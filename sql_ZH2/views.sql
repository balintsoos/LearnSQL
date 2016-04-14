CREATE OR REPLACE VIEW cikk_proj_db
AS 
SELECT NIKOVITS.cikk.ckod ckod, cnev, COUNT(DISTINCT pkod) darab FROM cikk, szallit
WHERE NIKOVITS.cikk.ckod=szallit.ckod
GROUP BY NIKOVITS.cikk.ckod, cnev;


select dnev from nikovits.dolgozo where fonoke in
(select dkod from nikovits.dolgozo where fonoke in 
  (select dkod from nikovits.dolgozo where dnev = 'KING')
);