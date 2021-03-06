-- N�h�ny p�lda megszor�t�sok (Constraint) l�trehoz�s�ra

CREATE TABLE emp1   AS SELECT * FROM nikovits.emp;
CREATE TABLE dept1  AS SELECT * FROM nikovits.dept;

select * from emp1;
select * from dept1;

-- Az emp1 �s dept1 t�bl�k els�dleges kulcsainak megad�sa
ALTER TABLE emp1   ADD CONSTRAINT emp1_empno_pk   PRIMARY KEY (empno);
ALTER TABLE dept1  ADD CONSTRAINT dept1_deptno_pk PRIMARY KEY (deptno);

-- Az emp1 t�bla idegen kulcs�nak megad�sa
ALTER TABLE emp1   ADD CONSTRAINT emp1_deptno_fk FOREIGN KEY (deptno) REFERENCES dept1 (deptno);

-- �j oszlop hozz�ad�sa a t�bl�hoz
ALTER TABLE emp1  ADD (mgr1 NUMBER(4));

-- �j oszlop hozz�ad�sa megszor�t�ssal
ALTER TABLE emp1  ADD (mgr2 NUMBER(4) CONSTRAINT emp1_mgr2_fk REFERENCES emp1 (empno));

-- A megl�v� sal oszlop kieg�sz�t�se NOT NULL megszor�t�ssal
ALTER TABLE emp1  MODIFY (sal CONSTRAINT emp1_sal_nn NOT NULL);

-- A megl�v� ename oszlop kieg�sz�t�se UNIQUE megszor�t�ssal
ALTER TABLE emp1  ADD CONSTRAINT emp1_ename_u UNIQUE (ename);

-- A megl�v� sal oszlop kieg�sz�t�se CHECK megszor�t�sokkal
ALTER TABLE emp1  ADD CONSTRAINT emp1_c1 CHECK (sal <= 9999);
ALTER TABLE emp1  ADD CONSTRAINT emp1_c2 CHECK (sal >=  500);

-- Oszlop �tnevez�se
ALTER TABLE emp1  RENAME COLUMN sal TO sal2;


-- Egy megszor�t�s t�rl�se
ALTER TABLE emp1   DROP CONSTRAINT emp1_c1;

-- A megszor�t�sok lek�rdez�se
SET LINESIZE 150
COLUMN Tabla       FORMAT A15
COLUMN Oszlop      FORMAT A15
COLUMN Megszoritas FORMAT A15

SELECT cons.table_name Tabla,  SUBSTR(col.column_name,1,10)   Oszlop,
       cons.constraint_name  Megszoritas, cons.constraint_type  Tipusa, 
       cons.search_condition Feltetel
FROM user_constraints cons, user_cons_columns col
WHERE cons.constraint_name = col.constraint_name  
AND   LOWER(cons.table_name) IN ('emp1','dept1')
ORDER BY 1, 2;


-- A t�bl�k eldob�sa. A sorrend nem mindegy !!!!!

DROP TABLE dept1; 
DROP TABLE emp1;
DROP TABLE dept1;