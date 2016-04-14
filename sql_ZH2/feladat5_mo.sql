A lekérdezésekhez használt táblák:

NIKOVITS.SZERET        (nev, gyumolcs)
NIKOVITS.DOLGOZO       (dkod, dnev, foglalkozas, fonoke, belepes, fizetes, jutalek, oazon)
NIKOVITS.OSZTALY       (oazon, onev, telephely)
NIKOVITS.FIZ_KATEGORIA (kategoria, also, felso)

Adjuk meg, hogy kik szeretnek pontosan kétféle gyümölcsöt.
SELECT nev FROM szeret 
GROUP BY nev 
HAVING COUNT(gyumolcs) = 2;

Adjuk meg, hogy kik szeretnek minden gyümölcsöt.
-- annyi gyümölcsöt szeretnek, amennyi van
SELECT nev FROM szeret 
GROUP BY nev 
HAVING COUNT(gyumolcs) = (SELECT COUNT(DISTINCT gyumolcs) FROM szeret);

Adjuk meg osztályonként a legnagyobb fizetésu dolgozó(ka)t, és a fizetést (oazon, dnev, fizetes).
SELECT d.oazon, d.dnev, d.fizetes 
FROM dolgozo d, (SELECT oazon, MAX(fizetes) maxfiz FROM dolgozo GROUP BY oazon) t
WHERE d.oazon=t.oazon AND d.fizetes=t.maxfiz;

Adjuk meg a fõnökök átlagfizetését egész számra kerekítve.
SELECT ROUND(AVG(fizetes)) FROM dolgozo, (SELECT DISTINCT fonoke FROM dolgozo) f
WHERE dolgozo.dkod = f.fonoke;
-- másik megoldás
SELECT ROUND(AVG(fizetes)) FROM dolgozo 
WHERE dkod IN (SELECT fonoke FROM dolgozo);

Adjuk meg azoknak a dolgozóknak az átlagfizetését, akiknek nincs beosztottja (akik nem fõnökök).
-- Vigyázzunk a fonoke oszlopban elõforduló NULL értékkel !!!
SELECT ROUND(AVG(fizetes)) FROM dolgozo 
WHERE dkod NOT IN (SELECT NVL(fonoke, 0) FROM dolgozo);

Adjuk meg azon osztályok nevét és telephelyét, amelyeknek van 1-es fizetési kategóriájú dolgozója.
-- egy korábbi megoldás
SELECT DISTINCT o.onev, telephely FROM dolgozo d, osztaly o, fiz_kategoria f
WHERE o.oazon=d.oazon AND d.fizetes BETWEEN f.also AND f.felso AND kategoria=1;
-- egy másik megoldás, amelyik segít a következõ feladatnál
SELECT onev, telephely FROM osztaly
WHERE oazon IN 
  (SELECT oazon FROM dolgozo, fiz_kategoria 
   WHERE kategoria=1 AND fizetes BETWEEN also AND felso);

Adjuk meg azon osztályok nevét és telephelyét, amelyeknek nincs 1-es fizetési kategóriájú dolgozója.
SELECT onev, telephely FROM osztaly
WHERE oazon NOT IN 
  (SELECT oazon FROM dolgozo, fiz_kategoria 
   WHERE kategoria=1 AND fizetes BETWEEN also AND felso);

Adjuk meg, hogy az egyes fizetési kategóriákba hány dolgozó esik. (kategória, fõ)
SELECT kategoria, COUNT(*) FROM dolgozo, fiz_kategoria 
WHERE fizetes BETWEEN also AND felso
GROUP BY kategoria;

Adjuk meg, hogy melyik fizetési kategóriába esik a legtöbb dolgozó.
SELECT * FROM
 (SELECT kategoria, COUNT(*) darab FROM dolgozo, fiz_kategoria 
  WHERE fizetes BETWEEN also AND felso
  GROUP BY kategoria ORDER BY darab DESC)
WHERE ROWNUM <= 1;
-- másik megoldás, az összesítõ függvények egymásba ágyazásával
SELECT kategoria, COUNT(*) FROM dolgozo, fiz_kategoria 
WHERE fizetes BETWEEN also AND felso
GROUP BY kategoria HAVING COUNT(*) = 
  (SELECT MAX(COUNT(*)) FROM dolgozo, fiz_kategoria 
   WHERE fizetes BETWEEN also AND felso GROUP BY kategoria);



