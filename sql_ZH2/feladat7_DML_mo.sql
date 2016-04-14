DELETE

-- T�r�lj�k azokat a dolgoz�kat, akiknek jutal�ka NULL.
DELETE FROM dolgozo WHERE jutalek IS NULL;

-- T�r�lj�k azokat a dolgoz�kat, akiknek a bel�p�si d�tuma 1982 el�tti.
DELETE FROM dolgozo WHERE belepes < TO_DATE('1982.01.01', 'yyyy.mm.dd');

-- T�r�lj�k azokat a dolgoz�kat, akik oszt�ly�nak telephelye DALLAS.
DELETE FROM dolgozo WHERE oazon IN 
   (SELECT oazon FROM osztaly WHERE telephely = 'DALLAS');


-- T�r�lj�k azokat a dolgoz�kat, akiknek a fizet�se kisebb, mint az �tlagfizet�s.
DELETE FROM dolgozo WHERE fizetes < (SELECT AVG(fizetes) FROM dolgozo);

-- T�r�lj�k a jelenleg legjobban keres� dolgoz�t.
DELETE FROM dolgozo WHERE fizetes = (SELECT MAX(fizetes) FROM dolgozo);

-- T�r�lj�k ki azokat az oszt�lyokat, akiknek van olyan dolgoz�ja, aki a 2-es fizet�si 
   kateg�ri�ba esik (l�sd m�g Fiz_Kategoria t�bl�t)
(Adjuk meg azon oszt�lyok nev�t, amelyeknek van olyan dolgoz�ja, aki a 2-es fizet�si kateg�ri�ba esik)

delete from osztaly where exists
  (select * from dolgozo, fiz_kategoria 
   where fizetes between also and felso and kategoria=2
   and osztaly.oazon=dolgozo.oazon);

select * from osztaly where exists
  (select * from dolgozo, fiz_kategoria 
   where fizetes between also and felso and kategoria=2
   and osztaly.oazon=dolgozo.oazon);


-- T�r�lj�k ki azon oszt�lyokat, amelyeknek 2 olyan dolgoz�ja van, aki a 2-es fizet�si kateg�ri�ba esik
delete from osztaly where oazon in 
  (select oazon from  dolgozo d, fiz_kategoria 
   where fizetes between also and felso and kategoria=2
   group by oazon
   having count(distinct dkod) = 2);

select * from osztaly where oazon in 
  (select oazon from  dolgozo d, fiz_kategoria 
   where fizetes between also and felso and kategoria=2
   group by oazon
   having count(distinct dkod) = 2);


INSERT

- Vigy�nk fel egy 'Kovacs' nev� �j dolgoz�t a 10-es oszt�lyra a k�vetkez� 
  �rt�kekkel: dkod=1, dnev='Kovacs', oazon=10, bel�p�s=aktu�lis d�tum,
  fizet�s=a 10-es oszt�ly �tlagfizet�se. A t�bbi oszop legyen NULL.

INSERT INTO dolgozo(dkod, dnev, belepes, fizetes, oazon) 
SELECT 1,'KOVACS', SYSDATE, AVG(fizetes), 10 FROM dolgozo WHERE oazon=10;

vagy m�sik megold�s:

INSERT INTO dolgozo(dkod, dnev, belepes, fizetes, oazon) 
VALUES(1,'KOVACS', SYSDATE, (SELECT AVG(fizetes) FROM dolgozo WHERE oazon=10),10);


UPDATE

-- N�velj�k meg a 20-as oszt�lyon a dolgoz�k fizet�s�t 20%-kal.
UPDATE dolgozo SET fizetes = fizetes*1.2 WHERE oazon=20;

-- N�velj�k meg azok fizet�s�t 500-zal, akik jutal�ka NULL vagy a fizet�s�k kisebb az �tlagn�l.
UPDATE dolgozo SET fizetes = fizetes + 500 
WHERE jutalek IS NULL OR fizetes < ( SELECT AVG(fizetes) FROM dolgozo);

-- N�velj�k meg mindenkinek a jutal�k�t a jelenlegi maxim�lis jutal�kkal.
UPDATE dolgozo SET jutalek = 
 (SELECT MAX(dolg1.jutalek) + NVL(dolgozo.jutalek,0) from dolgozo dolg1);

-- M�dos�tsuk 'Loser'-re a legrosszabbul keres� dolgoz� nev�t.
UPDATE dolgozo SET dnev = 'Loser' 
WHERE fizetes = ( SELECT MIN(fizetes) FROM dolgozo);


-- N�velj�k meg azoknak a dolgoz�knak a jutal�k�t 3000-rel, akiknek legal�bb 2 k�zvetlen beosztottjuk van. 
   Az ismeretlen (NULL) jutal�kot vegy�k �gy, mintha 0 lenne. 
UPDATE dolgozo SET jutalek=coalesce(jutalek,0)+3000 WHERE dkod IN
  (SELECT fonoke FROM dolgozo GROUP BY fonoke HAVING count(*)=2);

-- N�velj�k meg azoknak a dolgoz�knak a fizet�s�t, akiknek van beosztottja, a minim�lis fizet�ssel
update dolgozo set fizetes = fizetes + (select min(fizetes) from dolgozo) 
where dkod in (select fonoke from dolgozo);

-- N�velj�k meg a nem fon�k�k fizet�s�t a saj�t oszt�lyuk �tlagfizet�s�vel
update dolgozo d1 set fizetes = fizetes + (select avg(fizetes) from dolgozo d2 where d2.oazon = d1.oazon)
where dkod not in (select coalesce(fonoke,0) from dolgozo);


�sszetett, t�bb l�p�ses feladat a feladatgy�jtem�nyb�l:

5.5 feladat/c
B�v�ts�k a dolgoz� t�bl�t egy lakhely oszloppal, majd t�lts�k fel a k�vetkez�k�ppen:
A Boston-ban dolgoz�k Chicago-ban, a Chicago-ban dolgoz�k pedig Bostonban laknak, 
kiv�ve azokat a Chicago-i dolgoz�kat, akiknek Blake a f�n�ke, mert �k Indianapolis-ban
laknak, felt�ve, hogy nem Clerk munkak�r�ek, mert akkor sehol sem laknak.

ALTER TABLE dolgozo ADD lakhely VARCHAR2(20);

-- A Bostonban dolgoz�k Chicago-ban laknak						
UPDATE dolgozo  SET lakhely = 'CHICAGO'
WHERE oazon = (SELECT oazon FROM osztaly WHERE telephely = 'BOSTON');

-- A Chicago-ban dolgoz�k, ha nem Blake a f�n�k�k -> BOSTON
UPDATE dolgozo SET lakhely = 'BOSTON'
WHERE dkod IN (SELECT d.dkod FROM dolgozo d, osztaly o, dolgozo f
               WHERE d.oazon = o.oazon  AND d.fonoke = f.dkod  
			   AND telephely = 'CHICAGO' AND  f.dnev <> 'BLAKE');

-- A Chicago-ban dolgoz�k, ha Blake a f�n�k�k �s nem Clerk -> INDIANA
UPDATE dolgozo SET lakhely = 'INDIANA'
WHERE dkod IN (SELECT d.dkod FROM dolgozo d, osztaly o, dolgozo f
               WHERE d.oazon = o.oazon  AND d.fonoke = f.dkod  AND telephely = 'CHICAGO' 
               AND  f.dnev = 'BLAKE' AND d.foglalkozas<>'CLERK');


ALTER TABLE dolgozo DROP COLUMN lakhely;







  
 