CREATE PROCEDURE USP_Title_Objection_PreReq
(
	@TitleCode INT = 36672,
	@Record_Code INT = 21738,
	@Record_Type CHAR(1) = 'A',
	@PCodes NVARCHAR(MAX) = '17,20,21,22'
)
AS
BEGIN
	--DECLARE	@TitleCode INT = 37553,
	--@Record_Code INT = 22682,
	--@Record_Type CHAR(1) = 'A',
	--@PCodes NVARCHAR(MAX) = '380,73'

	SET NOCOUNT ON

	IF OBJECT_ID('tempdb..#DataMapping') IS NOT NULL DROP TABLE #DataMapping
	IF OBJECT_ID('tempdb..#Deal_Rights') IS NOT NULL DROP TABLE #Deal_Rights

	DECLARE @Counter INT, @Acq_Deal_Rights_Code INT ,  @Deal_Rights_Count INT, @TerritoryCode INT

	CREATE TABLE #DataMapping (
		Code INT,
		CodeFor CHAR(1),
		StartDate DATETIME,
		EndDate DATETIME,
		Obj_Type_Name  VARCHAR(MAX),
		Obj_Type_Group  VARCHAR(MAX),
		MapFor VARCHAR(MAX)
	)
	
	DECLARE @TABLE AS TABLE (
		CountryCode INT,
		Deal_Rights_Code INT
	)

	DECLARE @Tbl_Territory AS TABLE (
		Id INT IDENTITY(1,1) NOT NULL,
		TerritoryCode INT,
		Deal_Rights_Code INT
	)

	DECLARE @CntTer_Exists AS TABLE (
		Id INT IDENTITY(1,1) NOT NULL,
		TerritoryCode INT,
		CountryCode INT,
		Is_Exists CHAR(1)
	)

	CREATE TABLE #Deal_Rights
	(
		Id INT IDENTITY(1,1) NOT NULL,
		Deal_Rights_Code INT
	)

	IF(@Record_Type = 'A')
	BEGIN
		IF(@PCodes <> '')
		BEGIN
			INSERT INTO #Deal_Rights(Deal_Rights_Code)
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN acq_Deal_rights_platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			WHERE (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
				AND ADRP.Platform_Code in (SELECT number from dbo.fn_Split_withdelemiter( @PCodes,','))

			SELECT @Deal_Rights_Count = COUNT(*), @Counter=1 FROM #Deal_Rights

			WHILE (@Counter <= @Deal_Rights_Count )
			BEGIN
				SELECT @Acq_Deal_Rights_Code = Deal_Rights_Code FROM #Deal_Rights WHERE Id = @Counter
			
				IF((SELECT TOP 1 Territory_Type FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code) = 'G')
				BEGIN
					INSERT INTO @TABLE(CountryCode, Deal_Rights_Code)
					SELECT DISTINCT Country_Code, @Acq_Deal_Rights_Code FROM Territory_Details WHERE Territory_Code IN 
					(SELECT Territory_Code FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)

					INSERT INTO @Tbl_Territory (TerritoryCode, Deal_Rights_Code)
					SELECT Territory_Code, @Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				END
				ELSE
				BEGIN
					INSERT INTO @TABLE(CountryCode, Deal_Rights_Code)
					SELECT Country_Code, @Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				END
				SET @Counter  = @Counter  + 1
			END

			INSERT INTO #DataMapping(Code, CodeFor, MapFor)
			SELECT A.CountryCode, 'I', 'TERRITORY' FROM (SELECT CountryCode, COUNT(CountryCode) CNT FROM @TABLE GROUP BY CountryCode ) AS A WHERE A.CNT = @Deal_Rights_Count
		
			INSERT INTO #DataMapping(StartDate, EndDate, MapFor)
			SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date, 'SDED'
			FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			WHERE  (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
				AND ( @PCodes = '' OR ADR.Acq_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))
			ORDER BY Actual_Right_Start_Date,Actual_Right_End_Date

			SET @Counter=1
			WHILE ( @Counter <= (SELECT COUNT(*) FROM @Tbl_Territory))
			BEGIN
				SELECT @TerritoryCode = TerritoryCode FROM @Tbl_Territory WHERE Id = @Counter

				INSERT INTO @CntTer_Exists(TerritoryCode, CountryCode)
				SELECT DISTINCT Territory_Code, Country_Code FROM Territory_Details WHERE Territory_Code = @TerritoryCode

				UPDATE A SET A.Is_Exists='Y' FROM @CntTer_Exists A
				INNER JOIN #DataMapping B ON A.CountryCode = B.Code 
				WHERE B.CodeFor = 'I' AND B.MapFor = 'TERRITORY'

				IF NOT EXISTS (SELECT TOP 1 * FROM @CntTer_Exists WHERE ISNULL(Is_Exists,'') = '')
				BEGIN
					INSERT INTO #DataMapping(Code, CodeFor, MapFor)
					SELECT @TerritoryCode, 'G', 'TERRITORY'
				END

				DELETE FROM @CntTer_Exists
				SET @Counter  = @Counter  + 1
			END
		END
		
		INSERT INTO #DataMapping(Code, MapFor)
		SELECT DISTINCT ADRP.Platform_Code ,'PLATFORM'
		FROM Acq_Deal_Rights ADR
			 INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			 INNER JOIN acq_Deal_rights_platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		/*
		INSERT INTO #DataMapping(Code, CodeFor, MapFor)
		SELECT DISTINCT COALESCE(ADRT.Country_Code, ADRT.Territory_Code) AS Territory_Code, ADRT.Territory_Type, 'TERRITORY'
		FROM Acq_Deal_Rights_Territory ADRT
			 INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			 INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
			AND ( @PCodes = '' OR ADR.Acq_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))
		*/
	END
	ELSE IF(@Record_Type = 'S')
	BEGIN
		IF(@PCodes <> '')
		BEGIN
			INSERT INTO #Deal_Rights(Deal_Rights_Code)
			SELECT DISTINCT ADRP.Syn_Deal_Rights_Code
			FROM Syn_Deal_Rights ADR
				 INNER JOIN Syn_Deal_Rights_Title ADM ON ADM.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
				 INNER JOIN Syn_Deal_rights_platform ADRP ON ADRP.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
			WHERE (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
				AND ADRP.Platform_Code in (SELECT number from dbo.fn_Split_withdelemiter(@PCodes,','))

			SELECT @Deal_Rights_Count = COUNT(*), @Counter=1 FROM #Deal_Rights

			WHILE (@Counter <= @Deal_Rights_Count )
			BEGIN
				SELECT @Acq_Deal_Rights_Code = Deal_Rights_Code FROM #Deal_Rights WHERE Id = @Counter
			
				IF((SELECT TOP 1 Territory_Type FROM Syn_Deal_Rights_Territory where Syn_Deal_Rights_Code = @Acq_Deal_Rights_Code) = 'G')
				BEGIN
					INSERT INTO @TABLE(CountryCode, Deal_Rights_Code)
					SELECT DISTINCT Country_Code, @Acq_Deal_Rights_Code FROM Territory_Details WHERE Territory_Code IN 
					(SELECT Territory_Code FROM Syn_Deal_Rights_Territory where Syn_Deal_Rights_Code = @Acq_Deal_Rights_Code)
				END
				ELSE
				BEGIN
					INSERT INTO @TABLE(CountryCode, Deal_Rights_Code)
					SELECT Country_Code, @Acq_Deal_Rights_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code = @Acq_Deal_Rights_Code
				END
				SET @Counter  = @Counter  + 1
			END

			INSERT INTO #DataMapping(Code, CodeFor, MapFor)
			SELECT A.CountryCode, 'I', 'TERRITORY' FROM (SELECT CountryCode, COUNT(CountryCode) CNT FROM @TABLE GROUP BY CountryCode ) AS A WHERE A.CNT = @Deal_Rights_Count

			INSERT INTO #DataMapping(StartDate, EndDate, MapFor)
			SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date, 'SDED'
			FROM Syn_Deal_Rights ADR
				INNER JOIN Syn_Deal_Rights_Title ADM ON ADM.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
			WHERE  (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
				AND ( @PCodes = '' OR ADR.Syn_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))
			ORDER BY Actual_Right_Start_Date,Actual_Right_End_Date

			SET @Counter=1
			WHILE ( @Counter <= (SELECT COUNT(*) FROM @Tbl_Territory))
			BEGIN
				SELECT @TerritoryCode = TerritoryCode FROM @Tbl_Territory WHERE Id = @Counter

				INSERT INTO @CntTer_Exists(TerritoryCode, CountryCode)
				SELECT DISTINCT Territory_Code, Country_Code FROM Territory_Details WHERE Territory_Code = @TerritoryCode

				UPDATE A SET A.Is_Exists='Y' FROM @CntTer_Exists A
				INNER JOIN #DataMapping B ON A.CountryCode = B.Code 
				WHERE B.CodeFor = 'I' AND B.MapFor = 'TERRITORY'

				IF NOT EXISTS (SELECT TOP 1 * FROM @CntTer_Exists WHERE ISNULL(Is_Exists,'') = '')
				BEGIN
					INSERT INTO #DataMapping(Code, CodeFor, MapFor)
					SELECT @TerritoryCode, 'G', 'TERRITORY'
				END

				DELETE FROM @CntTer_Exists
				SET @Counter  = @Counter  + 1
			END
		END

		INSERT INTO #DataMapping(Code, MapFor)
		SELECT DISTINCT ADRP.Platform_Code ,'PLATFORM'
		FROM Syn_Deal_Rights ADR
			 INNER JOIN Syn_Deal_Rights_Title ADM ON ADM.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
			 INNER JOIN Syn_Deal_rights_platform ADRP ON ADRP.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
		WHERE  (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		INSERT INTO #DataMapping(Code, CodeFor, MapFor)
		SELECT DISTINCT COALESCE(ADRT.Country_Code, ADRT.Territory_Code) AS Territory_Code, ADRT.Territory_Type, 'TERRITORY'
		FROM Syn_Deal_Rights_Territory ADRT
			 INNER JOIN Syn_Deal_Rights ADR ON ADR.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code
			 INNER JOIN Syn_Deal_Rights_Title ADM ON ADM.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
			AND ( @PCodes = '' OR ADR.Syn_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))

		
	END

	--INSERT INTO #DataMapping(Code, CodeFor, MapFor)
	--SELECT DISTINCT Country_Code,'I','TERRITORY' FROM Territory_Details WHERE Territory_Code IN 
	--(SELECT Code FROM #DataMapping WHERE MapFor = 'TERRITORY' And ISNULL(CodeFor,'') = 'G')
	
	INSERT INTO #DataMapping(Code, Obj_Type_Group, Obj_Type_Name, MapFor)
	SELECT B.Objection_Type_Code, A.Objection_Type_Name , B.Objection_Type_Name , 'TYPEOFOBJECTION'
	FROM Title_Objection_Type A
	INNER JOIN Title_Objection_Type B ON A.Objection_Type_Code = B.Parent_Objection_Type_Code

	UPDATE A SET A.Obj_Type_Name = C.Country_Name FROM #DataMapping A INNER JOIN Country C  ON A.Code = C.Country_Code WHERE A.CodeFor = 'I' AND MapFor = 'TERRITORY'
	UPDATE A SET A.Obj_Type_Name = C.Territory_Name FROM #DataMapping A INNER JOIN Territory C  ON A.Code = C.Territory_Code WHERE A.CodeFor = 'G' AND MapFor = 'TERRITORY'

	DECLARE @Perpertuity_Term_In_Year INT
	SELECT @Perpertuity_Term_In_Year = Parameter_Value FROM system_parameter_new WHERE parameter_name = 'Perpertuity_Term_In_Year'

	UPDATE  #DataMapping SET EndDate = DATEADD(day ,-1, DATEADD(year, @Perpertuity_Term_In_Year, StartDate))
	WHERE MapFor = 'SDED' And EndDate IS NULL

	SELECT DISTINCT Code, CodeFor, StartDate, EndDate, Obj_Type_Group, Obj_Type_Name, MapFor FROM #DataMapping

	IF OBJECT_ID('tempdb..#DataMapping') IS NOT NULL DROP TABLE #DataMapping
	IF OBJECT_ID('tempdb..#Deal_Rights') IS NOT NULL DROP TABLE #Deal_Rights
END

