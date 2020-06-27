CREATE PROCEDURE [dbo].[USP_Schedule_InsertUploadFiles]
(
	@FileName VARCHAR(5000),
	@ChannelCode INT
)
AS
BEGIN
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
	DECLARE @FileCode INT;	SET @FileCode = 0
	SET @FileName = (cast(IDENT_CURRENT('Upload_Files') AS VARCHAR) + '~'+ @FileName)
	
	INSERT INTO Upload_Files([File_Name], Err_YN, Upload_Date, Uploaded_By, Upload_Type, ChannelCode)
	VALUES ( @FileName, 'N', GETDATE(),0,'S', @ChannelCode )
	----- 1.0 -----
	
END

/*
Exec USP_Schedule_InsertUploadFiles  'a.txt',1
*/