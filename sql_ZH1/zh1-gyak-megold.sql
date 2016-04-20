select * from nikovits.osztaly;
select * from nikovits.dolgozo;
select * from nikovits.fiz_kategoria;

--0.
select onev, avg(fizetes) + 100
from nikovits.dolgozo, nikovits.osztaly 
where nikovits.dolgozo.oazon = nikovits.osztaly.oazon
group by onev
having count(dkod) > 3
order by onev;

--3.
select TO_CHAR(belepes, 'DAY'), count(dkod)
from nikovits.dolgozo
group by TO_CHAR(belepes, 'DAY')
having count(dkod) >= 3;

--4.
SELECT o.onev, o.telephely, SUM(d.fizetes) 
FROM nikovits.dolgozo d, nikovits.osztaly o 
WHERE d.oazon = o.oazon 
GROUP BY o.onev, o.telephely
HAVING MIN(d.fizetes) < 1000;

--5.
SELECT k.also, k.felso, COUNT(fizetes) 
FROM nikovits.dolgozo d, nikovits.fiz_kategoria k, nikovits.osztaly o 
WHERE d.fizetes BETWEEN k.also AND k.felso 
AND d.oazon = o.oazon 
AND o.telephely = 'CHICAGO'
GROUP BY k.also, k.felso 
HAVING COUNT(fizetes) >= 2;

--6.
SELECT DISTINCT d1.dnev 
FROM nikovits.dolgozo d1, nikovits.dolgozo d2, nikovits.dolgozo d3 
WHERE d1.dkod = d2.fonoke
and d1.dkod = d3.fonoke 
and TO_CHAR(d2.belepes,'YEAR') != TO_CHAR(d3.belepes,'YEAR');
