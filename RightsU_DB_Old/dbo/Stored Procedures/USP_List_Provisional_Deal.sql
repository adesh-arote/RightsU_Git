CREATE PROC USP_List_Provisional_Deal
(
	@SearchText NVARCHAR(MAX)	= '',
	@Agreement_No VARCHAR(50)	= '',
	@StartDate DATETIME	 = NULL,
	@EndDate DATETIME = NULL,
	@Deal_Type_Code INT = 0,
	@Business_Unit_Code INT = 0,
	@Vendor_Codes VARCHAR(MAX) = '',
	@Title_Codes VARCHAR(MAX) = '',
	@IsAdvance_Search CHAR(1) = 'N',
	@User_Code INT = 0,
	@PageNo INT = 1 OUT,
	@PageSize INT = 10,
	@RecordCount INT OUT
)
AS
/*=============================================
Author		: Akshay Rane
Create Date	: 04 Aug 2017
Description	: List of Provisional Deal
=============================================*/
BEGIN	
	SET FMTONLY OFF
	--DECLARE
	--@SearchText NVARCHAR(MAX) = '',
	--@Agreement_No VARCHAR(50) = '',
	--@StartDate DATETIME = '',
	--@EndDate DATETIME = '',
	--@Deal_Type_Code INT = 0,
	--@Business_Unit_Code INT = 5,
	--@Vendor_Codes VARCHAR(MAX) = '99',
	--@Title_Codes VARCHAR(MAX) = '',
	--@IsAdvance_Search CHAR(1) = 'N',
	--@User_Code INT = 143,
	--@PageNo INT = 1 ,
	--@PageSize INT = 10,
	--@RecordCount INT 

	IF(OBJECT_ID('TEMPDB..#TempProvisionalDeal') IS NOT NULL)
		DROP TABLE #TempProvisionalDeal

	IF(OBJECT_ID('TEMPDB..#TempResultData') IS NOT NULL)
		DROP TABLE #TempResultData

	CREATE TABLE #TempProvisionalDeal
	(
		Row_NO INT IDENTITY(1,1),
		Provisional_Deal_Code INT
	)
	
	IF(ISNULL(@IsAdvance_Search, 'N') = 'Y')
	BEGIN
		PRINT 'Advance Serach'
		INSERT INTO #TempProvisionalDeal(Provisional_Deal_Code)
		SELECT A.Provisional_Deal_Code FROM (
			SELECT DISTINCT PD.Provisional_Deal_Code, PD.Last_Updated_Time FROM Provisional_Deal PD 
			INNER JOIN Provisional_Deal_Licensor PDL ON PDL.Provisional_Deal_Code = PD.Provisional_Deal_Code
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code = PD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			INNER JOIN Provisional_Deal_Title PDT  On PD.Provisional_Deal_Code = PDT.Provisional_Deal_Code
			INNER JOIN Title T On PDT.Title_Code = T.Title_Code
			WHERE 
				PD.[Agreement_No] LIKE '%' + @Agreement_No + '%' AND 
				(ISNULL(@StartDate, '') = '' OR ISNULL(@EndDate, '') = '' OR (
					(PD.[Agreement_Date] BETWEEN CAST(@StartDate AS DATETIME) AND CAST(@EndDate AS DATETIME))
				)) AND
				(PD.Deal_Type_Code = @Deal_Type_Code OR ISNULL(@Deal_Type_Code, 0) = 0) AND 
				(PD.Business_Unit_Code = @Business_Unit_Code OR ISNULL(@Business_Unit_Code, 0) = 0) AND 
				(@Vendor_Codes = '' OR PDL.Vendor_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Vendor_Codes, ',') WHERE number <> '')) AND
				(@Title_Codes = '' OR PDT.Title_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Title_Codes, ',') WHERE number <> '')) 
		) AS A
		ORDER BY A.Last_Updated_Time DESC

		
	END
	ELSE IF(@SearchText <> '')
	BEGIN
		PRINT 'Normal Search'
		INSERT INTO #TempProvisionalDeal(Provisional_Deal_Code)
		SELECT A.Provisional_Deal_Code FROM (
			SELECT DISTINCT PD.Provisional_Deal_Code, PD.Last_Updated_Time FROM Provisional_Deal PD 
			INNER JOIN Provisional_Deal_Licensor PDL ON PDL.Provisional_Deal_Code = PD.Provisional_Deal_Code
			INNER JOIN [Vendor] V ON V.[Vendor_Code] = PDL.Vendor_Code
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code = PD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			INNER JOIN Provisional_Deal_Title PDT  On PD.Provisional_Deal_Code = PDT.Provisional_Deal_Code
			INNER JOIN Title T On PDT.Title_Code = T.Title_Code
			WHERE 
				PD.[Agreement_No] LIKE '%' + @SearchText + '%' OR 
				PD.[Deal_Desc] LIKE '%' + @SearchText + '%' OR 
				V.[Vendor_Name] LIKE '%' + @SearchText + '%' OR 
				T.[Title_Name] LIKE '%' + @SearchText + '%'
		) AS A
		ORDER BY A.Last_Updated_Time DESC
	END
	ELSE
	BEGIN
		PRINT 'Show All'
		INSERT INTO #TempProvisionalDeal(Provisional_Deal_Code)
		SELECT A.Provisional_Deal_Code FROM (
			SELECT DISTINCT PD.Provisional_Deal_Code, PD.Last_Updated_Time FROM Provisional_Deal PD 
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code = PD.Business_Unit_Code AND UBU.Users_Code = @User_Code
		) AS A
		ORDER BY A.Last_Updated_Time DESC
	END
	
	/* START : Logic For Paging*/
	SELECT @RecordCount  = MAX(Row_No) FROM #TempProvisionalDeal
	SET @RecordCount = ISNULL(@RecordCount, 0)
	SELECT @PageNo = DBO.UFN_Get_New_PageNo(@RecordCount, @PageNo, @PageSize)

	DELETE FROM #TempProvisionalDeal WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	/* END : Logic For Paging*/
	
	SELECT
		PD.Provisional_Deal_Code, PD.Agreement_No, PD.Agreement_Date, PD.Version, PD.Deal_Desc, 
		substring(
        (
            Select  distinct ', '+ T2.Title_Name  AS [text()]
            From Provisional_Deal PD2
			INNER JOIN #TempProvisionalDeal TPD2 ON TPD.Provisional_Deal_Code = PD2.Provisional_Deal_Code
			INNER JOIN Provisional_Deal_Title PDT2  On PD2.Provisional_Deal_Code = PDT2.Provisional_Deal_Code
			INNER JOIN Title T2 On PDT2.Title_Code = T2.Title_Code
			INNER JOIN [Business_Unit] BU2 ON BU2.[Business_Unit_Code] = PD2.[Business_Unit_Code]
			INNER JOIN [Deal_Type] DT2 ON DT2.[Deal_Type_Code] = PD2.[Deal_Type_Code]
            Where PD.Provisional_Deal_Code = PD2.Provisional_Deal_Code
            --ORDER BY PD2.Provisional_Deal_Code
            For XML PATH ('')
        ), 2, 2000) Title_Name,
		substring(
        (
            Select distinct  ', '+ V1.Vendor_Name  AS [text()]
            From Provisional_Deal PD1
			INNER JOIN #TempProvisionalDeal TPD1 ON TPD.Provisional_Deal_Code = PD1.Provisional_Deal_Code
			INNER JOIN Provisional_Deal_Licensor PDL1 ON PDL1.Provisional_Deal_Code = PD1.Provisional_Deal_Code
			INNER JOIN [Vendor] V1 ON V1.[Vendor_Code] = PDL1.Vendor_Code
			INNER JOIN [Business_Unit] BU1 ON BU1.[Business_Unit_Code] = PD1.[Business_Unit_Code]
			INNER JOIN [Deal_Type] DT1 ON DT1.[Deal_Type_Code] = PD1.[Deal_Type_Code]
            Where PD.Provisional_Deal_Code = PD1.Provisional_Deal_Code
            --ORDER BY PD1.Provisional_Deal_Code
            For XML PATH ('')
        ), 2, 1000) Vendor_Name,
		BU.[Business_Unit_Name], 
		DT.Deal_Type_Name, 
		PD.Right_Start_Date, PD.Right_End_Date, 
		PD.[Deal_Workflow_Status],
		CAST('' AS NVARCHAR(MAX)) AS Channel_Names
		INTO #TempResultData
	FROM 
		Provisional_Deal PD 
		INNER JOIN #TempProvisionalDeal TPD ON TPD.Provisional_Deal_Code = PD.Provisional_Deal_Code
		INNER JOIN [Business_Unit] BU ON BU.[Business_Unit_Code] = PD.[Business_Unit_Code]
		INNER JOIN [Deal_Type] DT ON DT.[Deal_Type_Code] = PD.[Deal_Type_Code]
	ORDER BY PD.Last_Updated_Time DESC

	UPDATE TRD SET 
	TRD.[Channel_Names] = DBO.UFN_Get_Provisional_Deal_Channel_Data(TRD.Provisional_Deal_Code)
	FROM #TempResultData TRD

	select * from #TempResultData

END