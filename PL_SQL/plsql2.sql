CREATE OR REPLACE FUNCTION fv_plusz_2(szam number) RETURN number IS
  lokalis_valtozo NUMBER(6);
BEGIN
  lokalis_valtozo := szam + 2;
  return(lokalis_valtozo);
END;
/

select fv_plusz_2(100) from dual;

-- http://people.inf.elte.hu/nikovits/AB1/PLSQL/feladat10_plsql.txt
-- 1.
CREATE OR REPLACE FUNCTION kat_atlag(n integer) RETURN number IS
  atlag number;
begin
  select avg(fizetes)
  into atlag
  from nikovits.dolgozo, nikovits.fiz_kategoria
  where fizetes between also and felso
    and kategoria = n
  group by kategoria;
  
  return atlag;
end;
/

select kat_atlag(1) from dual;
select kat_atlag(2) from dual;

-- 2.
set serveroutput on
DECLARE
  TYPE array_type IS TABLE OF nikovits.dolgozo%ROWTYPE INDEX BY BINARY_INTEGER;
  arr array_type;
BEGIN
  select *
  into arr
  from nikovits.dolgozo
  order by dnev;
  
  for i in arr.first .. arr.last loop
    dbms_output.put_line(to_char(arr(arr.last - 1).dnev||' -- '||arr(arr.last - 1).fizetes));
  end loop;
  
  dbms_output.put_line(to_char(arr(arr.last - 1).dnev||' -- '||arr(arr.last - 1).fizetes));
END;