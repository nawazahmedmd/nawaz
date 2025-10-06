use ie_ie_cnv
Go
DECLARE @table TABLE (SEQ_ID INT IDENTITY(1,1), table_Name VARCHAR(120))

set nocount on 
DECLARE @l_Loop INT, @l_Max INT, @l_table_Name VARCHAR(120), @l_object_id INT
DECLARE @l_Loop2 INT, @l_Max2 INT

DECLARE @l_SQL VARCHAR(MAX)

INSERT INTO @table
SElect TABLE_NAME
FROM INFORMATION_SCHEMA.Tables
WHERE TABLE_TYPE = 'BASE TABLE'
and TABLE_SCHEMA = 'CONV_ADMIN'
AND TABLE_NAME IN ('DCM_LANDING_EXTRACT_DETAIL', 'DCM_LANDING_MASTER_TABLES', 'DCM_LEGACY_MASTER_FILES', 'DCM_TARGET_MASTER_TABLES', 'DCM_TARGET_EXTRACT_DETAIL', 'DCM_DATA_CONVERSION_HEADER', 'DCM_LEGACY_EXTRACT_DETAIL', 'DCM_STAGING_EXTRACT_DETAIL', 'DCM_STAGING_MASTER_TABLES')

SELECT @l_Loop =1, @l_Max = @@ROWCOUNT

WHILE (@l_Loop <= @l_Max)
BEGIN


SELECT @l_table_Name = table_Name--, @l_object_id = object_id, @l_SQL = '' 
from @table Where Seq_ID = @l_Loop
--Print '--Processing Function : ' + @l_Function_Name

EXEC dbo.P_GENERATE_INSERTS @l_table_Name, 'CONV_ADMIN'
--SELECT top 10 * from syscomments Where ID = 27199197

PRINT 'GO'

---SP_Helptext SP_Helptext

---EXEC SP_Helptext @l_Function_Name

SELECT @l_Loop = @l_Loop + 1, @l_Loop2 = 1, @l_Max2 = 0
END --


--SElect distinct type from Sys.objects where type = 'FN'


--Sp_Helptext F_GET_ILLEGAL_ALIENS_NUM_ED_ELIGILITY
