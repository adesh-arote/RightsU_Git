CREATE PROCEDURE [dbo].[USP_Validate_LP]
(
	@Deal_Code INT,
	@Title_Code  VARCHAR(max),
	@EpsFrom INT,
	@EpsTo INT
	,@Module_Code INT
)
AS
BEGIN
	--DECLARE @Deal_Code INT = 7863,@Title_Code VARCHAR(max) = '2028,5332',@EpsFrom INT = 1, @EpsTo INT = 1, @Module_Code INT = 30
	--DECLARE @Module_Code INT = 30
	DECLARE @TitleCNT INT = 0
	 SET FMTONLY OFF  
	 SET NOCOUNT ON  
	 DECLARE @DealTypeCode INT,@DealTypeProgram VARCHAR(100),@DealTP VARCHAR(100)

	 
	 IF(@Module_Code = 30)
	 BEGIN
		SELECT @DealTypeCode = Deal_Type_Code FROM Acq_Deal Where Acq_Deal_Code = @Deal_Code
		SELECT @DealTypeProgram = Deal_Type_Name FROM Deal_Type Where Deal_Type_Code = @DealTypeCode
		SELECT @DealTP =  dbo.UFN_GetDealTypeCondition(@DealTypeCode)
	 END
	 ELSE
	 BEGIN
		SELECT @DealTypeCode = Deal_Type_Code FROM Syn_Deal Where Syn_Deal_Code = @Deal_Code
		SELECT @DealTypeProgram = Deal_Type_Name FROM Deal_Type Where Deal_Type_Code = @DealTypeCode
		SELECT @DealTP =  dbo.UFN_GetDealTypeCondition(@DealTypeCode)
	 END

	IF OBJECT_ID('tempdb..#TempPeriod') IS NOT NULL DROP TABLE #TempPeriod
	CREATE TABLE #TempPeriod(
		RowID INT IDENTITY(1,1),
		Acq_Deal_Rights_Code INT,
		RightsStartDate DATETIME,
		RightsEndDate DATETIME,
		Title_Code INT,
		DtDiff INT,
		DtType VARCHAR(10),
		LPStart DATE,
		LPEnd DATE
	)
	IF OBJECT_ID('tempdb..#TempPeriodMultiTit') IS NOT NULL DROP TABLE #TempPeriodMultiTit
	CREATE TABLE #TempPeriodMultiTit(
		RowID INT IDENTITY(1,1),
		Acq_Deal_Rights_Code INT,
		RightsStartDate DATETIME,
		RightsEndDate DATETIME,
		Title_Code INT,
		DtDiff INT,
		DtType VARCHAR(10)
	)
	IF OBJECT_ID('tempdb..#TempSDED') IS NOT NULL DROP TABLE #TempSDED
	CREATE TABLE #TempSDED(
		Titcnt INT,
		LPStart Datetime,
		LPEnd Datetime
	)
	IF OBJECT_ID('tempdb..#TempMAXCNT') IS NOT NULL DROP TABLE #TempMAXCNT
	CREATE TABLE #TempMAXCNT(
		Titcnt INT,
		LPStart Datetime,
		LPEnd Datetime
	)

	IF(@Module_Code = 30)
	BEGIN
		IF(UPPER(@DealTP) = 'DEAL_PROGRAM' AND UPPER(@DealTypeProgram) <> 'SPORTS')
		BEGIN
			INSERT INTO #TempPeriod(Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType)
			SELECT DISTINCT ADR.Acq_Deal_Rights_Code, ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,ADM.Acq_Deal_Movie_Code,0,'N' AS DtType FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			INNER JOIN Acq_Deal_Movie ADM ON ADRT.Title_Code = ADM.Title_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To
			WHERE ADR.Acq_Deal_Code = @Deal_Code AND ADM.Acq_Deal_Movie_Code IN((select number from fn_Split_withdelemiter(@Title_Code ,','))) 
			AND ADRT.Title_Code = adm.Title_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To --AND ADR.PA_Right_Type = 'PR'
		END
		--ELSE IF(UPPER(@DealTypeProgram) = 'SPORTS')
		--BEGIN
		--	INSERT INTO #TempPeriod(Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType)
		--	SELECT DISTINCT ADR.Acq_Deal_Rights_Code, ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,ADM.Acq_Deal_Movie_Code,0,'N' AS DtType FROM Acq_Deal_Rights ADR
		--	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
		--	INNER JOIN Acq_Deal_Movie ADM ON ADRT.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
		--	WHERE ADR.Acq_Deal_Code = @Deal_Code AND ADM.Acq_Deal_Movie_Code IN((select number from fn_Split_withdelemiter(@Title_Code ,','))) 
		--	AND ADRT.Title_Code = adm.Title_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADRT.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
		--	AND ADR.PA_Right_Type = 'PR'
		--END
		ELSE
		BEGIN
			INSERT INTO #TempPeriod(Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType)
			SELECT DISTINCT ADR.Acq_Deal_Rights_Code, ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,ADRT.Title_Code,0,'N' AS DtType FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			WHERE ADR.Acq_Deal_Code = @Deal_Code AND ADRT.Title_Code  IN((select number from fn_Split_withdelemiter(@Title_Code ,','))) 
			--AND ADR.PA_Right_Type = 'PR'
		END
	END
	ELSE
	BEGIN
		IF(UPPER(@DealTP) = 'DEAL_PROGRAM' OR UPPER(@DealTypeProgram) = 'SPORTS')
		BEGIN
			INSERT INTO #TempPeriod(Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType)
			SELECT DISTINCT ADR.Syn_Deal_Rights_Code, ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,ADM.Syn_Deal_Movie_Code,0,'N' AS DtType FROM Syn_Deal_Rights ADR
			INNER JOIN Syn_Deal_Rights_Title ADRT ON ADRT.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code 
			INNER JOIN Syn_Deal_Movie ADM ON ADRT.Title_Code = ADM.Title_Code AND ADRT.Episode_From = ADM.Episode_From AND ADRT.Episode_To = ADM.Episode_End_To 
			WHERE ADR.Syn_Deal_Code = @Deal_Code AND ADM.Syn_Deal_Movie_Code IN((select number from fn_Split_withdelemiter(@Title_Code ,','))) 
			--AND ADR.PA_Right_Type = 'PR'
		END
		ELSE
		BEGIN
			INSERT INTO #TempPeriod(Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType)
			SELECT DISTINCT ADR.Syn_Deal_Rights_Code, ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,ADRT.Title_Code,0,'N' AS DtType FROM Syn_Deal_Rights ADR
			INNER JOIN Syn_Deal_Rights_Title ADRT ON ADRT.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code 
			WHERE ADR.Syn_Deal_Code = @Deal_Code AND ADRT.Title_Code IN((select number from fn_Split_withdelemiter(@Title_Code ,',')))  --AND ADRT.Episode_From = @EpsFrom AND ADRT.Episode_To = @EpsTo 
			--AND ADR.PA_Right_Type = 'PR'
		END
	END
	
	DECLARE @RowId INT,@Acq_Deal_Rights_Code INT,@RightsStartDate Datetime,@RightsEndDate Datetime,@CNT INT = 0,@PRVDt DATETIME,@NXTDt DATETIME,@TitleCD INT,@MaxTitCNT INT
	select @TitleCNT =  Count(number) from fn_Split_withdelemiter(@Title_Code ,',')
	IF(@TitleCNT > 1)
	BEGIN
		--INSERT INTO #TempPeriodMultiTit(Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType)
		--SELECT Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,Title_Code,DtDiff,DtType FROM #TempPeriod
		
		--INSERT INTO #TempPeriod(Title_Code, RightsStartDate, RightsEndDate)
		--SELECT 46848, '01-JAN-2025', '31-DEC-2026'
		--UNION
		--SELECT 46848, '01-JAN-2026', '31-DEC-2027'
		--UNION
		--SELECT 46848, '01-JAN-2028', '31-DEC-2028'
		--UNION
		--SELECT 46847, '01-JAN-2028', '31-DEC-2028'

		--Select * from #TempPeriod ORDER BY Title_Code, RightsStartDate ASC

		INSERT INTO #TempSDED(Titcnt,LPStart,LPEnd)
		SELECT DISTINCT Title_Code, LPStart, LPEnd FROM (
			SELECT TPM1.Title_Code, TPM1.RightsStartDate, TPM1.RightsEndDate, 
			MIN(TPMT2.RightsStartDate) AS LPStart, MAX(TPMT2.RightsEndDate) AS LPEnd
			from #TempPeriod TPM1
			INNER JOIN #TempPeriod TPMT2 ON TPM1.Title_Code = TPMT2.Title_Code AND --TPM1.RowID <> TPMT2.RowID AND 
			(
				TPM1.RightsStartDate BETWEEN TPMT2.RightsStartDate AND TPMT2.RightsEndDate OR
				TPM1.RightsEndDate BETWEEN TPMT2.RightsStartDate AND TPMT2.RightsEndDate OR
				TPMT2.RightsStartDate BETWEEN TPM1.RightsStartDate AND TPM1.RightsEndDate OR
				TPMT2.RightsEndDate BETWEEN TPM1.RightsStartDate AND TPM1.RightsEndDate
			) 
			GROUP BY TPM1.Title_Code, TPM1.RightsStartDate, TPM1.RightsEndDate
		) AS tmp
		--Select * from #TempSDED
		INSERT INTO #TempMAXCNT(Titcnt,LPStart,LPEnd) 
		SELECT COUNT(Titcnt),LPStart,LPEnd   FROM #TempSDED GROUP BY LPStart,LPEnd 
		
		--Select * from #TempMAXCNT
		SELECT @MaxTitCNT =   MAX(Titcnt) FROM #TempMAXCNT
		--Select @TitleCNT,@MaxTitCNT
		IF(@TitleCNT = @MaxTitCNT)
		BEGIN
			INSERT INTO #TempPeriodMultiTit(Acq_Deal_Rights_Code,Title_Code,RightsStartDate,RightsEndDate)
			SELECT DISTINCT TP.Acq_Deal_Rights_Code,TP.Title_Code,TMC.LPStart,TMC.LPEnd FROM #TempMAXCNT TMC
			INNER JOIN #TempPeriod TP ON TMC.LPStart = TP.RightsStartDate AND TMC.LPEnd = TP.RightsEndDate
			WHERE TMC.Titcnt = @TitleCNT
		END

		--DROP TABLE #TempLP

		--Select TPM1.Title_Code, TPM1.RightsStartDate, TPM1.RightsEndDate, 
		--(
		--	SELECT MIN(TPMT2.RightsStartDate) FROM #TempPeriod TPMT2 
		--	WHERE TPM1.Title_Code = TPMT2.Title_Code --AND TPM1.RowID <> TPMT2.RowID 
		--	AND 
		--	(
		--		TPM1.RightsStartDate BETWEEN TPMT2.RightsStartDate AND TPMT2.RightsEndDate OR
		--		TPM1.RightsEndDate BETWEEN TPMT2.RightsStartDate AND TPMT2.RightsEndDate OR
		--		TPMT2.RightsStartDate BETWEEN TPM1.RightsStartDate AND TPM1.RightsEndDate OR
		--		TPMT2.RightsEndDate BETWEEN TPM1.RightsStartDate AND TPM1.RightsEndDate
		--	) 
		--) AS LPStart
		--FROM #TempPeriod TPM1
		--INNER JOIN #TempPeriod TPMT2 ON TPM1.Title_Code = TPMT2.Title_Code AND TPM1.RowID <> TPMT2.RowID AND 
		--(
		--	TPM1.RightsStartDate BETWEEN TPMT2.RightsStartDate AND TPMT2.RightsEndDate OR
		--	TPM1.RightsEndDate BETWEEN TPMT2.RightsStartDate AND TPMT2.RightsEndDate OR
		--	TPMT2.RightsStartDate BETWEEN TPM1.RightsStartDate AND TPM1.RightsEndDate OR
		--	TPMT2.RightsEndDate BETWEEN TPM1.RightsStartDate AND TPM1.RightsEndDate
		--) 
		--GROUP BY TPM1.Title_Code, TPM1.RightsStartDate, TPM1.RightsEndDate
		TRUNCATE TABLE #TempPeriod
	END
	ELSE
	BEGIN
		--Select RightsStartDate,RightsEndDate,Count(Title_Code) from #TempPeriod TP1 GROUP BY RightsStartDate,RightsEndDate
		DECLARE RightCursor CURSOR FOR SELECT RowID,Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate FROM #TempPeriod
		OPEN RightCursor FETCH NEXT FROM RightCursor INTO @RowId,@Acq_Deal_Rights_Code,@RightsStartDate,@RightsEndDate
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(@CNT > 0)
			BEGIN
				SELECT @PRVDt = RightsEndDate FROM #TempPeriod WHERE RowID = @CNT
				SELECT @NXTDt = RightsStartDate FROM #TempPeriod WHERE RowID = @CNT + 1
				--SELECT @PRVDt,@NXTDt
				UPDATE TP SET TP.DtDiff = DATEDIFF(DAY,@PRVDt,@NXTDt) 
				FROM #TempPeriod TP Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			END
			SET @CNT = @CNT + 1
		FETCH NEXT FROM RightCursor
			INTO @RowId,@Acq_Deal_Rights_Code,@RightsStartDate,@RightsEndDate
		END
		CLOSE RightCursor
		DEALLOCATE RightCursor
	END
	UPDATE #TempPeriod SET DtType = 'G' WHERE DtDiff > 1
	UPDATE #TempPeriod SET DtType = 'C' WHERE DtDiff = 1
	
	IF((Select COUNT(*) FROM #TempPeriod) > 1)
	BEGIN
		IF EXISTS(Select * FROM #TempPeriod WHERE DtType IN('G','C'))
		BEGIN
			Select 1 as RowID,1 as Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,0 as DtDiff, '' as DtType from #TempPeriod
		END
		ELSE
		BEGIN
			Select DISTINCT  1 as RowID,0 as Acq_Deal_Rights_Code,MIN(RightsStartDate) as RightsStartDate,MAX(RightsEndDate) as RightsEndDate,0 as DtDiff,DtType from #TempPeriod
			GROUP BY DtType
		END
	END
	ELSE IF((Select COUNT(*) FROM #TempPeriodMultiTit) > 0)
	BEGIN
		Select DISTINCT 0 as RowID,0 as Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,ISNULL(DtDiff,0) as DtDiff,ISNULL(DtType,0) AS DtType from #TempPeriodMultiTit
	END
	ELSE
	BEGIN
		Select RowID,Acq_Deal_Rights_Code,RightsStartDate,RightsEndDate,DtDiff,DtType from #TempPeriod
	END

	--Select * from #TempPeriodMultiTit
END