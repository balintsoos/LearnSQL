select * from dual;
SELECT * FROM nikovits.dolgozo;


select dnev from nikovits.dolgozo where belepes > TO_Date('1982.01.01', 'YYYY.MM.DD');

select dnev from nikovits.dolgozo where SUBSTR(dnev, 2, 1) = 'A';
select dnev from nikovits.dolgozo where INSTR(dnev, 'A') = 2;

select dnev from nikovits.dolgozo where instr(dnev, 'L', 1, 2) > 0;

select SUBSTR(dnev, -3, 3) from nikovits.dolgozo;


select MAX(fizetes) from nikovits.dolgozo;

select SUM(fizetes) from nikovits.dolgozo;

select AVG(fizetes) from nikovits.dolgozo where oazon = 20;

select count(distinct foglalkozas) from nikovits.dolgozo;

