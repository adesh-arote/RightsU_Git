CREATE PROCEDURE [dbo].[USP_Content_Music_PIV]        
	@DM_Master_Import_Code VARCHAR(500),        
	@User_Code INT=143,
	@StepCountIn INT,
	@StepCountOut INT OUT    
AS    
 --declare @DM_Master_Import_Code VARCHAR(500) = 45,  
 --@User_Code INT = 143  
         
BEGIN 
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_PIV]', 'Step 1', 0, 'Started Procedure', 0, ''       
		IF OBJECT_ID('tempdb..#Temp_Import') IS NOT NULL DROP TABLE #Temp_Import
		IF OBJECT_ID('tempdb..#Temp_Music') IS NOT NULL DROP TABLE #Temp_Music
		IF OBJECT_ID('tempdb..#Temp_Album') IS NOT NULL DROP TABLE #Temp_Album
	
		DECLARE	 @Record_Code INT,
				 @Record_Type CHAR = 'C',
				 @Step_No INT = 0, 
				 @Sub_Step_No INT = 1,
				 @Loop_Counter INT = 0, 
				 @Proc_Name VARCHAR(100),
				 @Short_Status_Code VARCHAR(10),
				 @Process_Error_Code VARCHAR(10),
				 @Process_Error_MSG NVARCHAR(MAX) = ''

				 SET @Step_No = @StepCountIn

	 --"CM" id content Music DM_Master_Log table  
	 CREATE TABLE #Temp_Import        
	 (        
		-- Temp Import Data        
		 ID INT IDENTITY(1,1),        
		 DM_Master_Import_Code VARCHAR(500),        
		 Name NVARCHAR(4000),        
		 Master_Type VARCHAR(100),        
		 Action_By INT,        
		 Action_On DATETIME,        
		 Roles VARCHAR(100),      
		 --DM_Master_Log_Code INT,  
		 Master_Code INT,  
		 Mapped_By CHAR(1),
		 Movie_Album NVARCHAR(4000) 
	 )        
	 -- Director Data        
	 CREATE TABLE #Temp_Music        
	 (         
		Name NVARCHAR(4000),        
		MusicTitleCode INT,        
		RoleExists CHAR(1),
		Movie_Album NVARCHAR(4000)            
	 )    
	  CREATE TABLE #Temp_Album
	  (         
		 Name NVARCHAR(4000),        
		 MusicTitleCode INT,        
		 RoleExists CHAR(1)        
	  )

	  BEGIN TRY
		--CM0007: Block 4 - Insert And Update into Temp Tables

		SELECT @Record_Code = @DM_Master_Import_Code, @Step_No = @Step_No + 1, @Sub_Step_No = 1, @Short_Status_Code = 'CM0007', @Proc_Name = 'USP_Content_Music_PIV'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
			
		INSERT INTO #Temp_Music(Name, RoleExists,Movie_Album)        
		SELECT DISTINCT a.Music_Track_Name, 'N',a.Movie_Album_Name FROM        
		(        
		SELECT [Music_Track] Music_Track_Name, [Movie_Album] Movie_Album_Name FROM DM_Content_Music (NOLOCK) WHERE ISNULL([Music_Track], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'       
		) AS a    
  
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

		--Added for Movie album
		INSERT INTO #Temp_Album(Name, RoleExists)        
		SELECT DISTINCT a.Movie_Album_Name, 'N' FROM        
		(        
			SELECT [Movie_Album] Movie_Album_Name FROM DM_Content_Music (NOLOCK) WHERE ISNULL([Music_Track], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'       
		) AS a

	  --INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code)      
	  --SELECT  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL From (   
	  --SELECT LTRIM(RTRIM(Name)) As DMNAME, 'CM' As DMMASTER_TYPE FROM #Temp_Music      
	  --WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (      
	  --SELECT Music_Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Title WHERE Is_Active = 'Y'    
	  --) 
	  --) As a 
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

		INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code,Movie_Album)      
		SELECT  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL, MOVIEALBUM From (   
			SELECT LTRIM(RTRIM(Name)) As DMNAME, 'CM' As DMMASTER_TYPE,Movie_Album As MOVIEALBUM FROM #Temp_Music      
			WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (      
				SELECT Music_Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Title (NOLOCK) WHERE Is_Active = 'Y'
				)  
			UNION
			SELECT LTRIM(RTRIM(Name)) As DMNAME, 'MA' As DMMASTER_TYPE, '' AS MOVIEALBUM FROM #Temp_Album      
			WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (      
				SELECT Music_Album_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Album (NOLOCK)
				)
			UNION  
			SELECT LTRIM(RTRIM(Name)) As DMNAME, 'CM' As DMMASTER_TYPE,Movie_Album As MOVIEALBUM FROM #Temp_Music      
			WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS IN (      
				SELECT Music_Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Title (NOLOCK) --WHERE Is_Active = 'Y'     
				)  AND Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (      
				SELECT Music_Album_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Album  (NOLOCK)
				)  
		) as a

	  --Left Join DM_Master_Log DM ON a.DMNAME collate SQL_Latin1_General_CP1_CI_AS = DM.Name collate SQL_Latin1_General_CP1_CI_AS AND      
	  --a.DMMASTER_TYPE collate SQL_Latin1_General_CP1_CI_AS = DM.Master_Type  collate SQL_Latin1_General_CP1_CI_AS    
	  --where ISNULL(DM.Master_Code,0)=0    
	
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  


		IF NOT EXISTS (SELECT TOP 1 DM_Master_Import_Code  From DM_Master_Log (NOLOCK)  where DM_Master_Import_Code = @DM_Master_Import_Code)  
		BEGIN  
			INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Roles,Is_Ignore,Mapped_By,Music_Album)        
			SELECT  @DM_Master_Import_Code , Name, Master_Type, Action_By, Action_On, null,'N','U',Movie_Album  FROM #Temp_Import    
		END  
	
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

		UPDATE T set T.Master_Code = DM.Master_Code,T.Mapped_By = CASE WHEN DM.Master_Code != 0 THEN 'S' ELSE 'U'END  
		FROM #Temp_Import T  
		INNER JOIN DM_Master_Log DM ON DM.Name  COLLATE SQL_Latin1_General_CP1_CI_AS = T.Name COLLATE SQL_Latin1_General_CP1_CI_AS 
		AND DM.Music_Album  COLLATE SQL_Latin1_General_CP1_CI_AS =T.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS  
		AND (DM.Master_Type = 'CM' OR DM.Master_Type = 'MA') AND DM.Is_Ignore = 'N'
	
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

		UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By  
		FROM DM_Master_Log D  
		INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Master_Type = 'CM' 
		AND T.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS = D.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS 
		WHERE ISNULL(D.Master_Code,0)=0 AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND D.Is_Ignore='N'
		
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  		
				
		UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By  
		FROM DM_Master_Log D  
		INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Master_Type = 'MA' 
		AND T.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS = D.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS 
		WHERE ISNULL(D.Master_Code,0)=0 AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND D.Is_Ignore='N'
	
		UPDATE T set T.Master_Code = DM.Master_Code,T.Mapped_By = CASE WHEN DM.Master_Code != 0 THEN 'S' ELSE 'U'END  
		FROM #Temp_Import T  
		INNER JOIN DM_Master_Log DM ON DM.Name  COLLATE SQL_Latin1_General_CP1_CI_AS = T.Name COLLATE SQL_Latin1_General_CP1_CI_AS  
		AND DM.Master_Type = 'MA' AND DM.Is_Ignore = 'N'

		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  


		UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By  
		FROM DM_Master_Log D  
		INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS 
		AND T.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS = D.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS 
		AND D.Master_Type = 'MA'
		WHERE ISNULL(D.Master_Code,0)=0 AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND D.Is_Ignore='N'
  
	  --CM0008: Block 5 -  Update DM_Master_Import and DM_Content_Music on the basis of some condition
	
		SELECT @Step_No = @Step_No + 1, @Sub_Step_No = 1, @Short_Status_Code = 'CM0008'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
	
	  DECLARE @MusicCount INT = 0 ,@SystemMappingCount INT=0 , @Record_Status VARCHAR(30)
     
	  SELECT @MusicCount = COUNT(*) FROM #Temp_Import    
	  SELECT @SystemMappingCount = COUNT(*) FROM #Temp_Import 
   
	  IF (@MusicCount > 0)        
	  BEGIN   
  		SELECT @MusicCount = COUNT(*) FROM DM_Master_Log (NOLOCK) Where DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND ISNULL(Master_Code, 0) = 0  AND Master_Type='CM'           
	  END  
        
	  IF (@SystemMappingCount > 0)        
	  BEGIN        
		SELECT @SystemMappingCount = COUNT(*) FROM DM_Master_Log (NOLOCK) Where DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND Master_Code != 0   AND Master_Type='CM'         
	  END
     
	  IF (@MusicCount > 0)        
	  BEGIN    
		 DECLARE @status VARCHAR(2)  
		 SELECT @status = STATUS FROM DM_Master_Import  WHERE DM_Master_Import_Code = @DM_Master_Import_Code  

		 IF(@status != 'I' )  
		 BEGIN   
	 
			UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
		
			SELECT @Sub_Step_No = @Sub_Step_No + 1
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  
  
		 END    
		  UPDATE D set D.Record_Status = Case When D.Record_Status IN('OR','MO') THEn 'MO' Else 'MR'END   
		  FROM DM_Content_Music D  INNER JOIN DM_Master_Log T ON T.DM_Master_Import_Code = @DM_Master_Import_Code  
		  WHERE T.Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Is_Ignore != 'Y' AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(T.Master_Code, 0) = 0 AND T.Mapped_By = 'U'  
		  AND T.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS = D.Movie_Album  COLLATE SQL_Latin1_General_CP1_CI_AS
	  
		 SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

	  END      
	  ELSE      
	  BEGIN        
		IF EXISTS (SELECT Status FROM  DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Status = 'R')  
		BEGIN  
			UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code   
			SELECT @Sub_Step_No = @Sub_Step_No + 1
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

		END  
		--Else  
		--BEGIN  
		--UPDATE DM_Master_Import SET [Status] = 'P' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
		--END  
	  --IF EXISTS (select Status from  DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code AND Status != 'R')  
	  --BEGIN  
	  -- UPDATE DM_Master_Import Set [Status] = 'P' Where DM_Master_Import_Code = @DM_Master_Import_Code         
	  -- END  
	  -- Else  
	  --  UPDATE DM_Master_Import Set [Status] = 'R' Where DM_Master_Import_Code = @DM_Master_Import_Code      
	  END      
   
	  IF (@SystemMappingCount > 0)        
	  BEGIN       
   
		DECLARE @SystemMAppingstatus VARCHAR(2) , @FileStatus VARCHAR(2) 
		SELECT @SystemMAppingstatus = status FROM DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
		SELECT @FileStatus = status FROM DM_Master_Import (NOLOCK)  WHERE DM_Master_Import_Code = @DM_Master_Import_Code
  
  
		IF(@SystemMAppingstatus != 'I' )  
		BEGIN 
			IF(@FileStatus = 'R')
			BEGIN  
				UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

			END 
			ELSE
			BEGIN
				UPDATE DM_Master_Import SET [Status] = 'SR' WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  
   
			END     
		END  
		UPDATE D set D.Record_Status = Case When D.Record_Status IN('OR','SO') THEn 'SO' Else 'SM'END   
		FROM DM_Content_Music D  INNER JOIN DM_Master_Log T ON T.DM_Master_Import_Code = @DM_Master_Import_Code  
		WHERE T.Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Is_Ignore != 'Y' AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND T.Master_Code != 0  AND T.Mapped_By = 'S'  
		AND T.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS = D.Movie_Album  COLLATE SQL_Latin1_General_CP1_CI_AS
	
		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

	  END      
	  ELSE      
	  BEGIN         
		IF EXISTS (SELECT Status FROM  DM_Master_Import  (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Status = 'R')  
		BEGIN  
				UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code   
		END
	   END
   		--Ignore DM_Content_Music Record for not valid track and album 
		UPDATE DCM SET DCM.Record_Status ='E', DCM.[Error_Message] = 'Combination not valid for Music Track And Album'
		FROM DM_Content_Music DCM
		WHERE DCM.Music_Title_Code NOT IN (SELECT MT.Music_Title_Code FROM Music_Title MT (NOLOCK) WHERE MT.Music_Album_Code = DCM.Movie_Album_Code)
		AND DM_Master_Import_Code=@DM_Master_Import_Code
		AND DCM.Music_Title_Code IS NOT NULL AND DCM.Movie_Album_Code IS NOT NULL  

		SELECT @Sub_Step_No = @Sub_Step_No + 1
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  


		IF EXISTS(SELECT Record_Status FROM DM_Content_Music (NOLOCK) WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
			BEGIN
				UPDATE DM_Master_Import Set [Status] = 'E' where DM_Master_Import_Code  = @DM_Master_Import_Code
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

			END  
		END TRY 
		BEGIN CATCH
			SELECT @Process_Error_MSG = ERROR_MESSAGE(), @Short_Status_Code = 'All03'

			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		END CATCH

		SET @StepCountOut = @Step_No

	--DROP TABLE #Temp_Music     
	--DROP TABLE #Temp_Import     
		IF OBJECT_ID('tempdb..#Temp_Import') IS NOT NULL DROP TABLE #Temp_Import
		IF OBJECT_ID('tempdb..#Temp_Music') IS NOT NULL DROP TABLE #Temp_Music
		IF OBJECT_ID('tempdb..#Temp_Album') IS NOT NULL DROP TABLE #Temp_Album
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_PIV]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''      
END