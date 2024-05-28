
CREATE FUNCTION [dbo].[UFN_Get_DataFor_RightsUsageReport_New]
(
	--@Acq_Deal_Movie_Code INT,
	@Deal_Code INT,
	@DealType CHAR(1),
	@Title_Code INT,
	@Episode_no INT,

	@Type VARCHAR(50),
	@StartDate VARCHAR(30),
	@EndDate VARCHAR(30),
	@Channel VARCHAR(MAX),
	@RunType VARCHAR(1)
)
--RETURNS NVARCHAR(MAX)
RETURNS @Result TABLE 
(
    Channel_Name NVARCHAR(MAX), 
	Channel_Code NVARCHAR(MAX),  
    Rights_Period VARCHAR(50), 
    Provision_Run INT, 
    Actual_Run INT
)
AS
BEGIN
	--INSERT INTO @Result(Deal_Code, Title_Code, Episode_no)
	--SELECT @Deal_Code, @Title_Code, @Episode_no

	DECLARE @ChannelDetail TABLE
	(
		Channel_Code INT,
		Channel_Name NVARCHAR(MAX)
	)
	
	--IF(@Type = '')
	--	SET @Type = 'H'

	-- =============================================
	-- TYPE 
	-- 'H' = House ID
	-- 'P' = Platform
	-- 'R' = No. Of Runs
	-- 'T' = International Territory

	-- 'CH' = Channels Name
	-- 'CC' = Channels Code
	
	-- 'RP' = Rights Period
	-- 'PR' = Provision Run
	-- 'AR' = Actual Run	
	
	-- 'PAR' = 'Provision Run' + 'Actual Run'
	-- =============================================

	------------------ Channel Code And Channel Name----------------
	
	INSERT INTO @ChannelDetail(Channel_Code, Channel_Name)
	Select DISTINCT C.Channel_Code, C.channel_name FROM Content_Channel_Run CCR 
	INNER JOIN Channel C ON C.channel_code = CCR.channel_code
	Where CCR.Title_Code = @Title_Code AND 
	(
		(CCR.Acq_Deal_Code IN (SELECT TOP 1 ADR.Acq_Deal_Code FROM
		Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
		AND ADR.Acq_Deal_Code = @Deal_Code AND ADRT.Title_Code = @Title_Code
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		AND ADRP.Platform_Code in (
				SELECT platform_code FROM Platform WHERE ISNULL(applicable_for_asrun_schedule,'N') = 'Y'
			)
		) AND CCR.Deal_Type = 'A' AND @DealType = 'A')
	OR
		(CCR.Provisional_Deal_Code IN (
			select Provisional_Deal_Code  from Provisional_Deal PD
			INNER JOIN Provisional_Deal_Title PDT ON PD.Provisional_Deal_Code = PDT.Provisional_Deal_Code AND PDT.Title_Code = @Title_Code
			AND Provisional_Deal_Code = @Deal_Code					
		) AND CCR.Deal_Type = 'P' AND @DealType = 'P')
	) AND (CCR.Run_Type = @RunType OR @RunType = '')

	Update @Result SET Channel_Code = (STUFF((SELECT DISTINCT ', ' +  Channel_Code FROM @ChannelDetail FOR XML PATH('')),1,1,''))							
	,Channel_Name = (STUFF((SELECT DISTINCT ', ' +  Channel_Name FROM @ChannelDetail FOR XML PATH('')),1,1,''))		
	------------------ End Channel Code And Channel Name----------------

	--------------------- Rights Period ---------------------
	SELECT DISTINCT 
	@Result += STUFF
	((
		SELECT DISTINCT ',' + 
		CASE WHEN 
			ISNULL(CONVERT(VARCHAR(20), Y.Rights_Start_Date, 103),'')='' AND ISNULL(CONVERT(VARCHAR(20), Y.Rights_End_Date, 103),'')='' 
			THEN 'Unlimited' 
		ELSE
			convert(VARCHAR(20), Y.Rights_Start_Date, 103) +' - '+ convert(VARCHAR(20), Y.Rights_End_Date, 103) 
		END
			
		FROM
		(
			Select X.Title_Code, X.Episode_No, X.Deal_code, MIN(X.Rights_Start_Date) AS Rights_Start_Date, MAX(X.Rights_End_Date) AS Rights_End_Date from 
			(
				select TC.Title_Code, TC.Episode_No, CASE WHEN @DealType = 'A' THEN CCR.Acq_Deal_Code ELSE CCR.Provisional_Deal_Code END Deal_code,
				CCR.Rights_Start_Date, CCR.Rights_End_Date from Content_Channel_Run CCR INNER JOIN 
				Title_Content TC ON TC.Title_Code = CCR.Title_Code AND TC.Episode_No = @Episode_no
				AND (
					(@DealType = 'A' AND CCR.Acq_Deal_Code = @Deal_Code)
					OR
					(@DealType = 'P' AND CCR.Provisional_Deal_Code = @Deal_Code)
				) AND ((@RunType<>'' AND CCR.Run_Type = @RunType) OR @RunType = '')
			) AS X
		) AS Y
		Group BY X.Title_Code, X.Episode_No, X.Deal_code
	FOR XML PATH('')
	),1,1,'') 

	Update @Result SET Rights_Period = @Result

	--------------------- END Rights Period ---------------------
	
	--------------------- Provision Run ---------------------

	Update @Result SET Provision_Run = (SELECT count(bv.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction bv 
		--Inner Join Acq_Deal_Movie adm ON adm.Acq_Deal_Movie_Code = bv.Deal_Movie_Code And adm.Title_Code = bv.Title_Code And adm.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code
		INNER JOIN  Content_Channel_Run CCR ON CCR.Content_Channel_Run_Code = BV.Content_Channel_Run_Code 
		AND ((CCR.Acq_Deal_Code = @Deal_Code AND @DealType = 'A') OR (CCR.Provisional_Deal_Code = @Deal_Code AND @DealType = 'P')) 
		AND CCR.Title_Code = @Title_Code
		AND ((@Channel<>'' AND bv.Channel_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')
		AND (
				(@StartDate<>'' AND @EndDate <> '' AND CONVERT(DATE,bv.Schedule_Item_Log_Date,103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
				OR (@StartDate<>'' AND @EndDate = '' AND CONVERT(DATE,bv.Schedule_Item_Log_Date,103) = CONVERT(DATE,@StartDate,103))
				OR (@StartDate='' AND @EndDate <> '' AND CONVERT(DATE,bv.Schedule_Item_Log_Date,103) = CONVERT(DATE,@EndDate,103)) 
				OR (@StartDate = '' AND @EndDate = '')
			)
		AND 
			(
				(@RunType<>'' AND CCR.Run_Type = @RunType) OR @RunType=''
			)
	)
	--------------------- END Provision Run ---------------------	

	--------------------- Actual Run ---------------------

	Update @Result SET Actual_Run = (SELECT No_Of_Runs FROM (
		SELECT TC.Title_Code, TC.Episode_No, SUM(CCR.Defined_Runs) No_Of_Runs FROM Content_Channel_Run CCR 
		INNER JOIN Title_Content TC ON TC.Title_Content_Code = CCR.Title_Content_Code
		Where  
		(
			(CCR.Acq_Deal_Code IN (SELECT TOP 1 ADR.Acq_Deal_Code FROM
			Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Deal_Code
			AND ADRP.Platform_Code in (
					SELECT platform_code FROM Platform WHERE ISNULL(applicable_for_asrun_schedule,'N') = 'Y'
				)
			) AND CCR.Deal_Type = 'A' AND @DealType = 'A')
		OR
			(CCR.Provisional_Deal_Code IN (
				select Provisional_Deal_Code  from Provisional_Deal WHERE Provisional_Deal_Code = @Deal_Code					
			) AND CCR.Deal_Type = 'P' AND @DealType = 'P')
		)
		GROUP BY TC.Title_Code, TC.Episode_No)AS X
	)

	--------------------- END Actual Run ---------------------	

	RETURN;
END