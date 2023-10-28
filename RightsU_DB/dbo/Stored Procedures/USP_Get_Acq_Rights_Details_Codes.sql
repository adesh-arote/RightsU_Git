CREATE PROC [dbo].[USP_Get_Acq_Rights_Details_Codes]
(
	@Title_Code VARCHAR(MAX) = '',
	@Deal_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: October 2014
-- Description:	Get All Code for Populate Pushback popup in syndictaion
-- =============================================
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Acq_Rights_Details_Codes]', 'Step 1', 0, 'Started Procedure', 0, '' 
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
		SET FMTONLY OFF

		--DECLARE @Title_Code VARCHAR(MAX) = '2943', @Deal_Code INT = 41

		DECLARE @Is_Debug CHAR(1) = 'N', @Cur_time DATETIME = GETDATE()
		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '1 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END
	
		DECLARE @platformCode VARCHAR(MAX),  @countryCode VARCHAR(MAX), @subtitlingCode VARCHAR(MAX), @dubbingCode VARCHAR(MAX), @strQuery VARCHAR(MAX)
		SELECT @platformCode = '0',  @countryCode = '0', @subtitlingCode = '0', @dubbingCode = '0', @strQuery = ''

		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Deal_Code
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '2 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		CREATE TABLE #Deal_Movie_Temp
		(
			Title_Code INT,
			Episode_From INT,
			Episode_To INT
		)

		IF(@Deal_Type_Condition = 'DEAL_PROGRAM')
		BEGIN
			PRINT 'Deal type is Content'
			INSERT INTO #Deal_Movie_Temp (Title_Code, Episode_From, Episode_To)
			SELECT SDM.Title_Code, SDM.Episode_From, SDM.Episode_End_To FROM Syn_Deal_Movie SDM (NOLOCK) WHERE SDM.Syn_Deal_Movie_Code IN (select number from fn_Split_withdelemiter(@Title_Code, ','))
		END
		ELSE
		BEGIN
			PRINT 'Deal type is not Content'
			INSERT INTO #Deal_Movie_Temp (Title_Code, Episode_From, Episode_To)
			SELECT SDM.Title_Code, SDM.Episode_From, SDM.Episode_End_To FROM Syn_Deal_Movie SDM (NOLOCK) WHERE SDM.Title_Code IN (select number from fn_Split_withdelemiter(@Title_Code, ','))
		END

		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '3 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		Select Distinct ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRTE.EPS_No, ADRP.Platform_Code, 
			ADRTr.Country_Code,ADRTr.Territory_Code, ADRTr.Territory_Type InTo #Temp_Tit_Right
		From dbo.Acq_Deal_Rights ADR (NOLOCK)
		INNER JOIN dbo.Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code 
					And ADR.Acq_Deal_Code Is Not Null AND ADR.Is_Sub_License='Y' AND ADR.Is_Tentative='N' AND ADR.Is_Exclusive = 'Y'
		INNER JOIN dbo.Acq_Deal_Rights_Title_EPS ADRTE (NOLOCK) ON ADRT.Acq_Deal_Rights_Title_Code=ADRTE.Acq_Deal_Rights_Title_Code
		INNER JOIN #Deal_Movie_Temp DRT ON DRT.Title_Code = ADRT.Title_Code AND ADRTE.Eps_No BETWEEN DRT.Episode_FROM AND DRT.Episode_To
		INNER JOIN dbo.Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
		Inner Join Acq_Deal_Rights_Territory ADRTr (NOLOCK) ON ADR.Acq_Deal_Rights_Code=ADRTr.Acq_Deal_Rights_Code
		Inner Join Acq_Deal ad (NOLOCK) On ADR.Acq_Deal_Code = ad.Acq_Deal_Code And ISNULL(AD.Deal_Workflow_Status,'')='A' 
		WHERE
		 AD.Deal_Workflow_Status NOT IN ('AR', 'WA')

		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '4 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		Select @platformCode = @platformCode + ',' + Platform_Code
		FROM (
			SELECT DISTINCT CAST(ISNULL(Platform_Code, 0) AS VARCHAR) AS Platform_Code FROM #Temp_Tit_Right AA
			INNER JOIN #Deal_Movie_Temp DMT ON DMT.Title_Code = AA.Title_Code AND AA.EPS_No BETWEEN DMT.Episode_From AND DMT.Episode_To
		) AS P

		--Select @countryCode = @countryCode + ',' + Country_Code
		--FROM (
		--	SELECT DISTINCT CAST(ISNULL(Country_Code, 0) AS VARCHAR) AS Country_Code FROM #Temp_Tit_Right AA
		--	INNER JOIN #Deal_Movie_Temp DMT ON DMT.Title_Code = AA.Title_Code AND AA.EPS_No BETWEEN DMT.Episode_From AND DMT.Episode_To
		--) AS C
	
		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '5 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		SELECT @countryCode = @countryCode + ',' + CAST(ISNULL(Maintbl.Country_Code, 0) AS VARCHAR)  FROM 
		(
			SELECT DISTINCT
				CASE WHEN C.Territory_Type = 'G' THEN TD.Country_Code ELSE C.Country_Code END AS Country_Code 
			FROM 
			(
				SELECT DISTINCT AA.Country_Code,AA.Territory_Code,AA.Territory_Type
				FROM #Temp_Tit_Right AA
				INNER JOIN #Deal_Movie_Temp DMT ON DMT.Title_Code = AA.Title_Code 
					AND AA.EPS_No BETWEEN DMT.Episode_From AND DMT.Episode_To
			) AS C 
			LEFT JOIN Territory_Details TD (NOLOCK) ON  ISNULL(C.Territory_Code,0) = TD.Territory_Code
		) AS Maintbl
	
		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '6 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		SELECT DISTINCT Acq_Deal_Rights_Code INTO #Rights_Code FROM #Temp_Tit_Right

		SELECT DISTINCT 
		CASE WHEN ADRS.Language_Type = 'G' THEN LGD.Language_Code ELSE ADRS.Language_Code END AS Language_Code 
		InTo #Temp_SUbTit
		FROM dbo.Acq_Deal_Rights_Subtitling ADRS (NOLOCK)	
		INNER JOIN #Rights_Code ADR ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code
		LEFT JOIN Language_Group_Details LGD (NOLOCK) ON ISNULL(ADRS.Language_Group_Code,0) = LGD.Language_Group_Code
		
		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '7 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		SELECT DISTINCT 
			CASE WHEN ADRD.Language_Type = 'G' THEN LGD.Language_Code ELSE ADRD.Language_Code END AS Language_Code 
		InTo #Temp_Dubbing
		From dbo.Acq_Deal_Rights_Dubbing ADRD (NOLOCK)
		INNER JOIN #Rights_Code ADR ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code
		LEFT JOIN Language_Group_Details LGD (NOLOCK) ON ISNULL(ADRD.Language_Group_Code,0) = LGD.Language_Group_Code
		
		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '8 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		Select @subtitlingCode = @subtitlingCode + ',' + CAST(Language_Code AS VARCHAR)
		FROM #Temp_SUbTit
		-- (
		--	SELECT DISTINCT CAST(ISNULL(AA.SubTitle_Lang_Code, 0) AS VARCHAR) AS Language_Code FROM VW_Acq_Approved_Data AA
		--	INNER JOIN #Deal_Movie_Temp DMT ON DMT.Title_Code = AA.Title_Code AND AA.EPS_No BETWEEN DMT.Episode_From AND DMT.Episode_To
		--) AS S

		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '9 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		Select @dubbingCode = @dubbingCode + ',' + CAST(Language_Code AS VARCHAR)
		FROM #Temp_Dubbing
		--(
		--	SELECT DISTINCT CAST(ISNULL(AA.Dubb_Lang_Code, 0) AS VARCHAR) AS Language_Code FROM VW_Acq_Approved_Data AA
		--	INNER JOIN #Deal_Movie_Temp DMT ON DMT.Title_Code = AA.Title_Code AND AA.EPS_No BETWEEN DMT.Episode_From AND DMT.Episode_To
		--) AS D

		IF(@Is_Debug = 'Y')
		BEGIN
			PRINT '10 Time in Second : ' + CAST(DateDiff(second, @cur_time, GETDATE()) AS VARCHAR(10))
			SET @Cur_time = GETDATE()
		END

		SELECT @platformCode as Platform_Codes,  @countryCode as Country_Codes, @subtitlingCode as Subtitling_Codes, @dubbingCode as Dubbing_Codes

		--DROP TABLE #Deal_Movie_Temp
		--DROP TABLE #Temp_Tit_Right
		--DROP TABLE #Rights_Code
		--DROP TABLE #Temp_SUbTit
		--DROP TABLE #Temp_Dubbing

		IF OBJECT_ID('tempdb..#Deal_Movie_Temp') IS NOT NULL DROP TABLE #Deal_Movie_Temp
		IF OBJECT_ID('tempdb..#Rights_Code') IS NOT NULL DROP TABLE #Rights_Code
		IF OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL DROP TABLE #Temp_Dubbing
		IF OBJECT_ID('tempdb..#Temp_SUbTit') IS NOT NULL DROP TABLE #Temp_SUbTit
		IF OBJECT_ID('tempdb..#Temp_Tit_Right') IS NOT NULL DROP TABLE #Temp_Tit_Right
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Acq_Rights_Details_Codes]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END