\echo 'Схема: '
\prompt '' in_schema
\set p_schema '\'' :in_schema '\''

\echo 'Текст запроса: '
\prompt '' in_text
\set p_text '\'' :in_text '\''

call find_def_text(:p_schema::text, :p_text::text);