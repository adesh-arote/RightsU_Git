CREATE PROC USP_List_Music_Deal
(
	@SearchText NVARCHAR(MAX) = '',
	@Agreement_No VARCHAR(50) = '',
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@Deal_Type_Code NVARCHAR(MAX) = '',
	@Status_Code NVARCHAR(MAX)= '',
	@Business_Unit_Code INT = 0,
	@Deal_Tag_Code INT = 0,
	@Workflow_Status VARCHAR(5) = '',
	@Vendor_Codes VARCHAR(MAX) = '',
	@Music_Label_Codes VARCHAR(MAX) = '',
	@IsAdvance_Search CHAR(1) = 'N',
	@Show_Type_Code NVARCHAR(100) = '',
	@Title_Code NVARCHAR(MAX) = '',
	@User_Code INT = 0,
	@PageNo INT = 1 OUT,
	@PageSize INT = 10,
	@RecordCount INT OUT
)
AS
/*=============================================
Author		: Abhaysingh N. Rajpurohit
Create Date	: 02 March 2017
Description	: List of Music Deal, 

Based on this (@IsAdvance_Search) parameter we will get to know that query is for Advance Search Or Normal Search

> Parameter For Normal Search : 
	@SearchText

> Parameter For Advance Search : 
	@Agreement_No, @StartDate, @EndDate, @Deal_Type_Code, @Status_Code @Business_Unit_Code, @Deal_Tag_Code, @Workflow_Status, @Vendor_Codes, @Music_Label_Codes
	
=============================================*/
BEGIN	
	SET FMTONLY OFF
	--DECLARE
	--@SearchText NVARCHAR(MAX) = '',
	--@Agreement_No VARCHAR(50) = '',
	--@StartDate DATETIME = NULL,
	--@EndDate DATETIME = NULL,
	--@Deal_Type_Code NVARCHAR(MAX) = '1',
	--@Status_Code NVARCHAR(MAX) = '1,4,3',
	--@Business_Unit_Code INT = Null,
	--@Deal_Tag_Code INT = 0,
	--@Workflow_Status VARCHAR(5) = '0',
	--@Vendor_Codes VARCHAR(MAX) = '',
	--@Music_Label_Codes VARCHAR(MAX) = '',
	--@IsAdvance_Search CHAR(1) = 'Y',
	--@User_Code INT = 143,
	--@PageNo INT = 1 ,
	--@PageSize INT = Null,
	--@RecordCount INT,
	--@Show_Type_Code NVARCHAR(100) = 'AS',
	--@Title_Code NVARCHAR(MAX) = ''

	IF(OBJECT_ID('TEMPDB..#TempMusicDeal') IS NOT NULL)
		DROP TABLE #TempMusicDeal

	IF(OBJECT_ID('TEMPDB..#TempResultData') IS NOT NULL)
		DROP TABLE #TempResultData

	IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)
		DROP TABLE #Temp

	IF(OBJECT_ID('TEMPDB..#Title_Channel') IS NOT NULL)
		DROP TABLE #Title_Channel

	CREATE TABLE #TempMusicDeal
	(
		Row_NO INT IDENTITY(1,1),
		Music_Deal_Code INT
	)

	--CREATE TABLE #DealType_Title
	--(
	--	Row_No INT IDENTITY(1,1),
	--	Title_Code INT
	--)
	
	CREATE TABLE #Temp
	(
		Title_Name NVARCHAR(MAX),
		Channel_Name NVARCHAR(MAX),
		Title_Code INT
	)

	--DECLARE @Show_Name NVARCHAR(MAX) = '', 	@Show_Type_Code NVARCHAR(100) = 'SP'
	--IF(@Show_Type_Code <> '')
	--BEGIN
	--		IF  CHARINDEX('AF',@Show_Type_Code) > 0 
	--			SELECT @Show_Name = @Show_Name + 'Fiction' + ','
	--		IF  CHARINDEX('AN',@Show_Type_Code) > 0 
	--			SELECT @Show_Name =  @Show_Name + 'Non-Fiction'  + ','
	--		IF  CHARINDEX('AS',@Show_Type_Code) > 0  
	--			SELECT @Show_Name =  @Show_Name + 'Show'  + ','
	--		IF  CHARINDEX('AE',@Show_Type_Code) > 0  
	--			SELECT @Show_Name =  @Show_Name + 'Event'  + ','
	--		IF  CHARINDEX('SP',@Show_Type_Code) > 0 
	--			SELECT @Show_Name =  @Show_Name + 'Specific'  + ','

	--		SELECT @Show_Name = reverse(stuff(reverse(@Show_Name), 1, 1, ''))

	--		INSERT INTO #DealType_Title (Title_Code)
	--		SELECT DISTINCT Title_Code FROM Title WHERE Deal_Type_Code 
	--		IN (select Deal_Type_Code from Deal_Type where Deal_Type_Name 
	--		IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Show_Name, ',') WHERE number <> ''))
			 
	--		IF CHARINDEX('AS',@Show_Type_Code) > 0  
	--				INSERT INTO #DealType_Title (Title_Code)
	--				SELECT DISTINCT Title_Code from Title where Deal_Type_Code 
	--				IN (select Deal_Type_Code from Deal_Type where Deal_Type_Name LIKE '%SHOW%')

	--		IF CHARINDEX('SP',@Show_Type_Code) > 0  
	--				INSERT INTO #DealType_Title (Title_Code)
	--				select DISTINCT Title_Code from Music_Deal_LinkShow 
	--		SELECT * FROM #DealType_Title
	--END

	IF(ISNULL(@IsAdvance_Search, 'N') = 'Y')
	BEGIN
		PRINT 'Advance Serach'
		INSERT INTO #TempMusicDeal(Music_Deal_Code)
		SELECT A.Music_Deal_Code FROM (
			SELECT DISTINCT MD.Music_Deal_Code, MD.Last_Updated_Time FROM Music_Deal MD 
			INNER JOIN [Music_Deal_Vendor] MDV ON MDV.[Music_Deal_Code] = MD.[Music_Deal_Code]
			INNER JOIN [Music_Deal_DealType] MDD ON MDD.Music_Deal_Code = MD.[Music_Deal_Code]
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code = MD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			WHERE 
				MD.[Agreement_No] LIKE '%' + @Agreement_No + '%' AND 
				(ISNULL(@StartDate, '') = '' OR ISNULL(@EndDate, '') = '' OR (
					(MD.[Agreement_Date] BETWEEN CAST(@StartDate AS DATETIME) AND CAST(@EndDate AS DATETIME))
				)) AND
				--(MDD.Deal_Type_Code = @Deal_Type_Code OR ISNULL(@Deal_Type_Code, 0) = 0) AND 
				(MD.Business_Unit_Code = @Business_Unit_Code OR ISNULL(@Business_Unit_Code, 0) = 0) AND 
				(MD.Deal_Tag_Code = @Deal_Tag_Code OR ISNULL(@Deal_Tag_Code, 0) = 0) AND 
				(@Vendor_Codes = '' OR MDV.Vendor_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Vendor_Codes, ',') WHERE number <> '')) AND
				(@Deal_Type_Code = '' OR MDD.Deal_Type_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Deal_Type_Code, ',') WHERE number <> '')) AND
				(@Show_Type_Code = '' OR MD.Link_Show_Type IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Show_Type_Code, ',') WHERE number <> '')) AND
				(@Status_Code = '' OR MD.Deal_Tag_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Status_Code, ',') WHERE number <> '')) AND
				(@Music_Label_Codes = '' OR MD.Music_Label_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Music_Label_Codes, ',') WHERE number <> '')) AND
				(@Workflow_Status = '0' OR MD.[Deal_Workflow_Status] = @Workflow_Status)
		) AS A
		ORDER BY A.Last_Updated_Time DESC

		IF (ISNULL(@Title_Code,'') <> '')
		BEGIN
			--SPECIFIC CHANNEL FOR PARTICULAR MUSIC DEAL
			SELECT DISTINCT MD.Music_Deal_Code, MDC.Channel_Code, C.Channel_Name Into #MusicDeal_Channel FROM Music_Deal MD
			INNER JOIN Music_Deal_Channel MDC on  MDC.Music_Deal_Code = MD.Music_Deal_Code
			INNER JOIN Channel C ON C.Channel_Code = MDC.Channel_Code
			WHERE MD.Music_Deal_Code in (SELECT Music_Deal_Code FROM #TempMusicDeal)

			--SELECT CHANNEL RELATED TO TITLE CODE 
			INSERT INTO #Temp(Title_Name, Channel_Name, Title_Code)
			SELECT DISTINCT T.Title_Name, C.Channel_Name, T.Title_Code
			FROM Acq_Deal_Run_Channel ADRC
			INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
			INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
			INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code 

			SELECT A.Title_Code , C.Channel_Code INTO #Title_Channel
			FROM (SELECT DISTINCT Title_Name, Title_Code FROM #Temp T) AS A 
				INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Title_Code = A.Title_Code
				INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
				INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
				WHERE A.Title_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@Title_Code, ',') WHERE number <> '')

			--GETTING ACTUAL MUSIC DEAL CODE BY FILTERING DATA
			SELECT DISTINCT Music_Deal_Code INTO #Filtered_Music_Deal FROM #MusicDeal_Channel WHERE Channel_Code IN (SELECT Channel_Code FROM #Title_Channel)

			DELETE FROM #TempMusicDeal WHERE Music_Deal_Code NOT IN (SELECT Music_Deal_Code FROM #Filtered_Music_Deal)
		END
	END
	ELSE IF(@SearchText <> '')
	BEGIN
		PRINT 'Normal Search'
		INSERT INTO #TempMusicDeal(Music_Deal_Code)
		SELECT A.Music_Deal_Code FROM (
			SELECT DISTINCT MD.Music_Deal_Code, MD.Last_Updated_Time FROM Music_Deal MD 
			INNER JOIN [Vendor] V ON V.[Vendor_Code] = MD.[Primary_Vendor_Code]
			INNER JOIN [Music_Label] ML ON ML.[Music_Label_Code] = MD.[Music_Label_Code]
			INNER JOIN [Entity] E ON E.[Entity_Code] = MD.[Entity_Code]
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code = MD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			WHERE 
				MD.[Agreement_No] LIKE '%' + @SearchText + '%' OR 
				MD.[Description] LIKE '%' + @SearchText + '%' OR 
				V.[Vendor_Name] LIKE '%' + @SearchText + '%' OR 
				ML.[Music_Label_Name] LIKE '%' + @SearchText + '%' OR
				E.[Entity_Name] LIKE '%' + @SearchText + '%'
		) AS A
		ORDER BY A.Last_Updated_Time DESC
	END
	ELSE
	BEGIN
		PRINT 'Show All'
		INSERT INTO #TempMusicDeal(Music_Deal_Code)
		SELECT A.Music_Deal_Code FROM (
			SELECT DISTINCT MD.Music_Deal_Code, MD.Last_Updated_Time FROM Music_Deal MD 
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code = MD.Business_Unit_Code AND UBU.Users_Code = @User_Code
		) AS A
		ORDER BY A.Last_Updated_Time DESC
	END
	
	/* START : Logic For Paging*/
	SELECT @RecordCount  = MAX(Row_No) FROM #TempMusicDeal
	SET @RecordCount = ISNULL(@RecordCount, 0)
	SELECT @PageNo = DBO.UFN_Get_New_PageNo(@RecordCount, @PageNo, @PageSize)

	DELETE FROM #TempMusicDeal WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	/* END : Logic For Paging*/
	
	SELECT
		MD.[Music_Deal_Code], MD.[Agreement_No], MD.[Agreement_Date], MD.[Version], MD.[Description], 
		ML.[Music_Label_Name], V.Vendor_Name AS [Primary_Vendor], E.[Entity_Name], BU.[Business_Unit_Name], 
		/*DT.[Deal_Type_Name],*/ MD.[Rights_Start_Date], MD.[Rights_End_Date], /*DTS.[Deal_Tag_Description]*/ 
		CAST('' AS NVARCHAR(MAX)) AS [Deal_Tag_Description], MD.[Deal_Workflow_Status], 
		CAST('' AS VARCHAR(MAX)) AS [Final_Deal_Workflow_Status], CAST('' AS VARCHAR(MAX)) AS [Previous_Version], 
		CASE MD.[Title_Type] WHEN 'L' THEN 'Library' WHEN 'P' THEN 'Premier' ELSE 'NA' END AS [Title_Type], CAST('' AS NVARCHAR(MAX)) AS Deal_Type_Name,
		CAST('' AS NVARCHAR(MAX)) AS Channel_Names, CAST('' AS NVARCHAR(MAX)) AS Track_Languge_Name, CAST('' AS VARCHAR(MAX)) AS Visible_Buttons_Code,
		CAST('' AS VARCHAR(MAX)) AS IsZeroWorkFlow INTO #TempResultData
	FROM 
		[Music_Deal] MD
		INNER JOIN #TempMusicDeal TMD ON TMD.Music_Deal_Code = MD.Music_Deal_Code
		INNER JOIN [Vendor] V ON V.[Vendor_Code] = MD.[Primary_Vendor_Code]
		INNER JOIN [Music_Label] ML ON ML.[Music_Label_Code] = MD.[Music_Label_Code]
		INNER JOIN [Entity] E ON E.[Entity_Code] = MD.[Entity_Code]
		INNER JOIN [Business_Unit] BU ON BU.[Business_Unit_Code] = MD.[Business_Unit_Code]
		--INNER JOIN [Deal_Type] DT ON DT.[Deal_Type_Code] = MD.[Deal_Type_Code]
		--INNER JOIN [Deal_Tag] DTS ON DTS.[Deal_Tag_Code] = MD.[Deal_Tag_Code]

	ORDER BY MD.Last_Updated_Time DESC

	UPDATE TRD SET 
	TRD.[Previous_Version] = (SELECT ISNULL(MAX([Version]), 0) FROM AT_Music_Deal WHERE Music_Deal_Code = TRD.Music_Deal_Code), 
	TRD.[Final_Deal_Workflow_Status] = DBO.UFN_Get_Music_Deal_Workflow_Status(TRD.[Music_Deal_Code], TRD.[Deal_Workflow_Status], @User_Code),
	TRD.[Channel_Names] = DBO.UFN_Get_Music_Deal_Child_Data(TRD.Music_Deal_Code, '', 'CHANNEL'),
	TRD.[Track_Languge_Name] = DBO.UFN_Get_Music_Deal_Child_Data(TRD.Music_Deal_Code, '', 'LANGUAGE'),
	TRD.[Deal_Type_Name] = DBO.UFN_Get_Music_Deal_Child_Data(TRD.Music_Deal_Code, '', 'DEALTYPE'),
	TRD.[Visible_Buttons_Code] = [dbo].[UFN_Music_Deal_Get_Visible_Buttons_Code](TRD.Music_Deal_Code, CAST(TRD.[Version] AS FLOAT), @User_Code, TRD.[Deal_Workflow_Status]),
	TRD.[IsZeroWorkFlow] = [dbo].[UFN_Check_Workflow](163, [Music_Deal_Code])
	FROM #TempResultData TRD

	SELECT * FROM #TempResultData
END




--Select * from Music_Deal_DealType

