SZERET tábla

NEV         GYUMOLCS
--------------------
Malacka     alma
Micimackó   alma
Malacka     körte
Kanga       alma
Tigris      alma
Malacka     dinnye
Micimackó   körte
Tigris      körte

1.  Melyek azok a gyümölcsök, amelyeket Micimackó szeret?
2.  Melyek azok a gyümölcsök, amelyeket Micimackó nem szeret? (de valaki más igen)
3.  Kik szeretik az almát?
4.  Kik nem szeretik a körtét? (de valami mást igen)
5.  Kik szeretik vagy az almát vagy a körtét?
6.  Kik szeretik az almát is és a körtét is?
7.  Kik azok, akik szeretik az almát, de nem szeretik a körtét?
8.  Kik szeretnek legalább kétféle gyümölcsöt?
9.  Kik szeretnek legalább háromféle gyümölcsöt?
10. Kik szeretnek legfeljebb kétféle gyümölcsöt?
11. Kik szeretnek pontosan kétféle gyümölcsöt?
----------- eddig volt korábban, lásd feladat2.txt
12. Kik szeretnek minden gyümölcsöt?
13. Kik azok, akik legalább azokat a gyümölcsöket szeretik, mint Micimackó?
14. Kik azok, akik legfeljebb azokat a gyümölcsöket szeretik, mint Micimackó?
15. Kik azok, akik pontosan azokat a gyümölcsöket szeretik, mint Micimackó?
16. Melyek azok a (név,név) párok, akiknek legalább egy gyümölcsben eltér 
    az ízlésük, azaz az  egyik szereti ezt a gyümölcsöt, a másik meg nem?
17. Melyek azok a (név,név) párok, akiknek pontosan ugyanaz az ízlésük, azaz 
    pontosan  ugyanazokat a gyümölcsöket szeretik? 
18. SZERET(NEV, GYUMOLCS) tábla helyett EVETT(NEV, KG) legyen a relációséma 
    és azt tartalmazza, hogy ki mennyi gyümölcsöt evett összesen. 
    Ki ette a legtöbb gyümölcsöt? 


12. Kik szeretnek minden gyümölcsöt?
--  összes név minusz NemSzeret(Nev,Gyumolcs) nevei

SELECT nev FROM szeret 
 MINUS
SELECT DISTINCT nev FROM 
(SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2
  MINUS
 SELECT nev, gyumolcs FROM szeret) NemSz;

13. Kik azok, akik legalább azokat a gyümölcsöket szeretik, mint Micimackó?

SELECT nev FROM szeret 
 MINUS
SELECT DISTINCT nev FROM 
(SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2 where sz2.nev='Micimackó'
  MINUS
 SELECT nev, gyumolcs FROM szeret);

14. Kik azok, akik legfeljebb azokat a gyümölcsöket szeretik, mint Micimackó?
--  összes név minusz akik szeretnek olyat, amit Micimackó nem szeret

SELECT DISTINCT nev FROM szeret
 MINUS
SELECT DISTINCT sz.nev FROM szeret sz,
 (SELECT DISTINCT gyumolcs FROM szeret MINUS SELECT gyumolcs FROM szeret WHERE nev='Micimackó') MM_NSZ
WHERE sz.gyumolcs = mm_nsz.gyumolcs;

15. Kik azok, akik pontosan azokat a gyümölcsöket szeretik, mint Micimackó?
--  elõzõ kettõ metszete

(SELECT nev FROM szeret 
  MINUS
 SELECT DISTINCT nev FROM 
 (SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2 WHERE sz2.nev='Micimackó'
   MINUS
  SELECT nev, gyumolcs FROM szeret))
 INTERSECT
(SELECT DISTINCT nev FROM szeret
  MINUS
 SELECT DISTINCT sz.nev FROM szeret sz,
  (SELECT DISTINCT gyumolcs FROM szeret MINUS SELECT gyumolcs FROM szeret WHERE nev='Micimackó') MM_NSZ
 WHERE sz.gyumolcs = mm_nsz.gyumolcs);

16. Melyek azok a (név,név) párok, akiknek legalább egy gyümölcsben eltér 
    az ízlésük, azaz az  egyik szereti ezt a gyümölcsöt, a másik meg nem?
--  Szeret és NemSzeret direktszorzata, ebben azonos gyumolcs keresése
!!! Vigyázat, lehetnek párok, akik kétszer is szerepelnek -> A,B és B,A 
(van, amit A szeret, B nem és lehet olyan, amit B szeret, A nem)

SELECT DISTINCT sz.nev, nemSz.nev FROM szeret Sz,
 (SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2
   MINUS
  SELECT nev, gyumolcs FROM szeret) nemSz
WHERE sz.gyumolcs = nemSz.gyumolcs;

17. Melyek azok a (név,név) párok, akiknek pontosan ugyanaz az ízlésük, azaz 
    pontosan  ugyanazokat a gyümölcsöket szeretik? 
-- Az összes (név, név) párból kivonjuk az elõzõt. Az elõzõt úgy állítjuk elõ, hogy A,B és B,A is
-- benne legyen. (Mindkét irányú párok halmazát létrehozzuk, majd a kettõ unióját képezzük.)


18. SZERET(NEV, GYUMOLCS) tábla helyett EVETT(NEV, KG) legyen a relációséma 
    és azt tartalmazza, hogy ki mennyi gyümölcsöt evett összesen. 
    Ki ette a legtöbb gyümölcsöt? 
-- összes névbõl kivonjuk azokat, akiknél van nagyobb étvágyú