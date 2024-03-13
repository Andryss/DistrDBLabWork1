#!/usr/bin/bash

psql -h pg -d studs -f ~/create_functions.sql

psql -h pg -d studs -f ~/find_def_text.sql 2>&1 | sed 's|.*INFO:  ||g'