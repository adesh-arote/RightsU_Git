CREATE PROCEDURE [dbo].[USP_DM_Music_Title_PI]   
	@Music_Title_Import Music_Title_Import READONLY,  
	@User_Code INT=143  
AS  
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DM_Music_Title_PI]', 'Step 1', 0, 'Started Procedure', 0, ''
	 /* -- RECORD_STATUS  
	 N = No Error  
	 E = File Level Error  
	 R = Records are in Conflict  
	 P = No Conflict (Proper and ready to process)  
	 S = Sucess  
	 */  
  
		SET NOCOUNT ON;    
		DECLARE @Error_Message NVARCHAR(MAX), @DM_Master_Import_Code Int,@Sql NVARCHAR(1000),@DB_Name VARCHAR(1000);  
		DECLARE	 @Record_Code INT,
				 @Record_Type CHAR = 'M',
				 @Step_No INT = 3, 
				 @Sub_Step_No INT = 1,
				 @Loop_Counter INT = 0, 
				 @Proc_Name VARCHAR(100),
				 @Short_Status_Code VARCHAR(10),
				 @Process_Error_Code VARCHAR(10),
				 @Process_Error_MSG VARCHAR(50)='',
				 @StepCountIn INT,
				 @StepCountOut INT

		--M0024 - Call USP_Music_Title_PI Procedure

		SELECT @Record_Code = @DM_Master_Import_Code, @Step_No = @Step_No, @Sub_Step_No = 1, @Short_Status_Code = 'M0024', @Proc_Name = 'USP_Music_Title_PI'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

		Select Top 1 @DM_Master_Import_Code = DM_Master_Import_Code From @Music_Title_Import  
		INSERT INTO DM_Music_Title  
		(  
			[Music_Title_Name],   
			[Movie_Album],  
			[Title_Type] ,  
			[Title_Language] ,  
			[Year_of_Release],  
			[Duration] ,  
			[Singers],  
			[Lyricist],  
			[Music_Director],  
			[Music_Label],  
			[Record_Status],  
			[Genres],  
			[Star_Cast],  
			[Music_Version],  
			[Effective_Start_Date],  
			[Theme],  
			[Music_Tag] ,  
			[Movie_Star_Cast],  
			[Music_Album_Type],  
			[DM_Master_Import_Code],  
			[Excel_Line_No],
			[Is_Ignore],
			[Public_Domain]
		)    
		SELECT    
			LTRIM(RTRIM(Replace([Music_Title_Name], ' ', ' '))),  
			LTRIM(RTRIM(Replace([Movie_Album], ' ', ' '))),  
			[Title_Type],  
			[Title_Language],  
			[Year_of_Release],  
			[Duration],  
			[Singers],  
			[Lyricist],  
			[Music_Director],  
			[Music_Label],  
			'N',  
			[Genres],  
			[Star_Cast],  
			[Music_Version],  
			[Effective_Start_Date],  
			[Theme],  
			[Music_Tag],  
			[Movie_Star_Cast],  
			[Music_Album_Type],  
			[DM_Master_Import_Code],  
			[Excel_Line_No] ,
			'N',
			[Public_Domain]
		FROM @Music_Title_Import   
    
			EXEC USP_Validate_Music_Title_Import @DM_Master_Import_Code ,@Step_No,@StepCountOut OUT
		 
			SET @Step_No = @StepCountOut

	   IF EXISTS(SELECT Record_Status FROM DM_Music_Title (NOLOCK) WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
		 BEGIN
			SELECT   
			   [IntCode]+1 AS Line_Number,  
			   [Music_Title_Name] ,   
			   [Movie_Album],  
			   [Title_Language] ,  
			   [Year_of_Release],  
			   [Music_Label],  
			   [Star_Cast],  
			   [Movie_Star_Cast],  
			   [Music_Album_Type],  
	 		Substring([Error_Message],2,len([Error_Message])-1) AS Error_Messages
	 		FROM DM_Music_Title (NOLOCK)
			WHERE [Record_Status] = 'E'  
			UPDATE DM_Master_Import Set [Status] = 'E' where DM_Master_Import_Code  = @DM_Master_Import_Code

			DECLARE @File_Name VARCHAR(MAX)
			SELECT @File_Name = File_Name FROM DM_Master_Import (NOLOCK) WHere DM_Master_Import_Code = @DM_Master_Import_Code AND [Status] = 'E'
			INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
			SELECT GETDATE(),NULL,NULL,'USP_DM_Music_Title_PI','Error in file: '+ @File_Name,'NA','NA','DB'
		
			SELECT @sql = 'Error in file: '+ @File_Name
			SELECT @DB_Name = DB_Name()
			EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_DM_Music_Title_PI','AN','VN',@sql,'DB','IP','FR','TI'
		END
		ELSE
		BEGIN
			UPDATE DM_Master_Import Set [Status] = 'Q' where DM_Master_Import_Code  = @DM_Master_Import_Code
		END
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DM_Music_Title_PI]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END