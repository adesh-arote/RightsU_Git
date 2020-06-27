alter PROCEDURE [dbo].[USP_DM_Title_PII]
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code Int
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @DM_Master_Import_Code INT = 115,@Users_Code Int = 143
	--DECLARE @DM_Import_UDT DM_Import_UDT
	--INSERT INTO @DM_Import_UDT(
	--	[Key],[value], [DM_Master_Type]
	--)
	--VALUES
	--	(5526,13,'PC')
	IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL
		DROP TABLE #Temp_DM

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title') IS NOT NULL
		DROP TABLE #Temp_DM_Title

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title_Ignore') IS NOT NULL
		DROP TABLE #Temp_DM_Title_Ignore

	IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL
		DROP TABLE #Temp_Talent_Role


	CREATE TABLE #Temp_DM
	(
		Master_Name NVarchar(2000),
		DM_Master_Log_Code BIGINT,
		DM_Master_Code NVARCHAR (100),
		Master_Type NVARCHAR (100),
		Is_New CHAR(1)
	)

	CREATE TABLE #Temp_DM_Title
	(
		DM_Title_Code INT,
		IsMusicDirectorValid CHAR(1) DEFAULT('Y'),
		IsStarCastValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelValid CHAR(1) DEFAULT('Y'),
		IsTitleTypeValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageValid CHAR(1) DEFAULT('Y'),
		IsOriginalTitleLanguageValid CHAR(1) DEFAULT('Y'),
		IsProgramCategoryValid CHAR(1) DEFAULT('Y'),
		IsValid AS CASE 
						WHEN 'YYYYYYY' = (IsMusicDirectorValid + IsStarCastValid + IsMusicLabelValid + IsTitleTypeValid + IsTitleLanguageValid + 
											IsOriginalTitleLanguageValid + IsProgramCategoryValid ) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)

	CREATE TABLE #Temp_DM_Title_Ignore
	(
		DM_Title_Code INT,
		IsMusicDirectorValid CHAR(1) DEFAULT('N'),
		IsStarCastValid CHAR(1) DEFAULT('N'),
		IsMusicLabelValid CHAR(1) DEFAULT('N'),
		IsTitleTypeValid CHAR(1) DEFAULT('N'),
		IsTitleLanguageValid CHAR(1) DEFAULT('N'),
		IsOriginalTitleLanguageValid CHAR(1) DEFAULT('N'),
		IsProgramCategoryValid CHAR(1) DEFAULT('N'),
		IsIgnore AS CASE 
						WHEN 'NNNNNNN' = (IsMusicDirectorValid + IsStarCastValid + IsMusicLabelValid + IsTitleTypeValid + IsTitleLanguageValid + 
											IsOriginalTitleLanguageValid + IsProgramCategoryValid ) 
						THEN 'N' 
						ELSE 'Y' 
				END
	)

	INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Is_New)
	SELECT [Name], [Key], [value], [DM_Master_Type] , CASE WHEN  ISNULL(RTRIM(LTRIM([value])),'') = 'NEW' THEN 'Y' ELSE 'N' END AS [Is_New]
	FROM @DM_Import_UDT udt
	Inner Join DM_Master_Log dm on dm.DM_Master_Log_Code = udt.[Key]

	DECLARE @DirectorRoleCode INT = 1, @StarCastRoleCode INT = 2

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
		
		INSERT INTO Music_Label(Music_Label_Name, Is_Active, Inserted_By,  Inserted_On)  
		SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
		WHERE TD.Master_Type = 'LB' AND Is_New = 'Y' AND 
		TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label)
        
		UPDATE TD SET TD.DM_Master_Code = ML.Music_Label_Code   
		FROM #Temp_DM TD  
		INNER JOIN Music_Label ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS  
		AND TD.Master_Type = 'LB'
    
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

	BEGIN

		CREATE TABLE #Temp_Talent_Role
		(
			Talent_Code INT,
			Role_Code INT,
			[Name] NVarchar(2000)
		)

		INSERT INTO #Temp_Talent_Role(Talent_Code, Role_Code, [Name])
		Select Distinct DM_Master_Code, Role_Code, [Master_Name] From (
			SELECT DM_Master_Code, @DirectorRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles Like '%Director%' AND DM.Master_Type = 'TA'
			UNION
			SELECT DM_Master_Code, @StarCastRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles like '%Cast%' AND DM.Master_Type = 'TA'
		) AS a Where a.DM_Master_Code Not In (
			Select tr.Talent_Code From Talent_Role tr Where  tr.Role_Code = a.Role_Code AND tr.Talent_Code IS NOT NULL
		) AND a.DM_Master_Code != 'Y'

		DECLARE @count INt
		select @count = cOUNT(*) from #Temp_Talent_Role

		IF(@count > 0)	
		BEGIN
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Talent_Role(Talent_Code, Role_Code)
			SELECT Talent_Code, Role_Code FROM #Temp_Talent_Role	

			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)
			SELECT Distinct [Name] As Original_Title, [Name] As Title_Name, [Name] As Synopsis, 
					(SELECT Deal_Type_Code FROM [Role] a WHERE a.Role_Code = tl.Role_Code) As Deal_Type_Code, GetDate() As Inserted_On, 
				   'Y' As Is_Active, Talent_Code Reference_Key, 'T' AS Reference_Flag 
			FROM #Temp_Talent_Role tl
		END
		Drop Table #Temp_Talent_Role
		
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
		SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore FROM DM_Master_Log
		WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND ISNULL(Master_Code, 0) = 0  
	END
	DECLARE @Master_Name NVARCHAR(1000) = ''

	BEGIN
		DECLARE CUR_DM_Title_Ignore CURSOR For SELECT Master_Name from #Temp_DM
		OPEN CUR_DM_Title_Ignore  

		FETCH NEXT FROM CUR_DM_Title_Ignore InTo @Master_Name
		WHILE @@FETCH_STATUS<>-1    
	BEGIN    
                                            
		IF(@@FETCH_STATUS<>-2)                                                            
		BEGIN                                                                                                                           
			PRINT 'BEGIN Start'   

				INSERT INTO #Temp_DM_Title_Ignore(DM_Title_Code)
				SELECT DM_Title_Code FROM DM_Title 
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_status <> 'N' AND 
				(
					[Title Type] like '%' + @Master_Name + '%' OR
					[Program Category] like '%' + @Master_Name + '%' OR
					[Director Name] like '%' + @Master_Name + '%' OR
					[Key Star Cast] like '%' + @Master_Name + '%' OR
					[Original Language (Hindi)] like '%' + @Master_Name + '%' OR
					[Original_Language] like '%' + @Master_Name + '%' OR
					[Music_Label] like '%' + @Master_Name + '%' 
				)
				AND DM_Title_Code NOT IN (SELECT DM_Title_Code FROM #Temp_DM_Title_Ignore)
			FETCH NEXT FROM CUR_DM_Title_Ignore INTO @Master_Name
		END    
	END
		CLOSE CUR_DM_Title_Ignore    
		DEALLOCATE CUR_DM_Title_Ignore   

	END
	BEGIN -- Ignore
			UPDATE mt SET mt.IsTitleTypeValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Title Type]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Title Type],',')
					WHERE LTRIM(RTRIM(ISNULL([Title Type], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Title Type] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TT' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsProgramCategoryValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Program Category]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Program Category],',')
					WHERE LTRIM(RTRIM(ISNULL([Program Category], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Program Category] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'PC' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsMusicDirectorValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Director Name]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Director Name],',')
					WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Director Name] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA'  AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsStarCastValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Key Star Cast]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Key Star Cast],',')
					WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Key Star Cast] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA' AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0  AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsTitleLanguageValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original Language (Hindi)]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original Language (Hindi)],',')
					WHERE LTRIM(RTRIM(ISNULL([Original Language (Hindi)], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Original Language (Hindi)] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TL' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsOriginalTitleLanguageValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original_Language]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original_Language],',')
					WHERE LTRIM(RTRIM(ISNULL([Original_Language], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Original_Language] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'OL' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsMusicLabelValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Music_Label]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Music_Label],',')
					WHERE LTRIM(RTRIM(ISNULL([Music_Label], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Music_Label] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'LB' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE DT SET DT.Record_Status = 'N', DT.Is_Ignore = 'Y'
			FROM DM_Title DT
			INNER JOIN #Temp_DM_Title_Ignore TDMT ON TDMT.DM_Title_Code = DT.DM_Title_Code
			WHERE TDMT.IsIgnore = 'Y'
	END

	BEGIN
		DECLARE CUR_DM_Title CURSOR For SELECT Master_Name from #Temp_DM
		OPEN CUR_DM_Title  

		FETCH NEXT FROM CUR_DM_Title InTo @Master_Name
		WHILE @@FETCH_STATUS<>-1    
		BEGIN                            
			IF(@@FETCH_STATUS<>-2)                                                            
			BEGIN                                                                                                                           
				PRINT 'BEGIN Start'   
					INSERT INTO #Temp_DM_Title(DM_Title_Code)
					SELECT DM_Title_Code FROM DM_Title 
					WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_status <> 'N' AND 
					(
						[Title Type] like '%' + @Master_Name + '%' OR
						[Program Category] like '%' + @Master_Name + '%' OR
						[Director Name] like '%' + @Master_Name + '%' OR
						[Key Star Cast] like '%' + @Master_Name + '%' OR
						[Original Language (Hindi)] like '%' + @Master_Name + '%' OR
						[Original_Language] like '%' + @Master_Name + '%' OR
						[Music_Label] like '%' + @Master_Name + '%' 
					)
					AND IS_Ignore ='N' AND DM_Title_Code NOT IN (SELECT DM_Title_Code FROM #Temp_DM_Title)

				FETCH NEXT FROM CUR_DM_Title INTO @Master_Name
			END    
		END
		CLOSE CUR_DM_Title    
		DEALLOCATE CUR_DM_Title   

	END
	BEGIN 

		UPDATE mt SET mt.IsTitleTypeValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Title Type]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Title Type],',')
				WHERE LTRIM(RTRIM(ISNULL([Title Type], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Title Type] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TT' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code

		UPDATE mt SET mt.IsProgramCategoryValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Program Category]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Program Category],',')
				WHERE LTRIM(RTRIM(ISNULL([Program Category], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Program Category] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'PC' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code

		UPDATE mt SET mt.IsMusicDirectorValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Director Name]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Director Name],',')
				WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Director Name] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS
			AND ml.Master_Type = 'TA' AND  CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code

		UPDATE mt SET mt.IsStarCastValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Key Star Cast]
					FROM #Temp_DM_Title D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Key Star Cast],',')
					WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Key Star Cast] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA' AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0  
			) AS main
			INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsTitleLanguageValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original Title (Tanil/Telugu)]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original Title (Tanil/Telugu)],',')
				WHERE LTRIM(RTRIM(ISNULL([Original Title (Tanil/Telugu)], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Original Title (Tanil/Telugu)] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TL' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code	

		UPDATE mt SET mt.IsOriginalTitleLanguageValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original_Language]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original_Language],',')
				WHERE LTRIM(RTRIM(ISNULL([Original_Language], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Original_Language] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'OL' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code	

		UPDATE mt SET mt.IsMusicLabelValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Music_Label]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Music_Label] ,',')
				WHERE LTRIM(RTRIM(ISNULL([Music_Label], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Music_Label] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'LB' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code	

		UPDATE DT SET DT.Record_Status = 'N'
		FROM DM_Title DT
		INNER JOIN #Temp_DM_Title TDMT ON TDMT.DM_Title_Code = DT.DM_Title_Code
		WHERE TDMT.IsValid = 'Y'
	    
	END

	DECLARE @ResolveCount  Int , @TotalCount INT
	SELECT @ResolveCount = COUNT(*) FROM DM_Title WHERE Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
	SELECT @TotalCount = COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code
	IF(@ResolveCount = @TotalCount)
	BEGIN
		UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
	END
END

