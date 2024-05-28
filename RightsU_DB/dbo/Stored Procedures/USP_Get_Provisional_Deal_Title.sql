CREATE PROC [dbo].[USP_Get_Provisional_Deal_Title]     
@SearchString NVARCHAR(MAX),    
@Deal_Type_Code INT     
AS    
BEGIN    
	 Declare @Loglevel int;
	 select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Provisional_Deal_Title]', 'Step 1', 0, 'Started Procedure', 0, ''
		  --DECLARE @SearchString NVARCHAR(MAX)='2017'    
		  IF(@SearchString='')  
		  BEGIN  
			SELECT DISTINCT TIT.Title_Code, TIT.Title_Name FROM Title TIT (NOLOCK)    
		 WHERE TIT.Deal_Type_Code=@Deal_Type_Code  AND   TIT.Title_Code not in (SELECT Title_Code FROM Acq_Deal_Movie (NOLOCK))
		  END  
		  ELSE  
		  BEGIN  
		  SELECT DISTINCT TIT.Title_Code, TIT.Title_Name FROM Title TIT  (NOLOCK) 
		 LEFT JOIN Title_Talent TT (NOLOCK) ON TT.Title_Code = TIT.Title_Code    
		 LEFT JOIN Talent TAT (NOLOCK) ON TAT.Talent_Code = TT.Talent_Code    
		 LEFT JOIN Title_Geners TG (NOLOCK) ON TG.Title_Code = TIT.Title_Code    
		 LEFT JOIN Genres G (NOLOCK) ON G.Genres_Code = TG.Genres_Code    
		 WHERE     
		 (    
		  (TAT.Talent_Name LIKE '%'+@SearchString+'%' OR '' <> '') OR     
		  (G.Genres_Name LIKE '%'+@SearchString+'%' OR ''<>'' ) OR     
		  (TIT.Year_Of_Production LIKE '%'+@SearchString+'%' OR ''<>'') OR
		  (TIT.Title_Name LIKE '%'+@SearchString+'%' OR ''<>'')
		 )    
		 AND TIT.Deal_Type_Code=@Deal_Type_Code  
		 AND   TIT.Title_Code not in (SELECT Title_Code  FROM Acq_Deal_Movie (NOLOCK))  
		  END  
   
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Provisional_Deal_Title]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
