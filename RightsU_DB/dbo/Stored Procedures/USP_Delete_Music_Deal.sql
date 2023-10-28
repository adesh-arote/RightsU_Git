CREATE PROCEDURE [dbo].[USP_Delete_Music_Deal]
(
	@Music_Deal_Code INT
)
AS
-- =============================================
-- Author:		SAGAR MAHAHJAN
-- Create DATE: 12-NOV-2014
-- Description:	DELETE Acq Deal Call From Acq Deal List Page
-- =============================================
BEGIN
Declare @Loglevel int;

select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Music_Deal]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET NOCOUNT ON
	BEGIN TRY
	BEGIN TRANSACTION;		
		DELETE FROM Music_Deal_Channel  WHERE Music_Deal_Code  = @Music_Deal_Code
		DELETE FROM Music_Deal_Country  WHERE Music_Deal_Code  = @Music_Deal_Code
		DELETE FROM Music_Deal_Language  WHERE Music_Deal_Code  = @Music_Deal_Code
		DELETE FROM Music_Deal_LinkShow  WHERE Music_Deal_Code  = @Music_Deal_Code
		DELETE FROM Music_Deal_Vendor  WHERE Music_Deal_Code  = @Music_Deal_Code
		DELETE FROM Music_Deal  WHERE Music_Deal_Code  = @Music_Deal_Code

		COMMIT TRANSACTION
		SELECT 'SUCCESSFULLY' AS Result_Message
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION;
		DECLARE @ErrorMessage NVARCHAR(MAX),@ErrorSeverity INT,@ErrorState INT
		SELECT    @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();    
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState );		
		SELECT 'ERROR' AS Result_Message
	END CATCH;
	
if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Music_Deal]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
