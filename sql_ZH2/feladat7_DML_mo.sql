DELETE

-- Töröljük azokat a dolgozókat, akiknek jutaléka NULL.
DELETE FROM dolgozo WHERE jutalek IS NULL;

-- Töröljük azokat a dolgozókat, akiknek a belépési dátuma 1982 elõtti.
DELETE FROM dolgozo WHERE belepes < TO_DATE('1982.01.01', 'yyyy.mm.dd');

-- Töröljük azokat a dolgozókat, akik osztályának telephelye DALLAS.
DELETE FROM dolgozo WHERE oazon IN 
   (SELECT oazon FROM osztaly WHERE telephely = 'DALLAS');


-- Töröljük azokat a dolgozókat, akiknek a fizetése kisebb, mint az átlagfizetés.
DELETE FROM dolgozo WHERE fizetes < (SELECT AVG(fizetes) FROM dolgozo);

-- Töröljük a jelenleg legjobban keresõ dolgozót.
DELETE FROM dolgozo WHERE fizetes = (SELECT MAX(fizetes) FROM dolgozo);

-- Töröljük ki azokat az osztályokat, akiknek van olyan dolgozója, aki a 2-es fizetési 
   kategóriába esik (lásd még Fiz_Kategoria táblát)
(Adjuk meg azon osztályok nevét, amelyeknek van olyan dolgozója, aki a 2-es fizetési kategóriába esik)

delete from osztaly where exists
  (select * from dolgozo, fiz_kategoria 
   where fizetes between also and felso and kategoria=2
   and osztaly.oazon=dolgozo.oazon);

select * from osztaly where exists
  (select * from dolgozo, fiz_kategoria 
   where fizetes between also and felso and kategoria=2
   and osztaly.oazon=dolgozo.oazon);


-- Töröljük ki azon osztályokat, amelyeknek 2 olyan dolgozója van, aki a 2-es fizetési kategóriába esik
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

- Vigyünk fel egy 'Kovacs' nevû új dolgozót a 10-es osztályra a következõ 
  értékekkel: dkod=1, dnev='Kovacs', oazon=10, belépés=aktuális dátum,
  fizetés=a 10-es osztály átlagfizetése. A többi oszop legyen NULL.

INSERT INTO dolgozo(dkod, dnev, belepes, fizetes, oazon) 
SELECT 1,'KOVACS', SYSDATE, AVG(fizetes), 10 FROM dolgozo WHERE oazon=10;

vagy másik megoldás:

INSERT INTO dolgozo(dkod, dnev, belepes, fizetes, oazon) 
VALUES(1,'KOVACS', SYSDATE, (SELECT AVG(fizetes) FROM dolgozo WHERE oazon=10),10);


UPDATE

-- Növeljük meg a 20-as osztályon a dolgozók fizetését 20%-kal.
UPDATE dolgozo SET fizetes = fizetes*1.2 WHERE oazon=20;

-- Növeljük meg azok fizetését 500-zal, akik jutaléka NULL vagy a fizetésük kisebb az átlagnál.
UPDATE dolgozo SET fizetes = fizetes + 500 
WHERE jutalek IS NULL OR fizetes < ( SELECT AVG(fizetes) FROM dolgozo);

-- Növeljük meg mindenkinek a jutalékát a jelenlegi maximális jutalékkal.
UPDATE dolgozo SET jutalek = 
 (SELECT MAX(dolg1.jutalek) + NVL(dolgozo.jutalek,0) from dolgozo dolg1);

-- Módosítsuk 'Loser'-re a legrosszabbul keresõ dolgozó nevét.
UPDATE dolgozo SET dnev = 'Loser' 
WHERE fizetes = ( SELECT MIN(fizetes) FROM dolgozo);


-- Növeljük meg azoknak a dolgozóknak a jutalékát 3000-rel, akiknek legalább 2 közvetlen beosztottjuk van. 
   Az ismeretlen (NULL) jutalékot vegyük úgy, mintha 0 lenne. 
UPDATE dolgozo SET jutalek=coalesce(jutalek,0)+3000 WHERE dkod IN
  (SELECT fonoke FROM dolgozo GROUP BY fonoke HAVING count(*)=2);

-- Növeljük meg azoknak a dolgozóknak a fizetését, akiknek van beosztottja, a minimális fizetéssel
update dolgozo set fizetes = fizetes + (select min(fizetes) from dolgozo) 
where dkod in (select fonoke from dolgozo);

-- Növeljük meg a nem fonökök fizetését a saját osztályuk átlagfizetésével
update dolgozo d1 set fizetes = fizetes + (select avg(fizetes) from dolgozo d2 where d2.oazon = d1.oazon)
where dkod not in (select coalesce(fonoke,0) from dolgozo);


Összetett, több lépéses feladat a feladatgyûjteménybõl:

5.5 feladat/c
Bõvítsük a dolgozó táblát egy lakhely oszloppal, majd töltsük fel a következõképpen:
A Boston-ban dolgozók Chicago-ban, a Chicago-ban dolgozók pedig Bostonban laknak, 
kivéve azokat a Chicago-i dolgozókat, akiknek Blake a fõnöke, mert õk Indianapolis-ban
laknak, feltéve, hogy nem Clerk munkakörûek, mert akkor sehol sem laknak.

ALTER TABLE dolgozo ADD lakhely VARCHAR2(20);

-- A Bostonban dolgozók Chicago-ban laknak						
UPDATE dolgozo  SET lakhely = 'CHICAGO'
WHERE oazon = (SELECT oazon FROM osztaly WHERE telephely = 'BOSTON');

-- A Chicago-ban dolgozók, ha nem Blake a fõnökük -> BOSTON
UPDATE dolgozo SET lakhely = 'BOSTON'
WHERE dkod IN (SELECT d.dkod FROM dolgozo d, osztaly o, dolgozo f
               WHERE d.oazon = o.oazon  AND d.fonoke = f.dkod  
			   AND telephely = 'CHICAGO' AND  f.dnev <> 'BLAKE');

-- A Chicago-ban dolgozók, ha Blake a fõnökük és nem Clerk -> INDIANA
UPDATE dolgozo SET lakhely = 'INDIANA'
WHERE dkod IN (SELECT d.dkod FROM dolgozo d, osztaly o, dolgozo f
               WHERE d.oazon = o.oazon  AND d.fonoke = f.dkod  AND telephely = 'CHICAGO' 
               AND  f.dnev = 'BLAKE' AND d.foglalkozas<>'CLERK');


ALTER TABLE dolgozo DROP COLUMN lakhely;







  
 