select * from dba_objects;

select owner from dba_objects
where object_type = 'TABLE'
group by owner
having count(*) > 40;

select owner from dba_objects
where object_type = 'TABLE'
group by owner
having count(*) > 40
minus
select owner from dba_objects
where object_type = 'INDEX'
group by owner
having count(*) > 37;

select * from dba_tab_columns;

select owner, table_name from dba_tab_columns 
where data_type = 'DATE'
group by owner, table_name having count(*) >= 8;

describe sh.times;

select owner, table_name from dba_tables
where upper(table_name) like 'Z%';

create or replace procedure table_kiir(p_kar varchar2) is
  CURSOR curs1 IS
    select owner, table_name from dba_tables
    where upper(table_name) like upper(p_kar)||'%';
  rec curs1%ROWTYPE;
begin
  OPEN curs1;
  LOOP
    FETCH curs1 INTO rec;
    EXIT WHEN curs1%NOTFOUND;
    dbms_output.put_line(rec.owner||' - '||rec.table_name);
  END LOOP;
  CLOSE curs1;
end;
/

set serveroutput on
call table_kiir('z');

select * from nikovits.folyok;

