CREATE PROCEDURE [dbo].[USP_Title_Import_Utility_PII]
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code Int
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_Utility_PII]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON

		IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
		IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role

		--DECLARE @DM_Master_Import_Code INT = 15,@Users_Code Int = 1265
		--DECLARE @DM_Import_UDT DM_Import_UDT

		--INSERT INTO @DM_Import_UDT([Key],[value], [DM_Master_Type])
		--SELECT 236,'Y','TA'
		--UNION ALL SELECT 230,'1626','TA'
		--UNION ALL SELECT 227,'35','TA'

		CREATE TABLE #Temp_DM
		(
			Master_Name NVarchar(2000),
			DM_Master_Log_Code BIGINT,
			DM_Master_Code NVARCHAR (100),
			Master_Type NVARCHAR (100),
			Is_New CHAR(1)
		)

		CREATE TABLE #Temp_Talent_Role
		(
			Talent_Code INT,
			Role_Code INT,
			[Name] NVarchar(2000)
		)

		INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Is_New)
		SELECT [Name], [Key], [value], [DM_Master_Type] , CASE WHEN  ISNULL(RTRIM(LTRIM([value])),'') = 'NEW' THEN 'Y' ELSE 'N' END AS [Is_New]
		FROM @DM_Import_UDT udt
		Inner Join DM_Master_Log dm (NOLOCK) on dm.DM_Master_Log_Code = udt.[Key]

		IF EXISTS(SELECT TOP 1 DM_Master_Log_Code FROM #Temp_DM WHERE Is_New = 'Y')
		BEGIN
			DECLARE @CurDate DATETIME = GETDATE()

			-- INSERTING NEW DATA INTO TABLE
			BEGIN
				INSERT INTO Talent(Talent_Name, Gender, Is_Active, Inserted_By, Inserted_On)
				SELECT DISTINCT TD.Master_Name, 'N', 'Y', @Users_Code, @CurDate FROM  #Temp_DM TD  
				WHERE TD.Master_Type = 'TA' AND Is_New = 'Y'

				INSERT INTO Deal_Type(Deal_Type_Name, Is_Default,Is_Grid_Required, Is_Active, Is_Master_Deal)
				SELECT DISTINCT TD.Master_Name, 'N', 'Y','Y','N' FROM  #Temp_DM TD  
				WHERE TD.Master_Type = 'TT' AND Is_New = 'Y'

				INSERT INTO Genres (Genres_Name, Inserted_On, Inserted_By, Is_Active)
				SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code, 'Y' FROM  #Temp_DM TD  
				WHERE TD.Master_Type = 'GE' AND Is_New = 'Y'

				INSERT INTO Language (Language_Name, Inserted_On, Inserted_By, Is_Active)
				SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code, 'Y' FROM  #Temp_DM TD  
				WHERE TD.Master_Type IN ('OL','TL') AND Is_New = 'Y'

				INSERT INTO Program (Program_Name, Inserted_On, Inserted_By, Is_Active)
				SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code, 'Y' FROM  #Temp_DM TD  
				WHERE TD.Master_Type = 'PG' AND Is_New = 'Y'

				INSERT INTO Banner (Banner_Name, Inserted_On, Inserted_By)
				SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code FROM #Temp_DM TD  
				WHERE TD.Master_Type = 'BA' AND Is_New = 'Y'

				INSERT INTO AL_Lab (AL_Lab_Name, Inserted_On, Inserted_By)
				SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code FROM #Temp_DM TD 
				WHERE TD.Master_Type = 'LA' AND Is_New = 'Y'

				INSERT INTO Extended_Columns_Value(Columns_Code,Columns_Value)
				SELECT DISTINCT 41,TD.Master_Name FROM #Temp_DM TD 
				WHERE TD.Master_Type = 'MP' AND Is_New = 'Y'
			END

			-- UPDATING #Temp_DM (DM_Master_Code) Column
			BEGIN
				UPDATE TD SET TD.DM_Master_Code = T.Talent_Code 
				FROM #Temp_DM TD
				INNER JOIN Talent T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Talent_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'TA'

				UPDATE TD SET TD.DM_Master_Code = T.Deal_Type_Code 
				FROM #Temp_DM TD
				INNER JOIN Deal_Type T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Deal_Type_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'TT'

				UPDATE TD SET TD.DM_Master_Code = T.Genres_Code 
				FROM #Temp_DM TD
				INNER JOIN Genres T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Genres_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'GE'

				UPDATE TD SET TD.DM_Master_Code = T.Language_Code 
				FROM #Temp_DM TD
				INNER JOIN Language T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Language_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type IN ('OL','TL') 

				UPDATE TD SET TD.DM_Master_Code = T.Program_Code 
				FROM #Temp_DM TD
				INNER JOIN Program T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Program_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'PG'

				UPDATE TD SET TD.DM_Master_Code = B.Banner_Code
				FROM #Temp_DM TD
				INNER JOIN Banner B ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = B.Banner_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'BA'

				UPDATE TD SET TD.DM_Master_Code = L.AL_Lab_Code
				FROM #Temp_DM TD
				INNER JOIN AL_Lab L ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = L.AL_Lab_Name collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'LA'

				UPDATE TD SET TD.DM_Master_Code = E.Columns_Value_Code
				FROM #Temp_DM TD
				INNER JOIN Extended_Columns_Value E ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = E.Columns_Value collate SQL_Latin1_General_CP1_CI_AS
				AND TD.Master_Type = 'MP'
			END

			BEGIN -- MUSIC LABEL
				INSERT INTO Music_Label(Music_Label_Name, Is_Active, Inserted_By,  Inserted_On)  
				SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
				WHERE TD.Master_Type = 'LB' AND Is_New = 'Y' AND 
				TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label (NOLOCK))
        
				UPDATE TD SET TD.DM_Master_Code = ML.Music_Label_Code   
				FROM #Temp_DM TD  
				INNER JOIN Music_Label ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS  
				AND TD.Master_Type = 'LB'
			END
		END

		-- UPDATING IS_Ignore = Y INTO DM_Master_Log Table
		UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
		FROM DM_Master_Log D
		INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'

		-- UPDATING IS_Ignore = Y INTO DM_Master_Log Table
		UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
		FROM DM_Master_Log D
		INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'

		-- UPDATING Mapped_By = V INTO DM_Master_Log Table
		UPDATE D SET D.Mapped_By = 'V', D.Action_By = @Users_Code, D.Action_On = GETDATE()
		FROM DM_Master_Log D
		INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code > '0' AND D.Mapped_By = 'S'

		BEGIN -- TALENT ROLE HANDLED
			INSERT INTO #Temp_Talent_Role(Talent_Code, Role_Code, [Name])
			SELECT DISTINCT DM_Master_Code, Role_Code, [Master_Name] FROM (
				SELECT DM_Master_Code, R.Role_Code , [Master_Name] 
				FROM #Temp_DM  T
				INNER JOIN DM_Master_Log DM (NOLOCK) ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code
				INNER JOIN Role R (NOLOCK) ON R.Role_Name = DM.Roles
				WHERE DM.Master_Type = 'TA'
			) AS a WHERE a.DM_Master_Code Not In (
				SELECT tr.Talent_Code FROM Talent_Role tr (NOLOCK) WHERE  tr.Role_Code = a.Role_Code AND tr.Talent_Code IS NOT NULL
			) AND a.DM_Master_Code != 'Y'

			DECLARE @count INT
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
				SELECT Distinct [Name] As Original_Title, [Name] As Title_Name, [Name] As Synopsis, 
						(SELECT Deal_Type_Code FROM [Role] a (NOLOCK) WHERE a.Role_Code = tl.Role_Code) As Deal_Type_Code, GetDate() As Inserted_On, 
					   'Y' As Is_Active, Talent_Code Reference_Key, 'T' AS Reference_Flag 
				FROM #Temp_Talent_Role tl
			END
		END

		IF NOT EXISTS (SELECT TOP 1 *  FROM DM_Master_Log (NOLOCK) WHERE  DM_Master_Import_Code = @DM_Master_Import_Code AND Action_By IS NULL  AND Action_On IS NULL)
		BEGIN
			UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
		END

		IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
		IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role
 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_Utility_PII]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END