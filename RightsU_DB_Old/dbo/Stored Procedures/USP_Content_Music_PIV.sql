CREATE PROCEDURE [dbo].[USP_Content_Music_PIV]      
 @DM_Master_Import_Code VARCHAR(500),      
 @User_Code INT=143      
AS  
	--declare @DM_Master_Import_Code VARCHAR(500) = 6179,
	--@User_Code INT = 143
	      
BEGIN      

	--"CM" id content Music DM_Master_Log table
	CREATE TABLE #Temp_Import      
	(      
	-- Temp Import Data      
		ID INT IDENTITY(1,1),      
		DM_Master_Import_Code VARCHAR(500),      
		Name NVARCHAR(100),      
		Master_Type VARCHAR(100),      
		Action_By INT,      
		Action_On DATETIME,      
		Roles VARCHAR(100),    
		--DM_Master_Log_Code INT,
		Master_Code INT,
		Mapped_By CHAR(1)
	)      
	-- Director Data      
	CREATE TABLE #Temp_Music      
	(       
		Name NVARCHAR(1000),      
		MusicTitleCode INT,      
		RoleExists CHAR(1)      
	)  

	INSERT INTO #Temp_Music(Name, RoleExists)      
	  SELECT DISTINCT a.Music_Track_Name, 'N' FROM      
	  (      
	   SELECT [Music_Track] Music_Track_Name FROM DM_Content_Music WHERE ISNULL([Music_Track], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'     
	  ) AS a  
	
	INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code)    
	SELECT  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL From ( 
		SELECT LTRIM(RTRIM(Name)) As DMNAME, 'CM' As DMMASTER_TYPE FROM #Temp_Music    
		WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (    
		SELECT Music_Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Title    
		)  ) As a    
		--Left Join DM_Master_Log DM ON a.DMNAME collate SQL_Latin1_General_CP1_CI_AS = DM.Name collate SQL_Latin1_General_CP1_CI_AS AND    
		--a.DMMASTER_TYPE collate SQL_Latin1_General_CP1_CI_AS = DM.Master_Type  collate SQL_Latin1_General_CP1_CI_AS  
		--where ISNULL(DM.Master_Code,0)=0  

	IF NOT EXISTS (SELECT TOP 1 DM_Master_Import_Code  From DM_Master_Log  where DM_Master_Import_Code = @DM_Master_Import_Code)
	BEGIN
		INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Roles,Is_Ignore,Mapped_By)      
		SELECT  @DM_Master_Import_Code , Name, Master_Type, Action_By, Action_On, null,'N','U'  FROM #Temp_Import  
	END


	UPDATE T set T.Master_Code = DM.Master_Code,T.Mapped_By = CASE WHEN DM.Master_Code != 0 THEN 'S' ELSE 'U'END
	FROM #Temp_Import T
	INNER JOIN DM_Master_Log DM ON DM.Name  COLLATE SQL_Latin1_General_CP1_CI_AS = T.Name COLLATE SQL_Latin1_General_CP1_CI_AS
	AND DM.Master_Type = 'CM' AND DM.Is_Ignore = 'N'
	

	UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By
	FROM DM_Master_Log D
	INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Master_Type = 'CM'
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
	  UPDATE D set D.Record_Status = Case When D.Record_Status IN('OR','MO') THEn 'MO' Else 'MR'END 
	  FROM DM_Content_Music D  INNER JOIN DM_Master_Log T ON T.DM_Master_Import_Code = @DM_Master_Import_Code
	  WHERE T.Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Is_Ignore != 'Y' AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(T.Master_Code, 0) = 0 AND T.Mapped_By = 'U'
	
	 END    
	 ELSE    
	 BEGIN      
	  IF EXISTS (SELECT Status FROM  DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Status = 'R')
	  BEGIN
	  UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
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
	
	 declare @SystemMAppingstatus Varchar(2)
	 select @SystemMAppingstatus = status from DM_Master_Import  where DM_Master_Import_Code = @DM_Master_Import_Code

	 if(@SystemMAppingstatus != 'I' )
	 Begin 
	  UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
	  END
	  UPDATE D set D.Record_Status = Case When D.Record_Status IN('OR','SO') THEn 'SO' Else 'SM'END 
	  FROM DM_Content_Music D  INNER JOIN DM_Master_Log T ON T.DM_Master_Import_Code = @DM_Master_Import_Code
	  WHERE T.Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Is_Ignore != 'Y' AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND T.Master_Code != 0  AND T.Mapped_By = 'S'
	
	 END    
	 ELSE    
	 BEGIN   
	    
	  IF EXISTS (SELECT Status FROM  DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Status = 'R')
	  BEGIN
	  UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
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
DROP TABLE #Temp_Music   
DROP TABLE #Temp_Import   

END

