CREATE PROCEDURE [dbo].[USP_Content_Music_Link_Bulk_Insert_UDT]
(
	@Content_Music_Link_UDT Content_Music_Link_UDT READONLY,
	@UserCode INT
)
AS
-- =============================================
-- Author:  Sagar Mahajan / Abhaysingh N. Rajpurohit
-- Create date: 21 October 2016
-- Description: This usp call from Title_Content_ImportExportController  and Insert into Content_Music_Link_UDT
-- Last updated by akshay rane
-- =============================================
BEGIN
	SET NOCOUNT ON;
	--DECLARE @Content_Music_Link_UDT Content_Music_Link_UDT, @UserCode INT = 143
	--INSERT INTO @Content_Music_Link_UDT(
	--	Title_Content_Code,[From],From_Frame ,[To],To_Frame,Music_Track, [Duration], [Duration_Frame]
	--)
	--VALUES
	--('XX','00:02:30','0','00:04:30','0','Pal pal hai bhari', '', '0'),
	--('19','XXX:XXXXXX:XXX','0','00:05:30','0','Pal pal hai bhari', '', '0'),
	--('20','00:06:30','AXD','00:08:30','0','Pal pal hai bhari', '', '0'),
	--('18','00:02:30','0','sasaeqe','0','Pal pal hai bhari', '', '0'),
	--('19','00:04:30','0','00:05:30','qwq','Pal pal hai bhari', '', '0'),
	--('20','00:06:30','0','00:08:30','0','dhdiuys', '', ''),
	--('18','00:02:30','0','00:04:30','0','Pal pal hai bhari', 'sasqw1w', '0'),
	--('19','00:04:30','0','00:05:30','qwq','Pal pal hai bhari', '', '15sas'),
	--('89889','00:06:30','0','00:08:30','0','Pal pal hai bhari', '', '')

	IF(OBJECT_ID('TEMPDB..#TempErrorDetails') IS NOT NULL)
		DROP TABLE #TempErrorDetails

	CREATE TABLE #TempErrorDetails
	(
		[Row_No] INT,
		[Content_Name] NVARCHAR(2000),
		[Episode_No] INT,
		[Music_Track] NVARCHAR(2000),
		[TC_IN] VARCHAR(MAX),
		[TC_OUT] VARCHAR(MAX),
		[From_Frame] VARCHAR(MAX),
		[To_Frame] VARCHAR(MAX),
		[Duration] VARCHAR(MAX), 
		[Duration_Frame] VARCHAR(MAX),
		[Version_Name] NVARCHAR(2000),
		[Error_Message] NVARCHAR(MAX)
	)

	IF(OBJECT_ID('TEMPDB..#TempWithoutDistinct') IS NOT NULL)
		DROP TABLE #TempWithoutDistinct

	IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)
		DROP TABLE #Temp

	IF(OBJECT_ID('TEMPDB..#TempContentStatusHistory') IS NOT NULL)
		DROP TABLE #TempContentStatusHistory


	CREATE TABLE #TempWithoutDistinct
	(
		RowNo INT IDENTITY(1,1),
		Title_Content_Code VARCHAR(MAX) NULL,
		[From] VARCHAR(MAX) NULL,--TC In
		From_Frame VARCHAR(MAX) NULL,
		[To] VARCHAR(MAX) NULL, -- --TC Out
		To_Frame VARCHAR(MAX) NULL,
		Duration VARCHAR(MAX) NULL, --Diff b/w TC In and TC Out
		Duration_Frame VARCHAR(MAX) NULL,
		Music_Title_Code INT NULL,
		Music_Track NVARCHAR(MAX),
		[Version_Name] NVARCHAR(MAX),
	)

	CREATE TABLE #Temp
	(
		RowNo INT,
		Title_Content_Code VARCHAR(MAX) NULL,
		Content_Name NVARCHAR(2000),
		Episode_No INT,
		[From] VARCHAR(MAX) NULL,--TC In
		From_Frame VARCHAR(MAX) NULL,
		[To] VARCHAR(MAX) NULL, -- --TC Out
		To_Frame VARCHAR(MAX) NULL,
		Duration VARCHAR(MAX) NULL, --Diff b/w TC In and TC Out
		Duration_Frame VARCHAR(MAX) NULL,
		Music_Title_Code INT NULL,
		Music_Track NVARCHAR(MAX),
		Version_Code INT NULL,
		[Version_Name] NVARCHAR(MAX),
		Title_Content_Version_Code INT NULL,
		IsProcessed CHAR(1) DEFAULT('N')
	)

	INSERT INTO #TempWithoutDistinct
	(
		Title_Content_Code,
		[From],
		From_Frame,
		[To],
		To_Frame,
		Duration,
		Duration_Frame,
		Music_Track,
		[Version_Name]
	)
	SELECT Title_Content_Code,[From],From_Frame ,[To],To_Frame,Duration,Duration_Frame,Music_Track, Version_Name
	FROM @Content_Music_Link_UDT

	INSERT INTO #Temp
	(
		RowNo,
		Title_Content_Code,
		[From],
		From_Frame,
		[To],
		To_Frame,
		Duration,
		Duration_Frame,
		Music_Track,
		Version_Name
	)
	SELECT DISTINCT RowNo, Title_Content_Code,[From],From_Frame ,[To],To_Frame,Duration,Duration_Frame,Music_Track, Version_Name
	FROM #TempWithoutDistinct ORDER BY RowNo

	IF EXISTS (SELECT TOP 1 CMLU.Title_Content_Code FROM @Content_Music_Link_UDT CMLU)
	BEGIN
		/* Update Music Title Code */
		UPDATE T SET T.Music_Title_Code = MT.Music_Title_Code, T.Music_Track = MT.Music_Title_Name FROM #Temp T
		INNER JOIN Music_Title MT ON UPPER(RTRIM(LTRIM(T.Music_Track)))
		COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(RTRIM(LTRIM(REPLACE(MT.Music_Title_Name,' ',' ')))) COLLATE SQL_Latin1_General_CP1_CI_AS

		/* Update Version Code */
		UPDATE T SET T.Version_Code = V.Version_Code, T.Version_Name = V.Version_Name FROM #Temp T
		INNER JOIN [Version] V ON UPPER(RTRIM(LTRIM(T.Version_Name)))
		COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(RTRIM(LTRIM(V.Version_Name))) COLLATE SQL_Latin1_General_CP1_CI_AS 
			AND LTRIM(RTRIM(T.Version_Name)) != '' 

		/* Update Content Name */
		UPDATE TMP SET TMP.Content_Name = CASE WHEN ISNULL(TC.Episode_Title, '') = '' THEN T.Title_Name ELSE TC.Episode_Title END,
		TMP.Episode_No = TC.Episode_No FROM #Temp TMP
		INNER JOIN Title_Content TC ON CAST(TC.Title_Content_Code AS VARCHAR) COLLATE SQL_Latin1_General_CP1_CI_AS = 
		CAST(RTRIM(LTRIM(TMP.Title_Content_Code)) AS VARCHAR) COLLATE SQL_Latin1_General_CP1_CI_AS
		INNER JOIN Title T ON T.Title_Code = TC.Title_Code
	END

	DECLARE @RowNo INT = 0, @frameLimit INT = 0, @status VARCHAR(2) = '', @RowCounter INT = 0
	SELECT @frameLimit = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'FrameLimit'
	SELECT TOP 1 @RowNo = RowNo FROM #Temp WHERE IsProcessed = 'N'

	WHILE(@RowNo > 0)
	BEGIN
		SET @RowCounter =(@RowCounter + 1)
		DECLARE @errorMessage NVARCHAR(MAX) = '', @isErrorInRow CHAR(1) = 'N'

		DECLARE	@strTC_Code VARCHAR(MAX) = '',  @TC_Code INT = 0, @MusicTrackCode INT = 0, @versionCode INT = 0, @titleContentVersionCode INT = 0,
		@from VARCHAR(8) = '00:00:00', @to VARCHAR(8) = '00:00:00', @duration VARCHAR(8) = '00:00:00', 
		@fromFrame INT = 0, @toFrame INT = 0, @durationFrame INT = 0, @durationTime  VARCHAR(8) = '00:00:00',
		@strFromFrame VARCHAR(MAX) = '', @strToFrame VARCHAR(MAX) = '', @strDurationFrame VARCHAR(MAX) = ''

		--SELECT @TC_Code = Title_Content_Code, @MusicTrackCode = ISNULL(Music_Title_Code, 0),
		--@from = CAST([From] AS VARCHAR), @to = CAST([To] AS VARCHAR), @durationTime = CAST([Duration] AS VARCHAR),
		--@strFromFrame = CAST([From_Frame] AS INT), @strToFrame = CAST([To_Frame] AS VARCHAR), @strDurationFrame = CAST([To_Frame] AS VARCHAR)
		--FROM #Temp WHERE IsProcessed = 'N' AND RowNo = @RowNo

		SELECT @strTC_Code = Title_Content_Code, @MusicTrackCode = ISNULL(Music_Title_Code, 0), @versionCode = ISNULL(Version_Code, 0), 
		@from = CAST([From] AS VARCHAR), @to = CAST([To] AS VARCHAR), @durationTime = CAST([Duration] AS VARCHAR),
		@strFromFrame = CAST([From_Frame] AS VARCHAR), @strToFrame = CAST([To_Frame] AS VARCHAR), @strDurationFrame = CAST([Duration_Frame] AS VARCHAR)
		FROM #Temp WHERE IsProcessed = 'N' AND RowNo = @RowNo

		BEGIN TRY
			SET @TC_Code = CAST(@strTC_Code AS INT)
			IF(@TC_Code <= 0 OR (NOT EXISTS (SELECT * FROM Title_Content WHERE Title_Content_Code = @TC_Code)))
			BEGIN
				PRINT 'Invalid Content Code'
				SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid Content Code^'
			END
		END TRY  
		BEGIN CATCH  
			SET @TC_Code = 0
			PRINT 'Invalid Content Code'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid Content Code^'
		END CATCH

		IF(@versionCode = 0 )
		BEGIN
			PRINT 'Invalid Version'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid Version^'
		END
		ELSE IF(@TC_Code > 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM Title_Content_Version WHERE Title_Content_Code = @TC_Code AND Version_Code = @versionCode)
			BEGIN
				INSERT INTO Title_Content_Version(Title_Content_Code, Version_Code, Duration)
				SELECT Title_Content_Code, @versionCode, Duration  FROM Title_Content WHERE Title_Content_Code = @TC_Code
			END

			SELECT TOP 1 @titleContentVersionCode = Title_Content_Version_Code FROM Title_Content_Version WHERE Title_Content_Code = @TC_Code AND Version_Code = @versionCode

			UPDATE #Temp SET Title_Content_Version_Code = @titleContentVersionCode WHERE RowNo = @RowNo AND IsProcessed = 'N'
		END

		BEGIN TRY
			IF(@strFromFrame <> '')
			BEGIN
				SET @fromFrame = CAST(@strFromFrame AS INT)
			END
		END TRY  
		BEGIN CATCH  
			PRINT 'Invalid From Frame'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid From Frame^'
		END CATCH

		BEGIN TRY
			IF(@strToFrame <> '')
			BEGIN
				SET @toFrame = CAST(@strToFrame AS INT)
			END
		END TRY  
		BEGIN CATCH  
			PRINT 'Invalid To Frame'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid To Frame^'
		END CATCH

		BEGIN TRY
			IF(@strDurationFrame <> '')
			BEGIN
				SET @durationFrame = CAST(@strDurationFrame AS INT)
			END
		END TRY  
		BEGIN CATCH  
			PRINT 'Invalid Duration Frame'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid Duration Frame^'
		END CATCH

		/* START : Duration Calculation */
		DECLARE @hh INT = 0, @mm INT = 0, @ss INT = 0, @totalSec_F BIGINT = 0, @totalSec_T BIGINT = 0, @diffSec BIGINT = 0 , @totalSec_D BIGINT = 0
		BEGIN TRY  
			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@from, ':') where id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@from, ':') where id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@from, ':') where id = 3
			IF((@hh not between 0 and 23) OR (@mm not between 0 and 59) OR (@ss not between 0 and 59))
			BEGIN
				PRINT 'Invalid TC IN'
				SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid TC IN^'
			END
			SET @totalSec_F = ((@hh * 3600) + (@mm * 60) + @ss)
		END TRY  
		BEGIN CATCH  
			PRINT 'Invalid TC IN'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid TC IN^'
		END CATCH

		SELECT @hh = 0, @mm = 0, @ss = 0
		BEGIN TRY  
			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@to, ':') where id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@to, ':') where id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@to, ':') where id = 3
			IF((@hh not between 0 and 23) OR (@mm not between 0 and 59) OR (@ss not between 0 and 59))
			BEGIN
				PRINT 'Invalid TC OUT'
				SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid TC OUT^'
			END
			SET @totalSec_T = ((@hh * 3600) + (@mm * 60) + @ss)
		END TRY  
		BEGIN CATCH  
			PRINT 'Invalid TC OUT'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid TC OUT^'
		END CATCH

		SELECT @hh = 0, @mm = 0, @ss = 0
		BEGIN TRY  
			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@durationTime, ':') where id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@durationTime, ':') where id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@durationTime, ':') where id = 3
			IF((@hh NOT BETWEEN 0 AND 23) OR (@mm NOT BETWEEN 0 AND 59) OR (@ss NOT BETWEEN 0 AND 59))
			BEGIN
				PRINT 'Invalid Duration'
				SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid Duration^'
			END
			SET @totalSec_D = ((@hh * 3600) + (@mm * 60) + @ss)
		END TRY  
		BEGIN CATCH  
			PRINT 'Invalid Duration'
			SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage + 'Invalid Duration^'
		END CATCH

		IF(@status != 'X')
		BEGIN
			SET @diffSec = (@totalSec_T - @totalSec_F)

			IF(
				(@totalSec_F = 0 AND @totalSec_T = 0 AND @totalSec_D = 0) OR
				(@totalSec_F != 0 AND @totalSec_T = 0) OR 
				(@totalSec_F = 0 AND @totalSec_T != 0)
			)
			BEGIN
				PRINT 'Either TC IN, TC OUT or Duration cannot be zero'
				SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage +'Either TC IN, TC OUT or Duration cannot be zero^'
			END
			ELSE IF(@totalSec_F = 0 AND @totalSec_T = 0 AND @totalSec_D != 0)
			BEGIN
				IF(@durationFrame >= @frameLimit )
				BEGIN
					PRINT 'Duration frame cannot be greater than ' + CAST((@frameLimit - 1) AS VARCHAR)
					SELECT @status = 'X', @isErrorInRow = 'Y', 
					@errorMessage = @errorMessage + 'Duration frame cannot be greater than ' + CAST((@frameLimit - 1) AS VARCHAR) + '^'
				END
				ELSE
				BEGIN
					IF (@status <> 'X')
						SET @status = 'CD'
				END
			END

			IF(@totalSec_F != 0 AND @totalSec_T != 0)
			BEGIN
				IF(@totalSec_T > @totalSec_F)
				BEGIN
					IF(@toFrame >= @frameLimit OR @fromFrame >= @frameLimit)
					BEGIN
						PRINT 'From-Frame or To-Frame cannot be greater than' + CAST((@frameLimit - 1) AS VARCHAR)
						SELECT @status = 'X', @isErrorInRow = 'Y', 
						@errorMessage = @errorMessage +' From-Frame or To-Frame cannot be greater than ' + CAST((@frameLimit - 1) AS VARCHAR) + '^'
					END
					ELSE
					BEGIN
						IF (@status <> 'X')
							SET @status = 'CT'
					END
				END
				ELSE
				BEGIN
					PRINT 'TC OUT cannot be less than TC IN'
					SELECT @status = 'X', @isErrorInRow = 'Y', @errorMessage = @errorMessage +'TC OUT cannot be less than TC IN^'
				END
			END
		END

		IF(@MusicTrackCode = 0)
		BEGIN
			PRINT 'Could Not Find Music Track'
			SELECT @status = 'X', @isErrorInRow = 'Y', 
			@errorMessage = @errorMessage +'Could Not Find Music Track^'
		END

		IF(@status = 'CT')
		BEGIN
			IF(@toFrame < @fromFrame)
			BEGIN
				SET @diffSec = (@diffSec - 1)
				SET @durationFrame = (@frameLimit - @fromFrame)
				SET @durationFrame = (@durationFrame + @toFrame)
			END
			ELSE
				SET @durationFrame = (@toFrame - @fromFrame)

			SELECT @hh = 0, @mm = 0, @ss = 0
			IF(@diffSec > 0)
			BEGIN
				SET @ss= @diffSec
				IF(@ss >= 3600)
				BEGIN
					SET @hh = (@ss / 3600)
					set @ss = (@ss - (@hh * 3600))
				END

				IF(@ss >= 60)
				BEGIN
					SET @mm = (@ss / 60)
					set @ss= (@ss- (@mm * 60))
				END

				SET @duration = (RIGHT('00' + CAST(@hh AS VARCHAR), 2)  + ':' + RIGHT('00' + CAST(@mm AS VARCHAR), 2) + ':' + RIGHT('00' + CAST(@ss AS VARCHAR), 2))
			END
			ELSE
			BEGIN
				SELECT @duration = '00:00:00', @durationFrame = 0
				SET @durationFrame = (@toFrame - @fromFrame)
				IF(@durationFrame < 0)
					SET @durationFrame = 0
			END
			UPDATE #Temp SET Duration = @duration, Duration_Frame = @durationFrame WHERE RowNo = @RowNo
			/* END : Duration Calculation */
		END
		ELSE IF(@isErrorInRow = 'Y')
		BEGIN
			INSERT INTO #TempErrorDetails(
				[Row_No], [Content_Name], [Episode_No], [Music_Track], [TC_IN], [TC_OUT],
				[From_Frame], [To_Frame], [Duration], [Duration_Frame], [Version_Name], [Error_Message]
			)
			SELECT @RowCounter, T.[Content_Name], T.[Episode_No], T.[Music_Track], T.[From], T.[To],
				T.[From_Frame], T.[To_Frame], T.[Duration], T.[Duration_Frame], T.[Version_Name], @errorMessage 
			FROM #Temp T WHERE IsProcessed = 'N' AND RowNo = @RowNo
		END

		UPDATE #Temp SET IsProcessed  = 'Y' WHERE IsProcessed = 'N' AND RowNo = @RowNo
		SELECT @RowNo = 0, @from = '', @to = '', @fromFrame = '', @toFrame = '', @MusicTrackCode = 0
		SELECT TOP 1 @RowNo = RowNo FROM #Temp WHERE IsProcessed = 'N'
	END


	IF(@status != 'X')
	BEGIN
		IF EXISTS (SELECT * FROM #Temp WHERE ISNULL(Music_Title_Code, 0) > 0)
		BEGIN
			INSERT INTO Content_Music_Link (Title_Content_Code, Title_Content_Version_Code, [From],From_Frame,[To],To_Frame,Duration,Duration_Frame,Music_Title_Code,
				Inserted_On, Inserted_By, Last_UpDated_Time, Last_Action_By)
			SELECT DISTINCT Title_Content_Code, Title_Content_Version_Code, [From], From_Frame, [To], To_Frame, Duration, Duration_Frame, Music_Title_Code,
				GETDATE(), @UserCode, GETDATE(), @UserCode
			FROM #Temp WHERE ISNULL(Music_Title_Code, 0) > 0

			SELECT Title_Content_Code, COUNT(*) AS RecordCount INTO #TempContentStatusHistory FROM (
				SELECT DISTINCT * FROM #Temp 
			) AS TMP
			GROUP BY Title_Content_Code

			INSERT INTO Content_Status_History(Title_Content_Code, User_Code, User_Action, Record_Count, Created_On)
			SELECT Title_Content_Code, @UserCode, 'B', RecordCount, GETDATE() FROM #TempContentStatusHistory
		END
	END
	
	SELECT [Row_No], [Content_Name], [Episode_No], [Music_Track], [TC_IN], [TC_OUT],[From_Frame], [To_Frame], [Duration], [Duration_Frame], Version_Name, [Error_Message]
	FROM #TempErrorDetails
END