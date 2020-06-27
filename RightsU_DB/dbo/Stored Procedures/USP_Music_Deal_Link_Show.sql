CREATE PROCEDURE USP_Music_Deal_Link_Show
	@Channel_Code VARCHAR(500),
	@Title_Name varchar(500),
	@Mode Char(1),
	@Music_Deal_Code INT,
	@SelectedTitleCodes VARCHAR(MAX) = ''
AS
BEGIN
	--DECLARE
	--@Channel_Code VARCHAR(500) = '4,3',
	--@Title_Name varchar(500) = 'krishna dasi 2',
	--@Mode Char(1) = 'E',
	--@Music_Deal_Code INT = 38,
	--@SelectedTitleCodes VARCHAR(MAX) = ''

	SET @Title_Name = LTRIM(RTRIM(@Title_Name))

	IF OBJECT_ID('TEMPDB..#TEMP') IS NOT NULL
	BEGIN
		DROP TABLE #TEMP
	END	

	IF OBJECT_ID('TEMPDB..#TEMP2') IS NOT NULL
	BEGIN
		DROP TABLE #TEMP2
	END	

	CREATE TABLE #TEMP
	(
		Title_Name NVARCHAR(MAX),
		Channel_Name NVARCHAR(MAX),
		Title_Code INT,
		Music_Deal_LinkShow_Code INT
	)

	DECLARE @DealTypeContent VARCHAR(100),@DealTypeEvent VARCHAR(100),@DealTypeFormatProgram VARCHAR(100)
	SELECT TOP 1 @DealTypeContent =  Parameter_Value from System_Parameter_New where Parameter_Name = 'Deal_Type_Content'
	SELECT TOP 1 @DealTypeEvent =  Parameter_Value from System_Parameter_New where Parameter_Name = 'Deal_Type_Event'
	SELECT TOP 1 @DealTypeFormatProgram =  Parameter_Value from System_Parameter_New where Parameter_Name = 'Deal_Type_Format_Program'

	IF(@Mode <> 'V')
	BEGIN
		IF(@Title_Name != '' OR @SelectedTitleCodes !='')
		BEGIN
		INSERT INTO #TEMP(Title_Name, Channel_Name, Title_Code, Music_Deal_LinkShow_Code)
		SELECT DISTINCT T.Title_Name, C.Channel_Name, T.Title_Code, 
		ISNULL(MDLS.Music_Deal_LinkShow_Code, 0) AS Music_Deal_LinkShow_Code 
		FROM Acq_Deal_Run_Channel ADRC
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
		INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code 
		LEFT JOIN Music_Deal_LinkShow MDLS ON MDLS.Title_Code = T.Title_Code AND MDLS.Music_Deal_Code = @Music_Deal_Code
		WHERE ADRC.Channel_Code IN (SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@Channel_Code, ',') WHERE NUMBER <> '')
		AND T.Deal_Type_Code IN (@DealTypeContent, @DealTypeEvent, @DealTypeFormatProgram) 
		AND (
			(T.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS  Like '%'+ @Title_Name +'%' COLLATE SQL_Latin1_General_CP1_CI_AS AND @Title_Name <> '' ) OR
			T.Title_Code IN (SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@SelectedTitleCodes, ',') WHERE NUMBER <> '')
		)
		END
	END
	ELSE
	BEGIN
		INSERT INTO #TEMP(Title_Name, Channel_Name, Title_Code, Music_Deal_LinkShow_Code)
		SELECT DISTINCT T.Title_Name, C.Channel_Name, T.Title_Code, 
		ISNULL(MDLS.Music_Deal_LinkShow_Code, 0) AS Music_Deal_LinkShow_Code 
		FROM Acq_Deal_Run_Channel ADRC
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
		INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code 
		INNER JOIN Music_Deal_LinkShow MDLS ON MDLS.Title_Code = T.Title_Code AND MDLS.Music_Deal_Code = @Music_Deal_Code
		INNER JOIN Music_Deal_Channel MDC ON MDC.Music_Deal_Code = @Music_Deal_Code and MDC.Channel_Code = ADRC.Channel_Code
	END

	SELECT A.Title_Code, A.Title_Name, A.Music_Deal_LinkShow_Code,
	STUFF((
		SELECT DISTINCT  ', ' + (T.Channel_Name) FROM #Temp T
		WHERE T.Title_Code = A.Title_Code
		FOR XML PATH('')), 1, 1, ''
	) AS Channel_Name_Selected,
	STUFF((
		SELECT DISTINCT  ', ' + (C.Channel_Name) FROM #Temp T
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Title_Code = T.Title_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
		WHERE T.Title_Code = A.Title_Code
		AND ADRC.Channel_Code NOT IN (SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@Channel_Code, ',') WHERE NUMBER <> '')
		FOR XML PATH('')), 1, 1, ''
	) AS Channel_Name_UnSelected
	INTO #TEMP2
	FROM (
		SELECT DISTINCT Title_Name, Title_Code, Music_Deal_LinkShow_Code FROM #Temp
	) AS A 
	
	SELECT Title_Code, Title_Name, Music_Deal_LinkShow_Code, (Channel_Name_Selected + '~' + ISNULL(Channel_Name_UnSelected, '')) AS Channel_Name
	FROM #TEMP2

END

--exec USP_Music_Deal_Link_Show '4,5','a','E','33',''

