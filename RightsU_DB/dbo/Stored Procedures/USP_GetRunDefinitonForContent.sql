CREATE PROCEDURE [dbo].[USP_GetRunDefinitonForContent]                
(                
@Title_Content_Code INT,                
@Type CHAR(1),        
@Channel_Code INT,        
@Start_Date VARCHAR(10),        
@End_Date VARCHAR(10),        
@Deal_Type CHAR(1),        
@Is_active CHAR(1)        
)                
AS                
BEGIN    
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetRunDefinitonForContent]', 'Step 1', 0, 'Started Procedure', 0, ''
		--declare
		--@Title_Content_Code INT = 22433,          
		--@Type CHAR(1) = '',        
		--@Channel_Code INT = 0,        
		--@Start_Date VARCHAR(10)='',        
		--@End_Date VARCHAR(10)='',        
		--@Deal_Type CHAR(1)='',        
		--@Is_active CHAR(1)='C'        

		IF(@Is_Active = 'Y' AND @Deal_Type != '')        
		BEGIN               
		   SELECT CCR.Channel_Code, IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,IIF(Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type,Replace(CONVERT(VARCHAR,Rights_Start_Date, 106),' ','-')  AS Rights_Start_Date,Replace(CONVERT(VARCHAR,Rights_End_Date, 106),' ','-')  AS Rights_End_Date, C.Channel_Name,RU.Right_Rule_Name,CCR.Defined_Runs,CCR.Schedule_Runs                
		   ,IIF(Defined_Runs IS NULL,'',Defined_Runs-Schedule_Runs) AS Balanced_Runs  FROM Content_channel_Run CCR  (NOLOCK)                
		 LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.Right_Rule_Code                
		 INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.Channel_Code WHERE Title_Content_Code = @Title_Content_Code AND CCR.Is_Archive = 'N'        
		  AND CONVERT(date,CCR.Rights_End_Date,103) > CONVERT(date,GETDATE(),103) AND (@Channel_Code = 0 OR CCR.Channel_Code = @Channel_Code) AND  (ISNULL (CONVERT(date,CCR.Rights_Start_Date,103),'')>= CONVERT(date,@Start_Date,103) OR @Start_Date = '')           
  
    
      
       
		 AND (ISNULL(CONVERT(date,CCR.Rights_End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')          
		 AND ((@Deal_Type = 'A' and CCR.Acq_Deal_Code IS NOT NULL) OR (@Deal_Type = 'P' and CCR.Provisional_Deal_Code IS NOT NULL))          
		 ORDER BY CCR.Rights_Start_Date ASC,C.Channel_Name Asc        
		END            
		ELSE IF(@Is_Active = 'Y' AND @Deal_Type = '')        
		BEGIN       

		   SELECT DISTINCT  C.Channel_Code,
		   IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,IIF(Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type,Replace(CONVERT(VARCHAR,Rights_Start_Date, 106),' ','-')  AS Rights_Start_Date,Replace(CONVERT(VARCHAR,Rights_End_Date, 106),' ','-')  AS Rights_End_Date,
			C.Channel_Name,
		   RU.Right_Rule_Name,CCR.Defined_Runs,CCR.Schedule_Runs                
		   ,IIF(Defined_Runs IS NULL,'',Defined_Runs-Schedule_Runs) AS Balanced_Runs 
		   INTO #Temp_Content_channel_Run    
		   FROM Content_channel_Run CCR (NOLOCK)            
		 LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.Right_Rule_Code                
		 LEFT JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.Channel_Code AND CCR.Run_Def_Type = 'C'
		 WHERE Title_Content_Code = @Title_Content_Code AND CCR.Is_Archive = 'N'        
		 AND CONVERT(date,CCR.Rights_End_Date,103) > CONVERT(date,GETDATE(),103) AND (@Channel_Code = 0 OR CCR.Channel_Code = @Channel_Code) 
		 AND  (ISNULL (CONVERT(date,CCR.Rights_Start_Date,103),'')>= CONVERT(date,@Start_Date,103) OR @Start_Date = '')              
		 AND (ISNULL(CONVERT(date,CCR.Rights_End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')         
		 --ORDER BY CCR.Rights_Start_Date ASC,C.Channel_Name Asc 

		 UPDATE	 TC  set TC.Channel_Name =	STUFF(
					(Select Distinct ', ' + CAST(C.Channel_Name as NVARCHAR) From Channel C (NOLOCK)
					INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Channel_Code = C.Channel_Code
					 WHERE CCR.Title_Content_Code = @Title_Content_Code AND CCR.Run_Def_Type <> 'C' and CCR.Defined_Runs = TC.Defined_Runs 
						--Where ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
					FOR XML PATH('')), 1, 1, '') FROM #Temp_Content_channel_Run TC WHERE   TC.Channel_Name IS NULL  

		SELECT * FROM #Temp_Content_channel_Run

		DROP TABLE #Temp_Content_channel_Run


		END        
		ELSE IF(@Is_active = 'N' AND @Deal_Type != '')        
		BEGIN        
		  SELECT  CCR.Channel_Code, IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,IIF(Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type,Replace(CONVERT(VARCHAR,Rights_Start_Date, 106),' ','-')  AS Rights_Start_Date,Replace(CONVERT(VARCHAR,Rights_End_Date, 106),' ','-')  AS Rights_End_Date, C.Channel_Name,RU.Right_Rule_Name,CCR.Defined_Runs,CCR.Schedule_Runs                
		   ,IIF(Defined_Runs IS NULL,'',Defined_Runs-Schedule_Runs) AS Balanced_Runs  FROM Content_channel_Run CCR  (NOLOCK)                
		   LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.Right_Rule_Code                
		   INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.Channel_Code WHERE Title_Content_Code = @Title_Content_Code  AND CCR.Is_Archive = 'N'        
			 AND CCR.Rights_End_Date < GETDATE() AND (@Channel_Code = 0 OR CCR.Channel_Code = @Channel_Code)  AND  (ISNULL (CONVERT(date,CCR.Rights_Start_Date,103),'')>= CONVERT(date,@Start_Date,103) OR @Start_Date = '')                  
		  AND (ISNULL(CONVERT(date,CCR.Rights_End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')         
		   AND ((@Deal_Type = 'A' and CCR.Acq_Deal_Code IS NOT NULL) OR (@Deal_Type = 'P' and CCR.Provisional_Deal_Code IS NOT NULL))          
		   ORDER BY CCR.Rights_Start_Date ASC,C.Channel_Name Asc        
		END        
		ELSE IF(@Is_active = 'N' AND @Deal_Type = '')        
		BEGIN        
		  SELECT  CCR.Channel_Code, IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,IIF(Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type,Replace(CONVERT(VARCHAR,Rights_Start_Date, 106),' ','-')  AS Rights_Start_Date,Replace(CONVERT(VARCHAR,Rights_End_Date, 106),' ','-')  AS Rights_End_Date, C.Channel_Name,RU.Right_Rule_Name,CCR.Defined_Runs,CCR.Schedule_Runs                
		   ,IIF(Defined_Runs IS NULL,'',Defined_Runs-Schedule_Runs) AS Balanced_Runs  FROM Content_channel_Run CCR  (NOLOCK)                
		   LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.Right_Rule_Code                
		   INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.Channel_Code WHERE Title_Content_Code = @Title_Content_Code AND CCR.Is_Archive = 'N'        
			AND CONVERT(date,CCR.Rights_End_Date,103) < CONVERT(date,GETDATE(),103) AND (@Channel_Code = 0 OR CCR.Channel_Code = @Channel_Code)  AND  (ISNULL (CONVERT(date,CCR.Rights_Start_Date,103),'')>= CONVERT(date,@Start_Date,103) OR @Start_Date = '')        
  
    
      
          
		  AND (ISNULL(CONVERT(date,CCR.Rights_End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')         
		  ORDER BY CCR.Rights_Start_Date ASC,C.Channel_Name Asc        
		END        
		ELSE IF(@Is_active = 'C')        
		BEGIN     

		  SELECT DISTINCT 
			C.Channel_Code, 
			IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),
			DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,
			IIF(Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type,
			Replace(CONVERT(VARCHAR,Rights_Start_Date, 106),' ','-')  AS Rights_Start_Date,
			Replace(CONVERT(VARCHAR,Rights_End_Date, 106),' ','-')  AS Rights_End_Date, 
			C.Channel_Name,
			RU.Right_Rule_Name,
			CCR.Defined_Runs,CCR.Schedule_Runs                
		   ,IIF(Defined_Runs IS NULL,'',Defined_Runs-Schedule_Runs) AS Balanced_Runs 
		   INTO #TEMPContent_channel_Run 
		   FROM Content_channel_Run CCR   (NOLOCK)               
			 LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.Right_Rule_Code                
			 LEFT JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.Channel_Code AND CCR.Run_Def_Type = 'C'
		   WHERE Title_Content_Code = @Title_Content_Code      
		   AND CCR.IS_Archive = 'N'    
		   AND CONVERT(date,GETDATE(),103) BETWEEN CONVERT(date,CCR.Rights_Start_Date,103) AND CONVERT(date,CCR.Rights_End_Date,103)
		  --ORDER BY CCR.Channel_Code    
  

		   UPDATE TC  set TC.Channel_Name =	STUFF(
					(Select Distinct ', ' + CAST(C.Channel_Name as NVARCHAR) From Channel C (NOLOCK)
					INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Channel_Code = C.Channel_Code
					 WHERE CCR.Title_Content_Code = @Title_Content_Code AND CCR.Run_Def_Type <> 'C' and CCR.Defined_Runs = TC.Defined_Runs 
						--Where ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
					FOR XML PATH('')), 1, 1, '') FROM #TEMPContent_channel_Run TC WHERE   TC.Channel_Name IS NULL 
			
			SELECT * FROM #TEMPContent_channel_Run
			DROP TABLE #TEMPContent_channel_Run

		END        
		ELSE        
		BEGIN        
		 SELECT distinct CCR.Channel_Code, '' AS Agreement_No,'' AS Deal_Type,''  AS Rights_Start_Date,''  AS Rights_End_Date, C.Channel_Name,'' as Right_Rule_Name,CCR.Defined_Runs,CCR.Schedule_Runs                
		   ,0 AS Balanced_Runs  FROM Content_channel_Run CCR    (NOLOCK)          
		   INNER JOIN Channel C  (NOLOCK) ON C.Channel_Code = CCR.Channel_Code WHERE Title_Content_Code = @Title_Content_Code AND CCR.Is_Archive = 'N'        
		END

			IF OBJECT_ID('tempdb..#Temp_Content_channel_Run') IS NOT NULL DROP TABLE #Temp_Content_channel_Run
			IF OBJECT_ID('tempdb..#TEMPContent_channel_Run') IS NOT NULL DROP TABLE #TEMPContent_channel_Run
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetRunDefinitonForContent]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END