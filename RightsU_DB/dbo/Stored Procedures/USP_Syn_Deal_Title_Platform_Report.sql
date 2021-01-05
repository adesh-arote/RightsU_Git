﻿
CREATE PROCEDURE [dbo].[USP_Syn_Deal_Title_Platform_Report]  
(      
	@Business_Unit_Code VARCHAR(MAX),  
	@Title_Codes VARCHAR(MAX)='',   
	@Platform_Codes VARCHAR(MAX)='',  
	@Show_Expired CHAR(1)='Y'  
)  
AS 
-- =============================================  
-- Author:  Abhaysingh N Rajpurohit  
-- Create DATE: 16-April-2015  
-- Description: Show Platform wise report  
-- ============================================= 
BEGIN   
--PRINT 'Show Platform wise report'           	
	--DECLARE
	--	@Business_Unit_Code INT =1,  
	--	@Title_Codes VARCHAR(MAX)='27870',   
	--	@Platform_Codes VARCHAR(MAX)='',
	--	@Show_Expired CHAR(1)='N'  

	CREATE TABLE #Temp_Platforms   
	(    
	Agreement_No VARCHAR(MAX)    ,
	Deal_Desc NVARCHAR(MAX)    ,
	Title_Name NVARCHAR(MAX)    ,
	Deal_Segment NVARCHAR(MAX),
	Revenue_Vertical NVARCHAR(MAX),
	Right_Type VARCHAR(MAX)    ,
	Acq_Deal_Rights_Code INT    ,
	Term VARCHAR(MAX)    ,
	Actual_Right_Start_Date DATETIME    ,
	Actual_Right_End_Date DATETIME    ,
	Title_Language NVARCHAR(MAX)    ,
	Platform_Hiearachy NVARCHAR(MAX)    ,
	Platform_Code INT    ,
	Available NVARCHAR(MAX),
	Restriction_Remarks NVARCHAR(MAX),
	Is_Exclusive VARCHAR(10)
	)    

	DECLARE @IsDealSegment AS VARCHAR(100), @IsRevenueVertical AS VARCHAR(100)
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 
	SELECT @IsRevenueVertical = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Revenue_Vertical' 
	   
	DECLARE @Deal_Type_Code_Music INT = 0   
	  
	SELECT TOP 1 
	@Deal_Type_Code_Music = CAST(Parameter_Value AS INT) 
	FROM System_Parameter_New 
	WHERE Parameter_Name = 'Deal_Type_Music'     
	
	--PRINT 'Spliting value of @Platform_Codes...'   
	 
	SELECT DISTINCT number AS Platform_Code INTO #Selected_Platforms FROM fn_Split_withdelemiter(@Platform_Codes, ',') Where IsNull(number, '') <> '';  
	  
	IF((SELECT COUNT(*) FROM #Selected_Platforms) = 0)  
	BEGIN 
		INSERT INTO #Selected_Platforms(Platform_Code)  
		SELECT Platform_Code FROM Platform WHERE Is_Last_Level = 'Y'   
	END 
	--PRINT 'Splited and inserted in #Selected_Platforms table'    
	--PRINT 'Spliting value of @Title_Codes...'   
		
	SELECT DISTINCT number AS Title_Code INTO #Selected_Titles FROM fn_Split_withdelemiter(@Title_Codes, ',');   
	--PRINT 'Splited and inserted in #Selected_Titles table'   PRINT 'Fetching data...'   
		--Select * From #Selected_Platforms  			  
	INSERT INTO #Temp_Platforms 
	(    
	    Agreement_No			
		,Deal_Desc				
		,Title_Name				
		,Right_Type				
		,Acq_Deal_Rights_Code	
		,Term					
		,Actual_Right_Start_Date	
		,Actual_Right_End_Date	
		,Title_Language			
		,Platform_Hiearachy		
		,Platform_Code			
		,Available				
		,Restriction_Remarks		
		,Is_Exclusive					
	)   
	SELECT
		DISTINCT SD.Agreement_No, SD.Deal_Description,      
		DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(SD.Deal_Type_Code), t.Title_Name, SDRT.Episode_From, SDRT.Episode_To) AS Title_Name 
		, SDR.Right_Type, SDR.Syn_Deal_Rights_Code     
		,Case SDR.Right_Type           
		When 'Y' Then [dbo].[UFN_Get_Rights_Term](SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Term)            
		When 'M' Then [dbo].[UFN_Get_Rights_Milestone](SDR.Milestone_Type_Code, SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type)           
		When 'U' Then 'Perpetuity'          
		End as Term
		, CAST(SDR.Actual_Right_Start_Date as date)     
		, CAST(SDR.Actual_Right_End_Date as date)     
		, CASE WHEN SDR.Is_Title_Language_Right = 'Y' THEN ISNULL(L.Language_Name, 'No') ELSE 'No' END AS Language_Name     
		, Platform_Hiearachy     
		, p.Platform_Code     
		, 'YES' Available
		,ISNULL(sdr.Restriction_Remarks, '') AS [Restriction Remarks] 
		,CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END AS Is_Exclusive
		From Syn_Deal SD   
		--INNER JOIN Syn_Deal_Movie SDM On SD.Syn_Deal_Code = SDM.Syn_Deal_Code AND SD.Business_Unit_Code = @Business_Unit_Code   
		INNER JOIN Syn_Deal_Movie SDM On SD.Syn_Deal_Code = SDM.Syn_Deal_Code AND SD.Business_Unit_Code IN (SELECT CAST(number as INT) from [dbo].[fn_Split_withdelemiter](@Business_Unit_code,','))
		AND (Title_Code IN (SELECT Title_Code FROM #Selected_Titles) Or @Title_Codes = '')   
		INNER JOIN Syn_Deal_Rights sdr On SD.Syn_Deal_Code = SDR.Syn_Deal_Code    
		INNER JOIN Syn_Deal_Rights_Platform SDRP On SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code AND    
		(@Show_Expired = 'Y' OR ISNULL(SDR.Actual_Right_End_Date, GETDATE()) >= GETDATE())    
		INNER JOIN Syn_Deal_Rights_Title SDRT On SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code 
		AND SDM.Title_Code = SDRT.Title_Code   INNER JOIN Title t On SDRT.Title_Code = t.Title_Code  
		INNER JOIN Platform p On p.Platform_Code = SDRP.Platform_Code   
		INNER JOIN #Selected_Platforms pTEMP ON pTEMP.Platform_Code = P.Platform_Code   
		LEFT JOIN Language L ON L.Language_Code = T.Title_Language_Code      
		WHERE 
		SD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  
		sdr.Is_Pushback='N'

		IF(@IsDealSegment = 'Y')
		BEGIN
			UPDATE TP
			SET Deal_Segment = DS.Deal_Segment_Name
			FROM #Temp_Platforms TP
			INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = TP.Acq_Deal_Rights_Code
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = adr.Syn_Deal_Code
			INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code
		END

		IF(@IsRevenueVertical = 'Y')
		BEGIN
			UPDATE TP
			SET Revenue_Vertical = DS.Revenue_Vertical_Name
			FROM #Temp_Platforms TP
			INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = TP.Acq_Deal_Rights_Code
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = adr.Syn_Deal_Code
			INNER JOIN Revenue_Vertical DS ON DS.Revenue_Vertical_Code = AD.Revenue_Vertical_Code
		END
	
		--PRINT 'Fetched data'     
		--PRINT 'Altering #Temp_Platforms table...'  
		ALTER TABLE #Temp_Platforms   
		ADD Region_Names NVARCHAR(Max),     
		Subtitling_Names NVARCHAR(Max),    
		Dubbing_Names NVARCHAR(Max)
		     
		--PRINT 'Altered #Temp_Platforms table'     
		--PRINT 'updating value of newly added column in #Temp_Platforms table...'   
		Update #Temp_Platforms Set    Region_Names = DBO.UFN_Get_Rights_Country(Acq_Deal_Rights_Code, 'S',''),   
		Subtitling_Names = DBO.UFN_Get_Rights_Subtitling(Acq_Deal_Rights_Code, 'S'),   
		Dubbing_Names = DBO.UFN_Get_Rights_Dubbing(Acq_Deal_Rights_Code, 'S')     
		UPDATE #Temp_Platforms SET Region_Names = DBO.UFN_Get_Rights_Territory(Acq_Deal_Rights_Code, 'S') 
		WHERE LTRIM(RTRIM(Region_Names)) = ''   
		UPDATE #Temp_Platforms SET Subtitling_Names = 'No' WHERE LTRIM(RTRIM(Subtitling_Names)) = ''   
		UPDATE #Temp_Platforms SET Dubbing_Names = 'No' WHERE LTRIM(RTRIM(Dubbing_Names)) = ''   
	--  PRINT 'Updated'     

	 
	SELECT * FROM #Temp_Platforms     
	--Drop Table #Temp_Platforms   
	--Drop Table #Selected_Platforms   
	--Drop Table #Selected_Titles  

	IF OBJECT_ID('tempdb..#Selected_Platforms') IS NOT NULL DROP TABLE #Selected_Platforms
	IF OBJECT_ID('tempdb..#Selected_Titles') IS NOT NULL DROP TABLE #Selected_Titles
	IF OBJECT_ID('tempdb..#Temp_Platforms') IS NOT NULL DROP TABLE #Temp_Platforms
	IF OBJECT_ID('tempdb..#BusinessUnitCodes') IS NOT NULL DROP TABLE #BusinessUnitCodes
END 
/*
--EXEC USP_Syn_Deal_Title_Platform_Report 1, '', '1,2', 'Y'  
*/