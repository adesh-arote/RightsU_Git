CREATE PROC USP_Get_Title_WBS_Data
(
	@Acq_Deal_Code INT,
	@callForMilestone CHAR(1)
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 2 June 2015
-- Description:	List of All ASP_WBS_code with Start Date and End Date
-- =============================================
BEGIN

	--DECLARE @Acq_Deal_Code INT = 3122
	SET FMTONLY OFF

	CREATE TABLE #Temp_Previous_Data
	(
		WBS_Code VARCHAR(MAX), 
		WBS_Start_Date DATETIME, 
		WBS_End_Date DATETIME,
		Ignore CHAR(1)
	)

	CREATE TABLE #Temp_Current_Data
	(
		WBS_Code VARCHAR(MAX), 
		WBS_Start_Date DATETIME, 
		WBS_End_Date DATETIME,
		Ignore CHAR(1)
	)

	DECLARE @VersionNo INT, @AT_Acq_Deal_Code INT = 0
	SELECT @VersionNo = Cast(Version as INT) FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code

	SELECT ADB.Acq_Deal_Code, ADB.Title_Code, ADB.Episode_From, ADB.Episode_To, SW.WBS_Code, MIN(ADR.Actual_Right_Start_Date) AS Title_Start_Date,
	CASE WHEN ADR.Right_Type = 'U' THEN CAST('31/dec/9999' AS DATETIME) ELSE MAX(ADR.Actual_Right_End_Date) END AS Title_End_Date INTO #Temp_Data_Cur
	FROM Acq_Deal_Budget ADB
	INNER JOIN SAP_WBS SW ON SW.SAP_WBS_Code = ADB.SAP_WBS_Code
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = ADB.Acq_Deal_Code 
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
	INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
	AND ADRT.Title_Code = ADB.Title_Code AND ADRT.Episode_From = ADB.Episode_From AND ADRT.Episode_To = ADB.Episode_To
	WHERE ADRP.Platform_Code IN (SELECT Platform_Code FROM Platform WHERE ISNULL(Is_No_Of_Run, '') = 'Y') AND
	ADB.Acq_Deal_Code = @Acq_Deal_Code AND 
	(
		(ADR.Right_Type IN ('U') AND Actual_Right_Start_Date IS NOT NULL AND ISNULL(ADR.Is_Tentative, 'N') = 'N') OR 
		(Actual_Right_Start_Date IS NOT NULL AND Actual_Right_End_Date IS NOT NULL AND ISNULL(ADR.Is_Tentative, 'N') = 'N')
	)
	GROUP BY ADB.Acq_Deal_Code, ADB.Title_Code, ADB.Episode_From, ADB.Episode_To, SW.WBS_Code, ADR.Right_Type

	INSERT INTO #Temp_Current_Data
	select WBS_Code, MIN(Title_Start_Date) AS WBS_Start_Date, MAX(Title_End_Date) AS WBS_End_Date, 'N' from #Temp_Data_Cur
	GROUP BY WBS_Code

	IF(@VersionNo > 1)
	BEGIN
		SELECT @AT_Acq_Deal_Code = AT_Acq_Deal_Code FROM AT_Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code AND [Version] =  (@VersionNo - 1)
		SELECT ADB.AT_Acq_Deal_Code, ADB.Title_Code, ADB.Episode_From, ADB.Episode_To, SW.WBS_Code, MIN(ADR.Actual_Right_Start_Date) AS Title_Start_Date,
		CASE WHEN ADR.Right_Type = 'U' THEN CAST('31/dec/9999' AS DATETIME) ELSE MAX(ADR.Actual_Right_End_Date) END AS Title_End_Date INTO #Temp_Data_Prev
		FROM AT_Acq_Deal_Budget ADB
		INNER JOIN SAP_WBS SW ON SW.SAP_WBS_Code = ADB.SAP_WBS_Code
		INNER JOIN AT_Acq_Deal_Rights ADR ON ADR.AT_Acq_Deal_Code = ADB.AT_Acq_Deal_Code 
		INNER JOIN AT_Acq_Deal_Rights_Title ADRT ON ADRT.AT_Acq_Deal_Rights_Code = ADR.AT_Acq_Deal_Rights_Code 
		INNER JOIN AT_Acq_Deal_Rights_Platform ADRP ON ADRP.AT_Acq_Deal_Rights_Code = ADR.AT_Acq_Deal_Rights_Code 
		AND ADRT.Title_Code = ADB.Title_Code AND ADRT.Episode_From = ADB.Episode_From AND ADRT.Episode_To = ADB.Episode_To
		WHERE ADRP.Platform_Code IN (SELECT Platform_Code FROM Platform WHERE ISNULL(Is_No_Of_Run, '') = 'Y') AND
		ADB.AT_Acq_Deal_Code = @AT_Acq_Deal_Code AND 
		(
			(ADR.Right_Type IN ('U') AND Actual_Right_Start_Date IS NOT NULL AND ISNULL(ADR.Is_Tentative, 'N') = 'N') OR 
			(Actual_Right_Start_Date IS NOT NULL AND Actual_Right_End_Date IS NOT NULL AND ISNULL(ADR.Is_Tentative, 'N') = 'N')
		)
		GROUP BY ADB.AT_Acq_Deal_Code, ADB.Title_Code, ADB.Episode_From, ADB.Episode_To, SW.WBS_Code, ADR.Right_Type

		INSERT INTO #Temp_Previous_Data
		SELECT WBS_Code, MIN(Title_Start_Date), MAX(Title_End_Date), 'N' FROM #Temp_Data_Prev
		GROUP BY WBS_Code

		UPDATE T SET T.Ignore = 'Y' FROM #Temp_Current_Data T
		INNER JOIN #Temp_Previous_Data P ON P.WBS_Code = T.WBS_Code 
		AND  CAST( P.WBS_Start_Date AS DATETIME) = CAST(T.WBS_Start_Date AS DATETIME)
		AND P.WBS_End_Date = T.WBS_End_Date

		UPDATE P SET P.Ignore = 'Y' FROM #Temp_Previous_Data P
		INNER JOIN #Temp_Current_Data T ON P.WBS_Code = T.WBS_Code 
		AND  CAST( P.WBS_Start_Date AS DATETIME) = CAST(T.WBS_Start_Date AS DATETIME)
		AND P.WBS_End_Date = T.WBS_End_Date

		DELETE FROM #Temp_Current_Data WHERE Ignore = 'Y'
		DELETE FROM #Temp_Previous_Data WHERE Ignore = 'Y' OR WBS_Code IN (SELECT WBS_Code FROM #Temp_Current_Data)

		UPDATE #Temp_Previous_Data SET WBS_Start_Date =  NULL, WBS_End_Date = NULL WHERE WBS_Code NOT IN (SELECT WBS_Code FROM #Temp_Current_Data)
	END

	SELECT WBS_Code, WBS_Start_Date, WBS_End_Date, '' AS Acknowledgement_Status, '' AS Error_Details FROM #Temp_Current_Data
	UNION
	SELECT WBS_Code, WBS_Start_Date, WBS_End_Date, '' AS Acknowledgement_Status, '' AS Error_Details FROM #Temp_Previous_Data

	IF OBJECT_ID('tempdb..#Temp_Data_Cur') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Data_Cur
	END
	IF OBJECT_ID('tempdb..#Temp_Data_Prev') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Data_Prev
	END
	IF OBJECT_ID('tempdb..#Temp_Current_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Current_Data
	END
	IF OBJECT_ID('tempdb..#Temp_Previous_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Previous_Data
	END
END