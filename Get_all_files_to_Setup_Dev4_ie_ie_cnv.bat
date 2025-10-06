Pause
sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\001_Script_to_Create_Conv_ADMIN_Tables.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\001_Create_table_for_Conv_ADMIN.sql
Pause

sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\002_Script_to_Create_LAND_Tables.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\002_Create_Table_Script_For_Conv_LAND.sql
Pause
sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\003_Script_to_Create_STAGE_Tables.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\003_Create_Table_Script_For_Conv_STAGE.sql



sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\004_Script_to_Create_Views.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\004_Create_Views_Script.sql


sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\005_Script_to_Create_Seqences.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\005_Create_Seqences_Script.sql


sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\006_Script_to_Create_Synonyms.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\006_Create_Synonyms_Script.sql


sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\007_Script_to_Create_Functions.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\007_Create_Functios_Script.sql

sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\008_Script_to_Create_Procedures.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\008_Create_Procedures_Script.sql

sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\009_Script_to_get_CONV_ADMIN_Data.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\009_Get_CONV_ADMIN_Data.sql


sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\010_Script_to_get_Core_Reference_Data.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\010_REFERENCE_TABLE_data_Script.sql


sqlcmd -S 10.24.100.56 -E -d ie_ie_cnv -i C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\011_Script_to_get_Subsys_Reference_Data.sql  -o C:\IE_CONV\SQL_Scripts\DEV4_data_Prep\Ready_to_Move_to_DEV4\011_Subsystems_REFERENCE_TABLE_data_Script.sql
