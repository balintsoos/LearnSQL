-- 2.
-- N�velj�k meg azoknak a dolgoz�knak a fizet�s�t, akiknek nincs beosztottja, 
-- a saj�t f�n�k�k fizet�s�nek egyharmad�val.
-- A m�dos�t�s ut�n adjuk meg azoknak a fizet�s�t, akiknek nincs beosztottja. (n�v, fizet�s)
-- --------------
-- TURNER	2916,33
-- WARD	2666,33
-- MARTIN	2666,33
-- ALLEN	3016,33
-- MILLER	2116,67
-- SMITH	1799,67
-- ADAMS	2099,67
-- JAMES	2366,33

drop table dolgozo2;
create table dolgozo2 as (select * from nikovits.dolgozo);

update dolgozo2 d1 
set d1.fizetes = d1.fizetes + (
  select fizetes from dolgozo2 d2 where d2.dkod = d1.fonoke
) / 3
where d1.dkod not in (
  select NVL(fonoke, 0) from dolgozo2
);

select dnev, fizetes
from dolgozo2 
where dkod not in (
  select NVL(fonoke, 0) from dolgozo2
);