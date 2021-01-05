CREATE PROCEDURE USP_Music_Deal_Schedule_Validation
	@Music_Deal_Code INT,
	@Channel_Codes VARCHAR(500),
	@Start_Date VARCHAR(25),
	@End_Date VARCHAR(25),
	@LinkedShowType VARCHAR(5),
	@LinkedTitleCode VARCHAR(500)
AS 
BEGIN
	--DECLARE
	--@Music_Deal_Code INT = 59,
	--@Channel_Codes VARCHAR(100) = '5',
	--@Start_Date VARCHAR(25) = '02-Nov-2018',
	--@End_Date VARCHAR(25) = '25-Oct-2018',
	--@LinkedShowType VARCHAR(5) = 'SP',
	--@LinkedTitleCode VARCHAR(5) = ''

	DECLARE  @DealType_Fiction INT = 0, @DealType_NonFiction INT = 0, @DealType_Event INT = 0,@Status CHAR(1) = 'S', @Message NVARCHAR(MAX) = NULL, 
	@MaxStartDate DATETIME, @MinEndDate DATETIME, @Msg NVARCHAR(MAX) = NULL, @ErrorCount INT = 0,@DealTypeCode VARCHAR(100)

    IF(OBJECT_ID('TEMPDB..#TempErrorData') IS NOT NULL)            
		DROP TABLE #TempErrorData       
	
	
	CREATE TABLE #TempErrorData
	(
		Error_No INT,
		Title NVarchar(500),
		Schedule_Date VARCHAR(100),
		[Error_Message] NVARCHAR(MAX)
	)

	SELECT TOP 1 @DealType_Fiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content'
	SELECT TOP 1 @DealType_NonFiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'
	SELECT TOP 1 @DealType_Event = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'

	
	SELECT @MaxStartDate = MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)), @MinEndDate = MAX(CAST(BST.Schedule_Item_Log_Date AS DATETIME)) 
	FROM Music_Schedule_Transaction MSt
	INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
	WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N'
	
	IF(CAST(@Start_Date AS DATETIME) > @MaxStartDate)
	BEGIN
		SET @ErrorCount = @ErrorCount + 1
		SET @Msg = 'Start Date Can not be greater than ' + CONVERT(VARCHAR(11), @MaxStartDate, 106) + ' as run Scheduled for selected title.'

		INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
			SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106), @Msg 
				FROM Music_Schedule_Transaction MSt
				INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				inneR JOIN Title T ON T.Title_Code = BST.Title_Code
				WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N'
			group by T.Title_Name	
	END
	IF(CAST(@End_Date AS DATETIME) < @MinEndDate)
	BEGIN
		SET @ErrorCount = @ErrorCount + 1
		SET @Msg = 'End Date Can not be less than ' + CONVERT(VARCHAR(11), @MinEndDate, 106) + ' as run Scheduled for selected title.'

		INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
			SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106), @Msg 
				FROM Music_Schedule_Transaction MSt
				INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				inneR JOIN Title T ON T.Title_Code = BST.Title_Code
				WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N'
			group by T.Title_Name	
	END
		
	
	IF(@LinkedShowType = 'SP')
	BEGIN
	SET @ErrorCount = @ErrorCount + 1

			INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
				SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106)
			, 'Title(s)  ' + T.Title_Name + ' does not exist for Specific.' FROM Music_Schedule_Transaction MST
				INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				INNER JOIN Title T ON T.Title_Code = BST.Title_Code 
				WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N' AND BST.Title_Code NOT IN(
					SELECT number From DBO.fn_Split_withdelemiter(@LinkedTitleCode, ',')  WHERE number <> ''
				)
			group by T.Title_Name
	END

	IF(@LinkedShowType = 'AS')
		BEGIN
		SET @ErrorCount = @ErrorCount + 1

			INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
				SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106)
					, 'Title(s)  ' + T.Title_Name + ' does not exist for All Shows.' FROM Music_Schedule_Transaction MST
					INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
					Inner join Title T ON T.Title_Code = BST.Title_Code 
					WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N' 
					AND T.Deal_Type_Code NOT IN (@DealType_Fiction, @DealType_NonFiction, @DealType_Event)
				Group by T.Title_Name
		END

	IF(@LinkedShowType = 'AF')
		BEGIN
		SET @ErrorCount = @ErrorCount + 1

			INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
				SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106)
				, 'Title(s)  ' + T.Title_Name + ' does not exist for All Fiction.' FROM Music_Schedule_Transaction MST
					INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
					Inner join Title T ON T.Title_Code = BST.Title_Code 
					WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N' 
					AND T.Deal_Type_Code NOT IN (@DealType_Fiction)
				Group by T.Title_Name
		END

	IF(@LinkedShowType = 'AN')
		BEGIN
		SET @ErrorCount = @ErrorCount + 1

			INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
				SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106)
					, 'Title(s)  ' + T.Title_Name + ' does not exist for All Non Fiction.' FROM Music_Schedule_Transaction MST
					INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
					Inner join Title T ON T.Title_Code = BST.Title_Code 
					WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N' 
					AND T.Deal_Type_Code NOT IN (@DealType_NonFiction)
				Group by T.Title_Name
		END

	IF(@LinkedShowType = 'AE')
		BEGIN
			SET @ErrorCount = @ErrorCount + 1

			INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
				SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106)
					, 'Title(s)  ' + T.Title_Name + ' does not exist for All Event.' FROM Music_Schedule_Transaction MST
					INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
					Inner join Title T ON T.Title_Code = BST.Title_Code 
					WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N' 
					AND T.Deal_Type_Code NOT IN (@DealType_Event)
				Group by T.Title_Name
		END
		SET @ErrorCount = @ErrorCount + 1

		INSERT INTO #TempErrorData(Error_No, Title, Schedule_Date, [Error_Message])
			SELECT DISTINCT @ErrorCount, T.Title_Name, CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)),106), 
		    'Channel(s) '+ C.Channel_Name + ' does not exists as run Scheduled for selected title.' FROM Music_Schedule_Transaction MST
				INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				INNER JOIN Title T ON T.Title_Code = BST.Title_Code
				Inner join Channel C ON C.Channel_Code = BST.Channel_Code
				WHERE MST.Music_Deal_Code = @Music_Deal_Code AND ISNULL(MST.Is_Exception, '') = 'N' AND BST.Channel_Code NOT IN(
				SELECT number From DBO.fn_Split_withdelemiter(@Channel_Codes, ',')  WHERE number <> '')
			group by T.Title_Name,C.Channel_Name
	SELECT Error_No, Title, Schedule_Date, [Error_Message]  from #TempErrorData

	IF OBJECT_ID('tempdb..#TempErrorData') IS NOT NULL DROP TABLE #TempErrorData
END