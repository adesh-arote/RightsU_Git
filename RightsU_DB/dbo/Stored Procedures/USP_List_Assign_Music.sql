alter PROCEDURE USP_List_Assign_Music
(
	@Acq_Deal_Code INT
)
AS
BEGIN
	SET FMTONLY OFF
	
	--DECLARE @Acq_Deal_Code INT = 12360

	DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(Deal_Type_Code) FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code

	DECLARE @RoleCode_Singer INT = 13, @RoleCode_Lyricist INT = 15, @RoleCode_MusicComposer INT = 21

	IF(OBJECT_ID('TEMPDB..#Temp_Assign_Music_List') IS NOT NULL)
		DROP TABLE	#Temp_Assign_Music_List

	IF(OBJECT_ID('TEMPDB..#Temp_ProgramData') IS NOT NULL)
		DROP TABLE #Temp_ProgramData

	CREATE TABLE #Temp_Assign_Music_List
	(
		Int_Code VARCHAR(MAX),
		Program NVARCHAR(MAX),
		Episode_Numbers NVARCHAR(MAX),
		Music_Agreement NVARCHAR(MAX),
		Music_Library NVARCHAR(MAX),
		Music_Title NVARCHAR(MAX),
		Label VARCHAR(MAX),
		Movie_Album NVARCHAR(MAX),
		Singer NVARCHAR(MAX),
		Music_Composer NVARCHAR(MAX),
		Lyricist NVARCHAR(MAX)
	)

	IF( @Deal_Type_Condition = 'DEAL_MUSIC')
	BEGIN
		PRINT 'SELECT DATA FOR ASSIGN MUSIC LIST FOR MUSIC DEAL'

		INSERT INTO #Temp_Assign_Music_List(Int_Code, Music_Library, Music_Title, Movie_Album, Singer, Music_Composer, Lyricist)
		SELECT DISTINCT CAST(ADMM.Acq_Deal_Movie_Music_Code AS VARCHAR) AS Int_Code,
		DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Music_Library, 
		MT.Music_Title_Name AS Music_Title, MT.Movie_Album, 
		[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_Singer) AS Singers,
		[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_MusicComposer) AS Music_Composer,
		[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_Lyricist) AS Lyricist
		FROM Acq_Deal_Movie_Music ADMM
		INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code AND ADM.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
		INNER JOIN Music_Title MT ON ADMM.Music_Title_Code = MT.Music_Title_Code
	END
	ELSE
	BEGIN
		PRINT 'SELECT DATA FOR ASSIGN MUSIC LIST FOR NON-MUSIC DEAL'

		SELECT DISTINCT ADMML.Link_Acq_Deal_Movie_Code, ADMML.Acq_Deal_Movie_Music_Code INTO #Temp_ProgramData
		FROM Acq_Deal_Movie_Music_Link ADMML 

		INSERT INTO #Temp_Assign_Music_List(Int_Code, Program, Episode_Numbers, Music_Agreement, Music_Library, Music_Title, Label, Singer)
		SELECT DISTINCT 
		STUFF
		(
			(
				SELECT ',' + CAST(ADMML.Acq_Deal_Movie_Music_Link_Code AS VARCHAR)
				FROM Acq_Deal_Movie_Music_Link ADMML WHERE ADMML.Link_Acq_Deal_Movie_Code = TEMP.Link_Acq_Deal_Movie_Code 
					AND ADMML.Acq_Deal_Movie_Music_Code = TEMP.Acq_Deal_Movie_Music_Code
				ORDER BY ADMML.Acq_Deal_Movie_Music_Link_Code
				FOR XML PATH('')
			), 1, 1, ''
		) AS Int_Code,
		DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Program, 
		--STUFF
		--(
		--	(
		--		SELECT ',' + CAST(ADMML.Episode_No AS VARCHAR)
		--		FROM Acq_Deal_Movie_Music_Link ADMML WHERE ADMML.Link_Acq_Deal_Movie_Code = TEMP.Link_Acq_Deal_Movie_Code 
		--			AND ADMML.Acq_Deal_Movie_Music_Code = TEMP.Acq_Deal_Movie_Music_Code
		--		ORDER BY ADMML.Episode_No
		--		FOR XML PATH('')
		--	), 1, 1, ''
		--) AS Episode_Numbers,
		(
			SELECT DISTINCT CAST(COUNT(Episode_No) AS VARCHAR) + ' Episodes'
			FROM Acq_Deal_Movie_Music_Link ADMML WHERE ADMML.Link_Acq_Deal_Movie_Code = TEMP.Link_Acq_Deal_Movie_Code 
			AND ADMML.Acq_Deal_Movie_Music_Code = TEMP.Acq_Deal_Movie_Music_Code
		) AS Episode_Count,
		AD_L.Agreement_No AS Music_Agreement, 

		DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD_L.Deal_Type_Code), T_L.Title_Name, ADM_L.Episode_Starts_From, ADM_L.Episode_End_To) AS Music_Library, 
		MT_L.Music_Title_Name AS Music_Title, 
		ISNULL(STUFF
		(
			(
				SELECT ',' + CAST(ML.Music_Label_Name AS NVARCHAR)
				FROM Acq_Deal_Movie_Music ADMM
				INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = ADMM.Music_Title_Code
				INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				WHERE ADMM.Acq_Deal_Movie_Music_Code = TEMP.Acq_Deal_Movie_Music_Code
				ORDER BY ML.Music_Label_Name
				FOR XML PATH('')
			), 1, 1, ''
		), '') AS Label,
		[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT_L.Music_Title_Code, @RoleCode_Singer) AS Singers
		FROM #Temp_ProgramData TEMP 
		INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TEMP.Link_Acq_Deal_Movie_Code AND ADM.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
		--- Join for "Linked Music with Music Library"
		INNER JOIN Acq_Deal_Movie_Music ADMM ON ADMM.Acq_Deal_Movie_Music_Code = TEMP.Acq_Deal_Movie_Music_Code
		INNER JOIN Acq_Deal_Movie ADM_L ON ADM_L.Acq_Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code
		INNER JOIN Title T_L ON T_L.Title_Code = ADM_L.Title_Code
		INNER JOIN Music_Title MT_L ON ADMM.Music_Title_Code = MT_L.Music_Title_Code
		INNER JOIN Acq_Deal AD_L ON AD_L.Acq_Deal_Code = ADM_L.Acq_Deal_Code
		where  AD_L.Deal_Workflow_Status NOT IN ('AR', 'WA')
	END

	SELECT Int_Code, ISNULL(Program, '') AS Program, ISNULL(Episode_Numbers, '') AS Episode_Numbers, ISNULL(Music_Agreement, '') AS Music_Agreement,
	ISNULL(Music_Library, '') AS Music_Library, ISNULL(Music_Title, '') AS Music_Title, ISNULL(Label, '') AS Label, ISNULL(Movie_Album, '') AS Movie_Album, 
	ISNULL(Singer, '') AS Singer, ISNULL(Music_Composer, '') AS Music_Composer, ISNULL(Lyricist, '') AS Lyricist
	FROM #Temp_Assign_Music_List
END
