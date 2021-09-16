CREATE PROCEDURE USP_Title_Objection_PreReq
(
	@TitleCode INT = 36672,
	@Record_Code INT = 21738,
	@Record_Type CHAR(1) = 'A'
)
AS
BEGIN
	--DECLARE @TitleCode INT = 36672,
	--		@Record_Code INT = 21738,
	--		@Record_Type CHAR(1) = 'A'

	IF OBJECT_ID('tempdb..#DataMapping') IS NOT NULL DROP TABLE #DataMapping

	CREATE TABLE #DataMapping (
		Code INT,
		CodeFor CHAR(1),
		StartDate DATETIME,
		EndDate DATETIME,
		Obj_Type_Name  VARCHAR(MAX),
		Obj_Type_Group  VARCHAR(MAX),
		MapFor VARCHAR(MAX)
	)

	IF(@Record_Type = 'A')
	BEGIN

		INSERT INTO #DataMapping(Code, MapFor)
		SELECT DISTINCT ADRP.Platform_Code ,'PLATFORM'
		FROM Acq_Deal_Rights ADR
			 INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
			 INNER JOIN acq_Deal_rights_platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		INSERT INTO #DataMapping(Code, CodeFor, MapFor)
		SELECT DISTINCT COALESCE(ADRT.Country_Code, ADRT.Territory_Code) AS Territory_Code, ADRT.Territory_Type, 'TERRITORY'
		FROM Acq_Deal_Rights_Territory ADRT
			 INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			 INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		INSERT INTO #DataMapping(StartDate, EndDate, MapFor)
		SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date, 'SDED'
		FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Acq_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
		ORDER BY Actual_Right_Start_Date,Actual_Right_End_Date

	END
	ELSE IF(@Record_Type = 'S')
	BEGIN
		INSERT INTO #DataMapping(Code, MapFor)
		SELECT DISTINCT ADRP.Platform_Code ,'PLATFORM'
		FROM Syn_Deal_Rights ADR
			 INNER JOIN Syn_Deal_Movie ADM ON ADM.Syn_Deal_Code = ADR.Syn_Deal_Code
			 INNER JOIN Syn_Deal_rights_platform ADRP ON ADRP.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		INSERT INTO #DataMapping(Code, CodeFor, MapFor)
		SELECT DISTINCT COALESCE(ADRT.Country_Code, ADRT.Territory_Code) AS Territory_Code, ADRT.Territory_Type, 'TERRITORY'
		FROM Syn_Deal_Rights_Territory ADRT
			 INNER JOIN Syn_Deal_Rights ADR ON ADR.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code
			 INNER JOIN Syn_Deal_Movie ADM ON ADM.Syn_Deal_Code = ADR.Syn_Deal_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode

		INSERT INTO #DataMapping(StartDate, EndDate, MapFor)
		SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date, 'SDED'
		FROM Syn_Deal_Rights ADR
			INNER JOIN Syn_Deal_Movie ADM ON ADM.Syn_Deal_Code = ADR.Syn_Deal_Code
		WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Syn_Deal_Code = @Record_Code AND ADM.Title_Code = @TitleCode
		ORDER BY Actual_Right_Start_Date,Actual_Right_End_Date
	END

	INSERT INTO #DataMapping(Obj_Type_Group, Obj_Type_Name, MapFor)
	SELECT A.Objection_Type_Name , B.Objection_Type_Name , 'TYPEOFOBJECTION'
	FROM Title_Objection_Type A
	INNER JOIN Title_Objection_Type B ON A.Objection_Type_Code = B.Parent_Objection_Type_Code

	SELECT DISTINCT Code, CodeFor, StartDate, EndDate, Obj_Type_Group, Obj_Type_Name MapFor FROM #DataMapping
END