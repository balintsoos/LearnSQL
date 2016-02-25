SELECT dnev FROM nikovits.dolgozo WHERE fizetes > 2800;

SELECT DISTINCT foglalkozas FROM nikovits.dolgozo;

SELECT dnev, fizetes * 2 FROM nikovits.dolgozo where oazon = 10;

select dnev from nikovits.dolgozo where belepes > TO_Date('1982.01.01', 'YYYY.MM.DD');

select dnev from nikovits.dolgozo where fonoke is null;

select dnev from nikovits.dolgozo where fonoke = 7839;

select gyumolcs from nikovits.szeret where nev = 'Micimackó';

select distinct gyumolcs from nikovits.szeret
minus 
select gyumolcs from nikovits.szeret where nev = 'Micimackó';

select nev from nikovits.szeret where gyumolcs = 'alma';

select nev from nikovits.szeret
minus
select nev from nikovits.szeret where gyumolcs = 'körte';

select distinct nev from nikovits.szeret where gyumolcs = 'alma' or gyumolcs = 'körte';

select nev from nikovits.szeret where gyumolcs = 'alma'
union
select nev from nikovits.szeret where gyumolcs = 'körte';

select nev from nikovits.szeret where gyumolcs = 'alma'
intersect
select nev from nikovits.szeret where gyumolcs = 'körte';

select distinct sz1.nev from nikovits.szeret sz1, nikovits.szeret sz2
where sz1.gyumolcs != sz2.gyumolcs and sz1.nev = sz2.nev;

select distinct sz1.nev from nikovits.szeret sz1, nikovits.szeret sz2, nikovits.szeret sz3
where 
sz1.gyumolcs != sz2.gyumolcs and
sz1.gyumolcs != sz3.gyumolcs and 
sz2.gyumolcs != sz3.gyumolcs and
sz1.nev = sz2.nev and 
sz2.nev = sz3.nev;

select nev from nikovits.szeret
minus
select distinct sz1.nev from nikovits.szeret sz1, nikovits.szeret sz2, nikovits.szeret sz3
where 
sz1.gyumolcs != sz2.gyumolcs and
sz1.gyumolcs != sz3.gyumolcs and 
sz2.gyumolcs != sz3.gyumolcs and
sz1.nev = sz2.nev and 
sz2.nev = sz3.nev;
