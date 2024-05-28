CREATE PROCEDURE [dbo].[USPMHCueSheetValidation]    
AS  
-- =============================================
-- Author:  Akshay Rane
-- Create date: 22 June 2018
-- Description: 
-- =============================================
BEGIN  
	SET NOCOUNT ON
	IF(OBJECT_ID('TEMPDB..#temp_MHCueSheet') IS NOT NULL)
		DROP TABLE #temp_MHCueSheet

	IF(OBJECT_ID('TEMPDB..#Temp_MHCueSheetSong') IS NOT NULL)
		DROP TABLE #Temp_MHCueSheetSong

	IF(OBJECT_ID('TEMPDB..#TempTitleContent') IS NOT NULL)
		DROP TABLE #TempTitleContent

	IF(OBJECT_ID('TEMPDB..#Temp_Title_Content_Version') IS NOT NULL)
		DROP TABLE #Temp_Title_Content_Version

	CREATE TABLE #temp_MHCueSheet (
		RowNo_MH			 INT IDENTITY(1,1),
		[MHCueSheetCode]     INT            NOT NULL,
		[RequestID]          NVARCHAR (20)  NULL,
		[FileName]           NVARCHAR (400) NULL,
		[UploadStatus]       CHAR (1)       NULL,
		[VendorCode]         INT            NULL,
		[TotalRecords]       INT            NULL,
		[ErrorRecords]       INT            NULL,
		[CreatedBy]          INT            NULL,
		[CreatedOn]          DATETIME       NULL,
		[ApprovedBy]         INT            NULL,
		[ApprovedOn]         DATETIME       NULL,
		[SpecialInstruction] NVARCHAR (MAX) NULL,
		IsProcessed_MH		 CHAR(1) DEFAULT('N')
	);

	CREATE TABLE #Temp_MHCueSheetSong (
		RowNo_Song			 INT IDENTITY(1,1),
		[MHCueSheetSongCode] BIGINT         NOT NULL,
		[MHCueSheetCode]     INT            NULL,
		[TitleName]          NVARCHAR (400) NULL,
		[EpisodeNo]          INT            NULL,
		[MusicTrackName]     NVARCHAR (400) NULL,
		[FromTime]           TIME (7)       NULL,
		[FromFrame]          INT            NULL,
		[ToTime]             TIME (7)       NULL,
		[ToFrame]            INT            NULL,
		[DurationTime]       TIME (7)       NULL,
		[DurationFrame]      INT            NULL,
		[ExcelLineNo]        INT            NULL,
		[RecordStatus]       CHAR (1)       NULL,
		[ErrorMessage]       VARCHAR (4000) NULL,
		[TitleCode]          INT            NULL,
		[TitleContentCode]   INT            NULL,
		[MusicTitleCode]     INT            NULL,
		[IsApprove]          CHAR (1)       NULL,
		IsProcessed_Song	 CHAR(1) DEFAULT('N'),
		[TotalSec_F]		 BIGINT  DEFAULT(0),
		[TotalSec_T]		 BIGINT  DEFAULT(0),
		[DiffSec]			 BIGINT  DEFAULT(0),
		[TotalSec_D]		 BIGINT  DEFAULT(0)
	);

	CREATE TABLE #TempTitleContent(
		Title_Content_Code	INT,
		Title_Code			INT,
		Episode_No			INT 
	);

	CREATE TABLE #Temp_Title_Content_Version(
		Title_Content_Code			INT,
		Title_Content_Version_Code	INT
	);
	BEGIN TRY
	BEGIN TRANSACTION

		PRINT '********************************* PHASE 1 **************************************'
		INSERT INTO #temp_MHCueSheet (
		[MHCueSheetCode],[RequestID] ,[FileName],[UploadStatus],[VendorCode] ,[TotalRecords],[ErrorRecords] ,[CreatedBy],[CreatedOn] ,[ApprovedBy] ,[ApprovedOn] )
		SELECT [MHCueSheetCode],[RequestID] ,[FileName],[UploadStatus],[VendorCode] ,[TotalRecords],[ErrorRecords] ,[CreatedBy],[CreatedOn] ,[ApprovedBy] ,[ApprovedOn]
		FROM MHCueSheet WHERE [UploadStatus] = 'P'

		PRINT 'Step 1 : Inserting data into #temp_MHCueSheet where [UploadStatus] = P.'

		DECLARE @RowNo_MH INT = 0, @frameLimit INT = 0, @RowCounter_MH INT = 0, @RowNo_Song INT = 0, @MHCueSheetCode INT = 0

		DECLARE @MHCueSheetSongCode INT = 0, @TitleCode INT = 0, @RowCounter_Song INT = 0, @dealTypeCode INT = 0, @Title_Content_Code INT = 0, @Music_Title_Code INT = 0

		SELECT @frameLimit = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'FrameLimit'
		SELECT @dealTypeCode = Deal_Type_Code FROM Deal_Type WHERE Deal_Type_Name = 'Program'
		SELECT TOP 1 @RowNo_MH = RowNo_MH FROM #temp_MHCueSheet WHERE IsProcessed_MH = 'N'

		DECLARE @status VARCHAR(2) = '', @from TIME = '00:00:00.0000', @to TIME = '00:00:00.0000', @duration VARCHAR(MAX) = '00:00:00.0000',
			@fromFrame INT = 0, @toFrame INT = 0, @durationFrame INT = 0, @durationTime TIME = '00:00:00.0000'

		PRINT 'Step 2 : RowNo of #temp_MHCueSheet = ' + CAST(@RowNo_MH AS NVARCHAR(MAX))
	 
		WHILE(@RowNo_MH > 0)
		BEGIN
			PRINT '***********************************************************************'
			SELECT @MHCueSheetCode  = 0 ,  @RowCounter_MH =(@RowCounter_MH + 1)
			SELECT @MHCueSheetCode = MHCueSheetCode FROM #temp_MHCueSheet WHERE IsProcessed_MH = 'N' AND RowNo_MH = @RowNo_MH
			PRINT 'Step 3 : After Entering 1st While Loop.'
			PRINT 'Step 4 : #temp_MHCueSheet ie RowNo = ' +   CAST(@RowNo_MH AS NVARCHAR(MAX)) + ' And MHCueSheetCode = ' +   CAST(@MHCueSheetCode AS NVARCHAR(MAX))

			TRUNCATE TABLE #Temp_MHCueSheetSong

			UPDATE MHCueSheetSong SET FromTime = ISNULL(FromTime,cast('00:00:00.00000' as time)),
									  ToTime = ISNULL(ToTime,cast('00:00:00.00000' as time)),
									  DurationTime = ISNULL(DurationTime,cast('00:00:00.00000' as time)) 
			WHERE MHCueSheetCode = @MHCueSheetCode

			PRINT 'Step 5 : Truncated #Temp_MHCueSheetSong And Updated MHCueSheetSong where FromTime, ToTime, DurationTime is NULL.'

			INSERT INTO #Temp_MHCueSheetSong (
			[MHCueSheetSongCode],[MHCueSheetCode],[TitleName],[EpisodeNo],[MusicTrackName],[FromTime],[FromFrame],[ToTime],[ToFrame],[DurationTime],
			[DurationFrame],[ExcelLineNo],[RecordStatus],[ErrorMessage],[TitleCode],[TitleContentCode],[MusicTitleCode],[IsApprove])
			SELECT [MHCueSheetSongCode],[MHCueSheetCode],[TitleName],[EpisodeNo],[MusicTrackName],[FromTime],[FromFrame],[ToTime],[ToFrame],[DurationTime],
			[DurationFrame],[ExcelLineNo],[RecordStatus],[ErrorMessage],[TitleCode],[TitleContentCode],[MusicTitleCode],[IsApprove] 
			FROM MHCueSheetSong WHERE MHCueSheetCode = @MHCueSheetCode

			PRINT 'Step 6 : Inserted into #Temp_MHCueSheetSong WHERE MHCueSheetCode = '+   CAST(@MHCueSheetCode AS NVARCHAR(MAX))

			SELECT TOP 1 @RowNo_Song = RowNo_Song FROM #Temp_MHCueSheetSong WHERE IsProcessed_Song = 'N'

			PRINT 'Step 7 : RowNo of #Temp_MHCueSheetSong = ' +   CAST(@RowNo_Song AS NVARCHAR(MAX))
			-----------------------------------------------------------------------------------------------------------------
			WHILE(@RowNo_Song > 0)
			BEGIN
				SELECT @MHCueSheetSongCode = 0, @RowCounter_Song =(@RowCounter_Song + 1),  @TitleCode = 0, @Title_Content_Code = 0, @Music_Title_Code = 0
				SELECT @MHCueSheetSongCode = MHCueSheetSongCode FROM #Temp_MHCueSheetSong  WHERE IsProcessed_Song = 'N' AND RowNo_Song = @RowNo_Song
				PRINT '=================================================================='
				PRINT 'Step 8 : After Entering 2nd While Loop.'
				PRINT 'Step 9 : #Temp_MHCueSheetSong ie RowNo = ' +   CAST(@RowNo_Song AS NVARCHAR(MAX)) + ' And MHCueSheetSongCode = ' +   CAST(@MHCueSheetSongCode AS NVARCHAR(MAX))
			
				--*********************************** WARNING STARTS ***********************************
				PRINT 'Step 10 : WARNING Validation Starts.'

				SELECT @TitleCode = Title_Code FROM Title WHERE  Deal_Type_Code = @dealTypeCode AND Title_Name COLLATE DATABASE_DEFAULT = 
				(SELECT TitleName FROM #Temp_MHCueSheetSong WHERE MHCueSheetSongCode = @MHCueSheetSongCode) COLLATE DATABASE_DEFAULT

				SELECT @Music_Title_Code = MT.Music_Title_Code FROM Music_Title MT WHERE MT.Is_Active = 'Y' AND MT.Music_Title_Name COLLATE DATABASE_DEFAULT = 
				(SELECT MusicTrackName FROM #Temp_MHCueSheetSong WHERE MHCueSheetSongCode = @MHCueSheetSongCode) COLLATE DATABASE_DEFAULT

				PRINT 'Step 11 : Validating Title Name and Music Title Name'
				PRINT 'Step 12 : @TitleCode = ' +   CAST(@TitleCode AS NVARCHAR(MAX)) + ' @Music_Title_Code ' + CAST(@Music_Title_Code AS NVARCHAR(MAX))

				IF (@TitleCode > 0)
				BEGIN
				
					TRUNCATE TABLE #TempTitleContent

					INSERT INTO #TempTitleContent (Title_Content_Code, Title_Code, Episode_No)
					SELECT Title_Content_Code, Title_Code, Episode_No FROM Title_Content WHERE Title_Code = @TitleCode

					PRINT 'Step 12 A : Inserted into #TempTitleContent WHERE Title_Code = ' +   CAST(@TitleCode AS NVARCHAR(MAX))

					SELECT @Title_Content_Code = TTC.Title_Content_Code FROM #TempTitleContent TTC WHERE 
					TTC.Episode_No = (SELECT A.EpisodeNo FROM #Temp_MHCueSheetSong A WHERE MHCueSheetSongCode = @MHCueSheetSongCode)

					PRINT 'Step 12 A : Fetching  @Title_Content_Code =  ' +   CAST(@Title_Content_Code AS NVARCHAR(MAX)) + 'Where Episode No Matches' 

					UPDATE TV SET TitleCode = @TitleCode 
					FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV 
					WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
				END
				ELSE
				BEGIN	
					IF EXISTS (SELECT * FROM MHCueSheetSong TV WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode AND ISNULL(TV.TitleName, '') = '')
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHSNB~' --Music Hub Shown Name is Blank
						FROM MHCueSheetSong TV 
						WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode AND ISNULL(TV.TitleName, '') = ''
					ELSE
						UPDATE TV SET  TV.RecordStatus = 'W', TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '~') + 'MHSNNF~' -- Music Hub Show Name Not Found
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV 
						WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode

					PRINT 'Step 12 B : Updating error which is Music Hub Show Name Not Found' 
				END

				IF (@Title_Content_Code > 0)
				BEGIN
					UPDATE TV SET TV.TitleContentCode = @Title_Content_Code 
					FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
					WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT * FROM MHCueSheetSong TV WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode AND ISNULL(TV.EpisodeNo, '') = '')
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHENB~' --Music Hub Episode Number is Blank
						FROM MHCueSheetSong TV 
						WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode AND ISNULL(TV.EpisodeNo , '') = ''
					ELSE
						UPDATE TV SET  TV.RecordStatus = 'W', TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '~') + 'MHENIV~' -- Music Hub Episode No Is Invalid
						FROM MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					PRINT 'Step 12 C : Updating error which is Music Hub Episode No Is Invalid' 
				END

				IF (@Music_Title_Code > 0)
				BEGIN
					UPDATE TV SET TV.MusicTitleCode = @Music_Title_Code 
					FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV 
					WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
				END
				ELSE
				BEGIN 
					IF EXISTS (SELECT * FROM MHCueSheetSong TV WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode AND ISNULL(TV.MusicTrackName, '') = '')
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHTNB~' --Music Hub Music Track Name is Blank
						FROM MHCueSheetSong TV 
						WHERE  TV.MHCueSheetSongCode = @MHCueSheetSongCode AND ISNULL(TV.MusicTrackName , '') = ''
					ELSE
						UPDATE TV SET  TV.RecordStatus = 'W', TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '~') + 'MHMTNF~' -- Music Hub Music Title Not Found
						FROM MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					PRINT 'Step 12 D : Updating error which is Music Hub Music Title Not Found'
				END
				--select * from MHCueSheetSong WHERE MHCueSheetSongCode = @MHCueSheetSongCode

				PRINT 'Step 12 : WARNING Validation ends.'
				--*********************************** WARNING ENDS ***********************************
				
				--*********************************** ERROR STARTS ***********************************
				PRINT 'Step 13 : ERROR Validation STARTS.'

				SELECT  @status = 'Y', @from = '00:00:00.0000000', @to  = '00:00:00.0000000', @duration  = '00:00:00.0000000', @fromFrame  = 0,
						@toFrame  = 0, @durationFrame  = 0, @durationTime  = '00:00:00.0000'

				UPDATE TMH SET TMH.FromFrame =  ISNULL(TMH.FromFrame , 0 ), TMH.ToFrame =  ISNULL(TMH.ToFrame , 0 ), TMH.DurationFrame =  ISNULL(TMH.DurationFrame , 0 )
				FROM #Temp_MHCueSheetSong TMH  WHERE TMH.IsProcessed_Song = 'N' AND TMH.RowNo_Song = @RowNo_Song

				SELECT  @from = FromTime, @to = ToTime, @durationTime = DurationTime, @fromFrame = FromFrame, @toFrame =ToFrame, @durationFrame = DurationFrame
				FROM #Temp_MHCueSheetSong  WHERE IsProcessed_Song = 'N' AND RowNo_Song = @RowNo_Song

				UPDATE TMH SET TMH.FromFrame =  ISNULL(TMH.FromFrame , 0 ), TMH.ToFrame =  ISNULL(TMH.ToFrame , 0 ), TMH.DurationFrame =  ISNULL(TMH.DurationFrame , 0 )
				FROM MHCueSheetSong TMH WHERE TMH.MHCueSheetSongCode = @MHCueSheetSongCode

				PRINT '		From time = '+CAST( @from AS VARCHAR(MAX))+' | To Time = '+CAST( @to AS VARCHAR(MAX)) +' | Duration Time = '+CAST( @durationTime AS VARCHAR(MAX)) +' | From Frame = '+CAST( @fromFrame AS VARCHAR(MAX)) +' | To Frame = '+ CAST(@toFrame AS VARCHAR(MAX)) +' | Duration Frame = '+ CAST(@durationFrame AS VARCHAR(MAX))
				
				UPDATE TV SET @Status = 'E', TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVFF~' --Music Hub Invalid From Frame
				FROM MHCueSheetSong TV --#Temp_MHCueSheetSong TV
				WHERE  ISNUMERIC(TV.FromFrame) = 0 AND ISNUll(TV.FromFrame, '') <> '' AND TV.MHCueSheetSongCode = @MHCueSheetSongCode

				UPDATE TV SET @Status = 'E', TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVTF~' --Music Hub Invalid To Frame
				FROM MHCueSheetSong TV --#Temp_MHCueSheetSong TV
				WHERE  ISNUMERIC(TV.ToFrame) = 0 AND ISNUll(TV.ToFrame, '') <> '' AND TV.MHCueSheetSongCode = @MHCueSheetSongCode

				UPDATE TV SET @Status = 'E',  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVDF~'  --Music Hub Invalid Duration Frame
				FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
				WHERE  ISNUMERIC(TV.DurationFrame) = 0 AND ISNUll(TV.DurationFrame, '') <> '' AND TV.MHCueSheetSongCode = @MHCueSheetSongCode
				
				DECLARE @hh INT = 0, @mm INT = 0, @ss INT = 0, @totalSec_F BIGINT = 0, @totalSec_T BIGINT = 0, @diffSec BIGINT = 0 , @totalSec_D BIGINT = 0

				PRINT '		Checking FROM'
				BEGIN TRY  
					SELECT TOP 1 @hh = number FROM fn_Split_withdelemiter(@from, ':') where id = 1 AND number <> ''
					SELECT TOP 1 @mm = number FROM fn_Split_withdelemiter(@from, ':') where id = 2 AND number <> ''
					SELECT TOP 1 @ss = LEFT(number,2) FROM fn_Split_withdelemiter(@from, ':') where id = 3 AND number <> ''
					PRINT CAST(@hh AS VARCHAR(MAX)) + ' ' +CAST(@mm AS VARCHAR(MAX)) +' '+ CAST(@ss AS VARCHAR(MAX))
					IF((@hh not between 0 and 23) OR (@mm not between 0 and 59) OR (@ss not between 0 and 59))
					BEGIN
						PRINT '		Music Hub Invalid TC IN'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVTI~' --Music Hub Invalid TC IN
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

						SET @status = 'E'
					END
					UPDATE TV SET TV.TotalSec_F = ((@hh * 3600) + (@mm * 60) + @ss)
					FROM  #Temp_MHCueSheetSong TV WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					SET @totalSec_F = ((@hh * 3600) + (@mm * 60) + @ss)
					PRINT '		@totalSec_F = '+ CAST(@totalSec_F AS VARCHAR(MAX))
				END TRY  
				BEGIN CATCH  
						PRINT '		Invalid TC IN'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVTI~' --Music Hub Invalid TC IN
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

						SET @status = 'E'
				END CATCH

				SELECT @hh = 0, @mm = 0, @ss = 0
				PRINT '		Checking TO'
				BEGIN TRY  
					SELECT TOP 1 @hh = number FROM fn_Split_withdelemiter(@to, ':') where id = 1 AND number <> ''
					SELECT TOP 1 @mm = number FROM fn_Split_withdelemiter(@to, ':') where id = 2 AND number <> ''
					SELECT TOP 1 @ss = LEFT(number,2) FROM fn_Split_withdelemiter(@to, ':') where id = 3 AND number <> ''
					PRINT CAST(@hh AS VARCHAR(MAX)) + ' ' +CAST(@mm AS VARCHAR(MAX)) +' '+ CAST(@ss AS VARCHAR(MAX))
					IF((@hh not between 0 and 23) OR (@mm not between 0 and 59) OR (@ss not between 0 and 59))
					BEGIN
						PRINT '		Music Hub Invalid TC OUT'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVTO~' --Music Hub Invalid TC OUT
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

						SET @status = 'E'
					END
					UPDATE TV SET TV.TotalSec_T = ((@hh * 3600) + (@mm * 60) + @ss)
					FROM  #Temp_MHCueSheetSong TV WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					SET @totalSec_T = ((@hh * 3600) + (@mm * 60) + @ss)
					PRINT '		@totalSec_T = '+ CAST(@totalSec_T AS VARCHAR(MAX))
				END TRY  
				BEGIN CATCH  
						PRINT 'Invalid TC OUT'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVTO~' --Music Hub Invalid TC OUT
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

						SET @status = 'E'
				END CATCH

				SELECT @hh = 0, @mm = 0, @ss = 0
				PRINT '		Checking Duration Time'
				BEGIN TRY  
					SELECT TOP 1 @hh = number FROM fn_Split_withdelemiter(@durationTime, ':') where id = 1 AND number <> ''
					SELECT TOP 1 @mm = number FROM fn_Split_withdelemiter(@durationTime, ':') where id = 2 AND number <> ''
					SELECT TOP 1 @ss =  LEFT(number,2)  FROM fn_Split_withdelemiter(@durationTime, ':') where id = 3 AND number <> ''
					PRINT CAST(@hh AS VARCHAR(MAX)) + ' ' +CAST(@mm AS VARCHAR(MAX)) +' '+ CAST(@ss AS VARCHAR(MAX))
					IF((@hh NOT BETWEEN 0 AND 23) OR (@mm NOT BETWEEN 0 AND 59) OR (@ss NOT BETWEEN 0 AND 59))
					BEGIN
						PRINT '		Music Hub Invalid Duration'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVD~' --Music Hub Invalid Duration
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

						SET @status = 'E'
					END
					UPDATE TV SET TV.TotalSec_D = ((@hh * 3600) + (@mm * 60) + @ss)
					FROM  #Temp_MHCueSheetSong TV WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					SET @totalSec_D = ((@hh * 3600) + (@mm * 60) + @ss)
					PRINT '		@totalSec_D = '+ CAST(@totalSec_D AS VARCHAR(MAX))
				END TRY  
				BEGIN CATCH  
						PRINT '		Music Hub Invalid Duration'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHIVD~' --Music Hub Invalid Duration
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

						SET @status = 'E'
				END CATCH

				PRINT '		Checking if  @status != E | status = ' + @status
				--IF NOT EXISTS(SELECT count(*) FROM  MHCueSheetSong TV WHERE RecordStatus = 'E' AND MHCueSheetSongCode = @MHCueSheetSongCode )
				IF (@status <> 'E')
				BEGIN
					PRINT '			Doesnot exists proceed for diffsec'
					UPDATE TV SET TV.DiffSec = (@totalSec_T - @totalSec_F)
					FROM  #Temp_MHCueSheetSong TV WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					SET @diffSec = (@totalSec_T - @totalSec_F)
					PRINT '			@diffSec = ' + CAST(@diffSec AS VARCHAR(MAX))

					IF(
						(@totalSec_F = 0 AND @totalSec_T = 0 AND @totalSec_D = 0) OR
						(@totalSec_F != 0 AND @totalSec_T = 0) OR 
						(@totalSec_F = 0 AND @totalSec_T != 0)
					)
					BEGIN
						PRINT '			Either TC IN, TC OUT or Duration cannot be zero'
						UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHTITODCBZ~' --Music Hub TC IN, TC OUT or Duration cannot be zero
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
					END
					ELSE IF(@totalSec_F = 0 AND @totalSec_T = 0 AND @totalSec_D != 0)
					BEGIN
						IF( @durationFrame >= @frameLimit )
						BEGIN
							PRINT '			Duration frame cannot be greater than ' + CAST((@frameLimit - 1) AS VARCHAR)
							UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHDFCBGZ~' --Duration frame cannot be greater than ' + CAST((@frameLimit - 1) AS VARCHAR)
							FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
							WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
						END
						BEGIN
							SET @status = 'CD'
							PRINT '			CALCULATE DURATION @status = ' + @status
						END
					END

					IF(@totalSec_F != 0 AND @totalSec_T != 0)
					BEGIN
						IF(@totalSec_T > @totalSec_F)
						BEGIN
							IF(@toFrame >= @frameLimit OR @fromFrame >= @frameLimit)
							BEGIN
								PRINT '			From-Frame or To-Frame cannot be greater than' + CAST((@frameLimit - 1) AS VARCHAR)
								UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHFFTFCBGZ~' --From-Frame or To-Frame cannot be greater than' + CAST((@frameLimit - 1) AS VARCHAR)
								FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
								WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
							END
							ELSE
							BEGIN
									SET @status = 'CT'
									PRINT '			CALCULATE TIME @status = ' + @status
							END
						END
						ELSE
						BEGIN
							PRINT '			TC OUT cannot be less than TC IN'
							UPDATE TV SET  TV.RecordStatus = 'E',TV.ErrorMessage =  ISNULL(TV.ErrorMessage, '') + 'MHTOCLTI~' --TC OUT cannot be less than TC IN
							FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
							WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode
						END
					END
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
						SELECT  @duration = (RIGHT('00' + CAST(@hh AS VARCHAR), 2)  + ':' + RIGHT('00' + CAST(@mm AS VARCHAR), 2) + ':' + RIGHT('00' + CAST(@ss AS VARCHAR), 2))
						SELECT @duration =  @duration +'.0000000'
					END
					ELSE
					BEGIN
						SELECT @duration = '00:00:00.0000000', @durationFrame = 0
						SET @durationFrame = (@toFrame - @fromFrame)
						IF(@durationFrame < 0)
							SET @durationFrame = 0
					END

					PRINT '			 @duration = '+ @duration + ' @durationFrame = ' + CAST( @durationFrame AS VARCHAR(MAX))
					UPDATE TV SET TV.DurationTime = CAST (@duration AS TIME), TV.DurationFrame = @durationFrame
						FROM  MHCueSheetSong TV --#Temp_MHCueSheetSong TV
						WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

					/* END : Duration Calculation */
				END
					PRINT 'END : Duration Calculation'

				--*********************************** ERROR ENDS ***********************************

				UPDATE TV SET TV.RecordStatus = ISNULL(TV.RecordStatus,'S'), TV.IsApprove = 'P' FROM MHCueSheetSong TV WHERE TV.MHCueSheetSongCode = @MHCueSheetSongCode

				UPDATE #Temp_MHCueSheetSong SET IsProcessed_Song  = 'Y' WHERE IsProcessed_Song = 'N' AND RowNo_Song = @RowNo_Song
				SELECT @RowNo_Song = 0
				SELECT TOP 1 @RowNo_Song = RowNo_Song FROM #Temp_MHCueSheetSong WHERE IsProcessed_Song = 'N'
			END
			------------------------------------------------------------------------------------------------------------------

			--*********************************** FINAL UPLOAD STATUS STARTS ***********************************
				PRINT 'Step 15 :  FINAL UPLOAD STATUS Validation STARTS.'

				IF EXISTS(SELECT TV.RecordStatus FROM MHCueSheetSong TV  WHERE MHCueSheetCode = @MHCueSheetCode and TV.RecordStatus = 'E')
				BEGIN
					PRINT 'Step 15 A : Updating UploadStatus = E' 
					UPDATE MH SET MH.UploadStatus = 'E'  FROM MHCueSheet MH WHERE MHCueSheetCode = @MHCueSheetCode
				END
				ELSE IF EXISTS(SELECT TV.RecordStatus FROM MHCueSheetSong TV  WHERE MHCueSheetCode = @MHCueSheetCode and TV.RecordStatus= 'W')
				BEGIN
					PRINT 'Step 15 B : Updating UploadStatus = W' 
					UPDATE MH SET MH.UploadStatus = 'W', MH.ApprovedOn = GETDATE()   FROM MHCueSheet MH WHERE MHCueSheetCode = @MHCueSheetCode
				END
				ELSE IF NOT EXISTS(SELECT TV.RecordStatus FROM MHCueSheetSong TV WHERE MHCueSheetCode = @MHCueSheetCode and TV.RecordStatus IN ('W','E'))
				BEGIN
					IF NOT EXISTS (SELECT TV.RecordStatus FROM MHCueSheetSong TV WHERE MHCueSheetCode = @MHCueSheetCode)
					BEGIN
						PRINT 'Step 15 C : Updating UploadStatus = E' 
						UPDATE MH SET MH.UploadStatus = 'E'  FROM MHCueSheet MH WHERE MHCueSheetCode = @MHCueSheetCode
					END
					ELSE
					BEGIN
						PRINT 'Step 15 C : Updating UploadStatus = R' 
						UPDATE MH SET MH.UploadStatus = 'R', MH.ApprovedOn = GETDATE()  FROM MHCueSheet MH WHERE MHCueSheetCode = @MHCueSheetCode
					END
				END

				UPDATE TV SET TV.ErrorRecords = ( SELECT count(*) From MHCueSheetSong WHERE MHCueSheetCode = @MHCueSheetCode and RecordStatus in ('E','W') ) 
				FROM MHCueSheet TV where TV.MHCueSheetCode = @MHCueSheetCode
			--*********************************** FINAL UPLOAD STATUS ENDS ***********************************
			PRINT 'Step 15 :  FINAL UPLOAD STATUS Validation ENDS.'

			UPDATE #temp_MHCueSheet SET IsProcessed_MH  = 'Y' WHERE IsProcessed_MH = 'N' AND RowNo_MH = @RowNo_MH
			SELECT @RowNo_MH = 0
			SELECT TOP 1 @RowNo_MH = RowNo_MH FROM #temp_MHCueSheet WHERE IsProcessed_MH = 'N'
		
		END

		IF EXISTS(SELECT TOP 1 * FROM #temp_MHCueSheet)
			TRUNCATE TABLE #temp_MHCueSheet
		
		PRINT '********************************* PHASE 2 **************************************'
		INSERT INTO #temp_MHCueSheet (
		[MHCueSheetCode],[RequestID] ,[FileName],[UploadStatus],[VendorCode] ,[TotalRecords],[ErrorRecords] ,[CreatedBy],[CreatedOn] ,[ApprovedBy] ,[ApprovedOn] )
		SELECT [MHCueSheetCode],[RequestID] ,[FileName],[UploadStatus],[VendorCode] ,[TotalRecords],[ErrorRecords] ,[CreatedBy],[CreatedOn] ,[ApprovedBy] ,[ApprovedOn]
		FROM MHCueSheet WHERE [UploadStatus] = 'R'

		PRINT 'Step 1 :  Insertion into #temp_MHCueSheet where  UploadStatus = S'

		DECLARE @Music_Title TABLE (MusicTitleCode INT) 
		DECLARE @Title TABLE (TitleCode INT)

		SELECT  @RowNo_MH = 0, @RowCounter_MH = 0, @RowNo_Song = 0, @MHCueSheetCode = 0

		SELECT TOP 1 @RowNo_MH = RowNo_MH FROM #temp_MHCueSheet WHERE IsProcessed_MH = 'N'

		INSERT INTO #Temp_Title_Content_Version(Title_Content_Code, Title_Content_Version_Code )
		SELECT Title_Content_Code, MAX(Title_Content_Version_Code)
		FROM Title_Content_Version GROUP BY Title_Content_Code

		PRINT 'Step 2 : RowNo of #temp_MHCueSheet = ' + CAST(@RowNo_MH AS NVARCHAR(MAX))

		WHILE(@RowNo_MH > 0)
		BEGIN
			PRINT '***********************************************************************'
			SELECT @MHCueSheetCode  = 0 ,  @RowCounter_MH =(@RowCounter_MH + 1)
			SELECT @MHCueSheetCode = MHCueSheetCode FROM #temp_MHCueSheet WHERE IsProcessed_MH = 'N' AND RowNo_MH = @RowNo_MH

			
			PRINT 'Step 4 : #temp_MHCueSheet ie RowNo = ' +   CAST(@RowNo_MH AS NVARCHAR(MAX)) + ' And MHCueSheetCode = ' +   CAST(@MHCueSheetCode AS NVARCHAR(MAX))

				DELETE FROM @Music_Title
				DELETE FROM @Title

				PRINT 'Step 5 : Insertion into @Music_Title.'

				INSERT INTO @Music_Title(MusicTitleCode)
				(
				SELECT MusicTitleCode FROM MHCueSheetSong WHERE MHCueSheetCode = @MHCueSheetCode
				EXCEPT
				SELECT DISTINCT MTL.Music_Title_Code FROM MHCueSheet MR
				   INNER JOIN MHCueSheetSong MRD ON MR.MHCueSheetCode = MRD.MHCueSheetCode 
				   INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode
				   INNER JOIN Music_Deal MD ON MD.Music_Label_Code = MTL.Music_Label_Code
				WHERE MR.MHCueSheetCode =  @MHCueSheetCode
				)

				UPDATE MS SET MS.RecordStatus = 'E', MS.ErrorMessage =  ISNULL(MS.ErrorMessage, '~') +  'MHMDNF~'  -- Music Hub Music Deal Not Found
				FROM MHCueSheetSong MS 
				INNER JOIN @Music_Title MT on MT.MusicTitleCode = MS.MusicTitleCode
				WHERE MS.MHCueSheetCode =  @MHCueSheetCode
			
				PRINT 'Step 6 : Insertion into @Title.'

				INSERT INTO @Title(TitleCode)
				(
					SELECT DISTINCT MRD.TitleCode FROM  MHCueSheetSong MRD WHERE MRD.MHCueSheetCode = @MHCueSheetCode
					EXCEPT
					SELECT TitleCode FROM MHRequest WHERE MHRequestTypeCode = 1
				)

				UPDATE MS SET MS.RecordStatus = 'E', MS.ErrorMessage =  ISNULL(MS.ErrorMessage, '~') +  'MHTNFIC~'  -- Music Hub Title Not Found in Consumption
				FROM MHCueSheetSong MS 
				INNER JOIN @Title T on T.TitleCode = MS.TitleCode
				WHERE MS.MHCueSheetCode =  @MHCueSheetCode

				PRINT 'Step 6 : Insertion into Content_Music_Link.'

				INSERT INTO Content_Music_Link 
				(Title_Content_Code, Title_Content_Version_Code, Music_Title_Code, 
				[From], From_Frame, [To],To_Frame, Duration, Duration_Frame, Inserted_By, Inserted_On)
				SELECT 
					TC.Title_Content_Code, TCV.Title_Content_Version_Code, MH.MusicTitleCode,
					MH.FromTime, MH.FromFrame, MH.ToTime, MH.ToFrame, MH.DurationTime, MH.DurationFrame, 143, GETDATE()
				FROM MHCueSheetSong MH
				INNER JOIN  Title_Content TC ON TC.Title_Content_Code = MH.TitleContentCode
				INNER JOIN  (
					SELECT Title_Content_Code, Title_Content_Version_Code FROM #Temp_Title_Content_Version WHERE Title_Content_Code IS NOT NULL
				) TCV ON TCV.Title_Content_Code = TC.Title_Content_Code
				WHERE MH.MHCueSheetCode = @MHCueSheetCode

			UPDATE MH SET MH.UploadStatus = 'C'  FROM MHCueSheet MH WHERE MH.MHCueSheetCode =  @MHCueSheetCode

			--EXEC USPMHMailNotification 0,0,@MHCueSheetCode
			--EXEC USPMHNotificationMailForCueSheet @MHCueSheetCode

			UPDATE #temp_MHCueSheet SET IsProcessed_MH  = 'Y' WHERE IsProcessed_MH = 'N' AND RowNo_MH = @RowNo_MH
			SELECT @RowNo_MH = 0
			SELECT TOP 1 @RowNo_MH = RowNo_MH FROM #temp_MHCueSheet WHERE IsProcessed_MH = 'N'
		END

	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		SELECT  
		 ERROR_NUMBER() AS ErrorNumber  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END

--EXEC USPMHCueSheetValidation
--UPDATE MH SET MH.UploadStatus = 'S'  FROM MHCueSheet MH WHERE MH.MHCueSheetCode = 1

--update mhcuesheet set uploadstatus = 'p'  where mhcuesheetcode = 89
--update mhcuesheetsong set recordstatus = null, errormessage = null where mhcuesheetcode = 89
--update mhcuesheetsong set DurationTime = NULL where mhcuesheetsongcode = 140
--select * from mhcuesheet where mhcuesheetcode = 89
--select * from mhcuesheetsong where mhcuesheetcode = 89