Changed database context to 'ie_ie_cnv'.
--Total Finction in 02 server :         63


CREATE FUNCTION [dbo].[F_GET_ILLEGAL_ALIENS_NUM_ED_ELIGILITY] ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS BIGINT
BEGIN

DECLARE @l_ILLEGAL_ALIENS_NUM INT = 0
/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_ILLEGAL_ALIENS_NUM_ED_ELIGILITY.sql
Purpose: FN to get ILLEGAL_ALIENS_NUM from  lami_CASE_PGM_MEM table

Logic:

ILLEGAL_ALIENS_NUM	Count of Individuals with INCL-REASON="02" and Exclusion-code="11"	CASE-PGM-MEM	CPM-INCL-REASON

*/


SELECT @l_ILLEGAL_ALIENS_NUM =  (select Count(1) from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND CPM_INCL_REASON IN (  '02', '11'))


RETURN @l_ILLEGAL_ALIENS_NUM

END 



GO


CREATE FUNCTION [dbo].[F_GET_DC_INDV_LIVING_ARNGMNTS_LA_VERF_CD](@INDV_ID BIGINT)
RETURNS VARCHAR(10)
BEGIN
DECLARE @l_LA_VERF_CD VARCHAR(10) 

DECLARE @CPM_LIVING_ARRANG_V VARCHAR(10) 

--SELECT distinct CPM_LIVING_ARRANG_V from LAND.LAMI_CASE_PGM_MEM


--RT Mapping. IE Table = LIVINGARRANGEMENTVRF; Legacy Table = LVER

--AVAILABLE values as per appendix 
--98,4,5,51,52,50,55,80

--from preland table we are getting 24 DISTINCT values
-- 1, 4, B, M,00,01,04,05,11,23,3,40,44,50,51,52,54,55,80,98,CP,Q,Q0,V

/*
SELECT  CPM_LIVING_ARRANG_V, DBO.F_GET_REFERENCE_DATA ('LVER', CPM_LIVING_ARRANG_V, 'LIVINGARRANGEMENTVRF') AS LA_VERF_CD 
FROM (
SELECT DISTINCT CPM_LIVING_ARRANG_V
FROM LAND.LAMI_CASE_PGM_MEM (NOLOCK) 
WHERE CPM_LIVING_ARRANG_V IS NOT NULL) A;


3	NULL
80	CV
``	NULL
 0	NULL
00	NULL
`	NULL
50	CC
Q	NULL
F	NULL
11	NULL
52	CC
.	NULL
01	NULL
44	NULL
55	CS
0	NULL
~	NULL
CP	NULL
04	WS
54	NULL
40	NULL
05	WS
51	LS
'	NULL
98	PV
 B	NULL
4	NULL
N	NULL
08	NULL
*/



SELECT @CPM_LIVING_ARRANG_V = @CPM_LIVING_ARRANG_V
FROM (
SELECT distinct   CPM_LIVING_ARRANG_V
from Land.LAMI_CASE_PGM_MEM(noloCK) b
WHERE b.cpm_PID = @INDV_ID) A


SET @l_LA_VERF_CD = CASE @CPM_LIVING_ARRANG_V
   WHEN '98' THEN 'PV'
   WHEN '04' THEN 'WS'
   WHEN '05' THEN 'WS'
   WHEN '51' THEN 'LS'
   WHEN '52' THEN 'CC'
   WHEN '50' THEN 'CC'
   WHEN '55' THEN 'CS'
   WHEN '80' THEN 'CV'
   else 'CV'
   END


RETURN  @l_LA_VERF_CD

END


GO

CREATE FUNCTION [dbo].[F_GET_DATE_TIME](@Date date)
RETURNS VARCHAR(20)
BEGIN


DEclare @l_Date VARCHAR(10)

DECLARE @l_Time VarchAR(30) 

DECLARE @l_String VarchAR(50) 

SELECT @l_String = --cast(Replace(Convert(VARCHAR(10), @Date, 101), '/', '')  as varchar) 
cast(Replace(Convert(VARCHAR(12), @Date, 108), ':', '') as varchar)
--+ Datepart(HOUR, @Date) + Datepart(MI, @Date)+ Datepart(SS, @Date)

RETURN @l_String
END --Function


GO


CREATE FUNCTION [dbo].[F_GET_QUARTER_END_DATE](@Date_String VARCHAR(5))
RETURNS DATETIME2
BEGIN

--DECLARE @Date_String VARCHAR(5) = '20061'
DECLARE @l_Date DATETIME2 = getdate()

IF LEN(LTRIM(RTRIM(@Date_String))) = 5
BEGIN 



SET @l_Date = CASE  RIGHT(@Date_String,1) 
                WHEN 1 THEN '03/31/' + LEFT(@Date_String,4)
                WHEN 2 THEN '06/30/' + LEFT(@Date_String,4)
                WHEN 3 THEN '09/30/' + LEFT(@Date_String,4)
                WHEN 4 THEN '12/31/' + LEFT(@Date_String,4)
				ELSE NULL END 


END 
--PRINT @l_Date

RETURN @l_Date
END --Function



GO


CREATE FUNCTION [dbo].[F_GET_DC_SHELTER_DEDUCTIONS_EXPENSE_TYPE_CD] ( @EXP_TYPE VARCHAR(20))
RETURNS VARCHAR(20)
BEGIN

--'SR/M','SINS','STAX','SRTM','SXOT','SUNA'

DECLARE @l_EXP_Status  VARCHAR(10) = 'CV'

/*
--select * from iewp_ie_dev3..RT_SHELTEREXPENSETYPE_MV


HI	Homeowner's/ Flood Insurance	EXPE	EXPENSE TYPES	SINS	HOMEOWNER/FLOOD INSURANCE
SUMO	Mortgage	EXPE	EXPENSE TYPES	SR/M	RENT/MORTGAGE
SURE	Rent	EXPE	EXPENSE TYPES	SRTM	OTHER RENT/MORTGAGE
PT	Property Taxes	EXPE	EXPENSE TYPES	STAX	HOMEOWNER TAXES


--	SHELTEREXPENSETYPE
SELECT  EXP_TYPE, DBO.F_GET_REFERENCE_DATA ('EXPE', EXP_TYPE, 'SHELTEREXPENSETYPE') AS EXPENSE_TYPE_CD 
FROM (
SELECT DISTINCT EXP_TYPE
FROM LAND.LAMI_EXPENSES (NOLOCK) 
WHERE EXP_TYPE  IN ('SR/M' , 'SINS', 'SRTM' , 'STAX', 'SXOT', 'SUNA')
) A;



*/


SELECT @l_EXP_Status = CASE
    WHEN  @EXP_TYPE = 'SR/M'  THEN 'SURE'
    WHEN  @EXP_TYPE = 'SINS'  THEN 'HI'
    WHEN  @EXP_TYPE = 'SRTM'  THEN 'SECM'
    WHEN  @EXP_TYPE = 'STAX'  THEN 'PT'
      WHEN  @EXP_TYPE = 'SXOT'  THEN 'RR'
      WHEN  @EXP_TYPE = 'SUNA'  THEN 'CV'
       ELSE 'CV' END 

RETURN @l_EXP_Status

END 





GO


CREATE FUNCTION [dbo].[fn_FileExists](@path varchar(512))
RETURNS BIT
AS
BEGIN
     DECLARE @result INT
     EXEC master.dbo.xp_fileexist @path, @result OUTPUT
     RETURN cast(@result as bit)
END;

GO



CREATE FUNCTION [dbo].[F_GET_ED_ELIGIBILITY_BENEFIT_STATUS] (@Legacy_Freq VARCHAR(10))
RETURNS VARCHAR(10)
BEGIN
/*
IE_Code	IE_Field_Description	Legacy_Table_Name	Legacy_Table_Description	Legacy_Code	Legacy_Description
CV	CV	ISST	ISSUANCE STATUS CODES	AU	AUTHORIZED
CA	Cancelled	ISST	ISSUANCE STATUS CODES	CA	CANCELED
CV	CV	ISST	ISSUANCE STATUS CODES	FV	FORM VOID
AK	Issued	ISST	ISSUANCE STATUS CODES	IS	ISSUED
RT	Returned	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
PA	Paid	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
DR	Direct deposit returned	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
EX	EBT Expungement	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
PE	Pending	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
ES	Escheatment	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
TO	Tax Offset	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
ST	Stopped	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
SM	Submitted	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
F1	Pending DHS-4663 submission	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
F2	DHS-4663 submitted	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
SR	Supr. Rejected	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
RJ	Rejected	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
FL	Failed	ISST	ISSUANCE STATUS CODES	Not Available	Not Available
CV	CV	ISST	ISSUANCE STATUS CODES	OR	OVER-RIDDEN
AP	Pending Approval	ISST	ISSUANCE STATUS CODES	PA	PENDING STATE AUTHORIZATION
CV	CV	ISST	ISSUANCE STATUS CODES	PV	PRINTER VOID
CV	CV	ISST	ISSUANCE STATUS CODES	RD	REISSUANCE REQUEST DENIED
CV	CV	ISST	ISSUANCE STATUS CODES	RM	REDEEMED
ZG	Zero Grant	ISST	ISSUANCE STATUS CODES	ZG	ZERO GRANT
*/


DECLARE @l_IE_Reference_Code VARCHAR(10)

SELECT @l_IE_Reference_Code = CASE  @Legacy_Freq 
WHEN 'AU' THEN 'AU'
WHEN 'CA' THEN 'CA'
WHEN 'FV' THEN 'FV'
WHEN 'IS' THEN 'AK'
WHEN 'OR' THEN 'OR'
WHEN 'PA' THEN 'AP'
WHEN 'PV' THEN 'PV'
WHEN 'RD' THEN 'RD'
WHEN 'RM' THEN 'RM'
WHEN 'ZG' THEN 'ZG'
ELSE NULL
END 

RETURN @l_IE_Reference_Code

END 


GO

CREATE FUNCTION [dbo].[F_GET_EXTENSION_CODE] ( @LIM_EXTEN VARCHAR(2))
RETURNS VARCHAR(20)
BEGIN

DECLARE @l_EXTENSION_CODE   VARCHAR(10) = 'XX'

IF @LIM_EXTEN = '' OR @LIM_EXTEN IS NULL SET @l_EXTENSION_CODE = NULL
SELECT @l_EXTENSION_CODE = CASE
    WHEN  @LIM_EXTEN = 'T1'  THEN 'T1'
    WHEN  @LIM_EXTEN = 'T2'  THEN 'T2'
    WHEN  @LIM_EXTEN = 'T3'  THEN 'T3'
    WHEN  @LIM_EXTEN = 'T4'  THEN 'T4'
	WHEN  @LIM_EXTEN = 'T5'  THEN 'T5'
	WHEN  @LIM_EXTEN = 'T6'  THEN 'T6'
	WHEN  @LIM_EXTEN = 'T7'  THEN 'T7'
	ELSE NULL END 

RETURN @l_EXTENSION_CODE

END 

GO


CREATE FUNCTION [dbo].[F_GET_FORMAT_DATE](@Date_String VARCHAR(8), @format VARCHAR(8))
RETURNS DATETIME2
BEGIN

--DECLARE @Date_String VARCHAR(5) = '20061'
DECLARE @l_Date DATETIME2 
IF  LEN(LTRIM(RTRIM(@Date_String))) = 0 SET @l_Date = NULL

IF LEN(LTRIM(RTRIM(@Date_String))) = 7 AND @format = 'MMDDYYYY'
BEGIN

SET @Date_String = '0' + @Date_String
  SET @l_Date =  CAST( RIGHT(@Date_String,4) +  LEFT(@Date_String,2) + SUBSTRING(@Date_String,3,2) as DATETIME2)
END 

ELSE
IF LEN(LTRIM(RTRIM(@Date_String))) = 8 AND @format = 'MMDDYYYY'
  SET @l_Date =  CAST( RIGHT(@Date_String,4) +  LEFT(@Date_String,2) + SUBSTRING(@Date_String,3,2) as DATETIME2)
--PRINT @l_Date

RETURN @l_Date
END --Function



GO
CREATE FUNCTION [dbo].[F_GET_AMOUNT](@Amt_String VARCHAR(11))
RETURNS NUMERIC(11,2)
BEGIN


--DECLARE @l_Prec INT = LEN(@Amt_String) -2

IF LEN(@Amt_String) < 11 SET @Amt_String = RIGHT('000000000000' + LTRIM(RTRIM(@Amt_String)), 11)

--SET @l_Prec 
--DECLARE @l_Amt_String VARCHAR(11) = '00000012356'
DECLARE @l_Amt NUMERIC(11,2) = 0.00
--SELECT ISNUMERIC(@l_Amt_String)

IF ISNUMERIC(Replace(@Amt_String, '0', '')) = 1 
BEGIN

--Print @l_Amt_String
SET @l_Amt = SUBSTRING(@Amt_String,1, 9) +  '.' + right(@Amt_String,2)
--SET @l_Amt = CAST(@Amt_String as decimal(11,2)) 
END 

RETURN  @l_Amt

END 

GO



CREATE FUNCTION [dbo].[F_GET_FREQUENCY_CD] (@Legacy_Freq VARCHAR(10))
RETURNS VARCHAR(10)
BEGIN
/*
WK	Weekly	FREQ	FREQUENCY CODES	W
ETW	Every Two Weeks	FREQ	FREQUENCY CODES	B
MO	Monthly	FREQ	FREQUENCY CODES	M
TM	Twice a Month	FREQ	FREQUENCY CODES	S
QU	Quarterly	FREQ	FREQUENCY CODES	Q
AN	Annually	FREQ	FREQUENCY CODES	A
OTO	One-Time Only	FREQ	FREQUENCY CODES	P
WK	Weekly	FREQ	FREQUENCY CODES	W
BI	Every Two Weeks	FREQ	FREQUENCY CODES	B
MO	Monthly	FREQ	FREQUENCY CODES	S
TM	Twice a Month	FREQ	FREQUENCY CODES	M
QU	Quarterly	FREQ	FREQUENCY CODES	Q
AN	Annually	FREQ	FREQUENCY CODES	A
OT	One-Time Only (Expense)	FREQ	FREQUENCY CODES	P
*/


DECLARE @l_IE_Reference_Code VARCHAR(10)

SELECT @l_IE_Reference_Code = CASE  @Legacy_Freq 
   WHEN 'W' THEN 'WK'
   WHEN 'B' THEN 'BI'
WHEN 'M' THEN 'MO'
WHEN 'S' THEN 'TM'
WHEN 'Q' THEN 'QU'
WHEN 'A' THEN 'AN'
WHEN 'P' THEN 'IR'
ELSE NULL
END 

RETURN @l_IE_Reference_Code

END 


GO

CREATE FUNCTION dbo.F_GET_FIRST_DAY(@Date DATETIME)
RETURNS DATETIME2(0)
AS
BEGIN
DECLARE  @l_DATE DATE
DECLARE  @l_first_DAY_DATE DATE


SET @l_first_DAY_DATE = DATEADD(m, DATEDIFF(m, 0, @Date), 0)  

RETURN @l_first_DAY_DATE --cast(@l_hdr_ID as VARCHAR)

END --


GO
--SELECT * from Sys.objects 

CREATE FUNCTION [dbo].[F_GET_TABLE_COUNT] (@table_Name VARCHAR(200), @Schema_Name Varchar(20))
RETURNS INT
As
BEGIn

DECLARE @l_Count INT

IF @Schema_Name = 'STAGE'
SELECT @l_Count = RowCnt
FROM (
SELECT SUM(pa.rows) RowCnt
FROM sys.tables ta
INNER JOIN ie_ie_cnv.sys.partitions pa  ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN ie_ie_cnv.sys.schemas sc ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
AND sc.name = @Schema_Name
AND ta.Name = @table_Name
GROUP BY sc.name,ta.name) A


IF @Schema_Name = 'DBO'
SELECT @l_Count = RowCnt
FROM (
SELECT SUM(pa.rows) RowCnt
FROM iewp_ie_state.sys.tables ta
INNER JOIN iewp_ie_state.sys.partitions pa  ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN iewp_ie_state.sys.schemas sc ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
AND sc.name = @Schema_Name
AND ta.Name = @table_Name
GROUP BY sc.name,ta.name) A



RETURN @l_Count
END --1


GO

create FUNCTION [dbo].F_GET_TC_TRANSACTIONS_COUNT_MNTH_IN_FEDERAL_SW(@INDV_ID BIGINT)
RETURNS VARCHAR(1)
BEGIN --Main

/* 
Created: Wei Lee
Created date: MAR 06 2018
Purpose: Derive COUNT_MNTH_IN_FEDERAL_SW based on CASE-PGM-MEM file
File Name : TC_TRANSACTIONS_Functions


Logic:

Loop 144 times in reverse order from oldest to newest:

                        FOR #I1 = 144 TO 1 STEP -1

If Benefit Issue Month is more than 60 months, skip record:

                         IF LAMM10AG.LIM-BI-MON(#I1) LE #BI-DATE-MIN-60
                              ESCAPE TOP
                        END-IF

If Benefit Issue Month is less than 10/01/2003
   If Parent Indicator = "P" and Inclusion Code = "01" or "02" and Exemption not equal to "01"

       Check if 24 month limit has been reached and Exemption is blank
       Check if 900 Deduction = "Y" and Benefit Issue Month is greater than 06/30/1999

If both conditions False, increment 24 month limit count by one
   If 24 month limit count = 24 set flag to True:


*/

--SET NOCOUNT ON
DECLARE @l_COUNT_MNTH_IN_FEDERAL_SW VARCHAR(1)= 'N'
--DECLARE @INDV_ID INT = '100000645'


DECLARE @l_counter INT  = 0
DECLARE @l_Conv_Date DATE = dbo.F_GET_Conv_date()
--Print @l_Conv_Date

DECLARE @table TABLE(SEQ_ID INT IDENTITY(1,1), LIM_PID	INT, LIM_EXEMP	VARCHAR(2), LIM_BI_MON	DATETIME, 
LIM_PARENT_IND VARCHAR(1), 
LIM_DED_900	VARCHAR(1), LIM_INCL_CODE	VARCHAR(2), LIM_EXTEN VARCHAR(1))


DECLARE @l_LIM_PID	INT, @l_LIM_EXEMP	VARCHAR(2), @l_LIM_BI_MON	DATETIME2(0), 
@l_LIM_PARENT_IND VARCHAR(1), 
@l_LIM_DED_900	VARCHAR(1), 
@l_LIM_INCL_CODE VARCHAR(2), 
@l_LIM_EXTEN VARCHAR(1),
@l_LIM_PX_IND VARCHAR(1) 

DECLARE @l_Loop INT, @l_Max INt 
--Get data from oldest to newest

INSERT INTO @table
SELECT LIM_PID, 
       CASE WHEN LTRIM(RTRIM(LIM_EXEMP)) = '' THEN NULL ELSE LIM_EXEMP END,  
       (LIM_BI_MON), 
	   LIM_PARENT_IND,
       CASE WHEN LTRIM(RTRIM(LIM_DED_900)) = '' THEN NULL ELSE LIM_DED_900 END,  
	   LIM_INCL_CODE, 
       CASE WHEN LTRIM(RTRIM(LIM_EXTEN)) = '' THEN NULL ELSE LIM_EXTEN END
	   --CASE WHEN LTRIM(RTRIM(LIM_PX_IND)) = '' THEN NULL ELSE LIM_PX_IND END
	   --SELECT *
from LAND.LAMI_LIMIT_AFDC
WHERE LIM_PID = @INDV_ID
ORDER BY LIM_BI_MON 
SELECT @l_Loop = 1, @l_Max  = @@ROWCOUNT

WHILE @l_Loop <= @l_Max
BEGIN --Loop

--SELECT * FROM IE_IE_CNV.STAGE.TC_TRANSACTIONS
  --Get  data
  SELECT @l_LIM_EXEMP = LIM_EXEMP,
        @l_LIM_BI_MON = LIM_BI_MON,
		@l_LIM_PARENT_IND = LIM_PARENT_IND,
		@l_LIM_DED_900 = LIM_DED_900,
		@l_LIM_INCL_CODE = LIM_INCL_CODE,
		@l_LIM_EXTEN = LIM_EXTEN
		--@1_LIM_PX_IND =LIM_PX_IND
  FROM @table 
  WHERE SEQ_ID = @l_Loop
 --Print @l_LIM_BI_MON

   --Step1: If Benefit Issue Month is more than 60 months, skip record:
 IF @l_LIM_BI_MON < DATEADD(MM, -60, dbo.F_GET_CONV_DATE() )
    GOTO NEXTREC

   --Logic1:  Benefit Issue Month is less than 10/01/2003
 
 IF @l_LIM_BI_MON < '10/01/2003'
 BEGIN --Logic1

 --Print 'Logic1'

 --Step2:    If Parent Indicator = "P" and Inclusion Code = "01" 
  IF @l_LIM_PARENT_IND IN( 'P', 'A') AND @l_LIM_INCL_CODE ='01' 
  BEGIN --Step2
 -- Cond1: Check if 60 month limit has been reached and Exemption is blank
 IF (@l_LIM_EXEMP IS not NULL OR @l_LIM_EXEMP != '') AND @l_counter >= 60
  GOTO NEXTREC

  --Cond2: Check if 900 Deduction = "Y" and Benefit Issue Month is greater than 06/30/1999
  IF (@l_LIM_EXEMP ='' or @l_LIM_EXEMP is null ) 
  
  SET @l_counter = @l_counter + 1
 END  --Step2

 END --Logic1

  --Logic2:  Benefit Issue Month is GTE  10/01/2003
 IF @l_LIM_BI_MON >= '10/01/2003'
 BEGIN --Logic2
  --Print 'Logic2'

 --Step2:    If Parent Indicator = "P" and Inclusion Code = "01" 
  IF @l_LIM_PARENT_IND IN( 'P', 'A') AND @l_LIM_INCL_CODE IN ('01') 
   begin--Step2
 
  SET @l_counter = @l_counter + 1
  --Step2
  end 
 END --Logic2




   NEXTREC:
  SET @l_Loop = @l_Loop + 1

  END --Loop

  IF @l
_counter =24 SET @l_COUNT_MNTH_IN_FEDERAL_SW = 'Y'

  RETURN @l_COUNT_MNTH_IN_FEDERAL_SW
END --function


GO
CREATE FUNCTION dbo.F_GET_DATETIME(@DATE_String VARCHAR(15))
RETURNS Datetime2(0)
BEGIN
DECLARE @l_text VARCHAR(20) 
--DECLARE @DATE_String VARCHAR(15) = '201603281956034'
DECLARE @l_DATE Datetime2(0)

SET @l_text = SUBSTRING(@DATE_String,1,8) + ' ' + SUBSTRING(@DATE_String,9,2) + ':' 
+ SUBSTRING(@DATE_String,11,2) + ':' 
+ SUBSTRING(@DATE_String,13,2)  
--+ SUBSTRING(@DATE_String,15,1)  

--Print @l_text


SET @l_DATE = CAST(@l_text as DATETIME2)
--Print @l_DATE
RETURN   @l_DATE

END 

GO

create FUNCTION [dbo].F_GET_DC_INDV_LIVING_ARNGMNTS_APPLIES_FOR_ALL_SW(@INDV_ID BIGINT)
RETURNS VARCHAR(18)
BEGIN
/* 
Created: Venkata Nemani
Created date: Jan 12 2018
Purpose: Derive APPLIES_FOR_ALL_SW based on CASE-PGM-MEM file
File Name : Group1 Functions


--Logic: if CPM-PGM-MEM.CPM-REL-TO-HH = "01" (self recipient) AND CPM-PGM-MEM.CPM-INCL-CODE is not "01" or "02" populate N (No) else populate Y (yes)
*/


DECLARE @l_APPLIES_FOR_ALL_SW VARCHAR(1)= 'Y'


IF EXISTS (
SELECT cpm_PID  --top 1 CPM_REL_TO_HH, CPM_INCL_CODE
from Land.LAMI_CASE_PGM_MEM(noloCK) b
WHERE b.cpm_PID =@INDV_ID
and CPM_REL_TO_HH = '01' 
AND CPM_INCL_CODE NOT IN ('01','02') )
SET @l_APPLIES_FOR_ALL_SW = 'N'

RETURN  @l_APPLIES_FOR_ALL_SW

END


GO

create FUNCTION [dbo].F_GET_TC_TRANSACTIONS_COUNT_MNTH_IN_FEDERRAL_SW(@INDV_ID BIGINT)
RETURNS VARCHAR(1)
BEGIN --Main

/* 
Created: Venkata Nemani
Created date: Feb 09 2018
Purpose: Derive COUNT_MNTH_IN_FEDERRAL_SW based on CASE-PGM-MEM file
File Name : TC_TRANSACTIONS_Functions


Logic:
 
To accumulate the 60-month limit total, check each month to see
if the parent indicator is an 'P' or 'A' with an inclusion code
of '01'.  Once the 60-month limit total reaches 60, no exemptions
will be allowed to accumulate the total.


If Benefit Issue Month is less than 10/01/2003 and Exemption is blank
   increment 60 month count by one


If Benefit Issue Month is greater than or equal to 10/01/2003 increment 60 month count by one:



*/

--SET NOCOUNT ON
DECLARE @l_COUNT_MNTH_IN_FEDERRAL_SW VARCHAR(1)= 'N'
--DECLARE @INDV_ID INT = '100000645'


DECLARE @l_counter INT  = 0
DECLARE @l_Conv_Date DATE = dbo.F_GET_Conv_date()
--Print @l_Conv_Date

DECLARE @table TABLE(SEQ_ID INT IDENTITY(1,1), LIM_PID	INT, LIM_EXEMP	VARCHAR(2), LIM_BI_MON	DATETIME, 
LIM_PARENT_IND VARCHAR(1), 
LIM_DED_900	VARCHAR(1), LIM_INCL_CODE	VARCHAR(2), LIM_EXTEN VARCHAR(1))


DECLARE @l_LIM_PID	INT, @l_LIM_EXEMP	VARCHAR(2), @l_LIM_BI_MON	DATETIME, 
@l_LIM_PARENT_IND VARCHAR(1), 
@l_LIM_DED_900	VARCHAR(1), @l_LIM_INCL_CODE	VARCHAR(2), @l_LIM_EXTEN VARCHAR(1)

DECLARE @l_Loop INT, @l_Max INt 
--Get data from oldest to newest

INSERT INTO @table
SELECT LIM_PID, 
       CASE WHEN LTRIM(RTRIM(LIM_EXEMP)) = '' THEN NULL ELSE LIM_EXEMP END,  
       (LIM_BI_MON), 
	   LIM_PARENT_IND,
       CASE WHEN LTRIM(RTRIM(LIM_DED_900)) = '' THEN NULL ELSE LIM_DED_900 END,  
	   LIM_INCL_CODE, 
       CASE WHEN LTRIM(RTRIM(LIM_EXTEN)) = '' THEN NULL ELSE LIM_EXTEN END
from LAND.LAMI_LIMIT_AFDC
WHERE LIM_PID = @INDV_ID
ORDER BY LIM_BI_MON 
SELECT @l_Loop = 1, @l_Max  = @@ROWCOUNT

WHILE @l_Loop <= @l_Max
BEGIN --Loop


  --Get  data
  SELECT @l_LIM_EXEMP = LIM_EXEMP,
        @l_LIM_BI_MON = LIM_BI_MON,
		@l_LIM_PARENT_IND = LIM_PARENT_IND,
		@l_LIM_DED_900 = LIM_DED_900,
		@l_LIM_INCL_CODE = LIM_INCL_CODE,
		@l_LIM_EXTEN = LIM_EXTEN
  FROM @table 
  WHERE SEQ_ID = @l_Loop
 --Print @l_LIM_BI_MON

IF @l_counter =60 BREAK
 --Print 'Logic1'

 --Logic1:  If the parent indicator is an 'P' or 'A' with an inclusion code of '01'

  IF @l_LIM_PARENT_IND IN ('P','A') AND @l_LIM_INCL_CODE IN ('01') 
  BEGIN --Logic1
   SET @l_counter = @l_counter + 1
   END
   
 -- Cond1: If Benefit Issue Month is less than 10/01/2003 and Exemption is blank
 ELSE IF @l_LIM_BI_MON < '10/01/2003' AND (@l_LIM_EXEMP ='' OR @l_LIM_EXEMP IS NULL)

  SET @l_counter = @l_counter + 1

  --Cond2: If Benefit Issue Month is greater than or equal to 10/01/2003 increment 60 month count by one
  ELSE IF @l_LIM_BI_MON >= '10/01/2003' AND (@l_LIM_EXTEN='' OR @l_LIM_EXTEN IS NULL)
   SET @l_counter = @l_counter + 1


 --END --Logic1

  SET @l_Loop = @l_Loop + 1

  END --Loop

  IF @l_counter =60 SET @l_COUNT_MNTH_IN_FEDERRAL_SW = 'Y'

  RETURN @l_COUNT_MNTH_IN_FEDERRAL_SW
END --function


GO


CREATE FUNCTION [dbo].[F_GET_DC_INDV_HH_STAUS_IN_HOUSEHOLD_SW](@INDV_ID BIGINT, @CASNUM BIGINT) 
RETURNS VARCHAR(1)
BEGIN
DECLARE @l_IN_HOUSEHOLD_SW VARCHAR(1)= 'N'
/* 
Created: Venkata Nemani
Created date: Jan 12 2018
Purpose: Derive IN_HOUSEHOLD_SW based on CASE-PGM-MEM file
File Name : Group1 Functions

--Logic: If CASE-PGM-MEM.CPM-INCL-REASON="01" or "02", "03", "04" then Set to "Y" else "N"
*/


IF EXISTS (
SELECT cpm_PID, CPM_CID  --top 1 CPM_REL_TO_HH, CPM_INCL_CODE
from Land.LAMI_CASE_PGM_MEM(noloCK) b
WHERE b.cpm_PID =@INDV_ID
AND b.CPM_CID = @CASNUM
and CPM_INCL_CODE  IN ('01','02', '03', '04') 
)
SET @l_IN_HOUSEHOLD_SW = 'Y'

RETURN  @l_IN_HOUSEHOLD_SW

END



GO

create FUNCTION [dbo].F_GET_TC_TRANSACTIONS_COUNT_MNTH_IN_STATE_SW(@INDV_ID BIGINT)
RETURNS VARCHAR(1)
BEGIN --Main

/* 
Created: Venkata Nemani
Created date: Feb 09 2018
Purpose: Derive COUNT_MNTH_IN_STATE_SW based on CASE-PGM-MEM file
File Name : TC_TRANSACTIONS_Functions


Logic1:

Loop 144 times in reverse order from oldest to newest:

                        FOR #I1 = 144 TO 1 STEP -1

If Benefit Issue Month is more than 60 months, skip record:

                         IF LAMM10AG.LIM-BI-MON(#I1) LE #BI-DATE-MIN-60
                              ESCAPE TOP
                        END-IF

If Benefit Issue Month is less than 10/01/2003
   If Parent Indicator = "P" and Inclusion Code = "01" or "02" and Exemption not equal to "01"

       Check if 24 month limit has been reached and Exemption is blank
       Check if 900 Deduction = "Y" and Benefit Issue Month is greater than 06/30/1999

If both conditions False, increment 24 month limit count by one
   If 24 month limit count = 24 set flag to True:
   
Logic2:

If Benefit Issue Month is greater than or equal to 10/01/2003
   If Parent Indicator = "P" and Inclusion Code = "01" and Exemption not equal to "X1"

       Check if 24 month limit has been reached and Exemption is blank
       Check if 900 Deduction = "Y" and Benefit Issue Month is greater than 06/30/1999

If both conditions False, increment 24 month limit count by one
   If 24 month limit count = 24 set flag to True:
   


*/

--SET NOCOUNT ON
DECLARE @l_COUNT_MNTH_IN_STATE_SW VARCHAR(1)= 'N'
--DECLARE @INDV_ID INT = '100000645'


DECLARE @l_counter INT  = 0
DECLARE @l_Conv_Date DATE = dbo.F_GET_Conv_date()
--Print @l_Conv_Date

DECLARE @table TABLE(SEQ_ID INT IDENTITY(1,1), LIM_PID	INT, LIM_EXEMP	VARCHAR(2), LIM_BI_MON	DATETIME, 
LIM_PARENT_IND VARCHAR(1), 
LIM_DED_900	VARCHAR(1), LIM_INCL_CODE	VARCHAR(2), LIM_EXTEN VARCHAR(1))


DECLARE @l_LIM_PID	INT, @l_LIM_EXEMP	VARCHAR(2), @l_LIM_BI_MON	DATETIME, 
@l_LIM_PARENT_IND VARCHAR(1), 
@l_LIM_DED_900	VARCHAR(1), @l_LIM_INCL_CODE	VARCHAR(2), @l_LIM_EXTEN VARCHAR(1)

DECLARE @l_Loop INT, @l_Max INt 
--Get data from oldest to newest

INSERT INTO @table
SELECT LIM_PID, 
       CASE WHEN LTRIM(RTRIM(LIM_EXEMP)) = '' THEN NULL ELSE LIM_EXEMP END,  
       (LIM_BI_MON), 
	   LIM_PARENT_IND,
       CASE WHEN LTRIM(RTRIM(LIM_DED_900)) = '' THEN NULL ELSE LIM_DED_900 END,  
	   LIM_INCL_CODE, 
       CASE WHEN LTRIM(RTRIM(LIM_EXTEN)) = '' THEN NULL ELSE LIM_EXTEN END
from LAND.LAMI_LIMIT_AFDC
WHERE LIM_PID = @INDV_ID
ORDER BY LIM_BI_MON 
SELECT @l_Loop = 1, @l_Max  = @@ROWCOUNT

WHILE @l_Loop <= @l_Max
BEGIN --Loop


  --Get  data
  SELECT @l_LIM_EXEMP = LIM_EXEMP,
        @l_LIM_BI_MON = LIM_BI_MON,
		@l_LIM_PARENT_IND = LIM_PARENT_IND,
		@l_LIM_DED_900 = LIM_DED_900,
		@l_LIM_INCL_CODE = LIM_INCL_CODE,
		@l_LIM_EXTEN = LIM_EXTEN
  FROM @table 
  WHERE SEQ_ID = @l_Loop
 --Print @l_LIM_BI_MON

   --Step1: If Benefit Issue Month is more than 60 months, skip record:
 IF @l_LIM_BI_MON < DATEADD(MM, -60, dbo.F_GET_CONV_DATE() )
    GOTO NEXTREC

   --Logic1:  Benefit Issue Month is less than 10/01/2003
 IF @l_LIM_BI_MON < '10/01/2003'
 BEGIN --Logic1

 --Print 'Logic1'

 --Step2:    If Parent Indicator = "P" and Inclusion Code = "01" or "02" and Exemption not equal to "01"
  IF @l_LIM_PARENT_IND = 'P' AND @l_LIM_INCL_CODE IN ('01', '02') AND @l_LIM_EXEMP != '01'
  BEGIN --Step2
 -- Cond1: Check if 24 month limit has been reached and Exemption is blank
 IF (@l_LIM_EXEMP IS NULL OR @l_LIM_EXEMP = '') AND @l_counter >= 24
  GOTO NEXTREC

  --Cond2: Check if 900 Deduction = "Y" and Benefit Issue Month is greater than 06/30/1999
  IF (@l_LIM_DED_900 ='Y') AND @l_LIM_BI_MON > '06/30/1999' 
  GOTO NEXTREC

  SET @l_counter = @l_counter + 1
 END  --Step2

 END --Logic1


  --Logic2:  Benefit Issue Month is GTE  10/01/2003
 IF @l_LIM_BI_MON >= '10/01/2003'
 BEGIN --
Logic2

 --Step3:    If Parent Indicator = "P" and Inclusion Code = "01"  and Exemption not equal to "X1"
  IF @l_LIM_PARENT_IND = 'P' AND @l_LIM_INCL_CODE IN ('01') AND @l_LIM_EXEMP != 'X1'
 BEGIN --Step3
 -- Cond1: Check if 24 month limit has been reached and Exemption is blank
 IF (@l_LIM_EXEMP IS NULL OR @l_LIM_EXEMP = '') AND @l_counter >= 24
  GOTO NEXTREC

  --Cond2: Check if 900 Deduction = "Y" and Benefit Issue Month is greater than 06/30/1999
  IF (@l_LIM_DED_900 ='Y') AND @l_LIM_BI_MON > '06/30/1999' 
  GOTO NEXTREC

  SET @l_counter = @l_counter + 1

 END --Step3:



 --Print 'Logic2'
 END  --Logic2





  


  NEXTREC:
  SET @l_Loop = @l_Loop + 1

  END --Loop

  IF @l_counter =24 SET @l_COUNT_MNTH_IN_STATE_SW = 'Y'

  RETURN @l_COUNT_MNTH_IN_STATE_SW
END --function


GO
CREATE FUNCTION dbo.F_GET_INDV_INACTIVE_IND ( @CPM_PID VARCHAR(9))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_INACTIVE_IND VARCHAR(1) = 'N'

--Select * from iewp_ie_conv.dbo.Rt_PROGRAM_MV

IF EXISTS (SELECT CPM_PID FROM LAND.LAMI_CASE_PGM_MEM(NOLOCK) 
WHERE LTRIM(RTRIM(CPM_PID)) =LTRIM(RTRIM(@CPM_PID))
AND CPM_INCL_CODE = '05')
SET @l_INACTIVE_IND = 'Y'
 ELSE
 SET @l_INACTIVE_IND = 'N'

RETURN @l_INACTIVE_IND
END 


GO

CREATE FUNCTION dbo.F_GET_ARCHIVE_DATE()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE  @l_DATE VARCHAR(10) = '12/31/2999'


RETURN @l_DATE --cast(@l_DATE as VARCHAR(10))

END --


GO

CREATE FUNCTION [dbo].[F_GET_CASE_INDV_ACTIVE_IN_CASE_SW] ( @CPM_CID VARCHAR(9), @CPM_PID VARCHAR(9))
RETURNS VARCHAR(1)
BEGIN
--Logic:  IF CPM_INCL_CODE in '01' OR 02 THEN 'Y'    ELSE 'N'


--Used to populate ACTIVE_IN_CASE_SW in STAGE.DC_Case_Individual 

DECLARE @l_ACTIVE_IN_CASE_SW VARCHAR(1) --= 'N'

IF EXISTS (SELECT CPM_PID, CPM_CID FROM LAND.LAMI_CASE_PGM_MEM(NOLOCK) 
WHERE LTRIM(RTRIM(CPM_PID)) =LTRIM(RTRIM(@CPM_PID))
AND LTRIM(RTRIM(CPM_CID)) =LTRIM(RTRIM(@CPM_CID))
AND RTRIM(LTRIM(CPM_INCL_CODE)) IN ('01', '02')
) -- OR RTRIM(LTRIM(CPM_INCL_CODE)) ='02'))
SET @l_ACTIVE_IN_CASE_SW = 'Y'
 ELSE
 SET @l_ACTIVE_IN_CASE_SW = 'N'

RETURN @l_ACTIVE_IN_CASE_SW
END 

GO

CREATE FUNCTION dbo.F_GET_CONV_DATE()
RETURNS DATETIME2 --VARCHAR(20)
AS
BEGIN
DECLARE  @l_Conv_DATE DATETIME2


SELECT @l_Conv_DATE = DATA_CONVERSION_DATE
FROM CONV_ADMIN.DCM_DATA_CONVERSION_HEADER
WHERE DATA_CONVERSION_HEADER_ID = dbo.F_GET_HDR_ID() 
--(SELECT MAX(DATA_CONVERSION_HEADER_ID)
--FROM CONV_ADMIN.DCM_DATA_CONVERSION_HEADER)

RETURN @l_Conv_DATE --cast(@l_hdr_ID as VARCHAR)

END --


GO


CREATE FUNCTION [dbo].[F_GET_DC_DEMOGRAPHICS_IDENTIFICATION_VRF_CD](@INDV_ID BIGINT)
RETURNS VARCHAR(18)
BEGIN
DECLARE @l_CASE_IDENT_VER VARCHAR(2)
DECLARE @l_IDENTIFICATION_VRF_CD VARCHAR(18)

--USed: in IDENTIFICATION_VRF_CD for DC_DEMOGRAPHICS

--Reviewed with Rishi/Srini on Aug 17

--Select distinct IDENTIFICATION_VRF_CD from ie_ie_cnv_wp..DC_DEMOGRAPHICS

/*
SELECT  CASE_IDENT_VER, DBO.F_GET_REFERENCE_DATA ('IVER', CASE_IDENT_VER, 'IDVERIFICATION') AS IDENTIFICATION_VRF_CD 
FROM (
SELECT DISTINCT CASE_IDENT_VER
FROM LAND.LAMI_CASE (NOLOCK) 
WHERE CASE_IDENT_VER IS NOT NULL) A;

*/

Select @l_CASE_IDENT_VER = (SELECT top 1 CASE_IDENT_VER 
 from Land.LAMI_Member(NOLOCK)  A
 Join Land.LAMI_CASE_PGM_MEM(NOLOCK) B on b.cpm_PID = A.Mem_Pid
 Join Land.LAMI_Case(NOLOCK) C on C.CASE_CID = b.CPM_CID
  Where Mem_PID = @INDV_ID --100000001
  ORDER BY CPM_STAT_DATE DESC
  )


  --CREATE INDEX IX_LAMI_CASE_PGM_MEM_cpm_PID ON Land.LAMI_CASE_PGM_MEM (cpm_PID)

SET @l_IDENTIFICATION_VRF_CD = CASE @l_CASE_IDENT_VER 
          -- WHEN '' THEN NULL
		   WHEN '01' THEN 'BC'
			WHEN '02' THEN 'DL'
			WHEN '03' THEN 'VR'
			WHEN '04' THEN 'OF'
			WHEN '05' THEN 'DL'
			WHEN '06' THEN 'IN'
			WHEN '50' THEN 'CC' 
			WHEN '61' THEN 'OF' 
			WHEN '65' THEN 'SS' 
			WHEN '80' THEN 'OT' 
			WHEN '98' THEN 'PV'
			ELSE NULL
			END


RETURN  @l_IDENTIFICATION_VRF_CD

END 

GO

CREATE FUNCTION dbo.F_GET_CONV_FIRST_DATE()
RETURNS VARCHAR(20)
AS
BEGIN
DECLARE  @l_Conv_DATE DATE
DECLARE  @l_Conv_first_DATE DATE


--SELECT @l_Conv_DATE = DATA_CONVERSION_DATE --DATEADD(m, DATEDIFF(m, 0, DATA_CONVERSION_DATE), 0)  
--FROM CONV_ADMIN.DCM_DATA_CONVERSION_HEADER
--WHERE DATA_CONVERSION_HEADER_ID = (SELECT MAX(DATA_CONVERSION_HEADER_ID)
--FROM CONV_ADMIN.DCM_DATA_CONVERSION_HEADER)

SELECT @l_Conv_DATE = dbo.F_GET_CONV_DATE()
SET @l_Conv_first_DATE = DATEADD(m, DATEDIFF(m, 0, @l_Conv_DATE), 0)  

RETURN @l_Conv_first_DATE --cast(@l_hdr_ID as VARCHAR)

END --


GO


CREATE FUNCTION [dbo].[F_GET_DC_INDV_LIVING_ARNGMNTS_LA_TYPE_CD](@INDV_ID BIGINT)
RETURNS VARCHAR(10)
BEGIN
DECLARE @l_LA_TYPE_CD VARCHAR(10) 

DECLARE @CPM_LIVING_ARRANG VARCHAR(10) 

--SELECT distinct CPM_LIVING_ARRANG from LAND.LAMI_CASE_PGM_MEM
/*
SELECT  CPM_LIVING_ARRANG, DBO.F_GET_REFERENCE_DATA ('LIVE', CPM_LIVING_ARRANG, 'LIVINGARRANGEMENTYPE') AS LA_TYPE_CD 
FROM (
SELECT DISTINCT CPM_LIVING_ARRANG
FROM LAND.LAMI_CASE_PGM_MEM (NOLOCK) 
WHERE CPM_LIVING_ARRANG IS NOT NULL) A;

03	ME
99	OIF
01	HO
04	DV
05	HHS
02	AJC
*/
--RT Mapping. LIVE table.    If null, default to "01" (In Home)	LAMI	CASE-PGM-MEM	CPM-LIVING-ARRANG

SELECT @CPM_LIVING_ARRANG = ISNULL(CPM_LIVING_ARRANG, '01')
FROM (
SELECT distinct   CPM_LIVING_ARRANG
from Land.LAMI_CASE_PGM_MEM(noloCK) b
WHERE b.cpm_PID = @INDV_ID
) A


SET @l_LA_TYPE_CD = CASE @CPM_LIVING_ARRANG 
   WHEN '01' THEN 'HO'
   WHEN '02' THEN 'AJC'
   WHEN '03' THEN 'ME'
   WHEN '04' THEN 'DV'
   WHEN '05' THEN 'HHS'
   WHEN '99' THEN 'OIF'
   else 'XX'
   END


RETURN  @l_LA_TYPE_CD

END


GO

CREATE FUNCTION [dbo].[F_GET_CONV_USER]()
RETURNS VARCHAR(30)
AS
BEGIN
DECLARE  @l_Conv_USER VARCHAR(50)



SELECT @l_Conv_USER = 'CONVERSION_USER_' + Cast(dbo.F_GET_HDR_ID() as VARCHAR(3))

RETURN @l_Conv_USER

END --


GO
CREATE FUNCTION dbo.F_GET_PREPARES_AND_PURCHASES_SW(@CPM_CID INT, @CPM_PID_A INT, @CPM_PID_B INT)


RETURNS VARCHAR(1)
BEGIn
DECLARE @l_PREPARES_AND_PURCHASES_SW varchar(1)

DECLARE @CPM_INCL_CODE_A VARCHAR(2), @CPM_INCL_CODE_B VARCHAR(2)


SELECT top 1 @CPM_INCL_CODE_A = CPM_INCL_CODE
FROM LAND.LAMI_CASE_PGM_MEM(NOLOCK) A
WHERE CPM_CID = @CPM_CID AND CPM_PID = @CPM_PID_A


SELECT top 1 @CPM_INCL_CODE_B = CPM_INCL_CODE
FROM LAND.LAMI_CASE_PGM_MEM(NOLOCK) B
WHERE CPM_CID = @CPM_CID AND CPM_PID = @CPM_PID_B

SET @l_PREPARES_AND_PURCHASES_SW = 
CASE 
WHEN @CPM_INCL_CODE_A = '01' AND @CPM_INCL_CODE_B = '01' THEN 'Y'
WHEN @CPM_INCL_CODE_A = '01' AND @CPM_INCL_CODE_B = '02' THEN 'Y'
WHEN @CPM_INCL_CODE_A = '01' AND @CPM_INCL_CODE_B = '04' THEN 'Y'
WHEN @CPM_INCL_CODE_A = '02' AND @CPM_INCL_CODE_B = '02' THEN 'Y'
WHEN @CPM_INCL_CODE_A = '02' AND @CPM_INCL_CODE_B = '04' THEN 'Y'
WHEN @CPM_INCL_CODE_A = '04' AND @CPM_INCL_CODE_B = '04' THEN 'Y'
ELSE 'N'
END 

RETURN @l_PREPARES_AND_PURCHASES_SW
END 


GO
CREATE FUNCTION dbo.F_GET_REFERENCE_DATA (@Legacy_Table VARCHAR(200), @Legacy_Code VARCHAR(200), @IE_Code VARCHAR(200) = NULL)
RETURNS VARCHAR(200)
BEGIN

DECLARE @l_IE_Reference_Code VARCHAR(200)

IF @IE_Code IS  NULL
SELECT @l_IE_Reference_Code = IE_Code
FROM ie_ie_cnv.STAGE.LANDING_STAGE_REFERENCE_TABLE_DATA
WHERE Legacy_Table_Name = LTRIM(RTRIM(@Legacy_Table)) 
AND Legacy_Code = LTRIM(RTRIM(@Legacy_Code))

ELSE
SELECT @l_IE_Reference_Code = IE_Code
FROM ie_ie_cnv.STAGE.LANDING_STAGE_REFERENCE_TABLE_DATA
WHERE Legacy_Table_Name = LTRIM(RTRIM(@Legacy_Table)) 
AND Legacy_Code = LTRIM(RTRIM(@Legacy_Code))
AND IE_Reference_Table_Name = LTRIM(RTRIM(@IE_Code))


RETURN @l_IE_Reference_Code

END 


GO




CREATE FUNCTION [dbo].[F_GET_ED_PART_STATUS_CD] (@INDV_ID BIGINT, @Incl_Code VARCHAR(2))
RETURNS VARCHAR(4)
BEGIN
/*
--Dscussed with ND and get it for the below logic 
Select * from iewp_ie_State..RT_EDPRTSTSCD_MV
EA	Eligible Adult
XC	Excluded Child
EC	Eligible Child
XA	Excluded Adult
IA	Ineligible Adult
CI	Ineligible Child


--Logic
01		EA/EC based on age
02	IA/IC based on age
03	XA/XC based on age
04	XA/XC based on age
05  XA/XC based on age

Definition: ND Confirmed
Child: Age 17 and under 
Parent: Above or Equal Age 18  

*/
DECLARE @l_Age INt

DECLARE @l_ED_PART_STATUS_CD  VARCHAR(2) = 'XX'
--Select * from ie_ie_cnv_wp.dbo.Rt_DICASESTATUS_MV
--AP, DN, PE, TN


--Get Age
SELECT @l_Age = dbo.F_GET_MEMBER_AGE(DOB_DT)
FROM Stage.DC_INDV 
WHERE INDV_ID = @INDV_ID

IF @l_Age <= 17 --Cheld
SET @l_ED_PART_STATUS_CD = Case 
	WHEN @Incl_Code ='01' THEN 'EC'
	WHEN @Incl_Code ='02' THEN 'CI'   -- 09/04/2018 - REPLACED 'IC' BY 'CI' -- IESDLCP-37598
	WHEN @Incl_Code ='03' THEN 'XC'
	WHEN @Incl_Code ='04' THEN 'XC'
	WHEN @Incl_Code ='05' THEN 'XC'
	ELSE 'XX' END
ELSE
SET @l_ED_PART_STATUS_CD = Case 
	WHEN @Incl_Code ='01' THEN 'EA'
	WHEN @Incl_Code ='02' THEN 'IA'
	WHEN @Incl_Code ='03' THEN 'XA'
	WHEN @Incl_Code ='04' THEN 'XA'
	WHEN @Incl_Code ='05' THEN 'XA'
	ELSE 'XX' END


RETURN @l_ED_PART_STATUS_CD

END 




GO

CREATE FUNCTION dbo.F_GET_DATE(@Date_String VARCHAR(8))
RETURNS DATETIME2
BEGIN
DECLARE @l_Date DATETIME2 = NULL

IF ISDATE(LTRIM(RTRIM(@Date_String))) = 1 AND LEN(LTRIM(RTRIM(@Date_String))) = 8
--DECLARE @MEM_DATE_OF_DEATH VARCHAR(8) = '20070801'
SET @l_Date =  CAST (LTRIM(RTRIM(@Date_String)) AS DATETIME2)

--IF @l_Date = '1900-01-01 00:00:00.0000000' SET @l_Date = NULL

RETURN @l_Date
END --Function


GO



CREATE FUNCTION [dbo].[F_GET_TYPE_OF_ASSISTANCE_CD] (@PROGRAM_CD VARCHAR(4))
RETURNS VARCHAR(4)
BEGIN
/*
--Dscussed with ND and get it for the belwo ref table 
Select Code, PROGRAMCD from RT_EDTOA_MV

TP09	01 --FS
TP01	02- TF
TP20	03 --UP
TP30	04 --CA
*/


DECLARE @l_TYPE_OF_ASSISTANCE_CD  VARCHAR(5) = 'XX'
--Select * from ie_ie_cnv_wp.dbo.Rt_DICASESTATUS_MV
--AP, DN, PE, TN


SELECT @l_TYPE_OF_ASSISTANCE_CD = CASE
    WHEN  @PROGRAM_CD = 'FS'  THEN 'TP09' --FS
    WHEN  @PROGRAM_CD = 'TF'  THEN 'TP01' 
    WHEN  @PROGRAM_CD = 'UP'  THEN 'TP20'
    WHEN  @PROGRAM_CD = 'CA'  THEN 'TP30'
	ELSE 'XX' END 

RETURN @l_TYPE_OF_ASSISTANCE_CD

END 



GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_COUNT_OF_CG_CHILD (@CASE_NUM INT)
RETURNS VARCHAR(4)
BEGIN
/*
Created By: Venkata Nemani
Group: Group7
Created date: 01/24/2018

Description: Function to get MIGRANT_HOUSEHOLD_SW for ED_ELIGIBILITY tables based logic below
Logic: Add all the CASE PGM MEMBER who are less than 18 years using their DOB  with Inclusion code="01"



Sample age calc:
DECLARE @dob  datetime
SET @dob='2002-05-09 00:00:00'
SELECT DATEDIFF(YEAR, '0:0', getdate()-DOB_DT)

*/

DECLARE @l_COUNT_OF_CG_CHILD INT = 0
DECLARE @l_get_date DATETIME = getdate()  


SELECT @l_COUNT_OF_CG_CHILD = Count(1)
FROM (
SELECT distinct CPM_CID, INDV_ID, cast(DOB_DT as Date) DOB_DT,  DATEDIFF(YEAR, '0:0', @l_get_date- cast(DOB_DT as DateTIME)) Age
FROM LAND.LAMI_CASE_PGM_MEM(NOLOCK) A
JOIN STAGE.DC_INDV(NOLOCK) B on CPM_PID = INDV_ID 
Where CPM_INCL_CODE = '01' --and CPM_REL_TO_HH = '01'
and CPM_CID = @CASE_NUM
AND DATEDIFF(YEAR, '0:0', @l_get_date- cast(DOB_DT as DateTIME)) < 18
)A 


RETURN @l_COUNT_OF_CG_CHILD
END 


GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_COUNT_OF_CG_ADULTS (@CASE_NUM INT)
RETURNS VARCHAR(4)
BEGIN

/*
Created By: Venkata Nemani
Group: Group7
Created date: 01/24/2018

Description: Function to get MIGRANT_HOUSEHOLD_SW for ED_ELIGIBILITY tables based logic below

Logic: Add all the CASE PGM MEMBER who are equal to or greater than 18 years using their DOB with Inclusion code="01". 
       If the Individual under the age of 18 
      and Relationship to Head of household="01" then they are counted towards adult group.		

SELECT * from LAND.LAMI_MEMBER  

Sample age calc:
DECLARE @dob  datetime
SET @dob='2002-05-09 00:00:00'
SELECT DATEDIFF(YEAR, '0:0', getdate()-DOB_DT)

*/

DECLARE @l_COUNT_OF_CG_ADULTS INT = 0
DECLARE @l_get_date DATETIME = getdate()  


SELECT @l_COUNT_OF_CG_ADULTS = Count(1)
FROM (
SELECT distinct CPM_CID, INDV_ID, cast(DOB_DT as Date) DOB_DT,  DATEDIFF(YEAR, '0:0', @l_get_date- cast(DOB_DT as DateTIME)) Age
FROM LAND.LAMI_CASE_PGM_MEM(NOLOCK) A
JOIN STAGE.DC_INDV(NOLOCK) B on CPM_PID = INDV_ID 
Where CPM_INCL_CODE = '01' and CPM_REL_TO_HH = '01'
and CPM_CID = @CASE_NUM
AND DATEDIFF(YEAR, '0:0', @l_get_date- cast(DOB_DT as DateTIME)) >= 18
)A 


RETURN @l_COUNT_OF_CG_ADULTS
END 


GO




CREATE FUNCTION [dbo].[F_GET_HDR_ID]()
RETURNS INT
AS
BEGIN
DECLARE  @l_hdr_ID INt



SELECT @l_Hdr_ID = MAX(DATA_CONVERSION_HEADER_ID)
FROM CONV_ADMIN.DCM_DATA_CONVERSION_HEADER
Where CONVERSION_TYPE = 'STATE'


RETURN @l_hdr_ID --cast(@l_hdr_ID as VARCHAR)

END --



--ALTER TABLE LEGACY_RECON drop constraint DF__LEGACY_RE__HDR_I__4DD54A14;




GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_COMP_ELIG_RSLT_CD (@PGM_STATUS VARCHAR(4), @CP_CLOSURE_CD VARCHAR(10))
RETURNS VARCHAR(4)
BEGIN
DECLARE @l_COMP_ELIG_RSLT_CD  VARCHAR(5) --= 'CV'

/*

Descr: Function to get no financila Eligibility detais for ED_ELIGIBILITY tables based on excel (LEGACY_Eligibility_Closure_Code)
*/

IF @PGM_STATUS = 'AP' SET @l_COMP_ELIG_RSLT_CD = 'PS'
ELSE
BEGIN

IF EXISTS (SELECT * from LEGACY_Eligibility_Closure_Code Where Failure_Type = 'Compliance'
AND Rejection_Closure_Code =@CP_CLOSURE_CD ) 
SET @l_COMP_ELIG_RSLT_CD = 'FL'
END  

RETURN @l_COMP_ELIG_RSLT_CD
END 


GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_NF_ELIG_RSLT_CD (@PGM_STATUS VARCHAR(4), @CP_CLOSURE_CD VARCHAR(10))
RETURNS VARCHAR(4)
BEGIN
DECLARE @l_NF_ELIG_RSLT_CD  VARCHAR(5) --= 'CV'

/*

Descr: Function to get no financila Eligibility detais for ED_ELIGIBILITY tables based on excel (LEGACY_Eligibility_Closure_Code)
*/

IF @PGM_STATUS = 'AP' SET @l_NF_ELIG_RSLT_CD = 'PS'
ELSE
BEGIN

IF EXISTS (SELECT 1 from LEGACY_Eligibility_Closure_Code(NOLOCK) Where Failure_Type = 'Non-Financial'
AND Rejection_Closure_Code =@CP_CLOSURE_CD ) 
SET @l_NF_ELIG_RSLT_CD = 'FL'
END  

RETURN @l_NF_ELIG_RSLT_CD
END 


GO
CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_FIN_ELIG_RSLT_CD (@PGM_STATUS VARCHAR(4), @CP_CLOSURE_CD VARCHAR(10))
RETURNS VARCHAR(4)
BEGIN
DECLARE @l_FIN_ELIG_RSLT_CD  VARCHAR(5) --= 'CV'

/*

Descr: Function to get  financial Eligibility detais for ED_ELIGIBILITY tables based on excel (LEGACY_Eligibility_Closure_Code)
*/

IF @PGM_STATUS = 'AP' SET @l_FIN_ELIG_RSLT_CD = 'PS'
ELSE
BEGIN

IF EXISTS (SELECT 1 from LEGACY_Eligibility_Closure_Code(NOLOCK) Where Failure_Type = 'Financial'
AND Rejection_Closure_Code =@CP_CLOSURE_CD ) 
SET @l_FIN_ELIG_RSLT_CD = 'FL'
END  

RETURN @l_FIN_ELIG_RSLT_CD
END 


GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_RSC_ELIG_RSLT_CD (@PGM_STATUS VARCHAR(4), @CP_CLOSURE_CD VARCHAR(10))
RETURNS VARCHAR(4)
BEGIN
DECLARE @l_RSC_ELIG_RSLT_CD  VARCHAR(5) --= 'CV'

/*

Descr: Function to get  financial Eligibility detais for ED_ELIGIBILITY tables based on excel (LEGACY_Eligibility_Closure_Code)
*/

IF @PGM_STATUS = 'AP' SET @l_RSC_ELIG_RSLT_CD = 'PS'
ELSE
BEGIN

IF EXISTS (SELECT 1 from LEGACY_Eligibility_Closure_Code Where Failure_Type = 'Resources'
AND Rejection_Closure_Code =@CP_CLOSURE_CD ) 
SET @l_RSC_ELIG_RSLT_CD = 'FL'
END  

RETURN @l_RSC_ELIG_RSLT_CD
END 


GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_VERIFICATION_STATUS_CD (@PGM_STATUS VARCHAR(4), @CP_CLOSURE_CD VARCHAR(10))
RETURNS VARCHAR(4)
BEGIN
DECLARE @l_VERIFICATION_STATUS_CD  VARCHAR(5) --= 'CV'

/*

Descr: Function to get  financial Eligibility detais for ED_ELIGIBILITY tables based on excel (LEGACY_Eligibility_Closure_Code)
*/

IF @PGM_STATUS = 'AP' SET @l_VERIFICATION_STATUS_CD = 'PS'
ELSE
BEGIN

IF EXISTS (SELECT 1 from LEGACY_Eligibility_Closure_Code(NOLOCK) Where Failure_Type = 'Verification'
AND Rejection_Closure_Code =@CP_CLOSURE_CD ) 
SET @l_VERIFICATION_STATUS_CD = 'FL'
END  

RETURN @l_VERIFICATION_STATUS_CD
END 


GO
CREATE FUNCTION dbo.F_GET_EFIP_ELIG_SW_ED_ELIGILITY ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_EFIP_ELIG_SW  VARCHAR(1) = 'N'

/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_EFIP_ELIG_SW_ED_ELIGILITY.sql
Purpose: FN to get EFIP_ELIG_SW from  lami_CASE_PGM_MEM table

Logic:

EFIP_ELIG_SW	If CPM-LIM-EXTEN is not null, set to "Y"; else set to "N"	CASE-PGM-MEM	CPM-LIM-EXTEN

CREATE CLUSTERED INDEX CIX_LAMI_CASE_PGM_MEM ON LAND.lami_CASE_PGM_MEM(CPM_CID, CPM_PID)

*/


if exists (select 1 from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND LTRIM(RTRIM(CPM_LIM_EXTEN)) != '')
SET @l_EFIP_ELIG_SW = 'Y'


RETURN @l_EFIP_ELIG_SW

END 


GO
CREATE FUNCTION dbo.F_GET_ABAWD_SW_ED_ELIGILITY ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_ABAWD_SW  VARCHAR(1) = 'N'

/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_ABAWD_SW_ED_ELIGILITY.sql
Purpose: FN to get ABAWD_SW from  lami_CASE_PGM_MEM table

Logic:

ABAWD_SW	If Y, set to "Y", else set to NULL.	CASE-PGM-MEM	CPM-ABAWD-IND
*/


if exists (select 1 from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND CPM_ABAWD_IND = 'Y')
SET @l_ABAWD_SW = 'Y'


RETURN @l_ABAWD_SW

END 


GO

CREATE FUNCTION [dbo].[F_GET_EDG_SIZE_ED_ELIGILITY] ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS INT
BEGIN

DECLARE @l_EDG_SIZE INT = 0
/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_EDG_SIZE_ED_ELIGILITY.sql
Purpose: FN to get EDG_SIZE from  lami_CASE_PGM_MEM table

Logic:

EDG_SIZE	COUNT of number of individuals on the CASE PGM MEM for the CERT with INCLUSION CODE "01" or "02" "03" "04"(Derived from the Household Composition Ruleset )	CASE-PGM-MEM	CPM-PID

07/20/2018 BY Srinivas Poojari 
Change - replaced CPM_INCL_REASON by CPM_INCL_CODE

*/


SELECT @l_EDG_SIZE =  (select Count(1) from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND CPM_INCL_CODE IN ( '01', '02', '03', '04')) --CPM_INCL_REASON IN ( '01', '02', '03', '04'))


RETURN @l_EDG_SIZE

END 



GO


CREATE FUNCTION [dbo].[F_GET_ECTRACT_DATE]()
RETURNS DATETIME2 --VARCHAR(20)
AS
BEGIN
DECLARE  @l_Conv_DATE DATETIME2


SELECT @l_Conv_DATE = DATA_EXTRACT_DATE
FROM CONV_ADMIN.DCM_DATA_CONVERSION_HEADER
WHERE DATA_CONVERSION_HEADER_ID = dbo.F_GET_HDR_ID() 

RETURN @l_Conv_DATE --cast(@l_hdr_ID as VARCHAR)

END --



GO
CREATE FUNCTION dbo.F_GET_FS_ELD_DIS_GROUP_SW_ED_ELIGILITY ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_FS_ELD_DIS_GROUP_SW VARCHAR(1)= 'N'
/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_FS_ELD_DIS_GROUP_SW_ED_ELIGILITY.sql
Purpose: FN to get FS_ELD_DIS_GROUP_SW from  lami_CASE_PGM_MEM table

Logic:

FS_ELD_DIS_GROUP_SW	Set to "Y" for CPM-WORK-REG-CODE="17"	CASE-PGM-MEM	CPM-WORK-REG-CODE



*/

if exists (select 1 from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND CPM_WORK_REG_CODE = '17')
SET @l_FS_ELD_DIS_GROUP_SW = 'Y'


RETURN @l_FS_ELD_DIS_GROUP_SW

END 


GO
CREATE FUNCTION dbo.F_GET_HOMELESS_HOUSEHOLD_SW_ED_ELIGILITY ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_HOMELESS_HOUSEHOLD_SW VARCHAR(1)= 'N'
/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_HOMELESS_HOUSEHOLD_SW_ED_ELIGILITY.sql
Purpose: FN to get HOMELESS_HOUSEHOLD_SW from  lami_CASE_PGM_MEM table

Logic:

HOMELESS_HOUSEHOLD_SW	When all Individuals in the case have living arrangement ="05", set to Y.	CASE-PGM-MEM	CPM-LIVING-ARRANG


*/

if exists (select 1 from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND CPM_LIVING_ARRANG = '05')
SET @l_HOMELESS_HOUSEHOLD_SW = 'Y'


RETURN @l_HOMELESS_HOUSEHOLD_SW

END 


GO

CREATE FUNCTION [dbo].F_GET_ED_ELIGIBILITY_MIGRANT_HOUSEHOLD_SW (@INDV_ID INT)
RETURNS VARCHAR(4)
BEGIN
DECLARE @l_MIGRANT_HOUSEHOLD_SW  VARCHAR(1) = 'N'

/*
  Created By: Venkata Nemani
  Group: Group7
  Created date: 01/24/2018

Descr: Function to get MIGRANT_HOUSEHOLD_SW for ED_ELIGIBILITY tables based logic below

Logic: set to "Y" when "2" or "3"; else set to N	LAMI	MEMBER	MEM-WORKER-STAT

SELECT distinct MEM_WORKER_STAT from LAND.LAMI_MEMBER  
SELECT * from LAND.LAMI_MEMBER  

*/


IF EXISTS (SELECT 1 from LAND.LAMI_MEMBER (NOLOCK) 
Where CAST(LTRIM(RTRIM(MEM_PID)) as INT) = @INDV_ID 
AND LTRIM(RTRIM(MEM_WORKER_STAT)) IN ('2', '3'))
SET @l_MIGRANT_HOUSEHOLD_SW = 'Y'


RETURN @l_MIGRANT_HOUSEHOLD_SW
END 


GO
CREATE FUNCTION dbo.F_GET_SNG_PAR_CH_UNDER6_SW_ED_ELIGILITY ( @CID VARCHAR(9), @PGM_CAT VARCHAR(4), @PGM_TYPE VARCHAR(2))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_SNG_PAR_CH_UNDER6_SW VARCHAR(1)= 'N'
/*
Created By: Venkata Nemani
Created date: Jan 4th 2018
File Name: F_GET_SNG_PAR_CH_UNDER6_SW_ED_ELIGILITY.sql
Purpose: FN to get SNG_PAR_CH_UNDER6_SW from  lami_CASE_PGM_MEM table

Logic:

SNG_PAR_CH_UNDER6_SW	Set to Y where CPM-WORK-REG-CODE ="04"	CASE-PGM-MEM	CPM-WORK-REG-CODE

*/

if exists (select 1 from LAND.lami_CASE_PGM_MEM(NOLOCK) a
where CPM_CID = @CID AND CPM_PGM_CAT = @PGM_CAT
AND CPM_PGM_TYPE = @PGM_TYPE
AND CPM_WORK_REG_CODE = '05')
SET @l_SNG_PAR_CH_UNDER6_SW = 'Y'


RETURN @l_SNG_PAR_CH_UNDER6_SW

END 


GO

CREATE FUNCTION [dbo].[F_GET_CASE_PROGRAM_PROG_CD] ( @CP_PGM_TYPE VARCHAR(20))
RETURNS VARCHAR(20)
BEGIN

DECLARE @l_Case_PROG_CD  VARCHAR(10) = NULL
--AS PER DISCUSSION WITH AXIT RT_PROGRAMS_MV IS THE REF TABLE
--Select * from ie_ie_cnv_wp.dbo.Rt_PROGRAM_MV
--SElect Distinct CP_PGM_TYPE from Land.LAMI_CASE_PGM

SELECT @l_Case_PROG_CD = CASE

    WHEN  @CP_PGM_TYPE = 'BA'  THEN 'TF' --FITAP
    WHEN  @CP_PGM_TYPE = 'NP'  THEN 'FS' --SNAP
    WHEN  @CP_PGM_TYPE = 'PA'  THEN 'FS' --SNAP
    WHEN  @CP_PGM_TYPE = 'UP'  THEN 'UP' --KCSP
	WHEN  @CP_PGM_TYPE = 'CA'  THEN 'CA' --LACAP
	ELSE 'XX' END 

RETURN @l_Case_PROG_CD
END 


GO
--DROP FUNCTION [dbo].[F_GET_DC_INDV_ABAWD_END_DATE]
CREATE FUNCTION [dbo].[F_GET_DC_INDV_ABAWD_END_DATE]( @pi_INDV_ID INT)
RETURNS DATETIME2
BEGIN

DECLARE @l_END_DATE DATETIME2 = NULL

SELECT @l_END_DATE = CPM.CPM_STAT_DATE
FROM STAGE.DC_CASES(Nolock) A
JOIN STAGE.DC_CASE_INDIVIDUAL(NOLOCK) B on A.CASE_NUM = B.CASE_NUM 
JOIN LAND.LAMI_CASE_PGM_MEM(NOLOCK) CPM ON CPM.CPM_CID = B.CASE_NUM  AND CPM_PID = b.INDV_ID 
Where CASE_STATUS_CD IN ('DN', 'TN')
AND B.INDV_ID = @pi_INDV_ID
AND EXISTS (SELECT 1 FROM STAGE.DC_CASES(Nolock) E WHERE E.case_Num = A.Case_NUM AND CASE_STATUS_CD NOT IN ('DN', 'TN')) 


 RETURN @l_END_DATE
END



GO

CREATE FUNCTION dbo.F_GET_CREATE_DATE()
RETURNS DATETIME2
AS
BEGIN
DECLARE  @l_DATE DATETIME2 = Getdate()


RETURN @l_DATE --cast(@l_DATE as VARCHAR(10))

END --


GO
CREATE FUNCTION dbo.F_GET_RELATIOIN_SHIP_CODE(@REL_TO_HH VARCHAR(2), @REF_REL_TO_HH VARCHAR(2))
RETURNS VARCHAR(10)
BEGIn
DECLARE @l_Rel_Code varchar(10)

SET @l_Rel_Code = CASE 

           WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '09' THEN 'STC'
           WHEN @REL_TO_HH = '09' AND @REF_REL_TO_HH = '01' THEN 'STP'
		   

		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '14' THEN 'SPS'
		   WHEN @REL_TO_HH = '14' AND @REF_REL_TO_HH = '01' THEN 'SPS'

           WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '15' THEN 'SPS'	
		   WHEN @REL_TO_HH = '15' AND @REF_REL_TO_HH = '01' THEN 'SPS'

		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '16' THEN 'SPS'
		   WHEN @REL_TO_HH = '16' AND @REF_REL_TO_HH = '01' THEN 'SPS'
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '17' THEN 'SPS'
		   WHEN @REL_TO_HH = '17' AND @REF_REL_TO_HH = '01' THEN 'SPS'

		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '27' THEN 'PA'
           WHEN @REL_TO_HH = '27' AND @REF_REL_TO_HH = '01' THEN 'CH'
           
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '30' THEN 'PA'
           WHEN @REL_TO_HH = '30' AND @REF_REL_TO_HH = '01' THEN 'CH'
           
		   --WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '31' THEN 'PA'
           --WHEN @REL_TO_HH = '31' AND @REF_REL_TO_HH = '01' THEN 'CH'
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '32' THEN 'GP'
           WHEN @REL_TO_HH = '32' AND @REF_REL_TO_HH = '01' THEN 'GC'
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '34' THEN 'AU'
           WHEN @REL_TO_HH = '34' AND @REF_REL_TO_HH = '01' THEN 'NN'

		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '35' THEN 'CO'
           WHEN @REL_TO_HH = '35' AND @REF_REL_TO_HH = '01' THEN 'CO'
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '37' THEN 'OR'
           WHEN @REL_TO_HH = '37' AND @REF_REL_TO_HH = '01' THEN 'OR'
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '38' THEN 'NR'
           WHEN @REL_TO_HH = '38' AND @REF_REL_TO_HH = '01' THEN 'NR'
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '40' THEN 'FP'
           WHEN @REL_TO_HH = '40' AND @REF_REL_TO_HH = '01' THEN 'FC'
		             
		   
		   WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '59' THEN 'GC'
           WHEN @REL_TO_HH = '59' AND @REF_REL_TO_HH = '01' THEN 'GP'
		   
		   --WHEN @REL_TO_HH = '01' AND @REF_REL_TO_HH = '60' THEN 'CV'
           --WHEN @REL_TO_HH = '60' AND @REF_REL_TO_HH = '01' THEN 'CV'

      ELSE 'CV'
      END 

RETURN @l_Rel_Code

END 


GO

CREATE FUNCTION [dbo].[F_GET_MEMBER_AGE]( @pi_DOB_DT DATETIME2(0))
RETURNS INT
BEGIN

DECLARE @l_Age  INT = 0
DECLARE @GetDate DATE = GETDATE()
SELECT @l_Age = DATEDIFF(yy,CONVERT(DATETIME, @pi_DOB_DT),@GetDate) 
 RETURN @l_Age
END




GO



CREATE FUNCTION [dbo].[F_GET_REFERENCE_DATA_CAFE] (@Legacy_Table VARCHAR(200), @Legacy_Code VARCHAR(200), @IE_Code VARCHAR(200) = NULL)
RETURNS VARCHAR(200)
BEGIN

DECLARE @l_IE_Reference_Code VARCHAR(200)

IF @IE_Code IS  NULL
SELECT @l_IE_Reference_Code = [IE Code]
FROM ie_ie_cnv.STAGE.LANDING_STAGE_REFERENCE_TABLE_SUBSYSTEM_DATA(NOLOCK)
WHERE [Legacy Table Description] = LTRIM(RTRIM(@Legacy_Table)) 
AND [Legacy Code] = LTRIM(RTRIM(@Legacy_Code))

ELSE
SELECT @l_IE_Reference_Code = [IE Code]
FROM ie_ie_cnv.STAGE.LANDING_STAGE_REFERENCE_TABLE_SUBSYSTEM_DATA(NOLOCK)
WHERE [Legacy Table Description] = LTRIM(RTRIM(@Legacy_Table)) 
AND [Legacy Code] = LTRIM(RTRIM(@Legacy_Code))
AND [IE Reference Table Name] = LTRIM(RTRIM(@IE_Code))


RETURN @l_IE_Reference_Code

END 






GO
--DROP FUNCTION [dbo].[F_GET_DISB_CRITERIA_CD] 
CREATE FUNCTION [dbo].[F_GET_DISB_CRITERIA_CD] ( @Legacy_Code VARCHAR(200))
RETURNS VARCHAR(35)
BEGIN

DECLARE @l_IE_Reference_Code VARCHAR(200)

SELECT @l_IE_Reference_Code = CASE  @Legacy_Code 
   WHEN '03' THEN 'NFD'
   WHEN '14' THEN 'SSI'
WHEN '15' THEN 'SSI'
WHEN '16' THEN 'SSI'
WHEN '17' THEN 'SCV'
WHEN '22' THEN 'SCV'
ELSE NULL
END 

   /*
   Populate for every record in CASE-PGM-MEM if WORK-REG-CODE is “03”, “14”, “15” “16”, "17", and  “22”.
   Work Registration Code 03= No federal disability payment received
·       If the client has a code ‘03’ and over age 60 then the criteria should be = Receives or has been approved to receive Social Security Disability or Blindness benefits.
Work Registration Code 14= Receives or has been approved to receive Social Security Disability or Blindness benefits. 
Work Registration Code 15 = Receives SSI Presumptive eligibility payments or Receives or has been approved to receive SSI benefits or Receives a Federal, State, or local public disability retirement pension and considered permanently disabled by the Social Security Office 
Work Registration Code 16= Receives SSI Presumptive eligibility payments or Receives or has been approved to receive SSI benefits 
Work Registration Code 17= Receives or has been approved to receive Social Security Disability or Blindness benefits.
Work Registration Code 22= Is a veteran receiving service-connected disability benefits rated at 100%

*/

RETURN @l_IE_Reference_Code

END 



GO
 
 -- Implementing Oracle INITCAP function
 CREATE FUNCTION dbo.InitCap (@inStr VARCHAR(8000))
  RETURNS VARCHAR(8000)
  AS
  BEGIN
    DECLARE @outStr VARCHAR(8000) = LOWER(@inStr),
		 @char CHAR(1),	
		 @alphanum BIT = 0,
		 @len INT = LEN(@inStr),
                 @pos INT = 1;		  
 
    -- Iterate through all characters in the input string
    WHILE @pos <= @len BEGIN
 
      -- Get the next character
      SET @char = SUBSTRING(@inStr, @pos, 1);
 
      -- If the position is first, or the previous characater is not alphanumeric
      -- convert the current character to upper case
      IF @pos = 1 OR @alphanum = 0
        SET @outStr = STUFF(@outStr, @pos, 1, UPPER(@char));
 
      SET @pos = @pos + 1;
 
      -- Define if the current character is non-alphanumeric
      IF ASCII(@char) <= 47 OR (ASCII(@char) BETWEEN 58 AND 64) OR
	  (ASCII(@char) BETWEEN 91 AND 96) OR (ASCII(@char) BETWEEN 123 AND 126)
	  SET @alphanum = 0;
      ELSE
	  SET @alphanum = 1;
 
    END
 
   RETURN @outStr;		   
  END

GO
CREATE FUNCTION [dbo].F_GET_CASE_PGM_STATUS_CODE ( @CP_STATUS VARCHAR(20))
RETURNS VARCHAR(20)
BEGIN

DECLARE @l_Case_STATUS  VARCHAR(10) = 'XX'
--Select * from iewp_ie_dev3.dbo.Rt_PROGRAMSTATUS_MV
--AP, DN, PE, TN


SELECT @l_Case_STATUS = CASE
    WHEN  @CP_STATUS = 'AO'  THEN 'AP'
    WHEN  @CP_STATUS = 'CL'  THEN 'TN'
	WHEN  @CP_STATUS = 'CD'  THEN 'DN'
	ELSE 'XX' END 

RETURN @l_Case_STATUS

END 
GO

CREATE FUNCTION [dbo].[F_GET_INDV_GENDER_CD] ( @MEM_SEX VARCHAR(1))
RETURNS VARCHAR(1)
BEGIN

DECLARE @l_GENDER_CD VARCHAR(1) = 'C'

--Select * from iewp_ie_conv.dbo.Rt_PROGRAM_MV

SET @l_GENDER_CD = CASE @MEM_SEX WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'C' END

RETURN @l_GENDER_CD
END 




GO



CREATE FUNCTION dbo.F_GET_JAS_JB_COMP_TRACKING_DATE_STORED(@COMP_CASE_ID as BIGINT)
RETURNS DATETIME2 --VARCHAR(20)
AS
BEGIN
DECLARE  @l_DATE_STORED DATETIME2


SELECT @l_DATE_STORED = (
SELECT top 1 DATE_STORED from LAND.JAS_JB_COMP_TRACKING
Where COMP_CASE_ID = @COMP_CASE_ID
Order By DATE_STORED desc)



RETURN @l_DATE_STORED --cast(@l_hdr_ID as VARCHAR)

END --



GO

CREATE FUNCTION dbo.F_GET_TIMETAKEN (@l_Time INT)
RETURNS VARCHAR(50)
BEGIN

--DECLARE @l_Time INT = 7129

DECLARE @l_Time_str VARCHAR(50)

/*
DECLARE @l_HDR INT =dbo.F_Get_HDR_ID()
--Select @l_Time/60


       SELECT  @l_Time = SUM(ISNULL(TIME_TAKE_FOR_EXTRACT,0))
       FROM CONV_ADMIN.DCM_LEGACY_EXTRACT_DETAIL
       Where DATA_CONVERSION_HEADER_ID =  @l_HDR

*/

	   --Print @l_Time


SET @l_Time_str = cast(@l_Time/3600 as varchar) + ' Hour(s) and ' + Cast( ((@l_Time%3600)/60) as varchar) + ' Minutes'
RETURN @l_Time_str


END 

GO

CREATE FUNCTION [dbo].[F_GET_EMP_PAYMENT_DATE] ( @EFF_BEGIN_DT DATETIME, @OCCURANCE INT, @FREQUENCY VARCHAR(2))
RETURNS DATETIME2
BEGIN
--DECLARE @EFF_BEGIN_DT DATETIME = '05/01/2011', @OCCURANCE INT = 0, @FREQUENCY VARCHAR(2)= 'B'
DECLARE @l_EMP_PAYMENT_DATE DATETIME2

SELECT @l_EMP_PAYMENT_DATE = CASE  @FREQUENCY 
   WHEN 'B' THEN  DATEADD(DD, 15*@OCCURANCE, @EFF_BEGIN_DT)
   WHEN 'S' THEN  DATEADD(DD, 15*@OCCURANCE, @EFF_BEGIN_DT)
   WHEN 'M' THEN  DATEADD(MM, 1*@OCCURANCE, @EFF_BEGIN_DT)
   WHEN 'A' THEN  DATEADD(YY, 1*@OCCURANCE, @EFF_BEGIN_DT)
   WHEN 'Q' THEN  DATEADD(MM, 3*@OCCURANCE, @EFF_BEGIN_DT)
   WHEN 'P' THEN  DATEADD(MM, 1*@OCCURANCE, @EFF_BEGIN_DT)
     WHEN 'W' THEN  DATEADD(DD, 7*@OCCURANCE, @EFF_BEGIN_DT)

	ELSE @EFF_BEGIN_DT END 



RETURN @l_EMP_PAYMENT_DATE
   
END 


GO
CREATE FUNCTION [dbo].[F_GET_TARGET_INDV_ID](@CASNUM BIGINT) 
RETURNS BIGINT
BEGIN
DECLARE @l_IDV_ID INT
/* 
Created: Venkata Nemani
Created date: Jan 12 2018
Purpose: Derive Target INDV ID based on Case Num 
File Name : Group1 Functions
*/
 
SELECT @l_IDV_ID = MEM_PID
from Land.LAMI_CASE(noloCK) A
JOIN LAND.LAMI_MEMBER (NOLOCK) B ON A.CASE_SSN_HH = MEM_SSN
WHERE CASE_CID = @CASNUM
 
RETURN @l_IDV_ID
END

GO



CREATE FUNCTION [dbo].[F_GET_REFERENCE_DATA_APPEALS] (@Legacy_Table VARCHAR(200), @Legacy_Code VARCHAR(200), @IE_Code VARCHAR(200) = NULL)
RETURNS VARCHAR(200)
BEGIN

DECLARE @l_IE_Reference_Code VARCHAR(200)

IF @IE_Code IS  NULL
SELECT @l_IE_Reference_Code = [IE Code]
FROM ie_ie_cnv.STAGE.LANDING_STAGE_REFERENCE_TABLE_SUBSYSTEM_DATA(NOLOCK)
WHERE [Legacy Table Description] = LTRIM(RTRIM(@Legacy_Table)) 
AND [Legacy Code] = LTRIM(RTRIM(@Legacy_Code))

ELSE
SELECT @l_IE_Reference_Code = [IE Code]
FROM ie_ie_cnv.STAGE.LANDING_STAGE_REFERENCE_TABLE_SUBSYSTEM_DATA(NOLOCK)
WHERE [Legacy Table Description] = LTRIM(RTRIM(@Legacy_Table)) 
AND [Legacy Code] = LTRIM(RTRIM(@Legacy_Code))
AND [IE Reference Table Name] = LTRIM(RTRIM(@IE_Code))


RETURN @l_IE_Reference_Code

END 





GO
