-- 1.
-- Adjuk meg a legrosszabbul keres� f�n�k fizet�s�t, �s fizet�si kateg�ri�j�t. (Fizet�s, Kateg�ria)
-- ------
-- 2450	4

select * from (
  select fizetes, kategoria 
  from 
    nikovits.fiz_kategoria, (
    select fizetes from nikovits.dolgozo
    where dkod in (
      select NVL(fonoke, 0) from nikovits.dolgozo
    )
  )
  where fizetes between also and felso
  order by fizetes
)
where rownum = 1;