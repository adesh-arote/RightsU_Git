CREATE PROCEDURE [dbo].[USP_Deal_Process]    
AS    
-- =============================================    
-- Author:  Akshay Rane    
-- Create date: 11 Oct 2017    
-- =============================================    
BEGIN    
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Deal_Process]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON    
		--W- Working In Progress    
		--E- Error    
		--D- Done    
		--p- Pending    
	
		DECLARE @RowNo INT = 0,@Error_Message VARCHAR(1000),@sql NVARCHAR(MAX),@DB_Name VARCHAR(1000),@Agreement_No VARCHAR(100);
		SELECT TOP 1 @RowNo = COUNT(*) FROM Deal_Process (NOLOCK)  WHERE [Record_Status] = 'P'

		WHILE(@RowNo > 0)
		BEGIN
			DECLARE @Is_Error char(1) = 'N', @Deal_Process_Code INT = 0, @Module_Code INT = 0,  @Deal_Code INT = 0, @EditWithoutApproval  CHAR(1) = '', @Action  CHAR(1) = '',  @Record_Status  CHAR(1) = '', @User_Code INT = 0

			SELECT TOP 1 @Deal_Process_Code = Deal_Process_Code, @Module_Code = Module_Code, @Deal_Code = Deal_Code, @EditWithoutApproval = EditWithoutApproval, @Action = Action,  @Record_Status = Record_Status, @User_Code = User_Code
			FROM Deal_Process (NOLOCK) WHERE Record_Status = 'P'
    
			UPDATE Deal_Process SET [Record_Status] = 'W', Process_Start = GETDATE() WHERE Deal_Process_Code = @Deal_Process_Code
			BEGIN TRY 

				IF(@Module_Code = 30)
				BEGIN
					IF(@Action = 'A')
					BEGIN
						SET @Error_Message = 'USP_AT_Acq_Deal'
						EXEC [dbo].[USP_AT_Acq_Deal] @Deal_Code, @Is_Error OUT, @EditWithoutApproval

						IF(@Is_Error <> 'N')
						BEGIN
							UPDATE Deal_Process SET Record_Status  = 'E' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code

							SELECT @Agreement_No = Agreement_No FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @Deal_Code
							INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
							SELECT GETDATE(),null,null,'USP_Deal_Process','Agreement No : '+ @Agreement_No +' '+'in error state','NA','Error Generate in USP_AT_Acq_Deal','DB' 
					
							SELECT @sql = 'Agreement No : '+ @Agreement_No +' '+'in error state : - Error Generate in USP_AT_Acq_Deal'
							SELECT @DB_Name = DB_Name()
							EXEC [dbo].[USP_SendMail_Page_Crashed] 'SysDB User', @DB_Name,'RU','USP_Deal_Process','AN','VN',@sql,'DB','IP','FR','TI'
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
					SET @Error_Message = 'USP_Content_Channel_Run_Data_Generation'
					EXEC USP_Content_Channel_Run_Data_Generation @Deal_Code
					--EXEC [dbo].[USP_Schedule_Run_Save_Process] @Deal_Code

				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					IF(@Action = 'A')
					BEGIN
						SET @Error_Message = '[USP_AT_Syn_Deal]'
						EXEC [dbo].[USP_AT_Syn_Deal] @Deal_Code, @Is_Error OUT
						IF(@Is_Error <> 'N')
						BEGIN
							UPDATE Deal_Process SET Record_Status  = 'E' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code

							-------INSERTION IN  ERROR LOG TABLE---------------------------------------------------------
							SELECT @Agreement_No = Agreement_No FROM Syn_Deal WHERE Syn_Deal_Code = @Deal_Code
							INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
							SELECT GETDATE(),null,null,'USP_Deal_Process','Agreement No : '+ @Agreement_No +' '+'in error state','NA','Error Generate in USP_AT_Syn_Deal','DB' 
							---change erro
							SELECT @sql = 'Agreement No : '+ @Agreement_No +' '+'in error state : - Error Generate in USP_AT_Syn_Deal'
							SELECT @DB_Name = DB_Name()
							EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_Deal_Process','AN','VN',@sql,'DB','IP','FR','TI'
						END
						ELSE
						BEGIN
							UPDATE Deal_Process SET Record_Status  = 'D' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code
						END
					END
					ELSE IF(@Action = 'R')
					BEGIN
						EXEC [dbo].[USP_RollBack_Syn_Deal] @Deal_Code, @User_Code
					END
				END

			END TRY      
			BEGIN CATCH    
			 SELECT ERROR_MESSAGE() 
					SELECT @Agreement_No = Agreement_No FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @Deal_Code
		 			INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
		 			SELECT GETDATE(),null,null,'USP_Deal_Process','Agreement No : '+ @Agreement_No +' '+'in error state','NA','Error in '+@Error_Message,'DB' 
		 			FROM Deal_Process (NOLOCK) Where Deal_Process_Code = @Deal_Process_Code 
			
					SELECT @sql = @Error_Message +': -'+ ERROR_MESSAGE()
					SELECT @DB_Name = DB_Name()
					EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_Deal_Process','AN','VN',@sql,'DB','IP','FR','TI'
			END CATCH;    

			SELECT @RowNo = 0    
			SELECT TOP 1 @RowNo = COUNT(*) FROM Deal_Process (NOLOCK) WHERE Record_Status = 'P'    
		END   
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Deal_Process]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END