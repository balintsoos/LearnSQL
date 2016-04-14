A lek�rdez�sekhez haszn�lt t�bl�k:

NIKOVITS.SZERET        (nev, gyumolcs)
NIKOVITS.DOLGOZO       (dkod, dnev, foglalkozas, fonoke, belepes, fizetes, jutalek, oazon)
NIKOVITS.OSZTALY       (oazon, onev, telephely)
NIKOVITS.FIZ_KATEGORIA (kategoria, also, felso)

Adjuk meg, hogy kik szeretnek pontosan k�tf�le gy�m�lcs�t.
SELECT nev FROM szeret 
GROUP BY nev 
HAVING COUNT(gyumolcs) = 2;

Adjuk meg, hogy kik szeretnek minden gy�m�lcs�t.
-- annyi gy�m�lcs�t szeretnek, amennyi van
SELECT nev FROM szeret 
GROUP BY nev 
HAVING COUNT(gyumolcs) = (SELECT COUNT(DISTINCT gyumolcs) FROM szeret);

Adjuk meg oszt�lyonk�nt a legnagyobb fizet�su dolgoz�(ka)t, �s a fizet�st (oazon, dnev, fizetes).
SELECT d.oazon, d.dnev, d.fizetes 
FROM dolgozo d, (SELECT oazon, MAX(fizetes) maxfiz FROM dolgozo GROUP BY oazon) t
WHERE d.oazon=t.oazon AND d.fizetes=t.maxfiz;

Adjuk meg a f�n�k�k �tlagfizet�s�t eg�sz sz�mra kerek�tve.
SELECT ROUND(AVG(fizetes)) FROM dolgozo, (SELECT DISTINCT fonoke FROM dolgozo) f
WHERE dolgozo.dkod = f.fonoke;
-- m�sik megold�s
SELECT ROUND(AVG(fizetes)) FROM dolgozo 
WHERE dkod IN (SELECT fonoke FROM dolgozo);

Adjuk meg azoknak a dolgoz�knak az �tlagfizet�s�t, akiknek nincs beosztottja (akik nem f�n�k�k).
-- Vigy�zzunk a fonoke oszlopban el�fordul� NULL �rt�kkel !!!
SELECT ROUND(AVG(fizetes)) FROM dolgozo 
WHERE dkod NOT IN (SELECT NVL(fonoke, 0) FROM dolgozo);

Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek van 1-es fizet�si kateg�ri�j� dolgoz�ja.
-- egy kor�bbi megold�s
SELECT DISTINCT o.onev, telephely FROM dolgozo d, osztaly o, fiz_kategoria f
WHERE o.oazon=d.oazon AND d.fizetes BETWEEN f.also AND f.felso AND kategoria=1;
-- egy m�sik megold�s, amelyik seg�t a k�vetkez� feladatn�l
SELECT onev, telephely FROM osztaly
WHERE oazon IN 
  (SELECT oazon FROM dolgozo, fiz_kategoria 
   WHERE kategoria=1 AND fizetes BETWEEN also AND felso);

Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek nincs 1-es fizet�si kateg�ri�j� dolgoz�ja.
SELECT onev, telephely FROM osztaly
WHERE oazon NOT IN 
  (SELECT oazon FROM dolgozo, fiz_kategoria 
   WHERE kategoria=1 AND fizetes BETWEEN also AND felso);

Adjuk meg, hogy az egyes fizet�si kateg�ri�kba h�ny dolgoz� esik. (kateg�ria, f�)
SELECT kategoria, COUNT(*) FROM dolgozo, fiz_kategoria 
WHERE fizetes BETWEEN also AND felso
GROUP BY kategoria;

Adjuk meg, hogy melyik fizet�si kateg�ri�ba esik a legt�bb dolgoz�.
SELECT * FROM
 (SELECT kategoria, COUNT(*) darab FROM dolgozo, fiz_kategoria 
  WHERE fizetes BETWEEN also AND felso
  GROUP BY kategoria ORDER BY darab DESC)
WHERE ROWNUM <= 1;
-- m�sik megold�s, az �sszes�t� f�ggv�nyek egym�sba �gyaz�s�val
SELECT kategoria, COUNT(*) FROM dolgozo, fiz_kategoria 
WHERE fizetes BETWEEN also AND felso
GROUP BY kategoria HAVING COUNT(*) = 
  (SELECT MAX(COUNT(*)) FROM dolgozo, fiz_kategoria 
   WHERE fizetes BETWEEN also AND felso GROUP BY kategoria);



