CREATE PROCEDURE USP_Validate_Content_Music_Import
@DM_Master_Import_Code INt
AS
BEGIN
--declare @DM_Master_Import_Code INT = 6264
	CREATE TABLE #Temp_Validate
	(
		[Id] INT,
		[DM_Master_Import_Code] INT,
		[Title_Content_Code] INT,
		[Version_Name] NVARCHAR(1000),
		[Music_Track] NVARCHAR(4000),
		[From] VARCHAR(100),
		[To] VARCHAR(100),
		[From_Frame] VARCHAR(500),
		[To_Frame] VARCHAR(500),
		[Duration] VARCHAR(500),
		[Duration_Frame] VARCHAR(500),
		[Excel_Line_No] NVARCHAR(100),
		[Record_Status] VARCHAR(2),
		[Is_Ignore] VARCHAR(1),
		[Error_Tags] NVARCHAR(4000),
		[TotalSec_F] BIGINT,
		[TotalSec_T] BIGINT,
		[DiffSec] BIGINT,
		[TotalSec_D] BIGINT
	)

		INSERT INTO #Temp_Validate([Id], [DM_Master_Import_Code], [Title_Content_Code], [Version_Name], [Music_Track],[From], [To], [From_Frame], [To_Frame],[Duration],
			[Duration_Frame],[Excel_Line_No],[Record_Status],[Is_Ignore],[Error_Tags],[TotalSec_F],	[TotalSec_T],[DiffSec], [TotalSec_D] )
		SELECT  [IntCode], [DM_Master_Import_Code], [Title_Content_Code], [Version_Name], [Music_Track], [From], [To],[From_Frame], [To_Frame], [Duration],
		 [Duration_Frame], [Excel_Line_No], [Record_Status], [Is_Ignore], [Error_Tags], 0, 0,0, 0
		From DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code and Is_Ignore = 'N'

	SET NOCOUNT ON;		
	DECLARE @frameLimit INT = 0
	SELECT @frameLimit = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'FrameLimit'
	
		UPDATE TV SET  TV.Record_Status = 'OR',TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') + 'IVFF~' 
		FROM #Temp_Validate TV
		WHERE  ISNUMERIC(TV.[From_Frame]) = 0 AND ISNUll(TV.[From_Frame], '') <> '' AND TV.DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE TV SET  TV.Record_Status = 'OR',TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') + 'IVTF~' 
		FROM #Temp_Validate TV
		WHERE  ISNUMERIC(TV.[To_Frame]) = 0 AND ISNUll(TV.[To_Frame], '') <> '' AND TV.DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE TV SET  TV.Record_Status = 'OR',TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') + 'IVDF~' 
		FROM  #Temp_Validate TV
		WHERE  ISNUMERIC(TV.[Duration_Frame]) = 0 AND ISNUll(TV.[Duration_Frame], '') <> '' AND TV.DM_Master_Import_Code = @DM_Master_Import_Code
	
		UPDATE TV SET TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +   'IVFF~'
		FROM #Temp_Validate TV where TV.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.[From_Frame]= '00'

		UPDATE TV SET TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +   'IVTF~'
		FROM #Temp_Validate TV where TV.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.[To_Frame]= '00'

		UPDATE TV SET TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +   'IVTI~'
		FROM #Temp_Validate TV where TV.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.[From]= '00:00:00'

		UPDATE TV SET TV.TotalSec_F = ((HH * 3600) + (MM * 60) + SS)
		FROM  #Temp_Validate TV
		INNER JOIN (SELECT TV.Id AS ID,(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[From], ':') AS A WHERE A.id=1) AS HH,
		(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[From], ':') AS A WHERE A.id=2) AS MM ,
		(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[From], ':') AS A WHERE A.id=3) AS SS
		FROM #Temp_Validate TV) AS A
		ON TV.Id = A.ID
		WHERE TV.DM_Master_Import_Code = @DM_Master_Import_Code
	
		UPDATE TV SET TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +   'IVTO~'
		FROM #Temp_Validate TV where TV.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.[To] = '00:00:00'
	
		UPDATE TV SET TV.TotalSec_T = ((HH * 3600) + (MM * 60) + SS)
		FROM  #Temp_Validate TV
		INNER JOIN (SELECT TV.Id AS ID,(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[To], ':') AS A WHERE A.id=1) AS HH,
		(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[To], ':') AS A WHERE A.id=2) AS MM ,
		(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[To], ':') AS A WHERE A.id=3) AS SS
		FROM #Temp_Validate TV) AS A
		ON TV.Id = A.ID
		WHERE TV.DM_Master_Import_Code = @DM_Master_Import_Code

		
		UPDATE TV SET TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +   'IVDU~'
		FROM #Temp_Validate TV where TV.DM_Master_Import_Code = @DM_Master_Import_Code 
		 AND (
				TV.[Duration] = '00:00:00' AND ((TV.[From] = '00:00:00' OR TV.[To] = '00:00:00') OR (TV.[From] = '' OR TV.[To] = ''))
			)	
	
		UPDATE TV SET TV.TotalSec_D = ((HH * 3600) + (MM * 60) + SS)
		FROM  #Temp_Validate TV
		INNER JOIN (SELECT TV.Id AS ID,(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[Duration], ':') AS A WHERE A.id=1) AS HH,
		(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[Duration], ':') AS A WHERE A.id=2) AS MM ,
		(SELECT number FROM dbo.fn_Split_withdelemiter(TV.[Duration], ':') AS A WHERE A.id=3) AS SS
		FROM #Temp_Validate TV) AS A
		ON TV.Id = A.ID
		WHERE TV.DM_Master_Import_Code = @DM_Master_Import_Code
	
	IF EXISTS (SELECT  [From],[To],[Duration] FROM  #Temp_Validate WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([From])),'') = '' AND ISNULL(RTRIM(LTRIM([To])),'') = '' AND ISNULL(RTRIM(LTRIM(Duration)),'') = '') 
	BEGIN
		UPDATE TV SET Tv.Record_Status = 'OR', TV.[Error_Tags] = ISNULL(TV.[Error_Tags], '') +  
		CASE WHEN (TotalSec_F = 0 AND TotalSec_T =0 AND TotalSec_D = 0) OR (TotalSec_F != 0 AND TotalSec_T = 0) OR (TotalSec_F != 0 AND TotalSec_T = 0)  
		THEN 'TITODCB~' ELSE ''  END
		FROM #Temp_Validate TV
		where TV.DM_Master_Import_Code = @DM_Master_Import_Code
	END

	
		IF EXISTS (select Duration_Frame from #Temp_Validate where DM_Master_Import_Code = @DM_Master_Import_Code AND ISNUMERIC([Duration_Frame]) = 1 )
		BEGIN
			UPDATE TV Set TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +  'DFGT' + CAST((@frameLimit - 1) AS VARCHAR) + '~'
			FROM #Temp_Validate TV
			Where Tv.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.Duration_Frame > @frameLimit AND  ISNUMERIC(TV.[Duration_Frame]) = 1 
		END

		IF EXISTS (select From_Frame from #Temp_Validate where DM_Master_Import_Code = @DM_Master_Import_Code  AND ISNUMERIC([From_Frame]) = 1 )
		BEGIN
			UPDATE TV Set TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +  'FFGT' + CAST((@frameLimit - 1) AS VARCHAR) + '~'
			FROM #Temp_Validate TV
			Where Tv.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.From_Frame > @frameLimit AND ISNUMERIC(TV.[From_Frame]) = 1 
		END

	IF EXISTS (select To_Frame from #Temp_Validate where DM_Master_Import_Code = @DM_Master_Import_Code AND ISNUMERIC([To_Frame]) = 1 )
		BEGIN
			UPDATE TV Set TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +  'TFGT' + CAST((@frameLimit - 1) AS VARCHAR) + '~'
			FROM #Temp_Validate TV
			Where Tv.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.To_Frame > @frameLimit AND ISNUMERIC(TV.[To_Frame]) = 1 
		END
	
	--IF EXISTS (SELECT [From_Frame], [To_Frame] From #Temp_Validate WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND   ISNUMERIC([From_Frame]) != 0 AND ISNUMERIC([To_Frame]) != 0)
	--BEGIN
	--IF EXISTS (select  [From_Frame],[To_Frame] from #Temp_Validate where DM_Master_Import_Code = @DM_Master_Import_Code AND To_Frame>= @frameLimit AND Duration_Frame > @frameLimit)
	--BEGIN
	--	UPDATE TV Set TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +  'FFTFGT' + CAST((@frameLimit - 1) AS VARCHAR) + '~'
	--	FROM #Temp_Validate TV
	--	Where Tv.DM_Master_Import_Code = @DM_Master_Import_Code  AND TV.To_Frame>= @frameLimit AND TV.Duration_Frame > @frameLimit
	--END
	--END

	IF EXISTS (SELECT  [From], [To] FROM #Temp_Validate WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND TotalSec_T < TotalSec_F)
	BEGIN
		UPDATE TV Set TV.Record_Status = 'OR', TV.[Error_Tags] =  ISNULL(TV.[Error_Tags], '') +  'TOCLTTI~'
		FROM #Temp_Validate TV
		Where Tv.DM_Master_Import_Code = @DM_Master_Import_Code AND Tv.TotalSec_T < TotalSec_F 
	END

	UPDATE DCM SET DCM.Record_Status = TV.Record_Status , DCM.Error_Tags = TV.Error_Tags
	FROM DM_Content_Music DCM
	INNER JOIN #Temp_Validate TV ON TV.Id = DCM.IntCode
	WHERE DCM.DM_Master_Import_Code = @DM_Master_Import_Code AND TV.Error_Tags != ''
		
	IF EXISTS (SELECT Record_Status FROM DM_Content_Music where Record_Status = 'OR' AND DM_Master_Import_Code = @DM_Master_Import_Code)
	BEGIN
		UPDATE DM_Master_Import SET Status = 'R' where DM_Master_Import_Code = @DM_Master_Import_Code
		--EXEC USP_Content_Music_PIV @DM_Master_Import_Code  
	END
	else
	BEGIN
		UPDATE DM_Master_Import SET Status = 'N' where DM_Master_Import_Code = @DM_Master_Import_Code
	END
	drop table #Temp_Validate
END


