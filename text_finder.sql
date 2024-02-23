create or replace procedure find_text(p_schema text, p_text text)
    language plpgsql
as $$
    declare schema_oid oid; obj_name text; obj_lines text[]; obj_line text; res_num int = 1;
    begin
        -- check privileges?
        select oid from pg_namespace where nspname = p_schema into schema_oid;
        if schema_oid is null then
            raise exception 'Schema % does not exist', p_schema;
        end if;

        raise notice 'Схема: %', p_schema;
        raise notice 'Текст запроса: %', p_text;
        raise notice 'No. Имя объекта           # строки       Текст';
        raise notice '--- -------------------   -------------  --------------------------------------------';

        for obj_name in
            select proname from pg_proc where pronamespace = schema_oid
        loop
            select regexp_split_to_array(prosrc, '\n') from pg_proc where proname = obj_name into obj_lines;
            for i in 1 .. array_upper(obj_lines, 1)
            loop
                select btrim(obj_lines[i]) into obj_line;
                if lower(obj_line) like '%' || lower(p_text) || '%' then
                    raise notice '% % % %', rpad(res_num::text, 4, ' '), rpad(obj_name, 20, ' '), rpad(i::text, 14, ' '), obj_line;
                    select res_num + 1 into res_num;
                end if;
            end loop;
        end loop;
    end
$$;
