select l.PROG_CD, 
case l.PROG_STATUS_CD 
   when 'AO' then 'AO - Active Open' 
   when 'CD' THEN 'CD - CASE DENIED' 
   WHEN 'CL' THEN 'CL - CLOSED' 
   else 'XX' END as  PROG_STATUS_CD, 
Legacy_CNT, ie_cnt
,(Legacy_CNT-ie_cnt) Failed
from
(
SELECT PROG_CD, PROG_STATUS_CD, SUM(CNT) as Legacy_CNT
FROM (
SELECT CASE 
   WHEN CP_PGM_TYPE = 'BA' THEN 'FITAP' 
   WHEN CP_PGM_TYPE = 'CA' THEN 'LACAP' 
WHEN CP_PGM_TYPE = 'NP' THEN 'SNAP' 
WHEN CP_PGM_TYPE = 'PA' THEN 'SNAP' 
WHEN CP_PGM_TYPE = 'UP' THEN 'KCSP' END as PROG_CD,
CP_STAT as PROG_STATUS_CD, Cnt
FROM (
SElect CP_PGM_TYPE, CP_STAT, Count(1) cnt
FROM PRELAND.LAMI_CASE_PGM(NOLOCK)
Group BY CP_PGM_TYPE, CP_STAT
) A
) B
GROUP BY PROG_CD, PROG_STATUS_CD
) l

join




 (

SELECT CASE 
   WHEN PROG_CD = '02' THEN 'FITAP' 
   WHEN PROG_CD = '03' THEN 'KCSP' 
WHEN PROG_CD = '01' THEN 'SNAP' 
WHEN PROG_CD = '04' THEN 'LACAP' END as PROG_CD,

case PROG_STATUS_CD when 'AP' then 'AO' when 'DN' THEN 'CD' WHEN 'TN' THEN 'CL' else 'XX' END as  PROG_STATUS_CD, Count(1) AS ie_cnt
FROM stage.Dc_case_Program(NOLOCK)
Group BY PROG_CD, PROG_STATUS_CD
) ie 
on L.PROG_CD = IE.PROG_CD AND L.PROG_STATUS_CD = IE.PROG_STATUS_CD
Order By 1