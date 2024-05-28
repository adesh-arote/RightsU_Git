CREATE PROCEDURE [dbo].[USP_Validate_Close_Movie__Scheduled_Run]
	@Acq_Deal_Movie_Code int,
	@Title_Code int,
	@Deal_Movie_Close_Date varchar(15),
	@Episode_From INT,
	@Episode_To INT
AS
-- =============================================
-- Author:		Rajesh Godse
-- Create date: 17 April 2015
-- Description:	Validating movie close date with runs schedule date
-- =============================================
BEGIN
	Declare @Loglevel int  
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Close_Movie__Scheduled_Run]', 'Step 1', 0, 'Started Procedure', 0, ''  

	/*
	Condition-1 : Close date is less than Rights Date, Give alert that Rights willl be deleted , And If run is also Present then Combined Error
	Condition-2 : Close date cannot be greater than Max Rights Start date
	Condition-3 : Close date greater than Max of Syndicated Date
	Condition-3 : Close date greater than Max of BV_Schedule_Transaction
	*/
	
		SET FMTONLY OFF
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		DECLARE @recordcnt INT = 0
		DECLARE @maxdate DATETIME ='', @mindate DATETIME ='', @syn_maxdate DATETIME ='', @syn_mindate DATETIME ='', @bv_maxdate DATETIME =''			
		DECLARE @type varchar(500) =''
		DECLARE @alert varchar(500) ='N'
		DECLARE @Acq_Deal_Code INT = NULL
	
		DECLARE @Deal_Type_Condition VARCHAR(MAX) = '', @isError CHAR(1) = 'N'

		SELECT TOP 1 @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), @Acq_Deal_Code = ADM.Acq_Deal_Code FROM Acq_Deal_Movie ADM  (NOLOCK) 
		INNER JOIN Acq_Deal AD (NOLOCK)  ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code

		SELECT @mindate = MIN(adr.Right_Start_Date), @maxdate =  ISNULL(MAX(adr.Right_End_Date), CONVERT(DATETIME, @Deal_Movie_Close_Date))
		FROM Acq_Deal_Rights_Title adrt (NOLOCK) 
		INNER JOIN Acq_Deal_Rights adr  (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Movie adm  (NOLOCK) on adm.Acq_Deal_Code = adr.Acq_Deal_Code
		WHERE adm.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code AND adrt.Title_Code = @Title_Code 
	
		IF((
		SELECT count(*)
		FROM Acq_Deal_Rights_Title adrt (NOLOCK) 
		INNER JOIN Acq_Deal_Rights adr (NOLOCK)  ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Movie adm (NOLOCK)  on adm.Acq_Deal_Code = adr.Acq_Deal_Code
		WHERE adm.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code AND adrt.Title_Code = @Title_Code AND adrt.Episode_From = adm.Episode_Starts_From AND adrt.Episode_To = adm.Episode_End_To AND adr.Right_Type = 'M' AND adr.Actual_Right_Start_Date IS NULL AND adr.Actual_Right_End_Date IS NULL
		)>0)
		BEGIN
			SET @type = 'Please set milestone date before closing title '
			SET @maxdate = ''
		END
		ELSE IF (
					(
						SELECT COUNT(*) AS Rec_Count FROM Acq_Deal_Movie_Music_Link (NOLOCK)  WHERE Link_Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code AND 
						(Episode_No > @Episode_To OR Episode_No < @Episode_From )
					) > 0 
					AND 
					@Deal_Type_Condition = 'DEAL_PROGRAM'
				)
		BEGIN
			SET @type = STUFF
				(
					(
						SELECT ', Episode-' + CAST(Episode_No AS VARCHAR) FROM 
						(
							SELECT DISTINCT Episode_No FROM Acq_Deal_Movie_Music_Link (NOLOCK)  WHERE Link_Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code AND (Episode_No > @Episode_To OR Episode_No < @Episode_From)
						) AS A
						ORDER BY Episode_No
						FOR XML PATH('')
					), 1, 1, ''
				) + ' are already linked with music title'
			SET @maxdate = ''
		END
		ELSE IF ( 
					(SELECT COUNT(*) AS Rec_Count FROM Acq_Deal_Movie_Music (NOLOCK)  WHERE Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code) > @Episode_From 
					AND 
					@Episode_From > 0 
					AND
					@Deal_Type_Condition = 'DEAL_MUSIC' 
				)
		BEGIN
			SET @type = 'No. of Songs must be greater than equal to ' + CAST(@Episode_From AS VARCHAR)
			SET @maxdate = ''
		END
		ELSE IF(CONVERT(DATETIME, @Deal_Movie_Close_Date) <= @maxdate)
		BEGIN	
			SELECT @syn_maxdate = MAX(ISNULL(sdr.Right_End_Date, @Deal_Movie_Close_Date)) ,@syn_mindate = MIN(sdr.Right_Start_Date)
			FROM Syn_Deal_Rights sdr (NOLOCK) 
			INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK)  ON sdrt.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
			WHERE sdrt.Title_Code = @Title_Code

			IF(ISNULL(@syn_mindate, '')!= '' AND CONVERT(DATETIME, @Deal_Movie_Close_Date) < @syn_maxdate)
			BEGIN
				SET @type = 'The selected Title closed date should be greater than or equal to Syndicated date'
				SET @maxdate = @syn_maxdate
			END	
			ELSE
			BEGIN
				--SELECT @bv_maxdate = MAX(ISNULL(Schedule_Item_Log_Date, @Deal_Movie_Close_Date)) 
				--FROM BV_Schedule_Transaction
				--WHERE Deal_Movie_Code = @Acq_Deal_Movie_Code AND Title_Code = @Title_Code

				SELECT @bv_maxdate = MAX(ISNULL(Schedule_Item_Log_Date, @Deal_Movie_Close_Date)) 
				FROM BV_Schedule_Transaction (NOLOCK) 
				WHERE Content_Channel_Run_Code IN( Select Content_Channel_Run_Code From Content_Channel_Run (NOLOCK)  Where Acq_Deal_Code = @Acq_Deal_Code AND Title_Code = @Title_Code)

				IF(ISNULL(@bv_maxdate,'') != '' AND @bv_maxdate > CONVERT(DATETIME, @Deal_Movie_Close_Date))
				BEGIN
					SET @type = 'The selected Title is already scheduled for run after your specified close date.Please select maximum closed date.'
					SET @maxdate = @bv_maxdate
				END
				ELSE IF(CONVERT(DATETIME, @Deal_Movie_Close_Date) < @mindate)
				BEGIN
					SET @type = 'The selected Titles rights will be deleted'
					SET @alert = 'Y'
				END
			END
		END
		ELSE IF(CONVERT(DATETIME, @Deal_Movie_Close_Date) > @maxdate)
		BEGIN
			SET @type = 'The selected Title closed date should be less than or equal to maximum rights date '
		END
	
		SELECT RTRIM(LTRIM(@type)) AS Msg, @maxdate AS Max_Date, @alert AS Show_Confirmation
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Close_Movie__Scheduled_Run]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END