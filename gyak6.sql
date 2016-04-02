/*
A lek�rdez�sekhez haszn�lt t�bl�k:

NIKOVITS.SZERET        (nev, gyumolcs)
NIKOVITS.DOLGOZO       (dkod, dnev, foglalkozas, fonoke, belepes, fizetes, jutalek, oazon)
NIKOVITS.OSZTALY       (oazon, onev, telephely)
NIKOVITS.FIZ_KATEGORIA (kategoria, also, felso)
*/

--Adjuk meg oszt�lyonk�nt a legnagyobb fizet�su dolgoz�(ka)t, �s a fizet�st (oazon, dnev, fizetes).
select 
  d.oazon,
  d.dnev,
  d.fizetes
from 
  nikovits.dolgozo d, 
  (select oazon, max(fizetes) maxfiz from nikovits.dolgozo group by oazon) t
where 
  d.oazon = t.oazon 
  and 
  d.fizetes = t.maxfiz;

--Adjuk meg, hogy kik szeretnek minden gy�m�lcs�t. (a kor�bbit�l elt�r� megold�st adjunk)
--Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek van 1-es fizet�si kateg�ri�j� dolgoz�ja.
--Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek nincs 1-es fizet�si kateg�ri�j� dolgoz�ja.
--Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek k�t 1-es kateg�ri�j� dolgoz�ja van.