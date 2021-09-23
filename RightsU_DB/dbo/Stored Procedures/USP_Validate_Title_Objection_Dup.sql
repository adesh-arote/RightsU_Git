CREATE  PROC [dbo].[USP_Validate_Title_Objection_Dup] 
(  
	@Title_Objection_UDT Title_Objection_UDT READONLY, 
	@User_Code INT= 143
)
AS
BEGIN
	IF(OBJECT_ID('TEMPDB..#Title_Objection_Dup_Check') IS NOT NULL)
		DROP TABLE #Title_Objection_Dup_Check

	IF(OBJECT_ID('TEMPDB..#Duplicate_Objection') IS NOT NULL)
		DROP TABLE #Duplicate_Objection
		
	--DECLARE @Title_Objection_UDT Title_Objection_UDT

	--INSERT INTO @Title_Objection_UDT
	--SELECT 0, '170,180','3,4,10','28-Jul-2013~27-Jul-2022,30-Jun-2013~29-Jun-2022,21-Jul-2013~20-Jul-2022',
	--'01-Sep-2021','01-Oct-2021','test','test',4,1,'C',584,'A',52

	DECLARE @Result CHAR(1) = 'N'

	DECLARE @Title_Objection_Code INT, @Record_Type CHAR(1), @Record_Code INT, @Title_Code INT, @Platform_Codes VARCHAR(MAX), @RPCodes NVARCHAR(MAX),
			@Obj_Start_Date VARCHAR(MAX), @Obj_End_Date VARCHAR(MAX), @CountryCodes VARCHAR(MAX), @CntTerr CHAR(1)

	CREATE TABLE #Duplicate_Objection(
		Title_Objection_Code INT,
		Status NVARCHAR(10),
		CNT INT
	)

	SELECT 
		@Title_Objection_Code = Title_Objection_Code,
		@Record_Type = RecordType,
		@Title_Code = TitleCode,
		@Record_Code = RecordCode,
		@Platform_Codes = PlatformCodes,
		@RPCodes = LPCodes,
		@Obj_Start_Date = SD,
		@Obj_End_Date = ED,
		@CountryCodes = CTCodes,
		@CntTerr = CntTerr
	FROM @Title_Objection_UDT

	SELECT * INTO #Title_Objection_Dup_Check 
	FROM Title_Objection 
	WHERE Title_Objection_Code <> @Title_Objection_Code 
	AND Record_Type = @Record_Type AND Title_Code = @Title_Code AND Record_Code= @Record_Code

	--Check Platform Code
	BEGIN
		INSERT INTO #Duplicate_Objection(Title_Objection_Code, Status)
		SELECT DISTINCT Title_Objection_Code, 'PC'
		FROM Title_Objection_Platform 
		WHERE
			Title_Objection_Code IN (SELECT Title_Objection_Code FROM #Title_Objection_Dup_Check) 
			AND Platform_Code IN (SELECT number from fn_Split_withdelemiter(@Platform_Codes,','))
	END

	--Check License Period
	BEGIN
		INSERT INTO #Duplicate_Objection(Title_Objection_Code, Status)
		SELECT A.Title_Objection_Code, 'LP' FROM (
			SELECT  Title_objection_Code ,CONVERT(VARCHAR, Rights_Start_Date, 106) +'~'+  CONVERT(VARCHAR, Rights_End_Date, 106) AS 'SDED'
			FROM Title_Objection_Rights_Period
			WHERE Title_Objection_Code IN (SELECT Title_Objection_Code FROM #Title_Objection_Dup_Check)
		) AS A
		WHERE A.SDED IN (SELECT REPLACE(number,'-',' ') FROM fn_Split_withdelemiter(@RPCodes,','))
	END

	--Chekin Rights Period
	BEGIN
		INSERT INTO #Duplicate_Objection(Title_Objection_Code, Status)
		SELECT Title_Objection_Code,'RP'
		FROM #Title_Objection_Dup_Check  
		WHERE CAST(@Obj_Start_Date AS DATE) BETWEEN  CAST(Objection_Start_Date AS DATE) AND CAST(Objection_End_Date AS DATE)

		INSERT INTO #Duplicate_Objection(Title_Objection_Code, Status)
		SELECT Title_Objection_Code,'RP'
		FROM #Title_Objection_Dup_Check  
		WHERE CAST(@Obj_End_Date AS DATE) BETWEEN  CAST(Objection_Start_Date AS DATE) AND CAST(Objection_End_Date AS DATE)
	END

	BEGIN
		IF(@CntTerr = 'T')
		BEGIN
			SELECT @CountryCodes = STUFF((
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM  Territory_Details WHERE Territory_Code IN (SELECT number FROM fn_Split_withdelemiter(@CountryCodes,','))
			FOR XML PATH('')
            ), 1, 1, '')
		END

		INSERT INTO #Duplicate_Objection(Title_Objection_Code, Status)
		SELECT DISTINCT A.Title_Objection_Code,'CT' FROM (
			SELECT DISTINCT Title_Objection_Code, Country_Code
			FROM Title_Objection_Territory
			WHERE Territory_Type = 'I' AND
				Title_Objection_Code IN (SELECT Title_Objection_Code FROM #Title_Objection_Dup_Check) 
			UNION
			SELECT DISTINCT TOT.Title_Objection_Code, TD.Country_Code
			FROM Title_Objection_Territory TOT
			INNER JOIN Territory_Details TD ON TD.Territory_Code = TOT.Territory_Code
			WHERE  Territory_Type = 'G' AND
				Title_Objection_Code IN (SELECT Title_Objection_Code FROM #Title_Objection_Dup_Check) 
		) AS A WHERE 
		A.Country_Code IN (
			SELECT number FROM fn_Split_withdelemiter(@CountryCodes,',')
		)
	END

	UPDATE B SET B.CNT = A.CNT FROM (
	SELECT Title_Objection_Code, COUNT(*) AS CNT FROM #Duplicate_Objection GROUP BY Title_Objection_Code
	) AS A INNER JOIN #Duplicate_Objection B ON A.Title_Objection_Code = B.Title_Objection_Code

	IF EXISTS (SELECT DISTINCT Title_Objection_Code, CNT FROM #Duplicate_Objection WHERE CNT = 4)
		SET @Result = 'Y'

	SELECT @Result AS 'Result'
END

