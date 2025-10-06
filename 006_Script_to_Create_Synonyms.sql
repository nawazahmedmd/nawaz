use ie_ie_cnv
Go
--select * FROM ie_ie_cnv.SYS.synonyms

DECLARE @l_SQL NVARCHAR(MAX), @l_Table_count INT
DECLARE @l_Loop INT, @l_Max INT 
DECLARE @T_seq Table (SEQ_ID INT  IDENTITY(1,1), synonym_name VARCHAR(120))

DECLARE @l_synonym_name VARCHAR(120) 
SET NOCOUNT ON
INSERT INTO @T_seq select Name FROM ie_ie_cnv.SYS.synonyms
SELECT @l_Loop = 1, @l_Max = @@ROWCOUNT

WHILE @l_Loop <= @l_Max
BEGIN

SELECT @l_synonym_name = synonym_name FROM @T_seq WHERE SEQ_ID = @l_Loop

select @l_SQL = 'IF NOT EXISTS (SELECT 1 FROM FROM ie_ie_cnv.SYS.synonyms WHERE NAME = ' + '''' + @l_synonym_name + '''' + ')'+ CHAR(13)

 select @l_SQL=  @l_SQL + 'CREATE synonym dbo.' + @l_synonym_name + ' FOR iewp_ie_dev4.dbo.' + @l_synonym_name+ CHAR(13) +  'Go'
 


/* Sample:
CREATE SYNONYM [dbo].[RT_ACTNAME_MV] FOR [iewp_ie_state]..[RT_ACTNAME_MV]
*/



Print @l_SQL
--EXEC (@l_SQL)

SET @l_Loop= @l_Loop +1
END 