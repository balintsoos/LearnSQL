create table szeret (nev VARCHAR2(10), gyumolcs VARCHAR2(10));

insert into szeret (nev, gyumolcs)
values ('Tigris', 'alma');

select * from nikovits.szeret;
select nev, gyumolcs from szeret;
select nev from szeret;
select distinct nev from szeret;

select gyumolcs from szeret 
where nev = 'Micimackó';

delete from szeret
where nev = 'Malacka';