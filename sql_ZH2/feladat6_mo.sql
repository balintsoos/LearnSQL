Tov�bbi gyakorl� feladatok �jabb t�bl�kra:

NIKOVITS.CIKK       (ckod, cnev, szin, suly)
NIKOVITS.PROJEKT    (pkod, pnev, helyszin)
NIKOVITS.SZALLITO   (szkod, sznev, statusz, telephely)
NIKOVITS.SZALLIT    (szkod, ckod, pkod, mennyiseg, datum) 


Alk�rd�s (Subselect)  =ANY, <ALL, IN, EXISTS ...

- Adjuk meg azon cikkek k�dj�t �s nev�t, amelyeket valamelyik p�csi sz�ll�t� sz�ll�t.
SELECT ckod, cnev FROM cikk WHERE ckod IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg, hogy h�ny ilyen cikk van
SELECT COUNT(*) FROM cikk WHERE ckod IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg azon cikkek k�dj�t �s nev�t, amelyeket egyik p�csi sz�ll�t� sem sz�ll�t.
SELECT ckod, cnev FROM cikk WHERE ckod NOT IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg, hogy h�ny ilyen cikk van
SELECT COUNT(*) FROM cikk WHERE ckod NOT IN 
    (SELECT ckod FROM szallit, szallito WHERE szallit.szkod=szallito.szkod
     AND telephely='Pecs');

- Adjuk meg azon sz�ll�t�k nev�t, akik budapesti projektbe sz�ll�tanak sz�k nev� cikket.
SELECT DISTINCT sznev FROM cikk, szallit, projekt, szallito 
WHERE szallit.szkod=szallito.szkod AND telephely='Budapest'
AND cikk.ckod=szallit.ckod AND cnev='szek'
AND projekt.pkod=szallit.pkod AND helyszin='Budapest';

- Adjuk meg azon projektek k�dj�t, amelyekhez sz�ll�tanak k�k cikket.
SELECT DISTINCT pkod FROM cikk, szallit 
WHERE cikk.ckod=szallit.ckod AND szin='kek';

- Adjuk meg azon projektek k�dj�t �s nev�t, amelyekhez sz�ll�tanak k�k cikket.
SELECT DISTINCT pkod, pnev FROM projekt
WHERE pkod IN (SELECT DISTINCT pkod FROM cikk, szallit 
               WHERE cikk.ckod=szallit.ckod AND szin='kek');

- Adjuk meg azon projektek k�dj�t �s nev�t, amelyekhez nem sz�ll�tanak k�k cikket.
SELECT DISTINCT pkod, pnev FROM projekt
WHERE pkod NOT IN (SELECT DISTINCT pkod FROM cikk, szallit 
                   WHERE cikk.ckod=szallit.ckod AND szin='kek');

- Adjuk meg azon cikkek k�dj�t, amelyeket sz�ll�tanak valahova.
  Adjuk meg, hogy h�ny ilyen cikk van.
SELECT COUNT(DISTINCT CKOD) from szallit;

Adjuk meg azon cikkek k�dj�t, amelyeket nem sz�ll�tanak sehova.
SELECT ckod FROM cikk
 MINUS
SELECT ckod FROM szallit;

- Adjuk meg azon cikkek k�dj�t �s nev�t, amelyeket sehova nem sz�ll�tanak.
SELECT ckod, cnev FROM cikk WHERE NOT EXISTS 
   (SELECT * FROM szallit WHERE ckod=cikk.ckod); -- Min�s�t�s !!!

Vagy az el�z� feladatra visszavezetve:
SELECT ckod, cnev FROM cikk WHERE ckod IN
  (SELECT ckod FROM cikk
     MINUS
   SELECT ckod FROM szallit);

SELECT ckod, cnev FROM cikk WHERE ckod NOT IN
  (SELECT ckod FROM szallit);

- Adjuk meg azon k�k cikkek k�dj�t, amelyeket sz�ll�tanak valahova.
SELECT ckod FROM cikk where szin='kek' AND ckod IN 
  (SELECT ckod FROM szallit);

- Adjuk meg azon piros sz�n� cikkek k�dj�t, amelyeket sehova nem sz�ll�tanak.
SELECT ckod FROM cikk where szin='piros' AND ckod NOT IN 
  (SELECT ckod FROM szallit);

- Adjuk meg azon cikkek nev�t, amelyeket minden projekthez sz�ll�tanak.
SELECT cnev FROM cikk WHERE NOT EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

M�sik megk�zel�t�s:
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev
HAVING COUNT(DISTINCT pkod) = (SELECT COUNT(*) FROM projekt);

- Melyik cikket h�ny k�l�nb�z� projekthez sz�ll�tj�k? (ckod, cnev, darab)
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev

- Melyik cikket sz�ll�tj�k a legt�bb projekthez? (Leolvassuk a rendezett list�b�l)
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev
ORDER BY COUNT(DISTINCT pkod) DESC;  -- ORDER BY 3 DESC -et is �rhatn�nk

-- Leolvas�s n�lk�li megold�s ROWNUM seg�ts�g�vel
SELECT * FROM 
  (SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
   WHERE cikk.ckod=szallit.ckod
   GROUP BY cikk.ckod, cnev
   ORDER BY COUNT(DISTINCT pkod) DESC)
WHERE ROWNUM = 1;

-- m�g egy megold�s �sszes�t� f�ggv�nyek egym�sba �gyaz�s�val
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev HAVING COUNT(DISTINCT pkod) =
  (SELECT MAX(COUNT(DISTINCT pkod)) FROM cikk, szallit
   WHERE cikk.ckod=szallit.ckod
   GROUP BY cikk.ckod, cnev);

- Adjuk meg azon cikkek nev�t, amelyeket valamelyik projekthez nem sz�ll�tanak.
SELECT cnev FROM cikk WHERE EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon cikkek k�dj�t �s nev�t, amelyeket kevesebb mint 6 projekthez sz�ll�tanak.
SELECT cikk.ckod, cnev, COUNT(DISTINCT pkod) FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev
HAVING COUNT(DISTINCT pkod) < 6;

- Adjuk meg azon z�ld sz�n� cikkek nev�t, amelyeket minden projekthez sz�ll�tanak.
SELECT cnev FROM cikk WHERE szin='zold' AND NOT EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon z�ld sz�n� cikkek nev�t, amelyet valamelyik projekthez nem sz�ll�tanak.
SELECT cnev FROM cikk WHERE szin='zold' AND EXISTS 
  (SELECT * FROM projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon projektek nev�t, amelyekhez minden z�ld sz�n� cikket sz�ll�tanak.
SELECT pnev FROM projekt WHERE NOT EXISTS
  (SELECT * FROM cikk WHERE szin='zold' AND NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod));

- Adjuk meg azon sz�ll�t�k nev�t �s telephely�t, akik valamelyik cikket 
  (nem felt�tlen�l ugyanazt) minden projekthez sz�ll�tj�k.
SELECT sznev, telephely FROM szallito WHERE EXISTS
  (SELECT * FROM cikk WHERE NOT EXISTS
     (SELECT * FROM projekt WHERE NOT EXISTS
        (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod
         AND szallito.szkod=szallit.szkod)));

- Adjuk meg azon sz�ll�t�k nev�t �s telephely�t, akik valamelyik cikket 
  (nem felt�tlen�l ugyanazt) minden p�csi projekthez sz�ll�tj�k.
SELECT sznev, telephely FROM szallito WHERE EXISTS
  (SELECT * FROM cikk WHERE NOT EXISTS
     (SELECT * FROM projekt WHERE helyszin='Pecs' AND NOT EXISTS
        (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod
         AND szallito.szkod=szallit.szkod)));

- Adjuk meg azon sz�ll�t�k nev�t �s telephely�t, akik valamelyik k�k cikket 
  (nem felt�tlen�l ugyanazt) minden projekthez sz�ll�tj�k.
SELECT sznev, telephely FROM szallito WHERE EXISTS
  (SELECT * FROM cikk WHERE szin='kek' AND NOT EXISTS
     (SELECT * FROM projekt WHERE NOT EXISTS
        (SELECT * FROM szallit WHERE szallit.pkod=projekt.pkod AND szallit.ckod=cikk.ckod
         AND szallito.szkod=szallit.szkod)));

- Adjuk meg azon sz�ll�t�k nev�t, akik minden cikket sz�ll�tanak minden projekthez.
SELECT sznev FROM szallito WHERE NOT EXISTS
  (SELECT * FROM cikk, projekt WHERE NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.ckod=cikk.ckod
      AND szallit.szkod=szallito.szkod AND szallit.pkod=projekt.pkod));

- Adjuk meg azon sz�ll�t�k nev�t, akik minden kek cikket sz�ll�tanak minden projekthez.
SELECT sznev FROM szallito WHERE NOT EXISTS
  (SELECT * FROM cikk, projekt WHERE szin='kek' AND NOT EXISTS
     (SELECT * FROM szallit WHERE szallit.ckod=cikk.ckod
      AND szallit.szkod=szallito.szkod AND szallit.pkod=projekt.pkod));