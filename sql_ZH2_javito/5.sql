-- 5.
-- Adjuk meg azokat a fizet�si kateg�ri�kat, amelyekbe beleesik legal�bb 3 olyan dolgozonak
-- a fizet�se, akinek nincs beosztottja. (kategoria)
-- --
-- 1
-- 2

select kategoria
from (
  select kategoria, count(*) db
  from 
    nikovits.fiz_kategoria, (
      select * from nikovits.dolgozo 
      where dkod not in (
        select NVL(fonoke, 0) from nikovits.dolgozo
      )
    )
  where 
    fizetes between also and felso
  group by kategoria
)
where db >= 3;