CREATE PROCEDURE [dbo].[USP_DELETE_AT_ACQ_Deal]
(
	@AT_Acq_Deal_Code INT,
	@Debug Char(1) = 'N'
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	BEGIN TRANSACTION;
		/* START : Rights Tab */
		DELETE FROM AT_Acq_Deal_Rights_Holdback_Platform WHERE AT_Acq_Deal_Rights_Holdback_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Holdback_Code FROM AT_Acq_Deal_Rights_Holdback 
			WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Rights_Holdback_Territory WHERE AT_Acq_Deal_Rights_Holdback_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Holdback_Code FROM AT_Acq_Deal_Rights_Holdback 
			WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Rights_Holdback_Dubbing WHERE AT_Acq_Deal_Rights_Holdback_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Holdback_Code FROM AT_Acq_Deal_Rights_Holdback 
			WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		)
		DELETE FROM AT_Acq_Deal_Rights_Holdback_Subtitling WHERE AT_Acq_Deal_Rights_Holdback_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Holdback_Code FROM AT_Acq_Deal_Rights_Holdback 
			WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Rights_Holdback WHERE AT_Acq_Deal_Rights_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		--- Blackout ---
		DELETE FROM AT_Acq_Deal_Rights_Blackout_Platform WHERE AT_Acq_Deal_Rights_Blackout_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Blackout_Code FROM AT_Acq_Deal_Rights_Blackout 
		WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Rights_Blackout_Territory WHERE AT_Acq_Deal_Rights_Blackout_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Blackout_Code FROM AT_Acq_Deal_Rights_Blackout 
			WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Rights_Blackout_Dubbing WHERE AT_Acq_Deal_Rights_Blackout_Code IN
		(
		SELECT AT_Acq_Deal_Rights_Blackout_Code FROM AT_Acq_Deal_Rights_Blackout 
		WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		)
		DELETE FROM AT_Acq_Deal_Rights_Blackout_Subtitling WHERE AT_Acq_Deal_Rights_Blackout_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Blackout_Code FROM AT_Acq_Deal_Rights_Blackout 
		WHERE AT_Acq_Deal_Rights_Code IN
			(
				SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
				WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Rights_Blackout WHERE AT_Acq_Deal_Rights_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		--- Rights ---
		DELETE FROM AT_Acq_Deal_Rights_Title WHERE AT_Acq_Deal_Rights_Code IN
(
	SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
	WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
)
		DELETE FROM AT_Acq_Deal_Rights_Platform WHERE AT_Acq_Deal_Rights_Code IN
(
	SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
	WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
)
		DELETE FROM AT_Acq_Deal_Rights_Territory WHERE AT_Acq_Deal_Rights_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Rights_Subtitling WHERE AT_Acq_Deal_Rights_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)

		DELETE FROM AT_Acq_Deal_Rights_Dubbing WHERE AT_Acq_Deal_Rights_Code IN
		(
			SELECT AT_Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Rights  WHERE AT_Acq_Deal_Code  = @AT_Acq_Deal_Code
		/* END : Rights Tab */

		/* START : Pushback Tab */
		DELETE FROM AT_Acq_Deal_Pushback_Title WHERE AT_Acq_Deal_Pushback_Code IN
		(
			SELECT AT_Acq_Deal_Pushback_Code FROM AT_Acq_Deal_Pushback 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Pushback_Platform WHERE AT_Acq_Deal_Pushback_Code IN
		(
			SELECT AT_Acq_Deal_Pushback_Code FROM AT_Acq_Deal_Pushback 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Pushback_Territory WHERE AT_Acq_Deal_Pushback_Code IN
		(
			SELECT AT_Acq_Deal_Pushback_Code FROM AT_Acq_Deal_Pushback 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Pushback_Subtitling WHERE AT_Acq_Deal_Pushback_Code IN
		(
			SELECT AT_Acq_Deal_Pushback_Code FROM AT_Acq_Deal_Pushback 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Pushback_Dubbing WHERE AT_Acq_Deal_Pushback_Code IN
		(
			SELECT AT_Acq_Deal_Pushback_Code FROM AT_Acq_Deal_Pushback 
			WHERE AT_Acq_Deal_Code =@AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Pushback  WHERE AT_Acq_Deal_Code  = @AT_Acq_Deal_Code
		/* END : Pushback Tab */

		/* START : Run Def Tab */
		DELETE FROM AT_Acq_Deal_Run_Yearwise_Run_Week WHERE  AT_Acq_Deal_Run_Yearwise_Run_Code IN
		(
			SELECT AT_Acq_Deal_Run_Yearwise_Run_Code From AT_Acq_Deal_Run_Yearwise_Run WHERE AT_Acq_Deal_Run_Code IN
			(
				SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
			)
		)
		DELETE FROM AT_Acq_Deal_Run_Yearwise_Run WHERE  AT_Acq_Deal_Run_Code IN
		(		
			SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Run_Repeat_On_Day WHERE  AT_Acq_Deal_Run_Code IN
		(	
			SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)

		DELETE FROM AT_Acq_Deal_Run_Shows WHERE  AT_Acq_Deal_Run_Code IN
		(	
			SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Run_Shows WHERE  AT_Acq_Deal_Run_Code IN
		(	
			SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Run_Channel WHERE  AT_Acq_Deal_Run_Code IN
		(	
			SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Run_Title WHERE  AT_Acq_Deal_Run_Code IN
		(	
			SELECT AT_Acq_Deal_Run_Code FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Run Def Tab */

		/* START : Ancillary Tab */
		DELETE FROM AT_Acq_Deal_Ancillary_Title WHERE  AT_Acq_Deal_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Ancillary_Code From AT_Acq_Deal_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Ancillary_Platform_Medium WHERE  AT_Acq_Deal_Ancillary_Platform_Code IN
		(
			SELECT  AT_Acq_Deal_Ancillary_Platform_Code From AT_Acq_Deal_Ancillary_Platform WHERE  AT_Acq_Deal_Ancillary_Code IN
			(	
				SELECT AT_Acq_Deal_Ancillary_Code From AT_Acq_Deal_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
			) 
		)
		DELETE FROM AT_Acq_Deal_Ancillary_Platform WHERE  AT_Acq_Deal_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Ancillary_Code From AT_Acq_Deal_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Ancillary Tab */

		/* START : Cost Tab */
		DELETE FROM AT_Acq_Deal_Cost_Title WHERE  AT_Acq_Deal_Cost_Code IN
		(	
			SELECT AT_Acq_Deal_Cost_Code From AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Cost_Additional_Exp WHERE  AT_Acq_Deal_Cost_Code IN
		(	
			SELECT AT_Acq_Deal_Cost_Code From AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Cost_Commission WHERE  AT_Acq_Deal_Cost_Code IN
		(	
			SELECT AT_Acq_Deal_Cost_Code From AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Cost_Costtype_Episode WHERE  AT_Acq_Deal_Cost_Costtype_Code IN
		(	
			SELECT AT_Acq_Deal_Cost_Costtype_Code From AT_Acq_Deal_Cost_Costtype WHERE AT_Acq_Deal_Cost_Code IN
			(	
				SELECT AT_Acq_Deal_Cost_Code From AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
			)
		) 
		DELETE FROM AT_Acq_Deal_Cost_Costtype WHERE  AT_Acq_Deal_Cost_Code IN
		(	
			SELECT AT_Acq_Deal_Cost_Code From AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Cost_Variable_Cost WHERE  AT_Acq_Deal_Cost_Code IN
		(	
			SELECT AT_Acq_Deal_Cost_Code From AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Cost Tab */

		/* START : Sports Tab */
		DELETE FROM AT_Acq_Deal_Sport_Broadcast WHERE  AT_Acq_Deal_Sport_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Code FROM AT_Acq_Deal_Sport WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Platform WHERE  AT_Acq_Deal_Sport_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Code FROM AT_Acq_Deal_Sport WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Title WHERE  AT_Acq_Deal_Sport_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Code FROM AT_Acq_Deal_Sport WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Sports Tab */

		/* START : Sports Ancillary Tab */
		DELETE FROM AT_Acq_Deal_Sport_Ancillary_Broadcast WHERE  AT_Acq_Deal_Sport_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Ancillary_Code FROM AT_Acq_Deal_Sport_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Ancillary_Source WHERE  AT_Acq_Deal_Sport_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Ancillary_Code FROM AT_Acq_Deal_Sport_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Ancillary_Title WHERE  AT_Acq_Deal_Sport_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Ancillary_Code FROM AT_Acq_Deal_Sport_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Sports Ancillary Tab */

		/* START : Sports Ancillary Monetisation Tab */
		DELETE FROM AT_Acq_Deal_Sport_Monetisation_Ancillary_Type WHERE  AT_Acq_Deal_Sport_Monetisation_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Monetisation_Ancillary_Code FROM AT_Acq_Deal_Sport_Monetisation_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)  
		DELETE FROM AT_Acq_Deal_Sport_Monetisation_Ancillary_Title WHERE  AT_Acq_Deal_Sport_Monetisation_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Monetisation_Ancillary_Code FROM AT_Acq_Deal_Sport_Monetisation_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Monetisation_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Sports Ancillary Monetisation Tab */

		/* START : Sports Ancillary Sales Tab */
		DELETE FROM AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor WHERE  AT_Acq_Deal_Sport_Sales_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Sales_Ancillary_Code FROM AT_Acq_Deal_Sport_Sales_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Sales_Ancillary_Title WHERE  AT_Acq_Deal_Sport_Sales_Ancillary_Code IN
		(	
			SELECT AT_Acq_Deal_Sport_Sales_Ancillary_Code FROM AT_Acq_Deal_Sport_Sales_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		) 
		DELETE FROM AT_Acq_Deal_Sport_Sales_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Sports Ancillary Sales Tab */
		
		/* START : Payment Term / Material / Attachment, Budget Tab */
		DELETE FROM AT_Acq_Deal_Payment_Terms WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		DELETE FROM AT_Acq_Deal_Material WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		DELETE FROM AT_Acq_Deal_Attachment WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		/* END : Payment Term / Material / Attachment, Budget Tab */

		/* START : General Tab */
		DELETE FROM AT_Acq_Deal_Licensor WHERE  AT_Acq_Deal_Code  = @AT_Acq_Deal_Code
		DELETE FROM AT_Acq_Deal_Run_Shows Where AT_Acq_Deal_Movie_Code IN
		(
			Select AT_Acq_Deal_Movie_Code from AT_Acq_Deal_Movie Where AT_Acq_Deal_Code = @AT_Acq_Deal_Code
		)
		DELETE FROM AT_Acq_Deal_Movie WHERE AT_Acq_Deal_Code  = @AT_Acq_Deal_Code
		DELETE FROM AT_Acq_Deal WHERE AT_Acq_Deal_Code  = @AT_Acq_Deal_Code
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
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		IF(@Debug='D')
			PRINT 'ROLLBACK TRANSACTION'			
		SELECT 'ERROR' AS Result_Message
	END CATCH;
END
/*
EXEC [dbo].[USP_DELETE_Deal] 32, D

*/