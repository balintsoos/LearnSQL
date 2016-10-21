CREATE DATABASE LINK aramis CONNECT TO hdx9mu IDENTIFIED BY hdx9mu
USING 'aramis';

DROP DATABASE LINK aramis;

select * from nikovits.vilag_orszagai;
select * from nikovits.folyok@aramis;

select o.nev, f.nev, f.orszagok
from 
  nikovits.folyok@aramis f,
  nikovits.vilag_orszagai o
where 
  upper(f.nev) like '%NILUS%'
and 
  f.orszagok like '%' || o.tld || '%';

select * from dba_data_files;

select tablespace_name, count(*), sum(bytes)
from dba_data_files
group by tablespace_name;