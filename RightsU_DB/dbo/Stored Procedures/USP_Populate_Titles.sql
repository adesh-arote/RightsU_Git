CREATE PROCEDURE [dbo].[USP_Populate_Titles]
(
	@Deal_Code INT,
	@Deal_Type_Code INT, 
	@Master_Deal_Movie_Code INT,
	@Selected_Title_Codes VARCHAR(MAX),
	@CallFrom CHAR(1) = 'A'
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 13-March-2015
-- Description:	Get Titles for Add deal in Acq/Syn
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Populate_Titles]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE @Deal_Code INT = 0, @Deal_Type_Code INT = 15, @Master_Deal_Movie_Code INT = 33, @Selected_Title_Codes VARCHAR(MAX) = '', @CallFrom CHAR(1) = 'A'
		--USP_Populate_Titles 1, 0, '', 'S'

		SET FMTONLY OFF

		DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
		CREATE TABLE #Selected_Titles
		(
			Title_Code INT
		)

		CREATE TABLE #Populated_Titles
		(
			Title_Code INT,
			Title_Name NVARCHAR(MAX)
		)

		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)
		IF(@Deal_Type_Condition <> 'DEAL_PROGRAM' AND  @Deal_Type_Condition <> 'DEAL_MUSIC')
		BEGIN
			INSERT INTO #Selected_Titles
			SELECT number AS Title_Code FROM fn_Split_withdelemiter(@Selected_Title_Codes, ',')
		END

		IF(@CallFrom = 'A')
		BEGIN
			PRINT 'Populate data for Acq'
			IF(@Master_Deal_Movie_Code > 0)
			BEGIN
				DECLARE @Title_Code INT = 0, @Columns_Code INT = 0, @Deal_Type_Name VARCHAR(MAX) = ''
				SELECT TOP 1 @Title_Code = Title_Code FROM Acq_Deal_Movie (NOLOCK) where Acq_Deal_Movie_Code = @Master_Deal_Movie_Code
				SELECT TOP 1 @Deal_Type_Name = Deal_Type_Name FROM Deal_Type (NOLOCK) WHERE Deal_Type_Code = @Deal_Type_Code

				INSERT INTO #Selected_Titles(Title_Code)
				SELECT DISTINCT ADM.Title_Code FROM Acq_Deal AD (NOLOCK)
				INNER JOIN Acq_Deal_Movie ADM  (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
				WHERE AD.Master_Deal_Movie_Code_ToLink = @Master_Deal_Movie_Code AND AD.Deal_Type_Code = @Deal_Type_Code
				AND AD.Acq_Deal_Code != @Deal_Code			

				PRINT 'Populate data for ' + @Deal_Type_Name + ' according to master deal'

				INSERT INTO #Populated_Titles(Title_Code, Title_Name)
				SELECT DISTINCT TitTal.Title_Code, TitTal.Title_Name FROM Map_Extended_Columns MEC  (NOLOCK)
				INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
				INNER JOIN Talent TAT (NOLOCK) ON TAT.Talent_Code = MECD.Columns_Value_Code
				Inner Join Title TitTal (NOLOCK) On TAT.Talent_Code = TitTal.Reference_Key
				--INNER JOIN Title TIT ON TIT.Title_Name = TAT.Talent_Name AND TIT.Deal_Type_Code = @Deal_Type_Code  AND TIT.Title_Code in (@Title_Code)
				--AND ISNULL(TIT.Reference_Flag, '') = 'T' AND ISNULL(TIT.Is_Active, '') = 'Y'
				--AND TIT.Title_Code NOT IN (SELECT Title_Code FROM #Selected_Titles)
				WHERE MEC.Record_Code = @Title_Code And TitTal.Deal_Type_Code = @Deal_Type_Code And MEC.Record_Code In (@Title_Code)
			
				INSERT INTO #Populated_Titles(Title_Code, Title_Name)
				SELECT DISTINCT TIT.Title_Code, TIT.Title_Name FROM Title_Talent TT (NOLOCK) 
				INNER JOIN [Role] R (NOLOCK) ON R.Role_Code = TT.Role_Code AND R.Deal_Type_Code = @Deal_Type_Code
				INNER JOIN Talent TAT (NOLOCK) ON TAT.Talent_Code = TT.Talent_Code
				INNER JOIN Title TIT (NOLOCK) ON TIT.Title_Name = TAT.Talent_Name AND TIT.Deal_Type_Code = @Deal_Type_Code 
				AND ISNULL(TIT.Reference_Flag, '') = 'T' AND ISNULL(TIT.Is_Active, '') = 'Y'
				AND TIT.Title_Code NOT IN (SELECT Title_Code FROM #Selected_Titles)
				WHERE TT.Title_Code = @Title_Code
			END
			ELSE
			BEGIN
				INSERT INTO #Populated_Titles(Title_Code, Title_Name)
				SELECT DISTINCT Title_Code, Title_Name FROM Title (NOLOCK) WHERE ISNULL(Reference_Flag, '') <> 'T'  AND ISNULL(Is_Active, '') = 'Y'
				AND Deal_Type_Code = @Deal_Type_Code AND Title_Code NOT IN (SELECT Title_Code FROM #Selected_Titles)
			END
		END
		ELSE
		BEGIN
			PRINT 'Populate data for Syn'
			INSERT INTO #Populated_Titles(Title_Code, Title_Name)

			SELECT DISTINCT T.Title_Code, T.Title_Name FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM  (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ISNULL(ADR.Is_Sub_License, '') = 'Y'	AND ISNULL(ADR.Is_Tentative,'N') = 'N' 
				AND ISNULL(ADR.Actual_Right_Start_Date,'') <> ''
			INNER JOIN Title T (NOLOCK) ON ISNULL(Reference_Flag, '') <> 'T'  AND ISNULL(T.Is_Active, '') = 'Y' AND T.Title_Code = ADM.Title_Code
			AND T.Deal_Type_Code = @Deal_Type_Code AND T.Title_Code NOT IN (SELECT Title_Code FROM #Selected_Titles)
			WHERE AD.Deal_Workflow_Status = 'A'
		END

		SELECT DISTINCT Title_Code, Title_Name FROM #Populated_Titles
		--DROP TABLE #Selected_Titles
		--DROP TABLE #Populated_Titles

		IF OBJECT_ID('tempdb..#Populated_Titles') IS NOT NULL DROP TABLE #Populated_Titles
		IF OBJECT_ID('tempdb..#Selected_Titles') IS NOT NULL DROP TABLE #Selected_Titles
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Populate_Titles]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END