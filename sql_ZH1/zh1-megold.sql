--3.
select onev "Onév", round(avg(fizetes)) "Átlag", LPAD(' ', round(avg(fizetes))/200 + 1, '*') "Csillagok"
from nikovits.dolgozo, nikovits.osztaly
where nikovits.dolgozo.oazon = nikovits.osztaly.oazon
group by onev;

--ACCOUNTING	2917	************** 
--RESEARCH	2175	********** 
--SALES	1800	********* 

--4.
select distinct o.onev "Onév", o.telephely "Telephely"
from nikovits.dolgozo d, nikovits.fiz_kategoria k, nikovits.osztaly o
where d.oazon = o.oazon
and d.fizetes BETWEEN k.also AND k.felso;

--RESEARCH	DALLAS
--SALES	CHICAGO
--ACCOUNTING	NEW YORK

--5.
select TO_CHAR(belepes, 'MONTH') "Hónap", count(dkod) "Fő"
from nikovits.dolgozo
group by TO_CHAR(belepes, 'MONTH')
having count(dkod) >= 2;

--SZEPTEMBER	2
--FEBRUÁR   	2
--JANUÁR    	2
--DECEMBER  	4

--6.
select distinct d1.dnev "Dnév", d1.foglalkozas "Foglalkozás", d1.fizetes "Fizetés"
from nikovits.dolgozo d1, nikovits.dolgozo d2, nikovits.dolgozo d3 
where d1.dkod = d2.fonoke
and d1.dkod = d3.fonoke
and d2.dkod != d3.dkod;

--BLAKE	MANAGER	4250
--JONES	MANAGER	2975
--KING	PRESIDENT	5000