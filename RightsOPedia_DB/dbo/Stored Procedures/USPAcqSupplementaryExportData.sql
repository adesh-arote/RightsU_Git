CREATE PROCEDURE [dbo].[USPAcqSupplementaryExportData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
BEGIN
	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempSupplementaryCursor') IS NOT NULL DROP TABLE #TempSupplementaryCursor
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryData') IS NOT NULL DROP TABLE #TempAcqSupplementaryData
	
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

		PRINT 'Acquisition Supplementary - End'

	END	
	
	SELECT 1 AS GroupOrder, tasd.Title_Code AS TitleCode, tasd.Acq_Deal_Code AS Deal_Code, tasd.Supplementary_Tab_Description AS KeyField,
	       ISNULL(tasd.Data_Desc,'NA') AS DataValue, ISNULL(tasd.Data_Value,'NA') AS ValueField, tasd.Supplementary_Tab_Code AS FieldOrder, t.Title_Name AS TitleName, 
		   ad.Agreement_No AS AgreementNo, bu.Business_Unit_Name AS BusinessUnitName, dt.Deal_Type_Name AS DealType, ad.Deal_Desc AS DealDescription
	FROM #TempAcqSupplementaryData tasd
	INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = tasd.Acq_Deal_Code
	INNER JOIN Title t ON t.Title_Code= tasd.Title_Code
	INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
	INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = ad.Deal_Type_Code
	ORDER BY tasd.Title_Code, tasd.Acq_Deal_Code, tasd.Supplementary_Tab_Code, tasd.Row_Num ASC

	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempSupplementaryCursor') IS NOT NULL DROP TABLE #TempSupplementaryCursor
	IF OBJECT_ID('tempdb..#TempAcqSupplementaryData') IS NOT NULL DROP TABLE #TempAcqSupplementaryData

END