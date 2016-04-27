-- 3.
-- Adjuk meg a NIKOVITS.VAGYONOK tábla alapján ADAM gyerekeinek, unokáinak, dédunokáinak 
-- és ükunokáinak az összvagyonát (vagyis egy sorban az összes gyerekének az összvagyonát, 
-- egy másik sorban az unokáinak az összvagyonát stb.) (rokoni_fokozat, összvagyon). 
-- Az elsõ oszlopban az szerepeljen, hogy 'gyerekek', 'unokák', stb., a másodikban pedig 
-- a megfelelõ összvagyon. A lekérdezést hierarchikus SELECT utasítással adjuk meg.
-- ------------------
-- gyermek    870000
-- unoka      970000
-- dedunoka  2251000
-- ükunoka    409000

select kapcsolat, osszvagyon from (
  (select 0 as pos, 'gyermek' kapcsolat, sum(vagyon) osszvagyon
    from nikovits.vagyonok
    where level = 2
    start with nev = 'ADAM'
    connect by prior nev = apja
  ) union
  (select 1 as pos, 'unoka', sum(vagyon)
    from nikovits.vagyonok
    where level = 3
    start with nev = 'ADAM'
    connect by prior nev = apja
  ) union
  (select 2 as pos, 'dedunoka', sum(vagyon)
    from nikovits.vagyonok
    where level = 4
    start with nev = 'ADAM'
    connect by prior nev = apja
  ) union
  (select 3 as pos, 'ukunoka', sum(vagyon)
    from nikovits.vagyonok
    where level = 5
    start with nev = 'ADAM'
    connect by prior nev = apja
  )
)
order by pos;