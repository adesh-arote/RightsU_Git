CREATE PROCEDURE [dbo].[USP_DELETE_Deal]
(
	@Acq_Deal_Code INT,
	@Debug Char(1) = 'N'
)
AS
-- =============================================
-- Author:		SAGAR MAHAHJAN
-- Create DATE: 12-NOV-2014
-- Description:	DELETE Acq Deal Call From Acq Deal List Page
-- =============================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DELETE_Deal]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON
		BEGIN TRY
		BEGIN TRANSACTION;
			/* START : Rights Tab */
			--- Holdback ---
			DELETE FROM Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN
			(
				SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback (NOLOCK) 
				WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN
			(
				SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback (NOLOCK)
				WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN
			(
				SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback (NOLOCK)
				WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights  (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			)
			DELETE FROM Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN
			(
				SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback  (NOLOCK)
				WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights  (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights  (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)

			--Blackout
			DELETE FROM Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN
			(
				SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout (NOLOCK)
			WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN
			(
				SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout (NOLOCK)
				WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN
			(
			SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout (NOLOCK)
			WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			)
			DELETE FROM Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN
			(
				SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout (NOLOCK)
			WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)

			---Promoter

			DELETE FROM Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code IN
			(
				SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter (NOLOCK)
			WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
				DELETE FROM Acq_Deal_Rights_Promoter_Remarks WHERE Acq_Deal_Rights_Promoter_Code IN
			(
				SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter (NOLOCK)
			WHERE Acq_Deal_Rights_Code IN
				(
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK) 
					WHERE Acq_Deal_Code =@Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			--Rights
			DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code IN
			(
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Rights  WHERE Acq_Deal_Code  = @Acq_Deal_Code
			/* END : Rights Tab */

			/* START : Pushback Tab */
			DELETE FROM Acq_Deal_Pushback_Title WHERE Acq_Deal_Pushback_Code IN
			(
				SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Pushback_Platform WHERE Acq_Deal_Pushback_Code IN
			(
				SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Pushback_Territory WHERE Acq_Deal_Pushback_Code IN
			(
				SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Pushback_Subtitling WHERE Acq_Deal_Pushback_Code IN
			(
				SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Pushback_Dubbing WHERE Acq_Deal_Pushback_Code IN
			(
				SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback (NOLOCK)
				WHERE Acq_Deal_Code =@Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Pushback  WHERE Acq_Deal_Code  = @Acq_Deal_Code
			/* END : Pushback Tab */

			/* START : Run Def Tab */
			DELETE FROM Acq_Deal_Run_Yearwise_Run_Week WHERE  Acq_Deal_Run_Yearwise_Run_Code IN
			(
				SELECT Acq_Deal_Run_Yearwise_Run_Code From Acq_Deal_Run_Yearwise_Run (NOLOCK) WHERE Acq_Deal_Run_Code IN
				(
					SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
				)
			)
			DELETE FROM Acq_Deal_Run_Yearwise_Run WHERE  Acq_Deal_Run_Code IN
			(		
				SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Run_Repeat_On_Day WHERE  Acq_Deal_Run_Code IN
			(	
				SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)

			DELETE from Acq_Deal_Run_Shows where   Acq_Deal_Run_Code IN
			(	
				SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Run_Shows WHERE  Acq_Deal_Run_Code IN
			(	
				SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Run_Channel WHERE  Acq_Deal_Run_Code IN
			(	
				SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Run_Title WHERE  Acq_Deal_Run_Code IN
			(	
				SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Run Def Tab */

			/* START : Ancillary Tab */
			DELETE FROM Acq_Deal_Ancillary_Title WHERE  Acq_Deal_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Ancillary_Code From Acq_Deal_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Ancillary_Platform_Medium WHERE  Acq_Deal_Ancillary_Platform_Code IN
			(
				SELECT  Acq_Deal_Ancillary_Platform_Code From Acq_Deal_Ancillary_Platform WHERE  Acq_Deal_Ancillary_Code IN
				(	
					SELECT Acq_Deal_Ancillary_Code From Acq_Deal_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
				) 
			)
			DELETE FROM Acq_Deal_Ancillary_Platform WHERE  Acq_Deal_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Ancillary_Code From Acq_Deal_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Ancillary Tab */

			/* START : Cost Tab */
			DELETE FROM Acq_Deal_Cost_Title WHERE  Acq_Deal_Cost_Code IN
			(	
				SELECT Acq_Deal_Cost_Code From Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Cost_Additional_Exp WHERE  Acq_Deal_Cost_Code IN
			(	
				SELECT Acq_Deal_Cost_Code From Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Cost_Commission WHERE  Acq_Deal_Cost_Code IN
			(	
				SELECT Acq_Deal_Cost_Code From Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Cost_Costtype_Episode WHERE  Acq_Deal_Cost_Costtype_Code IN
			(	
				SELECT Acq_Deal_Cost_Costtype_Code From Acq_Deal_Cost_Costtype (NOLOCK) WHERE Acq_Deal_Cost_Code IN
				(	
					SELECT Acq_Deal_Cost_Code From Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
				)
			) 
			DELETE FROM Acq_Deal_Cost_Costtype WHERE  Acq_Deal_Cost_Code IN
			(	
				SELECT Acq_Deal_Cost_Code From Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Cost_Variable_Cost WHERE  Acq_Deal_Cost_Code IN
			(	
				SELECT Acq_Deal_Cost_Code From Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Cost WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Cost Tab */

			/* START : Sports Tab */
			DELETE FROM Acq_Deal_Sport_Broadcast WHERE  Acq_Deal_Sport_Code IN
			(	
				SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Platform WHERE  Acq_Deal_Sport_Code IN
			(	
				SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Title WHERE  Acq_Deal_Sport_Code IN
			(	
				SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Language WHERE  Acq_Deal_Sport_Code IN
			(	
				SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Sports Tab */

			/* START : Sports Ancillary Tab */
			DELETE FROM Acq_Deal_Sport_Ancillary_Broadcast WHERE  Acq_Deal_Sport_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Ancillary_Source WHERE  Acq_Deal_Sport_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Ancillary_Title WHERE Acq_Deal_Sport_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Sports Ancillary Tab */

			/* START : Sports Ancillary Monetisation Tab */
			DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary_Type WHERE  Acq_Deal_Sport_Monetisation_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM Acq_Deal_Sport_Monetisation_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			)  
			DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary_Title WHERE  Acq_Deal_Sport_Monetisation_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM Acq_Deal_Sport_Monetisation_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Sports Ancillary Monetisation Tab */

			/* START : Sports Ancillary Sales Tab */
			DELETE FROM Acq_Deal_Sport_Sales_Ancillary_Sponsor WHERE  Acq_Deal_Sport_Sales_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Sales_Ancillary_Title WHERE  Acq_Deal_Sport_Sales_Ancillary_Code IN
			(	
				SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			) 
			DELETE FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Sports Ancillary Sales Tab */

			/* START : Payment Term / Material / Attachment, Budget Tab */
			DELETE FROM Acq_Deal_Payment_Terms WHERE Acq_Deal_Code = @Acq_Deal_Code
			DELETE FROM Acq_Deal_Material WHERE Acq_Deal_Code = @Acq_Deal_Code
			DELETE FROM Acq_Deal_Attachment WHERE Acq_Deal_Code = @Acq_Deal_Code
			DELETE FROM Acq_Deal_Budget WHERE Acq_Deal_Code = @Acq_Deal_Code
			/* END : Payment Term / Material / Attachment, Budget Tab */

			/* START : General Tab */
			DELETE FROM Acq_Deal_Licensor WHERE  Acq_Deal_Code  = @Acq_Deal_Code
			DELETE FROM Title_Content_Mapping Where Acq_Deal_Movie_Code IN
			(
				Select Acq_Deal_Movie_Code from Acq_Deal_Movie (NOLOCK) Where Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Run_Shows Where Acq_Deal_Movie_Code IN
			(
				Select Acq_Deal_Movie_Code from Acq_Deal_Movie (NOLOCK) Where Acq_Deal_Code = @Acq_Deal_Code
			)
			DELETE FROM Acq_Deal_Movie WHERE Acq_Deal_Code  = @Acq_Deal_Code

			/*Delete from supplementary*/
		
			DELETE FROM [dbo].[Acq_Deal_Supplementary_detail] WHERE Acq_Deal_Supplementary_Code in (SELECT Acq_Deal_Supplementary_Code FROM [dbo].[Acq_Deal_Supplementary] 
			WHERE Acq_Deal_Code = @Acq_Deal_Code)

			DELETE FROM [dbo].[Acq_Deal_Supplementary] WHERE Acq_Deal_Code = @Acq_Deal_Code

			/*Delete from supplementary*/
		
			DELETE FROM  Acq_Deal WHERE Acq_Deal_Code  = @Acq_Deal_Code
			/* END : General Tab */
			COMMIT TRANSACTION;
			IF(@Debug='D')
				PRINT 'COMMIT TRANSACTION'
			SELECT 'SUCCESSFULLY' AS Result_Message
		END TRY
		BEGIN CATCH	
			ROLLBACK TRANSACTION;
			DECLARE @ErrorMessage NVARCHAR(MAX),@ErrorSeverity INT,@ErrorState INT
			SELECT    @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();    
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState );
			IF(@Debug='D')
				PRINT 'ROLLBACK TRANSACTION'			
			SELECT 'ERROR' AS Result_Message
		END CATCH;
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DELETE_Deal]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
