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
END
/*
EXEC [dbo].[USP_DELETE_Deal] 32, D

*/
