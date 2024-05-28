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
	print 'test1'
		SELECT CCR.RU_Channel_Code AS Channel_Code, AD.Agreement_No AS Agreement_No,
		--IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,
		IIF(AD.Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type, Replace(CONVERT(VARCHAR, CCR.Start_Date, 106),' ','-')  AS Rights_Start_Date,
		Replace(CONVERT(VARCHAR,CCR.End_Date, 106),' ','-')  AS Rights_End_Date, C.Channel_Name, RU.Right_Rule_Name, CCR.Total_Runs AS Defined_Runs, CCR.Utilised_Run AS Schedule_Runs,              
		IIF(CCR.Total_Runs IS NULL,'', CCR.Total_Runs-CCR.Utilised_Run) AS Balanced_Runs 
		FROM BMS_Deal_Content_Rights CCR  (NOLOCK)
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
		INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key
		INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.RU_Channel_Code 
		LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.RU_Right_Rule_Code  
		WHERE TCT.Title_Content_Code = @Title_Content_Code AND CCR.Is_Active = 'Y'        
		AND CONVERT(date,CCR.End_Date,103) > CONVERT(date,GETDATE(),103) 
		AND (@Channel_Code = 0 OR CCR.RU_Channel_Code = @Channel_Code) 
		AND  (ISNULL (CONVERT(date,CCR.Start_Date,103),'') >= CONVERT(date,@Start_Date,103) OR @Start_Date = '')           
		AND (ISNULL(CONVERT(date,CCR.End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')          
		AND ((@Deal_Type = 'A' and ADR.Acq_Deal_Code IS NOT NULL) OR (@Deal_Type = 'P' and ADR.Acq_Deal_Code IS NOT NULL))    --OR (@Deal_Type = 'P' and CCR.Provisional_Deal_Code IS NOT NULL))        
		ORDER BY CCR.Start_Date ASC,C.Channel_Name Asc        
	END            
	ELSE IF(@Is_Active = 'Y' AND @Deal_Type = '')        
	BEGIN
	print 'test2'
		SELECT DISTINCT  C.Channel_Code AS Channel_Code, AD.Agreement_No AS Agreement_No, 
		--IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,
		IIF(AD.Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type, Replace(CONVERT(VARCHAR,CCR.Start_Date, 106),' ','-') AS Rights_Start_Date,
		Replace(CONVERT(VARCHAR,CCR.End_Date, 106),' ','-')  AS Rights_End_Date, C.Channel_Name,
		RU.Right_Rule_Name, CCR.Total_Runs AS Defined_Runs, CCR.Utilised_Run AS Schedule_Runs, IIF(CCR.Total_Runs IS NULL,'',CCR.Total_Runs-CCR.Utilised_Run) AS Balanced_Runs 
		INTO #Temp_Content_channel_Run    
		FROM BMS_Deal_Content_Rights CCR (NOLOCK)
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
		INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key 
		LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.RU_Right_Rule_Code                
		LEFT JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.RU_Channel_Code AND ADR.Run_Definition_Type = 'C'
		WHERE TCT.Title_Content_Code = @Title_Content_Code AND CCR.Is_Active = 'Y'        
		AND CONVERT(date,CCR.End_Date,103) > CONVERT(date,GETDATE(),103) AND (@Channel_Code = 0 OR CCR.RU_Channel_Code = @Channel_Code) 
		AND (ISNULL (CONVERT(date,CCR.Start_Date,103),'') >= CONVERT(date,@Start_Date,103) OR @Start_Date = '')              
		AND (ISNULL(CONVERT(date,CCR.Start_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')         
		--ORDER BY CCR.Start_Date ASC,C.Channel_Name Asc 

		UPDATE	 TC  set TC.Channel_Name =	STUFF(
			(Select Distinct ', ' + CAST(C.Channel_Name as NVARCHAR) From Channel C (NOLOCK)
			INNER JOIN BMS_Deal_Content_Rights CCR (NOLOCK) ON CCR.RU_Channel_Code = C.Channel_Code
			INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
			INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key 
			WHERE TCT.Title_Content_Code = @Title_Content_Code AND ADR.Run_Definition_Type <> 'C' and CCR.Total_Runs = TC.Defined_Runs 
			--Where ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			FOR XML PATH('')), 1, 1, '') FROM #Temp_Content_channel_Run TC WHERE   TC.Channel_Name IS NULL  

		SELECT * FROM #Temp_Content_channel_Run
		--DROP TABLE #Temp_Content_channel_Run
	END        
	ELSE IF(@Is_active = 'N' AND @Deal_Type != '')        
	BEGIN
	print 'test3'
		SELECT  CCR.RU_Channel_Code AS Channel_Code, AD.Agreement_No AS Agreement_No, 
		--IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,
		IIF(AD.Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type, Replace(CONVERT(VARCHAR,CCR.Start_Date, 106),' ','-') AS Rights_Start_Date,
		Replace(CONVERT(VARCHAR,CCR.End_Date, 106),' ','-')  AS Rights_End_Date, C.Channel_Name, RU.Right_Rule_Name, CCR.Total_Runs AS Defined_Runs, CCR.Utilised_Run Schedule_Runs,              
		IIF(CCR.Total_Runs IS NULL,'', CCR.Total_Runs-CCR.Utilised_Run) AS Balanced_Runs 
		FROM BMS_Deal_Content_Rights CCR  (NOLOCK)
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
		INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key 
		INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.RU_Channel_Code 
		LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.RU_Right_Rule_Code                
		WHERE TCT.Title_Content_Code = @Title_Content_Code  AND CCR.Is_Active = 'N'        
		AND CCR.End_Date < GETDATE() AND (@Channel_Code = 0 OR CCR.RU_Channel_Code = @Channel_Code) 
		AND (ISNULL (CONVERT(date,CCR.Start_Date,103),'') >= CONVERT(date,@Start_Date,103) OR @Start_Date = '')                  
		AND (ISNULL(CONVERT(date,CCR.End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')         
		AND ((@Deal_Type = 'A' and ADR.Acq_Deal_Code IS NOT NULL) OR (@Deal_Type = 'P' and ADR.Acq_Deal_Code IS NOT NULL))  --OR (@Deal_Type = 'P' and CCR.Provisional_Deal_Code IS NOT NULL))          
		ORDER BY CCR.Start_Date ASC,C.Channel_Name Asc        
	END        
	ELSE IF(@Is_active = 'N' AND @Deal_Type = '')        
	BEGIN
	print 'test4'
		SELECT  CCR.RU_Channel_Code AS Channel_Code, AD.Agreement_No AS Agreement_No,
		--IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,
		IIF(AD.Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type, Replace(CONVERT(VARCHAR,CCR.Start_Date, 106),' ','-') AS Rights_Start_Date,
		Replace(CONVERT(VARCHAR,CCR.End_Date, 106),' ','-') AS Rights_End_Date, C.Channel_Name,RU.Right_Rule_Name, CCR.Total_Runs AS Defined_Runs, CCR.Utilised_Run AS Schedule_Runs,               
		IIF(CCR.Total_Runs IS NULL,'', CCR.Total_Runs-CCR.Utilised_Run) AS Balanced_Runs 
		FROM BMS_Deal_Content_Rights CCR (NOLOCK)
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
		INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key
		INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.RU_Channel_Code 
		LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.RU_Right_Rule_Code                
		WHERE TCT.Title_Content_Code = @Title_Content_Code AND CCR.Is_Active = 'N'        
		AND CONVERT(date,CCR.End_Date,103) < CONVERT(date,GETDATE(),103) 
		AND (@Channel_Code = 0 OR CCR.RU_Channel_Code = @Channel_Code)
		AND (ISNULL (CONVERT(date,CCR.Start_Date,103),'') >= CONVERT(date,@Start_Date,103) OR @Start_Date = '')   
		AND (ISNULL(CONVERT(date,CCR.End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')         
		ORDER BY CCR.Start_Date ASC,C.Channel_Name Asc        
	END        
	ELSE IF(@Is_active = 'C')        
	BEGIN
	print 'test5'
		SELECT DISTINCT 
		C.Channel_Code AS Channel_Code, AD.Agreement_No AS Agreement_No,
		--IIF(Acq_Deal_Code IS NULL,DBO.UFN_GetAGreement_No(Provisional_Deal_Code,'P'),DBO.UFN_GetAGreement_No(Acq_Deal_Code,'A')) AS Agreement_No,
		IIF(AD.Acq_Deal_Code IS NULL,'Provisional','Acquisition') AS Deal_Type, Replace(CONVERT(VARCHAR,CCR.Start_Date, 106),' ','-') AS Rights_Start_Date,
		Replace(CONVERT(VARCHAR,CCR.End_Date, 106),' ','-') AS Rights_End_Date, C.Channel_Name, RU.Right_Rule_Name, CCR.Total_Runs Defined_Runs, CCR.Utilised_Run AS Schedule_Runs,                
		IIF(CCR.Total_Runs IS NULL,'', CCR.Total_Runs-CCR.Utilised_Run) AS Balanced_Runs 
		INTO #TEMPContent_channel_Run 
		FROM BMS_Deal_Content_Rights CCR (NOLOCK)
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
		INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key
		LEFT JOIN Right_Rule RU (NOLOCK) ON RU.Right_Rule_Code = CCR.RU_Right_Rule_Code                
		LEFT JOIN Channel C (NOLOCK) ON C.Channel_Code = CCR.RU_Channel_Code AND ADR.Run_Definition_Type = 'C'
		WHERE TCT.Title_Content_Code = @Title_Content_Code AND CCR.Is_Active = 'N'    
		AND CONVERT(date,GETDATE(),103) BETWEEN CONVERT(date,CCR.Start_Date,103) AND CONVERT(date,CCR.End_Date,103)
		  --ORDER BY CCR.Channel_Code    

		UPDATE TC  set TC.Channel_Name =	STUFF(
			(Select Distinct ', ' + CAST(C.Channel_Name as NVARCHAR) From Channel C (NOLOCK)
			INNER JOIN BMS_Deal_Content_Rights CCR (NOLOCK) ON CCR.RU_Channel_Code = C.Channel_Code
			INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
			INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key
			WHERE TCT.Title_Content_Code = @Title_Content_Code AND ADR.Run_Definition_Type <> 'C' and CCR.Total_Runs = TC.Defined_Runs 
			--Where ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			FOR XML PATH('')), 1, 1, '') FROM #TEMPContent_channel_Run TC WHERE TC.Channel_Name IS NULL 

			SELECT * FROM #TEMPContent_channel_Run
			--DROP TABLE #TEMPContent_channel_Run
		END        
		ELSE        
		BEGIN 
		print 'test6'
			SELECT distinct CCR.RU_Channel_Code AS Channel_Code, '' AS Agreement_No,'' AS Deal_Type,''  AS Rights_Start_Date,''  AS Rights_End_Date, C.Channel_Name,'' as Right_Rule_Name,
			CCR.Total_Runs AS Defined_Runs,CCR.Utilised_Run AS Schedule_Runs, 0 AS Balanced_Runs  
			FROM BMS_Deal_Content_Rights CCR (NOLOCK)          
			INNER JOIN Channel C  (NOLOCK) ON C.Channel_Code = CCR.RU_Channel_Code
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
			INNER JOIN Title_Content TCT (NOLOCK) ON TCT.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key 
			WHERE TCT.Title_Content_Code = @Title_Content_Code AND CCR.Is_Active = 'N'        
		END

			IF OBJECT_ID('tempdb..#Temp_Content_channel_Run') IS NOT NULL DROP TABLE #Temp_Content_channel_Run
			IF OBJECT_ID('tempdb..#TEMPContent_channel_Run') IS NOT NULL DROP TABLE #TEMPContent_channel_Run
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetRunDefinitonForContent]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END