CREATE PROC USP_Schedule_Email_Notification
(
	@BV_Schedule_Transaction_Code INT,
	@Program_Episode_Title_Cr NVARCHAR(500), 
	@Program_Episode_Number_Cr NVARCHAR(500),  
	@Program_Title_Cr NVARCHAR(500)  ,
	@Program_Category_Cr NVARCHAR(500),  
	@Schedule_Item_Log_Date_Cr VARCHAR(500) ,
	@Schedule_Item_Log_TIME_Cr VARCHAR(500) ,
	@Schedule_Item_Duration_Cr VARCHAR(500)  ,
	@Scheduled_Version_House_Number_List_Cr VARCHAR(500) ,
	@FileCode_Cr INT ,
	@TitleCode_Cr INT ,
	@Channel_Code INT,
	@Email_Msg_For NVARCHAR(100),
	@IsRunCountCalculate CHAR(1),
	@Is_Update_BST CHAR(1),
	@IsPrimeException CHAR(1) = NULL,
	@Allocated_Runs_P NUMERIC(18, 0) = 0, 
	@Consumed_Runs_P NUMERIC(18, 0) = 0
)
AS
BEGIN

	DECLARE @EmailMsg NVARCHAR(200)
	SELECT @EmailMsg = Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = @Email_Msg_For
	AND [Type] = 'S'

	INSERT INTO Email_Notification_Schedule 
	(
		BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
		Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
		File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
		Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, IsPrimeException, Allocated_Runs, Consumed_Runs
	)
	SELECT 
	@BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr, @Program_Title_Cr, @Program_Category_Cr, 
	@Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr, @Scheduled_Version_House_Number_List_Cr, 
	@FileCode_Cr, @Channel_Code, GETDATE(), NULL, NULL, 
	@EmailMsg, 'N', @IsRunCountCalculate, @TitleCode_Cr, @IsPrimeException, @Allocated_Runs_P, @Consumed_Runs_P

	IF(@Is_Update_BST = 'Y')
		UPDATE BV_Schedule_Transaction SET IsException = 'Y' WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code				
							


END