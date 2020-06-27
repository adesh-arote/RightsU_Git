CREATE PROC USP_Delete_Provisional_Deal      
(      
	@Provisional_Deal_Code INT      
)      
AS      
BEGIN      
	SET NOCOUNT ON        
	BEGIN TRY      
		BEGIN TRANSACTION;      
		-- Delete record from Provisional_Deal_Run_Channel       
		DELETE PDRC FROM Provisional_Deal_Run_Channel PDRC
		INNER JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Run_Code = PDRC.Provisional_Deal_Run_Code
		INNER JOIN Provisional_Deal_Title PDT ON PDT.Provisional_Deal_Title_Code = PDR.Provisional_Deal_Title_Code
		WHERE PDT.Provisional_Deal_Code = @Provisional_Deal_Code
       
		--Delete record from Provisional_Deal_Run      
		DELETE PDR FROM Provisional_Deal_Run PDR 
		INNER JOIN Provisional_Deal_Title PDT ON PDT.Provisional_Deal_Title_Code = PDR.Provisional_Deal_Title_Code
		WHERE PDT.Provisional_Deal_Code = @Provisional_Deal_Code
       
		--Delete record from Provisional_Deal_Title      
		DELETE FROM Provisional_Deal_Title WHERE Provisional_Deal_Code = @Provisional_Deal_Code      
      
		--Delete record from Provisional_Deal_Licensor      
		DELETE FROM Provisional_Deal_Licensor WHERE Provisional_Deal_Code = @Provisional_Deal_Code      
       
		--Delete record from Provisional_Deal      
		DELETE FROM Provisional_Deal WHERE Provisional_Deal_Code = @Provisional_Deal_Code      
    
		COMMIT TRANSACTION      
		SELECT 'SUCCESSFULLY' AS Result_Message        
	END TRY       
	BEGIN CATCH      
		ROLLBACK TRANSACTION;        
		DECLARE @ErrorMessage NVARCHAR(MAX),@ErrorSeverity INT,@ErrorState INT        
		SELECT    @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();            
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState );          
		SELECT 'ERROR' AS Result_Message        
	END CATCH      
END