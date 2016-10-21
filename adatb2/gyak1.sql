select * from nikovits.hivas;
select * from nikovits.kozpont;
select * from nikovits.primer;

-- futásidõ: 35 sec 
SELECT sum(darab) FROM nikovits.hivas, nikovits.kozpont, nikovits.primer
WHERE hivas.kozp_azon_hivo=kozpont.kozp_azon AND kozpont.primer=primer.korzet
AND primer.varos = 'Szentendre' 
AND datum + 1 = next_day(to_date('2012.01.31', 'yyyy.mm.dd'),'hétfõ');


-- futásidõ: 1 sec
SELECT sum(darab) FROM nikovits.hivas, nikovits.kozpont, nikovits.primer
WHERE hivas.kozp_azon_hivo=kozpont.kozp_azon AND kozpont.primer=primer.korzet
AND primer.varos = 'Szentendre' 
AND datum = next_day(to_date('2012.01.31', 'yyyy.mm.dd'),'hétfõ') - 1;

select table_name, num_rows from dba_tables
where owner = 'NIKOVITS' and upper(table_name) like 'C%';

select * from sys.dba_objects where object_name like 'DUAL';

select * from dba_synonyms where synonym_name like 'DUAL';