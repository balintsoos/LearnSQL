-- 2.
set serveroutput on
DECLARE
  type arr_type IS TABLE OF nikovits.dolgozo%ROWTYPE;
  arr arr_type;
  
  cursor c1 is
  select *
  from nikovits.dolgozo
  order by dnev;

BEGIN
  open c1;
  fetch c1 bulk collect into arr;
  close c1;
  
  for i in arr.first .. arr.last loop
    dbms_output.put_line(to_char(arr(i).dnev||' -- '||arr(i).fizetes));
  end loop;
  
  dbms_output.put_line(to_char(arr(arr.last - 1).dnev||' -- '||arr(arr.last - 1).fizetes));
END;
/