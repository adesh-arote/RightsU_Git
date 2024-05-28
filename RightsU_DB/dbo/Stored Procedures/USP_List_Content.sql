CREATE PROCEDURE [dbo].[USP_List_Content]  
(  
 @searchText NVARCHAR(MAX) = NULL,   
 @episodeFrom INT = NULL,   
 @episodeTo INT = NULL  
)  
AS  
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Content]', 'Step 1', 0, 'Started Procedure', 0, '' 

	 --DECLARE  
	 --@searchText NVARCHAR(MAX) = 'Maanmarziyan~',   
	 --@episodeFrom INT = 0,   
	 --@episodeTo INT = 0
  
		IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)
			DROP TABLE #Temp

	 DECLARE @dealTypeCodeForAllowAssignMusic VARCHAR(150) = ''  
	 SELECT TOP 1 @dealTypeCodeForAllowAssignMusic = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DealTypeCodeFor_TitleContentList'--'DealTypeCodeFor_AllowAssignMusic'  
    
		IF  (@searchText = '' AND (@episodeFrom = 0 AND @episodeTo = 0))  
		BEGIN 
				PRINT 'A' 
				PRINT 'Search Text = ' + @searchText + ' Episode From = ' + CAST(@episodeFrom AS VARCHAR(MAX)) + ' Episode To = ' + CAST(@episodeTo AS VARCHAR(MAX))
			   SELECT  top 10  
			   TC.Title_Content_Code,  
			   COALESCE(TC.Episode_Title, T.Title_Name) AS Title_Name,   
			   CASE
				WHEN T.Deal_Type_Code = 1 THEN 'Episode 1'
				ELSE 'Episode ' + CAST(TC.Episode_No AS VARCHAR)
			   END AS Episode,  
			   ISNULL(TC.Duration, 0) AS Duration_In_Min ,  
			   (SELECT COUNT(*) FROM Content_Music_Link CML (NOLOCK) WHERE CML.Title_Content_Code=TC.Title_Content_Code) AS NumberOfSongs ,  
			   TC.Last_Updated_Time,  
			   STUFF((  
			   SELECT DISTINCT TOP 3 ', ' +  CAST(C.Channel_Name AS NVARCHAR(MAX))  FROM Channel  C  (NOLOCK)    
			   INNER JOIN Content_Channel_Run CCR (NOLOCK) on CCR.Channel_Code = C.Channel_Code        
			   WHERE CCR.Title_Content_Code = TC.Title_Content_Code      
			   AND CCR.Is_Archive ='N'    
			   AND CONVERT(date,GETDATE(),103) BETWEEN CONVERT(date,CCR.Rights_Start_Date,103) AND CONVERT(date,CCR.Rights_End_Date,103)      
			   FOR XML PATH(''),root('MyString'), type   
				 ).value('/MyString[1]','nvarchar(max)')   
				, 1, 1, '') As [Channel_Name]    
			   FROM Title_Content TC (NOLOCK)
			   INNER JOIN Title T (NOLOCK) ON TC.Title_Code = T.Title_Code and   
			   T.Deal_Type_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@dealTypeCodeForAllowAssignMusic, ','))  
			   LEFT JOIN Title_Content_Mapping TCM (NOLOCK) ON TCM.Title_Content_Code = TC.Title_Content_Code
			   ORDER BY  TC.Title_Content_Code desc    
		END
		ELSE --IF  (@searchText <> '' AND (@episodeFrom = 0 AND @episodeTo = 0))  
		BEGIN  
			PRINT 'B'
			PRINT 'Search Text = ' + @searchText + ' Episode From = ' + CAST(@episodeFrom AS VARCHAR(MAX)) + ' Episode To = ' + CAST(@episodeTo AS VARCHAR(MAX))
			   SELECT  DISTINCT
					TC.Title_Content_Code,  
					COALESCE(TC.Episode_Title, T.Title_Name) AS Title_Name,
					  CASE
						WHEN T.Deal_Type_Code = 1 THEN 'Episode 1'
						ELSE 'Episode ' + CAST(TC.Episode_No AS VARCHAR)
					  END AS Episode,  
					ISNULL(TC.Duration, 0) AS Duration_In_Min ,  
					(SELECT COUNT(*) FROM Content_Music_Link CML (NOLOCK) WHERE CML.Title_Content_Code=TC.Title_Content_Code) AS NumberOfSongs ,  
					TC.Last_Updated_Time,  
					STUFF((  
					SELECT DISTINCT TOP 3 ', ' +  CAST(C.Channel_Name AS NVARCHAR(MAX))  FROM Channel  C  (NOLOCK)   
					INNER JOIN Content_Channel_Run CCR (NOLOCK) on CCR.Channel_Code = C.Channel_Code        
					WHERE CCR.Title_Content_Code = TC.Title_Content_Code      
					AND CCR.Is_Archive ='N'    
					AND CONVERT(date,GETDATE(),103) BETWEEN CONVERT(date,CCR.Rights_Start_Date,103) AND CONVERT(date,CCR.Rights_End_Date,103)      
					FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, '') As [Channel_Name],
					Episode_No
					INTO #temp
					   FROM Title_Content TC (NOLOCK)  
		   
			   INNER JOIN Title T (NOLOCK) ON TC.Title_Code = T.Title_Code and   
			   T.Deal_Type_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@dealTypeCodeForAllowAssignMusic, ','))  
			   LEFT JOIN Title_Content_Mapping TCM (NOLOCK) ON TCM.Title_Content_Code = TC.Title_Content_Code
				 WHERE (  
				T.Title_Name IN (SELECT NUMBER FROM fn_Split_withdelemiter(@searchText, '~'))   
				OR TC.Episode_Title IN (SELECT NUMBER FROM fn_Split_withdelemiter(@searchText, '~'))  
				)  
		   
		   
				IF(@episodeFrom = 0 AND @episodeTo = 0)
		  			select Title_Content_Code,Title_Name, Episode,	Duration_In_Min, NumberOfSongs,	Last_Updated_Time, Channel_Name from #temp ORDER BY Title_Name, Episode_No    
				ELSE IF (@episodeFrom <> 0 AND @episodeTo = 0)
					select Title_Content_Code,Title_Name, Episode,	Duration_In_Min, NumberOfSongs,	Last_Updated_Time, Channel_Name  from #temp 
					WHERE  Episode_No >= @episodeFrom ORDER BY Title_Name, Episode_No     
				ELSE IF (@episodeFrom = 0 AND @episodeTo <> 0)
					select Title_Content_Code,Title_Name, Episode,	Duration_In_Min, NumberOfSongs,	Last_Updated_Time, Channel_Name  from #temp 
					WHERE Episode_No <= @episodeTo ORDER BY Title_Name, Episode_No    
				ELSE
					select Title_Content_Code,Title_Name, Episode,	Duration_In_Min, NumberOfSongs,	Last_Updated_Time, Channel_Name  from #temp 
					WHERE Episode_No BETWEEN @episodeFrom AND @episodeTo  ORDER BY Title_Name, Episode_No    
		END

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Content]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END
