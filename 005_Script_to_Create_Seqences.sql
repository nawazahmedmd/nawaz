use ie_ie_cnv
Go
DECLARE @l_SQL NVARCHAR(MAX), @l_Table_count INT
DECLARE @l_Loop INT, @l_Max INT 
DECLARE @T_seq Table (SEQ_ID INT  IDENTITY(1,1), sequence_name VARCHAR(120))

DECLARE @l_sequence_name VARCHAR(120) 
SET NOCOUNT ON
INSERT INTO @T_seq select Name FROM ie_ie_cnv.SYS.sequences
SELECT @l_Loop = 1, @l_Max = @@ROWCOUNT

WHILE @l_Loop <= @l_Max
BEGIN

SELECT @l_sequence_name = sequence_name FROM @T_seq WHERE SEQ_ID = @l_Loop

select @l_SQL = 'IF NOT EXISTS (SELECT 1 FROM ie_ie_cnv.SYS.sequences WHERE NAME = ' + '''' + @l_sequence_name + '''' + ')'+ CHAR(13)

 select @l_SQL=  @l_SQL + 'CREATE SEQUENCE dbo.' + @l_sequence_name + ' AS numeric(28, 0)' + CHAR(13) + 
 'START WITH 5001' + CHAR(13) + 
 'INCREMENT BY 10' + CHAR(13) + 
 'MINVALUE 1' + CHAR(13) + 
 'MAXVALUE 999999999999999999999999999' + CHAR(13) + 
 'CACHE  500 ;'--+ CHAR(13) +  'Go'
 


/* Sample:
CREATE SEQUENCE [dbo].[AR_APP_ADDR_0SQ] 
 AS [numeric](28, 0)
 START WITH 5001
 INCREMENT BY 10
 MINVALUE 1
 MAXVALUE 999999999999999999999999999
 CACHE  500 
*/



Print @l_SQL
--EXEC (@l_SQL)

SET @l_Loop= @l_Loop +1
END 