-- 4.
-- Adjuk meg, hogy (kerekítve) hány hónapja dolgoznak a cégnél azok a dolgozók, akiknek a DALLAS-i
-- telephelyû osztályon a legnagyobb a fizetésük.
-- (Dnev, Hónapok)
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