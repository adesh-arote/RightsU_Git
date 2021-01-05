
CREATE PROC [USP_Acq_Rights_PreReq]
(
	@Acq_Deal_Code INT,
	@Data_For VARCHAR(100),
	@Deal_Type_Code INT,
	@Is_Syn_Acq_Mapp VARCHAR(1)
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	07 Apr, 2016
Description:	It will select data from those master whose flag exist in '@Data_For' parameter
Note:			Parameter '@Data_For' will containg the flag value comma seperated, whose data should be selected.
				Parameter '@Acq_Deal_Code' and '@Deal_Type_Code' for call 'USP_Bind_Title' procedure, and pass as parameter
				Parameter '@Is_Syn_Acq_Mapp' add 'No Sublicensing' in Sub Licensing List

Flag for All Masters :
				
				CTR = Region - Country			CTT = Region - Circuit (Domestic Theatrical)
				TER = Region - Territory		TRT = Region - Territory (Domestic Theatrical)
				MST = Milestone Type			STL = Language - Subtitle (Langauge)
				SBL = Sublicensing				STG = Language - Subtitle (Langauge Group)
				TIT	= Titles					DBL = Language - Dubbing (Langauge)
				RFR = ROFR Type					DBG = Language - Dubbing (Langauge Group)
												MUN = Milestone Unit Type (e.g. Days, Weeks, Months, Years)
=======================================================================================================================================*/
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON

	--DECLARE
	--@Acq_Deal_Code INT = 287,
	--@Data_For VARCHAR(100) = 'TIT,TER,STG,DBL,RFR,MST,MUN,SBL',
	--@Deal_Type_Code INT = 14,
	--@Is_Syn_Acq_Mapp VARCHAR(1) = 'N'

	IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)
		DROP TABLE #PreReqData

	CREATE TABLE #PreReqData
	(
		RowID INT IDENTITY(1,1),
		Display_Value INT,
		Display_Text NVARCHAR(MAX),
		Data_For VARCHAR(3)
	)

	IF(CHARINDEX('TIT', @Data_For) > 0)
	BEGIN
		DECLARE @TempTitle table
		(
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Data_For VARCHAR(3) DEFAULT('TIT')
		)

		INSERT INTO @TempTitle(Title_Code, Title_Name)
		EXEC USP_Bind_Title @Acq_Deal_Code, @Deal_Type_Code, 'A' -- Here 'A' stands for Acquisition

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Title_Code, Title_Name, Data_For FROM @TempTitle ORDER BY Title_Name
	END

	IF(CHARINDEX('CTR', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Country_Code, Country_Name, 'CTR' AS Data_For FROM Country WHERE Is_Active = 'Y' AND Is_Theatrical_Territory = 'N'
		ORDER BY Country_Name
	END

	IF(CHARINDEX('TER', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Territory_Code, Territory_Name, 'TER' AS Data_For FROM Territory WHERE Is_Active = 'Y' AND Is_Thetrical = 'N'
		ORDER BY Territory_Name
	END

	IF(CHARINDEX('CTT', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Country_Code, Country_Name, 'CTT' AS Data_For FROM Country WHERE Is_Active = 'Y' AND Is_Theatrical_Territory = 'Y'
		ORDER BY Country_Name
	END

	IF(CHARINDEX('TRT', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Territory_Code, Territory_Name, 'TRT' AS Data_For FROM Territory WHERE Is_Active = 'Y' AND Is_Thetrical = 'Y'
		ORDER BY Territory_Name
	END

	IF(CHARINDEX('STL', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Language_Code, Language_Name, 'STL' AS Data_For FROM [Language] WHERE Is_Active = 'Y'
		ORDER BY Language_Name
	END

	IF(CHARINDEX('STG', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Language_Group_Code, Language_Group_Name, 'STG' AS Data_For FROM [Language_Group] WHERE Is_Active = 'Y'
		ORDER BY Language_Group_Name
	END

	IF(CHARINDEX('DBL', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Language_Code, Language_Name, 'DBL' AS Data_For FROM [Language] WHERE Is_Active = 'Y'
		ORDER BY Language_Name
	END

	IF(CHARINDEX('DBG', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Language_Group_Code, Language_Group_Name, 'DBG' AS Data_For FROM [Language_Group] WHERE Is_Active = 'Y'
		ORDER BY Language_Group_Name
	END

	IF(CHARINDEX('RFR', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'RFR' AS Data_For
		UNION
		SELECT DISTINCT ROFR_Code, ROFR_Type, 'RFR' AS Data_For FROM ROFR WHERE Is_Active = 'Y'
	END

	IF(CHARINDEX('MST', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Milestone_Type_Code, Milestone_Type_Name, 'MST' AS Data_For FROM Milestone_Type WHERE Is_Active = 'Y'
	END

	IF(CHARINDEX('MUN', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		VALUES(1, 'Days', 'MUN'),(2, 'Weeks', 'MUN'),(3, 'Months', 'MUN'),(4, 'Years', 'MUN')
	END

	IF(CHARINDEX('SBL', @Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT Sub_License_Code, Sub_License_Name, 'SBL' AS Data_For FROM Sub_License WHERE Is_Active = 'Y'
	END

	SELECT Display_Value, Display_Text, Data_For FROM #PreReqData
	ORDER BY RowID

	IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData
END
