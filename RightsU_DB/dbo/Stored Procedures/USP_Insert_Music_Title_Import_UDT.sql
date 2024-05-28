CREATE PROCEDURE [dbo].[USP_Insert_Music_Title_Import_UDT] 
	@Music_Title_Import Music_Title_Import READONLY,
--Declare
	@User_Code INT=143
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Music_Title_Import_UDT]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET NOCOUNT ON;		
			TRUNCATE TABLE DM_Music_Title 
			DECLARE @Error_Message	NVARCHAR(MAX)
			INSERT INTO DM_Music_Title
			(
				[Music_Title_Name], 
				[Movie_Album],
				[Title_Type] ,
				[Title_Language] ,
				[Year_of_Release],
				[Duration] ,
				[Singers],
				[Lyricist],
				[Music_Director],
				[Music_Label],
				[Record_Status],
				[Genres],
				[Star_Cast],
				[Music_Version],
				[Effective_Start_Date],
				[Theme],
				[Music_Tag] ,
				[Movie_Star_Cast],
				[Music_Album_Type],
				[Public_Domain]
			)		
			SELECT  
				LTRIM(RTRIM(Replace([Music_Title_Name], ' ', ' '))),
				LTRIM(RTRIM(Replace([Movie_Album], ' ', ' '))),
				[Title_Type],
				[Title_Language],
				[Year_of_Release],
				[Duration],
				[Singers],
				[Lyricist],
				[Music_Director],
				[Music_Label],
				'N',
				[Genres],
				[Star_Cast],
				[Music_Version],
				[Effective_Start_Date],
				[Theme],
				[Music_Tag],
				[Movie_Star_Cast],
				[Music_Album_Type],
				[Public_Domain]
			FROM @Music_Title_Import 
			IF EXISTS(SELECT TOP 1 Record_Status FROM DM_Music_Title (NOLOCK) WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'N')
			BEGIN
			EXEC USP_Validate_Music_Title_Import
			--SELECT TOP 100 Record_Status FROM DM_Title 
			--WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') <> 'E'

			IF NOT EXISTS(SELECT TOP 1 Record_Status FROM DM_Music_Title (NOLOCK) WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E')
			BEGIN
			PRINT 'IF Condition'	
				DECLARE @SingerRoleCode INT = 13, @LyricistRoleCode INT = 15, @MusicComposerRoleCode INT = 21, @StarCastRoleCode INT = 2
			-- Singers Data
			CREATE TABLE #Temp_Singers
			( 
				Name NVARCHAR(1000),
				TalentCode INT,
				RoleExists CHAR(1)
			)
			CREATE TABLE #Temp_Lyricist
			( -- Lyricist Data
				Name NVARCHAR(1000),
				TalentCode INT,
				RoleExists CHAR(1)
			)
			CREATE TABLE #Temp_Version
			( -- Lyricist Data
				Name NVARCHAR(1000),
				VersionCode INT,
				IsExists CHAR(1)
			)
			CREATE TABLE #Temp_Music_Director
			( -- Lyricist Data
				Name NVARCHAR(1000),
				TalentCode INT,
				RoleExists CHAR(1)
			)

			CREATE TABLE #Temp_Music_Label
			( -- Lyricist Data
				Name NVARCHAR(1000),
				LabelCode INT,
				RoleExists CHAR(1)
			)
			CREATE TABLE #Temp_Star_Cast
			( 
				Name NVARCHAR(1000),
				TalentCode INT,
				RoleExists CHAR(1)
			)
			CREATE TABLE #Temp_Genres
			( -- Lyricist Data
				Name NVARCHAR(1000),
				GenresCode INT,
				RoleExists CHAR(1)
			)

			CREATE TABLE #Temp_Music_Album
			( -- Lyricist Data
				Name NVARCHAR(1000),
				Album_Type NVARCHAR(50),
				Music_Album_Code INT,
				RoleExists CHAR(1)
			)

			CREATE TABLE #Temp_Music_Theme
			( -- Lyricist Data
				Name NVARCHAR(1000),
				Code INT,
				IsExists CHAR(1)
			)

			CREATE TABLE #Temp_Music_Language
			( -- Lyricist Data
				Name NVARCHAR(1000),
				Code INT,
				IsExists CHAR(1)
			)
			CREATE TABLE #Temp_Movie_Album
			( -- Lyricist Data
				Name NVARCHAR(1000),
				Music_Album_Code INT,
				RoleExists CHAR(1)
			)
			CREATE TABLE #Temp_Movie_Star_Cast
			(--Movie Star cast Data
				Name NVARCHAR(1000),
				Movie_Star_Cast_Code INT,
				RoleExists CHAR(1)
			)
			INSERT INTO #Temp_Music_Label(Name, RoleExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(a.MusicLabelName, ' ', ' '))), 'N' FROM
			(
				SELECT [Music_Label] MusicLabelName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Music_Label], '') <> ''
			) AS a

			----/////Add #Temp_Music_Theme
			INSERT INTO #Temp_Music_Theme(Name, IsExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.MusicThemeName, ' ', ' '))), 'N' FROM
			(
				SELECT [Theme] MusicThemeName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Theme], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) MusicThemeName FROM DBO.fn_Split_withdelemiter(a.MusicThemeName, ',')
			) AS b WHERE b.MusicThemeName <> ''

			----/////Add #Temp_Music_Language
			INSERT INTO #Temp_Music_Language(Name, IsExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.LanName, ' ', ' '))), 'N' FROM
			(
				SELECT [Title_Language] LanName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Title_Language], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) LanName FROM DBO.fn_Split_withdelemiter(a.LanName, ',')
			) AS b WHERE b.LanName <> ''
		

			INSERT INTO #Temp_Version(Name, IsExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(a.Music_Version, ' ', ' '))), 'N' FROM
			(
				SELECT [Music_Version] Music_Version FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Music_Version], '') <> ''
			) AS a

			INSERT INTO #Temp_Genres(Name, RoleExists)
			SELECT  LTRIM(RTRIM(Replace(a.Genres, ' ', ' '))), 'N' FROM
			(
				SELECT DISTINCT [Genres] Genres FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Genres], '') <> ''
			) AS a
			--UPDATE tm SET tm.Genres = tl.Genres_Code FROM DM_Music_Title tm INNER JOIN Genres tl ON LTRIM(RTRIM(tm.Genres)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Genres_Name)) collate SQL_Latin1_General_CP1_CI_AS
		
			------------Added Music_Album--------------
			INSERT INTO #Temp_Music_Album(Name,Album_Type, RoleExists)
			SELECT  LTRIM(RTRIM(Replace(a.Movie_Album, ' ', ' '))), LTRIM(RTRIM(Replace(a.Music_Album_Type, ' ', ' '))), 'N' FROM
			(
				SELECT DISTINCT [Movie_Album] Movie_Album, [Music_Album_Type] Music_Album_Type FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Movie_Album], '') <> '' AND ISNULL([Music_Album_Type], '') <> ''
			) AS a


			INSERT INTO #Temp_Singers(Name, RoleExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.SinName, ' ', ' '))), 'N' FROM
			(
				SELECT [Singers] SinName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Singers], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) SinName FROM DBO.fn_Split_withdelemiter(a.SinName, ',')
			) AS b WHERE b.SinName <> ''

			INSERT INTO #Temp_Lyricist(Name, RoleExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.Lyricist, ' ', ' '))), 'N' FROM(
				SELECT [Lyricist] FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Lyricist], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Lyricist FROM DBO.fn_Split_withdelemiter(a.Lyricist, ',')
			) AS b WHERE b.Lyricist <> ''

			INSERT INTO #Temp_Music_Director(Name, RoleExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.Music_Director, ' ', ' '))), 'N' FROM(
				SELECT [Music_Director] FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Music_Director], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Music_Director FROM DBO.fn_Split_withdelemiter(a.Music_Director, ',')
			) AS b WHERE b.Music_Director <> ''

			INSERT INTO #Temp_Star_Cast(Name, RoleExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.SCName, ' ', ' '))), 'N' FROM
			(
				SELECT [Star_Cast] SCName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Star_Cast], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) SCName FROM DBO.fn_Split_withdelemiter(a.SCName, ',')
			) AS b WHERE b.SCName <> ''
			---Movie Star Cast Added--
			INSERT INTO #Temp_Movie_Star_Cast(Name, RoleExists)
			SELECT DISTINCT LTRIM(RTRIM(Replace(b.SCName, ' ', ' '))), 'N' FROM
			(
				SELECT [Movie_Star_Cast] SCName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Movie_Star_Cast], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) SCName FROM DBO.fn_Split_withdelemiter(a.SCName, ',')
			) AS b WHERE b.SCName <> ''

			--SELECT * FROM #Temp_S			
			------------ Insert Talent Which are NOT available IN system
			INSERT INTO Talent(talent_name, gender, is_active)
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_Singers WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK))
			UNION
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_Lyricist WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK))
			UNION
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_Music_Director WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK))
			UNION
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_Star_Cast WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK))
			UNION 
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_Movie_Star_Cast WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK) )


			INSERT INTO Music_Label(Music_Label_Name,Is_Active)
			SELECT LTRIM(RTRIM(Name)), 'Y' FROM #Temp_Music_Label WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Label (NOLOCK))
		
			INSERT INTO Genres(Genres_Name,Is_Active)
			SELECT LTRIM(RTRIM(Name)), 'Y' FROM #Temp_Genres WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Genres_Name collate SQL_Latin1_General_CP1_CI_AS FROM Genres (NOLOCK))
		
		
			INSERT INTO Music_Album(Music_Album_Name, Album_Type, Is_Active)
			SELECT LTRIM(RTRIM(Name)),CASE WHEN LTRIM(RTRIM(Album_Type)) = 'Movie' THEN  'M' ELSE 'A' END,'Y' FROM #Temp_Music_Album 
			--SELECT LTRIM(RTRIM(Name)), LTRIM(RTRIM(Album_Type)) ,'Y' FROM #Temp_Music_Album 
			WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Album_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Album (NOLOCK))
 
 			INSERT INTO Music_Language(Language_Name,Is_Active)
			SELECT LTRIM(RTRIM(Name)), 'Y' FROM #Temp_Music_Language WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Language_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Language (NOLOCK))
		
			INSERT INTO Music_Theme(Music_Theme_Name,Is_Active)
			SELECT LTRIM(RTRIM(Name)), 'Y' FROM #Temp_Music_Theme WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Theme_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Theme (NOLOCK))
		
			------------ UPDATE temp tables with talent code AND IS role exists
			UPDATE tm SET tm.TalentCode = tl.talent_code FROM #Temp_Singers tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.TalentCode = tl.talent_code FROM #Temp_Lyricist tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.TalentCode = tl.talent_code FROM #Temp_Music_Director tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.TalentCode = tl.talent_code FROM #Temp_Star_Cast tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.LabelCode = tl.Music_Label_Code FROM #Temp_Music_Label tm INNER JOIN Music_Label tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Music_Label_Name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.GenresCode = tl.Genres_Code FROM #Temp_Genres tm INNER JOIN Genres tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Genres_Name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.Music_Album_Code = tl.Music_Album_Code FROM #Temp_Music_Album tm INNER JOIN Music_Album tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Music_Album_Name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.Code = tl.Music_Language_Code FROM #Temp_Music_Language tm INNER JOIN Music_Language tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Language_Name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.Code = tl.Music_Theme_Code FROM #Temp_Music_Theme tm INNER JOIN Music_Theme tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Music_Theme_Name)) collate SQL_Latin1_General_CP1_CI_AS
			--UPDATE tm SET tm.LabelCode = tl.Genres_Code FROM #Temp_Genres tm INNER JOIN Genres tl ON LTRIM(RTRIM(tm.Name)) = LTRIM(RTRIM(tl.Genres_Name))

			UPDATE tm SET tm.Movie_Star_Cast_Code = tl.Talent_Code FROM #Temp_Movie_Star_Cast tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS
		
			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_Singers tm INNER JOIN Talent_Role tr ON tm.TalentCode = tr.talent_code  AND role_code = @SingerRoleCode
			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_Lyricist tm INNER JOIN Talent_Role tr ON tm.TalentCode = tr.talent_code AND role_code = @LyricistRoleCode
			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_Music_Director tm INNER JOIN Talent_Role tr ON tm.TalentCode= tr.talent_code AND role_code = @MusicComposerRoleCode
			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_Star_Cast tm INNER JOIN Talent_Role tr ON tm.TalentCode= tr.talent_code AND role_code = @StarCastRoleCode
			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_Movie_Star_Cast tm INNER JOIN Talent_Role tr ON tm.Movie_Star_Cast_Code =  tr.talent_code AND role_code = @StarCastRoleCode
			UPDATE tm SET tm.IsExists = 'Y' FROM #Temp_Version tm INNER JOIN Music_Type tr ON tm.Name collate SQL_Latin1_General_CP1_CI_AS= tr.Music_Type_Name AND tr.Type='MV' collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.IsExists = 'Y' FROM #Temp_Music_Language tm INNER JOIN Music_Language tr ON tm.Name collate SQL_Latin1_General_CP1_CI_AS= tr.Language_Name collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.IsExists = 'Y' FROM #Temp_Music_Theme tm INNER JOIN Music_Theme tr ON tm.Name collate SQL_Latin1_General_CP1_CI_AS= tr.Music_Theme_Name collate SQL_Latin1_General_CP1_CI_AS
		
			------------ Talent Role Insert
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Talent_Role(talent_code, role_code)
			SELECT TalentCode, @SingerRoleCode FROM #Temp_Singers WHERE RoleExists = 'N'
			UNION
			SELECT TalentCode, @LyricistRoleCode FROM #Temp_Lyricist WHERE RoleExists = 'N'
			UNION
			SELECT TalentCode, @MusicComposerRoleCode FROM #Temp_Music_Director WHERE RoleExists = 'N'
			UNION
			SELECT TalentCode, @StarCastRoleCode FROM #Temp_Star_Cast WHERE RoleExists = 'N'
			UNION
			SELECT Movie_Star_Cast_Code, @StarCastRoleCode FROM #Temp_Movie_Star_Cast WHERE RoleExists = 'N'

			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS
			------------ END

			------------ INSERT TALENT RECORDS IN MUSIC TITLE		
		
			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)
			SELECT LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),(SELECT Deal_Type_Code FROM [Role] WHERE Role_Code = @SingerRoleCode), GETDATE(), 'Y',TalentCode,'T' FROM #Temp_Singers WHERE RoleExists = 'N'
			UNION
			SELECT LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),(SELECT Deal_Type_Code FROM [Role] WHERE Role_Code = @LyricistRoleCode), GETDATE(), 'Y',TalentCode,'T' FROM #Temp_Lyricist WHERE RoleExists = 'N'
			UNION
			SELECT LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),(SELECT Deal_Type_Code FROM [Role] WHERE Role_Code = @MusicComposerRoleCode), GETDATE(), 'Y',TalentCode,'T' FROM #Temp_Music_Director WHERE RoleExists = 'N'
			UNION
			SELECT LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),LTRIM(RTRIM(Name)),(SELECT Deal_Type_Code FROM [Role] WHERE Role_Code = @StarCastRoleCode), GETDATE(), 'Y',TalentCode,'T' FROM #Temp_Star_Cast WHERE RoleExists = 'N'
		
			------------ END
			PRINT 'Start Cursor'
			--Cursor
			DECLARE @Effective_Date NVARCHAR(100) =''
		 
			DECLARE @Music_TitleName NVARCHAR(1000) = '', @Movie_Album NVARCHAR(1000) = '', @Title_Type NVARCHAR(1000) = '', 
			@Title_Language NVARCHAR(1000) = '',@Year_of_Release INT, @Duration VARCHAR(10) = '', @Star_Cast NVARCHAR(1000) = '', @Music_Version NVARCHAR(1000) = '',
			@Singers NVARCHAR(1000) = '', @Lyricist NVARCHAR(1000) = '',@Music_Director NVARCHAR(1000) = '',@Music_Label NVARCHAR(1000) = '',@Genres NVARCHAR(1000) = '',
			@Effective_Start_Date NVARCHAR(100),@Theme NVARCHAR(1000),@Music_Tag NVARCHAR(200),@Movie_Star_Cast NVARCHAR(1000) = '', @Music_Album_Type NVARCHAR(50) = '' 

			DECLARE CUR_Title CURSOR For
				SELECT LTRIM(RTRIM([Music_Title_Name])),LTRIM(RTRIM([Movie_Album])), LTRIM(RTRIM(Title_Type)), 
					   LTRIM(RTRIM([Title_Language])), LTRIM(RTRIM([Year_of_Release])), LTRIM(RTRIM([Duration])),
					   LTRIM(RTRIM(ISNULL([Singers], ''))), LTRIM(RTRIM(ISNULL([Lyricist], ''))), LTRIM(RTRIM(ISNULL([Music_Director], ''))), 
					   LTRIM(RTRIM(ISNULL([Music_Label], ''))),LTRIM(RTRIM(ISNULL([Genres], ''))),LTRIM(RTRIM(ISNULL([Star_Cast], ''))),LTRIM(RTRIM(ISNULL([Music_Version], ''))),
					   LTRIM(RTRIM(ISNULL([Effective_Start_Date], ''))),LTRIM(RTRIM(ISNULL([Theme], ''))),LTRIM(RTRIM(ISNULL([Music_Tag], ''))),
					   LTRIM(RTRIM(ISNULL([Movie_Star_Cast], ''))),LTRIM(RTRIM(ISNULL([Music_Album_Type], '')))
				FROM DM_Music_Title (NOLOCK) WHERE Record_Status = 'N' -- AND [Title/ Dubbed Title (Hindi)] = 'Aag Ka Gola'
			OPEN CUR_Title

			FETCH NEXT FROM CUR_Title InTo @Music_TitleName, @Movie_Album, @Title_Type, @Title_Language, @Year_of_Release, @Duration,  @Singers, @Lyricist,@Music_Director
			,@Music_Label ,@Genres ,@Star_Cast,@Music_Version,@Effective_Start_Date,@Theme,@Music_Tag, @Movie_Star_Cast, @Music_Album_Type

			WHILE @@FETCH_STATUS<>-1 
			BEGIN                                              
			IF(@@FETCH_STATUS<>-2)                                                         
			BEGIN																														
				PRINT 'BEGIN Start'
			
				DECLARE @Music_type_Code INT , @Title_Language_code INT , @Music_Title_Code INT, @Music_Label_Code INT  , @Genres_Code INT ,@Music_Album_Code INT, @Version_Code INT=null
				SELECT @Music_type_Code = Music_Type_Code FROM Music_Type (NOLOCK) WHERE LTRIM(RTRIM(Music_Type_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Title_Type, ''))) collate SQL_Latin1_General_CP1_CI_AS
				--SELECT @Title_Language_code = language_code FROM [Language] WHERE LTRIM(RTRIM(Language_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Title_Language, ''))) collate SQL_Latin1_General_CP1_CI_AS		
				SELECT @Music_Label_Code = Music_Label_Code FROM Music_Label (NOLOCK) WHERE LTRIM(RTRIM(Music_Label_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Label, '')))	collate SQL_Latin1_General_CP1_CI_AS	
				SELECT @Genres_Code = Genres_Code FROM Genres (NOLOCK) WHERE LTRIM(RTRIM(Genres_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Genres, '')))	collate SQL_Latin1_General_CP1_CI_AS
				SELECT @Music_Album_Code = Music_Album_Code FROM Music_Album (NOLOCK) WHERE LTRIM(RTRIM(Music_Album_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Movie_Album, '')))	collate SQL_Latin1_General_CP1_CI_AS
			
			
				SELECT @Version_Code = Music_Type_Code FROM Music_Type (NOLOCK) WHERE LTRIM(RTRIM(Music_Type_Name)) collate SQL_Latin1_General_CP1_CI_AS = 
				LTRIM(RTRIM(ISNULL(@Music_Version, ''))) collate SQL_Latin1_General_CP1_CI_AS 
				AND LTRIM(RTRIM([Type])) collate SQL_Latin1_General_CP1_CI_AS = 'MV' collate SQL_Latin1_General_CP1_CI_AS

				print @Music_Album_Code
				--PRINT @Music_Version +''+Convert(VarCHAR(1000),@Version_Code)
				IF(ISNULL(@Version_Code, 0) = 0)
				BEGIN
					SELECT @Version_Code = Music_Type_Code FROM Music_Type (NOLOCK) WHERE Type = 'MV' AND Music_Type_Name ='Original'
				END

				INSERT INTO Music_Title
				(
					Music_Type_Code, Music_Title_Name, Movie_Album, Release_Year, Duration_In_Min, is_active,Inserted_By,Inserted_On,Last_UpDated_Time,Genres_Code,Music_Version_Code,Music_Tag,Music_Album_Code
				)
				Values
				(
					@Music_type_Code, LTRIM(RTRIM(@Music_TitleName)), LTRIM(RTRIM(@Movie_Album)), @Year_of_Release, @Duration, 'Y',@User_Code,GETDATE(),GETDATE(),@Genres_Code,@Version_Code,@Music_Tag,@Music_Album_Code
				)
				--SET @Music_Version=''
				--SET @Version_Code=NULL
	
				SELECT @Music_Title_Code = IDENT_CURRENT('Music_Title')
				--PRINT  'Inserted Into Music Title'
				----SELECT * FROM Title WHERE Title_Code = @Title_Code

				--------------Music Title Talent Insert
	
				INSERT INTO Music_Title_Talent(Music_Title_Code, Talent_Code, Role_code)
				SELECT @Music_Title_Code, TalentCode, @SingerRoleCode FROM #Temp_Singers td
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Singers, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(td.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS
				UNION
				SELECT @Music_Title_Code, TalentCode, @LyricistRoleCode FROM #Temp_Lyricist ts
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Lyricist, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(ts.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS
				UNION
				SELECT @Music_Title_Code, TalentCode, @MusicComposerRoleCode FROM #Temp_Music_Director ts
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Music_Director, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(ts.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS
				UNION
				SELECT @Music_Title_Code, TalentCode, @StarCastRoleCode FROM #Temp_Star_Cast ts
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Star_Cast, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(ts.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS

				DECLARE @Effective_From VARCHAR(100)
				SELECT TOP 1 @Effective_From =  Convert(datetime,Parameter_Value,103) from System_Parameter_New where Parameter_Name = 'Music_Label_Effective_From'
			
				INSERT INTO Music_Title_Label(Music_Label_Code,Music_Title_Code,Effective_From)
				SELECT @Music_Label_Code,@Music_Title_Code,CASE WHEN ISNULL(LTRIM(RTRIM(@Effective_Start_Date)),'')='' THEN  @Effective_From ELSE Convert(datetime,@Effective_Start_Date,103) END
			
				INSERT INTO Music_Title_Language(Music_Title_Code,Music_Language_Code)
				SELECT @Music_Title_Code, Code FROM #Temp_Music_Language tml
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Title_Language, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(tml.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS

				INSERT INTO Music_Title_Theme(Music_Title_Code,Music_Theme_Code)
				SELECT @Music_Title_Code, Code FROM #Temp_Music_Theme tmt
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Theme, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(tmt.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS

				INSERT INTO Music_Album_Talent(Music_Album_Code, Talent_Code, Role_Code)
				SELECT @Music_Album_Code, Movie_Star_Cast_Code, @StarCastRoleCode FROM #Temp_Movie_Star_Cast tmsc
				INNER JOIN (
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) number FROM DBO.fn_Split_withdelemiter(@Movie_Star_Cast, ',') WHERE number <> ''
				) AS a ON LTRIM(RTRIM(tmsc.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS
				WHERE tmsc.Movie_Star_Cast_Code NOT IN (SELECT mat.Talent_Code FROM Music_Album_Talent mat (NOLOCK) WHERE mat.Music_Album_Code = @Music_Album_Code)

				DECLARE @TitleType VARCHAR(500)
				SELECT @TitleType = Parameter_Value from System_Parameter_New where Parameter_Name='Title_Type_Music'
			
				PRINT  'Inserted Into Music Title_Talent'
			 --	------------ Update DM_Music_Title
				UPDATE DM_Music_Title SET Record_Status = 'C'  WHERE [Music_Title_Name] collate SQL_Latin1_General_CP1_CI_AS = @Music_TitleName collate SQL_Latin1_General_CP1_CI_AS
				PRINT  'UPDATE DM_Music_Title '		 
				Fetch Next FROM CUR_Title InTo @Music_TitleName, @Movie_Album, @Title_Type, @Title_Language, @Year_of_Release, @Duration,  @Singers, @Lyricist,
				@Music_Director,@Music_Label,@Genres,@Star_Cast,@Music_Version,@Effective_Start_Date,@Theme,@Music_Tag,@Movie_Star_Cast,@Music_Album_Type

				print @Music_Tag
			END
			END
				Close CUR_Title
				Deallocate CUR_Title
				Drop Table #Temp_Singers
				Drop Table #Temp_Music_Director
				Drop Table #Temp_Music_Label
				Drop Table #Temp_Version
				Drop Table #Temp_Lyricist
				Drop Table #Temp_Star_Cast
				Drop Table #Temp_Genres
				Drop Table #Temp_Music_Language
				Drop Table #Temp_Music_Theme
				Drop Table #Temp_Movie_Star_Cast
			END
			ELSE
			BEGIN 
				SELECT 
					[IntCode]+1 AS Line_Number,
					[Music_Title_Name] , 
					[Movie_Album],
					[Title_Language] ,
					[Year_of_Release],
					[Music_Label],
					[Star_Cast],
					[Movie_Star_Cast],
					[Music_Album_Type],
					Substring([Error_Message],2,len([Error_Message])-1) AS Error_Messages
					--[Title_Type] ,
					--[Duration] ,
					--[Singers],
					--[Lyricist],
					--[Music_Director],
					--[Genres],
				
					--[Music_Version],
					--[Error_Message] AS Error_Messages
				 
				FROM DM_Music_Title (NOLOCK)
				WHERE [Record_Status] = 'E'
			END

			END		
		
			--select * from DM_Music_Title

		IF OBJECT_ID('tempdb..#Temp_Genres') IS NOT NULL DROP TABLE #Temp_Genres
		IF OBJECT_ID('tempdb..#Temp_Lyricist') IS NOT NULL DROP TABLE #Temp_Lyricist
		IF OBJECT_ID('tempdb..#Temp_Movie_Album') IS NOT NULL DROP TABLE #Temp_Movie_Album
		IF OBJECT_ID('tempdb..#Temp_Movie_Star_Cast') IS NOT NULL DROP TABLE #Temp_Movie_Star_Cast
		IF OBJECT_ID('tempdb..#Temp_Music_Album') IS NOT NULL DROP TABLE #Temp_Music_Album
		IF OBJECT_ID('tempdb..#Temp_Music_Director') IS NOT NULL DROP TABLE #Temp_Music_Director
		IF OBJECT_ID('tempdb..#Temp_Music_Label') IS NOT NULL DROP TABLE #Temp_Music_Label
		IF OBJECT_ID('tempdb..#Temp_Music_Language') IS NOT NULL DROP TABLE #Temp_Music_Language
		IF OBJECT_ID('tempdb..#Temp_Music_Theme') IS NOT NULL DROP TABLE #Temp_Music_Theme
		IF OBJECT_ID('tempdb..#Temp_S') IS NOT NULL DROP TABLE #Temp_S
		IF OBJECT_ID('tempdb..#Temp_Singers') IS NOT NULL DROP TABLE #Temp_Singers
		IF OBJECT_ID('tempdb..#Temp_Star_Cast') IS NOT NULL DROP TABLE #Temp_Star_Cast
		IF OBJECT_ID('tempdb..#Temp_Version') IS NOT NULL DROP TABLE #Temp_Version
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Music_Title_Import_UDT]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END