CREATE Procedure [dbo].[USP_Deal_Rights_Process]
AS
BEGIN
	Declare @Loglevel int;
 
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Deal_Rights_Process]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON
		DECLARE @Deal_Code INT, @User_Code INT, @Rights_Bulk_Update_Code INT
		DECLARE @IsValid CHAR(1), @DRPL_Code INT = 0

		BEGIN TRY
			DECLARE db_DRPcursor CURSOR FOR 
			SELECT DISTINCT Deal_Code, User_Code, Rights_Bulk_Update_Code FROM Deal_Rights_Process (NOLOCK) WHERE Record_Status = 'P' AND ISNULL(Rights_Bulk_Update_Code , 0) > 0

			OPEN db_DRPcursor  
			FETCH NEXT FROM db_DRPcursor INTO @Deal_Code, @User_Code, @Rights_Bulk_Update_Code

			WHILE @@FETCH_STATUS = 0  
			BEGIN  
			
				INSERT INTO Deal_Rights_Process_Log (Deal_Code, Rights_Bulk_Update_Code , Record_Status, Description, Created_Date)
				SELECT @Deal_Code,@Rights_Bulk_Update_Code,'P','Before Calling USP_Acq_Bulk_Update_Process Store Procedure.', GETDATE()

				SELECT @DRPL_Code =  CAST(SCOPE_IDENTITY() AS INT)

				SET @IsValid = 'N'
				EXEC USP_Acq_Bulk_Update_Process @Deal_Code, @User_Code, @Rights_Bulk_Update_Code,@DRPL_Code, @IsValid OUTPUT
				--UPDATE ERROR MESSAGE TO DEAL_RIGHTS_PROCESS WHERE STATE IS WORKING

				FETCH NEXT FROM db_DRPcursor INTO @Deal_Code, @User_Code, @Rights_Bulk_Update_Code
			END 

			CLOSE db_DRPcursor  
			DEALLOCATE db_DRPcursor 
		END TRY
		BEGIN CATCH
			CLOSE db_DRPcursor  
			DEALLOCATE db_DRPcursor 
			SELECT ERROR_MESSAGE()
		END CATCH
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Deal_Rights_Process]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END


