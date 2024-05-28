CREATE PROCEDURE [dbo].[USP_Title_Import_Schedule]  
AS   
BEGIN     
	DECLARE @DM_Master_Import_Code INT = 0, @RowCounter INT = 0
	SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import WHERE [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'T' Order by DM_Master_Import_Code desc
	--select @DM_Master_Import_Code = 6179
	DECLARE @COUNT INT, @TotalCount INT,@StatusCount INT, @Status VARCHAR(2), @RsolveStatus VARCHAR(1)
	
	WHILE(@DM_Master_Import_Code > 0)
	BEGIN
	select @RsolveStatus = status from DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code
	
		IF(@RsolveStatus = 'N')
		BEGIN
			UPDATE DM_Master_Import set Status = 'W' where DM_Master_Import_Code = @DM_Master_Import_Code
		END
		
		EXEC USP_DM_Title_PIV @DM_Master_Import_Code
	
		SELECT @COUNT = COUNT(*) FROM DM_Title WHERE Is_Ignore = 'N' AND Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
		SELECT  @TotalCount = COUNT(*) FROM DM_Title WHERE Is_Ignore = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code
	
		SELECT @Status = Status FROM DM_Master_Import where DM_Master_Import_Code  = @DM_Master_Import_Code
		
		IF(@Status != 'R' AND @Status != 'SR')
		BEGIN
			IF(@COUNT > 0 AND @COUNT = @TotalCount) 
			BEGIN 
			EXEC USP_DM_Title_PIII @DM_Master_Import_Code
			END
		
		ELSE
			BEGIN
			SELECT @StatusCount = COUNT(*) FROM DM_Title WHERE (Record_Status = 'R') AND IS_Ignore = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
		
		IF(@StatusCount > 0)
		BEGIN
			UPDATE DM_Master_Import SET Status = 'R' where DM_Master_Import_Code = @DM_Master_Import_Code  
		END
		ELSE
		BEGIN
			UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code  
		END
		END
		END
	  
/*Fetch Next Record*/
		--declare @DM_MasterCode INT
		IF EXISTS (SELECT TOP 1 DM_Master_Import_Code FROM DM_Master_Import 
			WHERE [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'T'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code)
		)
		BEGIN
			SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import 
			WHERE [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'T'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code) Order by DM_Master_Import_Code desc
		END
		ELSE
			SELECT @DM_Master_Import_Code = 0

			--SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import WHERE [Status] NOT IN('S','E','W','N','R') AND File_Type = 'T' Order by DM_Master_Import_Code desc

	END
END