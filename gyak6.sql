/*
A lekérdezésekhez használt táblák:

NIKOVITS.SZERET        (nev, gyumolcs)
NIKOVITS.DOLGOZO       (dkod, dnev, foglalkozas, fonoke, belepes, fizetes, jutalek, oazon)
NIKOVITS.OSZTALY       (oazon, onev, telephely)
NIKOVITS.FIZ_KATEGORIA (kategoria, also, felso)
*/

--Adjuk meg osztályonként a legnagyobb fizetésu dolgozó(ka)t, és a fizetést (oazon, dnev, fizetes).
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

--Adjuk meg, hogy kik szeretnek minden gyümölcsöt. (a korábbitól eltérõ megoldást adjunk)
--Adjuk meg azon osztályok nevét és telephelyét, amelyeknek van 1-es fizetési kategóriájú dolgozója.
--Adjuk meg azon osztályok nevét és telephelyét, amelyeknek nincs 1-es fizetési kategóriájú dolgozója.
--Adjuk meg azon osztályok nevét és telephelyét, amelyeknek két 1-es kategóriájú dolgozója van.