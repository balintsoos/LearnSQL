-- 3. feladat
select kategoria as "Kategória"
from
  (select kategoria, count(*) db
  from 
    nikovits.fiz_kategoria, 
    (select * from nikovits.dolgozo 
      where dkod not in 
      (select NVL(fonoke, 0) from nikovits.dolgozo))
  where 
    fizetes between also and felso
  group by kategoria)
where db >= 3;

-- Kategória
-- 1
-- 2

-- 6. feladat
select
  dnev as "Név",
  foglalkozas as "Foglalkozás"
from
  (select 
    dnev,
    foglalkozas,
    fizetes + NVL(jutalek, 0) jovedelem
  from nikovits.dolgozo
  where  
    oazon = 
    (select oazon from nikovits.osztaly
      where telephely = 'CHICAGO')
  order by jovedelem desc)
where rownum <= 3;

-- Név Foglalkozás
-- BLAKE	MANAGER
-- MARTIN	SALESMAN
-- ALLEN	SALESMAN

-- 4. feladat
drop table dolgozo2;
create table dolgozo2 as (select * from nikovits.dolgozo);
select * from dolgozo2;

(select oazon, AVG(fizetes) as fiz from dolgozo2
group by oazon);