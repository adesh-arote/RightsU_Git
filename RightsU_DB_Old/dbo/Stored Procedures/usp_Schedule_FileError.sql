CREATE PROCEDURE [dbo].[usp_Schedule_FileError]
(
	@FileCode BIGINT,
	@RowNum INT
)
AS
BEGIN
-- =============================================
-- Author:		BHAVESH DESAI
-- Create date: 8 April 2015
-- Description:	This SP Update the status, If SSIS Package Execution is Failed; Due to improper file format.
-- =============================================

-- =============================================
/*
Steps:-
	1.0	Update file status if found file error.
	2.0	Send exception EMAIL on schedule file rejection.
*/
-- =============================================
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

	----- 1.0 -----
    UPDATE Upload_Files SET Err_YN = 'Y' WHERE File_code = @FileCode
    
    INSERT INTO Upload_Err_Detail (file_code, Row_Num,Row_Delimed, Err_Cols, Upload_Type, Upload_Title_Type) 
    VALUES (@FileCode, @RowNum, '', '1FE', 'S', 'M')
    ----- 1.0 -----
    
    ------------ 2.0 START SEND EMAIL ON FILE REJECTION ------------
    DECLARE @Channel_Code INT
    Select @Channel_Code = ISNULL(ChannelCode,0) FROM Upload_Files WHERE File_code = @FileCode
	
	DECLARE @EmailMsg NVARCHAR(MAX)
    SELECT @EmailMsg = Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'ImproperFile' AND [Type] = 'S'
    
    INSERT INTO Email_Notification_Schedule
	(
		File_Code, Channel_Code, Inserted_On, Email_Notification_Msg, IsMailSent
	)
	VALUES
	(
		@FileCode, @Channel_Code, GETDATE(), @EmailMsg,'N'
	)
	
	EXEC usp_Schedule_SendException_Email @FileCode, @Channel_Code, 'ImproperFile' 
	------------ 2.0 END SEND EMAIL ON FILE REJECTION ------------
    
END

/*
EXEC [usp_Schedule_FileError] 1
*/