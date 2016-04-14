További gyakorló feladatok újabb táblákra:

NIKOVITS.CIKK       (ckod, cnev, szin, suly)
NIKOVITS.PROJEKT    (pkod, pnev, helyszin)
NIKOVITS.SZALLITO   (szkod, sznev, statusz, telephely)
NIKOVITS.SZALLIT    (szkod, ckod, pkod, mennyiseg, datum) 


Alkérdés (Subselect)  =ANY, <ALL, IN, EXISTS ...

- Adjuk meg azon cikkek kódját és nevét, amelyeket valamelyik pécsi szállító szállít.
SELECT ckod, cnev FROM cikk WHERE ckod IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg, hogy hány ilyen cikk van
SELECT COUNT(*) FROM cikk WHERE ckod IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg azon cikkek kódját és nevét, amelyeket egyik pécsi szállító sem szállít.
SELECT ckod, cnev FROM cikk WHERE ckod NOT IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg, hogy hány ilyen cikk van
SELECT COUNT(*) FROM cikk WHERE ckod NOT IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg azon szállítók nevét, akik budapesti projektbe szállítanak szék nevû cikket.
SELECT DISTINCT sznev FROM cikk, szallit, projekt, szallito 
WHERE szallit.szkod=szallito.szkod AND telephely='Budapest'
AND cikk.ckod=szallit.ckod AND cnev='szek'
AND projekt.pkod=szallit.pkod AND helyszin='Budapest';

- Adjuk meg azon projektek kódját, amelyekhez szállítanak kék cikket.
SELECT DISTINCT pkod FROM cikk, szallit 
WHERE cikk.ckod=szallit.ckod AND szin='kek';

- Adjuk meg azon projektek kódját és nevét, amelyekhez szállítanak kék cikket.
SELECT DISTINCT pkod, pnev FROM projekt
WHERE pkod IN (SELECT DISTINCT pkod FROM cikk, szallit 
               WHERE cikk.ckod=szallit.ckod AND szin='kek');

- Adjuk meg azon projektek kódját és nevét, amelyekhez nem szállítanak kék cikket.
SELECT DISTINCT pkod, pnev FROM projekt
WHERE pkod NOT IN (SELECT DISTINCT pkod FROM cikk, szallit 
                   WHERE cikk.ckod=szallit.ckod AND szin='kek');

- Adjuk meg azon cikkek kódját, amelyeket szállítanak valahova.
  Adjuk meg, hogy hány ilyen cikk van.
SELECT COUNT(DISTINCT CKOD) from szallit;

Adjuk meg azon cikkek kódját, amelyeket nem szállítanak sehova.
SELECT ckod FROM cikk
 MINUS
SELECT ckod FROM szallit;

- Adjuk meg azon cikkek kódját és nevét, amelyeket sehova nem szállítanak.
SELECT ckod, cnev FROM cikk WHERE NOT EXISTS 
   (SELECT * FROM szallit WHERE ckod=cikk.ckod); -- Minõsítés !!!

Vagy az elõzõ feladatra visszavezetve:
SELECT ckod, cnev FROM cikk WHERE ckod IN
  (SELECT ckod FROM cikk
     MINUS
   SELECT ckod FROM szallit);

SELECT ckod, cnev FROM cikk WHERE ckod NOT IN
  (SELECT ckod FROM szallit);

- Adjuk meg azon kék cikkek kódját, amelyeket szállítanak valahova.
SELECT ckod FROM cikk where szin='kek' AND ckod IN 
  (SELECT ckod FROM szallit);

- Adjuk meg azon piros színû cikkek kódját, amelyeket sehova nem szállítanak.
SELECT ckod FROM cikk where szin='piros' AND ckod NOT IN 
  (SELECT ckod FROM szallit);

- Adjuk meg azon cikkek nevét, amelyeket minden projekthez szállítanak.
SELECT cnev FROM cikk WHERE NOT EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

Másik megközelítés:
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev
HAVING COUNT(DISTINCT pkod) = (SELECT COUNT(*) FROM projekt);

- Melyik cikket hány különbözõ projekthez szállítják? (ckod, cnev, darab)
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev

- Melyik cikket szállítják a legtöbb projekthez? (Leolvassuk a rendezett listából)
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev
ORDER BY COUNT(DISTINCT pkod) DESC;  -- ORDER BY 3 DESC -et is írhatnánk

-- Leolvasás nélküli megoldás ROWNUM segítségével
SELECT * FROM 
  (SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
   WHERE cikk.ckod=szallit.ckod
   GROUP BY cikk.ckod, cnev
   ORDER BY COUNT(DISTINCT pkod) DESC)
WHERE ROWNUM = 1;

-- még egy megoldás összesítõ függvények egymásba ágyazásával
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev HAVING COUNT(DISTINCT pkod) =
  (SELECT MAX(COUNT(DISTINCT pkod)) FROM cikk, szallit
   WHERE cikk.ckod=szallit.ckod
   GROUP BY cikk.ckod, cnev);

- Adjuk meg azon cikkek nevét, amelyeket valamelyik projekthez nem szállítanak.
SELECT cnev FROM cikk WHERE EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon cikkek kódját és nevét, amelyeket kevesebb mint 6 projekthez szállítanak.
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev
HAVING COUNT(DISTINCT pkod) < 6;

- Adjuk meg azon zöld színû cikkek nevét, amelyeket minden projekthez szállítanak.
SELECT cnev FROM cikk WHERE szin='zold' AND NOT EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon zöld színû cikkek nevét, amelyet valamelyik projekthez nem szállítanak.
SELECT cnev FROM cikk WHERE szin='zold' AND EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon projektek nevét, amelyekhez minden zöld színû cikket szállítanak.
SELECT pnev FROM projekt WHERE NOT EXISTS
  (SELECT * FROM cikk WHERE szin='zold' AND NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon szállítók nevét és telephelyét, akik valamelyik cikket 
  (nem feltétlenül ugyanazt) minden projekthez szállítják.
SELECT sznev, telephely FROM szallito WHERE EXISTS
  (SELECT * FROM cikk WHERE NOT EXISTS
     (SELECT * FROM projekt WHERE NOT EXISTS
        (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod
         AND szallito.szkod=szallit.szkod)));

- Adjuk meg azon szállítók nevét és telephelyét, akik valamelyik cikket 
  (nem feltétlenül ugyanazt) minden pécsi projekthez szállítják.
SELECT sznev, telephely FROM szallito WHERE EXISTS
  (SELECT * FROM cikk WHERE NOT EXISTS
     (SELECT * FROM projekt WHERE helyszin='Pecs' AND NOT EXISTS
        (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod
         AND szallito.szkod=szallit.szkod)));

- Adjuk meg azon szállítók nevét és telephelyét, akik valamelyik kék cikket 
  (nem feltétlenül ugyanazt) minden projekthez szállítják.
SELECT sznev, telephely FROM szallito WHERE EXISTS
  (SELECT * FROM cikk WHERE szin='kek' AND NOT EXISTS
     (SELECT * FROM projekt WHERE NOT EXISTS
        (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod
         AND szallito.szkod=szallit.szkod)));

- Adjuk meg azon szállítók nevét, akik minden cikket szállítanak minden projekthez.
SELECT sznev FROM szallito WHERE NOT EXISTS
  (SELECT * FROM cikk, projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.ckod=cikk.ckod
      AND szallit.szkod=szallito.szkod AND szallit.pkod=projekt.pkod));

- Adjuk meg azon szállítók nevét, akik minden kek cikket szállítanak minden projekthez.
SELECT sznev FROM szallito WHERE NOT EXISTS
  (SELECT * FROM cikk, projekt WHERE szin='kek' AND NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.ckod=cikk.ckod
      AND szallit.szkod=szallito.szkod AND szallit.pkod=projekt.pkod));