CREATE PROCEDURE [dbo].[USP_Schedule_InsertUploadFiles]  
(  
 @FileName VARCHAR(5000),  
 @ChannelCode INT  
)  
AS  
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Schedule_InsertUploadFiles]', 'Step 1', 0, 'Started Procedure', 0, ''
	-- =============================================  
	/*  
	Steps:-  
	Insert into the Upload_Files for Schedule File While Run through Auto Scheduler.  
	1.0 Add a record into Upload_Files. (i.e. Call from SSIS Package.)  
	*/  
	-- =============================================  
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
   
	 ----- 1.0 -----  
	 insert into ErrorOn_AsRun_Schedule (ErrorMessage) values ('Line1')  
    
	 DECLARE @FileCode INT; SET @FileCode = 0  
   
	 SET @FileName = (cast(IDENT_CURRENT('Upload_Files') as varchar) + '~'+ @FileName)  
   
	 insert into ErrorOn_AsRun_Schedule (ErrorMessage) values ('Line2')  
	 INSERT INTO Upload_Files([File_Name], Err_YN, Upload_Date, Uploaded_By, Upload_Type, ChannelCode)  
	 VALUES ( @FileName, 'N', GETDATE(),0,'S', @ChannelCode )  
	 insert into ErrorOn_AsRun_Schedule (ErrorMessage) values ('Line3')  
	 ----- 1.0 -----  
   
	 SELECT @FileCode = IDENT_CURRENT('Upload_Files')   
	 SELECT @FileCode AS FileCode  
	 insert into ErrorOn_AsRun_Schedule (ErrorMessage) values ('Line3')  
   
   
 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Schedule_InsertUploadFiles]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END
