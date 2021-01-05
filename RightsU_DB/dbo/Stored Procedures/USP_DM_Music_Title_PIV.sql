CREATE PROCEDURE [dbo].[USP_DM_Music_Title_PIV]    
	@DM_Master_Import_Code VARCHAR(500),    
	@User_Code INT=143    
AS     
BEGIN    
--declare @DM_Master_Import_Code VARCHAR(500)=6313,    
	CREATE TABLE #Temp_Import    
	(    
	-- Temp Import Data    
		ID INT IDENTITY(1,1),    
		DM_Master_Import_Code VARCHAR(500),    
		Name NVARCHAR(2000),    
		Master_Type VARCHAR(100),    
		Action_By INT,    
		Action_On DATETIME,    
		Roles VARCHAR(100),    
		--DM_Master_Log_Code INT   
		Master_Code INT,
		Mapped_By CHAR(1) 
	)    
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
	( -- Version Data    
		Name NVARCHAR(1000),    
		VersionCode INT,    
		IsExists CHAR(1)    
	)    
	CREATE TABLE #Temp_Music_Director    
	( -- Music Director Data    
		Name NVARCHAR(1000),    
		TalentCode INT,    
		RoleExists CHAR(1)    
	)    
    
	CREATE TABLE #Temp_Music_Label    
	( -- Music Label Data    
		Name NVARCHAR(1000),    
		LabelCode INT,    
		RoleExists CHAR(1)    
	)    
	CREATE TABLE #Temp_Star_Cast    
	(     
	--star cast data    
		Name NVARCHAR(1000),    
		TalentCode INT,    
		RoleExists CHAR(1)    
	)    
	CREATE TABLE #Temp_Genres    
	( -- Genres Data    
		Name NVARCHAR(1000),    
		GenresCode INT,    
		RoleExists CHAR(1)    
	)    
    
	CREATE TABLE #Temp_Music_Album    
	( -- Music Album Data    
		Name NVARCHAR(1000),    
		Album_Type NVARCHAR(50),    
		Music_Album_Code INT,    
		RoleExists CHAR(1)    
	)    
    
	CREATE TABLE #Temp_Music_Theme    
	( -- Msuic Theme Data    
		Name NVARCHAR(1000),    
		Code INT,    
		IsExists CHAR(1)    
	)    
    
	CREATE TABLE #Temp_Music_Language    
	( -- Music Language Data    
		Name NVARCHAR(1000),    
		Code INT,    
		IsExists CHAR(1)    
	)    
	CREATE TABLE #Temp_Movie_Album    
	( -- Movie album Data    
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

	IF OBJECT_ID('TEMPDB..#Temp_DM_Music_Title_SystemMapped') IS NOT NULL
		DROP TABLE #Temp_DM_Music_Title_SystemMapped

	IF OBJECT_ID('TEMPDB..#Temp_DM_Music_Title_UserMapped') IS NOT NULL
		DROP TABLE #Temp_DM_Music_Title_UserMapped

	CREATE TABLE #Temp_DM_Music_Title_UserMapped
	(
		IntCode INT,
		IsMovieAlbumUserMappedValid CHAR(1) DEFAULT('Y'),
		IsSingerUserMappedValid CHAR(1) DEFAULT('Y'),
		IsLyricistUserMappedValid CHAR(1) DEFAULT('Y'),
		IsMusicDirectorUserMappedValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageUserMappedValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelUserMappedValid CHAR(1) DEFAULT('Y'),
		IsGneresUserMappedValid CHAR(1) DEFAULT('Y'),
		IsStarCastUserMappedValid CHAR(1) DEFAULT('Y'),
		IsMoviestarcastUserMappedValid CHAR(1) DEFAULT('Y'),
		IsUserMappedValid AS CASE 
						WHEN 'YYYYYYYYY' = (IsMovieAlbumUserMappedValid + IsSingerUserMappedValid + IsLyricistUserMappedValid + IsMusicDirectorUserMappedValid + IsTitleLanguageUserMappedValid + 
											IsMusicLabelUserMappedValid + IsGneresUserMappedValid + IsStarCastUserMappedValid + IsMoviestarcastUserMappedValid) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)

	CREATE TABLE #Temp_DM_Music_Title_SystemMapped
	(
		IntCode INT,
		IsMovieAlbumSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsSingerSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsLyricistSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsMusicDirectorSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsGneresSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsStarCastSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsMoviestarcastSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsSystemMappedValid AS CASE 
						WHEN 'YYYYYYYYY' = (IsMovieAlbumSystemMappedValid + IsSingerSystemMappedValid + IsLyricistSystemMappedValid + IsMusicDirectorSystemMappedValid + IsTitleLanguageSystemMappedValid + 
											IsMusicLabelSystemMappedValid + IsGneresSystemMappedValid + IsStarCastSystemMappedValid + IsMoviestarcastSystemMappedValid) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)
	DECLARE @SingerRoleCode INT = 13, @LyricistRoleCode INT = 15, @MusicComposerRoleCode INT = 21, @StarCastRoleCode INT = 2 ,@DirectorCode INT =1    
	INSERT INTO #Temp_Music_Label(Name, RoleExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(a.MusicLabelName, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Music_Label] MusicLabelName FROM DM_Music_Title WHERE ISNULL([Music_Label], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
    
	----/////Add #Temp_Music_Theme    
	INSERT INTO #Temp_Music_Theme(Name, IsExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.MusicThemeName, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Theme] MusicThemeName FROM DM_Music_Title WHERE ISNULL([Theme], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) MusicThemeName FROM DBO.fn_Split_withdelemiter(a.MusicThemeName, ',')    
	) AS b WHERE b.MusicThemeName <> ''    
    
	----/////Add #Temp_Music_Language    
	INSERT INTO #Temp_Music_Language(Name, IsExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.LanName, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Title_Language] LanName FROM DM_Music_Title WHERE ISNULL([Title_Language], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) LanName FROM DBO.fn_Split_withdelemiter(a.LanName, ',')    
	) AS b WHERE b.LanName <> ''    
      
    
	INSERT INTO #Temp_Version(Name, IsExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(a.Music_Version, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Music_Version] Music_Version FROM DM_Music_Title WHERE ISNULL([Music_Version], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
    
	INSERT INTO #Temp_Genres(Name, RoleExists)    
	SELECT  LTRIM(RTRIM(REPLACE(a.Genres, ' ', ' '))), 'N' FROM    
	(    
		SELECT DISTINCT [Genres] Genres FROM DM_Music_Title WHERE ISNULL([Genres], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	--UPDATE tm SET tm.Genres = tl.Genres_Code FROM DM_Music_Title tm INNER JOIN Genres tl ON LTRIM(RTRIM(tm.Genres)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Genres_Name)) collate SQL_Latin1_General_CP1_CI_AS    
      
	------------Added Music_Album--------------    
	INSERT INTO #Temp_Music_Album(Name,Album_Type, RoleExists)    
	SELECT  LTRIM(RTRIM(REPLACE(a.Movie_Album, ' ', ' '))), LTRIM(RTRIM(REPLACE(a.Music_Album_Type, ' ', ' '))), 'N' FROM    
	(    
		SELECT DISTINCT [Movie_Album] Movie_Album, [Music_Album_Type] Music_Album_Type FROM DM_Music_Title WHERE ISNULL([Movie_Album], '') <> '' AND ISNULL([Music_Album_Type], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
    
    
	INSERT INTO #Temp_Singers(Name, RoleExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.SinName, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Singers] SinName FROM DM_Music_Title WHERE ISNULL([Singers], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) SinName FROM DBO.fn_Split_withdelemiter(a.SinName, ',')    
	) AS b WHERE b.SinName <> ''    
    
	INSERT INTO #Temp_Lyricist(Name, RoleExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.Lyricist, ' ', ' '))), 'N' FROM(    
	SELECT [Lyricist] FROM DM_Music_Title WHERE ISNULL([Lyricist], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) Lyricist FROM DBO.fn_Split_withdelemiter(a.Lyricist, ',')    
	) AS b WHERE b.Lyricist <> ''    
    
	INSERT INTO #Temp_Music_Director(Name, RoleExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.Music_Director, ' ', ' '))), 'N' FROM(    
	SELECT [Music_Director] FROM DM_Music_Title WHERE ISNULL([Music_Director], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) Music_Director FROM DBO.fn_Split_withdelemiter(a.Music_Director, ',')    
	) AS b WHERE b.Music_Director <> ''    
    
	INSERT INTO #Temp_Star_Cast(Name, RoleExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.SCName, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Star_Cast] SCName FROM DM_Music_Title WHERE ISNULL([Star_Cast], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) SCName FROM DBO.fn_Split_withdelemiter(a.SCName, ',')    
	) AS b WHERE b.SCName <> ''    
	---Movie Star Cast Added--    
	INSERT INTO #Temp_Movie_Star_Cast(Name, RoleExists)    
	SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.SCName, ' ', ' '))), 'N' FROM    
	(    
		SELECT [Movie_Star_Cast] SCName FROM DM_Music_Title WHERE ISNULL([Movie_Star_Cast], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
	) AS a    
	CROSS APPLY    
	(    
		SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) SCName FROM DBO.fn_Split_withdelemiter(a.SCName, ',')    
	) AS b WHERE b.SCName <> ''    
    
	SELECT @User_Code = Upoaded_By FROM DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code

	INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code, Mapped_By)    
	SELECT  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL, 'U' FROM (    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' AS DMMASTER_TYPE FROM #Temp_Singers     
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent  
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @SingerRoleCode)       
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' As DMMASTER_TYPE FROM #Temp_Lyricist    
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent    
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @LyricistRoleCode)       

	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' As DMMASTER_TYPE FROM #Temp_Music_Director     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @MusicComposerRoleCode)       
    
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) AS DMNAME, 'TA' AS DMMASTER_TYPE FROM #Temp_Star_Cast     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent    
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @StarCastRoleCode)       

	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' AS DMMASTER_TYPE FROM #Temp_Movie_Star_Cast    
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent  
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @StarCastRoleCode)   
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'LB' As DMMASTER_TYPE FROM #Temp_Music_Label     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label    
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'GE' As DMMASTER_TYPE FROM #Temp_Genres     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Genres    
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MA' As DMMASTER_TYPE FROM #Temp_Music_Album     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Music_Album_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Album    
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'ML' As DMMASTER_TYPE FROM #Temp_Music_Language     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Language_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Language    
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MT' As DMMASTER_TYPE FROM #Temp_Music_Theme WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Theme_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Theme)    
	) AS a    

	SELECT DISTINCT NAME, Roles INTO #TempRolesDummy FROM (    
	SELECT LTRIM(RTRIM(Name)) AS NAME, 'Singers' AS Roles FROM #Temp_Singers     
	WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
	SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent  
		WHERE Talent_Code  IN (SELECT Talent_Code from Talent_Role WHERE Role_Code = @SingerRoleCode)       
  
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) AS NAME, 'Lyricist' As Roles FROM #Temp_Lyricist    
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent    
		WHERE Talent_Code  IN (SELECT Talent_Code from Talent_Role WHERE Role_Code = @LyricistRoleCode)       

	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) AS NAME, 'Music Composer' As Roles FROM #Temp_Music_Director     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent    
		WHERE Talent_Code  IN (SELECT Talent_Code from Talent_Role WHERE Role_Code = @MusicComposerRoleCode)       

	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) AS NAME, 'Star Cast' AS Roles FROM #Temp_Star_Cast     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent   
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @StarCastRoleCode)       
 
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) AS NAME, 'Star Cast' AS Roles FROM #Temp_Movie_Star_Cast     
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent    
		WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role WHERE Role_Code = @StarCastRoleCode)       

	)    
	) AS a    
    
	UPDATE t1 set t1.Roles = STUFF(     
		(SELECT ', ' + t2.Roles    
		FROM #TempRolesDummy t2    
		WHERE t1.Name = t2.NAME    
		FOR XML PATH('')), 1, 1, '')      
		FROM #Temp_Import t1    
	WHERE Master_Type = 'TA'    
  

	IF NOT EXISTS (SELECT DM_Master_Import_Code  From DM_Master_Log  where DM_Master_Import_Code = @DM_Master_Import_Code)
	BEGIN
		INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Roles,Is_Ignore,Mapped_By)      
		SELECT  @DM_Master_Import_Code , Name, Master_Type, Action_By, Action_On, Roles,'N','U'  FROM #Temp_Import  
	END  
    
		UPDATE T set T.Master_Code = DM.Master_Code,T.Mapped_By = CASE WHEN DM.Master_Code != 0 THEN 'S' ELSE 'U'END
		FROM #Temp_Import T
		INNER JOIN DM_Master_Log DM ON DM.Name  COLLATE SQL_Latin1_General_CP1_CI_AS = T.Name COLLATE SQL_Latin1_General_CP1_CI_AS
		AND DM.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS = T.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS AND DM.Is_Ignore = 'N' 

		UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By
		FROM DM_Master_Log D
		INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS = T.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS  
		WHERE ISNULL(D.Master_Code,0)=0 AND D.DM_Master_Import_Code = @DM_Master_Import_Code

	DECLARE @MusicCount INT = 0 ,@SystemMappingCount INT=0     
	SELECT @MusicCount = COUNT(*) FROM #Temp_Import  
	SELECT @SystemMappingCount = COUNT(*) FROM #Temp_Import
	IF (@MusicCount > 0)      
	BEGIN      
		SELECT @MusicCount = COUNT(*) FROM DM_Master_Log WHERE DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND ISNULL(Master_Code, 0) = 0      
	END   

	IF (@SystemMappingCount > 0)      
	BEGIN      
		SELECT @SystemMappingCount = COUNT(*) FROM DM_Master_Log WHERE DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND Master_Code != 0      
	END 

	IF (@MusicCount > 0)      
	BEGIN  
		DECLARE @status VARCHAR(2)
		SELECT @status = status FROM DM_Master_Import  WHERE DM_Master_Import_Code = @DM_Master_Import_Code
		IF(@status != 'I' )
		BEGIN 
			UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
		END 
		
		BEGIN
		IF OBJECT_ID('TEMPDB..#TempMasterLog_Usermapped') IS NOT NULL
			DROP TABLE #TempMasterLog_Usermapped

		CREATE TABLE #TempMasterLog_Usermapped
		(
			Name NVARCHAR(500), 
			Master_Type VARCHAR(10), 
			Master_Code VARCHAR(1000), 
			Roles VARCHAR(100),
			Is_Ignore CHAR(1),
			Mapped_By CHAR(1)
		)

		INSERT INTO #TempMasterLog_Usermapped(Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
		SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By FROM DM_Master_Log
		WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND ISNULL(Master_Code, 0) = 0  AND Mapped_By = 'U'
	END

	BEGIN 
		INSERT INTO #Temp_DM_Music_Title_UserMapped(IntCode)
		SELECT IntCode FROM DM_Music_Title 
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'

		UPDATE mt SET mt.IsSingerUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Singers
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Singers,',')
				WHERE LTRIM(RTRIM(ISNULL(Singers, ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Singers collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('SINGERS', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

		UPDATE mt SET mt.IsMovieAlbumUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Album
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Album,',')
				WHERE LTRIM(RTRIM(ISNULL(Movie_Album, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'MA' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsLyricistUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Lyricist
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',')
				WHERE LTRIM(RTRIM(ISNULL(Lyricist, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Lyricist collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('LYRICIST', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsMusicDirectorUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Director
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',')
				WHERE LTRIM(RTRIM(ISNULL(Music_Director, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Music_Director collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsTitleLanguageUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Title_Language
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',')
				WHERE LTRIM(RTRIM(ISNULL(Title_Language, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Title_Language collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'ML' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsMusicLabelUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Label
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',')
				WHERE LTRIM(RTRIM(ISNULL(Music_Label, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Music_Label collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'LB' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

		UPDATE mt SET mt.IsGneresUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Genres
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Genres,',')
				WHERE LTRIM(RTRIM(ISNULL(Genres, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Genres collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'GE' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsStarCastUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Star_Cast
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',')
				WHERE LTRIM(RTRIM(ISNULL(Star_Cast, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

		UPDATE mt SET mt.IsMoviestarcastUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Star_Cast
				FROM #Temp_DM_Music_Title_UserMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Star_Cast,',')
				WHERE LTRIM(RTRIM(ISNULL(Movie_Star_Cast, ''))) <> '' AND IsUserMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.Movie_Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
	END
		UPDATE DMT SET DMT.Record_Status = 'R'
		FROM DM_Music_Title DMT
		INNER JOIN #Temp_DM_Music_Title_UserMapped TDMT ON TDMT.IntCode = DMT.IntCode
		WHERE TDMT.IsUserMappedValid = 'N'

	END    
	
     IF (@SystemMappingCount > 0)      
	 BEGIN     
	
	 DECLARE @SystemMAppingstatus VARCHAR(2),@Mapped_By CHAR(1)
	 SELECT @SystemMAppingstatus = status FROM DM_Master_Import  WHERE DM_Master_Import_Code = @DM_Master_Import_Code

	 IF(@SystemMAppingstatus != 'I' )
	 BEGIN 
		  UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
		  END
		  SELECT @Mapped_By = Mapped_By FROM DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code
		  IF(ISNULL(@Mapped_By,'') = '')
		  BEGIN

		  BEGIN
		IF OBJECT_ID('TEMPDB..#TempMasterLog_systemMapped') IS NOT NULL
			DROP TABLE #TempMasterLog_systemMapped

		CREATE TABLE #TempMasterLog_systemMapped
		(
			Name NVARCHAR(500), 
			Master_Type VARCHAR(10), 
			Master_Code VARCHAR(1000), 
			Roles VARCHAR(100),
			Is_Ignore CHAR(1),
			Mapped_By CHAR(1)
		)

		INSERT INTO #TempMasterLog_systemMapped(Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
		SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By FROM DM_Master_Log
		WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND Master_Code > 0 AND Mapped_By = 'S'
	END

	BEGIN 

		INSERT INTO #Temp_DM_Music_Title_SystemMapped(IntCode)
		SELECT IntCode FROM DM_Music_Title 
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'

		UPDATE mt SET mt.IsSingerSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Singers
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Singers,',')
				WHERE LTRIM(RTRIM(ISNULL(Singers, ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Singers collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('SINGERS', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode

		UPDATE mt SET mt.IsMovieAlbumSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Album
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Album,',')
				WHERE LTRIM(RTRIM(ISNULL(Movie_Album, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'MA' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsLyricistSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Lyricist
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',')
				WHERE LTRIM(RTRIM(ISNULL(Lyricist, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Lyricist collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('LYRICIST', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsMusicDirectorSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Director
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',')
				WHERE LTRIM(RTRIM(ISNULL(Music_Director, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Music_Director collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsTitleLanguageSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Title_Language
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',')
				WHERE LTRIM(RTRIM(ISNULL(Title_Language, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Title_Language collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'ML' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsMusicLabelSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Label
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',')
				WHERE LTRIM(RTRIM(ISNULL(Music_Label, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Music_Label collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'LB' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode

		UPDATE mt SET mt.IsGneresSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Genres
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Genres,',')
				WHERE LTRIM(RTRIM(ISNULL(Genres, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Genres collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'GE' 
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
		
		UPDATE mt SET mt.IsStarCastSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Star_Cast
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',')
				WHERE LTRIM(RTRIM(ISNULL(Star_Cast, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode

		UPDATE mt SET mt.IsMoviestarcastSystemMappedValid = 'N'
		FROM (
			SELECT DISTINCT IntCode
			FROM (
				SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Star_Cast
				FROM #Temp_DM_Music_Title_SystemMapped D
				INNER JOIN DM_Music_Title DMT ON DMT.IntCode = D.IntCode
				CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Star_Cast,',')
				WHERE LTRIM(RTRIM(ISNULL(Movie_Star_Cast, ''))) <> '' AND IsSystemMappedValid <> 'N'
			) AS a
			INNER JOIN #TempMasterLog_systemMapped ml ON a.Movie_Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
	END

		UPDATE DMT SET DMT.Record_Status = 'R'
		FROM DM_Music_Title DMT
		INNER JOIN #Temp_DM_Music_Title_SystemMapped TDMT ON TDMT.IntCode = DMT.IntCode
		WHERE TDMT.IsSystemMappedValid = 'N'

			
	END
END    
	--DROP TABLE #TempRolesDummy    
	--DROP TABLE #Temp_Genres    
	--DROP TABLE #Temp_Lyricist    
	--DROP TABLE #Temp_Movie_Album    
	--DROP TABLE #Temp_Movie_Star_Cast    
	--DROP TABLE #Temp_Music_Album    
	--DROP TABLE #Temp_Music_Director    
	--DROP TABLE #Temp_Music_Label    
	--DROP TABLE #Temp_Music_Language    
	--DROP TABLE #Temp_Music_Theme    
	--DROP TABLE #Temp_Singers    
	--DROP TABLE #Temp_Star_Cast    
	--DROP TABLE #Temp_Version    
	--DROP TABLE #Temp_Import    

	IF OBJECT_ID('tempdb..#Temp_DM_Music_Title_SystemMapped') IS NOT NULL DROP TABLE #Temp_DM_Music_Title_SystemMapped
	IF OBJECT_ID('tempdb..#Temp_DM_Music_Title_UserMapped') IS NOT NULL DROP TABLE #Temp_DM_Music_Title_UserMapped
	IF OBJECT_ID('tempdb..#Temp_Genres') IS NOT NULL DROP TABLE #Temp_Genres
	IF OBJECT_ID('tempdb..#Temp_Import') IS NOT NULL DROP TABLE #Temp_Import
	IF OBJECT_ID('tempdb..#Temp_Lyricist') IS NOT NULL DROP TABLE #Temp_Lyricist
	IF OBJECT_ID('tempdb..#Temp_Movie_Album') IS NOT NULL DROP TABLE #Temp_Movie_Album
	IF OBJECT_ID('tempdb..#Temp_Movie_Star_Cast') IS NOT NULL DROP TABLE #Temp_Movie_Star_Cast
	IF OBJECT_ID('tempdb..#Temp_Music_Album') IS NOT NULL DROP TABLE #Temp_Music_Album
	IF OBJECT_ID('tempdb..#Temp_Music_Director') IS NOT NULL DROP TABLE #Temp_Music_Director
	IF OBJECT_ID('tempdb..#Temp_Music_Label') IS NOT NULL DROP TABLE #Temp_Music_Label
	IF OBJECT_ID('tempdb..#Temp_Music_Language') IS NOT NULL DROP TABLE #Temp_Music_Language
	IF OBJECT_ID('tempdb..#Temp_Music_Theme') IS NOT NULL DROP TABLE #Temp_Music_Theme
	IF OBJECT_ID('tempdb..#Temp_Singers') IS NOT NULL DROP TABLE #Temp_Singers
	IF OBJECT_ID('tempdb..#Temp_Star_Cast') IS NOT NULL DROP TABLE #Temp_Star_Cast
	IF OBJECT_ID('tempdb..#Temp_Version') IS NOT NULL DROP TABLE #Temp_Version
	IF OBJECT_ID('tempdb..#TempMasterLog_systemMapped') IS NOT NULL DROP TABLE #TempMasterLog_systemMapped
	IF OBJECT_ID('tempdb..#TempMasterLog_Usermapped') IS NOT NULL DROP TABLE #TempMasterLog_Usermapped
	IF OBJECT_ID('tempdb..#TempRolesDummy') IS NOT NULL DROP TABLE #TempRolesDummy
END