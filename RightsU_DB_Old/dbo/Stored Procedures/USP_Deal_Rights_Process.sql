﻿ALTER Procedure USP_Deal_Rights_Process
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Deal_Code INT, @User_Code INT, @Rights_Bulk_Update_Code INT
	DECLARE @IsValid CHAR(1)

	BEGIN TRY
		DECLARE db_DRPcursor CURSOR FOR 
		SELECT DISTINCT Deal_Code, User_Code, Rights_Bulk_Update_Code FROM Deal_Rights_Process WHERE Record_Status = 'P'

		OPEN db_DRPcursor  
		FETCH NEXT FROM db_DRPcursor INTO @Deal_Code, @User_Code, @Rights_Bulk_Update_Code

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			  SET @IsValid = 'N'
			  EXEC USP_Acq_Bulk_Update_Process @Deal_Code, @User_Code, @Rights_Bulk_Update_Code, @IsValid OUTPUT
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
END