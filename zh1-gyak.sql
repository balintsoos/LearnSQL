select * from nikovits.szeret;

SELECT username, account_status, expiry_date FROM DBA_USERS where username = 'HDX9MU';

SELECT dnev FROM nikovits.dolgozo WHERE fizetes > 2800;

select * from nikovits.dolgozo;

select fizetes, oazon from nikovits.dolgozo where oazon = 10;

select dnev from nikovits.dolgozo where fonoke is null;

select distinct gyumolcs from nikovits.szeret
minus
select gyumolcs from nikovits.szeret where nev = 'Micimackó';

select distinct nev from nikovits.szeret
minus
select nev from nikovits.szeret where gyumolcs = 'körte';

select nev from nikovits.szeret where gyumolcs = 'dinnye'
union
select nev from nikovits.szeret where gyumolcs = 'körte';

select distinct sz1.nev from nikovits.szeret sz1, nikovits.szeret sz2
where sz1.gyumolcs != sz2.gyumolcs and sz1.nev = sz2.nev;

select dnev from nikovits.dolgozo where SUBSTR(dnev, 2, 1) = 'A';

select dnev, SUBSTR(dnev, 1, 2) from nikovits.dolgozo;

select dnev, INSTR(dnev, 'A') from nikovits.dolgozo;

select dnev, SUBSTR(dnev, INSTR(dnev, 'A'), 1) from nikovits.dolgozo;

select dnev, INSTR(dnev, 'L', 1, 2) from nikovits.dolgozo;

select dnev, SUBSTR(dnev, -3, 2) from nikovits.dolgozo;

select MAX(fizetes) from nikovits.dolgozo;

select AVG(fizetes) from nikovits.dolgozo;

select MIN(fizetes) from nikovits.dolgozo;

select SUM(fizetes) from nikovits.dolgozo;

select COUNT(fizetes) from nikovits.dolgozo;

select COUNT(distinct foglalkozas) from nikovits.dolgozo;

select * from nikovits.osztaly;
select * from nikovits.dolgozo;

select onev, avg(fizetes)
from nikovits.dolgozo, nikovits.osztaly 
where nikovits.dolgozo.oazon = nikovits.osztaly.oazon
group by onev
having count(dkod) > 3
order by onev;

SELECT * FROM nikovits.dolgozo WHERE 'str ' = 'str';
SELECT count(dkod) FROM nikovits.dolgozo WHERE 'str ' = 'str';
SELECT * FROM nikovits.dolgozo WHERE CAST('str ' AS VARCHAR(4)) = 'str';

select * from nikovits.osztaly;
select * from nikovits.dolgozo;

select TO_CHAR(belepes, 'DAY'), count(dkod)
from nikovits.dolgozo
group by TO_CHAR(belepes, 'DAY')
having count(dkod) >= 3;


