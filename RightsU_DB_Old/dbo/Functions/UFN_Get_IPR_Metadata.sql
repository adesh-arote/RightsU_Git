CREATE FUNCTION [dbo].[UFN_Get_IPR_Metadata]
(
	@IPR_Code INT,
	@IPR_Type VARCHAR(5),
	@MetaDataType VARCHAR(20)
)
/*==========================================================================================
Author			:	Abhaysingh N. Rajpurohit
Create Date		:	21 Sep 2016
Description		:	Get Comma Separated Metadata using IPR_Code

IPR Type	: 
	REP	: @IPR_Code containing code of IPR_Rep_Code
	OPP	: @IPR_Code containing code of IPR_Opp_Code

Metadata Type	: 
	CLASS	: Get Class Description Comma Separated
	BU		: Get Business Unit Name Comma Separated
	CHANNEL : Get Channel Name Comma Separated
==========================================================================================*/

RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ReturnValue NVARCHAR(MAX)=''
	SET @MetaDataType = LTRIM(RTRIM(UPPER(@MetaDataType)))
	SET @IPR_Type = LTRIM(RTRIM(UPPER(@IPR_Type)))

	IF(@MetaDataType = 'CLASS')
	BEGIN
		SELECT @ReturnValue = STUFF (( 
			SELECT DISTINCT ', ' + CAST(IPC.[Description] AS NVARCHAR(MAX)) FROM IPR_REP_CLASS  IRC
			INNER JOIN IPR_CLASS IC ON IRC.IPR_Class_Code=IC.IPR_Class_Code
			INNER JOIN IPR_CLASS IPC ON IPC.IPR_Class_Code=IC.Parent_Class_Code
			WHERE IPR_Rep_Code = @IPR_Code
		FOR XML PATH('')), 1, 1, '')
	END
	ELSE IF(@MetaDataType = 'BU')
	BEGIN
		IF(@IPR_Type = 'REP')
		BEGIN
			SELECT @ReturnValue = STUFF (( 
				SELECT DISTINCT ', ' + CAST(BU.Business_Unit_Name AS NVARCHAR(MAX)) FROM IPR_Rep_Business_Unit IPR_BU
				INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = IPR_BU.Business_Unit_Code
				WHERE IPR_BU.IPR_Rep_Code = @IPR_Code
			FOR XML PATH('')), 1, 1, '')
		END
		ELSE
		BEGIN
			SELECT @ReturnValue = STUFF (( 
				SELECT DISTINCT ', ' + CAST(BU.Business_Unit_Name AS NVARCHAR(MAX)) FROM IPR_Opp_Business_Unit IPR_BU
				INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = IPR_BU.Business_Unit_Code
				WHERE IPR_BU.IPR_Opp_Code = @IPR_Code
			FOR XML PATH('')), 1, 1, '')
		END
	END
	ELSE IF(@MetaDataType = 'CHANNEL')
	BEGIN
		IF(@IPR_Type = 'REP')
		BEGIN
			SELECT @ReturnValue = STUFF (( 
				SELECT DISTINCT ', ' + CAST(C.Channel_Name AS NVARCHAR(MAX)) FROM IPR_Rep_Channel IPR_C
				INNER JOIN Channel C ON C.Channel_Code = IPR_C.Channel_Code
				WHERE IPR_C.IPR_Rep_Code = @IPR_Code
			FOR XML PATH('')), 1, 1, '')
		END
		ELSE
		BEGIN
			SELECT @ReturnValue = STUFF (( 
				SELECT DISTINCT ', ' + CAST(C.Channel_Name AS NVARCHAR(MAX)) FROM IPR_Opp_Channel IPR_C
				INNER JOIN Channel C ON C.Channel_Code = IPR_C.Channel_Code
				WHERE IPR_C.IPR_Opp_Code = @IPR_Code
			FOR XML PATH('')), 1, 1, '')
		END
	END
	
	RETURN ISNULL(@ReturnValue, '')
END

--SELECT DBO.UFN_Get_IPR_Metadata(3790, 'REP', 'CLASS')
--SELECT DBO.UFN_Get_IPR_Metadata(3790, 'REP', 'BU')
--SELECT DBO.UFN_Get_IPR_Metadata(5057, 'OPP', 'BU')
--SELECT DBO.UFN_Get_IPR_Metadata(3790, 'REP', 'CHANNEL')
--SELECT DBO.UFN_Get_IPR_Metadata(5057, 'OPP', 'CHANNEL')