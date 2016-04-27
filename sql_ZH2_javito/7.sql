-- 7.
-- Adjuk meg azokat a foglalkoz�sokat, amelyek csak egyetlen oszt�lyon fordulnak el�,
-- �s adjuk meg hozz�juk azt az oszt�lyt, ahol van ilyen foglalkoz�s� dolgoz� tov�bb�, 
-- hogy h�ny ilyen foglalkoz�s� van. (foglalkoz�s, on�v, f�)
-- -------------------------
-- SALESMAN   SALES       4
-- PRESIDENT  ACCOUNTING  1
-- ANALYST    RESEARCH    2

select
  d.foglalkozas,
  o.onev,
  count(d.dkod)
from 
  nikovits.dolgozo d,
  nikovits.osztaly o
where
  d.oazon = o.oazon and
  d.foglalkozas not in (
    select distinct d1.foglalkozas 
    from nikovits.dolgozo d1, nikovits.dolgozo d2
    where d1.oazon <> d2.oazon and d1.foglalkozas = d2.foglalkozas
  )
group by d.foglalkozas, o.onev;