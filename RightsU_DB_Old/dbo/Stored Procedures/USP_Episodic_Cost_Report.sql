ALTER proc [dbo].[usp_Episodic_Cost_Report] 
	@DealCode INT,
	@TitleCode VARCHAR(MAX),
	@Eps_From INT,
	@Eps_To INT,
	@BUCode INT
AS
 --=============================================
 --Author:  Akshay Rane
 --Create date: 08 May  2016
 --Description: This Procedure will calculate the per episode cost acording to the episode number of the particular title of the deal
 --=============================================
BEGIN
	--DECLARE
	--@DealCode INT,
	--@TitleCode VARCHAR(MAX),
	--@Eps_From INT,
	--@Eps_To INT,
	--@BUCode INT
	--SET @DealCode = ''
	--SET @TitleCode = '18499 , 21597'
	--SET @Eps_From = 1
	--SET @Eps_To = 3
	--SET @BUCode = 5

	IF(OBJECT_ID('TEMPDB..#EpsSeq') IS NOT NULL)
		DROP TABLE #EpsSeq

	IF(OBJECT_ID('TEMPDB..#TempTitle') IS NOT NULL)
		DROP TABLE #TempTitle

	IF(OBJECT_ID('TEMPDB..#TempTitleCost') IS NOT NULL)
		DROP TABLE #TempTitleCost

	IF(OBJECT_ID('TEMPDB..#TempCost') IS NOT NULL)
		DROP TABLE #TempCost

	IF(OBJECT_ID('TEMPDB..#TempResult') IS NOT NULL)
		DROP TABLE #TempResult


	CREATE TABLE #TempResult
	(
		Deal_Name NVARCHAR(MAX),
		Deal_Type_Desc NVARCHAR(MAX),
		Eps_No INT,
		Eps_Cost NUMERIC(14,2),
		Agreement_No VARCHAR(50),
		Cost_Type VARCHAR(1000)	
	)

	Create Table #EpsSeq(
		EpsNo Int
	)

	CREATE TABLE #TempCost
	(
		Deal_Type_Name NVARCHAR(MAX),
		Deal_Desc NVARCHAR(MAX),
		Amount NUMERIC(14,2),
		Per_Eps_Amount NUMERIC(14,2),
		Episode_From INT,
		Episode_To INT,
		Agreement_No VARCHAR(50),
		Cost_Type VARCHAR(1000)	
	)

	CREATE TABLE #TempTitleCost
	(
		RowNo_Cost INT,
		Title_Code_Cost INT,
		Acq_Deal_Code_Cost INT,
		Episode_Starts_From_Cost INT,
		Episode_End_To_Cost INT,
		Title_Name_Cost NVARCHAR(MAX),	
		IsProcessed_Cost CHAR(1)
	)

	CREATE TABLE #TempTitle
	(
		RowNo INT IDENTITY(1,1),
		Title_Code INT,
		Acq_Deal_Code INT,
		Episode_Starts_From INT,
		Episode_End_To INT,
		Title_Name NVARCHAR(MAX),	
		IsProcessed CHAR(1) DEFAULT('N'),
	)
	INSERT INTO #TempTitle
	(
		Title_Code ,
		Acq_Deal_Code ,
		Episode_Starts_From ,
		Episode_End_To ,
		Title_Name	
	)
	Select
	t.Title_Code,
	ad.Acq_Deal_Code,
	adct.Episode_From,
	adct.Episode_To,
	t.Title_Name
	From Acq_Deal ad
	INNER JOIN Acq_Deal_Cost adc on ad.Acq_Deal_Code = adc.Acq_Deal_Code
	left outer  join Acq_Deal_Cost_Title adct on adc.Acq_Deal_Cost_Code = adct.Acq_Deal_Cost_Code
	left outer  join Title t on t.Title_Code = adct.Title_Code 
	where 
	AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND 
	ad.Business_Unit_Code = @BUCode and
	(ad.Acq_Deal_Code = @DealCode OR ISNULL(@DealCode, '') = '') and 
	t.Title_Code in (select number from dbo.fn_Split_withdelemiter(@TitleCode,','))

	DECLARE @RowNo INT = 0,  @RowCounter INT = 0, @Start INT, @End INT
	 
	SELECT TOP 1 @RowNo = RowNo FROM #TempTitle WHERE IsProcessed = 'N'

	WHILE(@RowNo > 0)
	BEGIN
	
		INSERT INTO #TempTitleCost
		(
			RowNo_Cost,
			Title_Code_Cost,
			Acq_Deal_Code_Cost,
			Episode_Starts_From_Cost,
			Episode_End_To_Cost,
			Title_Name_Cost,	
			IsProcessed_Cost	
		)
		SELECT TOP 1 RowNo,Title_Code,Acq_Deal_Code,Episode_Starts_From,Episode_End_To,Title_Name,IsProcessed FROM #TempTitle WHERE  RowNo = @RowNo

		INSERT INTO #TempCost
		(
			Deal_Type_Name,
			Deal_Desc,
			Amount,
			Per_Eps_Amount,
			Episode_From,
			Episode_To,
			Agreement_No,
			Cost_Type
		)
		SELECT  dt.Deal_Type_Name, 
			t.Title_Name_Cost + ' ( ' + CONVERT(varchar(10),t.Episode_Starts_From_Cost) + ' To ' + CONVERT(varchar(10),t.Episode_End_To_Cost) + ' )' as deal_desc,
			adcce.Amount,
			adcce.Per_Eps_Amount ,
			adcce.Episode_From,
			adcce.Episode_To,
			ad.Agreement_No,
			ct.Cost_Type_Name AS Cost_Type
		FROM Acq_Deal ad
			INNER JOIN	 Deal_Type dt on dt.Deal_Type_Code = ad.Deal_Type_Code 
			INNER JOIN	 Acq_Deal_Cost adc on ad.Acq_Deal_Code = adc.Acq_Deal_Code
			INNER JOIN   Acq_Deal_Cost_Costtype adcc on adcc.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
			INNER JOIN   Acq_Deal_Cost_Costtype_Episode adcce on adcce.Acq_Deal_Cost_Costtype_Code = adcc.Acq_Deal_Cost_Costtype_Code
			INNER JOIN   Cost_Type ct on ct.Cost_Type_Code = adcc.Cost_Type_Code
			INNER JOIN   Acq_Deal_Cost_Title adct on adc.Acq_Deal_Cost_Code = adct.Acq_Deal_Cost_Code
			INNER JOIN   #TempTitleCost t on t.Title_Code_Cost = adct.Title_Code  and t.Episode_Starts_From_Cost = adct.Episode_From AND t.Episode_End_To_Cost = adct.Episode_To
		WHERE
		 AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND 
		 ad.Business_Unit_Code = @BUCode and
		 (ad.Acq_Deal_Code = @DealCode OR ISNULL(@DealCode, '') = '') and 
		 t.RowNo_Cost = @RowNo 
	
		SELECT @Start = Min(Episode_From), @End = Max(Episode_To) 
		From #TempCost
		;With NumberSequence( Number ) AS
		(
			SELECT @start AS Number
				UNION all
			SELECT Number + 1
				FROM NumberSequence
				WHERE Number < @end
		)
		INSERT INTO #EpsSeq SELECT Number FROM NumberSequence OPTION (MaxRecursion 10000)

		INSERT INTO #TempResult
		(	
			Deal_Type_Desc,
			Agreement_No,
			Cost_Type,
			Eps_No,
			Eps_Cost 
		)
		SELECT DISTINCT  deal_desc, Agreement_No, Cost_Type, EpsNo, Sum(Per_Eps_Amount) Eps_Cost FROM #TempCost a
		Cross Apply #EpsSeq b
		WHERE b.EpsNo Between a.Episode_From And a.Episode_To 
		GROUP BY  deal_desc, Agreement_No, Cost_Type, EpsNo

		TRUNCATE TABLE #TempTitleCost
		TRUNCATE TABLE #TempCost
		TRUNCATE TABLE #EpsSeq

		UPDATE #TempTitle SET IsProcessed  = 'Y' WHERE IsProcessed = 'N' AND RowNo = @RowNo
		SELECT @RowNo = 0
		SELECT TOP 1 @RowNo = RowNo FROM #TempTitle WHERE IsProcessed = 'N'

	END
	SELECT distinct Deal_Type_Desc, Agreement_No, Cost_Type, Eps_No,Eps_Cost FROM #TempResult WHERE Eps_No between @Eps_From and @Eps_To  order by Eps_No
END
--exec [usp_Episodic_Cost_Report] 0,'18499 , 21597',1,5,5
