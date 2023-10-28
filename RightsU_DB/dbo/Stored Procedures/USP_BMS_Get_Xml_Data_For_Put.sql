CREATE PROC [dbo].[USP_BMS_Get_Xml_Data_For_Put]
(
	@BMS_WBS_Code INT
)
AS
--	==========================
--	Author		:	Abhaysingh N. Rajpurohit	
--	Created On	:	29 September 2015
--	Description	:	Convert XML into table format, and update Response_Type, Error_Details, Response_Status, Is_Process in BMS_WBS, and make entry in 
--	==========================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Get_Xml_Data_For_Put]', 'Step 1', 0, 'Started Procedure', 0, ''
		
		declare @xmlData NVARCHAR(max)
		select @xmlData = ( 
		SELECT 
		BMS_Key AS [Key],
		WBS_Description AS [Description],
		CASE UPPER(LTRIM(RTRIM(Is_Archive))) WHEN 'Y' THEN 'true' ELSE 'false' END AS [IsArchived],
		WBS_Code AS [ForeignId]
		FROM BMS_WBS (NOLOCK) WHERE BMS_WBS_Code = @BMS_WBS_Code FOR XML PATH('Budgetcode')
		) 

		select '<?xml version="1.0" ?>' + @xmlData  + '' AS [DataToSend]

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Get_Xml_Data_For_Put]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
