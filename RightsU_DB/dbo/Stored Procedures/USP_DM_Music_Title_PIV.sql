CREATE PROCEDURE [dbo].[USP_DM_Music_Title_PIV]    
	@DM_Master_Import_Code VARCHAR(500),    
	@User_Code INT=143,
	@StepCountIn INT,
	@StepCountOut INT OUT 
AS     
BEGIN    
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DM_Music_Title_PIV]', 'Step 1', 0, 'Started Procedure', 0, ''

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
			Mapped_By CHAR(1),
			Music_Album_Code INT,
			Music_Album NVARCHAR(2000)
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
		DECLARE @Record_Code INT, 
				@Record_Type CHAR = 'M', 
				@Step_No INT = 1, 
				@Sub_Step_No INT = 1, 
				@Loop_Counter INT = 0, 
				@Short_Status_Code VARCHAR(10), 
				@Proc_Name VARCHAR(100),
				@Process_Error_Code VARCHAR(10),
				@Process_Error_MSG VARCHAR(50)=''
				SET @Step_No = @StepCountIn
		BEGIN TRY
					--M0015: Block 2 Insert into Temp Tables 
					SELECT	@Record_Code = @DM_Master_Import_Code,
						@Step_No = @Step_No + 1,
						@Short_Status_Code ='M0015', 
						@Proc_Name = 'USP_DM_Music_Title_PIV'
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				INSERT INTO #Temp_Music_Label(Name, RoleExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(a.MusicLabelName, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Music_Label] MusicLabelName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Music_Label], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a  
			  
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				----/////Add #Temp_Music_Theme    
				INSERT INTO #Temp_Music_Theme(Name, IsExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.MusicThemeName, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Theme] MusicThemeName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Theme], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) MusicThemeName FROM DBO.fn_Split_withdelemiter(a.MusicThemeName, ',')    
				) AS b WHERE b.MusicThemeName <> ''    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				----/////Add #Temp_Music_Language    
				INSERT INTO #Temp_Music_Language(Name, IsExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.LanName, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Title_Language] LanName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Title_Language], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) LanName FROM DBO.fn_Split_withdelemiter(a.LanName, ',')    
				) AS b WHERE b.LanName <> ''    
			  
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
	
				INSERT INTO #Temp_Version(Name, IsExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(a.Music_Version, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Music_Version] Music_Version FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Music_Version], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				INSERT INTO #Temp_Genres(Name, RoleExists)    
				SELECT  LTRIM(RTRIM(REPLACE(a.Genres, ' ', ' '))), 'N' FROM    
				(    
					SELECT DISTINCT [Genres] Genres FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Genres], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				--UPDATE tm SET tm.Genres = tl.Genres_Code FROM DM_Music_Title tm INNER JOIN Genres tl ON LTRIM(RTRIM(tm.Genres)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Genres_Name)) collate SQL_Latin1_General_CP1_CI_AS    
			 
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				------------Added Music_Album--------------    
				INSERT INTO #Temp_Music_Album(Name,Album_Type, RoleExists)    
				SELECT  LTRIM(RTRIM(REPLACE(a.Movie_Album, ' ', ' '))), LTRIM(RTRIM(REPLACE(a.Music_Album_Type, ' ', ' '))), 'N' FROM    
				(    
					SELECT DISTINCT [Movie_Album] Movie_Album, [Music_Album_Type] Music_Album_Type FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Movie_Album], '') <> '' AND ISNULL([Music_Album_Type], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

			
				INSERT INTO #Temp_Singers(Name, RoleExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.SinName, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Singers] SinName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Singers], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) SinName FROM DBO.fn_Split_withdelemiter(a.SinName, ',')    
				) AS b WHERE b.SinName <> ''    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				INSERT INTO #Temp_Lyricist(Name, RoleExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.Lyricist, ' ', ' '))), 'N' FROM(    
				SELECT [Lyricist] FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Lyricist], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) Lyricist FROM DBO.fn_Split_withdelemiter(a.Lyricist, ',')    
				) AS b WHERE b.Lyricist <> ''    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				INSERT INTO #Temp_Music_Director(Name, RoleExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.Music_Director, ' ', ' '))), 'N' FROM(    
				SELECT [Music_Director] FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Music_Director], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) Music_Director FROM DBO.fn_Split_withdelemiter(a.Music_Director, ',')    
				) AS b WHERE b.Music_Director <> ''    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				INSERT INTO #Temp_Star_Cast(Name, RoleExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.SCName, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Star_Cast] SCName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Star_Cast], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) SCName FROM DBO.fn_Split_withdelemiter(a.SCName, ',')    
				) AS b WHERE b.SCName <> '' 
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
   
				---Movie Star Cast Added--    
				INSERT INTO #Temp_Movie_Star_Cast(Name, RoleExists)    
				SELECT DISTINCT LTRIM(RTRIM(REPLACE(b.SCName, ' ', ' '))), 'N' FROM    
				(    
					SELECT [Movie_Star_Cast] SCName FROM DM_Music_Title (NOLOCK) WHERE ISNULL([Movie_Star_Cast], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code    
				) AS a    
				CROSS APPLY    
				(    
					SELECT LTRIM(RTRIM(REPLACE(number, ' ', ' '))) SCName FROM DBO.fn_Split_withdelemiter(a.SCName, ',')    
				) AS b WHERE b.SCName <> ''    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
				DECLARE @DealType_Show INT = 0, @DealType_Movie INT = 0 ;

				SELECT @User_Code = Upoaded_By FROM DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code
				INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code, Mapped_By,Music_Album)    
				SELECT  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL, 'U',Music_Album FROM (    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' AS DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Singers     
					WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent  (NOLOCK) 
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @SingerRoleCode)       
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' As DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Lyricist    
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)    
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @LyricistRoleCode)       

				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' As DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Music_Director     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @MusicComposerRoleCode)       
			
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) AS DMNAME, 'TA' AS DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Star_Cast     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)    
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @StarCastRoleCode)       

				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' AS DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Movie_Star_Cast    
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)  
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @StarCastRoleCode)   
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'LB' As DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Music_Label     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label (NOLOCK)    
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'GE' As DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Genres     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Genres (NOLOCK)    
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MA' As DMMASTER_TYPE, 'Album' As Music_Album FROM #Temp_Music_Album     
					WHERE Album_Type = 'Album' and Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT Music_Album_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Album (NOLOCK)    
				)  
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MA' As DMMASTER_TYPE, 'Movie' As Music_Album FROM #Temp_Music_Album     
					WHERE Album_Type = 'Movie' and Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
                    select Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS from Title (NOLOCK) where Title_Name is not null and Deal_Type_Code in (select number from fn_Split_withdelemiter((select Parameter_Value from System_Parameter where Parameter_Name = 'AL_DealType_Movies'),','))				)
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MA' As DMMASTER_TYPE, 'Show' As Music_Album FROM #Temp_Music_Album     
					WHERE Album_Type = 'Show' and Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
				    select Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS from Title (NOLOCK) where Deal_Type_Code in (select number from fn_Split_withdelemiter((select Parameter_Value from System_Parameter where Parameter_Name = 'AL_DealType_Show'),','))   
				)
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'ML' As DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Music_Language     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT Language_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Language (NOLOCK)    
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MT' As DMMASTER_TYPE,NULL As Music_Album FROM #Temp_Music_Theme WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Theme_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Theme)    
				) AS a    

				SELECT DISTINCT NAME, Roles INTO #TempRolesDummy FROM (    
				SELECT LTRIM(RTRIM(Name)) AS NAME, 'Singers' AS Roles FROM #Temp_Singers     
				WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
				SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)  
					WHERE Talent_Code  IN (SELECT Talent_Code from Talent_Role (NOLOCK) WHERE Role_Code = @SingerRoleCode)       
  
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) AS NAME, 'Lyricist' As Roles FROM #Temp_Lyricist    
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)    
					WHERE Talent_Code  IN (SELECT Talent_Code from Talent_Role (NOLOCK) WHERE Role_Code = @LyricistRoleCode)       

				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) AS NAME, 'Music Composer' As Roles FROM #Temp_Music_Director     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)    
					WHERE Talent_Code  IN (SELECT Talent_Code from Talent_Role (NOLOCK) WHERE Role_Code = @MusicComposerRoleCode)       

				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) AS NAME, 'Star Cast' AS Roles FROM #Temp_Star_Cast     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)   
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @StarCastRoleCode)       
 
				)    
				UNION    
					SELECT LTRIM(RTRIM(Name)) AS NAME, 'Star Cast' AS Roles FROM #Temp_Movie_Star_Cast     
					WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
					SELECT talent_name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Talent (NOLOCK)    
					WHERE Talent_Code  IN (SELECT Talent_Code FROM Talent_Role (NOLOCK) WHERE Role_Code = @StarCastRoleCode)       

				)    
				) AS a    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
		
			--M0016: Block 3 Insert And Update Into DM_Master_Log using Temp Table
		
				SELECT  @Step_No = @Step_No + 1,
						@Sub_Step_No = 1,
						@Short_Status_Code = 'M0016'
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				UPDATE t1 set t1.Roles = STUFF(     
					(SELECT ', ' + t2.Roles    
					FROM #TempRolesDummy t2    
					WHERE t1.Name = t2.NAME    
					FOR XML PATH('')), 1, 1, '')      
					FROM #Temp_Import t1    
				WHERE Master_Type = 'TA'    
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 


				IF NOT EXISTS (SELECT DM_Master_Import_Code  From DM_Master_Log  (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code)
				BEGIN
					INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Roles,Is_Ignore,Mapped_By,Music_Album)      
					SELECT  @DM_Master_Import_Code , Name, Master_Type, Action_By, Action_On, Roles,'N','U',Music_Album  FROM #Temp_Import  

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END  
			
					UPDATE T set T.Master_Code = DM.Master_Code,T.Mapped_By = CASE WHEN DM.Master_Code != 0 THEN 'S' ELSE 'U'END
					FROM #Temp_Import T
					INNER JOIN DM_Master_Log DM (NOLOCK) ON DM.Name  COLLATE SQL_Latin1_General_CP1_CI_AS = T.Name COLLATE SQL_Latin1_General_CP1_CI_AS
					AND DM.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS = T.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS AND DM.Is_Ignore = 'N' 
					AND DM.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS = T.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By
					FROM DM_Master_Log D
					INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS = T.Master_Type COLLATE SQL_Latin1_General_CP1_CI_AS  
					WHERE ISNULL(D.Master_Code,0)=0 AND D.DM_Master_Import_Code = @DM_Master_Import_Code

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				DECLARE @MusicCount INT = 0 ,@SystemMappingCount INT=0     
				SELECT @MusicCount = COUNT(*) FROM #Temp_Import  
				SELECT @SystemMappingCount = COUNT(*) FROM #Temp_Import
				IF (@MusicCount > 0)      
				BEGIN      
					SELECT @MusicCount = COUNT(*) FROM DM_Master_Log (NOLOCK) WHERE DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND ISNULL(Master_Code, 0) = 0     
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
 
				END   

				IF (@SystemMappingCount > 0)      
				BEGIN      
					SELECT @SystemMappingCount = COUNT(*) FROM DM_Master_Log (NOLOCK) WHERE DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND Master_Code != 0      
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END 

				--M0017: Block 4 Insert into Temp Table for user mapped and update 

				IF (@MusicCount > 0)      
				BEGIN  
					DECLARE @status VARCHAR(2)
					SELECT @status = status FROM DM_Master_Import (NOLOCK)  WHERE DM_Master_Import_Code = @DM_Master_Import_Code

					SELECT @Step_No = @Step_No + 1, @Sub_Step_No = 1 , @Short_Status_Code = 'M0016'
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					IF(@status != 'I' )
					BEGIN 
						UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

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
					SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By FROM DM_Master_Log (NOLOCK)
					WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND ISNULL(Master_Code, 0) = 0  AND Mapped_By = 'U'

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END

				BEGIN 
					INSERT INTO #Temp_DM_Music_Title_UserMapped(IntCode)
					SELECT IntCode FROM DM_Music_Title (NOLOCK) 
					WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsSingerUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Singers
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Singers,',')
							WHERE LTRIM(RTRIM(ISNULL(Singers, ''))) <> ''
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Singers collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('SINGERS', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMovieAlbumUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Album
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Album,',')
							WHERE LTRIM(RTRIM(ISNULL(Movie_Album, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'MA' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsLyricistUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Lyricist
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',')
							WHERE LTRIM(RTRIM(ISNULL(Lyricist, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Lyricist collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('LYRICIST', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMusicDirectorUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Director
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',')
							WHERE LTRIM(RTRIM(ISNULL(Music_Director, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Music_Director collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsTitleLanguageUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Title_Language
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',')
							WHERE LTRIM(RTRIM(ISNULL(Title_Language, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Title_Language collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'ML' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMusicLabelUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Label
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',')
							WHERE LTRIM(RTRIM(ISNULL(Music_Label, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Music_Label collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'LB' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsGneresUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Genres
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Genres,',')
							WHERE LTRIM(RTRIM(ISNULL(Genres, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Genres collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'GE' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsStarCastUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Star_Cast
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',')
							WHERE LTRIM(RTRIM(ISNULL(Star_Cast, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMoviestarcastUserMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Star_Cast
							FROM #Temp_DM_Music_Title_UserMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Star_Cast,',')
							WHERE LTRIM(RTRIM(ISNULL(Movie_Star_Cast, ''))) <> '' AND IsUserMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_Usermapped ml ON a.Movie_Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_UserMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END
					UPDATE DMT SET DMT.Record_Status = 'R'
					FROM DM_Music_Title DMT
					INNER JOIN #Temp_DM_Music_Title_UserMapped TDMT ON TDMT.IntCode = DMT.IntCode
					WHERE TDMT.IsUserMappedValid = 'N'

					SELECT @Sub_Step_No = @Sub_Step_No + 1
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END    
				--M0018: Block 5 - Insert into Temp Table for System mapped and update

				 IF (@SystemMappingCount > 0)      
				 BEGIN     
			
				 DECLARE @SystemMAppingstatus VARCHAR(2),@Mapped_By CHAR(1)
				 SELECT @SystemMAppingstatus = status FROM DM_Master_Import  (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code

				 SELECT @Step_No = @Step_No + 1 , @Sub_Step_No = 1 , @Short_Status_Code = 'M0018'
				 EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				 IF(@SystemMAppingstatus != 'I' )
				 BEGIN 
					  UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    

					  SELECT @Sub_Step_No = @Sub_Step_No + 1 
					  EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					  END
					  SELECT @Mapped_By = Mapped_By FROM DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code
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
					SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By FROM DM_Master_Log (NOLOCK)
					WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND Master_Code > 0 AND Mapped_By = 'S'
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END

				BEGIN 

					INSERT INTO #Temp_DM_Music_Title_SystemMapped(IntCode)
					SELECT IntCode FROM DM_Music_Title (NOLOCK) 
					WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'

					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsSingerSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Singers
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Singers,',')
							WHERE LTRIM(RTRIM(ISNULL(Singers, ''))) <> ''
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Singers collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('SINGERS', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMovieAlbumSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Album
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Album,',')
							WHERE LTRIM(RTRIM(ISNULL(Movie_Album, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'MA' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsLyricistSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Lyricist
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',')
							WHERE LTRIM(RTRIM(ISNULL(Lyricist, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Lyricist collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('LYRICIST', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMusicDirectorSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Director
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',')
							WHERE LTRIM(RTRIM(ISNULL(Music_Director, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Music_Director collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsTitleLanguageSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Title_Language
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',')
							WHERE LTRIM(RTRIM(ISNULL(Title_Language, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Title_Language collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'ML' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMusicLabelSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Label
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',')
							WHERE LTRIM(RTRIM(ISNULL(Music_Label, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Music_Label collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'LB' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsGneresSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Genres
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Genres,',')
							WHERE LTRIM(RTRIM(ISNULL(Genres, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Genres collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'GE' 
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsStarCastSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Star_Cast
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',')
							WHERE LTRIM(RTRIM(ISNULL(Star_Cast, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode

					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					UPDATE mt SET mt.IsMoviestarcastSystemMappedValid = 'N'
					FROM (
						SELECT DISTINCT IntCode
						FROM (
							SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Star_Cast
							FROM #Temp_DM_Music_Title_SystemMapped D
							INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
							CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Star_Cast,',')
							WHERE LTRIM(RTRIM(ISNULL(Movie_Star_Cast, ''))) <> '' AND IsSystemMappedValid <> 'N'
						) AS a
						INNER JOIN #TempMasterLog_systemMapped ml ON a.Movie_Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
					) AS main
					INNER JOIN #Temp_DM_Music_Title_SystemMapped mt ON main.IntCode = mt.IntCode
				
					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

				END

					UPDATE DMT SET DMT.Record_Status = 'R'
					FROM DM_Music_Title DMT
					INNER JOIN #Temp_DM_Music_Title_SystemMapped TDMT ON TDMT.IntCode = DMT.IntCode
					WHERE TDMT.IsSystemMappedValid = 'N'

					SELECT @Sub_Step_No = @Sub_Step_No + 1 
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
	
				END
			END    
	END TRY 
		BEGIN CATCH
			SELECT @Process_Error_MSG = ERROR_MESSAGE(), @Short_Status_Code = 'All03'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		END CATCH 

		SET @StepCountOut = @Step_No

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
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DM_Music_Title_PIV]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END