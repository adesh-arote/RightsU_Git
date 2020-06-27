CREATE PROC [dbo].[USP_BMS_Key_Update]
(
	@strXml NVARCHAR(MAX),
	@BMS_WBS_Code INT
)
AS
--	==========================
--	Author		:	Abhaysingh N. Rajpurohit	
--	Created On	:	29 September 2015
--	Description	:	Convert XML into table format, and update BMS_Key in BMS_WBS, SAP_WBS tables
--	==========================
BEGIN
--	SET @strXml = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
--<Budgetcode xmlns="http://172.31.24.36:8080/rightsu-service/rest/Budgetcode" xmlns:bv="http://www.broadviewsoftware.com/XMLSchema/Domains" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://172.31.24.36:8080/rightsu-service/rest/Budgetcode http://172.31.24.36:8080/rightsu-service/rest/XSD/Budgetcode">
--    <Key>502582642</Key>
--    <Description>Pandorum-PRIME TIME-F/LIC-0004001.01</Description>
--    <Code>2     </Code>
--    <IsArchived>true</IsArchived>
--    <ForeignId>F/LIC-0004001.01</ForeignId>
--</Budgetcode>'

	DECLARE @XML_Data XML
	SET @XML_Data = @strXml

	DECLARE @BMS_Key INT, @WBS_Code NVARCHAR(MAX)

	;WITH XMLNAMESPACES(DEFAULT 'http://172.31.24.36:8080/rightsu-service/rest/Budgetcode')
	SELECT TOP 1 @BMS_Key = BMS_Key, @WBS_Code = Foreign_Id FROM (
		SELECT A.B.value('Key[1]','INT') AS BMS_Key,
		A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id      	
		FROM   @XML_Data.nodes('//Budgetcode') AS A(B)
	) AS TBL
	ORDER BY BMS_Key DESC

	--SELECT @BMS_WBS_Code AS BMS_WBS_Code, @BMS_Key AS BMS_Key , @WBS_Code AS WBS_Code

	UPDATE BMS_WBS SET BMS_Key = @BMS_Key WHERE BMS_WBS_Code = @BMS_WBS_Code AND WBS_Code = @WBS_Code
	UPDATE SAP_WBS SET BMS_Key = @BMS_Key WHERE WBS_Code = @WBS_Code
	
	SELECT 'S' As Result
	
END

/*********** New 
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Budgetcode xmlns="http://172.31.24.36:8080/rightsu-service/rest/Budgetcode" xmlns:bv="http://www.broadviewsoftware.com/XMLSchema/Domains" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://172.31.24.36:8080/rightsu-service/rest/Budgetcode http://172.31.24.36:8080/rightsu-service/rest/XSD/Budgetcode">
    <Key>502582642</Key>
    <Description>Pandorum-PRIME TIME-F/LIC-0004001.01</Description>
    <Code>2     </Code>
    <IsArchived>true</IsArchived>
    <ForeignId>F/LIC-0004001.01</ForeignId>
</Budgetcode>
*/
/*
EXEC USP_Update_BMS_Key '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Budgetcode xmlns="http://172.31.24.36:8080/rightsu-service/rest/Budgetcode" xmlns:bv="http://www.broadviewsoftware.com/XMLSchema/Domains" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://172.31.24.36:8080/rightsu-service/rest/Budgetcode http://172.31.24.36:8080/rightsu-service/rest/XSD/Budgetcode">
    <Key>502582642</Key>
    <Description>Pandorum</Description>
    <IsArchived>true</IsArchived>
    <ForeignId>F/LIC-0004001.01</ForeignId>
</Budgetcode>'
,2
*/