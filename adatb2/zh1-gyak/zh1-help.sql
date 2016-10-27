SELECT table_name FROM dba_tables WHERE owner='HR';

select * from dba_tables;

select column_id, column_name, data_type, data_length from dba_tab_columns
where table_name = 'SZERET'
and owner = 'NIKOVITS';

select object_name, object_type from dba_objects
where owner = 'NIKOVITS';

select segment_name, segment_type, extents, blocks, bytes from dba_segments
where owner = 'NIKOVITS';

select file_id, file_name, bytes, blocks from dba_data_files;

select segment_name, segment_type, file_id, block_id, blocks
from dba_extents
where owner = 'NIKOVITS'
and segment_name = 'TABLA_123';

select object_name, object_type, object_id, data_object_id from dba_objects
where data_object_id is null
and owner = 'NIKOVITS';

select tablespace_name, status, block_size, contents from dba_tablespaces;


select owner, object_name, object_type
from dba_objects,
(select dnev, 
  dbms_rowid.rowid_object(ROWID) adatobj,
  dbms_rowid.rowid_relative_fno(ROWID) fajl,
  dbms_rowid.rowid_block_number(ROWID) blokk,
  dbms_rowid.rowid_row_number(ROWID) sor
  from nikovits.dolgozo
  where dnev = 'KING'
)
where data_object_id = adatobj;

select *
from dba_data_files,
(select dnev, 
  dbms_rowid.rowid_object(ROWID) adatobj,
  dbms_rowid.rowid_relative_fno(ROWID) fajl,
  dbms_rowid.rowid_block_number(ROWID) blokk,
  dbms_rowid.rowid_row_number(ROWID) sor
  from nikovits.dolgozo
  where dnev = 'KING'
)
where file_id = fajl;

