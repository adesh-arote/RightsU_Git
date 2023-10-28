CREATE PROCEDURE [dbo].[USPAcqSupplementaryTabData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
--Declare
--	@DepartmentCode NVARCHAR(1000) = 7,
--	@BVCode NVARCHAR(1000) = 19,
--	@TitleCode VARCHAR(MAX) = 34406,
--	@AcqDealCode VARCHAR(1000) = 25970,
--	@TabName NVARCHAR(MAX)	= 'Acquisition Supplementary Tab'

BEGIN
	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempSupplementaryCursor') IS NOT NULL DROP TABLE #TempSupplementaryCursor
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryData') IS NOT NULL DROP TABLE #TempAcqSupplementaryData
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryMergeData') IS NOT NULL DROP TABLE #TempAcqSupplementaryMergeData
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryDataResult') IS NOT NULL DROP TABLE #TempAcqSupplementaryDataResult

	CREATE TABLE #TempFields(
		ViewName VARCHAR(100),
		DisplayName VARCHAR(100),
		FieldOrder INT,
		ValidOpList VARCHAR(100)
	)	

	INSERT INTO #TempFields(ViewName, DisplayName, FieldOrder, ValidOpList)
	SELECT View_Name, Display_Name, Display_Order, ValidOpList FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B') AND ValidOpList = @TabName

	CREATE TABLE #TempSupplementaryCursor
	(
	    Supplementary_Code INT,
		Supplementary_Tab_Code INT,
		Supplementary_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Data_Value NVARCHAR(MAX),
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)	

	CREATE TABLE #TempAcqSupplementaryData
	(
	    Supplementary_Code INT,
		Supplementary_Tab_Code INT,
		Supplementary_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Data_Value NVARCHAR(MAX),
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)

	CREATE TABLE #TempAcqSupplementaryMergeData
	(
	    Supplementary_Code INT,
		Supplementary_Tab_Code INT,
		Supplementary_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Data_Value NVARCHAR(MAX),
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)

	CREATE TABLE #TempAcqSupplementaryDataResult
	(
	    Supplementary_Code INT,
		Supplementary_Tab_Code INT,
		Supplementary_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Data_Value NVARCHAR(MAX),
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Acquisition Supplementary') AND ValidOpList = 'Acquisition Supplementary Tab' )
	BEGIN
	
		PRINT 'Acquisition Supplementary - Start'		

		INSERT INTO #TempSupplementaryCursor (Supplementary_Code, Supplementary_Tab_Code, Supplementary_Tab_Description, Data_Desc, Data_Value, Title_Code, Acq_Deal_Code, Row_Num)
		
		SELECT * FROM
			(SELECT sc.Supplementary_Code, adsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description,
			CASE WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'inLine' THEN ISNULL(STUFF((SELECT  ', ' + CAST(x.DataDesc AS VARCHAR(Max))[text()] from 
								                (SELECT (SELECT Data_Description FROM Supplementary_Data sd WHERE sd.Supplementary_Data_Code IN (number)) AS DataDesc
												FROM [dbo].[fn_Split_withdelemiter](ISNULL(adsd.Supplementary_Data_Code, ''), ','))x 
												FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' '),'' ) 
			     WHEN  EditWindowType = 'PopUp' THEN (SELECT Supplementary_Name FROM Supplementary WHERE Supplementary_Code=sc.Supplementary_Code) 
			ELSE NULL END AS Data_Desc,
			
			CASE WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'inLine' THEN (SELECT User_Value FROM Acq_Deal_Supplementary_detail 
										WHERE Acq_Deal_Supplementary_Code = adsd.Acq_Deal_Supplementary_Code 
										AND Supplementary_Tab_Code = adsd.Supplementary_Tab_Code 
										AND Row_Num= adsd.Row_Num
										AND Supplementary_Data_Code IS NULL) 
				 WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'PopUp' THEN ISNULL(STUFF((SELECT  ', ' + CAST(x.DataDesc AS VARCHAR(Max))[text()] from 
								        (SELECT (SELECT Data_Description FROM Supplementary_Data sd WHERE sd.Supplementary_Data_Code IN (number)) AS DataDesc
										FROM [dbo].[fn_Split_withdelemiter](ISNULL(adsd.Supplementary_Data_Code, ''), ','))x 
										FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' '),'' ) 
			ELSE User_Value END AS User_Value,ads.Title_code, ads.Acq_Deal_Code, adsd.Row_Num
			
			FROM Acq_Deal_Supplementary ads         
										 INNER JOIN Acq_Deal_Supplementary_detail adsd ON adsd.Acq_Deal_Supplementary_Code = ads.Acq_Deal_Supplementary_Code  
										 INNER JOIN Supplementary_Config sc ON sc.Supplementary_Config_Code = adsd.Supplementary_Config_Code
										 INNER JOIN Supplementary_Tab st ON st.Supplementary_Tab_Code = adsd.Supplementary_Tab_Code
			WHERE ads.title_code = @TitleCode AND ads.Acq_Deal_Code = @AcqDealCode ) AS T WHERE Data_Desc IS NOT NULL		

		
		IF EXISTS (SELECT TOP 1 * FROM #TempSupplementaryCursor)
		BEGIN
				DECLARE @SupplementaryCode NVARCHAR(MAX), @SupplementaryTabCode NVARCHAR(MAX) , @SupplementaryTabDescription NVARCHAR(MAX) = '', @Cur_AcqDealCode NVARCHAR(MAX), @Cur_TitleCode NVARCHAR(MAX), @RowNum NVARCHAR(MAX), @Cur_Remark NVARCHAR(MAX),
						@DataValue NVARCHAR(MAX), @DataDesc NVARCHAR(MAX)
				DECLARE CUR_Supplementary_Data CURSOR FOR SELECT DISTINCT Supplementary_Code, Supplementary_Tab_Code, Supplementary_Tab_Description, Title_Code, Acq_Deal_Code, Row_Num FROM #TempSupplementaryCursor

				OPEN CUR_Supplementary_Data
				FETCH FROM CUR_Supplementary_Data INTO @SupplementaryCode, @SupplementaryTabCode, @SupplementaryTabDescription, @Cur_TitleCode, @Cur_AcqDealCode, @RowNum

				WHILE(@@FETCH_STATUS = 0)
				BEGIN
				
				   SELECT @DataValue = COALESCE(@DataValue +' ' ,'') + Data_Value, @DataDesc = Data_Desc FROM #TempSupplementaryCursor WHERE Supplementary_Code = @SupplementaryCode AND Supplementary_Tab_Code = @SupplementaryTabCode AND Title_Code = @Cur_TitleCode AND Acq_Deal_Code = @Cur_AcqDealCode AND Row_Num =  @RowNum
				   
				   INSERT INTO #TempAcqSupplementaryData (Supplementary_Code, Supplementary_Tab_Code, Supplementary_Tab_Description, Data_Desc, Data_Value, Title_Code, Acq_Deal_Code, Row_Num )
				   SELECT @SupplementaryCode, @SupplementaryTabCode, @SupplementaryTabDescription, @DataDesc, @DataValue,  @Cur_TitleCode, @Cur_AcqDealCode, @RowNum
				  
				   SET @DataValue = NULL

				   FETCH FROM CUR_Supplementary_Data INTO @SupplementaryCode, @SupplementaryTabCode, @SupplementaryTabDescription, @Cur_TitleCode, @Cur_AcqDealCode, @RowNum
				END
			    CLOSE CUR_Supplementary_Data
				DEALLOCATE CUR_Supplementary_Data;
		END
		
		IF EXISTS (SELECT TOP 1 * FROM #TempAcqSupplementaryData)
		BEGIN
				DECLARE @SupplementaryMergeCode NVARCHAR(MAX), @SupplementaryMergeTabCode NVARCHAR(MAX) , @SupplementaryMergeTabDescription NVARCHAR(MAX) = '', @Cur_MergeAcqDealCode NVARCHAR(MAX), @Cur_MergeTitleCode NVARCHAR(MAX), @RowNumMerge NVARCHAR(MAX), @Cur_RemarkMerge NVARCHAR(MAX),
						@MergeDataValue NVARCHAR(MAX), @MergeDataDesc NVARCHAR(MAX)
				DECLARE CUR_Supplementary_Merge_Data CURSOR FOR SELECT DISTINCT Supplementary_Tab_Code, Supplementary_Tab_Description, Title_Code, Acq_Deal_Code, Row_Num FROM #TempAcqSupplementaryData

				OPEN CUR_Supplementary_Merge_Data
				FETCH FROM CUR_Supplementary_Merge_Data INTO @SupplementaryMergeTabCode, @SupplementaryMergeTabDescription, @Cur_MergeTitleCode, @Cur_MergeAcqDealCode, @RowNumMerge

				WHILE(@@FETCH_STATUS = 0)
				BEGIN
				
				   SELECT @MergeDataValue = COALESCE(@MergeDataValue +' | ' ,'') +  Data_Desc + ' - ' + Data_Value, @MergeDataDesc = Data_Desc, @SupplementaryMergeCode = Supplementary_Code FROM #TempAcqSupplementaryData WHERE Supplementary_Tab_Code = @SupplementaryMergeTabCode AND Title_Code = @Cur_MergeTitleCode AND Acq_Deal_Code = @Cur_MergeAcqDealCode AND Row_Num =  @RowNumMerge
				   
				   INSERT INTO #TempAcqSupplementaryMergeData (Supplementary_Code, Supplementary_Tab_Code, Supplementary_Tab_Description, Data_Desc, Data_Value, Title_Code, Acq_Deal_Code, Row_Num )
				   SELECT @SupplementaryMergeCode, @SupplementaryMergeTabCode, @SupplementaryMergeTabDescription, @MergeDataDesc, @MergeDataValue,  @Cur_MergeTitleCode, @Cur_MergeAcqDealCode, @RowNumMerge
				  
				   SET @MergeDataValue = NULL

				   FETCH FROM CUR_Supplementary_Merge_Data INTO @SupplementaryMergeTabCode, @SupplementaryMergeTabDescription, @Cur_MergeTitleCode, @Cur_MergeAcqDealCode, @RowNumMerge
				END
			    CLOSE CUR_Supplementary_Merge_Data
				DEALLOCATE CUR_Supplementary_Merge_Data;
		END

		IF EXISTS (SELECT TOP 1 * FROM #TempAcqSupplementaryMergeData)
		BEGIN
			DECLARE @CurDataDesc NVARCHAR(MAX) , @CurSupplementaryTabCode NVARCHAR(MAX) = '', @CurSupplementaryTabDesc NVARCHAR(MAX)

			DECLARE CUR_Supplementery_Dynamic_Data CURSOR FOR SELECT DISTINCT Supplementary_Tab_Code, Supplementary_Tab_Description FROM #TempAcqSupplementaryMergeData

			OPEN CUR_Supplementery_Dynamic_Data
			FETCH FROM CUR_Supplementery_Dynamic_Data INTO @CurSupplementaryTabCode, @CurSupplementaryTabDesc

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
		    
				SELECT @CurDataDesc = COALESCE(@CurDataDesc +' ~ ' ,'')  + Data_Value FROM #TempAcqSupplementaryMergeData WHERE Supplementary_Tab_Code = @CurSupplementaryTabCode

				INSERT INTO #TempAcqSupplementaryDataResult (Data_Desc, Supplementary_Tab_Code, Supplementary_Tab_Description, Title_Code, Acq_Deal_Code)
				SELECT @CurDataDesc, @CurSupplementaryTabCode, @CurSupplementaryTabDesc, @TitleCode, @AcqDealCode 
				SET @CurDataDesc = NULL

				FETCH FROM CUR_Supplementery_Dynamic_Data INTO @CurSupplementaryTabCode, @CurSupplementaryTabDesc
		    END
			CLOSE CUR_Supplementery_Dynamic_Data
			DEALLOCATE CUR_Supplementery_Dynamic_Data;
		END

		PRINT 'Acquisition Supplementary - End'

	END		
	
	SELECT 1 AS GroupOrder, tasdr.Title_Code AS TitleCode, tasdr.Acq_Deal_Code AS Deal_Code, tasdr.Supplementary_Tab_Description AS KeyField,
	       ISNULL(tasdr.Data_Desc,'NA') AS ValueField, ISNULL(tasdr.Data_Value,'NA') AS DataValue, tasdr.Supplementary_Tab_Code AS FieldOrder, t.Title_Name AS TitleName, 
		   ad.Agreement_No AS AgreementNo, bu.Business_Unit_Name AS BusinessUnitName, dt.Deal_Type_Name AS DealType, ad.Deal_Desc AS DealDescription
	FROM #TempAcqSupplementaryDataResult tasdr
	INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = tasdr.Acq_Deal_Code
	INNER JOIN Title t ON t.Title_Code= tasdr.Title_Code
	INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
	INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = ad.Deal_Type_Code

	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempSupplementaryCursor') IS NOT NULL DROP TABLE #TempSupplementaryCursor
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryData') IS NOT NULL DROP TABLE #TempAcqSupplementaryData
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryMergeData') IS NOT NULL DROP TABLE #TempAcqSupplementaryMergeData
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryDataResult') IS NOT NULL DROP TABLE #TempAcqSupplementaryDataResult

END