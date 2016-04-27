-- 4.
-- Adjuk meg, hogy (kerek�tve) h�ny h�napja dolgoznak a c�gn�l azok a dolgoz�k, akiknek a DALLAS-i
-- telephely� oszt�lyon a legnagyobb a fizet�s�k.
-- (Dnev, H�napok)
-- -----------
-- FORD   413
-- SCOTT  400

select
  dnev,
  round(months_between(sysdate, belepes))
from 
  nikovits.dolgozo d,
  nikovits.osztaly o
where
  d.oazon = o.oazon and
  o.telephely = 'DALLAS' and 
  d.fizetes >= all (
    select fizetes 
    from nikovits.dolgozo d, nikovits.osztaly o
    where 
      d.oazon = o.oazon and
      o.telephely = 'DALLAS'
  );