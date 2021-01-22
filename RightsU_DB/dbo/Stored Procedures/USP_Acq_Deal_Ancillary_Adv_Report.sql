CREATE PROCEDURE [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]  
(  
	@Agreement_No VARCHAR(MAX),  
	@Title_Codes VARCHAR(MAX),  
	@Platform_Codes VARCHAR(MAX),  
	@Ancillary_Type_Code VARCHAR(MAX),  
	@Business_Unit_Code INT,  
	@IncludeExpired VARCHAR(MAX)  
)  
AS  
 --=============================================  
 --Author:  Akshay Rane  
 --Create DATE: 16-April-2018  
 --Description: Show Platform wise Ancillary Advance report  
 --=============================================  
BEGIN  
  
 --DECLARE  
 --@Agreement_No VARCHAR(MAX),  
 --@Title_Codes VARCHAR(MAX),  
 --@Platform_Codes VARCHAR(MAX),  
 --@Ancillary_Type_Code VARCHAR(MAX),  
 --@Business_Unit_Code INT,  
 --@IncludeExpired VARCHAR(MAX)  
  
 --SELECT  
 --@Agreement_No = '',  
 --@Title_Codes = '', --'545',  
 --@Platform_Codes = '',--'0,1,0,3,4,0,6,7,0,0,328,329,330,331,338,339,0,341,342,343,344,345,346,347,348,349,350,351,0,332,333,334,335,352,353,0,355,356,357,358,359,360,361,362,363,364,365,0,0,366,367,0,369,370,371,372,373,374,375,376,377,378,379,0,380,381,0,383,384,385,386,387,388,389,390,391,392,393,0,0,16,17,0,20,21,0,22,23,251,24,29,181,0,252,253,254,255,0,32,33,34,0,0,0,60,258,61,62,259,63,64,65,66,67,69,0,71,72,73,0,262,263,75,76,0,145,146,265,78,79,147,152,154,0,0,38,256,39,40,257,41,42,43,44,45,47,0,49,50,51,0,260,261,53,54,0,149,150,264,56,57,151,155,157,0,0,268,269,270,271,272,273,274,275,276,277,278,0,280,281,282,0,284,285,286,287,0,291,292,293,288,289,294,295,296,0,0,299,300,301,302,303,304,305,306,307,308,309,0,311,312,313,0,315,316,317,318,0,322,323,324,319,320,325,326,327,0,0,111,112,113,182,183,184,0,114,115,116,185,186,187,0,0,173,174,175,200,201,202,0,0,120,121,122,188,189,190,0,227,228,229,230,231,232,0,123,124,125,191,192,193,0,0,165,163,167,197,195,199,0,162,166,164,194,198,196,0,213,215,214,216,218,217,0,220,222,221,223,225,224,226,0,127,128,0,336,337,130,0,248,249,250,0,132,133,134,135,0,138,139,140,141,0,234,235,236,143,0,238,239,240,241,170,0,242,243,244,180,0,207,208,209,210,0,246,247,394',  
 --@Ancillary_Type_Code = '1,2,3,4,5,6' ,  
 --@Business_Unit_Code = 5,  
 --@IncludeExpired = 'Y'  

 --CREATE TABLE TestParameterPA (
 --Agreement_No VARCHAR(MAX),  
 --Title_Codes VARCHAR(MAX),  
 --Platform_Codes VARCHAR(MAX),  
 --Ancillary_Type_Code VARCHAR(MAX),  
 --Business_Unit_Code INT,  
 --IncludeExpired VARCHAR(MAX)  
 --)
-- DROP TABLE TestParameterPA
 --Select * from TestParameterPA
 --INSERT INTO TestParameterPA(Agreement_No,Title_Codes,Platform_Codes,Ancillary_Type_Code,Business_Unit_Code,IncludeExpired)
 --SELECT @Agreement_No,@Title_Codes,@Platform_Codes,@Ancillary_Type_Code,@Business_Unit_Code,@IncludeExpired
  
  
 IF(OBJECT_ID('tempdb..#GetDealTypeCondition') IS NOT NULL) DROP TABLE #GetDealTypeCondition  
 IF(OBJECT_ID('tempdb..#AncillaryTypeCode') IS NOT NULL) DROP TABLE #AncillaryTypeCode  
 IF(OBJECT_ID('tempdb..#PlatformCode') IS NOT NULL) DROP TABLE #PlatformCode  
 IF(OBJECT_ID('tempdb..#Tmp_AcqDeal') IS NOT NULL) DROP TABLE #Tmp_AcqDeal  
 IF(OBJECT_ID('tempdb..#Tmp_Report') IS NOT NULL) DROP TABLE #Tmp_Report

   
 DECLARE @Acq_Deal_Code int  = 0  
 DECLARE @Ancillary_Deal TABLE( Acq_Deal_Ancillary_Code INT, Title_Code INT)  
  
 create table #GetDealTypeCondition(  
  DealType VARCHAR(MAX),  
  Deal_Type_Code INT  
 )  
  
 CREATE TABLE #AncillaryTypeCode  
 (  
  Ancillary_Type_Code INT  
 )  
  
 CREATE TABLE #PlatformCode  
 (  
  Platform_Code INT  
 )  
  
 IF(@Title_Codes = '0')  
 BEGIN  
  SET @Title_Codes = ''  
 END  
  
 IF(@Platform_Codes = '0')  
 BEGIN  
  SET @Platform_Codes = ''  
 END  
  
 IF(@Ancillary_Type_Code = '0')  
 BEGIN  
  SET @Ancillary_Type_Code = ''  
 END  
  
 INSERT INTO #AncillaryTypeCode  
 SELECT number FROM fn_Split_withdelemiter(@Ancillary_Type_Code, ',')  
  
 INSERT INTO #PlatformCode  
 SELECT number FROM fn_Split_withdelemiter(@Platform_Codes, ',')  
  
 IF (@Agreement_No <> '' AND @Title_Codes = '') -- Agreement No = A-2018-00129 /  Title Codes = ''  
 BEGIN  
  PRINT 'STEP 1 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  SELECT @Acq_Deal_Code = Acq_Deal_Code FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No = @Agreement_No AND Business_Unit_Code = @Business_Unit_Code  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)  
  SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary WHERE Acq_deal_Code = @Acq_Deal_Code   
 END  
 ELSE IF (@Title_Codes <> '' AND @Agreement_No = '') --  Agreement No = '' /  Title Codes = '12,13,14,5'  
 BEGIN  
  PRINT 'STEP 2 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code, Title_Code)  
  SELECT ADAT.Acq_Deal_Ancillary_Code, ADAT.Title_Code FROM Acq_Deal_Ancillary_title ADAT   
  INNER JOIN Acq_Deal_Ancillary ADA ON ADA.Acq_Deal_Ancillary_Code = ADAT.Acq_Deal_Ancillary_Code  
  INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADA.Acq_Deal_Code AND Business_Unit_Code = @Business_Unit_Code  
  WHERE ADAT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))  
 END  
 ELSE IF (@Title_Codes = '' AND @AGREEMENT_NO = '') -- Agreement No = '' / Title Codes = ''  
 BEGIN  
  PRINT 'STEP 3 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  DECLARE @AcqDeal TABLE ( Acq_Deal_Code INT)  
  
  INSERT INTO @AcqDeal (Acq_Deal_Code)  
  SELECT  Acq_Deal_Code  FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Business_Unit_Code = @Business_Unit_Code  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code,Title_Code)  
  SELECT AAD.Acq_Deal_Ancillary_Code,ADT.Title_Code FROM Acq_Deal_Ancillary AAD
  INNER JOIN Acq_Deal_Ancillary_title ADT ON AAD.Acq_Deal_Ancillary_Code = ADT.Acq_Deal_Ancillary_Code  
  WHERE AAD.Acq_Deal_Code IN (SELECT Acq_Deal_Code FROM @AcqDeal)  
 END  
 ELSE IF (@Title_Codes <> '' AND @Agreement_No <> '') -- Agreement No = A-2018-00129 / Title Codes = '12,13,14,5'  
 BEGIN  
  PRINT 'STEP 4 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  SELECT @Acq_Deal_Code = Acq_Deal_Code FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No = @Agreement_No AND Business_Unit_Code = @Business_Unit_Code  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code, Title_Code)  
  SELECT ADT.Acq_Deal_Ancillary_Code, ADT.Title_Code FROM Acq_Deal_Ancillary ADA  
  INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code  
  WHERE ADA.Acq_deal_Code = @Acq_Deal_Code AND   
  ADT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))  
 END  
  
 INSERT INTO #GetDealTypeCondition(Deal_Type_Code)  
 SELECT DISTINCT ad.Deal_Type_Code  
 FROM Acq_Deal_Ancillary ada  
 INNER JOIN Acq_Deal ad ON ada.Acq_Deal_Code = ad.Acq_Deal_Code  
 WHERE Business_Unit_Code = @Business_Unit_Code  
  
 UPDATE #GetDealTypeCondition SET DealType = DBO.UFN_GetDealTypeCondition(Deal_Type_Code)  
  
 CREATE TABLE #Tmp_AcqDeal  
 (  
  Agreement_No NVARCHAR(MAX),  
  Acq_Deal_Code INT,  
  Title_Code INT,  
  Deal_Type_Code INT  
 ) 
  CREATE TABLE #Tmp_Report  
 (  
  Agreement_No NVARCHAR(MAX),  
  Acq_Deal_Code INT,  
  Title_Code INT,  
  Deal_Type_Code INT,
  Title_Name VARCHAR(MAX),
  Title_Type VARCHAR(MAX),
  Ancillary_Type_Name VARCHAR(MAX),
  Duration VARCHAR(MAX),
  Day VARCHAR(MAX),
  Remarks VARCHAR(MAX),
  Platform_Hiearachy VARCHAR(MAX),
  Platform_Code INT,
  Available VARCHAR(MAX)
 ) 
 
 INSERT INTO #Tmp_AcqDeal(Agreement_No, Acq_Deal_Code, Title_Code, Deal_Type_Code)  
 SELECT AD.Agreement_No, AD.Acq_Deal_Code, adrt.Title_Code, AD.Deal_Type_Code  
 FROM Acq_Deal AD   
  INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code   
  INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code  
  INNER JOIN #GetDealTypeCondition GDTC ON AD.Deal_Type_Code = GDTC.Deal_Type_Code  
 WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')  
  AND AD.Business_Unit_Code = @Business_Unit_Code  
  AND (ADR.Actual_Right_Start_Date IS NOT NULL AND ISNULL(ADR.Actual_Right_End_Date, '31DEC9999') >= GETDATE() OR @IncludeExpired = 'Y')  
  AND ( @Title_Codes = '' OR (ADRT.Title_Code  IN (SELECT Title_Code FROM @Ancillary_Deal)))  
   
 
  INSERT INTO #Tmp_Report
 SELECT DISTINCT  
  AD.*,  
  DBO.UFN_GetTitleNameInFormat(GDTC.DealType,   
  T.Title_Name, ADT.Episode_From, ADT.Episode_To) AS Title_Name,  
  CASE GDTC.DealType WHEN 'DEAL_MOVIE' THEN 'Movie' WHEN 'DEAL_PROGRAM' THEN 'Program' END  AS Title_Type,  
  AT.Ancillary_Type_Name,  
  ISNULL(CAST(ADA.Duration AS VARCHAR(MAX)),'') AS Duration,  
  ISNULL(CAST(ADA.Day AS VARCHAR(MAX)),'')  AS Day,  
  ADA.Remarks,  
  P.Platform_Hiearachy,  
  P.Platform_Code,  
  'YES' Available  
 FROM Acq_Deal_Ancillary ADA   
  INNER JOIN #Tmp_AcqDeal AD ON ADA.Acq_Deal_Code = AD.Acq_Deal_Code  
  INNER JOIN Acq_Deal_Ancillary_Platform ADP ON ADA.Acq_Deal_Ancillary_Code = ADP.Acq_Deal_Ancillary_Code  
  INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Title_Code = AD.Title_Code  
  INNER JOIN @Ancillary_Deal ADN ON ADN.Acq_Deal_Ancillary_Code =  ADA.Acq_Deal_Ancillary_Code  AND ADT.Title_Code = ADN.Title_Code
  INNER JOIN Platform P On P.Platform_Code = ADP.Platform_Code  
  INNER JOIN Title T On ADT.Title_Code = T.Title_Code  
  INNER JOIN Ancillary_Type AT ON AT.Ancillary_Type_Code = ADA.Ancillary_Type_Code  
  INNER JOIN #GetDealTypeCondition GDTC ON AD.Deal_Type_Code = GDTC.Deal_Type_Code  
  WHERE   
  (@Ancillary_Type_Code  = '' OR (ADA.Ancillary_Type_code IN (SELECT DISTINCT Ancillary_Type_code FROM #AncillaryTypeCode) AND @Ancillary_Type_Code <> ''))  
  AND (@Platform_Codes  = '' OR (P.Platform_Code IN (SELECT DISTINCT Platform_Code FROM #PlatformCode )AND @Platform_Codes <> ''))  

  --SELECT * FROM #Tmp_Report

		DECLARE @TableColumns VARCHAR(MAX) = '',@CurDisplayName NVARCHAR(100) = ''
		SELECT @CurDisplayName = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DISTINCT Platform_Hiearachy FROM #Tmp_Report 
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + '[' + @CurDisplayName +']'

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary

	--	PRINT  ('SELECT [Agreement_No],[Title_Name],[Title_Type],[Ancillary_Type_Name],[Duration],[Day],[Remarks] ,'+ @TableColumns +' FROM   
	--(SELECT [Agreement_No],[Title_Name],[Title_Type],[Ancillary_Type_Name],[Duration],[Day],[Remarks],[Platform_Hiearachy]-- CASE WHEN [Platform_Hiearachy] = 0 THEN ''Y'' ELSE ''N'' END Platform_Hiearachy
	--FROM #Tmp_Report)Tab1  
	--PIVOT  
	--(  
	--Count([Platform_Hiearachy])
	--FOR Platform_Hiearachy IN (' +@TableColumns+')) AS Tab2 ')
	
	--SELECT * FROM #Tmp_Report
	DECLARE @COUNT INT

	SELECT @COUNT = COUNT(*) FROM #Tmp_Report

	IF(@COUNT > 0)
	BEGIN
		EXEC ('SELECT [Agreement_No],[Title_Name] AS [Title],[Title_Type],[Ancillary_Type_Name] AS [Ancillary_Type],[Duration] AS [Duration(Sec)],[Day] AS [Period(Day)],[Remarks] ,'+ @TableColumns +' FROM   
		(SELECT [Agreement_No],[Title_Name],[Title_Type],[Ancillary_Type_Name],[Duration], [Day],[Remarks],[Platform_Hiearachy]
		FROM #Tmp_Report)Tab1  
		PIVOT  
		(  
		MAX([Platform_Hiearachy])
		FOR Platform_Hiearachy IN (' +@TableColumns+')) AS Tab2') 
	END
	ELSE
	BEGIN
		SELECT * FROM #Tmp_Report
	END 
	--Select * from #temp
    --SELECT * FROM #Tmp_Report
  
  IF(OBJECT_ID('tempdb..#GetDealTypeCondition') IS NOT NULL) DROP TABLE #GetDealTypeCondition  
  IF(OBJECT_ID('tempdb..#AncillaryTypeCode') IS NOT NULL) DROP TABLE #AncillaryTypeCode  
  IF(OBJECT_ID('tempdb..#PlatformCode') IS NOT NULL) DROP TABLE #PlatformCode  
  IF(OBJECT_ID('tempdb..#Tmp_AcqDeal') IS NOT NULL) DROP TABLE #Tmp_AcqDeal  
  IF(OBJECT_ID('tempdb..#Tmp_Report') IS NOT NULL) DROP TABLE #Tmp_Report

END