-- поиск по объявлению функций, процедур, триггеров
create or replace procedure find_def_text(p_schema text, p_text text)
    language plpgsql
as $$
    declare schema_oid oid; p_schema_split text[]; obj_name text; obj_oid oid; obj_lines text[]; obj_line text; res_num int = 1;
    begin
        select trim(p_schema), trim(p_text) into p_schema, p_text;

        if p_schema like '%.%' then
            select regexp_split_to_array(p_schema, '\.') into p_schema_split;
            if array_length(p_schema_split, 1) > 2 then
                raise exception 'Incorrect scheme format, correct dbName.schemaName or schemaName';
            end if;
            if p_schema_split[1] != current_database() then
                raise exception 'Unknown dbName ''%''', p_schema_split[1];
            end if;
            select oid from pg_namespace where nspname = p_schema_split[2] into schema_oid;
        else
            select oid from pg_namespace where nspname = p_schema into schema_oid;
        end if;

        if schema_oid is null then
            raise exception 'Schema ''%'' does not exist', p_schema;
        end if;

        select btrim(p_text) into p_text;
        if p_text is null or p_text = '' then
            raise exception 'Search text must be neither null nor blank';
        end if;

        raise info 'No. Имя объекта           # строки       Текст';
        raise info '--- -------------------   -------------  --------------------------------------------';

        for obj_oid, obj_name in
            select oid, proname from pg_proc where pronamespace = schema_oid
        loop
            select regexp_split_to_array(pg_get_functiondef(obj_oid), '\n') into obj_lines;
            for i in 1 .. array_upper(obj_lines, 1)
            loop
                select btrim(obj_lines[i]) into obj_line;
                if lower(obj_line) like '%' || lower(p_text) || '%' then
                    raise info '% % % %', rpad(res_num::text, 4, ' '), rpad(obj_name, 20, ' '), rpad(i::text, 14, ' '), obj_line;
                    select res_num + 1 into res_num;
                end if;
            end loop;
        end loop;

        for obj_oid, obj_name in
            select pt.oid, pt.tgname from pg_trigger pt join pg_class pc on pt.tgrelid = pc.oid where pc.relnamespace = schema_oid
        loop
            select regexp_split_to_array(pg_get_triggerdef(obj_oid), '\n') into obj_lines;
            for i in 1 .. array_upper(obj_lines, 1)
            loop
                select btrim(obj_lines[i]) into obj_line;
                if lower(obj_line) like '%' || lower(p_text) || '%' then
                    raise info '% % % %', rpad(res_num::text, 4, ' '), rpad(obj_name, 20, ' '), rpad(i::text, 14, ' '), obj_line;
                    select res_num + 1 into res_num;
                end if;
            end loop;
        end loop;
    end
$$;
