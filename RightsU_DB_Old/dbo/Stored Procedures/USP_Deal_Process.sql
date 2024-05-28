ALTER PROCEDURE [dbo].[USP_Deal_Process]    
AS    
-- =============================================    
-- Author:  Akshay Rane    
-- Create date: 11 Oct 2017    
-- =============================================    
BEGIN    
	SET NOCOUNT ON    
	--W- Working In Progress    
	--E- Error    
	--D- Done    
	--p- Pending    
	BEGIN TRY 

		DECLARE @RowNo INT = 0
		SELECT TOP 1 @RowNo = COUNT(*) FROM Deal_Process WHERE [Record_Status] = 'P'

		WHILE(@RowNo > 0)
		BEGIN
			DECLARE @Is_Error char(1) = 'N', @Deal_Process_Code INT = 0, @Module_Code INT = 0,  @Deal_Code INT = 0, @EditWithoutApproval  CHAR(1) = '', @Action  CHAR(1) = '',  @Record_Status  CHAR(1) = '', @User_Code INT = 0

			SELECT TOP 1 @Deal_Process_Code = Deal_Process_Code, @Module_Code = Module_Code, @Deal_Code = Deal_Code, @EditWithoutApproval = EditWithoutApproval, @Action = Action,  @Record_Status = Record_Status, @User_Code = User_Code
			FROM Deal_Process WHERE Record_Status = 'P'
    
			UPDATE Deal_Process SET [Record_Status] = 'W', Process_Start = GETDATE() WHERE Deal_Process_Code = @Deal_Process_Code
    
			IF(@Module_Code = 30)
			BEGIN
				IF(@Action = 'A')
				BEGIN
					EXEC [dbo].[USP_AT_Acq_Deal] @Deal_Code, @Is_Error OUT, @EditWithoutApproval

					IF(@Is_Error <> 'N')
					BEGIN
						UPDATE Deal_Process SET Record_Status  = 'E' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code
					END
					ELSE
					BEGIN
						UPDATE Deal_Process SET Record_Status  = 'D' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code
					END
				END
				ELSE IF(@Action = 'R')
				BEGIN
					EXEC [dbo].[USP_RollBack_Acq_Deal] @Deal_Code, @User_Code, @EditWithoutApproval
				END
				EXEC USP_Content_Channel_Run_Data_Generation @Deal_Code
				--EXEC [dbo].[USP_Schedule_Run_Save_Process] @Deal_Code

			END
			ELSE IF(@Module_Code = 35)
			BEGIN
				IF(@Action = 'A')
				BEGIN
					EXEC [dbo].[USP_AT_Syn_Deal] @Deal_Code, @Is_Error OUT
					IF(@Is_Error <> 'N')
					BEGIN
						UPDATE Deal_Process SET Record_Status  = 'E' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code
					END
					ELSE
					BEGIN
						UPDATE Deal_Process SET Record_Status  = 'D' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code
					END
					EXEC [dbo].[USP_AutoPushAcqDeal] @Deal_Code, @User_Code, '',''
				END
				ELSE IF(@Action = 'R')
				BEGIN
					EXEC [dbo].[USP_RollBack_Syn_Deal] @Deal_Code, @User_Code
				END
			END

			SELECT @RowNo = 0    
			SELECT TOP 1 @RowNo = COUNT(*) FROM Deal_Process WHERE Record_Status = 'P'    
		END    
	END TRY      
	BEGIN CATCH      
		 SELECT ERROR_MESSAGE()    
	END CATCH;    
END

--exec USP_Deal_Process