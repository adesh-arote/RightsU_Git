CREATE PROCEDURE [dbo].[USP_Validate_Platform_Run_UDT]
(
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Code INT,
	@Deal_Code INT,
	@CallFrom CHAR(2)='AR',	
	@ViewType CHAR(1) = 'D',
	@Platform_Code INT,
	@Debug CHAR(1)='N'
)
As
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 09-March-2015
-- Description:	Checks If Run added for These titles and while editing you are not selecting any platform which Applicable_For_Asrun_Schedule = 'Y'
-- =============================================
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF
   
	--DECLARE
	--@Deal_Rights_Title Deal_Rights_Title,
	--@Deal_Rights_Platform Deal_Rights_Platform,
	--@Deal_Rights_Code INT,
	--@Deal_Code INT,
	--@CallFrom CHAR(2)='AR',	
	--@ViewType CHAR(1) = 'D',
	--@Platform_Code INT = 21,
	--@Debug CHAR(1)='N'

	--INSERT INTO @Deal_Rights_Title(Title_Code, Episode_From, Episode_To) VALUES (10151, 1, 1)--, (10152, 1, 1)
	--INSERT INTO @Deal_Rights_Platform(Platform_Code) VALUES (21)--, (22), (121), (131)
	--SET @Deal_Rights_Code = 2757
	--SET @Deal_Code = 749

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END

	IF OBJECT_ID('tempdb..#Deal_Rights_Title_New') IS NOT NULL
	BEGIN
		DROP TABLE #Deal_Rights_Title_New
	END

	CREATE TABLE #Deal_Rights_Title_New
	(
		Title_Code INT, 
		Episode_From INT, 
		Episode_To INT, 
		Title_For CHAR(1)
	)

	IF OBJECT_ID('tempdb..#Deal_Rights_Platform_New') IS NOT NULL
	BEGIN
		DROP TABLE #Deal_Rights_Platform_New
	END

	CREATE TABLE #Deal_Rights_Platform_New
	(
		Platform_Code INT
	)
	
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END

	CREATE TABLE #Temp
	(
		Title_Code INT, 
		Episode_From INT, 
		Episode_To INT, 
		Platform_Code INT,
		Title_For CHAR(1)
		
	)

	IF OBJECT_ID('tempdb..#RunRecord') IS NOT NULL
	BEGIN
		DROP TABLE #RunRecord
	END

	CREATE TABLE #RunRecord
	(
		Title_Code INT, 
		Episode_From INT, 
		Episode_To INT, 
		Title_For CHAR(1),
		Platform_Count INT
	)

	INSERT INTO #Deal_Rights_Platform_New (Platform_Code)
	SELECT Platform_Code FROM @Deal_Rights_Platform

	IF(UPPER(@CallFrom)='AR')
	BEGIN
		PRINT 'Called from Acq Rights Tab'

		IF(@ViewType = 'G')
		BEGIN
			INSERT INTO #Deal_Rights_Title_New(Title_Code, Episode_From, Episode_To, Title_For)
			SELECT DISTINCT RunT.Title_Code, RunT.Episode_From, RunT.Episode_To, 'R' FROM  Acq_Deal_Run Run
			INNER JOIN Acq_Deal_Run_Title RunT ON RunT.Acq_Deal_Run_Code = Run.Acq_Deal_Run_Code AND Run.Acq_Deal_Code = @Deal_Code
			INNER JOIN Acq_Deal_Rights_Title RightT ON RightT.Acq_Deal_Rights_Code = @Deal_Rights_Code AND RightT.Title_Code = RunT.Title_Code
				AND RightT.Episode_From = RunT.Episode_From AND RightT.Episode_To = RunT.Episode_To

			INSERT INTO #Deal_Rights_Title_New(Title_Code, Episode_From, Episode_To, Title_For)
			SELECT DISTINCT Budget.Title_Code, Budget.Episode_From, Budget.Episode_To, 'B' FROM  Acq_Deal_Budget Budget
			INNER JOIN Acq_Deal_Rights_Title RightT ON RightT.Acq_Deal_Rights_Code = @Deal_Rights_Code AND RightT.Title_Code = Budget.Title_Code
				AND RightT.Episode_From = Budget.Episode_From AND RightT.Episode_To = Budget.Episode_To
			WHERE Budget.Acq_Deal_Code = @Deal_Code

		END
		ELSE
		BEGIN
			INSERT INTO #Deal_Rights_Title_New(Title_Code, Episode_From, Episode_To, Title_For)
			SELECT DISTINCT RunT.Title_Code, RunT.Episode_From, RunT.Episode_To, 'R' FROM  Acq_Deal_Run Run
			INNER JOIN Acq_Deal_Run_Title RunT ON RunT.Acq_Deal_Run_Code = Run.Acq_Deal_Run_Code AND Run.Acq_Deal_Code = @Deal_Code
			INNER JOIN @Deal_Rights_Title RightT ON RightT.Title_Code = RunT.Title_Code AND RightT.Episode_From = RunT.Episode_From 
				AND RightT.Episode_To = RunT.Episode_To

			INSERT INTO #Deal_Rights_Title_New(Title_Code, Episode_From, Episode_To, Title_For)
			SELECT DISTINCT Budget.Title_Code, Budget.Episode_From, Budget.Episode_To, 'B' FROM  Acq_Deal_Budget Budget
			INNER JOIN @Deal_Rights_Title RightT ON RightT.Title_Code = Budget.Title_Code AND RightT.Episode_From = Budget.Episode_From 
				AND RightT.Episode_To = Budget.Episode_To
			WHERE Budget.Acq_Deal_Code = @Deal_Code
		END

		IF(@ViewType = 'D')
		BEGIN
			INSERT INTO #Deal_Rights_Platform_New (Platform_Code)
			SELECT DISTINCT Platform_Code FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Deal_Rights_Code
			AND Platform_Code != @Platform_Code
		END
		 

		IF((SELECT COUNT(*) FROM #Deal_Rights_Title_New) > 0)
		BEGIN
			PRINT 'Title conatains Run Definition'

			INSERT INTO #Temp (Title_Code, Episode_From, Episode_To, Platform_Code, Title_For)
			SELECT DISTINCT ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADRP.Platform_Code, Title_For FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN #Deal_Rights_Title_New DRT ON ADRT.Title_Code = DRT.Title_Code AND ADRT.Episode_From = DRT.Episode_From AND ADRT.Episode_To = DRT.Episode_To
			INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			INNER JOIN Platform P ON ADRP.Platform_Code = p.Platform_Code AND P.Is_No_Of_Run = 'Y'
			WHERE ADR.Acq_Deal_Code = @Deal_Code AND ADR.Acq_Deal_Rights_Code != @Deal_Rights_Code
						
			INSERT INTO #Temp
			SELECT DISTINCT DRT.Title_Code, DRT.Episode_From, DRT.Episode_To, 
			CASE WHEN T2.Title_Code IS NULL AND T2.Episode_From IS NULL AND T2.Episode_To IS NULL THEN NULL ELSE P.Platform_Code END, Title_For 
			FROM #Deal_Rights_Title_New DRT
			INNER JOIN #Deal_Rights_Platform_New DRP ON 1 = 1
			LEFT JOIN @Deal_Rights_Title T2 ON DRT.Title_Code = T2.Title_Code AND DRT.Episode_From = T2.Episode_From AND DRT.Episode_To = T2.Episode_To
			LEFT JOIN Platform P ON DRP.Platform_Code = P.Platform_Code AND P.Is_No_Of_Run = 'Y'

			INSERT INTO #RunRecord (Title_Code, Episode_From, Episode_To, Title_For, Platform_Count)
			SELECT DISTINCT Title_Code, Episode_From, Episode_To, Title_For, COUNT(Platform_Code) AS Platform_Count  FROM #Temp
			GROUP BY Title_Code, Episode_From, Episode_To, Title_For
		END
	END
	ELSE
	BEGIN
		PRINT 'Called from Syn Rights Tab'
	END

	DECLARE @Title_Names NVARCHAR(MAX) = ''

	IF((SELECT COUNT(*) FROM #RunRecord WHERE Platform_Count = 0) > 0)
	BEGIN
		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
		IF(UPPER(@CallFrom)='AR')
			SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal WHERE Acq_Deal_Code = @Deal_Code
		ELSE
			SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal WHERE Syn_Deal_Code = @Deal_Code

		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)
		
		IF((SELECT COUNT(*) FROM #RunRecord WHERE Platform_Count = 0 AND Title_For = 'R' ) > 0)
		BEGIN
			SELECT @Title_Names += 
			dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, RR.Episode_From, RR.Episode_To) + ', '
			FROM #RunRecord RR INNER JOIN Title T ON RR.Title_Code = T.Title_Code
			WHERE Platform_Count = 0 AND Title_For = 'R'

			SET @Title_Names = LEFT(@Title_Names, LEN(@Title_Names) - 1)
			SET @Title_Names = 'Please select at least 1 cable right as Run Definition is already added for these Title(s) : ' + @Title_Names
		END
		ELSE
		BEGIN
			SELECT @Title_Names += 
			dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, RR.Episode_From, RR.Episode_To) + ', '
			FROM #RunRecord RR INNER JOIN Title T ON RR.Title_Code = T.Title_Code
			WHERE Platform_Count = 0 AND Title_For  = 'B'

			SET @Title_Names = LEFT(@Title_Names, LEN(@Title_Names) - 1)

			SET @Title_Names = LEFT(@Title_Names, LEN(@Title_Names) - 1)
			SET @Title_Names = 'Please select at least 1 cable right as Budget is already added for these Title(s) : ' + @Title_Names
		END
	END
	ELSE
		SET @Title_Names = ''

	SELECT @Title_Names as Error_Msg
END