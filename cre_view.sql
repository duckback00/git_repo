REM $Id: cre_view.sql 523 2007-12-12 14:11:34Z mshapira $
REM Copyright  1998-2007, Unitask, Inc., All rights reserved.
set feedback off
set serverout off
set termout off
set term off
set verify off
set pau off
set pages 0
SET LONGCHUNKSIZE 2400
set linesize 2400
set long 1000000
set head off
set echo off
WHENEVER SQLERROR EXIT


spool &3

select dbms_metadata.get_ddl('VIEW','&1','&2') from dual
/
prompt /
prompt exit
spool off
exit
