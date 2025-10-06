use ie_ie_cnv
Go
DECLARE @table TABLE (SEQ_ID INT IDENTITY(1,1), Function_Name VARCHAR(120), object_id INT)

set nocount on 
DECLARE @l_Loop INT, @l_Max INT, @l_Function_Name VARCHAR(120), @l_object_id INT
DECLARE @l_Loop2 INT, @l_Max2 INT

DECLARE @l_SQL VARCHAR(MAX)

INSERT INTO @table
SElect Name, object_id from Sys.objects where type = 'FN'
and Name NOT IN ('fn_diagramobjects')
SELECT @l_Loop =1, @l_Max = @@ROWCOUNT
Print '--Total Finction in 02 server : ' + STR(@l_Max)

WHILE (@l_Loop <= @l_Max)
BEGIN


SELECT @l_Function_Name = Function_Name, @l_object_id = object_id, @l_SQL = '' from @table Where Seq_ID = @l_Loop
--Print '--Processing Function : ' + @l_Function_Name


SELECT @l_Loop2 = 1, @l_Max2 = Max(colid) from syscomments Where ID = @l_object_id


While @l_Loop2 <= @l_Max2 
BEGIN

SELECT @l_SQL = text from syscomments Where ID = @l_object_id and colid = @l_Loop2


If Len(@l_SQL) > 0
Print @l_SQL



SET @l_Loop2 = @l_Loop2 + 1

END --
--SELECT top 10 * from syscomments Where ID = 27199197

PRINT 'GO'

---SP_Helptext SP_Helptext

---EXEC SP_Helptext @l_Function_Name

SELECT @l_Loop = @l_Loop + 1, @l_Loop2 = 1, @l_Max2 = 0
END --





--Sp_Helptext F_GET_ILLEGAL_ALIENS_NUM_ED_ELIGILITY
