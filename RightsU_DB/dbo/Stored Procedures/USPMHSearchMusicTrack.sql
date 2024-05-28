CREATE PROCEDURE [dbo].[USPMHSearchMusicTrack]
@MusicLabelCode INT ,
@MusicTrack NVARCHAR(50),
@MovieName NVARCHAR(50),
@GenreCode INT,
@TalentName NVARCHAR(50),
@Tag NVARCHAR(50),
@MHPlayListCode INT,
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@ChannelCode INT,
@TitleCode INT,
@MusicLanguageCode INT,
@RecordCount INT OUT,
@SortBy NVARCHAR(50),
@Order NVARCHAR(50)    
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHSearchMusicTrack]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF  
	
		--DECLARE
		--@MusicLabelCode INT = 0,
		--@MusicTrack NVARCHAR(50) = '',
		--@MovieName NVARCHAR(50) ='',
		--@GenreCode INT = 0,
		--@TalentName NVARCHAR(50)= '',
		--@Tag NVARCHAR(50) = '',
		--@MHPlayListCode INT = 2,
		--@PagingRequired NVARCHAR(2) = 'N',
		--@PageSize INT = 25,
		--@PageNo INT = 0,
		--@ChannelCode INT = 1,
		--@TitleCode INT = 8504,
		--@MusicLanguageCode INT = 0,
		--@RecordCount INT,
		--@SortBy NVARCHAR(50) = 'MusicTrack',
		--@Order NVARCHAR(50) = 'ASC'  

		IF(OBJECT_ID('TEMPDB..#TempMusicTrackList') IS NOT NULL)
			DROP TABLE #TempMusicTrackList
		IF(OBJECT_ID('TEMPDB..#tempA') IS NOT NULL)
			DROP TABLE #tempA
		IF(OBJECT_ID('TEMPDB..#tempStuff') IS NOT NULL)
			DROP TABLE #tempStuff
		IF(OBJECT_ID('TEMPDB..#tempMusicLabel') IS NOT NULL)
			DROP TABLE #tempMusicLabel

				IF(OBJECT_ID('TEMPDB..#tempStuff2') IS NOT NULL)
			DROP TABLE #tempStuff2
				IF(OBJECT_ID('TEMPDB..#tempStuff3') IS NOT NULL)
			DROP TABLE #tempStuff3
		IF OBJECT_ID('tempdb..#TempMusicTrackListFinal') IS NOT NULL DROP TABLE #TempMusicTrackListFinal

		CREATE TABLE #TempMusicTrackList(
		Row_No INT IDENTITY(1,1),
		Music_Title_Code INT,
		Music_Album_Code INT,
		MusicTrack NVARCHAR(MAX),
		Movie NVARCHAR(MAX),
		Genre NVARCHAR(MAX),
		Tag NVARCHAR(MAX),
		MusicLabel NVARCHAR(MAX),
		--Talent NVARCHAR(MAX),
		StarCast NVARCHAR(MAX),
		Singers NVARCHAR(MAX),
		MusicComposer NVARCHAR(MAX),
		MusicLanguage NVARCHAR(MAX),
		MHPlayListSongCode INT
		)

		CREATE TABLE #TempMusicTrackListFinal(
		Row_No INT IDENTITY(1,1),
		Music_Title_Code INT,
		Music_Album_Code INT,
		MusicTrack NVARCHAR(MAX),
		Movie NVARCHAR(MAX),
		Genre NVARCHAR(MAX),
		Tag NVARCHAR(MAX),
		MusicLabel NVARCHAR(MAX),
		--Talent NVARCHAR(MAX),
		StarCast NVARCHAR(MAX),
		Singers NVARCHAR(MAX),
		MusicComposer NVARCHAR(MAX),
		MusicLanguage NVARCHAR(MAX),
		MHPlayListSongCode INT
		)

		CREATE TABLE #tempStuff(
		Talent_Code INT,
		Talent_Name NVARCHAR(100),
		Role_Name NVARCHAR(100),
		Music_Title_Code INT
		)

		CREATE TABLE #tempStuff2(
		Talent_Code INT,
		Talent_Name NVARCHAR(100),
		Role_Name NVARCHAR(100),
		Music_Title_Code INT
		)

		CREATE TABLE #tempStuff3(
		Talent_Code INT,
		Talent_Name NVARCHAR(100),
		Role_Name NVARCHAR(100),
		Music_Title_Code INT
		)
	
		CREATE TABLE #tempMusicLabel(
		MusicLabelCode INT,
		MusicLabelName NVARCHAR(MAX)
		)

		INSERT INTO #tempMusicLabel(MusicLabelCode,MusicLabelName)
		EXEC [USPMHGetMusicLabel] @ChannelCode,@TitleCode

		--select * from #tempMusicLabel
		Print 'P1' + Convert(Varchar(100), Getdate(), 109)
		INSERT INTO #tempStuff(Talent_Code,Talent_Name,Role_Name,Music_Title_Code)
		Select T.Talent_Code,T.Talent_Name,R.Role_Name,MTT.Music_Title_Code 
		FROM Music_Title_Talent MTT WITH(NOLOCK)
		INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
		--INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code
		INNER JOIN ROLE R WITH(NOLOCK) ON R.Role_Code = MTT.Role_Code
		Where R.Role_Code = 2 Order by Talent_Code

		INSERT INTO #tempStuff2(Talent_Code,Talent_Name,Role_Name,Music_Title_Code)
		Select T.Talent_Code,T.Talent_Name,R.Role_Name,MTT.Music_Title_Code 
		FROM Music_Title_Talent MTT WITH(NOLOCK)
		INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
		--INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code
		INNER JOIN ROLE R WITH(NOLOCK) ON R.Role_Code = MTT.Role_Code
		Where R.Role_Code= '13' Order by Talent_Code

		INSERT INTO #tempStuff3(Talent_Code,Talent_Name,Role_Name,Music_Title_Code)
		Select T.Talent_Code,T.Talent_Name,R.Role_Name,MTT.Music_Title_Code 
		FROM Music_Title_Talent MTT WITH(NOLOCK)
		INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
		--INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code
		INNER JOIN ROLE R WITH(NOLOCK) ON R.Role_Code = MTT.Role_Code
		Where R.Role_Name= '21' Order by Talent_Code
		if(@PageNo = 0)
			Set @PageNo = 1

		IF(@MHPlayListCode > 0)
		BEGIN
			INSERT INTO #TempMusicTrackList(Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,StarCast,Singers,MusicComposer, MusicLanguage,MHPlayListSongCode)
			SELECT MT.Music_Title_Code,ISNULL(MT.Music_Album_Code,'') AS Music_Album_Code,MT.Music_Title_Name AS MusicTrack,ISNULL(MA.Music_Album_Name,'') AS Movie,ISNULL(G.Genres_Name,'') AS Genre,ISNULL(MT.Music_Tag,'') AS Tag,ISNULL(ML.MusicLabelName,'') AS MusicLabel
			--,STUFF((SELECT DISTINCT ', ' + CAST(T.Talent_Name AS VARCHAR(Max)) [text()]
			--	FROM Music_Title_Talent MTT
			--	INNER JOIN Talent T ON T.Talent_Code = MTT.Talent_Code
			--	Where MTT.Music_Title_Code = MT.Music_Title_Code
			--	FOR XML PATH(''), TYPE)
			--	.value('.','NVARCHAR(MAX)'),1,2,' '
			--) Talent
			,STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
				FROm #tempStuff ts
				Where ts.Music_Title_Code = MT.Music_Title_Code AND ts.Role_Name = 'Star Cast'
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			)  AS StarCast,
			STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
				FROm #tempStuff ts
				Where ts.Music_Title_Code = MT.Music_Title_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			)  AS Singers,
			STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
				FROm #tempStuff ts
				Where ts.Music_Title_Code = MT.Music_Title_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			)  AS MusicComposer, mlng.Language_Name AS MusicLanguage, MHPLS.MHPlayListSongCode
			FROM Music_Title MT WITH(NOLOCK)
			LEFT JOIN Genres G WITH(NOLOCK) ON G.Genres_Code = MT.Genres_Code
			INNER JOIN Music_Title_Label MTL WITH(NOLOCK) ON MTL.Music_Title_Code = MT.Music_Title_Code AND MTL.Effective_To IS NULL
			INNER JOIN Music_Album MA WITH(NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
			--INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			INNER JOIN #tempMusicLabel ML WITH(NOLOCK) ON ML.MusicLabelCode = MTL.Music_Label_Code
			INNER JOIN Music_Title_Language mtln WITH(NOLOCK) ON mtln.Music_Title_Code = mt.Music_Title_Code
			INNER JOIN Music_Language mlng WITH(NOLOCK) ON mlng.Music_Language_Code = mtln.Music_Language_Code
			INNER JOIN MHPlayListSong MHPLS WITH(NOLOCK) ON MHPLS.MusicTitleCode = MT.Music_Title_Code AND MHPLS.MHPlayListCode = @MHPlayListCode
			ORDER BY MT.Music_Title_Name	

			SELECT @RecordCount = COUNT(*) FROM #TempMusicTrackList
			print 'Record Count: ' +CAST(@RecordCount AS NVARCHAR)

			EXEC ('INSERT INTO #TempMusicTrackListFinal(Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,StarCast,Singers,MusicComposer,MHPlayListSongCode)
					Select Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,ISNULL(StarCast,'''') AS StarCast,ISNULL(Singers,'''') AS Singers,ISNULL(MusicComposer,'''') AS MusicComposer,MHPlayListSongCode 
					from #TempMusicTrackList ORDER BY '+ @SortBy + ' '+ @Order)

			DELETE from  #TempMusicTrackListFinal
			WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

			SELECT Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,StarCast,Singers,MusicComposer,MHPlayListSongCode FROM #TempMusicTrackListFinal

		END
		ELSE
		BEGIN
		
			Print 'P2' + Convert(Varchar(100), Getdate(), 109)

			SELECT DISTINCT MTT.Music_Title_Code INTO #tempA 
			FROM Music_Title_Talent mtt WITH(NOLOCK)
			INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
			Where ISNULL(T.Talent_Name,'') like '%'+@TalentName+'%'
				
			Print 'P3' + Convert(Varchar(100), Getdate(), 109)

			INSERT INTO #TempMusicTrackList(Music_Title_Code, Music_Album_Code, MusicTrack, Movie , Genre, Tag, MusicLabel, StarCast, Singers, MusicComposer, MusicLanguage)
			SELECT MT.Music_Title_Code,ISNULL(MT.Music_Album_Code,'') AS Music_Album_Code,MT.Music_Title_Name AS MusicTrack,ISNULL(MA.Music_Album_Name,'') AS Movie,ISNULL(G.Genres_Name,'') AS Genre,ISNULL(MT.Music_Tag,'') AS Tag,ISNULL(ML.MusicLabelName,'') AS MusicLabel
			--,STUFF((SELECT DISTINCT ', ' + CAST(T.Talent_Name AS VARCHAR(Max)) [text()]
			--	FROM Music_Title_Talent MTT
			--	INNER JOIN Talent T ON T.Talent_Code = MTT.Talent_Code
			--	Where MTT.Music_Title_Code = MT.Music_Title_Code
			--	FOR XML PATH(''), TYPE)
			--	.value('.','NVARCHAR(MAX)'),1,2,' '
			--) Talent
			,
			STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
				FROm #tempStuff ts
				Where ts.Music_Title_Code = MT.Music_Title_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			)  
			AS StarCast,
			STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
				FROm #tempStuff2 ts
				Where ts.Music_Title_Code = MT.Music_Title_Code --AND ts.Role_Name = 'Singers'
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			 AS Singers,
			STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
				FROm #tempStuff3 ts
				Where ts.Music_Title_Code = MT.Music_Title_Code --AND ts.Role_Name = 'Music Composer'
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			AS MusicComposer, mlng.Language_Name AS MusicLanguage
			FROM Music_Title MT WITH(NOLOCK)
			LEFT JOIN Genres G WITH(NOLOCK) ON G.Genres_Code = MT.Genres_Code
			INNER JOIN Music_Title_Label MTL WITH(NOLOCK) ON MTL.Music_Title_Code = MT.Music_Title_Code AND MTL.Effective_To IS NULL
			INNER JOIN Music_Album MA WITH(NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
			--INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			INNER JOIN #tempMusicLabel ML WITH(NOLOCK) ON ML.MusicLabelCode = MTL.Music_Label_Code
			INNER JOIN Music_Title_Language mtln ON mtln.Music_Title_Code = mt.Music_Title_Code
			INNER JOIN Music_Language mlng ON mlng.Music_Language_Code = mtln.Music_Language_Code
			WHERE (@MusicLabelCode = 0 OR ML.MusicLabelCode = @MusicLabelCode) AND ISNULL(MT.Music_Title_Name,'') like '%'+@MusicTrack+'%' AND ISNULL(MA.Music_Album_Name,'') like '%'+@MovieName+'%'
			AND ISNULL(MT.Music_Tag,'') like '%'+@Tag+'%' 
			AND (@GenreCode = 0 or mt.Genres_Code = @GenreCode)
			AND (@TalentName = '' OR MT.Music_Title_Code IN (
					SELECT Music_Title_Code FROM #tempA
				)
			)
			AND (@MusicLanguageCode = 0 or mtln.Music_Language_Code = @MusicLanguageCode)
			ORDER BY MT.Music_Title_Name	

			Print 'P4 ' + Convert(Varchar(100), Getdate(), 109)

			SELECT @RecordCount = COUNT(*) FROM #TempMusicTrackList
			print 'Record Count: ' +CAST(@RecordCount AS NVARCHAR)


			EXEC ('INSERT INTO #TempMusicTrackListFinal(Music_Title_Code, Music_Album_Code, MusicTrack, Movie , Genre, Tag, MusicLabel, StarCast, Singers, MusicComposer, MusicLanguage)
					Select Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,ISNULL(StarCast,'''') AS StarCast,ISNULL(Singers,'''') AS Singers,ISNULL(MusicComposer,'''') AS MusicComposer, ISNULL(MusicLanguage,'''') AS MusicLanguage 
					from #TempMusicTrackList ORDER BY '+ @SortBy + ' '+ @Order)

			DELETE from  #TempMusicTrackListFinal
			WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

			SELECT Music_Title_Code, Music_Album_Code, MusicTrack, Movie , Genre, Tag, MusicLabel, StarCast, Singers, MusicComposer, MusicLanguage FROM #TempMusicTrackListFinal

			--DROP TABLE #tempA
		END

		IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
		IF OBJECT_ID('tempdb..#tempMusicLabel') IS NOT NULL DROP TABLE #tempMusicLabel
		IF OBJECT_ID('tempdb..#TempMusicTrackList') IS NOT NULL DROP TABLE #TempMusicTrackList
		IF OBJECT_ID('tempdb..#tempStuff') IS NOT NULL DROP TABLE #tempStuff
		IF OBJECT_ID('tempdb..#tempStuff2') IS NOT NULL DROP TABLE #tempStuff2
		IF OBJECT_ID('tempdb..#tempStuff3') IS NOT NULL DROP TABLE #tempStuff3
		IF OBJECT_ID('tempdb..#TempMusicTrackListFinal') IS NOT NULL DROP TABLE #TempMusicTrackListFinal
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHSearchMusicTrack]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO

