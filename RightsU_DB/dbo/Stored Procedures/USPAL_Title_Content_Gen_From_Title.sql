
CREATE PROCEDURE [dbo].[USPAL_Title_Content_Gen_From_Title] 
(
	  @TitleCode INT           
)
AS
BEGIN

/*---------------------------
Author          : Prathamesh Naik
Created On      : 06/April/2023
Description     : Generates Episodes for Program/Show based on the number provided or One if the type is Movie
Last Modified On: 11/April/2023
Last Change     : Added Conditions for Movies and Show. Added System parameter based values for checking if selected type is Movie or Show			
---------------------------*/

	
	IF(OBJECT_ID('tempdb..#TempTitleEpisodeDetail') IS NOT NULL) DROP TABLE #TempTitleEpisodeDetail
	IF(OBJECT_ID('tempdb..#TempTitleContent') IS NOT NULL) DROP TABLE #TempTitleContent
	
	CREATE table #TempTitleEpisodeDetail(
			 Title_Episode_Detail_Code INT,
			 Episode_Nos INT,
			 Title_Code INT
		)
	
	CREATE table #TempTitleContent(
		Title_Code INT,
		Episode_No INT,
		Episode_Title VARCHAR(100),
		Content_Status VARCHAR(100),
		Title_Episode_Detail_Code INT,
		EpisodeSynopsisRemarks VARCHAR(MAX)
	)
	
	--DECLARE @TitleCode INT;
	DECLARE @MaxEpisodeCount INT;
	DECLARE @NumberOfRecord INT;
	DECLARE @Counter INT;
	DECLARE @CurrentEpisodeCount INT;
	DECLARE @Title_Episode_Detail_Code INT;
	DECLARE @Episode_Nos INT;
	DECLARE @Title_Code INT;
	DECLARE @EpisodeIncrement INT;
	DECLARE @TitleName VARCHAR(100);
	DECLARE @Increment INT;
	DECLARE @DealTypeCode INT;
	DECLARE @DealType VARCHAR(10);
	DECLARE @MovieCodes VARCHAR(100);
	DECLARE @ShowCodes VARCHAR(100);
	DECLARE @Remarks VARCHAR(MAX);

	SET @DealTypeCode = (SELECT t.Deal_Type_Code FROM Title t WHERE t.Title_Code = @TitleCode)
	SELECT @DealTypeCode;

	SET @MovieCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');
	SET @ShowCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show');

	--SET @DealType = CASE 
	--	WHEN @DealTypeCode = 1 THEN 'MOVIE'
	--	WHEN @DealTypeCode = 11 THEN 'SHOW'
	--END

	IF EXISTS(SELECT number FROM [dbo].[fn_Split_withdelemiter](@ShowCodes,',') WHERE number = @DealTypeCode)
	BEGIN 
		SET @DealType = 'SHOW'
	END
	ELSE IF EXISTS(SELECT number FROM [dbo].[fn_Split_withdelemiter](@MovieCodes,',') WHERE number = @DealTypeCode)
	BEGIN
		SET @DealType = 'MOVIE'
	END

	SELECT @DealType as DealType;

	IF (@DealType = 'SHOW')
		BEGIN
			SET @Increment = 0;
			SELECT * FROM Title_Content tc WHERE tc.Title_Code = @TitleCode;
			SET @TitleName = (SELECT t.Title_Name FROM Title t WHERE t.Title_Code = @TitleCode);
			SELECT @TitleName;
			
			SET @MaxEpisodeCount = (select MAX(TC.Episode_No) from Title_Content TC where TC.Title_Code = @TitleCode) + 1;
			IF (@MaxEpisodeCount IS NULL)
				SET @MaxEpisodeCount = 1;
			
			SELECT @MaxEpisodeCount as MaxPastEPCount;
			
			DECLARE curEpisode CURSOR FOR
				SELECT Title_Episode_Detail_Code, Episode_Nos, Title_Code, Remarks FROM Title_Episode_Details ted WHERE ted.Title_Code = @TitleCode AND ted.Status = 'P'
				
				OPEN curEpisode
				FETCH NEXT FROM curEpisode
				INTO @Title_Episode_Detail_Code, @Episode_Nos, @Title_Code, @Remarks
				
				WHILE @@FETCH_STATUS = 0
				BEGIN	  
			
					SET @CurrentEpisodeCount = (SELECT ted.Episode_Nos FROM Title_Episode_Details ted WHERE ted.Title_Code = @Title_Code AND ted.Title_Episode_Detail_Code = @Title_Episode_Detail_Code);
					SELECT @CurrentEpisodeCount as EpisodeCount
			
						SET @Counter = 1
						
						WHILE (@Counter <= @CurrentEpisodeCount)
							BEGIN
								SET @EpisodeIncrement = @MaxEpisodeCount + @Increment;
								INSERT INTO #TempTitleContent (Title_Code, Episode_No, Episode_Title, Content_Status, Title_Episode_Detail_Code, EpisodeSynopsisRemarks) VALUES (@Title_Code, @EpisodeIncrement, @TitleName, 'P', @Title_Episode_Detail_Code, @Remarks);
								SET @Counter = @Counter + 1;
								SET @Increment = @Increment + 1;
								SELECT @Increment as IncrementBy1;
							END
					
					FETCH NEXT FROM curEpisode
						INTO @Title_Episode_Detail_Code, @Episode_Nos, @Title_Code, @Remarks
			
				END
				CLOSE curEpisode;
				DEALLOCATE curEpisode;
			
			---------------- END OF CURSOR ----------------
			
				SELECT * FROM #TempTitleContent 
			
				INSERT INTO Title_Content (Title_Code, Episode_No, Episode_Title, Content_Status, Duration, Synopsis) 
				SELECT ttc.Title_Code, ttc.Episode_No, ttc.Episode_Title, ttc.Content_Status, T.Duration_In_Min, ttc.EpisodeSynopsisRemarks 
				FROM #TempTitleContent ttc INNER JOIN Title T ON T.Title_Code = @Title_Code;
			
				--SELECT tc.Title_Content_Code FROM Title_Content tc INNER JOIN #TempTitleContent ttc ON tc.Title_Code = ttc.Title_Code AND tc.Episode_No = ttc.Episode_No 
				
				INSERT INTO Title_Content_Version (Title_Content_Code, Version_Code, Duration)
				SELECT tc.Title_Content_Code, 1, T.Duration_In_Min FROM Title_Content tc INNER JOIN #TempTitleContent ttc ON tc.Title_Code = ttc.Title_Code AND tc.Episode_No = ttc.Episode_No 
				INNER JOIN Title T ON T.Title_Code = @Title_Code;
			
				INSERT INTO Title_Episode_Details_TC (Title_Episode_Detail_Code, Title_Content_Code)
				SELECT ttc.Title_Episode_Detail_Code, tc.Title_Content_Code FROM Title_Content tc 
				INNER JOIN #TempTitleContent ttc ON tc.Title_Code = ttc.Title_Code AND tc.Episode_No = ttc.Episode_No;
			
			UPDATE Title_Episode_Details SET Status = 'C' WHERE Title_Episode_Detail_Code IN (SELECT DISTINCT Title_Episode_Detail_Code FROM #TempTitleContent)
		END
	ELSE IF  (@DealType = 'MOVIE')
		BEGIN
			SELECT * FROM Title_Content tc WHERE tc.Title_Code = @TitleCode;
			SET @TitleName = (SELECT t.Title_Name FROM Title t WHERE t.Title_Code = @TitleCode);
			SELECT @TitleName;

			SET @MaxEpisodeCount = (select MAX(TC.Episode_No) from Title_Content TC where TC.Title_Code = @TitleCode);
			IF (@MaxEpisodeCount IS NULL)
			--	SET @MaxEpisodeCount = 1;

			--SELECT @MaxEpisodeCount as MaxPastEPCount;
			--SELECT Title_Episode_Detail_Code, Episode_Nos, Title_Code FROM Title_Episode_Details ted WHERE ted.Title_Code = @TitleCode AND ted.Status = 'P'

			--INSERT INTO #TempTitleContent (Title_Code, Episode_No, Episode_Title, Content_Status, Title_Episode_Detail_Code) VALUES (@Title_Code, @EpisodeIncrement, @TitleName, 'P', @Title_Episode_Detail_Code);
				BEGIN
				SET @MaxEpisodeCount = 1;
				SELECT @MaxEpisodeCount as MaxPastEPCount;
				SELECT Title_Episode_Detail_Code, Episode_Nos, Title_Code FROM Title_Episode_Details ted WHERE ted.Title_Code = @TitleCode AND ted.Status = 'P'
				SET @Title_Episode_Detail_Code = (SELECT Title_Episode_Detail_Code FROM Title_Episode_Details ted WHERE ted.Title_Code = @TitleCode AND ted.Status = 'P')
				INSERT INTO #TempTitleContent (Title_Code, Episode_No, Episode_Title, Content_Status, Title_Episode_Detail_Code) VALUES (@TitleCode, @MaxEpisodeCount, @TitleName, 'P', @Title_Episode_Detail_Code);

				END
			SELECT * FROM #TempTitleContent

			INSERT INTO Title_Content (Title_Code, Episode_No, Episode_Title, Content_Status, Duration) 
			SELECT ttc.Title_Code, ttc.Episode_No, ttc.Episode_Title, ttc.Content_Status, T.Duration_In_Min 
			FROM #TempTitleContent ttc INNER JOIN Title T ON T.Title_Code = @TitleCode;

			INSERT INTO Title_Content_Version (Title_Content_Code, Version_Code, Duration)
			SELECT tc.Title_Content_Code, 1, T.Duration_In_Min FROM Title_Content tc INNER JOIN #TempTitleContent ttc ON tc.Title_Code = ttc.Title_Code AND tc.Episode_No = ttc.Episode_No 
			INNER JOIN Title T ON T.Title_Code = @TitleCode;
			
			INSERT INTO Title_Episode_Details_TC (Title_Episode_Detail_Code, Title_Content_Code)
			SELECT ttc.Title_Episode_Detail_Code, tc.Title_Content_Code FROM Title_Content tc 
			INNER JOIN #TempTitleContent ttc ON tc.Title_Code = ttc.Title_Code AND tc.Episode_No = ttc.Episode_No;
			
			UPDATE Title_Episode_Details SET Status = 'C' WHERE Title_Episode_Detail_Code IN (SELECT DISTINCT Title_Episode_Detail_Code FROM #TempTitleContent)
		END

		SELECT Column1 = 'Success'

END