 CREATE PROC [dbo].[USP_Get_Music_Platform_Tree_Hierarchy]  
	 (  
		   @MusicPlatformCodes VARCHAR(2000),  
	       @Search_Music_Platform_Name NVARCHAR(500)  
	 )  
  AS  
  BEGIN  
  
  --Declare @MusicPlatformCodes Varchar(2000) = ''  
        IF(RTRIM(LTRIM(@Search_Music_Platform_Name)) <> '')  
        SET @Search_Music_Platform_Name = RTRIM(LTRIM(@Search_Music_Platform_Name))  
  
    CREATE TABLE #TEMP_MPF(  
	   Music_Platform_Code INT,  
       Parent_Code INT,  
       Is_Last_Level VARCHAR(2)  
		)  
     
    IF(@MusicPlatformCodes <> '')  
    BEGIN  
        INSERT INTO #TEMP_MPF  
			SELECT Music_Platform_Code, ISNULL(Parent_Code, 0), Is_Last_Level  
				 FROM [Music_Platform] WHERE Music_Platform_Code IN (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@MusicPlatformCodes, ',')) ORDER BY Platform_Name  
		    WHILE((     
				SELECT COUNT(*) FROM [Music_Platform] WHERE Music_Platform_Code IN (SELECT Parent_Code FROM #TEMP_MPF) AND Music_Platform_Code NOT IN (SELECT Music_Platform_Code FROM #TEMP_MPF)  
			) > 0)  
        BEGIN  
            INSERT INTO #TEMP_MPF  
				SELECT Music_Platform_Code, ISNULL(Parent_Code , 0), Is_Last_Level  
	    	FROM [Music_Platform] WHERE Music_Platform_Code  IN (SELECT Parent_Code FROM #TEMP_MPF) AND Music_Platform_Code NOT IN (SELECT Music_Platform_Code  FROM #TEMP_MPF)  
        END  
    END  
	 ELSE  
    BEGIN  
        INSERT INTO #TEMP_MPF(Music_Platform_Code, Parent_Code )  
			 SELECT Music_Platform_Code, ISNULL(Parent_Code , 0) FROM [Music_Platform]  
    End  
  
    SELECT Music_Platform_Code, REPLACE(Platform_Name,@Search_Music_Platform_Name  
    --,'<span style="background-color:yellow">'+@Search_Platform_Name+'</span>') AS Platform_Name  
		,'<span style="background-color:yellow">'  
            + (SUBSTRING(Platform_Name,CHARINDEX(@Search_Music_Platform_Name,Platform_Name ,0),CHARINDEX(@Search_Music_Platform_Name,Platform_Name ,0) + (LEN(@Search_Music_Platform_Name)  - CHARINDEX(@Search_Music_Platform_Name,Platform_Name,0))) +'</span
				>')  
            ) AS Platform_Name  
		, ISNULL(Parent_Code, 0) Parent_Code, Is_Last_Level, Module_Position,  
			(SELECT COUNT(*) FROM #TEMP_MPF tmp WHERE tmp.Parent_Code = [Music_Platform].Music_Platform_Code) ChildCount  
				 From [Music_Platform] WHERE Is_Active = 'Y'  
					And Music_Platform_Code In (SELECT Music_Platform_Code FROM #TEMP_MPF)  
						--AND (Platform_Hiearachy LIKE  '%'+@Search_Platform_Name+'%' or ISNULL(@Search_Platform_Name,'') = '')  
			 ORDER BY Module_Position  
    --Select Platform_Code, Platform_Name, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position From [Platform] Where Is_Active = 'Y' Order By Module_Position  
	 DROP TABLE #TEMP_MPF  
 END  
  
--/*  
  
--Exec USP_Get_Music_Platform_Tree_Hierarchy '1','Promotional'  
  
--*/  