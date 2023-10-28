CREATE PROCEDURE [dbo].[USP_DM_Music_Title_PII]  
	@DM_Import_UDT DM_Import_UDT READONLY,  
	@DM_Master_Import_Code Int,
	@Users_Code INT
AS  
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DM_Music_Title_PII]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;  
		--DECLARE @DM_Master_Import_Code INT = 4887,@Users_Code INT = 136
		--DECLARE @DM_Import_UDT DM_Import_UDT
		--INSERT INTO @DM_Import_UDT(
		--	[Key],[value], [DM_Master_Type]
		--)
		--VALUES
		--	(4167,'New','MA')

		IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL
			DROP TABLE #Temp_DM

		IF OBJECT_ID('TEMPDB..#Temp_DM_Music_Title') IS NOT NULL
			DROP TABLE #Temp_DM_Music_Title

		IF OBJECT_ID('TEMPDB..#Temp_DM_Music_Title_Ignore') IS NOT NULL
			DROP TABLE #Temp_DM_Music_Title_Ignore

		IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL
			DROP TABLE #Temp_Talent_Role

		CREATE TABLE #Temp_DM  
		(  
			Master_Name NVarchar(2000),  
			DM_Master_Log_Code BIGINT,  
			DM_Master_Code NVARCHAR (100),  
			Master_Type NVARCHAR (100),
			Music_Album NVARCHAR (100),
			Is_New CHAR(1)
		)  
  
		CREATE TABLE #Temp_DM_Music_Title
		(
			IntCode INT,
			IsMovieAlbumValid CHAR(1) DEFAULT('Y'),
			IsSingerValid CHAR(1) DEFAULT('Y'),
			IsLyricistValid CHAR(1) DEFAULT('Y'),
			IsMusicDirectorValid CHAR(1) DEFAULT('Y'),
			IsTitleLanguageValid CHAR(1) DEFAULT('Y'),
			IsMusicLabelValid CHAR(1) DEFAULT('Y'),
			IsGneresValid CHAR(1) DEFAULT('Y'),
			IsStarCastValid CHAR(1) DEFAULT('Y'),
			IsMoviestarcastValid CHAR(1) DEFAULT('Y'),
			IsValid AS CASE 
							WHEN 'YYYYYYYYY' = (IsMovieAlbumValid + IsSingerValid + IsLyricistValid + IsMusicDirectorValid + IsTitleLanguageValid + 
												IsMusicLabelValid + IsGneresValid + IsStarCastValid + IsMoviestarcastValid) 
							THEN 'Y' 
							ELSE 'N' 
					END
		)

		CREATE TABLE #Temp_DM_Music_Title_Ignore
		(
			IntCode INT,
			IsMovieAlbumIgnore CHAR(1) DEFAULT('N'),
			IsSingerIgnore CHAR(1) DEFAULT('N'),
			IsLyricistIgnore CHAR(1) DEFAULT('N'),
			IsMusicDirectorIgnore CHAR(1) DEFAULT('N'),
			IsTitleLanguageIgnore CHAR(1) DEFAULT('N'),
			IsMusicLabelIgnore CHAR(1) DEFAULT('N'),
			IsGneresIgnore CHAR(1) DEFAULT('N'),
			IsStarCastIgnore CHAR(1) DEFAULT('N'),
			IsMoviestarcastIgnore CHAR(1) DEFAULT('N'),
			IsIgnore AS CASE 
							WHEN 'NNNNNNNNN' = (IsMovieAlbumIgnore + IsSingerIgnore + IsLyricistIgnore + IsMusicDirectorIgnore + IsTitleLanguageIgnore + 
												IsMusicLabelIgnore + IsGneresIgnore + IsStarCastIgnore + IsMoviestarcastIgnore) 
							THEN 'N' 
							ELSE 'Y' 
					END
		)

		DECLARE @Record_Code INT,
					@Record_Type CHAR = 'M',
					@Step_No INT = 1, 
					@Sub_Step_No INT = 1,
					@Loop_Counter INT = 0, 
					@Proc_Name VARCHAR(100),
					@Short_Status_Code VARCHAR(10),
					@Process_Error_Code VARCHAR(10),
					@Process_Error_MSG VARCHAR(50) = '',
					@StepCountIn INT,
					@StepCountOut INT,
					@Import_Log_Code INT

			
				SELECT	@Record_Code = @DM_Master_Import_Code,
					@Short_Status_Code = 'All01', 
					@Proc_Name = 'USP_DM_Music_Title_PII'

				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		DECLARE @SingerRoleCode INT = 13, @LyricistRoleCode INT = 15, @MusicComposerRoleCode INT = 21, @StarCastRoleCode INT = 2  
  
		INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Is_New,Music_Album)  
		SELECT distinct [Name], [Key], [value], [DM_Master_Type], CASE WHEN  ISNULL(RTRIM(LTRIM([value])),'') = 'NEW' THEN 'Y' ELSE 'N' END AS [Is_New],dm.[Music_Album]
		FROM @DM_Import_UDT udt  
		Inner Join DM_Master_Log dm (NOLOCK) on dm.DM_Master_Log_Code = udt.[Key]  

		SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		IF EXISTS(SELECT TOP 1 DM_Master_Log_Code FROM #Temp_DM WHERE Is_New = 'Y')  
		BEGIN  
			Declare @CurDate DateTime = GetDate();  
  
			INSERT INTO Talent(Talent_Name, Gender, Is_Active, Inserted_By, Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 'N', 'Y', @Users_Code, @CurDate FROM  #Temp_DM TD  
			WHERE TD.Master_Type = 'TA' AND Is_New = 'Y'
    
			UPDATE TD SET TD.DM_Master_Code = T.Talent_Code   
			FROM #Temp_DM TD  
			INNER JOIN Talent T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Talent_Name collate SQL_Latin1_General_CP1_CI_AS 
			AND TD.Master_Type = 'TA'  
		
			INSERT INTO Music_Label(Music_Label_Name, Is_Active, Inserted_By, Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
			WHERE TD.Master_Type = 'LB' AND Is_New = 'Y' AND 
			TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label (NOLOCK))
    
		
			UPDATE TD SET TD.DM_Master_Code = ML.Music_Label_Code   
			FROM #Temp_DM TD  
			INNER JOIN Music_Label ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type = 'LB'
    
			INSERT INTO Genres(Genres_Name, Is_Active,Inserted_By, Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
			WHERE TD.Master_Type = 'GE' AND Is_New = 'Y'  AND 
			TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Genres_Name  COLLATE SQL_Latin1_General_CP1_CI_AS FROM Genres (NOLOCK))

			UPDATE TD SET TD.DM_Master_Code = G.Genres_Code   
			FROM #Temp_DM TD  
			INNER JOIN Genres G ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = G.Genres_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type = 'GE' 
    
			INSERT INTO Music_Album(Music_Album_Name, Album_Type, Is_Active, Inserted_By, Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 
			CASE WHEN DMT.Music_Album_Type = 'Movie' THEN 'M'
			ELSE 'A' END AS Album_Type, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD
			INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code
			WHERE TD.Master_Type = 'MA' AND DMT.Music_Album_Type = 'Album' AND Is_New = 'Y' AND
			TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Album_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Album (NOLOCK))

			UPDATE TD SET TD.DM_Master_Code = Ma.Music_Album_Code    
			FROM #Temp_DM TD  
			INNER JOIN Music_Album MA ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = MA.Music_Album_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type  = 'MA' AND TD.Music_Album = 'Album'

			UPDATE TD SET TD.DM_Master_Code = TA.Title_Code
			FROM #Temp_DM TD
			INNER JOIN Title TA ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = TA.Title_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type  = 'MA' AND TD.Music_Album = 'Movie'

			UPDATE TD SET TD.DM_Master_Code = TA.Title_Code
			FROM #Temp_DM TD
			INNER JOIN Title TA ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = TA.Title_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type  = 'MA' AND TD.Music_Album = 'Show'
    
			INSERT INTO Music_Language(Language_Name, Is_Active,Inserted_By, Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
			WHERE TD.Master_Type = 'ML' AND Is_New = 'Y' AND
			TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Language_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Language (NOLOCK))
    
			UPDATE TD SET TD.DM_Master_Code = ML.Music_Language_Code    
			FROM #Temp_DM TD  
			INNER JOIN Music_Language ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Language_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type = 'ML' 
    
			INSERT INTO Music_Theme(Music_Theme_Name, Is_Active,Inserted_By, Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
			WHERE TD.Master_Type = 'MT' AND Is_New = 'Y' AND
			TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (select Music_Theme_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Theme (NOLOCK))
    
			UPDATE TD SET TD.DM_Master_Code = MT.Music_Theme_Code    
			FROM #Temp_DM TD  
			INNER JOIN Music_Theme MT ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = MT.Music_Theme_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type = 'MT' 		
		
			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		END  
	 
			UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
			FROM DM_Master_Log D
			INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'
		
			UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
			FROM DM_Master_Log D
			INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'
		
			UPDATE D SET D.Mapped_By = 'V', D.Action_By = @Users_Code, D.Action_On = GETDATE()
			FROM DM_Master_Log D
			INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code > '0' AND D.Mapped_By = 'S'

			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		BEGIN  
			CREATE TABLE #Temp_Talent_Role  
			(  
				Talent_Code INT,  
				Role_Code INT,  
				[Name] NVARCHAR(2000)  
			)  
  
			INSERT INTO #Temp_Talent_Role(Talent_Code, Role_Code, [Name])  
			SELECT DISTINCT DM_Master_Code, Role_Code, [Master_Name] FROM (  
			SELECT DM_Master_Code, @SingerRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T  
			INNER JOIN DM_Master_Log DM (NOLOCK) ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles Like '%Singers%' AND DM.Master_Type = 'TA'  
			UNION  
			SELECT DM_Master_Code, @LyricistRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T  
			INNER JOIN DM_Master_Log DM (NOLOCK) ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles like '%Lyricist%' AND DM.Master_Type = 'TA'  
			UNION  
			SELECT DM_Master_Code, @MusicComposerRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T  
			INNER JOIN DM_Master_Log DM (NOLOCK) ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles like '%Composer%' AND DM.Master_Type = 'TA'  
			UNION  
			SELECT DM_Master_Code, @StarCastRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T  
			INNER JOIN DM_Master_Log DM (NOLOCK) ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles like '%Cast%' AND DM.Master_Type = 'TA'  
			) AS A WHERE a.DM_Master_Code NOT IN (  
			SELECT tr.Talent_Code FROM Talent_Role tr (NOLOCK) WHERE  tr.Role_Code = a.Role_Code AND tr.Talent_Code IS NOT NULL  
			) AND a.DM_Master_Code != 'Y' 
		 
			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

			DECLARE @count INt
			SELECT @count = COUNT(*) FROM #Temp_Talent_Role

			IF(@count > 0)	
			BEGIN
				ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del  
				ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS  
  
				INSERT INTO Talent_Role(Talent_Code, Role_Code)  
				SELECT Talent_Code, Role_Code FROM #Temp_Talent_Role   
  
				ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del  
				ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS  
  
				INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)  
				SELECT Distinct [Name] AS Original_Title, [Name] AS Title_Name, [Name] AS Synopsis,   
				(SELECT Deal_Type_Code FROM [Role] a (NOLOCK) WHERE a.Role_Code = tl.Role_Code) AS Deal_Type_Code, GetDate() AS Inserted_On,   
					'Y' As Is_Active, Talent_Code Reference_Key, 'T' AS Reference_Flag   
				FROM #Temp_Talent_Role tl  

				SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

			END
			DROP TABLE #Temp_Talent_Role  
		END  

		BEGIN
			IF OBJECT_ID('TEMPDB..#TempMasterLog') IS NOT NULL
				DROP TABLE #TempMasterLog

			CREATE TABLE #TempMasterLog
			(
				Name NVARCHAR(500), 
				Master_Type VARCHAR(10), 
				Master_Code VARCHAR(1000), 
				Roles VARCHAR(100),
				Is_Ignore CHAR(1)
			)

			INSERT INTO #TempMasterLog(Name, Master_Type, Master_Code, Roles, Is_Ignore)
			SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore FROM DM_Master_Log (NOLOCK)
			WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND ISNULL(Master_Code, 0) = 0  

			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		END

		DECLARE @Master_Name NVARCHAR(1000) = ''

		BEGIN
			DECLARE CUR_DM_Music_Title_Ignore CURSOR LOCAL For SELECT Master_Name from #Temp_DM
			OPEN CUR_DM_Music_Title_Ignore  

			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

			FETCH NEXT FROM CUR_DM_Music_Title_Ignore InTo @Master_Name
			WHILE @@FETCH_STATUS<>-1    
		BEGIN    
                                            
			IF(@@FETCH_STATUS<>-2)                                                            
			BEGIN                                                                                                                           
				PRINT 'BEGIN Start'   

					INSERT INTO #Temp_DM_Music_Title_Ignore(IntCode)
					SELECT IntCode FROM DM_Music_Title (NOLOCK) 
					WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_status <> 'N' AND 
					(
						Movie_Album like '%' + @Master_Name + '%' OR
						Singers like '%' + @Master_Name + '%' OR
						Lyricist like '%' + @Master_Name + '%' OR
						Music_Director like '%' + @Master_Name + '%' OR
						Title_Language like '%' + @Master_Name + '%' OR
						Music_Label like '%' + @Master_Name + '%' OR
						Genres like '%' + @Master_Name + '%' OR
						star_Cast like '%' + @Master_Name + '%' OR
						Theme like '%' + @Master_Name + '%' OR
						Movie_Star_Cast like '%' + @Master_Name + '%' 
					)
					AND IntCode NOT IN (SELECT IntCode FROM #Temp_DM_Music_Title_Ignore)
				FETCH NEXT FROM CUR_DM_Music_Title_Ignore INTO @Master_Name
			END    
		END
			CLOSE CUR_DM_Music_Title_Ignore    
			DEALLOCATE CUR_DM_Music_Title_Ignore   
		
			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		END

		BEGIN -- Ignore

				UPDATE mt SET mt.IsSingerIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Singers
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Singers,',')
						WHERE LTRIM(RTRIM(ISNULL(Singers, ''))) <> ''
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Singers collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'TA' AND CHARINDEX('SINGERS', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode

				UPDATE mt SET mt.IsMovieAlbumIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Album
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Album,',')
						WHERE LTRIM(RTRIM(ISNULL(Movie_Album, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS
					AND ml.Master_Type = 'MA' AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode

				UPDATE mt SET mt.IsLyricistIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Lyricist
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',')
						WHERE LTRIM(RTRIM(ISNULL(Lyricist, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Lyricist collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'TA' AND CHARINDEX('LYRICIST', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore= 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode
			
				UPDATE mt SET mt.IsMusicDirectorIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Director
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',')
						WHERE LTRIM(RTRIM(ISNULL(Music_Director, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Music_Director collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'TA' AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode
			
				UPDATE mt SET mt.IsTitleLanguageIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Title_Language
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',')
						WHERE LTRIM(RTRIM(ISNULL(Title_Language, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Title_Language collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'ML' AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode
			
				UPDATE mt SET mt.IsMusicLabelIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Label
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',')
						WHERE LTRIM(RTRIM(ISNULL(Music_Label, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Music_Label collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS
					AND ml.Master_Type = 'LB' AND ml.Is_Ignore= 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode

				UPDATE mt SET mt.IsGneresIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Genres
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Genres,',')
						WHERE LTRIM(RTRIM(ISNULL(Genres, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Genres collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'GE' AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode
			
				UPDATE mt SET mt.IsStarCastIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Star_Cast
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',')
						WHERE LTRIM(RTRIM(ISNULL(Star_Cast, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode

				UPDATE mt SET mt.IsMoviestarcastIgnore = 'Y'
				FROM (
					SELECT DISTINCT IntCode
					FROM (
						SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Star_Cast
						FROM #Temp_DM_Music_Title_Ignore D
						INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
						CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Star_Cast,',')
						WHERE LTRIM(RTRIM(ISNULL(Movie_Star_Cast, ''))) <> '' AND IsIgnore <> 'Y'
					) AS a
					INNER JOIN #TempMasterLog ml ON a.Movie_Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
					AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore = 'Y'
				) AS main
				INNER JOIN #Temp_DM_Music_Title_Ignore mt ON main.IntCode = mt.IntCode
			END
			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

			UPDATE DMT SET DMT.Record_Status = 'N', DMT.Is_Ignore = 'Y'
			FROM DM_Music_Title DMT
			INNER JOIN #Temp_DM_Music_Title_Ignore TDMT ON TDMT.IntCode = DMT.IntCode
			WHERE TDMT.IsIgnore = 'Y'

			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		BEGIN
			DECLARE CUR_DM_Music_Title CURSOR For SELECT Master_Name from #Temp_DM
			OPEN CUR_DM_Music_Title  

			FETCH NEXT FROM CUR_DM_Music_Title InTo @Master_Name
			WHILE @@FETCH_STATUS<>-1    
			BEGIN                            
				IF(@@FETCH_STATUS<>-2)                                                            
				BEGIN                                                                                                                           
					PRINT 'BEGIN Start'   
						INSERT INTO #Temp_DM_Music_Title(IntCode)
						SELECT IntCode FROM DM_Music_Title (NOLOCK) 
						WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_status <> 'N' AND 
						(
							Movie_Album like '%' + @Master_Name + '%' OR
							Singers like '%' + @Master_Name + '%' OR
							Lyricist like '%' + @Master_Name + '%' OR
							Music_Director like '%' + @Master_Name + '%' OR
							Title_Language like '%' + @Master_Name + '%' OR
							Music_Label like '%' + @Master_Name + '%' OR
							Genres like '%' + @Master_Name + '%' OR
							star_Cast like '%' + @Master_Name + '%' OR
							Theme like '%' + @Master_Name + '%' OR
							Movie_Star_Cast like '%' + @Master_Name + '%' 
						)
						AND IS_Ignore ='N' AND IntCode NOT IN (SELECT IntCode FROM #Temp_DM_Music_Title)

					FETCH NEXT FROM CUR_DM_Music_Title INTO @Master_Name
				END    
			END
			CLOSE CUR_DM_Music_Title    
			DEALLOCATE CUR_DM_Music_Title   
		
			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		END

		BEGIN 

			UPDATE mt SET mt.IsSingerValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Singers
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Singers,',')
					WHERE LTRIM(RTRIM(ISNULL(Singers, ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Singers collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('SINGERS', UPPER(ml.Roles)) > 0
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode

			UPDATE mt SET mt.IsMovieAlbumValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Album
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Album,',')
					WHERE LTRIM(RTRIM(ISNULL(Movie_Album, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'MA' 
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode
		
			UPDATE mt SET mt.IsLyricistValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Lyricist
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',')
					WHERE LTRIM(RTRIM(ISNULL(Lyricist, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Lyricist collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('LYRICIST', UPPER(ml.Roles)) > 0
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode
		
			UPDATE mt SET mt.IsMusicDirectorValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Director
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',')
					WHERE LTRIM(RTRIM(ISNULL(Music_Director, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Music_Director collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA' AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode
		
			UPDATE mt SET mt.IsTitleLanguageValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Title_Language
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',')
					WHERE LTRIM(RTRIM(ISNULL(Title_Language, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Title_Language collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'ML' 
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode
		
			UPDATE mt SET mt.IsMusicLabelValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Music_Label
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',')
					WHERE LTRIM(RTRIM(ISNULL(Music_Label, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Music_Label collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'LB' 
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode

			UPDATE mt SET mt.IsGneresValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Genres
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Genres,',')
					WHERE LTRIM(RTRIM(ISNULL(Genres, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Genres collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'GE' 
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode
		
			UPDATE mt SET mt.IsStarCastValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Star_Cast
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',')
					WHERE LTRIM(RTRIM(ISNULL(Star_Cast, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode

			UPDATE mt SET mt.IsMoviestarcastValid = 'N'
			FROM (
				SELECT DISTINCT IntCode
				FROM (
					SELECT Distinct D.IntCode, LTRIM(RTRIM(number)) AS Movie_Star_Cast
					FROM #Temp_DM_Music_Title D
					INNER JOIN DM_Music_Title DMT (NOLOCK) ON DMT.IntCode = D.IntCode
					CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Movie_Star_Cast,',')
					WHERE LTRIM(RTRIM(ISNULL(Movie_Star_Cast, ''))) <> '' AND IsValid <> 'N'
				) AS a
				INNER JOIN #TempMasterLog ml ON a.Movie_Star_Cast collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS AND ml.Master_Type = 'TA'  AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0
			) AS main
			INNER JOIN #Temp_DM_Music_Title mt ON main.IntCode = mt.IntCode

			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

		END
	
			UPDATE DMT SET DMT.Record_Status = 'N'
			FROM DM_Music_Title DMT
			INNER JOIN #Temp_DM_Music_Title TDMT ON TDMT.IntCode = DMT.IntCode
			WHERE TDMT.IsValid = 'Y'
	    
			SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'M0023'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG


		DECLARE @ResolveCount  Int , @TotalCount INT
		SELECT @ResolveCount = COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
		SELECT @TotalCount = COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code
		IF(@ResolveCount = @TotalCount)
		BEGIN
			UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
		END

		IF OBJECT_ID('tempdb..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
		IF OBJECT_ID('tempdb..#Temp_DM_Music_Title') IS NOT NULL DROP TABLE #Temp_DM_Music_Title
		IF OBJECT_ID('tempdb..#Temp_DM_Music_Title_Ignore') IS NOT NULL DROP TABLE #Temp_DM_Music_Title_Ignore
		IF OBJECT_ID('tempdb..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role
		IF OBJECT_ID('tempdb..#TempMasterLog') IS NOT NULL DROP TABLE #TempMasterLog
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DM_Music_Title_PII]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END