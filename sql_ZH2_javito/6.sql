-- 6.
-- Adjuk meg a CHICAGO-i telephelyû osztály 3 legnagyobb jövedelmû dolgozójának
-- (jövedelem: fizetés + jutalék, ahol a NULL jutalék 0-nak számít) nevét és foglalkozását.
-- (név, foglalkozás)
-- ----------------
-- BLAKE	MANAGER
-- MARTIN	SALESMAN
-- ALLEN	SALESMAN

select
  dnev,
  foglalkozas
from (
  select 
    dnev,
    foglalkozas,
    fizetes + NVL(jutalek, 0) jovedelem
  from nikovits.dolgozo
  where  
    oazon = (
      select oazon from nikovits.osztaly
      where telephely = 'CHICAGO'
    )
  order by jovedelem desc
)
where rownum <= 3;