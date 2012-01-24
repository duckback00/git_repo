create or replace procedure hello as 
v_cnt   PLS_INTEGER; 
begin 
   select count(*) into v_cnt from all_objects; 
   --select sysdate from dual; 
   dbms_output.put_line('Hello from GIT ... '||v_cnt); 
end; 
/

