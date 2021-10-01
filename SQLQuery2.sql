ALTER PROCEDURE USP_Title_Objection_PreReq
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
	--@PCodes NVARCHAR(MAX) = ''

	IF OBJECT_ID('tempdb..#DataMapping') IS NOT NULL DROP TABLE #DataMapping
	IF OBJECT_ID('tempdb..#Deal_Rights') IS NOT NULL DROP TABLE #Deal_Rights

	CREATE TABLE #DataMapping (
		Code INT,
		CodeFor CHAR(1),
		StartDate DATETIME,
		EndDate DATETIME,
		Obj_Type_Name  VARCHAR(MAX),
		Obj_Type_Group  VARCHAR(MAX),
		MapFor VARCHAR(MAX)
	)
	
	CREATE TABLE #Deal_Rights
	(
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
		END

		INSERT INTO #DataMapping(Code, MapFor)
		SELECT DISTINCT ADRP.Platform_Code ,'PLATFORM'
		FROM Acq_Deal_Rights ADR
			 INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			 INNER JOIN acq_Deal_rights_platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		INSERT INTO #DataMapping(Code, CodeFor, MapFor)
		SELECT DISTINCT COALESCE(ADRT.Country_Code, ADRT.Territory_Code) AS Territory_Code, ADRT.Territory_Type, 'TERRITORY'
		FROM Acq_Deal_Rights_Territory ADRT
			 INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			 INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
			AND ( @PCodes = '' OR ADR.Acq_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))

		INSERT INTO #DataMapping(StartDate, EndDate, MapFor)
		SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date, 'SDED'
		FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE  (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
			AND ( @PCodes = '' OR ADR.Acq_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))
		ORDER BY Actual_Right_Start_Date,Actual_Right_End_Date

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

		INSERT INTO #DataMapping(StartDate, EndDate, MapFor)
		SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date, 'SDED'
		FROM Syn_Deal_Rights ADR
			INNER JOIN Syn_Deal_Rights_Title ADM ON ADM.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
		WHERE  (ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U') AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
			AND ( @PCodes = '' OR ADR.Syn_Deal_Rights_Code IN (SELECT DISTINCT Deal_Rights_Code FROM #Deal_Rights))
		ORDER BY Actual_Right_Start_Date,Actual_Right_End_Date
	END

	INSERT INTO #DataMapping(Code, CodeFor, MapFor)
	SELECT DISTINCT Country_Code,'I','TERRITORY' FROM Territory_Details WHERE Territory_Code IN 
	(SELECT Code FROM #DataMapping WHERE MapFor = 'TERRITORY' And ISNULL(CodeFor,'') = 'G')

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