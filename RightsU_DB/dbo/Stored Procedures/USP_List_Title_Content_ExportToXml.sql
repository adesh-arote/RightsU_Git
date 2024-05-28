CREATE PROCEDURE [dbo].[USP_List_Title_Content_ExportToXml]   
(              
	@Title_Content_Code NVARCHAR(MAX)             
)  
AS  
BEGIN  
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_List_Title_Content_ExportToXml]', 'Step 1', 0, 'Started Procedure', 0, '' 
	 --DECLARE  
	 --@Duration Decimal  
	 --DECLARE  
	 -- @Title_Content_Code NVARCHAR(MAX)  = '7129,7118,7117,7116,7115,7114,7113,7112,7111,7110'  
	  IF(OBJECT_ID('TEMPDB..#tempA') IS NOT NULL)            
			 DROP TABLE #tempA  
		    
		SET @Title_Content_Code = ISNULL(@Title_Content_Code, 0)    
		SELECT DISTINCT   
			ISNULL(TC.Ref_BMS_Content_Code, '') AS [BMS_Content_Code],
			TC.Title_Content_Code AS [RU_PROGRAM_FOREIGN_ID], 
			V.Version_Code AS [RU_VERSION_ID],  
			TC.Episode_Title AS [RU_PROGRAM_EPISODE_TITLE],  
			TC.Episode_Title AS [RU_PROGRAM_EPG_TITLE],  
			T.Title_Name AS [MAINTITLE],  
			ISNULL(T.Synopsis, '') AS [RU_PROGRAM_SYNOPSIS],   
			 STUFF((  
				SELECT DISTINCT ',' +  CAST(T.Talent_Name AS NVARCHAR(MAX))  FROM Title_Talent TT  (NOLOCK)
					INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Code = TT.Title_Code  
					INNER JOIN Talent T (NOLOCK) on TT.Talent_Code = T.Talent_Code        
					INNER JOIN Role R (NOLOCK) ON R.Role_Code = TT.Role_Code    
				WHERE R.Role_Code = '2'  AND TC.Title_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Content_Code,',')) 
			FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_STARCAST],  
			 STUFF((  
				SELECT DISTINCT ',' +  CAST(L.Language_Name AS NVARCHAR(MAX))  FROM Language L (NOLOCK)
					INNER JOIN Title T (NOLOCK) ON T.Title_Language_Code = L.Language_Code
					INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Code = T. Title_Code
				WHERE TC.Title_Content_Code IN (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@Title_Content_Code,','))
			FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_LANGUAGE],  
			STUFF((  
				SELECT DISTINCT ',' +  CAST(G.Genres_Name AS NVARCHAR(MAX))  FROM Genres  G  (NOLOCK)    
					INNER JOIN Title_Geners TG (NOLOCK) on T.Title_Code = TG.Title_Code        
				WHERE G.Genres_Code = TG.Genres_Code  
			FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_GENRE],  
			 CAST(T.Year_Of_Production AS  VARCHAR(500)) AS  [RU_PROGRAM_YEAROFRELEASE],
			 CASE WHEN TCV.Duration IS NULL THEN TC.Duration ELSE TCV.Duration END AS [RU_PROGRAM_DURATION],  
			  STUFF((  
				SELECT DISTINCT ',' +  CAST(C.Country_Name AS NVARCHAR(MAX))  FROM Country C (NOLOCK)     
					INNER JOIN Title_Country TC (NOLOCK) on T.Title_Code = TC.Title_Code        
				WHERE C.Country_Code = TC.Country_Code  
			FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_COUNTRY],  
			 STUFF((  
				SELECT DISTINCT ',' +  CAST(T.Talent_Name AS NVARCHAR(MAX))  FROM Title_Talent TT (NOLOCK)
					INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Code = TT.Title_Code  
					INNER JOIN Talent T (NOLOCK) on TT.Talent_Code = T.Talent_Code        
					INNER JOIN Role R (NOLOCK) ON R.Role_Code = TT.Role_Code    
				WHERE R.Role_Code = '1'  AND TC.Title_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Content_Code,',')) 
			FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_DIRECTOR],  
			 STUFF((  
				SELECT DISTINCT ',' +  CAST(T.Talent_Name AS NVARCHAR(MAX))  FROM Title_Talent TT (NOLOCK)
					INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Code = TT.Title_Code  
					INNER JOIN Talent T (NOLOCK) on TT.Talent_Code = T.Talent_Code        
					INNER JOIN Role R (NOLOCK) ON R.Role_Code = TT.Role_Code    
				WHERE R.Role_Code = '4'  AND TC.Title_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Content_Code,',')) 
			FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_PRODUCER],
			 STUFF((  
			SELECT DISTINCT ',' +  CAST(DT.Deal_Type_Name AS NVARCHAR(MAX))  FROM Deal_Type DT (NOLOCK)
					INNER JOIN Title T (NOLOCK) on DT.Deal_Type_Code = T.Deal_Type_Code   
					INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Code = T.Title_Code       
				WHERE TC.Title_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Content_Code,',')) 
				 FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_CATEGORY],
			'' AS [RU_VERSION_MEDIA], 
			GETDATE() AS RU_PROGRAM_UPDATE_DATETIME,  
			TC.Episode_Title AS [RU_PROGRAM_EPISODE_SEASON],  
			TC.Episode_Title AS [RU_PROGRAM_LISTING_TITLE], 
			CONCAT(TC.Episode_Title ,'-',CAST(TC.Episode_No AS varchar(10))) AS [RU_PROGRAM_TITLE],
			'RightsU' AS RU_PROGRAM_UPDATE_USER,  
			'RightsU' AS RU_PROGRAM_CREATE_USER,  
			'' AS RU_PROGRAM_IS_ARCHVIED  
			INTO #tempA
		 FROM Title_Content TC (NOLOCK)  
			  INNER  JOIN Title T (NOLOCK) ON TC.Title_Code = T.Title_Code  
			  INNER JOIN Title_Content_Version TCV (NOLOCK) ON TC.Title_Content_Code = TCV.Title_Content_Code  
			  INNER JOIN Version V (NOLOCK) ON TCV.Version_Code = V.Version_Code   
		 WHERE
		 TC.Title_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Content_Code,','))
	         
			 --TC.Title_Content_Code = @Title_Content_Code OR @Title_Content_Code = 0   
			  SELECT * FROM #tempA ORDER BY RU_PROGRAM_FOREIGN_ID DESC

		IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
	 --Select   
	 -- '' AS BMS_Content_Code,  
	 -- 0 AS [RU_PROGRAM_FOREIGN_ID],  
	 -- 0 AS [RU_VERSION_ID],   
	 -- '' AS [RU_PROGRAM_EPISODE_TITLE],  
	 -- '' AS [RU_PROGRAM_EPG_TITLE],  
	 -- '' AS [MAINTITLE],  
	 -- '' AS [RU_PROGRAM_SYNOPSIS],  
	 -- '' AS [RU_PROGRAM_STARCAST],
	 -- '' AS [RU_PROGRAM_LANGUAGE],    
	 -- '' AS [RU_PROGRAM_GENRE],  
	 -- '' AS [RU_PROGRAM_YEAROFRELEASE],  
	 -- @Duration AS [RU_PROGRAM_DURATION], 
	 -- '' AS [RU_PROGRAM_COUNTRY],
	 -- '' AS [RU_PROGRAM_DIRECTOR],
	 -- '' AS [RU_PROGRAM_PRODUCER],  
	 -- '' AS [RU_PROGRAM_CATEGORY],  
	 -- '' AS [RU_VERSION_MEDIA],  
	 -- GETDATE() AS RU_PROGRAM_UPDATE_DATETIME, 
	 --  '' AS [RU_PROGRAM_EPISODE_SEASON],  
	 -- '' AS [RU_PROGRAM_LISTING_TITLE],   
	 --  '' AS [RU_PROGRAM_TITLE],
	 -- '' AS RU_PROGRAM_UPDATE_USER,  
	 -- '' AS RU_PROGRAM_CREATE_USER,  
	 -- '' AS RU_PROGRAM_IS_ARCHVIED  
  
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_List_Title_Content_ExportToXml]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END