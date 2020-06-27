--DROP PROCEDURE [dbo].[USP_Insert_Title_Import_UDT]
--Drop TYPE [dbo].[Title_Import]
--CREATE TYPE [dbo].[Title_Import] AS TABLE (
--    [Title_Name]      VARCHAR (5000) NULL,
--    [Title_Type]      VARCHAR (100)  NULL,
--    [Title_Language]  VARCHAR (100)  NULL,
--    [Year_of_Release] VARCHAR (100)  NULL,
--    [Duration]        VARCHAR (100)  NULL,
--    [Key_Star_Cast]   VARCHAR (1000) NULL,
--    [Director]        VARCHAR (1000) NULL,
--    [Synopsis]        VARCHAR (5000) NULL,
--	[Music_Label]        VARCHAR (5000) NULL);

--Alter Table DM_Title 
--ADD [Music_Label]  VARCHAR (5000) NULL
--	select * from DM_Title


Create PROCEDURE [dbo].[USP_Insert_Title_Import_UDT]
(
	@Title_Import Title_Import READONLY,
	@User_Code INT
)
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 9 Sept 2015
-- Description:	Insert Record into Dm_Title
-- =============================================
BEGIN

		SET NOCOUNT ON;		
		TRUNCATE TABLE DM_Title 
		DECLARE @Error_Message	NVARCHAR(MAX)
		
		INSERT INTO DM_Title
		(
			[Original Title (Tanil/Telugu)], 
			[Title Type] ,
			[Original Language (Hindi)] ,
			[Year of Release],
			[Duration (Min)] ,
			[Key Star Cast],
			[Director Name],
			[Synopsis],
			[Record_Status],
			[Music_Label]
		)
		SELECT  
			[Title_Name], 
			[Title_Type] ,
			[Title_Language] ,
			[Year_of_Release],
			[Duration],
			[Key_Star_Cast],			
			[Director],
			[Synopsis],
			'N',
			[Music_Label]
		FROM @Title_Import 

		--SELECT 
		--	[Title_Name], 
		--	[Title_Type] ,
		--	[Title_Language] ,
		--	[Year_of_Release],
		--	[Key_Star_Cast]
		--	[Duration] ,
		--	[Director],
		--	[Synopsis],
		--	@Error_Message AS Error_Messages
		--from @Title_Import 
			 
		--SELECT 'sagar',* from  DM_Title 
		DECLARE @Title_Type_Music VARCHAR(500)
		
		SELECT @Title_Type_Music = Parameter_Value from System_Parameter_New where Parameter_Name='Title_Type_Music'
		UPDATE DM_Title SET [Music_Label]='' where [Title Type]!=@Title_Type_Music
		--select * from DM_Title

		IF EXISTS(SELECT TOP 1 Record_Status FROM DM_Title WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'N')
		BEGIN
		EXEC USP_Validate_Title_Import 				
		--SELECT TOP 100 Record_Status FROM DM_Title 
		--WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') <> 'E'
		

		IF NOT EXISTS(SELECT TOP 1 Record_Status FROM DM_Title WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E')
		BEGIN
			PRINT 'IF Condition'
				DECLARE @DirectorRoleCode INT = 1, @StarCastRoleCode INT = 2
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

			INSERT INTO #Temp_Music_Label(Name, RoleExists)
			SELECT DISTINCT a.MusicLabelName, 'N' FROM
			(
				SELECT [Music_Label] MusicLabelName FROM DM_Music_Title WHERE ISNULL([Music_Label], '') <> ''
			) AS a

			INSERT INTO #Temp_Director(Name, RoleExists)
			SELECT DISTINCT b.DirName, 'N' FROM
			(
				SELECT [Director Name] DirName FROM DM_Title WHERE ISNULL([Director Name], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(number)) DirName FROM DBO.fn_Split_withdelemiter(a.DirName, ',')
			) AS b WHERE b.DirName <> ''

			INSERT INTO #Temp_S(Name, RoleExists)
			SELECT DISTINCT b.StarCast, 'N' FROM(
				SELECT [Key Star Cast] StarCast FROM DM_Title WHERE ISNULL([Key Star Cast], '') <> ''
			) AS a
			CROSS APPLY
			(
				SELECT LTRIM(RTRIM(number)) StarCast FROM DBO.fn_Split_withdelemiter(a.StarCast, ',')
			) AS b WHERE b.StarCast <> ''

			--SELECT * FROM #Temp_S			
			------------ Insert Talent Which are NOT available IN system
			INSERT INTO Talent(talent_name, gender, is_active)
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_Director WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent)

			INSERT INTO Talent(talent_name, gender, is_active)
			SELECT LTRIM(RTRIM(Name)), 'N', 'Y' FROM #Temp_S WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT talent_name collate SQL_Latin1_General_CP1_CI_AS FROM Talent)

			INSERT INTO Music_Label(Music_Label_Name,Is_Active)
			SELECT LTRIM(RTRIM(Name)), 'Y' FROM #Temp_Music_Label WHERE Name collate SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS FROM Music_Label)
		
			------------ UPDATE temp tables with talent code AND IS role exists
			UPDATE tm SET tm.TalentCode = tl.talent_code FROM #Temp_Director tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS
			UPDATE tm SET tm.TalentCode = tl.talent_code FROM #Temp_S tm INNER JOIN Talent tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.talent_name)) collate SQL_Latin1_General_CP1_CI_AS

			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_Director tm INNER JOIN Talent_Role tr ON tm.TalentCode  = tr.talent_code  AND role_code = @DirectorRoleCode 
			UPDATE tm SET tm.RoleExists = 'Y' FROM #Temp_S tm INNER JOIN Talent_Role tr ON tm.TalentCode = tr.talent_code  AND role_code  = @StarCastRoleCode 
			UPDATE tm SET tm.LabelCode = tl.Music_Label_Code FROM #Temp_Music_Label tm INNER JOIN Music_Label tl ON LTRIM(RTRIM(tm.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(tl.Music_Label_Name)) collate SQL_Latin1_General_CP1_CI_AS
			------------ Talent Role Insert
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS
			INSERT INTO Talent_Role(talent_code, role_code)
			SELECT TalentCode, @DirectorRoleCode FROM #Temp_Director WHERE RoleExists = 'N'

			INSERT INTO Talent_Role(talent_code, role_code)
			SELECT TalentCode, @StarCastRoleCode FROM #Temp_S WHERE RoleExists = 'N'

			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS
			------------ END

			------------ INSERT TALENT RECORDS IN TITLE		
		
			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)  
			SELECT LTRIM(RTRIM(Name)), LTRIM(RTRIM(Name)), LTRIM(RTRIM(Name)), (SELECT Deal_Type_Code FROM [Role] WHERE Role_Code = @DirectorRoleCode), GETDATE(), 'Y', TalentCode, 'T' FROM #Temp_Director WHERE RoleExists = 'N'

			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)  
			SELECT LTRIM(RTRIM(Name)), LTRIM(RTRIM(Name)), LTRIM(RTRIM(Name)), (SELECT Deal_Type_Code FROM [Role] WHERE Role_Code = @StarCastRoleCode), GETDATE(), 'Y', TalentCode, 'T' FROM #Temp_S WHERE RoleExists = 'N'

			------------ END
			PRINT 'Start Cursor'
			--Cursor
			DECLARE @TitleType VARCHAR(100) = '', @OrgTitle NVARCHAR(1000) = '', @EngTitle NVARCHAR(1000) = '', @Synopsis NVARCHAR(MAX) = '', 
			@Original_Language_Name NVARCHAR(1000) = '',@Release_Year VARCHAR(10) = '', @Duration VARCHAR(10) = '', 
			@DirName NVARCHAR(1000) = '', @StarCastName NVARCHAR(1000) = '',@Music_Label NVARCHAR(1000) = ''

			DECLARE CUR_Title CURSOR For
				SELECT LTRIM(RTRIM([Title Type])), '',LTRIM(RTRIM([Original Title (Tanil/Telugu)])), LTRIM(RTRIM(Synopsis)), 
					   LTRIM(RTRIM([Original Language (Hindi)])), LTRIM(RTRIM([Year of Release])), LTRIM(RTRIM([Duration (Min)])),
					   LTRIM(RTRIM(ISNULL([Director Name], ''))), LTRIM(RTRIM(ISNULL([Key Star Cast], ''))),LTRIM(RTRIM(ISNULL([Music_Label], ''))) 				   
				FROM DM_Title WHERE Record_Status = 'N' -- AND [Title/ Dubbed Title (Hindi)] = 'Aag Ka Gola'
			OPEN CUR_Title
			FETCH NEXT FROM CUR_Title InTo @TitleType, @OrgTitle, @EngTitle, @Synopsis, @Original_Language_Name, @Release_Year, @Duration,  @DirName, @StarCastName,@Music_Label
			WHILE @@FETCH_STATUS<>-1 
			BEGIN                                              
				IF(@@FETCH_STATUS<>-2)                                              
				BEGIN																														
					PRINT 'BEGIN Start'
					DECLARE @Deal_Type_Code INT = 0, @Title_Language_code INT = 0, @Original_Language_code INT = 0, @Title_Code INT = 0 ,@CountryCode INT = 0,@Music_Label_Code INT
					select @CountryCode=CONVERT(INT,Parameter_Value)  from System_Parameter_new where Parameter_Name collate SQL_Latin1_General_CP1_CI_AS ='Title_CountryOfOrigin' collate SQL_Latin1_General_CP1_CI_AS
					SELECT @Deal_Type_Code = Deal_Type_Code FROM Deal_Type WHERE Deal_Type_Name collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@TitleType, ''))) collate SQL_Latin1_General_CP1_CI_AS
					SELECT @Title_Language_code = language_code FROM [Language] WHERE Language_Name collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Original_Language_Name, ''))) collate SQL_Latin1_General_CP1_CI_AS	
					SELECT @Music_Label_Code = Music_Label_Code FROM Music_Label WHERE LTRIM(RTRIM(Music_Label_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Label, '')))	collate SQL_Latin1_General_CP1_CI_AS
			
					INSERT INTO Title
					(
						Deal_Type_Code, Original_Title, Title_Name, Synopsis, Title_Language_Code, year_of_production, duration_in_min, is_active,Inserted_By,Inserted_On,Music_Label_Code
					)
					Values
					(
						@deal_type_code, @OrgTitle, @EngTitle, @Synopsis, @Title_Language_code, Convert(INT,@Release_Year), @Duration  , 'Y',@User_Code,GETDATE(),@Music_Label_Code
					)
				
					SELECT @Title_Code = IDENT_CURRENT('Title')

					PRINT  'Inserted Into Title'
					--SELECT * FROM Title WHERE Title_Code = @Title_Code

					------------ Title Talent Insert

					INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_code)
					SELECT @Title_Code, TalentCode, @DirectorRoleCode FROM #Temp_Director td
					INNER JOIN (
						SELECT LTRIM(RTRIM(number)) number FROM DBO.fn_Split_withdelemiter(@DirName, ',') WHERE number <> ''
					) AS a ON LTRIM(RTRIM(td.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS

					INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_code)
					SELECT @Title_Code, TalentCode, @StarCastRoleCode FROM #Temp_S ts
					INNER JOIN (
						SELECT LTRIM(RTRIM(number)) number FROM DBO.fn_Split_withdelemiter(@StarCastName, ',') WHERE number <> ''
					) AS a ON LTRIM(RTRIM(ts.Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.number)) collate SQL_Latin1_General_CP1_CI_AS
			INSERT INTO Title_Country(Title_Code,Country_Code)
			Values(@Title_Code, @CountryCode)
					PRINT  'Inserted Into Title_Talent'
				 --	------------ Update DM_Title
					UPDATE DM_Title SET Record_Status = 'C'  WHERE [Original Title (Tanil/Telugu)] collate SQL_Latin1_General_CP1_CI_AS = @OrgTitle collate SQL_Latin1_General_CP1_CI_AS
					PRINT  'UPDATE DM_Title '		 
					Fetch Next FROM CUR_Title InTo @TitleType, @OrgTitle, @EngTitle, @Synopsis, @Original_Language_Name, @Release_Year, @Duration,  @DirName, @StarCastName,@Music_Label
				END
			END
				Close CUR_Title
				Deallocate CUR_Title
				Drop Table #Temp_Director
				Drop Table #Temp_S
				Drop Table #Temp_Music_Label

		END
		ELSE
		BEGIN 
			PRINT 'IF Condition'
			SELECT 
			[Original Title (Tanil/Telugu)] AS Title_Name,
			[Title Type] AS Title_Type,
			[Original Language (Hindi)] AS Title_Language,
			[Year of Release] AS Year_of_Release,
			[Duration (Min)]  AS Duration,
			[Director Name] AS Director,
			[Key Star Cast] AS Key_Star_Cast,
			[Synopsis] AS Synopsis,
			[Music_Label] AS Music_Label,
			(ISNULL([Error_Message],'')) AS Error_Messages 
			FROM DM_Title 
		END

		END		
		
		END


--		select Parameter_Value  from System_Parameter_new where Parameter_Name='Title_CountryOfOrigin'


--		select * from System_Parameter_New  where Parameter_Name='Title_CountryOfOrigin'
--		select * from Country where Country_Code=3


--		EXEC [dbo].[USP_Title_List]  1,' ',1,1,10,'Y',10
--select * from Title_Country where Title_Code in (select Title_Code from Title where Title_Name Like '%bbb%')


--select *, from Country where Country_Name Like '%&%'