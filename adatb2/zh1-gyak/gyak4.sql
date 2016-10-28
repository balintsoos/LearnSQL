select * from dba_ind_columns
where descend = 'DESC'
and index_owner = 'NIKOVITS';

select * from dba_ind_expressions;
select * from dba_ind_columns;

select index_owner, index_name, count(*) from dba_ind_columns
group by index_owner, index_name
having count(*) >= 9;

select index_name from dba_indexes
where table_owner = 'SH'
and table_name = 'SALES'
and index_type = 'BITMAP';

SELECT index_owner, index_name FROM dba_ind_columns 
GROUP BY index_owner, index_name HAVING count(*) >=2
 INTERSECT
SELECT index_owner, index_name FROM dba_ind_expressions;

select * from dba_ind_expressions
where index_owner = 'OE';

select owner, table_name, iot_name, iot_type from dba_tables
where owner = 'NIKOVITS'
and iot_type = 'IOT';

select table_name, index_name, index_type, tablespace_name from dba_indexes
where table_owner = 'NIKOVITS'
and index_type like '%IOT%';

select o.object_name, o.data_object_id
from dba_indexes i, dba_segments s, dba_objects o
where i.table_owner = 'NIKOVITS'
and i.index_type like '%IOT%'
and i.index_name = s.segment_name
and s.owner = 'NIKOVITS'
and i.table_name = o.object_name;

select t.owner, t.table_name, t.iot_name, t.iot_type, s.bytes
from dba_tables t, dba_segments s
where t.iot_type like '%OVERFLOW%'
and t.owner = 'NIKOVITS'
and s.owner = 'NIKOVITS'
and s.segment_name = t.table_name;

select * from dba_tab_columns;

SELECT owner, table_name FROM dba_tables WHERE iot_type = 'IOT'
intersect
select owner, table_name from dba_tab_columns
where data_type = 'DATE'
group by owner, table_name
having count(*) = 1;

select * from dba_part_tables;

SELECT column_name, column_position FROM dba_part_key_columns 
WHERE owner='SH' AND name='COSTS' AND object_type='TABLE';

SELECT owner, segment_name, SUM(bytes) FROM dba_segments 
WHERE segment_type LIKE 'TABLE%PARTITION'
GROUP BY owner, segment_name
ORDER BY SUM(bytes) DESC;

select owner, cluster_name from dba_clusters
minus
select owner, cluster_name from dba_tables;

select owner, cluster_name from dba_tables
where cluster_name is not null
group by owner, cluster_name
having count(*) >= 6;

