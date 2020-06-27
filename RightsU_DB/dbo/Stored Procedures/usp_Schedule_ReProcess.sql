
CREATE PROC [dbo].[usp_Schedule_ReProcess]  
(
	@File_Code INT,
	@Channel_Code INT
)
AS  
BEGIN
-- =============================================
/*	
Steps:- This SP update the schedule Runs. And send an exception email if any on reprocess.
		Note:- The reprocess is same as normal process. The main change is send @IsReprocess flag to 'Y'
		always need to pass because some steps are handles on this flag.
1.0 Call usp_Schedule_Validate_Temp_BV_Sche Procedure.
*/
-- =============================================
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

	------------------------------------------- GLOBAL VARIBALES -------------------------------------------
	DECLARE @Result_IsSuccess CHAR(1);	SET @Result_IsSuccess = 'N'
	------------------------------------------- END GLOBAL VARIBALES -------------------------------------------
	DECLARE @IsReprocess VARCHAR(10);	SET @IsReprocess = 'Y'

	EXEC [usp_Schedule_Validate_Temp_BV_Sche] @File_Code, @Channel_Code, @IsReprocess
   
	----------------------------------- RETRUN RESULT -----------------------------------
	DECLARE @isErr CHAR (1)
	
	SELECT @isErr = ISNULL(Err_YN,'N') FROM Upload_Files WHERE File_code = @File_Code
	IF(@isErr = 'N')
	BEGIN
		SET @Result_IsSuccess = 'Y'
	END
	ELSE
	BEGIN
		SET @Result_IsSuccess = 'N'
	END
	
	SELECT @Result_IsSuccess as Result
	----------------------------------- END RETRUN RESULT -----------------------------------		
	
END
  
/*  
EXEC [usp_Schedule_ReProcess] 2,3
*/