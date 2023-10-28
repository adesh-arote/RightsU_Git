CREATE PROCEDURE [dbo].[USPAcquisitionDigitalTabData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
--DECLARE
--	@DepartmentCode NVARCHAR(1000) = 7,
--	@BVCode NVARCHAR(1000) = 19,
--	@TitleCode VARCHAR(MAX) = 27816,
--	@AcqDealCode VARCHAR(1000) = 15250,
--	@TabName NVARCHAR(MAX) = 'Acquisition Digital Tab'
BEGIN
	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempAcqDigitalCursor') IS NOT NULL DROP TABLE #TempAcqDigitalCursor
	IF OBJECT_ID('tempdb..#TempAcqDigitalData') IS NOT NULL DROP TABLE #TempAcqDigitalData
	IF OBJECT_ID('tempdb..#TempAcqDigitalDataResult') IS NOT NULL DROP TABLE #TempAcqDigitalDataResult

	CREATE TABLE #TempFields(
		ViewName VARCHAR(100),
		DisplayName VARCHAR(100),
		FieldOrder INT,
		ValidOpList VARCHAR(100)
	)	

	CREATE TABLE #TempAcqDigitalCursor
	(
	    Digital_Code INT,
		Digital_Tab_Code INT,
		Digital_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Remark NVARCHAR(MAX),		
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)	

	CREATE TABLE #TempAcqDigitalData
	(
	    Digital_Code INT,
		Digital_Tab_Code INT,
		Digital_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Remark NVARCHAR(MAX),		
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)

	CREATE TABLE #TempAcqDigitalDataResult
	(	    
		Digital_Tab_Code INT,
		Digital_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Remark NVARCHAR(MAX),		
		Title_Code INT,
		Acq_Deal_Code INT,
		Row_Num INT
	)

	INSERT INTO #TempFields(ViewName, DisplayName, FieldOrder, ValidOpList)
	SELECT View_Name, Display_Name, Display_Order, ValidOpList FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B') AND ValidOpList = @TabName	
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Acquisition Digital') AND ValidOpList = 'Acquisition Digital Tab' )
	BEGIN
	
		PRINT 'Acquisition Digital Tab - Start'		
		
		INSERT INTO #TempAcqDigitalCursor (Digital_Code, Digital_Tab_Code,	Digital_Tab_Description, Data_Desc, Acq_Deal_Code, Title_Code, Remark, Row_Num)
		
		SELECT dc.Digital_Code, addd.Digital_Tab_Code, dt.Digital_Tab_Description, d.Digital_Name +' - '+
	    
			CASE WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'inLine' THEN ISNULL(STUFF((SELECT  ', ' + CAST(x.DataDesc AS VARCHAR(Max))[text()] from 
				(SELECT (SELECT Data_Description FROM Digital_Data dd WHERE dd.Digital_Data_Code IN (number)) AS DataDesc
					FROM [dbo].[fn_Split_withdelemiter](ISNULL(addd.Digital_Data_Code, ''), ','))x 
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' '),'' )
					WHEN  EditWindowType = 'PopUp' THEN (SELECT Digital_Name FROM Digital WHERE Digital_Code = dc.Digital_Code)
			ELSE 
				User_Value 
			END AS Data_Desc,	    
			addg.Acq_Deal_Code, addg.Title_Code, addg.Remarks, Row_Num

		FROM Acq_Deal_Digital addg
			INNER JOIN Acq_Deal_Digital_detail addd ON addd.Acq_Deal_Digital_Code = addg.Acq_Deal_Digital_Code
			INNER JOIN Digital_Config dc ON dc.Digital_Config_Code = addd.Digital_Config_Code
			INNER JOIN Digital_Tab dt ON dt.Digital_Tab_Code = addd.Digital_Tab_Code
			INNER JOIN Digital d ON d.Digital_Code = dc.Digital_Code
		WHERE addg.title_code = @TitleCode AND addg.Acq_Deal_Code = @AcqDealCode

		DECLARE @Digital_Tab_Code NVARCHAR(MAX) = '', @Digital_Tab_Description NVARCHAR(MAX) = '', @Acq_Deal_Code NVARCHAR(MAX), @Title_Code NVARCHAR(MAX), @Row_Num NVARCHAR(MAX), @Remark NVARCHAR(MAX),
				@Data_Desc NVARCHAR(MAX) 

		DECLARE CUR_Digital_Dynamic_Data CURSOR FOR SELECT DISTINCT Digital_Tab_Code, Digital_Tab_Description, Acq_Deal_Code, Title_Code, Row_Num FROM #TempAcqDigitalCursor

		OPEN CUR_Digital_Dynamic_Data
		FETCH FROM CUR_Digital_Dynamic_Data INTO @Digital_Tab_Code, @Digital_Tab_Description, @Acq_Deal_Code, @Title_Code, @Row_Num

		WHILE(@@FETCH_STATUS = 0)
		BEGIN

		   SELECT @Data_Desc = COALESCE(@Data_Desc+' | ' ,'') + Data_Desc, @Remark = Remark FROM #TempAcqDigitalCursor WHERE Digital_Tab_Code = @Digital_Tab_Code AND Acq_Deal_Code = @Acq_Deal_Code AND Title_Code = @Title_Code AND Row_Num = @Row_Num

		   INSERT INTO #TempAcqDigitalData (Digital_Tab_Code, Digital_Tab_Description, Data_Desc, Remark, Acq_Deal_Code, Title_Code, Row_Num )
		   SELECT @Digital_Tab_Code, @Digital_Tab_Description, @Data_Desc, @Remark, @Acq_Deal_Code, @Title_Code, @Row_Num
		   
		   SET @Data_Desc = NULL

		   FETCH FROM CUR_Digital_Dynamic_Data INTO @Digital_Tab_Code, @Digital_Tab_Description, @Acq_Deal_Code, @Title_Code, @Row_Num
		END
		CLOSE CUR_Digital_Dynamic_Data
		DEALLOCATE CUR_Digital_Dynamic_Data;

		IF EXISTS (SELECT TOP 1 * FROM #TempAcqDigitalData)
			BEGIN
				DECLARE @DigitalTabCode NVARCHAR(MAX) = '', @DigitalTabDescription NVARCHAR(MAX) = '', @Cur_AcqDealCode NVARCHAR(MAX), @Cur_TitleCode NVARCHAR(MAX), @RowNum NVARCHAR(MAX), @Cur_Remark NVARCHAR(MAX),
						@DataDesc NVARCHAR(MAX)
				DECLARE CUR_Digital_Data CURSOR FOR SELECT DISTINCT Digital_Tab_Code, Digital_Tab_Description, Acq_Deal_Code, Title_Code FROM #TempAcqDigitalData

				OPEN CUR_Digital_Data
				FETCH FROM CUR_Digital_Data INTO @DigitalTabCode, @DigitalTabDescription, @Cur_AcqDealCode, @Cur_TitleCode

				WHILE(@@FETCH_STATUS = 0)
				BEGIN

				   SELECT @DataDesc = COALESCE(@DataDesc+' ~ ' ,'') + Data_Desc, @Cur_Remark = Remark FROM #TempAcqDigitalData WHERE Digital_Tab_Code = @DigitalTabCode AND Acq_Deal_Code = @Cur_AcqDealCode AND Title_Code = @Cur_TitleCode 

				   INSERT INTO #TempAcqDigitalDataResult (Digital_Tab_Code, Digital_Tab_Description, Data_Desc, Remark, Acq_Deal_Code, Title_Code )
				   SELECT @DigitalTabCode, @DigitalTabDescription, @DataDesc, @Cur_Remark, @Cur_AcqDealCode, @Cur_TitleCode
				   
				   SET @DataDesc = NULL

				   FETCH FROM CUR_Digital_Data INTO @DigitalTabCode, @DigitalTabDescription, @Cur_AcqDealCode, @Cur_TitleCode
				END
				CLOSE CUR_Digital_Data
				DEALLOCATE CUR_Digital_Data;
			END

		PRINT 'Acquisition Digital Tab - End'

	END

	SELECT 1 AS GroupOrder, taddr.Title_Code AS TitleCode, taddr.Acq_Deal_Code AS DealCode, ISNULL(taddr.Digital_Tab_Description,'NA') AS KeyField, 
	       ISNULL(taddr.Data_Desc,'NA') AS ValueField,ISNULL(taddr.Remark,'NA') AS Remark, taddr.Digital_Tab_Code AS FieldOrder, t.Title_Name AS TitleName, 
		   ad.Agreement_No AS AgreementNo, bu.Business_Unit_Name AS BusinessUnitName, dt.Deal_Type_Name AS DealType, ad.Deal_Desc AS DealDescription
	FROM #TempAcqDigitalDataResult taddr
	INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = taddr.Acq_Deal_Code
	INNER JOIN Title t ON t.Title_Code= taddr.Title_Code
	INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
	INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = ad.Deal_Type_Code

	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempAcqDigitalCursor') IS NOT NULL DROP TABLE #TempAcqDigitalCursor
	IF OBJECT_ID('tempdb..#TempAcqDigitalDataResult') IS NOT NULL DROP TABLE #TempAcqDigitalDataResult

END
