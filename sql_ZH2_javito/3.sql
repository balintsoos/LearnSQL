-- 3.
-- Adjuk meg a NIKOVITS.VAGYONOK t�bla alapj�n ADAM gyerekeinek, unok�inak, d�dunok�inak 
-- �s �kunok�inak az �sszvagyon�t (vagyis egy sorban az �sszes gyerek�nek az �sszvagyon�t, 
-- egy m�sik sorban az unok�inak az �sszvagyon�t stb.) (rokoni_fokozat, �sszvagyon). 
-- Az els� oszlopban az szerepeljen, hogy 'gyerekek', 'unok�k', stb., a m�sodikban pedig 
-- a megfelel� �sszvagyon. A lek�rdez�st hierarchikus SELECT utas�t�ssal adjuk meg.
-- ------------------
-- gyermek    870000
-- unoka      970000
-- dedunoka  2251000
-- �kunoka    409000

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