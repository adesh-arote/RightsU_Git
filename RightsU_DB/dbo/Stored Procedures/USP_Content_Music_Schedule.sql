CREATE PROCEDURE [dbo].[USP_Content_Music_Schedule]  
AS   
BEGIN     
	DECLARE @DM_Master_Import_Code INT = 0, @RowCounter INT = 0
	SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import WHERE [Status] NOT IN('S','E','W','R','T') AND File_Type = 'C' Order by DM_Master_Import_Code desc
	--select @DM_Master_Import_Code = 6179
	DECLARE @COUNT INT, @TotalCount INT,@StatusCount INT, @Status VARCHAR(2), @RsolveStatus VARCHAR(1)

	WHILE(@DM_Master_Import_Code > 0)
	BEGIN
		select @RsolveStatus = status from DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code
	
		IF(@RsolveStatus = 'N')
		BEGIN
			UPDATE DM_Master_Import set Status = 'W' where DM_Master_Import_Code = @DM_Master_Import_Code
			EXEC USP_Validate_Content_Music_Import @DM_Master_Import_Code
		END
		--ELSE
		--BEGIN
		--	EXEC USP_Validate_Content_Music_Import @DM_Master_Import_Code
		--END
		
		EXEC USP_Content_Music_PIV @DM_Master_Import_Code
	
		SELECT @Status = Status FROM DM_Master_Import where DM_Master_Import_Code  = @DM_Master_Import_Code
		
		SELECT @COUNT = COUNT(*) FROM DM_Content_Music WHERE Is_Ignore = 'N' AND (Record_Status = 'N' OR Record_Status = 'SM')
		AND DM_Master_Import_Code = @DM_Master_Import_Code
		SELECT  @TotalCount = COUNT(*) FROM DM_Content_Music WHERE Is_Ignore = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code
	
		SELECT @Status = Status FROM DM_Master_Import where DM_Master_Import_Code  = @DM_Master_Import_Code
		
		IF(@Status != 'R')
		BEGIN
			IF(((Select [Status] From DM_Master_Import Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P') OR (@COUNT > 0 AND @COUNT = @TotalCount) )
			BEGIN 
			EXEC USP_Content_Music_PIII @DM_Master_Import_Code
			END
		
		ELSE
			BEGIN
			SELECT @StatusCount = COUNT(*) FROM DM_Content_Music WHERE (Record_Status = 'MR' OR Record_Status = 'OR' OR Record_Status = 'MO' OR Record_Status = 'SO' OR Record_Status = 'SM' ) AND IS_Ignore = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
		
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
		IF EXISTS (SELECT TOP 1 DM_Master_Import_Code FROM DM_Master_Import 
			WHERE [Status] NOT IN('S','E','W','R','T') AND File_Type = 'C'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code)
		)
		BEGIN
			SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import 
			WHERE [Status] NOT IN('S','E','W','R','T') AND File_Type = 'C'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code) Order by DM_Master_Import_Code desc
		END
		ELSE
			SELECT @DM_Master_Import_Code = 0
	--SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import WHERE [Status] NOT IN('S','E','W','R') AND File_Type = 'C' Order by DM_Master_Import_Code desc

		
		
	END
END