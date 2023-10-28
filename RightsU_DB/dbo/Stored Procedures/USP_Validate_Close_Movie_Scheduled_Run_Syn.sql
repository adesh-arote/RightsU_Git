CREATE PROCEDURE [dbo].[USP_Validate_Close_Movie_Scheduled_Run_Syn]
	@Syn_Deal_Movie_Code int,
	@Title_Code int,
	@Deal_Movie_Close_Date varchar(25),
	@Episode_From INT,
	@Episode_To INT
AS
-- =============================================
-- Author:		Aditya B
-- Create date: 09 Nov 2020
-- Description:	Validating movie close date with runs schedule date
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Close_Movie_Scheduled_Run_Syn]', 'Step 1', 0, 'Started Procedure', 0, ''  	
		--DECLARE
		--@SYN_DEAL_MOVIE_CODE INT =  4052,
		--@TITLE_CODE INT = 43690,
		--@DEAL_MOVIE_CLOSE_DATE VARCHAR(25) = '2030-11-13 00:00:00',--'NOV 14 2026 12:00AM',
		--@EPISODE_FROM INT = 1,
		--@EPISODE_TO INT = 3

	/*
	Condition-1 : Close date is less than Rights Date, Give alert that Rights willl be deleted , And If run is also Present then Combined Error
	Condition-2 : Close date cannot be greater than Max Rights Start date
	*/
	
		SET FMTONLY OFF
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		DECLARE @recordcnt INT = 0
		DECLARE @maxdate DATETIME ='', @mindate DATETIME ='', @syn_maxdate DATETIME ='', @syn_mindate DATETIME ='', @bv_maxdate DATETIME ='',@maxStartdate DATETIME =''			
		DECLARE @type varchar(500) =''
		DECLARE @alert varchar(500) ='N',@DealCode INT,@AgreementNo VARCHAR(100) = '',@TitleName NVARCHAR(MAX) = '',@Channel NVARCHAR(MAX)= ''

		DELETE FROM Acq_Deal_Close_Title_Error_Details WHERE Acq_Deal_Movie_Code = @Syn_Deal_Movie_Code

		SELECT @DealCode = Acq_Deal_Code FROM Acq_Deal_Movie (NOLOCK) WHERE Acq_Deal_Movie_Code = @Syn_Deal_Movie_Code
		SELECT @AgreementNo = Agreement_No FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @DealCode
		SELECT @TitleName = Title_Name FROM Title (NOLOCK) WHere Title_Code = @Title_Code
	
		DECLARE @Deal_Type_Condition VARCHAR(MAX) = '', @isError CHAR(1) = 'N'

		SELECT TOP 1 @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(SD.Deal_Type_Code) FROM Syn_Deal_Movie SDM  (NOLOCK)
		INNER JOIN Syn_Deal SD  (NOLOCK) ON SD.Syn_Deal_Code = SDM.Syn_Deal_Code AND SDM.Syn_Deal_Movie_Code = @Syn_Deal_Movie_Code

		SELECT @mindate = MIN(adr.Right_Start_Date), @maxdate =  ISNULL(MAX(adr.Right_End_Date), CONVERT(DATETIME, @Deal_Movie_Close_Date)), @maxStartdate = MAX(adr.Right_Start_Date)
		FROM Syn_Deal_Rights_Title adrt (NOLOCK)
		INNER JOIN Syn_Deal_Rights adr  (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Movie adm (NOLOCK) on adm.Syn_Deal_Code = adr.Syn_Deal_Code
		WHERE adm.Syn_Deal_Movie_Code = @Syn_Deal_Movie_Code AND adrt.Title_Code = @Title_Code 
		--SELECT @Deal_Movie_Close_Date
		--SELECT @maxdate
		IF(CONVERT(DATETIME, @Deal_Movie_Close_Date) <= @maxdate)
		BEGIN
				IF(CONVERT(DATETIME, @Deal_Movie_Close_Date) < @maxStartdate)
				BEGIN
					SET @type = 'The selected Title closed date should be greater than or equal to maximum rights start date'
					SET @alert = 'Y'

					INSERT INTO Acq_Deal_Close_Title_Error_Details(Acq_Deal_Code,Acq_Deal_Movie_Code,Title_Code,Episode_From,Episode_To,Title,ValidationFor,Agreement_No,Period,Airing_Date,Airing_Channel,Err_Msg)
					SELECT @DealCode,@Syn_Deal_Movie_Code,@Title_Code,@Episode_From,@Episode_To,@TitleName,'SR',@AgreementNo,(CONVERT(VARCHAR,@mindate,106) + ' - ' + CONVERT(VARCHAR,@maxdate,106)),'NA','NA',@type

				END
		END
		ELSE IF(CONVERT(DATETIME, @Deal_Movie_Close_Date) > @maxdate)
		BEGIN
			SET @type = 'The selected Title closed date should be less than or equal to maximum rights date '

			INSERT INTO Acq_Deal_Close_Title_Error_Details(Acq_Deal_Code,Acq_Deal_Movie_Code,Title_Code,Episode_From,Episode_To,Title,ValidationFor,Agreement_No,Period,Airing_Date,Airing_Channel,Err_Msg)
			SELECT @DealCode,@Syn_Deal_Movie_Code,@Title_Code,@Episode_From,@Episode_To,@TitleName,'SR',@AgreementNo,(CONVERT(VARCHAR,@mindate,106) + ' - ' + CONVERT(VARCHAR,@maxdate,106)),'NA','NA',@type

		END

		SELECT RTRIM(LTRIM(@type)) AS Msg, @maxdate AS Max_Date, @alert AS Show_Confirmation
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Close_Movie_Scheduled_Run_Syn]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END