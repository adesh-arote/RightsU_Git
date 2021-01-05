
CREATE PROCEDURE [dbo].[USP_DM_Title_PIV]      
	@DM_Master_Import_Code varchar(500),      
	@User_Code INT=143      
AS       
BEGIN      
	CREATE TABLE #Temp_Import      
	(      
	-- Temp Import Data      
		ID int identity(1,1),      
		DM_Master_Import_Code varchar(500),      
		Name Nvarchar(100),      
		Master_Type varchar(100),      
		Action_By int,      
		Action_On datetime,      
		Roles varchar(100),    
		--DM_Master_Log_Code Int,
		Master_Code INT,
		Mapped_By CHAR(1)
	)      
   -- Director Data      
	CREATE TABLE #Temp_Director      
	(       
		Name NVARCHAR(1000),      
		TalentCode INT,      
		RoleExists CHAR(1)      
	)      
	CREATE TABLE #Temp_S      
	( -- Star Cast Data      
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
      
	CREATE TABLE #Temp_Language      
	( -- Lyricist Data      
		Name NVARCHAR(1000),      
		LanguageCode INT,      
		RoleExists CHAR(1)      
	)   
	
	CREATE TABLE #Temp_Original_Language      
	( -- Lyricist Data      
		Name NVARCHAR(1000),      
		LanguageCode INT,      
		RoleExists CHAR(1)      
	)    
      
	CREATE TABLE #Temp_Deal_Type      
	( -- Lyricist Data      
		Name NVARCHAR(1000),      
		DealTypeCode INT,      
		RoleExists CHAR(1)      
	)    
	
	CREATE TABLE #Temp_Program_Category      
	( -- Lyricist Data      
		Name NVARCHAR(1000),      
		ProgramCategoryCode INT,      
		RoleExists CHAR(1)      
	)  
	
	CREATE TABLE #Temp_Import_Program_Category      
	( -- Lyricist Data      
		Name NVARCHAR(1000),      
		Master_Type CHAR(2)      
	)  
      
	IF OBJECT_ID('TEMPDB..#Temp_DM_Title_SystemMapped') IS NOT NULL
		DROP TABLE #Temp_DM_Title_SystemMapped

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title_UserMapped') IS NOT NULL
		DROP TABLE #Temp_DM_Title_UserMapped

	CREATE TABLE #Temp_DM_Title_UserMapped
	(
		DM_Title_Code INT,
		IsMusicDirectorUserMappedValid CHAR(1) DEFAULT('Y'),
		IsStarCastUserMappedValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelUserMappedValid CHAR(1) DEFAULT('Y'),
		IsTitleTypeUserMappedValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageUserMappedValid CHAR(1) DEFAULT('Y'),
		IsOriginalTitleLanguageUserMappedValid CHAR(1) DEFAULT('Y'),
		IsProgramCategoryUserMappedValid CHAR(1) DEFAULT('Y'),
		IsUserMappedValid AS CASE 
						WHEN 'YYYYYYY' = (IsMusicDirectorUserMappedValid + IsStarCastUserMappedValid + IsMusicLabelUserMappedValid + IsTitleTypeUserMappedValid 
						+ IsTitleLanguageUserMappedValid + IsOriginalTitleLanguageUserMappedValid + IsProgramCategoryUserMappedValid ) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)

	CREATE TABLE #Temp_DM_Title_SystemMapped
	(
		DM_Title_Code INT,
		IsMusicDirectorSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsStarCastSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsTitleTypeSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsOriginalTitleLanguageSystemMappedValid CHAR(1) DEFAULT('Y'),
		IsProgramCategorySystemMappedValid CHAR(1) DEFAULT('Y'),
		IsSystemMappedValid AS CASE 
						WHEN 'YYYYYYY' = (IsMusicDirectorSystemMappedValid + IsStarCastSystemMappedValid + IsMusicLabelSystemMappedValid + IsTitleTypeSystemMappedValid 
						+ IsTitleLanguageSystemMappedValid + IsOriginalTitleLanguageSystemMappedValid + IsProgramCategorySystemMappedValid ) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)

	DECLARE @DirectorRoleCode INT = 1, @StarCastRoleCode INT = 2, @Program_Category_Code INT ,@Is_Allow_Program_Category VARCHAR(2)     
	INSERT INTO #Temp_Music_Label(Name, RoleExists)      
	SELECT DISTINCT a.MusicLabelName, 'N' FROM      
	(      
		SELECT [Music_Label] MusicLabelName FROM DM_Title WHERE ISNULL([Music_Label], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a      
      
	INSERT INTO #Temp_Language(Name, RoleExists)      
	SELECT DISTINCT a.Language_Name, 'N' FROM      
	(      
		SELECT [Original Language (Hindi)] Language_Name FROM DM_Title WHERE ISNULL([Original Language (Hindi)], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a      

	INSERT INTO #Temp_Original_Language (Name, RoleExists)      
	SELECT DISTINCT a.Language_Name, 'N' FROM      
	(      
		SELECT [Original_Language] Language_Name FROM DM_Title WHERE ISNULL([Original_Language], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a 
      
	INSERT INTO #Temp_Deal_Type(Name, RoleExists)      
	SELECT DISTINCT a.Title_Type, 'N' FROM      
	(      
		SELECT [Title Type] Title_Type FROM DM_Title WHERE ISNULL([Title Type], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a      

	INSERT INTO #Temp_Program_Category(Name, RoleExists)      
	SELECT DISTINCT a.Program_Category, 'N' FROM      
	(      
		SELECT [Program Category] Program_Category FROM DM_Title WHERE ISNULL([Program Category], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a  

      
	INSERT INTO #Temp_Director(Name, RoleExists)      
	SELECT DISTINCT b.DirName, 'N' FROM      
	(      
		SELECT [Director Name] DirName FROM DM_Title WHERE ISNULL([Director Name], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a      
	CROSS APPLY      
	(      
		SELECT LTRIM(RTRIM(number)) DirName FROM DBO.fn_Split_withdelemiter(a.DirName, ',')      
	) AS b WHERE b.DirName <> ''      
      
	INSERT INTO #Temp_S(Name, RoleExists)      
	SELECT DISTINCT b.StarCast, 'N' FROM(      
		SELECT [Key Star Cast] StarCast FROM DM_Title WHERE ISNULL([Key Star Cast], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code      
	) AS a      
	CROSS APPLY      
	(      
	SELECT LTRIM(RTRIM(number)) StarCast FROM DBO.fn_Split_withdelemiter(a.StarCast, ',')      
	) AS b WHERE b.StarCast <> ''      
      
	SELECT @Program_Category_Code = Columns_Code FROM Extended_Columns WHERE UPPER(LOWER(Columns_Name)) = 'Program Category'
	SELECT @Is_Allow_Program_Category = Parameter_Value from System_Parameter_New WHERE Parameter_Name = 'Is_Allow_Program_Category'

	SELECT @User_Code = Upoaded_By FROM DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code


	IF(@Is_Allow_Program_Category = 'Y')
	BEGIN
		INSERT INTO #Temp_Import_Program_Category(Name,Master_Type)
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'PC' As DMMASTER_TYPE FROM #Temp_Program_Category    
			WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
			SELECT Columns_Value collate SQL_Latin1_General_CP1_CI_AS FROM Extended_Columns_Value 
			WHERE Columns_Code = @Program_Category_Code)
	END

	INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code,Mapped_By)    
	Select  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL,'U' From (    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' As DMMASTER_TYPE FROM #Temp_Director    
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent 
		where Talent_Code  In (select Talent_Code from Talent_Role where Role_Code = @DirectorRoleCode)   
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TA' As DMMASTER_TYPE FROM #Temp_S    
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent
		where Talent_Code  In (select Talent_Code from Talent_Role where Role_Code = @StarCastRoleCode)       
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'LB' As DMMASTER_TYPE FROM #Temp_Music_Label    
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Label    
	)    
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TL' As DMMASTER_TYPE FROM #Temp_Language    
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Language_Name collate SQL_Latin1_General_CP1_CI_AS FROM Language    
	)   
	UNION    
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'OL' As DMMASTER_TYPE FROM #Temp_Original_Language    
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Language_Name collate SQL_Latin1_General_CP1_CI_AS FROM Language    
	)    
	UNION      
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'TT' As DMMASTER_TYPE FROM #Temp_Deal_Type    
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Deal_Type_Name collate SQL_Latin1_General_CP1_CI_AS FROM Deal_Type    
	)    
	UNION   
		SELECT Name AS DMNAME, Master_Type AS DMMASTER_TYPE  FROM #Temp_Import_Program_Category
	
	) As a    
	
	Select Distinct NAME, Roles InTo #TempRolesDummy From (      
		SELECT LTRIM(RTRIM(Name)) As NAME, 'Director' As Roles FROM #Temp_Director     
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent   
		where Talent_Code  In (select Talent_Code from Talent_Role where Role_Code = @DirectorRoleCode)    
	)    
	UNION      
		SELECT LTRIM(RTRIM(Name)) As NAME, 'Star Cast' As Roles FROM #Temp_S     
		WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent    
			where Talent_Code  In (select Talent_Code from Talent_Role where Role_Code = @StarCastRoleCode)   
	)    
	) As a      
    

	Update t1 set t1.Roles = Stuff((    
		Select ', ' + t2.Roles from #TempRolesDummy t2      
		Where t1.Name = t2.NAME     
		For xml path('')), 1, 1, ''    
	)    
	From #Temp_Import t1      
	Where Master_Type = 'TA'  
	
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
	  SELECT @MusicCount = COUNT(*) FROM DM_Master_Log Where DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND ISNULL(Master_Code, 0) = 0      
	 END   
	  IF (@SystemMappingCount > 0)      
	 BEGIN      
	  SELECT @SystemMappingCount = COUNT(*) FROM DM_Master_Log Where DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND Master_Code != 0      
	 END 

	 IF (@MusicCount > 0)      
	 BEGIN  
	 declare @status Varchar(2)
	 select @status = status from DM_Master_Import  where DM_Master_Import_Code = @DM_Master_Import_Code
	 if(@status != 'I' )
	 Begin 
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
		INSERT INTO #Temp_DM_Title_UserMapped(DM_Title_Code)
		SELECT DM_Title_Code FROM DM_Title 
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'

		UPDATE mt SET mt.IsTitleTypeUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Title Type]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Title Type],',')
				WHERE LTRIM(RTRIM(ISNULL([Title Type], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Title Type] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TT'
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsProgramCategoryUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Program Category]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Program Category],',')
				WHERE LTRIM(RTRIM(ISNULL([Program Category], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Program Category] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'PC'
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsMusicDirectorUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Director Name]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Director Name],',')
				WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Director Name] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TA' AND  CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsStarCastUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Key Star Cast]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Key Star Cast],',')
				WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Key Star Cast] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TA' AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0  
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsTitleLanguageUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original Language (Hindi)]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original Language (Hindi)],',')
				WHERE LTRIM(RTRIM(ISNULL([Original Language (Hindi)], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Original Language (Hindi)] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TL'
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsOriginalTitleLanguageUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original_Language]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original_Language],',')
				WHERE LTRIM(RTRIM(ISNULL([Original_Language], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Original_Language] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'OL'
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsMusicLabelUserMappedValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Music_Label]
				FROM #Temp_DM_Title_UserMapped D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Music_Label],',')
				WHERE LTRIM(RTRIM(ISNULL([Music_Label], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog_Usermapped ml ON a.[Music_Label] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'LB'
		) AS main
		INNER JOIN #Temp_DM_Title_UserMapped mt ON main.DM_Title_Code = mt.DM_Title_Code
	END

		UPDATE DT SET DT.Record_Status = 'R'
		FROM DM_Title DT
		INNER JOIN #Temp_DM_Title_UserMapped TDMT ON TDMT.DM_Title_Code = DT.DM_Title_Code
		WHERE TDMT.IsUserMappedValid = 'N'

	END    
	

	 
     IF (@SystemMappingCount > 0)      
	 BEGIN     
	
	 declare @SystemMAppingstatus Varchar(2), @Mapped_By CHAR(1), @FileStatus Varchar(2)
	 select @SystemMAppingstatus = status from DM_Master_Import  where DM_Master_Import_Code = @DM_Master_Import_Code
	  select @FileStatus = status from DM_Master_Import  where DM_Master_Import_Code = @DM_Master_Import_Code

	 if(@SystemMAppingstatus != 'I' )
	 Begin 
		IF(@FileStatus = 'R')
		BEGIN
			UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
		END
		ELSE
		BEGIN
			UPDATE DM_Master_Import SET [Status] = 'SR' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
		END  
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

			INSERT INTO #Temp_DM_Title_SystemMapped(DM_Title_Code)
			SELECT DM_Title_Code FROM DM_Title 
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'

			UPDATE mt SET mt.IsTitleTypeSystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Title Type]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Title Type],',')
					WHERE LTRIM(RTRIM(ISNULL([Title Type], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Title Type] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TT' 
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsProgramCategorySystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Program Category]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Program Category],',')
					WHERE LTRIM(RTRIM(ISNULL([Program Category], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Program Category] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'PC' 
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsMusicLabelSystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Music_Label]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Music_Label],',')
					WHERE LTRIM(RTRIM(ISNULL([Music_Label], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Music_Label] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'LB' 
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsTitleLanguageSystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original Language (Hindi)]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original Language (Hindi)],',')
					WHERE LTRIM(RTRIM(ISNULL([Original Language (Hindi)], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Original Language (Hindi)] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TL' 
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsOriginalTitleLanguageSystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original_Language]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original_Language],',')
					WHERE LTRIM(RTRIM(ISNULL([Original_Language], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Original_Language] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'OL' 
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsMusicDirectorSystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Director Name]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Director Name],',')
					WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Director Name] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA' AND  CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsStarCastSystemMappedValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Key Star Cast]
					FROM #Temp_DM_Title_SystemMapped D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Key Star Cast],',')
					WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog_systemMapped ml ON a.[Key Star Cast] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA' AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0  
			) AS main
			INNER JOIN #Temp_DM_Title_SystemMapped mt ON main.DM_Title_Code = mt.DM_Title_Code
		END

		UPDATE DT SET DT.Record_Status = 'R'
		FROM DM_Title DT
		INNER JOIN #Temp_DM_Title_SystemMapped TDMT ON TDMT.DM_Title_Code = DT.DM_Title_Code
		WHERE TDMT.IsSystemMappedValid = 'N'

		 
		END
	 END    
	 
	Drop Table #TempRolesDummy      
        
    
	--DROP TABLE #Temp_Director      
	--DROP TABLE #Temp_S      
	--DROP TABLE #Temp_Music_Label      
	--DROP TABLE #Temp_Deal_Type   
	--DROP TABLE #Temp_Program_Category 
	--DROP TABLE #Temp_Language   
	--DROP TABLE #Temp_Original_Language
	--DROP TABLE #Temp_Import      
   
	IF OBJECT_ID('tempdb..#Temp_Deal_Type') IS NOT NULL DROP TABLE #Temp_Deal_Type
	IF OBJECT_ID('tempdb..#Temp_Director') IS NOT NULL DROP TABLE #Temp_Director
	IF OBJECT_ID('tempdb..#Temp_DM_Title_SystemMapped') IS NOT NULL DROP TABLE #Temp_DM_Title_SystemMapped
	IF OBJECT_ID('tempdb..#Temp_DM_Title_UserMapped') IS NOT NULL DROP TABLE #Temp_DM_Title_UserMapped
	IF OBJECT_ID('tempdb..#Temp_Import') IS NOT NULL DROP TABLE #Temp_Import
	IF OBJECT_ID('tempdb..#Temp_Import_Program_Category') IS NOT NULL DROP TABLE #Temp_Import_Program_Category
	IF OBJECT_ID('tempdb..#Temp_Language') IS NOT NULL DROP TABLE #Temp_Language
	IF OBJECT_ID('tempdb..#Temp_Music_Label') IS NOT NULL DROP TABLE #Temp_Music_Label
	IF OBJECT_ID('tempdb..#Temp_Original_Language') IS NOT NULL DROP TABLE #Temp_Original_Language
	IF OBJECT_ID('tempdb..#Temp_Program_Category') IS NOT NULL DROP TABLE #Temp_Program_Category
	IF OBJECT_ID('tempdb..#Temp_S') IS NOT NULL DROP TABLE #Temp_S
	IF OBJECT_ID('tempdb..#TempMasterLog_systemMapped') IS NOT NULL DROP TABLE #TempMasterLog_systemMapped
	IF OBJECT_ID('tempdb..#TempMasterLog_Usermapped') IS NOT NULL DROP TABLE #TempMasterLog_Usermapped
	IF OBJECT_ID('tempdb..#TempRolesDummy') IS NOT NULL DROP TABLE #TempRolesDummy

END