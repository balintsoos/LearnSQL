-- 6.
-- Adjuk meg a CHICAGO-i telephely� oszt�ly 3 legnagyobb j�vedelm� dolgoz�j�nak
-- (j�vedelem: fizet�s + jutal�k, ahol a NULL jutal�k 0-nak sz�m�t) nev�t �s foglalkoz�s�t.
-- (n�v, foglalkoz�s)
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