select table_name, num_rows from all_tables;

select * from dba_synonyms where synonym_name like 'DUAL';

CREATE DATABASE LINK aramis CONNECT TO hdx9mu IDENTIFIED BY hdx9mu
USING 'aramis';

DROP DATABASE LINK aramis;

select * from user_db_links;
select * from nikovits.vilag_orszagai;
select * from nikovits.folyok;
select * from nikovits.folyok@aramis;

