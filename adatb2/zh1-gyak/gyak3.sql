select blocks from dba_segments
where owner = 'NIKOVITS'
and segment_name = 'CIKK'
and segment_type = 'TABLE';

select distinct
  dbms_rowid.rowid_relative_fno(ROWID) fajl,
  dbms_rowid.rowid_block_number(ROWID) blokk
from nikovits.cikk;

SELECT dbms_rowid.rowid_relative_fno(ROWID) fajl,
       dbms_rowid.rowid_block_number(ROWID) blokk,
       count(*)
FROM nikovits.dolgozo
group by
  dbms_rowid.rowid_relative_fno(ROWID),
  dbms_rowid.rowid_block_number(ROWID)
having count(*) > 10;

create or replace procedure beszur is
   v_blokkszam NUMBER := 0; -- nemüres blokkok száma 
   v_sorsz NUMBER := 1;
begin
  WHILE v_blokkszam < 2 AND v_sorsz < 1000 LOOP     
    INSERT INTO proba SELECT * FROM nikovits.cikk WHERE ckod=v_sorsz;
    
    v_sorsz := v_sorsz + 1;
    
    SELECT COUNT(
      DISTINCT dbms_rowid.rowid_relative_fno(ROWID)||
      dbms_rowid.rowid_block_number(ROWID)
    )
    INTO v_blokkszam
    FROM nikovits.proba;
  END LOOP;
  COMMIT;
end;
/

select 
  dbms_rowid.rowid_object(ROWID) adatobj,
  dbms_rowid.rowid_relative_fno(ROWID) fajl,
  dbms_rowid.rowid_block_number(ROWID) blokk,
  dbms_rowid.rowid_row_number(ROWID) sor
from sh.sales
where to_char(time_id, 'YYYY.MM.DD') = '1998.01.10'
and prod_id = 13
and cust_id = 2380;

select 
  o.object_name,
  o.subobject_name,
  o.object_type,
  o.data_object_id
from sh.sales s, dba_objects o
where dbms_rowid.rowid_object(s.ROWID) = o.data_object_id
and to_char(time_id, 'YYYY.MM.DD') = '1998.01.10'
and prod_id = 13
and cust_id = 2380;