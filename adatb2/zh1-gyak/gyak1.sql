select owner from dba_objects
where object_type = 'VIEW' and object_name = 'DBA_TABLES';

select owner from dba_objects
where object_type = 'TABLE' and object_name = 'DUAL';

select * from dba_objects;

select distinct object_type from dba_objects
where owner = 'ORAUSER';

SELECT * FROM dba_objects WHERE object_name = 'DBA_TABLES' AND object_type = 'SYNONYM';
SELECT * FROM dba_objects WHERE object_name = 'DUAL' AND object_type = 'SYNONYM';

select count(distinct object_type) from dba_objects;
select object_type, count(*) from dba_objects
group by object_type;

select distinct owner from dba_objects
where object_type = 'TRIGGER'
intersect
select distinct owner from dba_objects
where object_type = 'VIEW';

select * from dba_tab_columns
where owner = 'NIKOVITS' and table_name = 'EMP';

select * from dba_tab_columns
where owner = 'NIKOVITS'
and table_name = 'EMP'
and column_id = 6;

describe sh.times;

select * from dba_tables;

create or replace procedure tabla_kiiro(p_kar VARCHAR2) is
begin
  for v_tables in (
    select owner, table_name from dba_tables
    where table_name like upper(p_kar) || '%'
  ) loop
    dbms_output.put_line('Owner: ' || v_tables.owner || ' , Table name: ' || v_tables.table_name);
  end loop;
end;
/

set serveroutput on;
call tabla_kiiro('SZE');

CREATE OR REPLACE PROCEDURE cr_tab(p_owner VARCHAR2, p_tabla VARCHAR2) IS
  v_out VARCHAR2(400);
BEGIN
   v_out := v_out || 'CREATE TABLE ' || p_tabla || '(';
   FOR v_table IN (SELECT * FROM dba_tab_columns WHERE owner = upper(p_owner) AND table_name = upper(p_tabla)) LOOP
     v_out := v_out || lower(v_table.column_name) || ' ' || v_table.data_type || '(' || v_table.data_length || ')';
     IF v_table.data_default IS NOT NULL THEN
      v_out := v_out || ' DEFAULT ' || v_table.data_default;
     END IF;
     v_out := v_out || ', ';
   END LOOP;
   dbms_output.put_line(RTRIM(v_out, ', ') || ');');
END;
/

