CREATE PROCEDURE [dbo].[USP_DM_Music_Title_PIII]    
    @DM_Master_Import_Code Int    
AS    
BEGIN    
	CREATE TABLE #Temp_Talents    
	(    
		IntCode INT,
		Talent_Code INT,    
		Talent_Name NVARCHAR(1000),    
		Roles VARCHAR(100),    
		Role_Code INT    
	)    
	CREATE TABLE #Temp_Music_Label    
	(    
		IntCode INT,
		Music_Label_Code INT,    
		Music_Label_Name NVARCHAR(1000),    
		Effective_From DATETIME    
	)    
	CREATE TABLE #Temp_Music_Language    
	(    
		IntCode INT,
		Music_Language_Code INT,    
		Music_Language_Name NVARCHAR(1000)    
	)    
	CREATE TABLE #Temp_Music_Theme    
	(    
		IntCode INT,
		Music_Theme_Code INT,    
		Music_Theme_Name NVARCHAR(1000)    
	)    
	CREATE TABLE #Temp_Genre   
	(    
		IntCode INT,
		Genre_Code INT,    
		Genre_Name NVARCHAR(1000)    
	)   
	CREATE TABLE #Temp_Music_Album  
	(    
		IntCode INT,
		Music_Album_Code INT,    
		Music_Album_Name NVARCHAR(1000)    
	)   
	CREATE TABLE #Temp_Music_Album_Talent    
	(    
		Music_Album_Code INT,    
		Music_Album_Name NVARCHAR(1000),    
		Talent_Code VARCHAR(100),    
		Role_Code INT    
	)    
     
	DECLARE @SingerRoleCode INT = 13, @LyricistRoleCode INT = 15, @MusicComposerRoleCode INT = 21, @StarCastRoleCode INT = 2    
      
	INSERT INTO #Temp_Talents (IntCode, Talent_Code, Talent_Name, Roles, Role_Code)    
	SELECT Distinct 0 As IntCode, T.Talent_Code, T.Talent_Name, R.Role_Name, R.Role_Code FROM Talent T    
	INNER JOIN Talent_Role TR ON T.Talent_Code = TR.Talent_Code    
	INNER JOIN Role R ON TR.Role_Code = R.Role_Code    
	UNION     
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name, 'Singer', 13 FROM DM_Master_Log WHERE Master_Type = 'TA' AND ISNULL(Master_Code, 0) > 0 AND Roles LIKE '%Singers%' AND DM_Master_Import_Code like @DM_Master_Import_Code     
	UNION    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name, 'Lyricist', 15 FROM DM_Master_Log WHERE Master_Type = 'TA' AND ISNULL(Master_Code, 0) > 0 AND Roles LIKE '%Lyricist%' AND DM_Master_Import_Code like @DM_Master_Import_Code   
	UNION    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name, 'Music Composer', 21 FROM DM_Master_Log WHERE Master_Type = 'TA' AND ISNULL(Master_Code, 0) > 0 AND Roles LIKE '%Composer%' AND DM_Master_Import_Code like @DM_Master_Import_Code      
	UNION    
	SELECT DM_Master_Log_Code AS IntCode,Master_Code, Name, 'Star Cast', 2 FROM DM_Master_Log WHERE Master_Type = 'TA' AND ISNULL(Master_Code, 0) > 0 AND Roles LIKE '%Cast%'  AND DM_Master_Import_Code like @DM_Master_Import_Code  
      
	INSERT INTO #Temp_Music_Language (IntCode, Music_Language_Code, Music_Language_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='ML' AND ISNULL(Master_Code, 0) > 0 AND DM_Master_Import_Code like @DM_Master_Import_Code         
	Union    
	SELECT 0 As IntCode, Music_Language_Code, Language_Name FROM Music_Language    
            
	INSERT INTO #Temp_Music_Theme (IntCode, Music_Theme_Code, Music_Theme_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='MT' AND ISNULL(Master_Code, 0) > 0 AND DM_Master_Import_Code like @DM_Master_Import_Code       
	UNION    
	SELECT 0 As IntCode, Music_Theme_Code, Music_Theme_Name FROM Music_Theme    
    
	INSERT INTO #Temp_Music_Label (IntCode, Music_Label_Code, Music_Label_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='LB' AND ISNULL(Master_Code, 0) > 0  AND DM_Master_Import_Code like @DM_Master_Import_Code      
	UNION    
	SELECT 0 As IntCode, Music_Label_Code, Music_Label_Name FROM Music_Label  
  
	INSERT INTO #Temp_Genre (IntCode, Genre_Code, Genre_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='GE' AND ISNULL(Master_Code, 0) > 0  AND DM_Master_Import_Code like @DM_Master_Import_Code      
	UNION    
	SELECT 0 As IntCode, Genres_Code, Genres_Name FROM Genres   
   
	INSERT INTO #Temp_Music_Album (IntCode, Music_Album_Code, Music_Album_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='MA' AND ISNULL(Master_Code, 0) > 0   AND DM_Master_Import_Code like @DM_Master_Import_Code     
	UNION    
	SELECT 0 As IntCode, Music_Album_Code, Music_Album_Name FROM Music_Album   
	--  --Cursor    
	DECLARE @User_Code Int = 0;
	BEGIN TRY
	BEGIN TRANSACTION
	          
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
		FROM DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'   
		OPEN CUR_Title    
    
		FETCH NEXT FROM CUR_Title InTo @Music_TitleName, @Movie_Album, @Title_Type, @Title_Language, @Year_of_Release, @Duration,  @Singers, @Lyricist,@Music_Director    
		,@Music_Label ,@Genres ,@Star_Cast,@Music_Version,@Effective_Start_Date,@Theme,@Music_Tag, @Movie_Star_Cast, @Music_Album_Type    
  
		WHILE @@FETCH_STATUS<>-1    
		BEGIN    
                                            
			IF(@@FETCH_STATUS<>-2)                                                            
			BEGIN                                                                                                                           
				PRINT 'BEGIN Start'    
               
				DECLARE @Music_type_Code INT , @Title_Language_code INT , @Music_Title_Code INT, @Music_Label_Code INT  , @Genres_Code INT ,@Music_Album_Code INT, @Version_Code INT=null,@Music_Album_Name nvarchar(500)    
				SELECT @Music_type_Code = Music_Type_Code FROM Music_Type WHERE LTRIM(RTRIM(Music_Type_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Title_Type, ''))) collate SQL_Latin1_General_CP1_CI_AS    
				-- SELECT @Title_Language_code = Music_Language_Code FROM Music_Language WHERE LTRIM(RTRIM(Language_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Title_Language, ''))) collate SQL_Latin1_General_CP1_CI_AS           
				SELECT Top 1 @Music_Label_Code = Music_Label_Code FROM #Temp_Music_Label WHERE LTRIM(RTRIM(Music_Label_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Label, '')))    collate SQL_Latin1_General_CP1_CI_AS ORDER BY IntCode DESC      
				SELECT @Genres_Code = Genre_Code FROM #Temp_Genre WHERE LTRIM(RTRIM(Genre_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Genres, '')))  collate SQL_Latin1_General_CP1_CI_AS  ORDER BY IntCode DESC  
    
				SELECT @Music_Album_Code = Music_Album_Code FROM #Temp_Music_Album WHERE LTRIM(RTRIM(Music_Album_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Movie_Album, ''))) COLLATE SQL_Latin1_General_CP1_CI_AS ORDER BY IntCode DESC 
				SELECT @Music_Album_Name = Music_Album_Name FROM #Temp_Music_Album WHERE LTRIM(RTRIM(Music_Album_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Movie_Album, ''))) COLLATE SQL_Latin1_General_CP1_CI_AS ORDER BY IntCode DESC 
			
				SELECT @User_Code =  Upoaded_By FROM DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code   
               
				SELECT @Version_Code = Music_Type_Code FROM Music_Type WHERE LTRIM(RTRIM(Music_Type_Name)) collate SQL_Latin1_General_CP1_CI_AS =    
				LTRIM(RTRIM(ISNULL(@Music_Version, ''))) collate SQL_Latin1_General_CP1_CI_AS    
				AND LTRIM(RTRIM([Type])) collate SQL_Latin1_General_CP1_CI_AS = 'MV' collate SQL_Latin1_General_CP1_CI_AS    
    
				print @Music_Album_Code    
				--PRINT @Music_Version +''+Convert(VarCHAR(1000),@Version_Code)    
				IF(ISNULL(@Version_Code, 0) = 0)    
				BEGIN    
					SELECT @Version_Code = Music_Type_Code FROM Music_Type WHERE Type = 'MV' AND Music_Type_Name ='Original'    
				END    
				DECLARE @titleCount INt    
				SELECT @titleCount = COUNT(*) FROM Music_Title WHERE Music_Title_Name = LTRIM(RTRIM(@Music_TitleName)) AND Movie_Album =  LTRIM(RTRIM(@Music_Album_Name))
				IF(@titleCount = 0)    
				BEGIN    
					INSERT INTO Music_Title    
					(    
					Music_Type_Code, Music_Title_Name, Movie_Album, Release_Year, Duration_In_Min, is_active,Inserted_By,Inserted_On,Last_UpDated_Time,Genres_Code,Music_Version_Code,Music_Tag,Music_Album_Code, Public_Domain    
					)    
					VALUES    
					(    
					@Music_type_Code, LTRIM(RTRIM(@Music_TitleName)), LTRIM(RTRIM(@Music_Album_Name)), @Year_of_Release, @Duration, 'Y',@User_Code,GETDATE(),GETDATE(),@Genres_Code,@Version_Code,@Music_Tag,@Music_Album_Code,'N'    
					)    
       
					SELECT @Music_Title_Code = IDENT_CURRENT('Music_Title')    
               
            --------------Music Title Talent Insert    
    
					INSERT INTO Music_Title_Talent(Music_Title_Code, Talent_Code, Role_code)    
					SELECT DISTINCT @Music_Title_Code, tt.Talent_Code, tt.Role_Code FROM (    
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Name, @SingerRoleCode AS RoleCode FROM DBO.fn_Split_withdelemiter(@Singers, ',') WHERE number <> ''    
					UNION    
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Name, @LyricistRoleCode AS RoleCode FROM DBO.fn_Split_withdelemiter(@Lyricist, ',') WHERE number <> ''    
					UNION    
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Name, @MusicComposerRoleCode AS RoleCode FROM DBO.fn_Split_withdelemiter(@Music_Director, ',') WHERE number <> ''    
					UNION    
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Name, @StarCastRoleCode AS RoleCode FROM DBO.fn_Split_withdelemiter(@Star_Cast, ',') WHERE number <> ''    
					) AS a    
					INNer JOIN #Temp_Talents tt On tt.Talent_Name collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.Name)) collate SQL_Latin1_General_CP1_CI_AS    
					AND tt.Role_Code = a.RoleCode    
         
					INSERT INTO Music_Title_Theme(Music_Title_Code,Music_Theme_Code)      
					SELECT @Music_Title_Code, b.Music_Theme_Code FROM DBO.fn_Split_withdelemiter(@Theme, ',') AS a    
					INNER JOIN #Temp_Music_Theme b On LTRIM(RTRIM(Replace(a.number, ' ', ' ')))  COLLATE SQL_Latin1_General_CP1_CI_AS = b.Music_Theme_Name  COLLATE SQL_Latin1_General_CP1_CI_AS    
					WHERE number <> ''    
    
					INSERT INTO Music_Title_Language(Music_Title_Code, Music_Language_Code)      
					SELECT @Music_Title_Code, b.Music_Language_Code FROM DBO.fn_Split_withdelemiter(@Title_Language, ',') As a    
					INNER JOIN #Temp_Music_Language b On LTRIM(RTRIM(Replace(a.number, ' ', ' ')))  COLLATE SQL_Latin1_General_CP1_CI_AS = b.Music_Language_Name  COLLATE SQL_Latin1_General_CP1_CI_AS    
					WHERE number <> ''    
        
					DECLARE @Effective_From VARCHAR(100)    
					SELECT TOP 1 @Effective_From =  CONVERT(DATETIME,Parameter_Value,103) FROM System_Parameter_New WHERE Parameter_Name = 'Music_Label_Effective_From'    
       
					INSERT INTO Music_Title_Label(Music_Label_Code, Music_Title_Code, Effective_From)    
					SELECT @Music_Label_Code, @Music_Title_Code, CASE WHEN ISNULL(LTRIM(RTRIM(@Effective_Start_Date)),'')='' THEN  CONVERT(DATETIME,@Effective_From,103) ELSE CONVERT(DATETIME,@Effective_Start_Date,103) END    
       
					INSERT INTO Music_Album_Talent (Music_Album_Code,Talent_Code,Role_Code)    
					SELECT @Music_Album_Code, b.Talent_Code, @StarCastRoleCode FROM DBO.fn_Split_withdelemiter(@Movie_Star_Cast, ',') As a    
					INNER JOIN #Temp_Talents b  On LTRIM(RTRIM(Replace(a.number, ' ', ' ')))  COLLATE SQL_Latin1_General_CP1_CI_AS = b.Talent_Name  COLLATE SQL_Latin1_General_CP1_CI_AS    
					WHERE number <> '' AND b.Talent_Code NOT IN (SELECT mat.Talent_Code FROM Music_Album_Talent mat WHERE mat.Music_Album_Code = @Music_Album_Code) and b.Role_Code = @StarCastRoleCode    
                    
					DECLARE @TitleType VARCHAR(500)    
					SELECT @TitleType = Parameter_Value FROM System_Parameter_New where Parameter_Name='Title_Type_Music'    
				END      
				PRINT  'Inserted Into Music Title_Talent'    
				--    ------------ Update DM_Music_Title    
				UPDATE DM_Music_Title SET Record_Status = 'C'  WHERE [Music_Title_Name] COLLATE SQL_Latin1_General_CP1_CI_AS = @Music_TitleName COLLATE SQL_Latin1_General_CP1_CI_AS AND DM_Master_Import_Code = @DM_Master_Import_Code   
				PRINT  'UPDATE DM_Music_Title '       
             
				FETCH NEXT FROM CUR_Title INTO @Music_TitleName, @Movie_Album, @Title_Type, @Title_Language, @Year_of_Release, @Duration,  @Singers, @Lyricist,    
				@Music_Director,@Music_Label,@Genres,@Star_Cast,@Music_Version,@Effective_Start_Date,@Theme,@Music_Tag,@Movie_Star_Cast,@Music_Album_Type    
    
			END    
		END    
		CLOSE CUR_Title    
		DEALLOCATE CUR_Title    
		DROP TABLE #Temp_Talents    
		DROP TABLE #Temp_Music_Album_Talent    
		DROP TABLE #Temp_Music_Label    
		DROP TABLE #Temp_Music_Language    
		DROP TABLE #Temp_Music_Theme    
     
    
		--IF EXISTS(SELECT Record_Status='C' FROM DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code)    
		--BEGIN    
			UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
		--END    
	COMMIT
	END TRY
	BEGIN CATCH
	ROLLBACK
		UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
	END CATCH
    
END    