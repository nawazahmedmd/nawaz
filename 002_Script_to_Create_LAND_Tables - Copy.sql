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
and TABLE_SCHEMA = 'DBO'

SELECT @l_Loop =1, @l_Max = @@ROWCOUNT
Print '--Total Finction in 02 server : ' + STR(@l_Max)

WHILE (@l_Loop <= @l_Max)
BEGIN


SELECT @l_table_Name = table_Name--, @l_object_id = object_id, @l_SQL = '' 
from @table Where Seq_ID = @l_Loop
--Print '--Processing Function : ' + @l_Function_Name

EXEC dbo.P_DBA_RECREATE_TABLE_SCRIPT @l_table_Name, 'DBO'
--SELECT top 10 * from syscomments Where ID = 27199197

PRINT 'GO'

---SP_Helptext SP_Helptext

---EXEC SP_Helptext @l_Function_Name

SELECT @l_Loop = @l_Loop + 1, @l_Loop2 = 1, @l_Max2 = 0
END --


--SElect distinct type from Sys.objects where type = 'FN'


--Sp_Helptext F_GET_ILLEGAL_ALIENS_NUM_ED_ELIGILITY
