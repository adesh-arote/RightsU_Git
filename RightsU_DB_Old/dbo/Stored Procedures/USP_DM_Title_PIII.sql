CREATE PROCEDURE [dbo].[USP_DM_Title_PIII]    
    @DM_Master_Import_Code Int    
AS    
BEGIN    
	--DECLARE @DM_Master_Import_Code INT    = 6866

	IF OBJECT_ID('tempdb..#Temp_Talents') IS NOT NULL        
		DROP TABLE #Temp_Talents   
	IF OBJECT_ID('tempdb..#Temp_Music_Label') IS NOT NULL        
		DROP TABLE #Temp_Music_Label  
	IF OBJECT_ID('tempdb..#Temp_Language') IS NOT NULL        
		DROP TABLE #Temp_Language  
	IF OBJECT_ID('tempdb..#Temp_Original_Language') IS NOT NULL        
		DROP TABLE #Temp_Original_Language  
	IF OBJECT_ID('tempdb..#Temp_Deal_Type') IS NOT NULL        
		DROP TABLE #Temp_Deal_Type  
	IF OBJECT_ID('tempdb..#Temp_Program_Category') IS NOT NULL        
		DROP TABLE #Temp_Program_Category  
	
	CREATE TABLE #Temp_Talents    
	(    
		IntCode INT,
		Talent_Code Int,    
		Talent_Name NVarchar(1000),    
		Roles Varchar(100),    
		Role_Code Int    
	)    
	CREATE TABLE #Temp_Music_Label    
	(    
		IntCode INT,
		Music_Label_Code Int,    
		Music_Label_Name NVARCHAR(1000),    
		Effective_From Datetime    
	)      
	CREATE TABLE #Temp_Language    
	(    
		IntCode INT,
		Language_Code Int,    
		Language_Name NVARCHAR(1000),      
	)    
	CREATE TABLE #Temp_Original_Language    
	(    
		IntCode INT,
		Language_Code Int,    
		Language_Name NVARCHAR(1000),      
	)    
	CREATE TABLE #Temp_Deal_Type    
	(   
		IntCode INT, 
		Deal_Type_Code Int,    
		Deal_Type_Name NVARCHAR(1000),      
	)    
	CREATE TABLE #Temp_Program_Category   
	(   
		IntCode INT, 
		Program_Category_Code Int,    
		Program_Category_Name NVARCHAR(1000),      
	)  

	DECLARE @DirectorRoleCode INT = 1, @StarCastRoleCode INT = 2, @Is_Allow_Program_Category VARCHAR(2), @Program_Category_Code INT    
    
	SELECT @Is_Allow_Program_Category = Parameter_Value FROM System_Parameter_New  WHERE Parameter_Name = 'Is_Allow_Program_Category'

	SELECT @Program_Category_Code = Columns_Code FROM Extended_Columns WHERE Columns_Name = 'Program Category'

	INSERT INTO #Temp_Talents (IntCode,Talent_Code, Talent_Name, Roles, Role_Code)    
	SELECT Distinct 0 AS IntCode, T.Talent_Code, T.Talent_Name, R.Role_Name, R.Role_Code FROM Talent T    
	INNER JOIN Talent_Role TR ON T.Talent_Code = TR.Talent_Code    
	INNER JOIN Role R ON TR.Role_Code = R.Role_Code    
	UNION     
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name, 'Director', @DirectorRoleCode FROM DM_Master_Log where Master_Type = 'TA' AND ISNULL(Master_Code, 0) > 0 AND Roles LIKE '%Director%' AND DM_Master_Import_Code like @DM_Master_Import_Code  
	UNION    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name, 'Star Cast', 2 FROM DM_Master_Log where Master_Type = 'TA' AND ISNULL(Master_Code, 0) > 0 AND Roles LIKE '%Cast%' AND DM_Master_Import_Code like @DM_Master_Import_Code     
		
      
	INSERT INTO #Temp_Music_Label (IntCode, Music_Label_Code, Music_Label_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='LB' AND ISNULL(Master_Code, 0) > 0      
	UNION    
	SELECT 0 As IntCode, Music_Label_Code, Music_Label_Name FROM Music_Label    
    
      
	INSERT INTO #Temp_Language (IntCode, Language_Code, Language_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='TL' AND ISNULL(Master_Code, 0) > 0      
	UNION    
	SELECT 0 As IntCode, Language_Code, Language_Name FROM Language    

	INSERT INTO #Temp_Original_Language (IntCode, Language_Code, Language_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='OL' AND ISNULL(Master_Code, 0) > 0      
	UNION    
	SELECT 0 As IntCode, Language_Code, Language_Name FROM Language    
    
	INSERT INTO #Temp_Deal_Type (IntCode, Deal_Type_Code, Deal_Type_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='TT' AND ISNULL(Master_Code, 0) > 0      
	UNION    
	SELECT 0 As IntCode, Deal_Type_Code, Deal_Type_Name FROM Deal_Type    

	IF(@Is_Allow_Program_Category = 'Y')
	BEGIN	
		INSERT INTO #Temp_Program_Category(IntCode, Program_Category_Code, Program_Category_Name)
		SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type = 'PC' AND ISNULL(Master_Code, 0 ) > 0
			UNION
		SELECT 0 AS IntCode, Columns_Value_Code, Columns_Value FROM Extended_Columns_Value  WHERE Columns_Code = @Program_Category_Code
	END
    
	DECLARE @User_Code Int = 0    
             
	PRINT 'Start Cursor'    
	
	BEGIN TRY
	BEGIN TRANSACTION
	--Cursor    
		DECLARE @TitleType VARCHAR(100) = '', @OrgTitle NVARCHAR(1000) = '', @EngTitle NVARCHAR(1000) = '', @Synopsis NVARCHAR(MAX) = '',     
	@Original_Language_Name NVARCHAR(1000) = '',@Release_Year VARCHAR(10) = '', @Duration VARCHAR(10) = '',     
	@DirName NVARCHAR(1000) = '', @StarCastName NVARCHAR(1000) = '',@Music_Label NVARCHAR(1000) = '', @Program_Category  NVARCHAR(2000) , @OrgLanguageName NVARCHAR(1000) = ''
     
		DECLARE CUR_Title CURSOR For    
			SELECT LTRIM(RTRIM([Title Type])),LTRIM(RTRIM([Title/ Dubbed Title (Hindi)])),LTRIM(RTRIM([Original Title (Tanil/Telugu)])), LTRIM(RTRIM(Synopsis)),     
				LTRIM(RTRIM([Original Language (Hindi)])), LTRIM(RTRIM([Year of Release])), LTRIM(RTRIM([Duration (Min)])),    
				LTRIM(RTRIM(ISNULL([Director Name], ''))), LTRIM(RTRIM(ISNULL([Key Star Cast], ''))),LTRIM(RTRIM(ISNULL([Music_Label], ''))),
				LTRIM(RTRIM(ISNULL([Program Category], '')))  ,LTRIM(RTRIM([Original_Language]))           
			FROM DM_Title 
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'    

		OPEN CUR_Title 
		
		FETCH NEXT FROM CUR_Title InTo @TitleType, @OrgTitle, @EngTitle, @Synopsis, @Original_Language_Name, @Release_Year, @Duration,  @DirName, @StarCastName,@Music_Label, @Program_Category, @OrgLanguageName   
		WHILE @@FETCH_STATUS<>-1     
		BEGIN        
			IF(@@FETCH_STATUS<>-2)                                                  
			BEGIN                                  
				PRINT 'BEGIN START'    
				DECLARE @Deal_Type_Code INT = 0, @Title_Language_code INT = 0, @Original_Language_code INT = NULL, @Title_Code INT = 0 ,@CountryCode INT = 0,@Music_Label_Code INT, @Column_Value_Code INT   
    
				SELECT @CountryCode=CONVERT(INT,Parameter_Value)  from System_Parameter_new where Parameter_Name collate SQL_Latin1_General_CP1_CI_AS ='Title_CountryOfOrigin' collate SQL_Latin1_General_CP1_CI_AS    
  
				SELECT @Deal_Type_Code = Deal_Type_Code FROM Deal_Type WHERE Deal_Type_Name collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@TitleType, ''))) collate SQL_Latin1_General_CP1_CI_AS    
	
				SELECT TOP 1 @Title_Language_code = Language_Code FROM #Temp_Language 
				WHERE LTRIM(RTRIM(Language_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Original_Language_Name, ''))) collate SQL_Latin1_General_CP1_CI_AS 
				ORDER BY IntCode DESC   

				SELECT TOP 1 @Original_Language_code = Language_Code FROM #Temp_Original_Language 
				WHERE LTRIM(RTRIM(Language_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@OrgLanguageName, ''))) collate SQL_Latin1_General_CP1_CI_AS 
				ORDER BY IntCode DESC 

				SELECT Top 1 @deal_type_code = Deal_Type_Code FROM #Temp_Deal_Type 
				WHERE LTRIM(RTRIM(Deal_Type_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@TitleType, ''))) collate SQL_Latin1_General_CP1_CI_AS Order by IntCode desc      
	
				SELECT @Column_Value_Code = Program_Category_Code FROM #Temp_Program_Category 
				WHERE LTRIM(RTRIM(Program_Category_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Program_Category, ''))) collate SQL_Latin1_General_CP1_CI_AS
    
				SELECT @Music_Label_Code = Music_Label_Code FROM Music_Label 
				WHERE LTRIM(RTRIM(Music_Label_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Label, ''))) collate SQL_Latin1_General_CP1_CI_AS    
       
				SELECT @User_Code =  Upoaded_By from DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
		
				DECLARE @titleCount INT  
				SELECT @titleCount = Count(*) From Title WHERE Title_Name = @EngTitle  and Reference_Key is null

				IF(@titleCount = 0)  
				BEGIN 
					SELECT @Original_Language_code

					 INSERT INTO Title    
					 (    
					  Deal_Type_Code, Original_Title, Title_Name, Synopsis, Original_Language_code ,Title_Language_Code, year_of_production, duration_in_min, is_active,Inserted_By,Inserted_On,Last_UpDated_Time, Music_Label_Code    
					 )    
					 VALUES    
					 (    
					  @deal_type_code, @OrgTitle, @EngTitle, @Synopsis,@Original_Language_code, @Title_Language_code, Convert(INT,@Release_Year), @Duration  , 'Y',@User_Code,GETDATE(),GetDate(),@Music_Label_Code    
					 )  
			
					SELECT @Title_Code = IDENT_CURRENT('Title')    
		
					SELECT @Title_Code

					------------ Title Talent Insert    
					INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_code)    
									SELECT DISTINCT @Title_Code, tt.Talent_Code, tt.Role_Code FROM (    
									SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Name, @DirectorRoleCode As RoleCode FROM DBO.fn_Split_withdelemiter(@DirName, ',') WHERE number <> ''    
									UNION    
					SELECT LTRIM(RTRIM(Replace(number, ' ', ' '))) Name, @StarCastRoleCode As RoleCode FROM DBO.fn_Split_withdelemiter(@StarCastName, ',') WHERE number <> ''    
					) AS a    
					INNER JOIN #Temp_Talents tt On tt.Talent_Name COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(a.Name)) COLLATE SQL_Latin1_General_CP1_CI_AS  AND tt.Role_Code = a.RoleCode    
         
					INSERT INTO Title_Country(Title_Code,Country_Code)   VALUES(@Title_Code, @CountryCode)   

					IF(@Is_Allow_Program_Category = 'Y')
					BEGIN
						INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Column_Value, Is_Multiple_Select)
						VALUES(@Title_Code, 'TITLE', @Program_Category_Code, @Column_Value_Code, NULL, 'N')
					END

				END  
  
				UPDATE DM_Title SET Record_Status = 'C'  WHERE [Original Title (Tanil/Telugu)] COLLATE SQL_Latin1_General_CP1_CI_AS = @EngTitle COLLATE SQL_Latin1_General_CP1_CI_AS  AND DM_Master_Import_Code = @DM_Master_Import_Code  
     
				FETCH NEXT FROM CUR_Title InTo @TitleType, @OrgTitle, @EngTitle, @Synopsis, @Original_Language_Name, @Release_Year, @Duration,  @DirName, @StarCastName,@Music_Label,@Program_Category, @OrgLanguageName   
           
			END    

		END    
		CLOSE CUR_Title    
		DEALLOCATE CUR_Title    
		
		UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
	   
	COMMIT
	END TRY
	BEGIN CATCH
	CLOSE CUR_Title    
		DEALLOCATE CUR_Title  
		ROLLBACK
		UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
	END CATCH
END    