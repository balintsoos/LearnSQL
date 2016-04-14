SZERET t�bla

NEV         GYUMOLCS
--------------------
Malacka     alma
Micimack�   alma
Malacka     k�rte
Kanga       alma
Tigris      alma
Malacka     dinnye
Micimack�   k�rte
Tigris      k�rte

1.  Melyek azok a gy�m�lcs�k, amelyeket Micimack� szeret?
2.  Melyek azok a gy�m�lcs�k, amelyeket Micimack� nem szeret? (de valaki m�s igen)
3.  Kik szeretik az alm�t?
4.  Kik nem szeretik a k�rt�t? (de valami m�st igen)
5.  Kik szeretik vagy az alm�t vagy a k�rt�t?
6.  Kik szeretik az alm�t is �s a k�rt�t is?
7.  Kik azok, akik szeretik az alm�t, de nem szeretik a k�rt�t?
8.  Kik szeretnek legal�bb k�tf�le gy�m�lcs�t?
9.  Kik szeretnek legal�bb h�romf�le gy�m�lcs�t?
10. Kik szeretnek legfeljebb k�tf�le gy�m�lcs�t?
11. Kik szeretnek pontosan k�tf�le gy�m�lcs�t?
----------- eddig volt kor�bban, l�sd feladat2.txt
12. Kik szeretnek minden gy�m�lcs�t?
13. Kik azok, akik legal�bb azokat a gy�m�lcs�ket szeretik, mint Micimack�?
14. Kik azok, akik legfeljebb azokat a gy�m�lcs�ket szeretik, mint Micimack�?
15. Kik azok, akik pontosan azokat a gy�m�lcs�ket szeretik, mint Micimack�?
16. Melyek azok a (n�v,n�v) p�rok, akiknek legal�bb egy gy�m�lcsben elt�r 
    az �zl�s�k, azaz az  egyik szereti ezt a gy�m�lcs�t, a m�sik meg nem?
17. Melyek azok a (n�v,n�v) p�rok, akiknek pontosan ugyanaz az �zl�s�k, azaz 
    pontosan  ugyanazokat a gy�m�lcs�ket szeretik? 
18. SZERET(NEV, GYUMOLCS) t�bla helyett EVETT(NEV, KG) legyen a rel�ci�s�ma 
    �s azt tartalmazza, hogy ki mennyi gy�m�lcs�t evett �sszesen. 
    Ki ette a legt�bb gy�m�lcs�t? 


12. Kik szeretnek minden gy�m�lcs�t?
--  �sszes n�v minusz NemSzeret(Nev,Gyumolcs) nevei

SELECT nev FROM szeret 
 MINUS
SELECT DISTINCT nev FROM 
(SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2
  MINUS
 SELECT nev, gyumolcs FROM szeret) NemSz;

13. Kik azok, akik legal�bb azokat a gy�m�lcs�ket szeretik, mint Micimack�?

SELECT nev FROM szeret 
 MINUS
SELECT DISTINCT nev FROM 
(SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2 where sz2.nev='Micimack�'
  MINUS
 SELECT nev, gyumolcs FROM szeret);

14. Kik azok, akik legfeljebb azokat a gy�m�lcs�ket szeretik, mint Micimack�?
--  �sszes n�v minusz akik szeretnek olyat, amit Micimack� nem szeret

SELECT DISTINCT nev FROM szeret
 MINUS
SELECT DISTINCT sz.nev FROM szeret sz,
 (SELECT DISTINCT gyumolcs FROM szeret MINUS SELECT gyumolcs FROM szeret WHERE nev='Micimack�') MM_NSZ
WHERE sz.gyumolcs = mm_nsz.gyumolcs;

15. Kik azok, akik pontosan azokat a gy�m�lcs�ket szeretik, mint Micimack�?
--  el�z� kett� metszete

(SELECT nev FROM szeret 
  MINUS
 SELECT DISTINCT nev FROM 
 (SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2 WHERE sz2.nev='Micimack�'
   MINUS
  SELECT nev, gyumolcs FROM szeret))
 INTERSECT
(SELECT DISTINCT nev FROM szeret
  MINUS
 SELECT DISTINCT sz.nev FROM szeret sz,
  (SELECT DISTINCT gyumolcs FROM szeret MINUS SELECT gyumolcs FROM szeret WHERE nev='Micimack�') MM_NSZ
 WHERE sz.gyumolcs = mm_nsz.gyumolcs);

16. Melyek azok a (n�v,n�v) p�rok, akiknek legal�bb egy gy�m�lcsben elt�r 
    az �zl�s�k, azaz az  egyik szereti ezt a gy�m�lcs�t, a m�sik meg nem?
--  Szeret �s NemSzeret direktszorzata, ebben azonos gyumolcs keres�se
!!! Vigy�zat, lehetnek p�rok, akik k�tszer is szerepelnek -> A,B �s B,A 
(van, amit A szeret, B nem �s lehet olyan, amit B szeret, A nem)

SELECT DISTINCT sz.nev, nemSz.nev FROM szeret Sz,
 (SELECT DISTINCT sz1.nev, sz2.gyumolcs FROM szeret sz1, szeret sz2
   MINUS
  SELECT nev, gyumolcs FROM szeret) nemSz
WHERE sz.gyumolcs = nemSz.gyumolcs;

17. Melyek azok a (n�v,n�v) p�rok, akiknek pontosan ugyanaz az �zl�s�k, azaz 
    pontosan  ugyanazokat a gy�m�lcs�ket szeretik? 
-- Az �sszes (n�v, n�v) p�rb�l kivonjuk az el�z�t. Az el�z�t �gy �ll�tjuk el�, hogy A,B �s B,A is
-- benne legyen. (Mindk�t ir�ny� p�rok halmaz�t l�trehozzuk, majd a kett� uni�j�t k�pezz�k.)


18. SZERET(NEV, GYUMOLCS) t�bla helyett EVETT(NEV, KG) legyen a rel�ci�s�ma 
    �s azt tartalmazza, hogy ki mennyi gy�m�lcs�t evett �sszesen. 
    Ki ette a legt�bb gy�m�lcs�t? 
-- �sszes n�vb�l kivonjuk azokat, akikn�l van nagyobb �tv�gy�