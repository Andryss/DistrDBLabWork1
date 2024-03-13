\echo 'Схема: '
\prompt '' in_schema

\echo 'Текст запроса: '
\prompt '' in_text

call find_def_text(:'in_schema', :'in_text');