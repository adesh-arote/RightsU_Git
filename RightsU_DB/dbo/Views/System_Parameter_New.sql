CREATE VIEW [dbo].[System_Parameter_New]
	AS
SELECT Id ,Parameter_Name ,Parameter_Value ,[Inserted_On],Inserted_By ,Lock_Time ,Last_Updated_Time ,Last_Action_By ,Channel_Code ,[Type] ,IsActive ,[Description] ,IS_System_Admin ,Client_Name
FROM System_Parameter
WHERE Client_Name = (SELECT TOP 1 Parameter_Value FROM System_Parameter WHERE Parameter_Name = 'Client_Name')
