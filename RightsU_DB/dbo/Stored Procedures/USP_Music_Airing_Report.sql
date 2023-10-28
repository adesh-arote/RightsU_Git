
CREATE PROCEDURE [dbo].[USP_Music_Airing_Report]      
(      
 @Title_Content_Code varchar(100),      
 @Episode_From varchar(25),      
 @Episode_To varchar(25),      
 @Date_From varchar(25),      
 @Date_To varchar(25),      
 @Music_Title_Code varchar(100),      
 @Channel_Code varchar(100)      
)      
AS       
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Music_Airing_Report]', 'Step 1', 0, 'Started Procedure', 0, ''
	 --DECLARE  
	 --@Title_Content_Code varchar(100),      
	 --@Episode_From varchar(25),      
	 --@Episode_To varchar(25),      
	 --@Date_From varchar(25),      
	 --@Date_To varchar(25),      
	 --@Music_Title_Code varchar(100),      
	 --@Channel_Code varchar(100)    
  
	 --SET @Title_Content_Code =''  
	 --SET @Episode_From =''      
	 --SET @Episode_To =''     
	 --SET @Date_From ='24-Jan-2018'      
	 --SET @Date_To  ='30-Jan-2018'   
	 --SET @Music_Title_Code  =''     
	 --SET @Channel_Code  ='4'    
	 IF(OBJECT_ID('TEMPDB..#TempTC') IS NOT NULL)  
	 DROP TABLE #TempTC  
  
	 select DIStinct TC1.Title_Code As Title_Code  
	 INTO #TempTC FROM Title_Content AS TC1 (NOLOCK) where TC1.Title_Content_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Title_Content_Code, ','))  

	 SELECT --*
	  TC.Episode_Title AS [Content], TC.Episode_No As [Episode No.],MT.Music_Title_Name As [Music Track],      
     
	 Convert(Datetime,(Convert(varchar(50),BST.Schedule_Item_Log_Date,106) + ' ' + Schedule_Item_Log_Time),120) as [Airing Date : Time],    
	 CML.[From] AS [TC IN], CML.[To] As [TC OUT],      
	 CML.Duration As Duration, C.Channel_Name As Channels,  
	 V.Version_Name,  
	 P.Program_Name AS [Program Name]
	 , CASE WHEN ISNULL(MT.Movie_Album_Type,'A')='A' THEN (select MA.Music_Album_Name from Music_Album MA Where MA.Music_Album_Code = MT.Music_Album_Code)
		ELSE (select TA.Title_Name from Title TA Where TA.Title_Code = MT.Title_Code) END AS Music_Album
	 , REVERSE( STUFF(REVERSE(STUFF((
	   Select DISTINCT  RTRIM(LTRIM(ML.Music_Label_Name))+', '  from Music_Label ML  
	   INNER JOIN Music_Title_Label MTL ON ML.Music_Label_Code = MTL.Music_Label_Code AND MTL.Music_Title_Code = MT.Music_Title_Code
		FOR XML PATH(''), root('Music_Label_Name'), type  
			).value('/Music_Label_Name[1]','Nvarchar(max)'),2,0, '')), 1, 2, ''))
	  AS Music_Label_Name  
	 from Title_Content TC  (NOLOCK)    
	 --INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code      
	 INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Title_Content_Code = TC.Title_Content_Code
	 INNER JOIN BV_Schedule_Transaction BST (NOLOCK) ON BST.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code --ON BST.Deal_Movie_Code = TCM.Acq_Deal_Movie_Code AND BST.Program_Episode_Number = TC.Episode_No      
	 INNER JOIN Content_Music_Link CML (NOLOCK) ON CML.Title_Content_Code = TC.Title_Content_Code      
	 INNER JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = CML.Music_Title_Code      
	 INNER JOIN Channel C (NOLOCK) on C.Channel_Code = BST.Channel_Code     
	 INNER JOIN Title_Content_Version TCV (NOLOCK) ON TCV.Title_Content_Code = CML.Title_Content_Code AND TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code    
	 INNER JOIN [Version] V (NOLOCK) ON V.Version_Code = TCV.Version_Code  
	 INNER JOIN Title T (NOLOCK) ON  TC.Title_Code = T.Title_Code  
	 LEFT JOIN Program P (NOLOCK) ON T.Program_Code = P.Program_Code  
	 where (@Title_Content_Code = '' OR TC.Title_Code IN(select Title_Code FROM #TempTC))  
	 AND C.Channel_Code IN((SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@Channel_Code, ',') WHERE NUMBER <> ''))         
	 AND (MT.Music_Title_Code IN((SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@Music_Title_Code, ',') WHERE NUMBER <> '')) OR @Music_Title_Code = '')      
	 AND ((@Episode_From <> '' AND Tc.Episode_No >= @Episode_From ) OR @Episode_From = '')      
	 AND ((@Episode_To <> '' AND TC.Episode_No <= @Episode_To) OR @Episode_To = '')      
	 AND ((CONVERT(DATE, BST.Schedule_Item_Log_Date,103) >= CONVERT(DATE, @Date_From,103)))      
	 AND ((CONVERT(DATE,BST.Schedule_Item_Log_Date,103) <= CONVERT(DATE,@Date_To,103)))   
      
		 --IF(OBJECT_ID('TEMPDB..#TempTC') IS NOT NULL)  
		 --DROP TABLE #TempTC  

		IF OBJECT_ID('tempdb..#TempTC') IS NOT NULL DROP TABLE #TempTC
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Music_Airing_Report]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END