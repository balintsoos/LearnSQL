create or replace function prim(n integer) return number is
begin
  for i in 2 .. sqrt(n) loop
    if n / i = trunc(n / i) then
      return 0;
    end if;
  end loop;
  return 1;
end;
/
SELECT prim(26388279066623) from dual;

create or replace procedure fib(n integer) is
begin
  null;
end;
/
set serveroutput on call fib(10);