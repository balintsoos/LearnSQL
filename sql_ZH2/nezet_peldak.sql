N�zet t�bl�k (VIEW)

A lek�rdez�sekhez a NIKOVITS felhaszn�l� tulajdon�ban lev� t�bl�kat haszn�ljuk! 

NIKOVITS.DOLGOZO    (dkod, dnev, foglalkozas, fonoke, belepes, fizetes, jutalek, oazon)
NIKOVITS.OSZTALY    (oazon, onev, telephely)
NIKOVITS.CIKK       (ckod, cnev, szin, suly)
NIKOVITS.PROJEKT    (pkod, pnev, helyszin)
NIKOVITS.SZALLITO   (szkod, sznev, statusz, telephely)
NIKOVITS.SZALLIT    (szkod, ckod, pkod, mennyiseg, datum)


- Melyik cikket sz�ll�tj�k a legt�bb projekthez?
CREATE OR REPLACE VIEW cikk_proj_db
AS 
SELECT cikk.ckod ckod, cnev, COUNT(DISTINCT pkod) darab FROM cikk, szallit
WHERE cikk.ckod=szallit.ckod
GROUP BY cikk.ckod, cnev;

SELECT ckod, cnev FROM cikk_proj_db
WHERE darab = (SELECT MAX(darab) FROM cikk_proj_db);

A lek�rdez�s �gy is megadhat�, hogy ne kelljen n�zetet l�trehozni.
Az al�bbi lek�rdez�sben a "n�zet" csak a lek�rdez�s idej�re j�n l�tre.
Ezt �gy is h�vjuk, hogy INLINE n�zet.

SELECT ckod, cnev FROM
  (SELECT cikk.ckod ckod, cnev, COUNT(DISTINCT pkod) darab 
   FROM cikk, szallit
   WHERE cikk.ckod=szallit.ckod
   GROUP BY cikk.ckod, cnev) cikk_proj_db
WHERE darab = (SELECT MAX(darab) FROM 
                   (SELECT cikk.ckod ckod, cnev, COUNT(DISTINCT pkod) darab 
                    FROM cikk, szallit
                    WHERE cikk.ckod=szallit.ckod
                    GROUP BY cikk.ckod, cnev) 
               ) 
;

A fenti lek�rdez�sben k�tszer kellett le�rnunk ugyanazt a "n�zetet" -> cikk_proj_db
Ezt megsp�rolhatjuk az al�bbi szintaxissal. Most is csak a lek�rdez�s idej�re 
j�n l�tre a n�zet.

WITH 
  cikk_proj_db AS (
    SELECT cikk.ckod ckod, cnev, COUNT(DISTINCT pkod) darab 
    FROM cikk, szallit
    WHERE cikk.ckod=szallit.ckod
    GROUP BY cikk.ckod, cnev)
SELECT ckod, cnev FROM cikk_proj_db
WHERE darab = (SELECT MAX(darab) FROM cikk_proj_db);


K�pezz�k oszt�lyonk�nt az �sszfizet�st, vegy�k ezen sz�mok �tlag�t, �s adjuk 
meg, hogy mely oszt�lyokon nagyobb enn�l az �tlagn�l az �sszfizet�s.

CREATE OR REPLACE VIEW osztaly_osszfiz 
AS 
SELECT onev, SUM(fizetes) ossz_fiz
FROM dolgozo d, osztaly o
WHERE d.oazon = o.oazon
GROUP BY onev;

CREATE OR REPLACE VIEW atlag_koltseg 
AS
SELECT SUM(ossz_fiz)/COUNT(*) atlag
FROM osztaly_osszfiz;

SELECT * FROM osztaly_osszfiz
WHERE ossz_fiz  >  (SELECT atlag FROM atlag_koltseg)

Ugyanez WITH-del megadva:

WITH
  osztaly_osszfiz AS (
    SELECT onev, SUM(fizetes) ossz_fiz
    FROM dolgozo d, osztaly o
    WHERE d.oazon = o.oazon
    GROUP BY onev),
  atlag_koltseg AS (
    SELECT SUM(ossz_fiz)/COUNT(*) atlag
    FROM osztaly_osszfiz)
SELECT * FROM osztaly_osszfiz
WHERE ossz_fiz  >  (SELECT atlag FROM atlag_koltseg)



