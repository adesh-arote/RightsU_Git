SELECT * FROM sys.tables where name like '%Platform'

--SELECT * FROM [Platform] WHERE ISNULL(Is_Sport_Right, 'N') = 'Y'
SELECT * FROM System_Parameter_New WHERE Parameter_Name IN ('Sports_Standalone_Base_Platform', 'Sports_Simulcast_Base_Platform')

--Update System_Parameter_New Set Parameter_Value = 9 WHERE Parameter_Name IN ('Sports_Standalone_Base_Platform', 'Sports_Simulcast_Base_Platform')