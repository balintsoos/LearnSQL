-- nyomozas
SELECT * FROM sz1;

select * from dba_objects
where object_name = 'SZ1';

select * from dba_synonyms
where synonym_name = 'SZ1';

select * from dba_objects
where object_name = 'V1';

select * from dba_views
where view_name = 'V1';
-- end nyomozas

select tablespace_name, count(*), sum(bytes)
from dba_data_files
group by tablespace_name;

--
select * from
  (select segment_name, bytes
  from dba_segments
  where owner='NIKOVITS' and segment_type='TABLE'
  order by bytes desc)
where rownum <= 1;

--
select segment_name from dba_extents
where owner = 'NIKOVITS' and segment_type = 'TABLE'
group by owner, segment_name, segment_type
having count(distinct file_id) > 1;

--
select * from dba_data_files;

--
select f.file_name, sum(e.bytes) 
from dba_extents e, dba_data_files f
where 
  owner = 'NIKOVITS' 
and 
  segment_type = 'TABLE'
and
  f.file_id = e.file_id
and
  segment_name = 'TABLA_123'
group by f.file_id, f.file_name;

-- 
select * from dba_data_files;
select * from dba_extents;

--
select 
  f.file_name,
  round(sum(e.bytes) / f.bytes, 2)
from 
  dba_extents e,
  dba_data_files f
where 
  f.file_id = e.file_id
group by 
  f.file_id,
  f.file_name,
  f.bytes;




