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

	declare @xmlData NVARCHAR(max)
	select @xmlData = ( 
	SELECT 
	BMS_Key AS [Key],
	WBS_Description AS [Description],
	CASE UPPER(LTRIM(RTRIM(Is_Archive))) WHEN 'Y' THEN 'true' ELSE 'false' END AS [IsArchived],
	WBS_Code AS [ForeignId]
	FROM BMS_WBS WHERE BMS_WBS_Code = @BMS_WBS_Code FOR XML PATH('Budgetcode')
	) 

	select '<?xml version="1.0" ?>' + @xmlData  + '' AS [DataToSend]
END

--exec USP_BMS_Get_Xml_Data_For_Put 2

/*
<?xml version="1.0" ?><Budgetcode><Key>502582642</Key><Description>Pandorum</Description><IsArchived>true</IsArchived><ForeignId>F/LIC-0004001.01</ForeignId></Budgetcode>
<?xml version="1.0" ?><Budgetcode><Key>502582642</Key><Description>Pandorum</Description><IsArchived>true</IsArchived><ForeignId>F/LIC-0004001.01</ForeignId></Budgetcode>
*/
