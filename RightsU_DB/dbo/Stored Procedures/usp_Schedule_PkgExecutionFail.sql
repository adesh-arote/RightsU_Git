CREATE PROCEDURE [dbo].[usp_Schedule_PkgExecutionFail]
(
	@FileCode BIGINT
)
AS
BEGIN
-- =============================================
/*
Steps:-
1.0	Update the file status, If SSIS Package Execution is Failed due to any error.
2.0	And Insert into Error Detail Table.
3.0	Send an exception email.
*/
-- =============================================
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
	
	----- 1.0 And 2.0 -----
    UPDATE Upload_Files SET Err_YN = 'Y' WHERE File_code = @FileCode
    
    INSERT INTO Upload_Err_Detail (file_code, Row_Num,Row_Delimed, Err_Cols, Upload_Type, Upload_Title_Type) 
    VALUES (@FileCode, 0, '', '1PkgFail', 'S', 'M')
    ----- 1.0 And 2.0 -----
    
		------------ 3.0 START SEND EMAIL ON Package Fail ------------
		BEGIN TRY
			DECLARE @EmailMsg_New NVARCHAR(MAX)
			SELECT @EmailMsg_New = Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'PkgFail' AND [Type] = 'S'

			DECLARE @ChannelCode INT
			SELECT @ChannelCode= ChannelCode FROM Upload_Files WHERE File_code = @FileCode 
			
			INSERT INTO Email_Notification_Schedule ( File_Code, Channel_Code, Inserted_On, Email_Notification_Msg, IsMailSent )
			VALUES( @FileCode, @ChannelCode, GETDATE(), @EmailMsg_New ,'N' )

			EXEC usp_Schedule_SendException_Email @FileCode, @ChannelCode, 'PkgFail'
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
			PRINT ERROR_MESSAGE() 

			INSERT INTO	ERRORON_SENDMAIL_FOR_WORKFLOW 
			SELECT
			ERROR_NUMBER() AS ERRORNUMBER,
			ERROR_SEVERITY() AS ERRORSEVERITY,		
			ERROR_STATE() AS ERRORSTATE,
			ERROR_PROCEDURE() AS ERRORPROCEDURE,
			ERROR_LINE() AS ERRORLINE,
			ERROR_MESSAGE() AS ERRORMESSAGE;
		END CATCH
		------------ 3.0 End SEND EMAIL ON Package Fail ------------
    
END

/*
EXEC [usp_Schedule_PkgExecutionFail] 1 
*/