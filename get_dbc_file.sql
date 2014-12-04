REM $Id: get_dbc_file.sql 1303 2011-05-19 14:08:08Z mshapira $
REM Copyright Unitask Inc., 1999-2011
set heading off
set verify off
set define off
set linesize 70
select fnd_profile.VALUE('APPS_DATABASE_ID') from dual
/
exit
