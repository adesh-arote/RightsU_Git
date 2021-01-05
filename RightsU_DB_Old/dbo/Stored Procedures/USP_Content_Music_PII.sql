CREATE PROCEDURE [dbo].[USP_Content_Music_PII]
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code INT
AS
BEGIN
	--DECLARE @DM_Master_Import_Code INT = 6171
	--DECLARE @DM_Import_UDT DM_Import_UDT, @UserCode INT = 143
	--INSERT INTO @DM_Import_UDT(
	--	[Key],[value], [DM_Master_Type]
	--)
	--VALUES
	--(6955,5062,'CM')
	--INSERT INTO @DM_Import_UDT(
	--	[Key],[value], [DM_Master_Type]
	--)
	--VALUES
	--(6941,'3842','CM')

	SET NOCOUNT ON;
	
	CREATE TABLE #Temp_DM
	(
		Master_Name NVARCHAR(2000),
		DM_Master_Log_Code BIGINT,
		DM_Master_Code NVARCHAR (100),
		Master_Type NVARCHAR (100)
	)

	INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type)
	SELECT [Name], [Key], [value], [DM_Master_Type] FROM @DM_Import_UDT udt
	Inner Join DM_Master_Log dm on dm.DM_Master_Log_Code = udt.[Key]


	UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'

	
	

	UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'



	UPDATE D SET D.Is_Ignore ='Y', D.Record_Status = 'N'
	FROM DM_Content_Music D
	INNER JOIN #Temp_DM T ON T.Master_Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code
	WHERE T.DM_Master_Code = 'Y'

	
	UPDATE D SET D.Record_Status =  Case When D.Record_Status IN('MO','SO') THEn 'OR' Else 'N'END
	FROM DM_Content_Music D
	INNER JOIN #Temp_DM T ON T.Master_Name   collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND T.DM_Master_Code != 'Y' OR D.Record_Status = 'SM'
	
	UPDATE D SET D.Record_Status =  Case When D.Record_Status IN('MO','SO') THEn 'OR'Else 'N'END
	FROM DM_Content_Music D
	INNER JOIN #Temp_DM T ON T.Master_Name   collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND T.DM_Master_Code = 'Y'


	DROP TABLE #Temp_DM
	DECLARE @Count  Int , @TotalCount INT
	SELECT @Count = COUNT(*) FROM DM_Content_Music WHERE Record_Status  IN('N','SM')
		 AND DM_Master_Import_Code = @DM_Master_Import_Code
	SELECT @TotalCount = COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code
	IF(@Count = @TotalCount)
	BEGIN
	UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
	END

	--EXEC [USP_Content_Music_PIV] @DM_Master_Import_Code

	-- DECLARE @COUNT INT , @TotalCount INT


	--  SELECT @COUNT = COUNT(*) FROM DM_Content_Music WHERE Is_Ignore = 'N' AND (Record_Status = 'N' OR Record_Status = 'SM')
	--	 AND DM_Master_Import_Code = @DM_Master_Import_Code
	--	select  @TotalCount = COUNT(*) FROM DM_Content_Music WHERE Is_Ignore = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code

	--  IF( @COUNT > 0 AND @COUNT = @TotalCount)
	--   --IF (@COUNT > 0)   
	--   BEGIN
	--  	EXEC [USP_Content_Music_PIII] @DM_Master_Import_Code
	--   END
	--   ELSE
	--   BEGIN
	--	 DECLARE @StatusCount INT
	--	 SELECT @StatusCount = COUNT(*) FROM DM_Content_Music WHERE (Record_Status = 'MR' OR Record_Status = 'OR' OR Record_Status = 'MO' OR Record_Status = 'SO' ) AND IS_Ignore = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
		
	--	 IF(@StatusCount > 0)
	--	 BEGIN
	--	 	   UPDATE DM_Master_Import SET Status = 'R' where DM_Master_Import_Code = @DM_Master_Import_Code  
	--	 END
	--	 ELSE
	--	 BEGIN
	--	 	   UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code  
	--	 END
	--   END

	--IF((SELECT [Status] From DM_Master_Import Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P')
	--BEGIN
	--	EXEC [USP_Content_Music_PIII] @DM_Master_Import_Code
	--END

END


