CREATE PROCEDURE [dbo].[USP_Populate_Music]
(
	@Acq_Deal_Movie_Code INT = 0, @Search_Text VARCHAR(MAX) = '', @Deal_Type_Code INT = '', @Link_Show VARCHAR(1),
	@Mode VARCHAR(MAX) = 'VIEW'
)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Populate_Music]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SET FMTONLY OFF

		--DECLARE @Acq_Deal_Movie_Code INT = 13041, @Search_Text VARCHAR(MAX) = 'Music_4885', @Deal_Type_Code INT = 11, @Link_Show VARCHAR(1) = 'N',
		--@Mode VARCHAR(MAX) = ''

		DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)

		DECLARE @RoleCode_Singer INT = 13, @RoleCode_Lyricist INT = 15, @RoleCode_MusicComposer INT = 21
		DECLARE @Deal_Code INT = 0

		IF(OBJECT_ID('TEMPDB..#Temp_Music_List') IS NOT NULL)
			DROP TABLE	#Temp_Music_List

		CREATE TABLE #Temp_Music_List
		(
			Int_Code VARCHAR(MAX),
			Agreement_No VARCHAR(MAX),
			Music_Library NVARCHAR(MAX),
			Music_Title NVARCHAR(MAX),
			Label NVARCHAR(MAX),
			Movie_Album VARCHAR(MAX),
			Singer NVARCHAR(MAX),
			Music_Composer NVARCHAR(MAX),
			Lyricist NVARCHAR(MAX),
			Deal_Type VARCHAR(MAX),
			Title_Name NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Episodes NVARCHAR(MAX),
			No_Of_Play INT,
		)

		IF( @Deal_Type_Condition = 'DEAL_MUSIC' AND @Link_Show = 'N')
		BEGIN
			PRINT 'SELECT DATA FROM MUSIC_TITLE (NOLOCK) FOR MUSIC DEAL'

			SELECT TOP 1 @Deal_Code = Acq_Deal_Code FROM Acq_Deal_Movie (NOLOCK) WHERE Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code

			INSERT INTO #Temp_Music_List(Int_Code, Music_Title, Movie_Album, Singer, Music_Composer, Lyricist)
			SELECT DISTINCT CAST(MT.Music_Title_Code AS VARCHAR) AS Int_Code, MT.Music_Title_Name AS Music_Title, MT.Movie_Album, 
			[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_Singer) AS Singers,
			[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_MusicComposer) AS Music_Composer,
			[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_Lyricist) AS Lyricist
			FROM Music_Title MT (NOLOCK) 
			LEFT JOIN Music_Title_Talent MTT (NOLOCK) ON MTT.Music_Title_Code = MT.Music_Title_Code 
				AND MTT.Role_Code IN (@RoleCode_Singer, @RoleCode_MusicComposer, @RoleCode_Lyricist)
			LEFT JOIN Talent T (NOLOCK) ON T.Talent_Code = MTT.Talent_Code 
			WHERE MT.Music_Title_Code NOT IN (
				SELECT DISTINCT ADMM.Music_Title_Code FROM Acq_Deal_Movie_Music ADMM (NOLOCK) WHERE ADMM.Acq_Deal_Movie_Code IN ( 
					SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie (NOLOCK) WHERE Acq_Deal_Code =  @Deal_Code
				)
			) AND 
			(
				ISNULL(MT.Music_Title_Name, '') LIKE '%' + @Search_Text + '%' OR ISNULL(MT.Movie_Album, '') LIKE '%' + @Search_Text + '%' OR
				ISNULL(T.Talent_Name, '') LIKE '%' + @Search_Text + '%'
			)
		
		END
		ELSE IF( @Deal_Type_Condition = 'DEAL_MUSIC' AND @Link_Show = 'Y')
		BEGIN
			PRINT 'SELECT DATA FROM ACQ_DEAL (NOLOCK) FOR LINK SHOW'

			IF(@Mode = 'VIEW')
			BEGIN
				INSERT INTO #Temp_Music_List(Agreement_No, Deal_Type, Title_Name, No_Of_Play, Episodes)
				SELECT DISTINCT AD.Agreement_No, DT.Deal_Type_Name,  
				DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), ISNULL(T.Title_Name, ''), ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name,
				ADMML.No_Of_Play,
				STUFF
				(
					(
						SELECT ', Episode-' + CAST(ADMML_I.Episode_No AS VARCHAR)
						FROM Acq_Deal_Movie_Music_Link ADMML_I (NOLOCK)
						WHERE ADMML_I.Link_Acq_Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code
						AND ADMML_I.Acq_Deal_Movie_Music_Code = ADMML.Acq_Deal_Movie_Music_Code
						AND ADMML_I.No_Of_Play = ADMML.No_Of_Play 
						ORDER BY ADMML_I.Episode_No
						FOR XML PATH('')
					), 1, 1, ''
				) AS Episodes
				FROM Acq_Deal_Movie_Music_Link ADMML (NOLOCK)
				INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Acq_Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
				INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
				INNER JOIN Deal_Type DT (NOLOCK) ON DT.Deal_Type_Code = AD.Deal_Type_Code
				WHERE ADMML.Acq_Deal_Movie_Music_Code = @Acq_Deal_Movie_Code AND AD.Deal_Workflow_Status = 'A'
			END
			ELSE
			BEGIN
				IF EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_Name = 'AssignMusic_DealType')
				BEGIN
					DECLARE @Codes VARCHAR(MAX) = ''
					SELECT TOP 1 @Codes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AssignMusic_DealType'

					IF(OBJECT_ID('TEMPDB..#Temp_Deal_Type') IS NOT NULL)
						DROP TABLE #Temp_Deal_Type

					SELECT number AS Deal_Type_Code INTO #Temp_Deal_Type FROM DBO.fn_Split_withdelemiter(@Codes, ',') WHERE LTRIM(RTRIM(number)) <> ''

					INSERT INTO #Temp_Music_List(Int_Code, Agreement_No, Deal_Type, Title_Name, Episode_From, Episode_To)
					SELECT DISTINCT ADM.Acq_Deal_Movie_Code, AD.Agreement_No, DT.Deal_Type_Name,  
					DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), ISNULL(T.Title_Name, ''), ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name,
					ADM.Episode_Starts_From, ADM.Episode_End_To
					FROM Acq_Deal AD (NOLOCK)
					INNER JOIN #Temp_Deal_Type TDT ON TDT.Deal_Type_Code = AD.Deal_Type_Code
					INNER JOIN Deal_Type DT (NOLOCK) ON DT.Deal_Type_Code = ad.Deal_Type_Code
					INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
					INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
					INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
					WHERE ADM.Episode_Starts_From IS NOT NULL AND ADM.Episode_End_To IS NOT NULL AND ISNULL(AD.[Status], '') <> 'T' AND AD.Deal_Workflow_Status = 'A' AND (
						ISNULL(AD.Agreement_No, '') LIKE '%' + @Search_Text + '%' OR ISNULL(DT.Deal_Type_Name, '') LIKE '%' + @Search_Text + '%' OR
						ISNULL(T.Title_Name, '') LIKE '%' + @Search_Text + '%' OR ISNULL(V.Vendor_Name, '') LIKE '%' + @Search_Text + '%'
					)
					AND AD.Deal_Workflow_Status = 'A'
				END		
			END
		
		END
		ELSE
		BEGIN
			PRINT 'SELECT DATA FROM ACQ_DEAL_MOVIE_MUSIC (NOLOCK) FOR NON-MUSIC '

			INSERT INTO #Temp_Music_List(Int_Code, Agreement_No, Music_Library, Music_Title, Label, Movie_Album, Singer, Music_Composer)
			SELECT DISTINCT CAST(ADMM.Acq_Deal_Movie_Music_Code AS VARCHAR) AS Int_Code, AD.Agreement_No, 
			DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), ISNULL(T.Title_Name, ''), ADM.Episode_Starts_From, ADM.Episode_End_To) AS Music_Library, 
			MT.Music_Title_Name AS Music_Title, 
			ISNULL(STUFF
			(
				(
					SELECT ',' + CAST(ML_I.Music_Label_Name AS NVARCHAR)
					FROM Music_Title_Label MTL_I (NOLOCK) 
					INNER JOIN Music_Label ML_I (NOLOCK) ON ML_I.Music_Label_Code = MTL_I.Music_Label_Code
					WHERE MTL_I.Music_Title_Code = MT.Music_Title_Code
					ORDER BY ML_I.Music_Label_Name
					FOR XML PATH('')
				), 1, 1, ''
			), '') AS Label,
			MT.Movie_Album, 
			[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_Singer) AS Singers,
			[dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code](MT.Music_Title_Code, @RoleCode_MusicComposer) AS Music_Composer
			FROM Acq_Deal_Movie_Music ADMM (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Acq_Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code
			INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
			INNER JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = ADMM.Music_Title_Code
			INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
			LEFT JOIN Music_Title_Label MTL (NOLOCK) ON MTL.Music_Title_Code = MT.Music_Title_Code
			LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MTL.Music_Label_Code
			WHERE(
				ISNULL(AD.Agreement_No, '') LIKE '%' + @Search_Text + '%' OR ISNULL(T.Title_Name, '') LIKE '%' + @Search_Text + '%' OR
				ISNULL(ML.Music_Label_Name, '') LIKE '%' + @Search_Text + '%' OR ISNULL(MT.Music_Title_Name, '') LIKE '%' + @Search_Text + '%' 
			) AND AD.Deal_Workflow_Status = 'A' AND AD.[Status] != 'T'
		END

		SELECT DISTINCT Int_Code, ISNULL(Agreement_No, '') AS Agreement_No, ISNULL(Music_Library, '') AS Music_Library, ISNULL(Music_Title, '') AS Music_Title, 
		ISNULL(Label, '') AS Label, ISNULL(Movie_Album, '') AS Movie_Album, ISNULL(Singer, '') AS Singer, ISNULL(Music_Composer, '') AS Music_Composer, 
		ISNULL(Lyricist, '') AS Lyricist, ISNULL(Deal_Type, '') AS Deal_Type, ISNULL(Title_Name, '') AS Title_Name, 
		ISNULL(Episode_From, 0) AS Episode_From, ISNULL(Episode_To, 0) AS Episode_To, ISNULL(Episodes, '') AS Episodes, ISNULL(No_Of_Play, 0) AS No_Of_Play
		FROM #Temp_Music_List

		IF OBJECT_ID('tempdb..#Temp_Deal_Type') IS NOT NULL DROP TABLE #Temp_Deal_Type
		IF OBJECT_ID('tempdb..#Temp_Music_List') IS NOT NULL DROP TABLE #Temp_Music_List
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Populate_Music]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END