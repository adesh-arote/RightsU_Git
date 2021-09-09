GO
PRINT N'Rename refactoring operation with key b0e704aa-cd07-4ee2-a6e1-345beda02fb5 is skipped, element [dbo].[Acq_Adv_Ancillary_Report].[Id] (SqlSimpleColumn) will not be renamed to Acq_Adv_Ancillary_Report_Code';


GO
PRINT N'Dropping Permission...';


GO
REVOKE UPDATE
    ON OBJECT::[dbo].[System_Module_Message] TO [dbserver2012] CASCADE
    AS [dbo];


GO
PRINT N'Creating [dbo].[MusicScheduleProcess]...';


GO
CREATE TYPE [dbo].[MusicScheduleProcess] AS TABLE (
    [Title_Code]                      INT    NULL,
    [Episode_No]                      INT    NULL,
    [BV_Schedule_Transaction_Code]    BIGINT NULL,
    [Music_Schedule_Transaction_Code] BIGINT NULL);


GO
PRINT N'Creating [dbo].[Acq_Adv_Ancillary_Report]...';


GO
CREATE TABLE [dbo].[Acq_Adv_Ancillary_Report] (
    [Acq_Adv_Ancillary_Report_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Agreement_No]                  VARCHAR (MAX)   NULL,
    [Title_Codes]                   VARCHAR (MAX)   NULL,
    [Platform_Codes]                VARCHAR (MAX)   NULL,
    [Business_Unit_Code]            INT             NULL,
    [IncludeExpired]                VARCHAR (MAX)   NULL,
    [Date_Format]                   NVARCHAR (2000) NULL,
    [DateTime_Format]               NVARCHAR (2000) NULL,
    [Created_By]                    NVARCHAR (2000) NULL,
    [SysLanguageCode]               INT             NULL,
    [Report_Name]                   NVARCHAR (2000) NULL,
    [Accessibility]                 CHAR (10)       NULL,
    [File_Name]                     NVARCHAR (2000) NULL,
    [Process_Start]                 DATETIME        NULL,
    [Process_End]                   DATETIME        NULL,
    [Report_Status]                 CHAR (1)        NULL,
    [Error_Message]                 NVARCHAR (MAX)  NULL,
    [Generated_By]                  INT             NULL,
    [Generated_On]                  DATETIME        NULL,
    [Ancillary_Type_Codes]          VARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([Acq_Adv_Ancillary_Report_Code] ASC)
);


GO
PRINT N'Altering [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]...';


GO



 ALTER PROCEDURE [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]  
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
 --@Title_Codes = '2138, 7511', --'545',  
 --@Platform_Codes = '',--'0,1,0,3,4,0,6,7,0,0,328,329,330,331,338,339,0,341,342,343,344,345,346,347,348,349,350,351,0,332,333,334,335,352,353,0,355,356,357,358,359,360,361,362,363,364,365,0,0,366,367,0,369,370,371,372,373,374,375,376,377,378,379,0,380,381,0,383,384,385,386,387,388,389,390,391,392,393,0,0,16,17,0,20,21,0,22,23,251,24,29,181,0,252,253,254,255,0,32,33,34,0,0,0,60,258,61,62,259,63,64,65,66,67,69,0,71,72,73,0,262,263,75,76,0,145,146,265,78,79,147,152,154,0,0,38,256,39,40,257,41,42,43,44,45,47,0,49,50,51,0,260,261,53,54,0,149,150,264,56,57,151,155,157,0,0,268,269,270,271,272,273,274,275,276,277,278,0,280,281,282,0,284,285,286,287,0,291,292,293,288,289,294,295,296,0,0,299,300,301,302,303,304,305,306,307,308,309,0,311,312,313,0,315,316,317,318,0,322,323,324,319,320,325,326,327,0,0,111,112,113,182,183,184,0,114,115,116,185,186,187,0,0,173,174,175,200,201,202,0,0,120,121,122,188,189,190,0,227,228,229,230,231,232,0,123,124,125,191,192,193,0,0,165,163,167,197,195,199,0,162,166,164,194,198,196,0,213,215,214,216,218,217,0,220,222,221,223,225,224,226,0,127,128,0,336,337,130,0,248,249,250,0,132,133,134,135,0,138,139,140,141,0,234,235,236,143,0,238,239,240,241,170,0,242,243,244,180,0,207,208,209,210,0,246,247,394',  
 --@Ancillary_Type_Code = '' ,  
 --@Business_Unit_Code = 1,  
 --@IncludeExpired = 'N'  
  
  
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
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)  
  SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary WHERE Acq_deal_Code IN (SELECT Acq_Deal_Code FROM @AcqDeal)  
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
  INNER JOIN @Ancillary_Deal ADN ON ADN.Acq_Deal_Ancillary_Code =  ADA.Acq_Deal_Ancillary_Code  
  INNER JOIN #Tmp_AcqDeal AD ON ADA.Acq_Deal_Code = AD.Acq_Deal_Code  
  INNER JOIN Acq_Deal_Ancillary_Platform ADP ON ADA.Acq_Deal_Ancillary_Code = ADP.Acq_Deal_Ancillary_Code  
  INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Title_Code = AD.Title_Code  
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
GO
PRINT N'Altering [dbo].[USP_Content_Music_PI]...';


GO
ALTER PROCEDURE [dbo].[USP_Content_Music_PI]
(
	@Content_Music_Link_UDT Content_Music_Link_UDT READONLY,
	@UserCode INT
)
AS
------ =============================================
---- Author:  Sayali Surve
---- Create date: 07 October 2017
---- Description: This usp call from Title_Content_ImportExportController  and check Error and Insert into Content_Music_Link_UDT
---- =============================================
BEGIN
	SET NOCOUNT ON;

	DECLARE	@DM_Master_Import_Code INT ,@Sql NVARCHAR(1000),@DB_Name VARCHAR(1000); 
	Select Top 1 @DM_Master_Import_Code = DM_Master_Import_Code From @Content_Music_Link_UDT    

	INSERT INTO DM_Content_Music([DM_Master_Import_Code],[From],[To],[Duration],[From_Frame],[To_Frame],[Duration_Frame],[Is_Ignore],[Record_Status],[Music_Track],
			[Title_Content_Code],[Version_Name],[Excel_Line_No],[Error_Tags])
		SELECT  [DM_Master_Import_Code], [From], [To], [Duration],[From_Frame],  [To_Frame], [Duration_Frame], 'N','N', [Music_Track], [Title_Content_Code],
		  [Version_Name], [Excel_Line_No], '' As Error_Tags
	    FROM @Content_Music_Link_UDT  

	/* Update Version Code */
	UPDATE T SET T.Version_Code = V.Version_Code, T.Version_Name = V.Version_Name FROM DM_Content_Music T
	INNER JOIN [Version] V ON UPPER(RTRIM(LTRIM(T.Version_Name)))
	COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(RTRIM(LTRIM(V.Version_Name))) COLLATE SQL_Latin1_General_CP1_CI_AS 
		AND LTRIM(RTRIM(T.Version_Name)) != '' 

	/* Update Content Name */
	UPDATE TMP SET TMP.Content_Name = CASE WHEN ISNULL(TC.Episode_Title, '') = '' THEN T.Title_Name ELSE TC.Episode_Title END,
	TMP.Episode_No = TC.Episode_No FROM DM_Content_Music TMP
	INNER JOIN Title_Content TC ON CAST(TC.Title_Content_Code AS VARCHAR) COLLATE SQL_Latin1_General_CP1_CI_AS = 
	CAST(RTRIM(LTRIM(TMP.Title_Content_Code)) AS VARCHAR) COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN Title T ON T.Title_Code = TC.Title_Code
	--END

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Sr. No cannot be blank~' 
	FROM DM_Content_Music T
	WHERE T.Excel_Line_No = '' AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Music Track cannot be blank~' 
	FROM DM_Content_Music T
	WHERE T.Music_Track = '' AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL(T.[Error_Message], '') + '~' + T.[Music_Track] + ' - Music Track Name is Deactivated in system.'
	FROM Music_Title MT
	INNER JOIN DM_Content_Music T ON T.Music_Track = MT.Music_Title_Name
	WHERE ISNULL (T.Record_Status,'') <> 'C' AND MT.Is_Active = 'N' AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Either TC IN, TC OUT or Duration cannot be zero~' 
	FROM DM_Content_Music T
	WHERE ((T.[From] = '' AND T.[To] = '' AND T.[Duration] = '') OR (T.[From] != '' AND T.[To] = '') OR (T.[From] = '' AND T.[To] != '')) AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Invalid Title Content Code~' 
	FROM DM_Content_Music T
	WHERE T.Title_Content_Code Not In(select Title_Content_Code From Title_Content) AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE DM_Content_Music SET [Record_Status] = 'E' , [Error_Message] = ISNULL([Error_Message], '') + 'Invalid Version Name'
	WHERE ISNULL([Version_Code],'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code

	--IF NOT EXISTS(SELECT TOP 1 Record_Status FROM DM_Content_Music WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
	--BEGIN  
	--print '1'
	--EXEC USP_Validate_Content_Music_Import @DM_Master_Import_Code     
	----IF NOT EXISTS(SELECT TOP 1 Record_Status FROM DM_Content_Music WHERE RTRIM(LTRIM(ISNULL(Record_Status,''))) = 'OR' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
	----print '2'
	----	BEGIN  
	--		EXEC USP_Content_Music_PIV @DM_Master_Import_Code 
	    
	--		IF((Select [Status] From DM_Master_Import Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P')
	--		BEGIN  
	--			EXEC USP_Content_Music_PIII @DM_Master_Import_Code
	--		END
	--	--END
	--END
	--ELSE
	--BEGIN
		IF EXISTS(SELECT Record_Status FROM DM_Content_Music WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
		BEGIN
			SELECT [Excel_Line_No], [Content_Name], [Episode_No], [Music_Track], [From], [To], [From_Frame], [To_Frame], [Duration], [Duration_Frame], Version_Name, [Error_Message]
			FROM DM_Content_Music Where [Record_Status] = 'E'
			UPDATE DM_Master_Import Set [Status] = 'E' where DM_Master_Import_Code  = @DM_Master_Import_Code

			DECLARE @File_Name VARCHAR(MAX)
			SELECT @File_Name = File_Name FROM DM_Master_Import WHere DM_Master_Import_Code = @DM_Master_Import_Code AND [Status] = 'E'
			INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
			SELECT GETDATE(),NULL,NULL,'USP_Content_Music_PI','Error in file: '+ @File_Name,'NA','NA','DB'

			SELECT @sql = 'Error in file: '+ @File_Name
			SELECT @DB_Name = DB_Name()
			EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_Content_Music_PI','AN','VN',@sql,'DB','IP','FR','TI'
		END
	--END
END
GO
PRINT N'Altering [dbo].[USP_DM_Title_PII]...';


GO
ALTER PROCEDURE [dbo].[USP_DM_Title_PII]
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code Int
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @DM_Master_Import_Code INT = 115,@Users_Code Int = 143
	--DECLARE @DM_Import_UDT DM_Import_UDT
	--INSERT INTO @DM_Import_UDT(
	--	[Key],[value], [DM_Master_Type]
	--)
	--VALUES
	--	(5526,13,'PC')
	IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL
		DROP TABLE #Temp_DM

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title') IS NOT NULL
		DROP TABLE #Temp_DM_Title

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title_Ignore') IS NOT NULL
		DROP TABLE #Temp_DM_Title_Ignore

	IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL
		DROP TABLE #Temp_Talent_Role


	CREATE TABLE #Temp_DM
	(
		Master_Name NVarchar(2000),
		DM_Master_Log_Code BIGINT,
		DM_Master_Code NVARCHAR (100),
		Master_Type NVARCHAR (100),
		Is_New CHAR(1)
	)

	CREATE TABLE #Temp_DM_Title
	(
		DM_Title_Code INT,
		IsMusicDirectorValid CHAR(1) DEFAULT('Y'),
		IsStarCastValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelValid CHAR(1) DEFAULT('Y'),
		IsTitleTypeValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageValid CHAR(1) DEFAULT('Y'),
		IsOriginalTitleLanguageValid CHAR(1) DEFAULT('Y'),
		IsProgramCategoryValid CHAR(1) DEFAULT('Y'),
		IsValid AS CASE 
						WHEN 'YYYYYYY' = (IsMusicDirectorValid + IsStarCastValid + IsMusicLabelValid + IsTitleTypeValid + IsTitleLanguageValid + 
											IsOriginalTitleLanguageValid + IsProgramCategoryValid ) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)

	CREATE TABLE #Temp_DM_Title_Ignore
	(
		DM_Title_Code INT,
		IsMusicDirectorValid CHAR(1) DEFAULT('N'),
		IsStarCastValid CHAR(1) DEFAULT('N'),
		IsMusicLabelValid CHAR(1) DEFAULT('N'),
		IsTitleTypeValid CHAR(1) DEFAULT('N'),
		IsTitleLanguageValid CHAR(1) DEFAULT('N'),
		IsOriginalTitleLanguageValid CHAR(1) DEFAULT('N'),
		IsProgramCategoryValid CHAR(1) DEFAULT('N'),
		IsIgnore AS CASE 
						WHEN 'NNNNNNN' = (IsMusicDirectorValid + IsStarCastValid + IsMusicLabelValid + IsTitleTypeValid + IsTitleLanguageValid + 
											IsOriginalTitleLanguageValid + IsProgramCategoryValid ) 
						THEN 'N' 
						ELSE 'Y' 
				END
	)

	INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Is_New)
	SELECT [Name], [Key], [value], [DM_Master_Type] , CASE WHEN  ISNULL(RTRIM(LTRIM([value])),'') = 'NEW' THEN 'Y' ELSE 'N' END AS [Is_New]
	FROM @DM_Import_UDT udt
	Inner Join DM_Master_Log dm on dm.DM_Master_Log_Code = udt.[Key]

	DECLARE @DirectorRoleCode INT = 1, @StarCastRoleCode INT = 2

	IF EXISTS(SELECT TOP 1 DM_Master_Log_Code FROM #Temp_DM WHERE Is_New = 'Y')
	BEGIN
		Declare @CurDate DateTime = GetDate();

		INSERT INTO Talent(Talent_Name, Gender, Is_Active, Inserted_By, Inserted_On)
		SELECT DISTINCT TD.Master_Name, 'N', 'Y', @Users_Code, @CurDate FROM  #Temp_DM TD  
		WHERE TD.Master_Type = 'TA' AND Is_New = 'Y'
		
		UPDATE TD SET TD.DM_Master_Code = T.Talent_Code 
		FROM #Temp_DM TD
		INNER JOIN Talent T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Talent_Name collate SQL_Latin1_General_CP1_CI_AS
		AND TD.Master_Type = 'TA'
		
		INSERT INTO Music_Label(Music_Label_Name, Is_Active, Inserted_By,  Inserted_On)  
		SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
		WHERE TD.Master_Type = 'LB' AND Is_New = 'Y' AND 
		TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label)
        
		UPDATE TD SET TD.DM_Master_Code = ML.Music_Label_Code   
		FROM #Temp_DM TD  
		INNER JOIN Music_Label ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS  
		AND TD.Master_Type = 'LB'
    
	END

	UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'

	UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'

	UPDATE D SET D.Mapped_By = 'V', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code > '0' AND D.Mapped_By = 'S'

	BEGIN

		CREATE TABLE #Temp_Talent_Role
		(
			Talent_Code INT,
			Role_Code INT,
			[Name] NVarchar(2000)
		)

		INSERT INTO #Temp_Talent_Role(Talent_Code, Role_Code, [Name])
		Select Distinct DM_Master_Code, Role_Code, [Master_Name] From (
			SELECT DM_Master_Code, @DirectorRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles Like '%Director%' AND DM.Master_Type = 'TA'
			UNION
			SELECT DM_Master_Code, @StarCastRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles like '%Cast%' AND DM.Master_Type = 'TA'
		) AS a Where a.DM_Master_Code Not In (
			Select tr.Talent_Code From Talent_Role tr Where  tr.Role_Code = a.Role_Code AND tr.Talent_Code IS NOT NULL
		) AND a.DM_Master_Code != 'Y'

		DECLARE @count INt
		select @count = cOUNT(*) from #Temp_Talent_Role

		IF(@count > 0)	
		BEGIN
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Talent_Role(Talent_Code, Role_Code)
			SELECT Talent_Code, Role_Code FROM #Temp_Talent_Role	

			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)
			SELECT Distinct [Name] As Original_Title, [Name] As Title_Name, [Name] As Synopsis, 
					(SELECT Deal_Type_Code FROM [Role] a WHERE a.Role_Code = tl.Role_Code) As Deal_Type_Code, GetDate() As Inserted_On, 
				   'Y' As Is_Active, Talent_Code Reference_Key, 'T' AS Reference_Flag 
			FROM #Temp_Talent_Role tl
		END
		Drop Table #Temp_Talent_Role
		
	END

	BEGIN
		IF OBJECT_ID('TEMPDB..#TempMasterLog') IS NOT NULL
			DROP TABLE #TempMasterLog

		CREATE TABLE #TempMasterLog
		(
			Name NVARCHAR(500), 
			Master_Type VARCHAR(10), 
			Master_Code VARCHAR(1000), 
			Roles VARCHAR(100),
			Is_Ignore CHAR(1)
		)

		INSERT INTO #TempMasterLog(Name, Master_Type, Master_Code, Roles, Is_Ignore)
		SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore FROM DM_Master_Log
		WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND ISNULL(Master_Code, 0) = 0  
	END
	DECLARE @Master_Name NVARCHAR(1000) = ''



	/*
	DECLARE @ResolveCount  Int , @TotalCount INT
	SELECT @ResolveCount = COUNT(*) FROM DM_Title WHERE Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
	SELECT @TotalCount = COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code
	IF(@ResolveCount = @TotalCount)
	BEGIN
		UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
	END
	*/
	
	

	IF NOT EXISTS (SELECT TOP 1 *  FROM DM_Master_Log WHERE  DM_Master_Import_Code = @DM_Master_Import_Code AND Action_By IS NULL  AND Action_On IS NULL)
	BEGIN
		UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
	END


	IF OBJECT_ID('tempdb..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
	IF OBJECT_ID('tempdb..#Temp_DM_Title') IS NOT NULL DROP TABLE #Temp_DM_Title
	IF OBJECT_ID('tempdb..#Temp_DM_Title_Ignore') IS NOT NULL DROP TABLE #Temp_DM_Title_Ignore
	IF OBJECT_ID('tempdb..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role
	IF OBJECT_ID('tempdb..#TempMasterLog') IS NOT NULL DROP TABLE #TempMasterLog
END
GO
PRINT N'Altering [dbo].[USP_List_DM_Master_Import]...';


GO
ALTER  PROCEDURE [dbo].[USP_List_DM_Master_Import]  
(  
	@strSearch  NVARCHAR(2000),  
	@PageNo INT=1,  
	@OrderByCndition NVARCHAR(100),  
	@IsPaging VARCHAR(2),  
	@PageSize INT,
	@RecordCount INT OUT,  
	@User_Code INT
)   
AS  
BEGIN  
	SET FMTONLY OFF  
  
	DECLARE @SqlPageNo NVARCHAR(MAX),@Sql NVARCHAR(MAX)  
	SET NOCOUNT ON;   
	IF(@PageNo=0)  
		Set @PageNo = 1   
	CREATE TABLE #Temp  
	(  
		DM_Master_Import_Code INT,  
		RowId VARCHAR(200)
	);  
	SET @SqlPageNo = '  
		WITH Y AS   
		(  
			SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
			FROM DM_Master_Import DM  
			Where 1= 1  '+@StrSearch+'  
			GROUP BY DM.DM_Master_Import_Code  
		)  
		INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'  
  
		PRINT @SqlPageNo  
		EXEC(@SqlPageNo)  
		SELECT @RecordCount = ISNULL(COUNT(DM_Master_Import_Code),0) FROM #Temp  
  
	IF(@IsPaging = 'Y')  
	BEGIN   
		DELETE FROM #Temp WHERE RowId < (((@PageNo - 1) * @PageSize) + 1) OR RowId > @PageNo * @PageSize   
	END   
	ALTER TABLE #Temp ADD FileType CHAR(1)
	ALTER TABLE #Temp ADD TotalCount INT
	ALTER TABLE #Temp ADD SuccessCount INT
	ALTER TABLE #Temp ADD ConflictCount INT
	ALTER TABLE #Temp ADD IgnoreCount INT
	ALTER TABLE #Temp ADD ErrorCount INT
	ALTER TABLE #Temp ADD WaitingCount INT

	UPDATE T SET T.FileType = (SELECT File_Type FROM DM_Master_Import WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
	FROM #Temp T

	DECLARE @FileType CHAR(1)
	SELECT @FileType = FileType FROM #Temp
	IF(@FileType = 'M')
	BEGIN
		UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
		FROM #Temp T

		UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
		FROM #Temp T

		UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND Is_Ignore ='N')
		FROM #Temp T

		UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
		FROM #Temp T

		UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
		FROM #Temp T

		UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
		FROM #Temp T
	END
	ELSE IF(@FileType= 'T')
	BEGIN 
	
		UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 and DM_Master_Import_Code = T.DM_Master_Import_Code)
		FROM #Temp T

		UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
		FROM #Temp T

		UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND Is_Ignore ='N')
		FROM #Temp T

		UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
		FROM #Temp T

		UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E' AND Is_Ignore <> 'Y')
		FROM #Temp T

		UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
		FROM #Temp T
	END
	ELSE
	BEGIN
		UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
		FROM #Temp T

		UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
		FROM #Temp T

		UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND (Record_Status = 'OR' 
			OR Record_Status = 'MR' OR Record_Status = 'SM' OR Record_Status = 'MO' OR Record_Status = 'SO') ANd Is_Ignore = 'N')
		FROM #Temp T

		UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
		FROM #Temp T

		UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
		FROM #Temp T

		UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
		FROM #Temp T
	END

	SET @Sql = 'SELECT DM.DM_Master_Import_Code As DM_Master_Import_Code, DM.File_Name As File_Name, U.Login_Name AS UserName, 
	REPLACE(CONVERT(char(11), DM.Uploaded_Date, 106),'' '',''-'') + right(convert(varchar(32),DM.Uploaded_Date,100),8) AS Uploaded_Date, 
	DM.Status AS Status, T.TotalCount As TotalCount, T.SuccessCount As SuccessCount, T.ConflictCount AS ConflictCount, T.IgnoreCount AS IgnoreCount,
	T.ErrorCount As ErrorCount, T.WaitingCount As WaitingCount
	FROM DM_Master_Import DM  
	INNER JOIN USers U  
	ON DM.Upoaded_By = U.Users_Code  
	INNER JOIN #Temp T ON DM.DM_Master_Import_Code = T.DM_Master_Import_Code ORDER BY ' +@OrderByCndition  
  
	PRINT @sql  
	EXEC (@Sql)  
   

	--DROP TABLE #Temp  
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
END
GO
PRINT N'Altering [dbo].[USP_Title_Import_Utility_PII]...';


GO
ALTER PROCEDURE USP_Title_Import_Utility_PII
(
	@DM_Master_Import_Code INT
)
AS 
BEGIN
	SET NOCOUNT ON
	--DECLARE @DM_Master_Import_Code INT = 2
	DECLARE @ISError CHAR(1) = 'N', @Error_Message NVARCHAR(MAX) = '', @ExcelCnt INT = 0

	IF(OBJECT_ID('tempdb..#TempTitle') IS NOT NULL) DROP TABLE #TempTitle
	IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
	IF(OBJECT_ID('tempdb..#TempExcelSrNo') IS NOT NULL) DROP TABLE #TempExcelSrNo
	IF(OBJECT_ID('tempdb..#TempHeaderWithMultiple') IS NOT NULL) DROP TABLE #TempHeaderWithMultiple
	IF(OBJECT_ID('tempdb..#TempTalent') IS NOT NULL) DROP TABLE #TempTalent
	IF(OBJECT_ID('tempdb..#TempExtentedMetaData') IS NOT NULL) DROP TABLE #TempExtentedMetaData
	IF(OBJECT_ID('tempdb..#TempResolveConflict') IS NOT NULL) DROP TABLE #TempResolveConflict
	IF(OBJECT_ID('tempdb..#TempDuplicateRows') IS NOT NULL) DROP TABLE #TempDuplicateRows
	
	CREATE TABLE #TempTitle(
		DM_Master_Import_Code INT,
		ExcelSrNo NVARCHAR(MAX),
		Col1 NVARCHAR(MAX),
		Col2 NVARCHAR(MAX),
		Col3 NVARCHAR(MAX),
		Col4 NVARCHAR(MAX),
		Col5 NVARCHAR(MAX),
		Col6 NVARCHAR(MAX),
		Col7 NVARCHAR(MAX),
		Col8 NVARCHAR(MAX),
		Col9 NVARCHAR(MAX),
		Col10 NVARCHAR(MAX),
		Col11 NVARCHAR(MAX),
		Col12 NVARCHAR(MAX),
		Col13 NVARCHAR(MAX),
		Col14 NVARCHAR(MAX),
		Col15 NVARCHAR(MAX),
		Col16 NVARCHAR(MAX),
		Col17 NVARCHAR(MAX),
		Col18 NVARCHAR(MAX),
		Col19 NVARCHAR(MAX),
		Col20 NVARCHAR(MAX),
		Col21 NVARCHAR(MAX),
		Col22 NVARCHAR(MAX),
		Col23 NVARCHAR(MAX),
		Col24 NVARCHAR(MAX),
		Col25 NVARCHAR(MAX),
		Col26 NVARCHAR(MAX),
		Col27 NVARCHAR(MAX),
		Col28 NVARCHAR(MAX),
		Col29 NVARCHAR(MAX),
		Col30 NVARCHAR(MAX),
		Col31 NVARCHAR(MAX),
		Col32 NVARCHAR(MAX),
		Col33 NVARCHAR(MAX),
		Col34 NVARCHAR(MAX),
		Col35 NVARCHAR(MAX),
		Col36 NVARCHAR(MAX),
		Col37 NVARCHAR(MAX),
		Col38 NVARCHAR(MAX),
		Col39 NVARCHAR(MAX),
		Col40 NVARCHAR(MAX),
		Col41 NVARCHAR(MAX),
		Col42 NVARCHAR(MAX),
		Col43 NVARCHAR(MAX),
		Col44 NVARCHAR(MAX),
		Col45 NVARCHAR(MAX),
		Col46 NVARCHAR(MAX),
		Col47 NVARCHAR(MAX),
		Col48 NVARCHAR(MAX),
		Col49 NVARCHAR(MAX),
		Col50 NVARCHAR(MAX),
		Col51 NVARCHAR(MAX),
		Col52 NVARCHAR(MAX),
		Col53 NVARCHAR(MAX),
		Col54 NVARCHAR(MAX),
		Col55 NVARCHAR(MAX),
		Col56 NVARCHAR(MAX),
		Col57 NVARCHAR(MAX),
		Col58 NVARCHAR(MAX),
		Col59 NVARCHAR(MAX),
		Col60 NVARCHAR(MAX),
		Col61 NVARCHAR(MAX),
		Col62 NVARCHAR(MAX),
		Col63 NVARCHAR(MAX),
		Col64 NVARCHAR(MAX),
		Col65 NVARCHAR(MAX),
		Col66 NVARCHAR(MAX),
		Col67 NVARCHAR(MAX),
		Col68 NVARCHAR(MAX),
		Col69 NVARCHAR(MAX),
		Col70 NVARCHAR(MAX),
		Col71 NVARCHAR(MAX),
		Col72 NVARCHAR(MAX),
		Col73 NVARCHAR(MAX),
		Col74 NVARCHAR(MAX),
		Col75 NVARCHAR(MAX),
		Col76 NVARCHAR(MAX),
		Col77 NVARCHAR(MAX),
		Col78 NVARCHAR(MAX),
		Col79 NVARCHAR(MAX),
		Col80 NVARCHAR(MAX),
		Col81 NVARCHAR(MAX),
		Col82 NVARCHAR(MAX),
		Col83 NVARCHAR(MAX),
		Col84 NVARCHAR(MAX),
		Col85 NVARCHAR(MAX),
		Col86 NVARCHAR(MAX),
		Col87 NVARCHAR(MAX),
		Col88 NVARCHAR(MAX),
		Col89 NVARCHAR(MAX),
		Col90 NVARCHAR(MAX),
		Col91 NVARCHAR(MAX),
		Col92 NVARCHAR(MAX),
		Col93 NVARCHAR(MAX),
		Col94 NVARCHAR(MAX),
		Col95 NVARCHAR(MAX),
		Col96 NVARCHAR(MAX),
		Col97 NVARCHAR(MAX),
		Col98 NVARCHAR(MAX),
		Col99 NVARCHAR(MAX),
		Col100 NVARCHAR(MAX)
	)

	CREATE TABLE #TempTitleUnPivot(
		ExcelSrNo NVARCHAR(MAX),
		ColumnHeader NVARCHAR(MAX),
		TitleData NVARCHAR(MAX),
		RefKey NVARCHAR(MAX),
		IsError CHAR(1),
		ErrorMessage NVARCHAR(MAX)
	)

	CREATE TABLE #TempExcelSrNo(
		ExcelSrNo NVARCHAR(MAX),
	)

	CREATE TABLE #TempHeaderWithMultiple(
		ExcelSrNo NVARCHAR(MAX),
		TitleCode INT,
		HeaderName NVARCHAR(MAX),
		PropName NVARCHAR(MAX),
		PropCode INT
	)

	CREATE TABLE #TempResolveConflict(
		[Name] NVARCHAR(MAX),
		Master_Type NVARCHAR(MAX),
		Master_Code INT,
		Roles NVARCHAR(MAX),
		Mapped_By CHAR(1)
	)

	CREATE TABLE #TempTalent(
		ExcelSrNo NVARCHAR(MAX),
		HeaderName NVARCHAR(MAX),
		TalentName NVARCHAR(MAX),
		TalentCode INT,
		RoleCode INT
	)

	CREATE TABLE #TempExtentedMetaData(
		ExcelSrNo NVARCHAR(MAX),
		Columns_Code INT,
		HeaderName NVARCHAR(MAX),
		EMDName NVARCHAR(MAX),
		EMDCode INT
	)

	BEGIN TRY

	UPDATE DM_Title_Import_Utility_Data SET Error_Message = NULL, Is_Ignore = 'N', Record_Status = NULL 
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Col1 NOT LIKE '%Sr%' 

	PRINT 'Inserting Data into #TempTitle'
	INSERT INTO #TempTitle (DM_Master_Import_Code, ExcelSrNo, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99)  
	SELECT DM_Master_Import_Code, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100  
	FROM DM_Title_Import_Utility_Data  
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Fetching duplicate EXCEL Sr No'
	UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Duplicate EXCEL Sr. No. Found', Is_Ignore = 'Y' --A.Record_Status = 'E', 
	FROM DM_Title_Import_Utility_Data A
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
	AND A.Col1 COLLATE Latin1_General_CI_AI in (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DELETE FROM #TempTitle WHERE 
	ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DECLARE @Mandatory_message NVARCHAR(MAX)
	SELECT @Mandatory_message = STUFF(( SELECT ', ' + Display_Name +' is Mandatory Field' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		

	SELECT B.Col1 as ExcelSrNo
	INTO #TempDuplicateRows
	FROM DM_Title_Import_Utility_Data B
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND B.Col1 NOT LIKE '%Sr%'
	AND B.Col1 IN (
		SELECT A.ExcelSrNo FROM
		(
			SELECT Col1 AS ExcelSrNo , CONCAT(Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50, Col51, Col52, Col53, Col54, Col55, Col56, Col57, Col58, Col59, Col60, Col61, Col62, Col63, Col64, Col65, Col66, Col67, Col68, Col69, Col70, Col71, Col72, Col73, Col74, Col75, Col76, Col77, Col78, Col79, Col80, Col81, Col82, Col83, Col84, Col85, Col86, Col87, Col88, Col89, Col90, Col91, Col92, Col93, Col94, Col95, Col96, Col97, Col98, Col99, Col100) AS Concatenate
			FROM DM_Title_Import_Utility_Data  
			WHERE DM_Master_Import_Code =  @DM_Master_Import_Code
			AND Col1 NOT LIKE '%Sr%'
		) AS A WHERE A.Concatenate = ''
	)

	UPDATE B SET  B.Error_Message= ISNULL(B.Error_Message,'') + '~'+@Mandatory_message , B.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data B WHERE B.Col1 IN (SELECT ExcelSrNo FROM #TempDuplicateRows )

	PRINT 'Fetching duplicate rows'
	UPDATE A SET  Error_Message= ISNULL(Error_Message,'') + '~Duplicate Rows Found', Is_Ignore = 'Y' --,A.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data A 
	INNER JOIN 
	(
		SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
		FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' 
	) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' AND B.rank > 1 AND A.Col1 NOT IN (SELECT ExcelSrNo FROM #TempDuplicateRows)

	DELETE A FROM #TempTitle A 
	INNER JOIN (
	SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
	FROM #TempTitle
	WHERE ExcelSrNo NOT LIKE '%Sr%' ) AS B ON A.ExcelSrNo = B.ExcelSrNo
	WHERE  A.ExcelSrNo NOT LIKE '%Sr%' AND B.rank > 1	

	
	BEGIN
		PRINT 'Unpivoting Title data for further validation'
		INSERT INTO #TempTitleUnPivot(ExcelSrNo, ColumnHeader, TitleData)
		SELECT ExcelSrNo, LTRIM(RTRIM(ColumnHeader)), LTRIM(RTRIM(TitleData))
		FROM
		(
			SELECT * FROM #TempTitle
		) AS cp
		UNPIVOT 
		(
			TitleData FOR ColumnHeader IN (Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50)
		) AS up

		UPDATE T2 SET T2.ColumnHeader = T1.TitleData
		FROM (
			SELECT * FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		) AS T1
		INNER JOIN #TempTitleUnPivot T2 ON T1.ColumnHeader = T2.ColumnHeader

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		DELETE FROM #TempTitleUnPivot WHERE TitleData = ''

		INSERT INTO #TempExcelSrNo(ExcelSrNo)
		SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot

		SELECT @ExcelCnt = COUNT(DISTINCT ExcelSrNo) FROM #TempExcelSrNo

		UPDATE T1 SET T1.IsError = NULL, ErrorMessage = NULL FROM #TempTitleUnPivot T1
	END

	DECLARE @Display_Name NVARCHAR(MAX), @Reference_Table NVARCHAR(MAX), @Reference_Text_Field NVARCHAR(MAX), @Reference_Value_Field NVARCHAR(MAX)
	, @Reference_Whr_Criteria NVARCHAR(MAX),  @Control_Type NVARCHAR(MAX), @Is_Allowed_For_Resolve_Conflict CHAR(1), @ShortName NVARCHAR(MAX),
	@Target_Column NVARCHAR(MAX)

	BEGIN
		PRINT 'Duplication'

		DECLARE db_cursor_Duplication CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%dup%'

		OPEN db_cursor_Duplication  
		FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') has duplicate data'
			WHERE ExcelSrNo IN(
				SELECT A.ExcelSrNo FROM ( SELECT excelSrNo, RANK() OVER(PARTITION BY TitleData ORDER BY excelSrNo) AS rank FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name ) AS A WHERE A.rank > 1
			)	
			--IF (@Display_Name = 'Title Name')
			--BEGIN
			--	UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Title Name is already existed'
			--	WHERE ExcelSrNo IN(
			--		SELECT EXCELSRNO FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name
			--		AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT DISTINCT ISNULL(Title_Name,'') FROM Title)
			--	)
			--END

			FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name 
		END 
		CLOSE db_cursor_Duplication  
		DEALLOCATE db_cursor_Duplication 
	END

	BEGIN
		PRINT 'Check INT Column'
		DECLARE db_cursor_Int CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND Colum_Type = 'INT'

		OPEN db_cursor_Int  
		FETCH NEXT FROM db_cursor_Int INTO @Display_Name 

		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Not Numeric'
			WHERE  ColumnHeader = @Display_Name AND ISNUMERIC(TitleData) <> 1

			IF ('YEAR OF RELEASE' = UPPER(@Display_Name))
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND ISNUMERIC(TitleData) = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1950 AND 9999
			
			
			FETCH NEXT FROM db_cursor_Int INTO @Display_Name 
		END 

		CLOSE db_cursor_Int  
		DEALLOCATE db_cursor_Int 
	END
	
	BEGIN
		PRINT 'Mandatory Validation'

		DECLARE db_cursor_Mandatory CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%'

		OPEN db_cursor_Mandatory  
		FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			 IF((SELECT COUNT(DISTINCT ExcelSrNo) FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name) < 2) --@ExcelCnt
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Mandatory Field'
					WHERE ExcelSrNo NOT IN ( SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name)
				END
			  FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name 
		END 

		CLOSE db_cursor_Mandatory  
		DEALLOCATE db_cursor_Mandatory 
	END

	BEGIN
		PRINT 'Deleting IsError = Y and updating record status amd error message AND deleting existing title'

		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + 'Title Name Already Existed'--, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		WHERE A.DM_Master_Import_Code =  @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%' and A.Col1 COLLATE Latin1_General_CI_AI IN 
		(
			SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name'
			AND TitleData COLLATE Latin1_General_CI_AI IN (SELECT Title_Name FROM Title)
		)

		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + B.ErrorMessage --, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		INNER JOIN (
			SELECT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y' GROUP BY ExcelSrNo, ErrorMessage
		) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%'

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo IN
		(
			SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name'
			AND TitleData COLLATE Latin1_General_CI_AI IN (SELECT Title_Name FROM Title)
		)

		DELETE FROM #TempTitleUnPivot WHERE IsError = 'Y'
	END
	
	BEGIN
		PRINT 'Referene check not available where Is_Multiple = ''N'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'N'

		OPEN db_cursor_Reference  
		FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  

				EXEC ('UPDATE B SET B.RefKey = A.'+@Reference_Value_Field+' 
						FROM #TempTitleUnPivot B
						INNER JOIN '+@Reference_Table+' A ON A.'+@Reference_Text_Field+'  COLLATE Latin1_General_CI_AI = B.TitleData  COLLATE Latin1_General_CI_AI AND B.ColumnHeader = '''+@Display_Name+'''
						WHERE 1=1 '+@Reference_Whr_Criteria+'
				')

				IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
				BEGIN
					
					UPDATE B SET B.RefKey = A.Master_Code
					FROM DM_Master_Log A
					INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
					WHERE 
						A.DM_Master_Import_Code = @DM_Master_Import_Code 
						AND A.Master_Type   = @ShortName   
						AND B.ColumnHeader   = @Display_Name  
						AND B.RefKey IS NULL
						AND A.Master_Code IS NOT NULL
				END
				
				IF(@Is_Allowed_For_Resolve_Conflict = 'N')
					UPDATE A SET A.IsError = 'Y', A.ErrorMessage = ISNULL(A.ErrorMessage, '') + '~' + @Display_Name +' Not Available~'
					FROM #TempTitleUnPivot A WHERE  A.ExcelSrNo IN
					(
						SELECT DISTINCT  ExcelSrNo
						FROM #TempTitleUnPivot T1
						WHERE T1.ColumnHeader = @Display_Name AND T1.RefKey IS NULL AND T1.TitleData <> ''
					)

				FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		END 

		CLOSE db_cursor_Reference  
		DEALLOCATE db_cursor_Reference 
	END

	BEGIN
		PRINT 'Referene check where Is_Multiple = ''Y'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'Y'

		OPEN db_cursor_Reference  
		FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria,  @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  		
	
			INSERT INTO #TempHeaderWithMultiple(ExcelSrNo,HeaderName, PropName)
				SELECT DISTINCT 
						ExcelSrNo, 
						@Display_Name,
						LTRIM(RTRIM(f.Number))
				FROM #TempTitleUnPivot upvot
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> '' 

			UPDATE A SET A.PropCode = B.Master_Code
			FROM #TempHeaderWithMultiple A
			INNER JOIN DM_Master_Log B ON A.PropName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName

			EXEC ('UPDATE A SET A.PropCode = B.'+@Reference_Value_Field+' 
			FROM #TempHeaderWithMultiple A
			INNER JOIN '+@Reference_Table+' B ON A.PropName COLLATE SQL_Latin1_General_CP1_CI_AS = B.'+@Reference_Text_Field+'
			WHERE 1=1 AND A.PropCode IS NULL AND A.HeaderName ='''+@Display_Name+'''  '+@Reference_Whr_Criteria+'
			')

			FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name,  @Reference_Table, @Reference_Text_Field, @Reference_Value_Field,  @Reference_Whr_Criteria , @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_Reference  
		DEALLOCATE db_cursor_Reference 
	END

	BEGIN
		PRINT 'Talent Referene check'

		DECLARE db_cursor_Talent_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName 
		FROM DM_Title_Import_Utility WHERE Reference_Table = 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y'

		OPEN db_cursor_Talent_Reference  
		FETCH NEXT FROM db_cursor_Talent_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  									 
				INSERT INTO #TempTalent(ExcelSrNo,HeaderName, TalentName, RoleCode)
				SELECT DISTINCT 
						ExcelSrNo, 
						upvot.ColumnHeader,
						LTRIM(RTRIM(f.Number)),
						r.Role_Code
				FROM #TempTitleUnPivot upvot
				inner join Role R ON R.Role_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''

				UPDATE A SET A.TalentCode = B.Master_Code FROM #TempTalent A
				INNER JOIN DM_Master_Log B ON A.TalentName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND Roles = @Display_Name

				FETCH NEXT FROM db_cursor_Talent_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_Talent_Reference  
		DEALLOCATE db_cursor_Talent_Reference 

		DELETE FROM #TempTalent WHERE TalentName in ('',' ','.')

		UPDATE tt SET tt.TalentCode = t.Talent_Code FROM Talent t
		INNER JOIN #TempTalent tt ON t.Talent_Name COLLATE Latin1_General_CI_AI = tt.TalentName COLLATE Latin1_General_CI_AI	
		WHERE TT.TalentCode IS NULL

	END

	BEGIN
		PRINT 'Extended metadata except talent Is_Multiple = ''N'''

		DECLARE db_cursor_EMD_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'N'
	
		OPEN db_cursor_EMD_Reference  
		FETCH NEXT FROM db_cursor_EMD_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
											 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
				-- if TXT then directly insert ie banner 
				IF (@Control_Type = 'DDL')
				BEGIN
					UPDATE upvot SET upvot.RefKey = ECV.Columns_Value_Code
					FROM #TempTitleUnPivot upvot
					INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
					INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Code = EC.Columns_Code AND UPVOT.TitleData COLLATE Latin1_General_CI_AI = ECV.Columns_Value COLLATE Latin1_General_CI_AI 
					WHERE upvot.ColumnHeader = @Display_Name -- 'Colour or B&W'
	
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
					BEGIN
						UPDATE B SET B.RefKey = A.Master_Code
						FROM DM_Master_Log A
						INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
						WHERE 
							A.DM_Master_Import_Code = @DM_Master_Import_Code 
							AND A.Master_Type   = @ShortName   
							AND B.ColumnHeader   = @Display_Name  
							AND B.RefKey IS NULL
							AND A.Master_Code IS NOT NULL
					END

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
						WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE RefKey is null AND ColumnHeader = @Display_Name )
					
				END
				FETCH NEXT FROM db_cursor_EMD_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 
	
		CLOSE db_cursor_EMD_Reference  
		DEALLOCATE db_cursor_EMD_Reference 
	END

	BEGIN
		PRINT 'Extended metadata except talent Is_Multiple = ''Y'''

		DECLARE db_cursor_EMDY_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'Y'

		OPEN db_cursor_EMDY_Reference  
		FETCH NEXT FROM db_cursor_EMDY_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
		
				IF (@Control_Type = 'DDL')
				BEGIN
					INSERT INTO #TempExtentedMetaData (ExcelSrNo, Columns_Code, HeaderName, EMDName)
					SELECT DISTINCT ExcelSrNo, EC.Columns_Code, upvot.ColumnHeader, LTRIM(RTRIM(f.Number))
					FROM #TempTitleUnPivot upvot
						INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
						CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
					WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''
					
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
						UPDATE A SET A.EMDCode = B.Master_Code FROM #TempExtentedMetaData A
						INNER JOIN DM_Master_Log B ON A.EMDName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
						WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName

					UPDATE A SET A.EMDCode= ECV.Columns_Value_Code  FROM #TempExtentedMetaData A
					INNER JOIN Extended_Columns_Value ECV 
					ON ECV.Columns_Value COLLATE Latin1_General_CI_AI = A.EMDName COLLATE Latin1_General_CI_AI AND ECV.Columns_Code = A.Columns_Code 
				END
				FETCH NEXT FROM db_cursor_EMDY_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_EMDY_Reference  
		DEALLOCATE db_cursor_EMDY_Reference 
	END
		
	BEGIN
		PRINT 'Resolve Conflict'
		
		DELETE FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and Master_Code IS NULL AND Is_Ignore = 'N'
		--UPDATE DM_Title_Import_Utility_Data SET Record_Status = NULL WHERE Record_Status = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code

		INSERT INTO #TempResolveConflict ([Name], Master_Type, Roles)
		SELECT DISTINCT A.[Name], A.Master_Type, A.Roles FROM (
				SELECT A.TitleData AS Name ,B.ShortName AS Master_Type ,'' AS Roles FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD
				SELECT A.PropName AS Name ,B.ShortName AS Master_Type,'' AS Roles
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD
				SELECT A.TitleData AS Name,B.ShortName AS Master_Type,''AS Roles
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD EXTENDED META DATA
				SELECT A.EMDName AS Name, B.ShortName AS Master_Type ,''AS Roles
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD EXTENDED META DATA
				SELECT A.TalentName AS Name, B.ShortName AS Master_Type, R.Role_Name AS Roles
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			--TITLE PROPERTIES WITH TALENT
		) AS A

		UPDATE A SET  A.Master_Code = B.Master_Code, A.Mapped_By = 'S' 
		FROM #TempResolveConflict A
		INNER JOIN DM_Master_Log B ON B.Name COLLATE Latin1_General_CI_AI = A.Name AND A.Master_Type COLLATE Latin1_General_CI_AI = B.Master_Type
		WHERE B.DM_Master_Log_Code IN ( SELECT  MAX(DM_Master_Log_Code) AS DM_Master_Log_Code FROM DM_Master_Log GROUP BY Name)

		UPDATE #TempResolveConflict SET Mapped_By = 'U' where Master_Code IS NULL 
	
		PRINT 'Delete from Temp table where is_ignore IS Y '
		BEGIN
			DELETE A
			FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
			WHERE A.RefKey IS NULL
				  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				  AND B.Reference_Table <> 'Talent' 
				  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				  AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempHeaderWithMultiple A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.PropName collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
			WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
			WHERE	A.RefKey IS NULL
					AND B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N'
					AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempExtentedMetaData A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.EMDName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
			WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempTalent A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN Role R ON R.Role_Code = A.RoleCode
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.TalentName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
												AND DML.Roles = R.Role_Name COLLATE Latin1_General_CI_AI
			WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A FROM #TempResolveConflict A 
				INNER JOIN DM_Master_Log B ON A.Name COLLATE SQL_Latin1_General_CP1_CI_AS = B.Name AND  B.Is_Ignore = 'Y'
			WHERE B.DM_Master_Import_Code = @DM_Master_Import_Code
		END

		IF EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
		BEGIN
			UPDATE TIU SET TIU.Record_Status = 'R' , TIU.Is_Ignore = 'N'
			FROM DM_Title_Import_Utility_Data AS TIU WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
			AND ISNUMERIC(TIU.Col1) = 1 AND TIU.Col1 COLLATE Latin1_General_CI_AI IN (
			SELECT DISTINCT A.ExcelSrNo FROM (
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION  
				SELECT A.ExcelSrNo
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			) AS A )

			UPDATE DM_Master_Import SET Status = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

			INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
			SELECT @DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles,'N',Mapped_By FROM #TempResolveConflict
		END
	END

	BEGIN
		PRINT 'if error which cannot be resolved '
		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE IsError = 'Y') 
		BEGIN

			UPDATE A SET A.Error_Message = B.ErrorMessage, Record_Status = 'E'
			FROM DM_Title_Import_Utility_Data A
			INNER JOIN 
			(SELECT DISTINCT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y') as B on B.ExcelSrNo = A.Col1 COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' 
			
		END

		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE IsError <> 'Y')
		BEGIN
			IF NOT EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
				BEGIN	
				DECLARE @cols_DisplayName AS NVARCHAR(MAX), @cols_TargetColumn AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)

				-----------Title COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',[' + Display_Name +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',[' + Target_Column +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				EXEC ('
				INSERT INTO Title ( Is_Active, '+@cols_TargetColumn+')
				SELECT ''Y'', '+@cols_DisplayName+' FROM (SELECT ExcelSrNo, ColumnHeader, 
				CASE WHEN RefKey IS NULL THEN TitleData ELSE RefKey END
				TitleData FROM #TempTitleUnPivot WHERE ISError <> ''Y'') AS Tbl PIVOT( MAX(TitleData) FOR ColumnHeader IN ('+@cols_DisplayName+')) AS Pvt ')
				
				UPDATE A SET A.RefKey = B.Title_Code 
				FROM #TempTitleUnPivot A
				INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
				WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

				UPDATE B SET B.TitleCode = A.RefKey FROM  #TempTitleUnPivot A
				INNER JOIN #TempHeaderWithMultiple B ON A.ExcelSrNo = B.ExcelSrNo
				WHERE A.ColumnHeader = 'Title Name'  AND A.ISError <> 'Y'

				-----------Title_Country COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				EXEC ('
				INSERT INTO Title_Country (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE 
				HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Country'')
				')
				-----------Title_Geners COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')	
				EXEC ('
				INSERT INTO Title_Geners (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Geners'')
				')

				-----------Title_Talent COLUMN--------------------
				EXEC ('
				INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_Code)
				SELECT B.RefKey, A.TalentCode, A.RoleCode FROM #TempTalent A
				INNER JOIN #TempTitleUnPivot B ON B.ExcelSrNo = A.ExcelSrNo
				WHERE B.ColumnHeader = ''Title Name'' AND  A.TalentCode IS NOT NULL AND B.ISError <> ''Y''
				')

				-----------EXTENDED COLUMN IS Multiple = N With DDL AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.RefKey, 'N' 
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'DDL' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
					AND A.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = N With TXT AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Column_Value, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.TitleData, 'N'  
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'TXT' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y' 
					AND A.ISError <> 'Y'
	
				-----------EXTENDED COLUMN IS Multiple = Y AND Map_Extended_Column --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					 AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)	
				SELECT MEC.Map_Extended_Columns_Code, A.EMDCode
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = A.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'  
					AND AA.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = Y IN TALENT --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column_Values' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)
				SELECT MEC.Map_Extended_Columns_Code, A.TalentCode
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN extended_columns EC ON EC.Columns_Name = A.HeaderName COLLATE Latin1_General_CI_AI
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = EC.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
				
				UPDATE DM_Title_Import_Utility_Data SET Record_Status = 'C', Error_Message = NULL WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status IS NULL AND  ISNUMERIC(Col1) = 1 
				UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			END
		END
		ELSE
		BEGIN 
			UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
		END
	END
	END TRY
	BEGIN CATCH
		UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE A SET  A.Error_Message = ISNULL(Error_Message,'')  + '~' + ERROR_MESSAGE()
		FROM DM_Title_Import_Utility_Data A WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
	END CATCH
END
------------
--exec USP_Title_Import_Utility_PII 10168
--SELECT * FROM DM_Master_Log order by 1 desc

--select * from DM_Title_Import_Utility_Data order by 1 desc where DM_Master_Import_Code = 10161
GO
PRINT N'Altering [dbo].[USPExportToExcelBulkImport]...';


GO

ALTER PROCEDURE USPExportToExcelBulkImport
	@DM_Master_Import_Code INT = 0,
	@SearchCriteria VARCHAR(MAX) = '',
	@File_Type VARCHAR(1) = '',
	@AdvanceSearch NVARCHAR(MAX) = ''
	
AS
BEGIN
	--DECLARE
	--@DM_Master_Import_Code INT = 3,
	--@SearchCriteria VARCHAR(MAX) = 'abcdefgh',
	--@File_Type VARCHAR(1) = 'T',
	--@AdvanceSearch NVARCHAR(MAX) = ''
	DECLARE 
	@Condition NVARCHAR(MAX) = '',
	@Record_Status VARCHAR(20) = '',
	@Is_Ignore VARCHAR(1) = ''

     SELECT @Record_Status = CASE WHEN @SearchCriteria = 'Success' THEN  'C'
								  WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  'OR,MR,SM,MO,SO,R'
								  WHEN @SearchCriteria = 'Proceed' THEN  'P'
								  WHEN @SearchCriteria = 'No Error' THEN  'N'
								  WHEN @SearchCriteria = 'Error' THEN  'E'
								  ELSE '' END, 
			@Is_Ignore = CASE WHEN @SearchCriteria = 'Ignore' THEN 'Y'
								  ELSE '' END,	
			@SearchCriteria = CASE WHEN @SearchCriteria = 'Success' THEN  ''
								  WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  ''
								  WHEN @SearchCriteria = 'Proceed' THEN  ''
								  WHEN @SearchCriteria = 'No Error' THEN  ''
								  WHEN @SearchCriteria = 'Error' THEN  ''
								  WHEN @SearchCriteria = 'Ignore' THEN ''
								  ELSE @SearchCriteria END
   
     IF(@AdvanceSearch = '')
		set @AdvanceSearch += ''
	  IF(@SearchCriteria != '')
			set @SearchCriteria =  '%'+@SearchCriteria+'%'  
       		    
	--SELECT @Record_Status
	--SELECT @SearchCriteria
	--SELECT @Is_Ignore

	IF(OBJECT_ID('TEMPDB..#tempBulkImportExport_To_Excel') IS NOT NULL)
		DROP TABLE #tempBulkImportExport_To_Excel

	IF(OBJECT_ID('TEMPDB..#ExcelSrNo') IS NOT NULL)
		DROP TABLE #ExcelSrNo

	CREATE TABLE #tempBulkImportExport_To_Excel
	(
		COL01 NVARCHAR(MAX),
		COL02 NVARCHAR(MAX),
		COL03 NVARCHAR(MAX),
		COL04 NVARCHAR(MAX),
		COL05 NVARCHAR(MAX),
		COL06 NVARCHAR(MAX),
		COL07 NVARCHAR(MAX),
		COL08 NVARCHAR(MAX),
		COL09 NVARCHAR(MAX),
		COL10 NVARCHAR(MAX),
		COL11 NVARCHAR(MAX),
		COL12 NVARCHAR(MAX),
		COL13 NVARCHAR(MAX),
		COL14 NVARCHAR(MAX),
		COL15 NVARCHAR(MAX),
		COL16 NVARCHAR(MAX),
		COL17 NVARCHAR(MAX),
		COL18 NVARCHAR(MAX),
		COL19 NVARCHAR(MAX),
		COL20 NVARCHAR(MAX),
		COL21 NVARCHAR(MAX),
		COL22 NVARCHAR(MAX),
		COL23 NVARCHAR(MAX),
		COL24 NVARCHAR(MAX),
		COL25 NVARCHAR(MAX),
		COL26 NVARCHAR(MAX),
		COL27 NVARCHAR(MAX),
		COL28 NVARCHAR(MAX),
		COL29 NVARCHAR(MAX),
		COL30 NVARCHAR(MAX),
		COL31 NVARCHAR(MAX),
		COL32 NVARCHAR(MAX),
		COL33 NVARCHAR(MAX),
		COL34 NVARCHAR(MAX),
		COL35 NVARCHAR(MAX),
		COL36 NVARCHAR(MAX),
		COL37 NVARCHAR(MAX),
		COL38 NVARCHAR(MAX),
		COL39 NVARCHAR(MAX),
		COL40 NVARCHAR(MAX),
		COL41 NVARCHAR(MAX),
		COL42 NVARCHAR(MAX),
		COL43 NVARCHAR(MAX),
		COL44 NVARCHAR(MAX),
		COL45 NVARCHAR(MAX),
		COL46 NVARCHAR(MAX),
		COL47 NVARCHAR(MAX),
		COL48 NVARCHAR(MAX),
		COL49 NVARCHAR(MAX),
		COL50 NVARCHAR(MAX),
		COL51 NVARCHAR(MAX),
		COL52 NVARCHAR(MAX),
		COL53 NVARCHAR(MAX),
		COL54 NVARCHAR(MAX),
		COL55 NVARCHAR(MAX),
		COL56 NVARCHAR(MAX),
		COL57 NVARCHAR(MAX),
		COL58 NVARCHAR(MAX),
		COL59 NVARCHAR(MAX),
		COL60 NVARCHAR(MAX),
		COL61 NVARCHAR(MAX),
		COL62 NVARCHAR(MAX),
		COL63 NVARCHAR(MAX),
		COL64 NVARCHAR(MAX),
		COL65 NVARCHAR(MAX),
		COL66 NVARCHAR(MAX),
		COL67 NVARCHAR(MAX),
		COL68 NVARCHAR(MAX),
		COL69 NVARCHAR(MAX),
		COL70 NVARCHAR(MAX),
		COL71 NVARCHAR(MAX),
		COL72 NVARCHAR(MAX),
		COL73 NVARCHAR(MAX),
		COL74 NVARCHAR(MAX),
		COL75 NVARCHAR(MAX),
		COL76 NVARCHAR(MAX),
		COL77 NVARCHAR(MAX),
		COL78 NVARCHAR(MAX),
		COL79 NVARCHAR(MAX),
		COL80 NVARCHAR(MAX),
		COL81 NVARCHAR(MAX),
		COL82 NVARCHAR(MAX),
		COL83 NVARCHAR(MAX),
		COL84 NVARCHAR(MAX),
		COL85 NVARCHAR(MAX),
		COL86 NVARCHAR(MAX),
		COL87 NVARCHAR(MAX),
		COL88 NVARCHAR(MAX),
		COL89 NVARCHAR(MAX),
		COL90 NVARCHAR(MAX),
		COL91 NVARCHAR(MAX),
		COL92 NVARCHAR(MAX),
		COL93 NVARCHAR(MAX),
		COL94 NVARCHAR(MAX),
		COL95 NVARCHAR(MAX),
		COL96 NVARCHAR(MAX),
		COL97 NVARCHAR(MAX),
		COL98 NVARCHAR(MAX),
		COL99 NVARCHAR(MAX),
		COL100 NVARCHAR(MAX)
	)
	
	--- Title
	IF(@File_Type = 'T')
	BEGIN 
		  CREATE TABLE #ExcelSrNo (ExcelLineNo NVARCHAR(MAX))

		  INSERT INTO #ExcelSrNo (ExcelLineNo)
		  EXEC USP_Get_ExcelSrNo @DM_Master_Import_Code,@SearchCriteria,''
		  

		  DECLARE @Counter INT ,@TotalCounter INT, @ColNames NVARCHAR(MAX) = '', @BulkImp_ColNames NVARCHAR(MAX) = ''
		  SELECT @TotalCounter = COUNT(*) + 1  FROM DM_Title_Import_Utility where Is_Active = 'Y'

		  SET @Counter=1
		  WHILE ( @Counter <= @TotalCounter)
		  BEGIN
				SELECT @ColNames = @ColNames + 'COL'+ CAST(@Counter AS NVARCHAR(MAX))+', '
		  		SET @Counter  = @Counter  + 1
		  END

		  SELECT @ColNames = @ColNames + 'Record_Status, Error_Message'

		  SET @Counter=1
		  WHILE ( @Counter <= @TotalCounter + 2)
		  BEGIN
				IF(@Counter < 10)
					SELECT @BulkImp_ColNames = @BulkImp_ColNames + 'COL0'+ CAST(@Counter AS NVARCHAR(MAX))+', '
				ELSE
					SELECT @BulkImp_ColNames = @BulkImp_ColNames + 'COL'+ CAST(@Counter AS NVARCHAR(MAX))+', '

		  		SET @Counter  = @Counter  + 1
		  END

		  SELECT @BulkImp_ColNames = LEFT(@BulkImp_ColNames, LEN(@BulkImp_ColNames) - 1)

		  EXEC ('
			  INSERT INTO #tempBulkImportExport_To_Excel('+ @BulkImp_ColNames +')				  
			  SELECT '+ @ColNames +'
			  FROM DM_Title_Import_Utility_Data WHERE DM_Master_Import_Code = '+@DM_Master_Import_Code+' 
			  AND (Col1 COLLATE Latin1_General_CI_AI IN (SELECT ExcelLineNo FROM #ExcelSrNo) OR COL1 = ''Excel Sr. No'')
		  ')

		  DECLARE @Col1 INT= @TotalCounter + 1, @Col2 INT= @TotalCounter + 2
		  EXEC ('
		  		UPDATE #tempBulkImportExport_To_Excel 
		  		SET COL'+ @Col1 +' = ''Record Status'', COL'+ @Col2 +' = ''Error Message'' where COL01 = ''Excel Sr. No''
		  ')

		  EXEC ('
			  UPDATE #tempBulkImportExport_To_Excel SET COL'+ @Col1 +'
			  CASE WHEN COL'+ @Col2 +' = ''Y'' THEN ''Ignore''
													 WHEN COL'+ @Col1 +' = ''C'' THEN ''Success''
													 WHEN COL'+ @Col1 +' = ''E'' THEN ''Error''
													 WHEN COL'+ @Col1 +' = ''N'' THEN ''No Error''
													 WHEN COL'+ @Col1 +' = ''P'' THEN ''Proceed''
													 WHEN COL'+ @Col1 +' = ''R'' THEN ''Resolve Conflict''
												END AS Status
			   WHERE COL01 <> ''Excel Sr. No''
			')

		  SELECT * FROM #tempBulkImportExport_To_Excel
	END

	---- Music_Track
	IF(@File_Type = 'M')
	BEGIN
		IF(@DM_Master_Import_Code > 0) 
			set @Condition  += ' AND DMT.DM_Master_Import_Code  ='+ cast( @DM_Master_Import_Code as varchar)+'' 
		 IF(@SearchCriteria != '')
			set @Condition += ' AND ([Music_Title_Name]  Like ''' + @SearchCriteria + ''' OR [Movie_Album] Like ''' + @SearchCriteria + ''' OR [Music_Label] Like ''' + @SearchCriteria +
									  ''' OR [Title_Language] Like ''' + @SearchCriteria + ''' OR [Star_Cast] Like ''' + @SearchCriteria + ''' OR [Music_Album_Type] Like ''' + @SearchCriteria +
									  ''' OR [Singers] Like ''' + @SearchCriteria +''' OR [Genres] Like ''' + @SearchCriteria +''')'
		 IF(@Record_Status != '')
			set @Condition += ' AND [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter('''+@Record_Status+''', '''+ ',' +''') WHERE number != '''')'						         
		 IF(@Is_Ignore != '')
			set @Condition += ' AND [Is_Ignore] =''' + @Is_Ignore +''''
             
		IF(OBJECT_ID('TEMPDB..#TempSinger') IS NOT NULL)
			DROP TABLE #TempSinger
		IF(OBJECT_ID('TEMPDB..#TempStarCast') IS NOT NULL)
			DROP TABLE #TempStarCast
		IF(OBJECT_ID('TEMPDB..#TempErrorMsg') IS NOT NULL)
			DROP TABLE #TempErrorMsg
		IF(OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL)
			DROP TABLE #TempLanguage 
         	
		CREATE TABLE #TempStarCast
		(
			ID INT,		
			StarCast NVARCHAR(MAX)			
		)
		CREATE TABLE #TempSinger
		(
			ID INT,
			Singer NVARCHAR(MAX)
		)
		CREATE TABLE #TempErrorMsg
		(
			ID INT,		
			ErrorMessage NVARCHAR(MAX)			
		)
		CREATE TABLE #TempLanguage
		(
			ID INT,
			Language NVARCHAR(MAX)
		)

		INSERT INTO #TempStarCast(ID, StarCast)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS StarCast from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Star_Cast],',') 
		WHERE LTRIM(RTRIM(ISNULL([Star_Cast], ''))) <> ''
			
		INSERT INTO #TempSinger(ID, Singer)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Singers from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Singers],',') 
		WHERE LTRIM(RTRIM(ISNULL([Singers], ''))) <> '' 
		
		INSERT INTO #TempErrorMsg(ID, ErrorMessage)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS ErrorMsg from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
		WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 

		INSERT INTO #TempLanguage(ID, Language)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Language from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Title_Language, ''))) <> '' 
		AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

		INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20)				  
		SELECT 'Excel Line No', 'Music Track', 'Length', 'Movie/Album', 'Singers', 'Lyricist', 'Music Composer',' Music Language', 'Music Label',
						   'Year of Release', 'Genres','Song Star Cast', 'Music Version', 'Effective Start Date', ' Music Theme', 'Music Tag', 'Movie Star Cast', 'Music Album Type',
						   'Status', 'Error Message'

		Declare @Sql1 NVARCHAR(MAX)

		Set @Sql1 =  '
			        INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20)				  
					SELECT [Excel_Line_No], [Music_Title_Name], [Duration], [Movie_Album], [Singers], [Lyricist], [Music_Director], [Title_Language], [Music_Label],
						   [Year_of_Release], [Genres], [Star_Cast], [Music_Version], [Effective_Start_Date], [Theme], [Music_Tag], [Movie_Star_Cast], [Music_Album_Type],
						   Status, [Error_Message] from
						   (
						      Select * FROM
							  (
								SELECT distinct [IntCode], [Excel_Line_No], [Music_Title_Name], [Duration], [Movie_Album], [Singers], [Lyricist], [Music_Director], [Title_Language], [Music_Label],
								[Year_of_Release], [Genres], [Star_Cast], [Music_Version], [Effective_Start_Date], [Theme], [Music_Tag], [Movie_Star_Cast], [Music_Album_Type],
									CASE WHEN [Is_Ignore] = ''Y'' THEN ''Ignore''
												 WHEN [Record_Status] = ''C'' THEN ''Success''
											     WHEN [Record_Status] = ''E'' THEN ''Error''
											     WHEN [Record_Status] = ''N'' THEN ''No Error''
												 WHEN [Record_Status] = ''P'' THEN ''Proceed''
												 WHEN [Record_Status] = ''R'' THEN ''Resolve Conflict''
											END AS Status,
											[Error_Message]
								            FROM DM_Music_Title DMT
										    LEFT JOIN #TempErrorMsg TEM ON DMT.IntCode = TEM.ID 
											LEFT JOIN #TempSinger TS ON DMT.IntCode = TS.ID
											LEFT JOIN #TempStarCast TST ON DMT.IntCode = TST.ID
											LEFT JOIN #TempLanguage TL ON DMT.IntCode = TL.ID
											where 1=1    										 
                                              '+ @Condition +'  '+@AdvanceSearch+' 
                                      )as XYZ  Where 1 = 1 
                             )as X   '			
		Exec(@Sql1)				
		SELECT *  FROM #tempBulkImportExport_To_Excel 
	END

	-- Content
	IF(@File_Type = 'C')
	BEGIN
		 IF(@DM_Master_Import_Code > 0) 
			set @Condition  += ' AND DCM.DM_Master_Import_Code  ='+ cast( @DM_Master_Import_Code as varchar)+'' 
         IF(@SearchCriteria != '')
			set @Condition += ' AND ([Content_Name] Like ''' + @SearchCriteria + ''' OR [Episode_No] Like ''' + @SearchCriteria + ''' OR [Music_Track] Like ''' + @SearchCriteria +''')'
		 IF(@Record_Status != '')
			set @Condition += ' AND [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter('''+@Record_Status+''', '''+ ',' +''') WHERE number != '''')'						         
		 IF(@Is_Ignore != '')
			set @Condition += ' AND DCM.[Is_Ignore] =''' + @Is_Ignore +''''

	     IF(OBJECT_ID('TEMPDB..#TempContentErrorMsg') IS NOT NULL)
			 DROP TABLE #TempContentErrorMsg
		 IF(OBJECT_ID('TEMPDB..#TempMusicTitle') IS NOT NULL)
			 DROP TABLE #TempMusicTitle
        			  
		 CREATE TABLE #TempContentErrorMsg
		 (
			 ID INT,
			 ErrorMsg NVARCHAR(MAX)
		 )

		 IF(OBJECT_ID('TEMPDB..#TempMasterImportCode') IS NOT NULL)
			 DROP TABLE #TempMasterImportCode	
        			
		 INSERT INTO #TempContentErrorMsg(ID, ErrorMsg)
		 SELECT DCM.IntCode, LTRIM(RTRIM(number)) AS ErrorMsg from DM_Content_Music DCM
		 CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
		 WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 

		 SELECT * INTO #TempMasterImportCode 
		 FROM(
		 SELECT @DM_Master_Import_Code as DM_Master_Import_Code ,Name ,Master_Type,Master_Code,User_Action,Action_By,Action_On,Roles,Is_Ignore,Mapped_By  FROM DM_Master_Log where DM_Master_Import_Code LIKE '~' + CAST(@DM_Master_Import_Code AS VARCHAR) + '~'
		 UNION
		 SELECT @DM_Master_Import_Code as DM_Master_Import_Code,Name,Master_Type,Master_Code,User_Action,Action_By,Action_On,Roles,Is_Ignore,Mapped_By  FROM DM_Master_Log where DM_Master_Import_Code = CAST(@DM_Master_Import_Code AS VARCHAR)
		 ) as a
			
		 SELECT Distinct DCM.IntCode, MT.Music_Title_Name Into #TempMusicTitle FROM DM_Content_Music DCM 
		 LEFT JOIN #TempMasterImportCode DML ON DCM.DM_Master_Import_Code = DML.DM_Master_Import_Code
		 LEFT JOIN Music_Title MT ON MT.Music_Title_Code = DML.Master_Code
		 Where DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DCM.Music_Track IN (DML.Name)

         INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18)
		 Select  'Int Code', 'Excel Line No','Content Name','Episode No',' Version Name','Music Track', 'From',
				                'To', 'From Frame', 'To Frame', 'Duration', 'Duration Frame', 'Status', 'Error Message', 'Mapped To', 'Mapped By', 'Action By', 'Mapped Date'

		 Declare @SqlQuery NVARCHAR(MAX)

		 Set @SqlQuery =  '	
			            INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18)
						 Select  distinct [IntCode], [Excel_Line_No],[Content_Name],[Episode_No], [Version_Name], [Music_Track], [From]
				                  ,[To], [From_Frame], [To_Frame], [Duration], [Duration_Frame], Status, [Error_Message], [MappedTo], [MappedBy], [ActionBy], [MappedDate]   From      
                            (      
                                select distinct * from (      
                                    select distinct DCM.[IntCode], DCM.[Excel_Line_No], DCM.[Content_Name], DCM.[Episode_No], DCM.[Version_Name],  DCM.[Music_Track], DCM.[From]    
										     ,DCM.[To], DCM.[From_Frame], DCM.[To_Frame], DCM.[Duration], DCM.[Duration_Frame],
											CASE WHEN DCM.[Is_Ignore] = ''Y'' THEN ''Ignore''
												 WHEN DCM.[Record_Status] = ''C'' THEN ''Success''
											     WHEN DCM.[Record_Status] = ''E'' THEN ''Error''
											     WHEN DCM.[Record_Status] = ''N'' THEN ''No Error''
												 WHEN DCM.[Record_Status] = ''P'' THEN ''Proceed''
												 WHEN (DCM.[Record_Status] = ''OR'' OR DCM.[Record_Status] = ''MR'' OR DCM.[Record_Status] = ''SM'' OR DCM.[Record_Status] = ''MO'' OR DCM.[Record_Status] = ''SO'') THEN ''Resolve Conflict''  
											END AS Status,
											DCM.[Error_Message], T.Music_Title_Name as MappedTo, 
											CASE WHEN (DML.Mapped_By = ''U'' AND DML.Master_Code IS NOT NULL) THEN ''Users''
											WHEN ((DML.Mapped_By = ''S'' OR DML.Mapped_By = ''V'') AND DML.Master_Code IS NOT NULL) THEN ''System''
											END AS MappedBy,
											CASE WHEN (DML.Mapped_By = ''U'' AND DML.Master_Code IS NOT NULL) THEN U.First_Name
											ELSE '''' END as ActionBy,
											CASE WHEN DML.Master_Code IS NOT NULL THEN DML.Action_On
											ELSE NULL END as MappedDate
                                            FROM DM_Content_Music  DCM		
											LEFT JOIN #TempMasterImportCode DML ON  DCM.DM_Master_Import_Code  =  DML.DM_Master_Import_Code 
											LEFT Join Users U ON DML.Action_By  = U.Users_Code 
											LEFT JOIN #TempMusicTitle T ON T.IntCode = DCM.IntCode
											LEFT JOIN #TempContentErrorMsg TCEM ON DCM.IntCode = TCEM.ID																																
                                            where 1=1    										 
                                              '+ @Condition +'  '+@AdvanceSearch+' 											
                                      )as XYZ where 1=1
                             )as X '			 
		  Exec(@SqlQuery)   
		SELECT COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18 FROM #tempBulkImportExport_To_Excel 
	END

	IF OBJECT_ID('tempdb..#tempBulkImportExport_To_Excel') IS NOT NULL DROP TABLE #tempBulkImportExport_To_Excel
	IF OBJECT_ID('tempdb..#TempContentErrorMsg') IS NOT NULL DROP TABLE #TempContentErrorMsg
	IF OBJECT_ID('tempdb..#TempDirector') IS NOT NULL DROP TABLE #TempDirector
	IF OBJECT_ID('tempdb..#TempErrorMsg') IS NOT NULL DROP TABLE #TempErrorMsg
	IF OBJECT_ID('tempdb..#TempKeyStarCast') IS NOT NULL DROP TABLE #TempKeyStarCast
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempMasterImportCode') IS NOT NULL DROP TABLE #TempMasterImportCode
	IF OBJECT_ID('tempdb..#TempMusicLabel') IS NOT NULL DROP TABLE #TempMusicLabel
	IF OBJECT_ID('tempdb..#TempMusicTitle') IS NOT NULL DROP TABLE #TempMusicTitle
	IF OBJECT_ID('tempdb..#TempSinger') IS NOT NULL DROP TABLE #TempSinger
	IF OBJECT_ID('tempdb..#TempStarCast') IS NOT NULL DROP TABLE #TempStarCast
	IF OBJECT_ID('tempdb..#TempTitleErrorMsg') IS NOT NULL DROP TABLE #TempTitleErrorMsg
END
GO
PRINT N'Altering [dbo].[USPMHConsumptionRequestList]...';


GO
ALTER PROCEDURE [dbo].[USPMHConsumptionRequestList]
@RequestTypeCode INT,
@UsersCode INT,
@RecordFor VARCHAR(2), 
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@RecordCount INT OUT,
@RequestID NVARCHAR(MAX),
@ChannelCode NVARCHAR(MAX),
@ShowCode NVARCHAR(MAX),
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50) = '',
@ToDate NVARCHAR(50)= '',
@SortBy NVARCHAR(50)= '',
@Order NVARCHAR(50)= ''
AS
BEGIN
SET FMTONLY OFF
	
	--BEGIN
	--DECLARE
	--@RequestTypeCode INT = 1,
	--@UsersCode INT = 293,
	--@RecordFor VARCHAR(2) = 'L', 
	--@PagingRequired NVARCHAR(2) = 'Y',
	--@PageSize INT = 10,
	--@PageNo INT = 1,
	--@RecordCount INT,-- OUT,
	--@RequestID NVARCHAR(MAX) = '',
	--@ChannelCode NVARCHAR(MAX) = '',
	--@ShowCode NVARCHAR(MAX) = '',
	--@StatusCode NVARCHAR(MAX) = '',
	--@FromDate NVARCHAR(50) = '',
	--@ToDate NVARCHAR(50)= '',
	--@SortBy NVARCHAR(50)= 'RequestDate',
	--@Order NVARCHAR(50)= 'DESC'

	IF(OBJECT_ID('TEMPDB..#TempConsumptionList') IS NOT NULL)
		DROP TABLE #TempConsumptionList
	IF(OBJECT_ID('TEMPDB..#tempApprovedCount') IS NOT NULL)
		DROP TABLE #tempApprovedCount
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal

	CREATE TABLE #TempConsumptionList(
	Row_No INT IDENTITY(1,1),
	RequestID NVARCHAR(50),
	MusicLabel NVARCHAR(MAX),
	RequestCode INT,
	Title_Name NVARCHAR(100),
	EpisodeFrom INT,
	EpisodeTo INT,
	TelecastFrom NVARCHAR(50),
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50)
	)

	CREATE TABLE #TempConsumptionListFinal(
	Row_No INT IDENTITY(1,1),
	RequestID NVARCHAR(50),
	MusicLabel NVARCHAR(MAX),
	RequestCode INT,
	Title_Name NVARCHAR(100),
	EpisodeFrom INT,
	EpisodeTo INT,
	TelecastFrom NVARCHAR(50),
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50),
	ApprovedRequest INT
	)
	
	CREATE TABLE #tempApprovedCount
	(
	MHRequestCode INT,
	Approved INT
	)

	if(@PageNo = 0)
        Set @PageNo = 1

	DECLARE @Count INT;
	IF(@RecordFor = 'D')
		BEGIN
			SET @Count = 5
		END
	ELSE
		BEGIN
			SET @Count = (SELECT COUNT(MHRequestCode) FROM MHRequest WHERE MHRequestTypeCode = @RequestTypeCode AND VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode))
		END

	IF(@FromDate = '' AND @ToDate <> '')
		SET @FromDate = '01-Jan-1970'
	ELSE IF(@ToDate = '' AND @FromDate <> '')
		Set @ToDate = '31-Dec-9999'
	ELSE IF(@FromDate = '' AND @ToDate = '')
		BEGIN
			SET @FromDate = '01-Jan-1970'
			Set @ToDate = '31-Dec-9999'
		END
	
	Print @FromDate
	Print @ToDate

	INSERT INTO #tempApprovedCount(Approved,MHRequestCode)
	Select COUNT(MHRequestCode) AS ApprovedCount,MHRequestCode FROM MHRequestDetails WITH (NOLOCK)
	WHERE IsApprove = 'Y' 
	GROUP BY MHRequestCode 

	INSERT INTO #TempConsumptionList(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate)
	SELECT TOP(@Count) MR.RequestID,
	ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS VARCHAR(Max))[text()]
			 FROM MHRequestDetails MRD
			 --INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
			 LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
			 LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			 Where MRD.MHRequestCode = MR.MHRequestCode
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) MusicLabel,
	ISNULL(MR.MHRequestCode,0) AS RequestCode,ISNULL(T.Title_Name,'') AS Title_Name ,ISNULL(MR.EpisodeFrom,'') AS EpisodeFrom,ISNULL(MR.EpisodeTo,'') AS EpisodeTo,ISNULL(MR.TelecastFrom,'') AS TelecastFrom,ISNULL(MR.TelecastTo,'') AS TelecastTo,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS Login_Name,ISNULL(C.Channel_Name,'') AS ChannelName,
	ISNULL(MR.RequestedDate,'') AS RequestDate
	--INTO #tempRequest
	FROM MHRequest MR WITH(NOLOCK)
	LEFT JOIN Title T WITH(NOLOCK) ON T.Title_Code = MR.TitleCode
	LEFT JOIN MHRequestStatus MRS WITH(NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
	LEFT JOIN Users U WITH(NOLOCK) ON U.Users_Code = MR.UsersCode
	LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
	LEFT JOIN Channel C WITH(NOLOCK) ON C.Channel_Code = MR.ChannelCode
	WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode) AND
	(@RequestID = '' OR MR.RequestID like '%'+@RequestID+'%') AND (@ChannelCode = '' OR C.Channel_Code IN(select number from dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) AND (@ShowCode = '' OR T.Title_Code IN(select number from dbo.fn_Split_withdelemiter(@ShowCode,','))) 
	AND (@StatusCode = '' OR MRS.MHRequestStatusCode IN(select number from dbo.fn_Split_withdelemiter(@StatusCode,',')))
	AND
	--((REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	((CAST(MR.RequestedDate AS DATE) BETWEEN @FromDate AND @ToDate))
	GROUP BY MRD.MHRequestCode,MR.RequestID,T.Title_Name ,MR.EpisodeFrom,MR.EpisodeTo,MR.TelecastFrom,MR.TelecastTo,MRS.RequestStatusName,MRS.RequestStatusName,U.Login_Name,MR.RequestedDate,MR.MHRequestCode,C.Channel_Name
	ORDER BY MR.RequestedDate DESC

	SELECT @RecordCount = COUNT(*) FROM #TempConsumptionList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	
	BEGIN
		IF(@SortBy = 'RequestDate')
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest 
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				ORDER BY CAST('+ @SortBy + ' AS DATETIME) ' + @Order)
			END
		ELSE
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest 
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				ORDER BY '+ @SortBy + ' ' + @Order)
			END
	END

	IF(@PagingRequired  = 'Y')
		BEGIN
			DELETE from  #TempConsumptionListFinal
			WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
		END

	SELECT * FROM #TempConsumptionListFinal


	IF OBJECT_ID('tempdb..#TempConsumptionList') IS NOT NULL DROP TABLE #TempConsumptionList
	IF OBJECT_ID('tempdb..#tempRequest') IS NOT NULL DROP TABLE #tempRequest
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal
END

--DECLARE @RecordCount INT
--EXEC USPMHConsumptionRequestList 1,1287,'L','Y',10,1,@RecordCount OUTPUT,'','','','','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
GO
PRINT N'Altering [dbo].[USPMHGetCueSheetList]...';


GO
ALTER PROCEDURE [dbo].[USPMHGetCueSheetList]
@MHCueSheetCode INT,
@UsersCode INT,
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@RecordCount INT OUT,
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50),
@ToDate NVARCHAR(50),
@SortBy NVARCHAR(50)= '',
@Order NVARCHAR(50)= ''
AS
BEGIN

	--DECLARE
	--@MHCueSheetCode INT= 0,
	--@UsersCode INT = 293,
	--@PagingRequired NVARCHAR(2) = 'Y',
	--@PageSize INT = 10,
	--@PageNo INT = 1,
	--@RecordCount INT,-- OUT,
	--@StatusCode NVARCHAR(MAX)='C',
	--@FromDate NVARCHAR(50)='',
	--@ToDate NVARCHAR(50)='',
	--@SortBy NVARCHAR(50)= 'TotalRecords',
	--@Order NVARCHAR(50)= 'DESC'
	
	IF(OBJECT_ID('TEMPDB..#TempCueSheetList') IS NOT NULL)
		DROP TABLE #TempCueSheetList
	IF OBJECT_ID('tempdb..#TempCueSheetListFinal') IS NOT NULL DROP TABLE #TempCueSheetListFinal

	CREATE TABLE #TempCueSheetList(
	Row_No INT IDENTITY(1,1),
	MHCueSheetCode INT,
	RequestID NVARCHAR(50),
	FileName NVARCHAR(MAX),
	RequestedBy NVARCHAR(MAX),
	RequestedDate NVARCHAR(50),
	RecordStatus NVARCHAR(20),
	Status NVARCHAR(MAX),
	TotalRecords INT,
	ErrorRecords INT,
	WarningRecords INT,
	SuccessRecords INT
	)

	CREATE TABLE #TempCueSheetListFinal(
	Row_No INT IDENTITY(1,1),
	MHCueSheetCode INT,
	RequestID NVARCHAR(50),
	FileName NVARCHAR(MAX),
	RequestedBy NVARCHAR(MAX),
	RequestedDate NVARCHAR(50),
	RecordStatus NVARCHAR(20),
	Status NVARCHAR(MAX),
	TotalRecords INT,
	ErrorRecords INT,
	WarningRecords INT,
	SuccessRecords INT
	)
	
	IF(@FromDate = '' AND @ToDate <> '')
		SET @FromDate = '01-Jan-1970'
	ELSE IF(@ToDate = '' AND @FromDate <> '')
		Set @ToDate = '31-Dec-9999'
	ELSE IF(@FromDate = '' AND @ToDate = '')
		BEGIN
			SET @FromDate = '01-Jan-1970'
			Set @ToDate = '31-Dec-9999'
		END
	
	Print @FromDate
	Print @ToDate

	if(@PageNo = 0)
        Set @PageNo = 1
	
	IF(@StatusCode = 'D')
		SET @StatusCode = 'E,W'
	ELSE IF(@StatusCode = 'S')
		SET @StatusCode = 'C'

	INSERT INTO #TempCueSheetList(MHCueSheetCode,RequestID,FileName,RequestedBy,RequestedDate,RecordStatus,Status,TotalRecords,ErrorRecords,WarningRecords,SuccessRecords)
	SELECT MHCueSheetCode,RequestID,ISNULL(FileName,'') AS FileName,ISNULL(U.Login_Name,'') AS RequestedBy,CAST(CreatedOn AS DATE) AS RequestedDate,ISNULL(UploadStatus,'') AS RecordStatus,
	CASE 
		WHEN UploadStatus = 'P' THEN 'Pending' 
		WHEN UploadStatus IN ('E', 'W') THEN 'Data Error'
		ELSE 'Submit' END AS Status,
	ISNULL(TotalRecords,0) AS TotalRecords,--ISNULL(ErrorRecords,0) AS ErrorRecords  
	(SELECT COUNT(*) FROM MHCueSheetSong cmsi WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'E') AS ErrorRecords,
	(SELECT COUNT(*) FROM MHCueSheetSong cmsi WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'W') AS WarningRecords,
	(SELECT COUNT(*) FROM MHCueSheetSong cmsi WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'S') AS SuccessRecords
	FROM MHCueSheet MCS
	INNER JOIN Users U ON U.Users_Code = MCS.CreatedBy
	WHERE MCS.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
	AND (@StatusCode = '' OR UploadStatus IN (select number from dbo.fn_Split_withdelemiter(@StatusCode,','))) AND
	--(MCS.CreatedOn BETWEEN @FromDate AND @ToDate)
	 (@MHCueSheetCode = 0 OR MCS.MHCueSheetCode = @MHCueSheetCode)
	AND ((CAST(MCS.CreatedOn AS DATE) BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	ORDER BY CreatedOn DESC

	SELECT @RecordCount = COUNT(*) FROM #TempCueSheetList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	EXEC ('INSERT INTO #TempCueSheetListFinal
	SELECT MHCueSheetCode,RequestID,FileName,RequestedBy,RequestedDate,RecordStatus,
	CASE WHEN TotalRecords = SuccessRecords THEN ''Success''
		WHEN ErrorRecords > 0 THEN ''Error''
		WHEN (ErrorRecords = 0 AND WarningRecords > 0) THEN ''Data Error''
		WHEN (RecordStatus = ''P'') Then ''Pending''
		--ELSE ''Pending''
	END AS
	Status,TotalRecords,ErrorRecords,WarningRecords,SuccessRecords FROM #TempCueSheetList ORDER BY '+ @SortBy + ' ' + @Order)

	IF(@PagingRequired  = 'Y')
		BEGIN
			DELETE from  #TempCueSheetListFinal
			WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
		END

	SELECT * FROM #TempCueSheetListFinal

	IF OBJECT_ID('tempdb..#TempCueSheetList') IS NOT NULL DROP TABLE #TempCueSheetList
	IF OBJECT_ID('tempdb..#TempCueSheetListFinal') IS NOT NULL DROP TABLE #TempCueSheetListFinal

END

--DECLARE @RecordCount INT
--EXEC USPMHGetCueSheetList 110,1287,'Y',10,1,@RecordCount OUTPUT,'','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
--select REPLACE(CONVERT(NVARCHAR,GETDATE(), 106), ' ', '-')
GO
PRINT N'Altering [dbo].[USPMHGetRequestDetails]...';


GO
ALTER PROCEDURE [dbo].[USPMHGetRequestDetails]
@RequestCode NVARCHAR(MAX),
@RequestTypeCode INT,
@IsCueSheet CHAR = 'N'
AS
BEGIN
	IF(@RequestTypeCode = 1)
		BEGIN
		IF(@IsCueSheet = 'Y')
			BEGIN
				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,MR.SpecialInstruction
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',','))) AND MRD.IsApprove = 'Y'
			END
		ELSE
			BEGIN
				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,MR.SpecialInstruction
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',',')))
			END
			
		END
	ELSE IF(@RequestTypeCode = 2)
		BEGIN
			SELECT ISNULL(MRD.MusicTrackName,'') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'') AS MusicMovieAlbumName,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
			ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove,
				 ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.Singers,'')),'') AS Singers,ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.StarCasts,'')),'') AS StarCasts
			FROM MHRequestDetails MRD
			LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
			WHERE MRD.MHRequestCode = @RequestCode
		END
	ELSE
		BEGIN
			SELECT ISNULL(MRD.TitleName,'') AS RequestedMovieAlbumName,ISNULL(MA.Music_Album_Name,'') AS ApprovedMovieAlbumName,
			CASE WHEN MRD.MovieAlbum = 'A' THEN 'Album' 
				 ELSE 'Movie' END AS MovieAlbum,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
				 ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove
			FROM MHRequestDetails MRD 
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode
			WHERE MRD.MHRequestCode = @RequestCode
		END
END
GO
PRINT N'Altering [dbo].[USPMHMailNotification]...';


GO
ALTER PROCEDURE USPMHMailNotification
	@MHRequestCode INT,
	@MHRequestTypeCode INT = 0,
	@MHCueSheetCode INT = 0
AS
--=====================================================
-- Author:		<Akshay Rane>
-- Create date: <16 August 2018>
-- Description:	<Email Notification for music hub>
--=====================================================
BEGIN
	--DECLARE @MHRequestCode INT = 10466, @MHRequestTypeCode INT = 1, @MHCueSheetCode INT = 184

	IF OBJECT_ID('tempdb..#UsageRequest') IS NOT NULL
		DROP TABLE #UsageRequest

	IF OBJECT_ID('tempdb..#MusicTracksRequest') IS NOT NULL
		DROP TABLE #MusicTracksRequest
		
	IF OBJECT_ID('tempdb..#NewMovieRequest') IS NOT NULL
		DROP TABLE #NewMovieRequest

	DECLARE @Subject NVARCHAR(MAX), @MailSubjectCr NVARCHAR(MAX),@DatabaseEmail_Profile varchar(MAX), @EmailUser_Body NVARCHAR(MAX), @DefaultSiteUrl VARCHAR(MAX), @Email_Config_Code INT = 0

	DECLARE @ChannelName NVARCHAR(MAX),  @ShowName NVARCHAR(MAX), @EpisodeNo NVARCHAR(MAX), @TelecastDate NVARCHAR(MAX),@MusicLabel NVARCHAR(MAX), 
	@NoOfSongs NVARCHAR(MAX), @AuthorisedBy NVARCHAR(MAX) , @AuthorisedDate NVARCHAR(MAX), @RequestDate  NVARCHAR(MAX), @RequestID NVARCHAR(MAX),
	@RequestStatusName NVARCHAR(MAX), @SongsApproved NVARCHAR(MAX), @VendorCode INT

	DECLARE @ApprovedOn  NVARCHAR(MAX),  @FileName  NVARCHAR(MAX),  @SubmitBy  NVARCHAR(MAX), @SubmitOn  NVARCHAR(MAX) 

	DECLARE @DynamicTableName NVARCHAR(MAX) = ''

	BEGIN TRY
		IF(@MHCueSheetCode = 0)
		BEGIN
			IF(@MHRequestTypeCode = 1)
			BEGIN
				SELECT DISTINCT
					 @ChannelName = C.Channel_Name
					,@ShowName = (select TOP 1 T.Title_Name from Title T Where T.Title_Code = MR.TitleCode)
					,@EpisodeNo = CASE WHEN ISNULL(MR.EpisodeFrom,0)  < ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX)) +' - '+ CAST(MR.EpisodeTo AS VARCHAR(MAX))
						 WHEN ISNULL(MR.EpisodeFrom,0)  = ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX))
						 ELSE '' END
					,@TelecastDate = CASE WHEN CAST(MR.TelecastFrom AS DATE) =  CAST(MR.TelecastTo AS DATE) 
									THEN CONVERT(varchar(11),IsNull(MR.TelecastFrom,''), 106)
									ELSE
									CONVERT(varchar(11),IsNull(MR.TelecastFrom,''), 106)  + ' - ' + CONVERT(varchar(11),IsNull(MR.TelecastTo,''), 106)
									END
					,@MusicLabel = STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS NVARCHAR) FROM MHRequestDetails MRD1
						 INNER JOIN Music_Title_Label MTL ON MRD1.MusicTitleCode = MTL.Music_Title_Code 
						 INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
						 Where MRD1.MHRequestCode = MR.MHRequestCode
						 FOR XML PATH('')), 1, 1, '')
					,@NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
					LEFT JOIN Channel c ON c.Channel_Code = MR.ChannelCode
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr= @RequestID +' – Usage Request - is '+UPPER(@RequestStatusName)
				 --SELECT @ChannelName,@ShowName,@EpisodeNo,@TelecastDate,@MusicLabel,@NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved
	
				 DECLARE @PivotUR TABLE 
					(Channel_Name NVARCHAR(MAX),Show_Name  NVARCHAR(MAX), Episode_No  NVARCHAR(MAX),Telecast_Date  NVARCHAR(MAX),
					Music_Label  NVARCHAR(MAX),No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX) )

				INSERT INTO @PivotUR VALUES (@ChannelName, @ShowName, @EpisodeNo, @TelecastDate, @MusicLabel, @NoOfSongs, @SongsApproved)

				SELECT * INTO #UsageRequest FROM(
				SELECT 1 AS RowId, 'Channel Name: ' as ColName, Channel_Name as ColValue from @PivotUR UNION ALL
				SELECT 2 AS RowId, 'Show Name: ' as ColName, Show_Name as ColValue from @PivotUR UNION ALL
				SELECT 3 AS RowId, 'Episode No.: ' as ColName, Episode_No as ColValue from @PivotUR UNION ALL
				SELECT 4 AS RowId, 'Telecast Date: ' as ColName, Telecast_Date as ColValue from @PivotUR UNION ALL
				SELECT 5 AS RowId, 'Music Label: ' as ColName, Music_Label as ColValue from @PivotUR UNION ALL
				SELECT 6 AS RowId, 'Number of Songs: ' as ColName, No_Of_Songs as ColValue from @PivotUR UNION ALL
				SELECT 7 AS RowId, 'Songs Approved: ' as ColName, Songs_Approved as ColValue from @PivotUR) as tmp 
		
				IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED' )
				BEGIN
					DELETE FROM #UsageRequest WHERE RowId = 7
				END

				SET @DynamicTableName = '#UsageRequest'
				SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHCONSUMPTIONREQUEST'
			END
			ELSE IF(@MHRequestTypeCode = 2)
			BEGIN
				SELECT DISTINCT
					 @NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr=@RequestID +' – New Music Tracks Request - is '+UPPER(@RequestStatusName)

				 --SELECT @NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved

				 DECLARE @PivotMTR TABLE (No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX))

				 INSERT INTO @PivotMTR VALUES (@NoOfSongs, @SongsApproved)

				 SELECT * INTO #MusicTracksRequest FROM(
				 SELECT 1 AS RowId, 'Number of Songs: ' as ColName, No_Of_Songs as ColValue from @PivotMTR UNION ALL
				 SELECT 2 AS RowId, 'Approved Songs: ' as ColName, Songs_Approved as ColValue from @PivotMTR) as tmp 

				 IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED' )
				 BEGIN
		 			DELETE FROM #MusicTracksRequest WHERE RowId = 2
				 END

				 SET @DynamicTableName = '#MusicTracksRequest'
				 SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHMUSICREQUEST'
			END
			ELSE IF(@MHRequestTypeCode = 3)
			BEGIN
				 SELECT DISTINCT
					 @NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr=@RequestID +' – New Movie Request - is '+UPPER(@RequestStatusName)

				 --SELECT @NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved

				 DECLARE @PivotNMR TABLE (No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX))

				 INSERT INTO @PivotNMR VALUES (@NoOfSongs, @SongsApproved)

				 SELECT * INTO #NewMovieRequest FROM(
				 SELECT 1 AS RowId, 'Number of Movie/Album: ' as ColName, No_Of_Songs as ColValue from @PivotNMR UNION ALL
				 SELECT 2 AS RowId, 'Approved Movie/Album: ' as ColName, Songs_Approved as ColValue from @PivotNMR) as tmp 

				 IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED')
				 BEGIN
		 			DELETE FROM #NewMovieRequest WHERE RowId = 2
				 END

				 SET @DynamicTableName = '#NewMovieRequest'
				 SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHMOVIEREQUEST'
			END
		END
		ELSE
		BEGIN
			SELECT 
				@RequestID = MC.RequestID,
				@ApprovedOn =  CONVERT(VARCHAR(11),ISNULL(MC.ApprovedOn,''), 106),
				@FileName = MC.FileName, 
				@SubmitBy =V.Vendor_Name +' / ' + U.First_Name,
				@SubmitOn = CONVERT(VARCHAR(11),ISNULL(MC.SubmitOn,''), 106),
				@RequestStatusName = 'COMPLETED',
				@VendorCode = MC.VendorCode
			FROM MHCUESHEET MC
				INNER JOIN Vendor V ON V.Vendor_Code = MC.VendorCode
				INNER JOIN Users U ON U.Users_Code = MC.SubmitBy
			WHERE MC.MHCueSheetCode = @MHCueSheetCode 

			--SELECT @RequestID,@ApprovedOn,@FileName,@SubmitBy,@SubmitOn,@RequestStatusName

			SET @MailSubjectCr =  @RequestID +' – Music Assignment Request - is '+UPPER(@RequestStatusName)
			SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHCUESHEETUPLOAD'
		END
	 
		SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
		SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
		
		DECLARE @Email_Id NVARCHAR(MAX),  @Users_Code INT = 0, @UserName NVARCHAR(MAX) = '',
				@RowCount INT = 0, @Emailbody NVARCHAR(MAX), @EmailHead NVARCHAR(MAX), @EMailFooter NVARCHAR(MAX)

		DECLARE curOuter CURSOR FOR 
		SELECT MU.Users_Code,U.Email_Id, UPPER(LEFT(U.First_Name, 1))+LOWER(SUBSTRING(U.First_Name, 2, LEN(U.First_Name))) +' '+UPPER(LEFT(U.Last_Name, 1))+LOWER(SUBSTRING(U.Last_Name, 2, LEN(U.Last_Name))) AS UserName FROM MHUsers MU
		INNER JOIN Users U ON U.Users_Code = MU.Users_Code WHERE MU.Vendor_Code = @VendorCode AND U.Is_Active = 'Y'
		OPEN curOuter 
			
		FETCH NEXT FROM curOuter INTO @Users_Code, @Email_Id, @UserName

		SELECT  @EmailUser_Body='', @Emailbody = '', @EmailHead= '', @EMailFooter = ''

		WHILE @@Fetch_Status = 0 
		BEGIN	
				SET @Emailbody = '<table class="tblFormat" style="width:90%; border:1px solid black;border-collapse:collapse;">'
			
				IF(@RowCount = 0)
				BEGIN
					IF(@MHCueSheetCode = 0)
					BEGIN
						  SET @Emailbody=@Emailbody + '<tr><th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Date</th>
						  <th align="center" width="40%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Description</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Authorised By</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Authorised Date</th></tr>'
					 END
					 ELSE
					 BEGIN
						  SET @Emailbody=@Emailbody + '<tr><th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Date</th>
						  <th align="center" width="40%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Description</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Requested By</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Uploaded On</th></tr>'
					 END
				END
				SET @RowCount  = @RowCount  + 1

				IF(@MHCueSheetCode = 0)
				BEGIN
					DECLARE @returnCount INT = 0,  @Sql NVARCHAR(MAX)=''

					SET @SQL = 'SELECT @Count= Count(*) FROM ' + @DynamicTableName 

					EXEC sp_executesql @SQL,N'@Count INT OUTPUT',@Count=@returnCount OUTPUT

					SELECT @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' >'+ CAST  (ISNULL(@RequestDate, '') as varchar(MAX))+' </td>		
								{{DYNAMIC}}
								<td align="center" class="tblData" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (ISNULL(@AuthorisedBy,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (IsNull(@AuthorisedDate,'') AS NVARCHAR(MAX)) +' </td></tr>'

					DECLARE @i INT = 0

					WHILE (@i < @returnCount)
					BEGIN
						 DECLARE @ColName NVARCHAR(MAX)= '', @ColVal NVARCHAR(MAX)= ''
						 SET @i = @i + 1

						 DECLARE @temptable TABLE (ColName NVARCHAR(MAX), ColVal NVARCHAR(MAX))
						 SET @Sql = 'SELECT ColName, ColValue  FROM '+ @DynamicTableName +' WHERE  RowId = '+ Cast(@i as varchar(10))
						 INSERT @temptable EXEC(@Sql) 		 
						 SELECT @ColName = ColName, @ColVal= ColVal FROM @temptable	 

						 IF	(@i = 1)
						 BEGIN
							SELECT @Emailbody = REPLACE(@Emailbody, '{{DYNAMIC}}', '<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>'+@ColName +'</b> '+ @ColVal+'</td>');
						 END
						 ELSE
						 BEGIN
							SELECT @Emailbody=@Emailbody+ '<tr><td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>'+@ColName +'</b> '+ @ColVal+'</td></tr>'
						 END
						 DELETE FROM @temptable	
					END
				END
				ELSE
				BEGIN
					SELECT @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px" >'+ CAST  (ISNULL(@ApprovedOn, '') as varchar(MAX))+' </td>		
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (ISNULL(@FileName,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (ISNULL(@SubmitBy,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (IsNull(@SubmitOn,'') AS NVARCHAR(MAX)) +' </td></tr>'
				END
				IF(@Emailbody!='')
					SET @Emailbody = @Emailbody + '</table>'

				SET @EmailHead= '<html><head></head><body>
				<p>Dear '+@UserName+',</p>
				<p>The Request No: '+ @RequestID +' is <b>'+ UPPER(@RequestStatusName) +'</b>. </p>
				<p>Please click <a href="'+@DefaultSiteUrl+'">here</a> to access Music Hub to view the request.</p>
				<p>The details are as follows: </p>'

				SET @EMailFooter ='</br>
				</body></html>'

				--SET @EMailFooter ='</br>
				--If you have any questions or need assistance, please feel free to reach us at 
				--<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
				--<p>Regards,</br>
				--RightsU Support</br>
				--U-TO Solutions</p>
				--</body></html>'

				SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
		
				IF(@RowCount <> 0)
				BEGIN
					--select @EmailUser_Body, @Users_Code, @Email_Id, @UserName

					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @DatabaseEmail_Profile,
					@recipients =  @Email_Id,
					@subject = @MailSubjectCr,
					@body = @EmailUser_Body, 
					@body_format = 'HTML';

					INSERT INTO MHNotificationLog(Email_Config_Code, Created_Time, Is_Read, Email_Body,	User_Code, Vendor_Code, [Subject], Email_Id)
					SELECT @Email_Config_Code,GETDATE(),'N', @Emailbody, @Users_Code, @VendorCode, @MailSubjectCr, @Email_Id

					SET @RowCount = 0
				END
				SET @EmailUser_Body=''	
		
				FETCH NEXT FROM curOuter INTO @Users_Code, @Email_Id, @UserName
		END	
		CLOSE curOuter
		DEALLOCATE curOuter
		SELECT 'Y' as Result  
	END TRY
	BEGIN CATCH
			IF CURSOR_STATUS('global','curOuter')>=-1
			BEGIN
				CLOSE curOuter
				DEALLOCATE curOuter
			END
			
			SELECT ERROR_MESSAGE() as Result  
	END CATCH
	IF OBJECT_ID('tempdb..#MusicTracksRequest') IS NOT NULL DROP TABLE #MusicTracksRequest
	IF OBJECT_ID('tempdb..#NewMovieRequest') IS NOT NULL DROP TABLE #NewMovieRequest
	IF OBJECT_ID('tempdb..#UsageRequest') IS NOT NULL DROP TABLE #UsageRequest
END

--exec USPMHMailNotification 10466,1,0
--select * from MHNotificationLog
--select * from email_config order by 1 desc

--CREATE PROCEDURE USPMHMailNotification
--	@MHRequestCode INT,
--	@MHRequestTypeCode INT,
--	@MHCueSheetCode INT = 0
--AS
----=====================================================
---- Author:		<Akshay Rane>
---- Create date: <16 August 2018>
---- Description:	<Email Notification for music hub>
----=====================================================
--BEGIN
--	SELECT '' as Result  
--END
GO
PRINT N'Altering [dbo].[USPMHSearchMusicTrack]...';


GO
ALTER PROCEDURE [dbo].[USPMHSearchMusicTrack]
@MusicLabelCode INT ,
@MusicTrack NVARCHAR(50),
@MovieName NVARCHAR(50),
@GenreCode INT,
@TalentName NVARCHAR(50),
@Tag NVARCHAR(50),
@MHPlayListCode INT,
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@ChannelCode INT,
@TitleCode INT,
@MusicLanguageCode INT,
@RecordCount INT OUT,
@SortBy NVARCHAR(50),
@Order NVARCHAR(50)    
AS
BEGIN
SET FMTONLY OFF  
	
	--BEGIN
	--DECLARE
	--@MusicLabelCode INT = 0,
	--@MusicTrack NVARCHAR(50) = '',
	--@MovieName NVARCHAR(50) ='',
	--@GenreCode INT = 0,
	--@TalentName NVARCHAR(50)= '',
	--@Tag NVARCHAR(50) = '',
	--@MHPlayListCode INT = 1,
	--@PagingRequired NVARCHAR(2) = 'Y',
	--@PageSize INT = 2,
	--@PageNo INT = 1,
	--@ChannelCode INT = 1,
	--@TitleCode INT = 8504,
	--@MusicLanguageCode INT = 0,
	--@RecordCount INT,
	--@SortBy NVARCHAR(50) = 'Music_Title_Code',
	--@Order NVARCHAR(50) = 'DESC'  

	IF(OBJECT_ID('TEMPDB..#TempMusicTrackList') IS NOT NULL)
		DROP TABLE #TempMusicTrackList
	IF(OBJECT_ID('TEMPDB..#tempA') IS NOT NULL)
		DROP TABLE #tempA
	IF(OBJECT_ID('TEMPDB..#tempStuff') IS NOT NULL)
		DROP TABLE #tempStuff
	IF(OBJECT_ID('TEMPDB..#tempMusicLabel') IS NOT NULL)
		DROP TABLE #tempMusicLabel

			IF(OBJECT_ID('TEMPDB..#tempStuff2') IS NOT NULL)
		DROP TABLE #tempStuff2
			IF(OBJECT_ID('TEMPDB..#tempStuff3') IS NOT NULL)
		DROP TABLE #tempStuff3
	IF OBJECT_ID('tempdb..#TempMusicTrackListFinal') IS NOT NULL DROP TABLE #TempMusicTrackListFinal

	CREATE TABLE #TempMusicTrackList(
	Row_No INT IDENTITY(1,1),
	Music_Title_Code INT,
	Music_Album_Code INT,
	MusicTrack NVARCHAR(MAX),
	Movie NVARCHAR(MAX),
	Genre NVARCHAR(50),
	Tag NVARCHAR(MAX),
	MusicLabel NVARCHAR(50),
	--Talent NVARCHAR(MAX),
	StarCast NVARCHAR(MAX),
	Singers NVARCHAR(MAX),
	MusicComposer NVARCHAR(MAX),
	MusicLanguage NVARCHAR(MAX)
	)

	CREATE TABLE #TempMusicTrackListFinal(
	Row_No INT IDENTITY(1,1),
	Music_Title_Code INT,
	Music_Album_Code INT,
	MusicTrack NVARCHAR(MAX),
	Movie NVARCHAR(MAX),
	Genre NVARCHAR(50),
	Tag NVARCHAR(MAX),
	MusicLabel NVARCHAR(50),
	--Talent NVARCHAR(MAX),
	StarCast NVARCHAR(MAX),
	Singers NVARCHAR(MAX),
	MusicComposer NVARCHAR(MAX),
	MusicLanguage NVARCHAR(MAX)
	)

	CREATE TABLE #tempStuff(
	Talent_Code INT,
	Talent_Name NVARCHAR(100),
	Role_Name NVARCHAR(100),
	Music_Title_Code INT
	)

	CREATE TABLE #tempStuff2(
	Talent_Code INT,
	Talent_Name NVARCHAR(100),
	Role_Name NVARCHAR(100),
	Music_Title_Code INT
	)

	CREATE TABLE #tempStuff3(
	Talent_Code INT,
	Talent_Name NVARCHAR(100),
	Role_Name NVARCHAR(100),
	Music_Title_Code INT
	)
	
	CREATE TABLE #tempMusicLabel(
	MusicLabelCode INT,
	MusicLabelName NVARCHAR(MAX)
	)

	INSERT INTO #tempMusicLabel(MusicLabelCode,MusicLabelName)
	EXEC [USPMHGetMusicLabel] @ChannelCode,@TitleCode

	--select * from #tempMusicLabel
	Print 'P1' + Convert(Varchar(100), Getdate(), 109)
	INSERT INTO #tempStuff(Talent_Code,Talent_Name,Role_Name,Music_Title_Code)
	Select T.Talent_Code,T.Talent_Name,R.Role_Name,MTT.Music_Title_Code 
	FROM Music_Title_Talent MTT WITH(NOLOCK)
	INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
	--INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code
	INNER JOIN ROLE R WITH(NOLOCK) ON R.Role_Code = MTT.Role_Code
	Where R.Role_Code = 2 Order by T.Talent_Code

	INSERT INTO #tempStuff2(Talent_Code,Talent_Name,Role_Name,Music_Title_Code)
	Select T.Talent_Code,T.Talent_Name,R.Role_Name,MTT.Music_Title_Code 
	FROM Music_Title_Talent MTT WITH(NOLOCK)
	INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
	--INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code
	INNER JOIN ROLE R WITH(NOLOCK) ON R.Role_Code = MTT.Role_Code
	Where R.Role_Code= '13' Order by T.Talent_Code

	INSERT INTO #tempStuff3(Talent_Code,Talent_Name,Role_Name,Music_Title_Code)
	Select T.Talent_Code,T.Talent_Name,R.Role_Name,MTT.Music_Title_Code 
	FROM Music_Title_Talent MTT WITH(NOLOCK)
	INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
	--INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code
	INNER JOIN ROLE R WITH(NOLOCK) ON R.Role_Code = MTT.Role_Code
	Where R.Role_Name= '21' Order by T.Talent_Code
	if(@PageNo = 0)
        Set @PageNo = 1

	IF(@MHPlayListCode > 0)
	BEGIN
		INSERT INTO #TempMusicTrackList(Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,StarCast,Singers,MusicComposer, MusicLanguage)
		SELECT MT.Music_Title_Code,ISNULL(MT.Music_Album_Code,'') AS Music_Album_Code,MT.Music_Title_Name AS MusicTrack,ISNULL(MA.Music_Album_Name,'') AS Movie,ISNULL(G.Genres_Name,'') AS Genre,ISNULL(MT.Music_Tag,'') AS Tag,ISNULL(ML.MusicLabelName,'') AS MusicLabel
		--,STUFF((SELECT DISTINCT ', ' + CAST(T.Talent_Name AS VARCHAR(Max)) [text()]
		--	FROM Music_Title_Talent MTT
		--	INNER JOIN Talent T ON T.Talent_Code = MTT.Talent_Code
		--	Where MTT.Music_Title_Code = MT.Music_Title_Code
		--	FOR XML PATH(''), TYPE)
		--	.value('.','NVARCHAR(MAX)'),1,2,' '
		--) Talent
		,STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
			FROm #tempStuff ts
			Where ts.Music_Title_Code = MT.Music_Title_Code AND ts.Role_Name = 'Star Cast'
			FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '
		)  AS StarCast,
		STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
			FROm #tempStuff ts
			Where ts.Music_Title_Code = MT.Music_Title_Code
			FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '
		)  AS Singers,
		STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
			FROm #tempStuff ts
			Where ts.Music_Title_Code = MT.Music_Title_Code
			FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '
		)  AS MusicComposer, mlng.Language_Name AS MusicLanguage
		FROM Music_Title MT WITH(NOLOCK)
		LEFT JOIN Genres G WITH(NOLOCK) ON G.Genres_Code = MT.Genres_Code
		INNER JOIN Music_Title_Label MTL WITH(NOLOCK) ON MTL.Music_Title_Code = MT.Music_Title_Code AND MTL.Effective_To IS NULL
		INNER JOIN Music_Album MA WITH(NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
		--INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
		INNER JOIN #tempMusicLabel ML WITH(NOLOCK) ON ML.MusicLabelCode = MTL.Music_Label_Code
		INNER JOIN Music_Title_Language mtln ON mtln.Music_Title_Code = mt.Music_Title_Code
		INNER JOIN Music_Language mlng ON mlng.Music_Language_Code = mtln.Music_Language_Code
		INNER JOIN MHPlayListSong MHPLS WITH(NOLOCK) ON MHPLS.MusicTitleCode = MT.Music_Title_Code AND MHPLS.MHPlayListCode = @MHPlayListCode
		ORDER BY MT.Music_Title_Name	

		SELECT @RecordCount = COUNT(*) FROM #TempMusicTrackList
		print 'Record Count: ' +CAST(@RecordCount AS NVARCHAR)

		EXEC ('INSERT INTO #TempMusicTrackListFinal(Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,StarCast,Singers,MusicComposer)
				Select Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,ISNULL(StarCast,'''') AS StarCast,ISNULL(Singers,'''') AS Singers,ISNULL(MusicComposer,'''') AS MusicComposer 
				from #TempMusicTrackList ORDER BY '+ @SortBy + ' '+ @Order)

		DELETE from  #TempMusicTrackListFinal
		WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

		SELECT Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,StarCast,Singers,MusicComposer FROM #TempMusicTrackListFinal

	END
	ELSE
	BEGIN
		
		Print 'P2' + Convert(Varchar(100), Getdate(), 109)

		SELECT DISTINCT MTT.Music_Title_Code INTO #tempA 
		FROM Music_Title_Talent mtt WITH(NOLOCK)
		INNER JOIN Talent T WITH(NOLOCK) ON T.Talent_Code = MTT.Talent_Code
		Where ISNULL(T.Talent_Name,'') like '%'+@TalentName+'%'
				
		Print 'P3' + Convert(Varchar(100), Getdate(), 109)

		INSERT INTO #TempMusicTrackList(Music_Title_Code, Music_Album_Code, MusicTrack, Movie , Genre, Tag, MusicLabel, StarCast, Singers, MusicComposer, MusicLanguage)
		SELECT MT.Music_Title_Code,ISNULL(MT.Music_Album_Code,'') AS Music_Album_Code,MT.Music_Title_Name AS MusicTrack,ISNULL(MA.Music_Album_Name,'') AS Movie,ISNULL(G.Genres_Name,'') AS Genre,ISNULL(MT.Music_Tag,'') AS Tag,ISNULL(ML.MusicLabelName,'') AS MusicLabel
		--,STUFF((SELECT DISTINCT ', ' + CAST(T.Talent_Name AS VARCHAR(Max)) [text()]
		--	FROM Music_Title_Talent MTT
		--	INNER JOIN Talent T ON T.Talent_Code = MTT.Talent_Code
		--	Where MTT.Music_Title_Code = MT.Music_Title_Code
		--	FOR XML PATH(''), TYPE)
		--	.value('.','NVARCHAR(MAX)'),1,2,' '
		--) Talent
		,
		STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
			FROm #tempStuff ts
			Where ts.Music_Title_Code = MT.Music_Title_Code
			FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '
		)  
		AS StarCast,
		STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
			FROm #tempStuff2 ts
			Where ts.Music_Title_Code = MT.Music_Title_Code --AND ts.Role_Name = 'Singers'
			FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '
		) 
		 AS Singers,
		STUFF((SELECT DISTINCT ', ' + CAST(ts.Talent_Name AS VARCHAR(Max)) [text()]
			FROm #tempStuff3 ts
			Where ts.Music_Title_Code = MT.Music_Title_Code --AND ts.Role_Name = 'Music Composer'
			FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '
		) 
		AS MusicComposer, mlng.Language_Name AS MusicLanguage
		FROM Music_Title MT WITH(NOLOCK)
		LEFT JOIN Genres G WITH(NOLOCK) ON G.Genres_Code = MT.Genres_Code
		INNER JOIN Music_Title_Label MTL WITH(NOLOCK) ON MTL.Music_Title_Code = MT.Music_Title_Code AND MTL.Effective_To IS NULL
		INNER JOIN Music_Album MA WITH(NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
		--INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
		INNER JOIN #tempMusicLabel ML WITH(NOLOCK) ON ML.MusicLabelCode = MTL.Music_Label_Code
		INNER JOIN Music_Title_Language mtln ON mtln.Music_Title_Code = mt.Music_Title_Code
		INNER JOIN Music_Language mlng ON mlng.Music_Language_Code = mtln.Music_Language_Code
		WHERE (@MusicLabelCode = 0 OR ML.MusicLabelCode = @MusicLabelCode) AND ISNULL(MT.Music_Title_Name,'') like '%'+@MusicTrack+'%' AND ISNULL(MA.Music_Album_Name,'') like '%'+@MovieName+'%'
		AND ISNULL(MT.Music_Tag,'') like '%'+@Tag+'%' 
		AND (@GenreCode = 0 or mt.Genres_Code = @GenreCode)
		AND (@TalentName = '' OR MT.Music_Title_Code IN (
				SELECT Music_Title_Code FROM #tempA
			)
		)
		AND (@MusicLanguageCode = 0 or mtln.Music_Language_Code = @MusicLanguageCode)
		ORDER BY MT.Music_Title_Name	

		Print 'P4 ' + Convert(Varchar(100), Getdate(), 109)

		SELECT @RecordCount = COUNT(*) FROM #TempMusicTrackList
		print 'Record Count: ' +CAST(@RecordCount AS NVARCHAR)


		EXEC ('INSERT INTO #TempMusicTrackListFinal(Music_Title_Code, Music_Album_Code, MusicTrack, Movie , Genre, Tag, MusicLabel, StarCast, Singers, MusicComposer, MusicLanguage)
				Select Music_Title_Code,Music_Album_Code,MusicTrack,Movie,Genre,Tag,MusicLabel,ISNULL(StarCast,'''') AS StarCast,ISNULL(Singers,'''') AS Singers,ISNULL(MusicComposer,'''') AS MusicComposer, ISNULL(MusicLanguage,'''') AS MusicLanguage 
				from #TempMusicTrackList ORDER BY '+ @SortBy + ' '+ @Order)

		DELETE from  #TempMusicTrackListFinal
		WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

		SELECT Music_Title_Code, Music_Album_Code, MusicTrack, Movie , Genre, Tag, MusicLabel, StarCast, Singers, MusicComposer, MusicLanguage FROM #TempMusicTrackListFinal

		--DROP TABLE #tempA
	END

	IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
	IF OBJECT_ID('tempdb..#tempMusicLabel') IS NOT NULL DROP TABLE #tempMusicLabel
	IF OBJECT_ID('tempdb..#TempMusicTrackList') IS NOT NULL DROP TABLE #TempMusicTrackList
	IF OBJECT_ID('tempdb..#tempStuff') IS NOT NULL DROP TABLE #tempStuff
	IF OBJECT_ID('tempdb..#tempStuff2') IS NOT NULL DROP TABLE #tempStuff2
	IF OBJECT_ID('tempdb..#tempStuff3') IS NOT NULL DROP TABLE #tempStuff3
	IF OBJECT_ID('tempdb..#TempMusicTrackListFinal') IS NOT NULL DROP TABLE #TempMusicTrackListFinal

END
	
	--DECLARE @RecordCount INT
	--EXEC USPMHSearchMusicTrack 0,'','',0,'','',0,'Y',10,1,1,27808, @RecordCount out
	--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
GO
PRINT N'Creating [dbo].[USP_Music_Schedule_Process_Neo]...';


GO

CREATE PROC [dbo].[USP_Music_Schedule_Process_Neo]
(
	@MusicScheduleProcess MusicScheduleProcess READONLY,
	@CallFrom VARCHAR(10) = ''
)
AS
/*=======================================================================================================================================
Author:			ADESH AROTE
Create date:	03 MAY 2020
Description:	Music Schedule Process and Email Exception
Value for @CallFrom :
	'AM'	= Called from Assign Music Page
	'SR'	= Called from USP_Schedule_Revert_Count
	'AR'	= Called from USP_Music_Schedule_Exception_AutoResolver
	'SP'	= Called from USP_Schedule_Process
=======================================================================================================================================*/
BEGIN
	SET NOCOUNT ON
	--DECLARE @MusicScheduleProcess MusicScheduleProcess, @CallFrom VARCHAR(10) = 'SP'
	
	--@TitleCode BIGINT = 27521,
	--@EpisodeNo INT = 70, 
	--@BV_Schedule_Transaction_Code BIGINT = 3275689, 
	--@MusicScheduleTransactionCode BIGINT = 5409103,
	--
	--INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
	--SELECT DISTINCT BV_Schedule_Transaction_Code
	--FROM Title_Content tc
	--INNER JOIN (
	--	SELECT DISTINCT LTRIM(RTRIM([Title_Content_Code])) AS [Title_Content_Code] FROM DM_Content_Music WHERE DM_Master_Import_Code = 2603 AND Is_Ignore = 'N'
	--) AS dm ON tc.Title_Content_Code = dm.Title_Content_Code
	--INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
	--INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID


	DECLARE @stepNo INT = 1;
	PRINT 'Music Schedule Process Started - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		
	IF(OBJECT_ID('TEMPDB..#TempScheduleData') IS NOT NULL) DROP TABLE #TempScheduleData
	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransaction') IS NOT NULL) DROP TABLE #TempMusicScheduleTransaction
	IF(OBJECT_ID('TEMPDB..#AllMusicLabelDealData') IS NOT NULL) DROP TABLE #AllMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#CurrentMusicLabelDealData') IS NOT NULL) DROP TABLE #CurrentMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#ExistingException') IS NOT NULL) DROP TABLE #ExistingException
	IF(OBJECT_ID('TEMPDB..#tmpMDC') IS NOT NULL) DROP TABLE #tmpMDC

	CREATE TABLE #TempMusicScheduleTransaction
	(
		IntCode							INT IDENTITY(1,1),
		Title_Code						INT,
		Episode_No						INT,
		MusicScheduleTransactionCode	BIGINT, 
		BV_Schedule_Transaction_Code	BIGINT, 
		Schedule_Date					DATETIME, 
		Schedule_Item_Log_Time			VARCHAR(50), 
		Content_Music_Link_Code			BIGINT, 
		Music_Title_Code					BIGINT, 
		Channel_Code					BIGINT, 
		Music_Label_Code				BIGINT, 
		Is_Processed					CHAR(1) DEFAULT('N'),
			   
		Music_Deal_Code					INT, 
		lastMDCode						INT, 
		ErrorCode						INT, 
		isValid							CHAR(1) DEFAULT('Y'),
		isError							CHAR(1) DEFAULT('N'),
		AutoResolvedErrCodes			VARCHAR(MAX), 
		NewRaisedErrCodes				VARCHAR(MAX), 
		ShowLinked						CHAR(1) DEFAULT('Y'), 
		isApprovedDeal					CHAR(1) DEFAULT('Y'),

		RightRuleCode					INT,
		NoOfSongs						INT,
		isIgnore						CHAR(1) DEFAULT('N'),
		RunType							CHAR(1),
		ChannelType						CHAR(1),
		MinDateTime						DATETIME,
		MaxDateTime						DATETIME,
		CountSchedule					INT
	)

	--SELECT @RightRuleCode = 0, @NoOfSongs = 0,  @IsIgnore = 'N', @RunType = '', @ChannelType = ''

	CREATE TABLE #CurrentMusicLabelDealData
	(
		Music_Deal_Code			INT,
		Music_Label_Code		INT,
		Agreement_No			VARCHAR(50),
		Deal_Workflow_Status	VARCHAR(5),
		Deal_Version			INT,
		Rights_Start_Date		DATETIME,
		Rights_End_Date			DATETIME,
		Run_Type				CHAR(4),
		Right_Rule_Code			INT,
		Channel_Type			CHAR(1),
		Channel_Code			INT,
		No_Of_Songs				INT,
		Defined_Runs			INT,
		Scheduled_Runs			INT,
		Show_Linked				VARCHAR(1),
		Title_Code				INT,
		DealCreatedOn			DATETIME,
		Show_Linked_No			INT,
		Is_Active_Deal			VARCHAR(1)
	)

	CREATE TABLE #ExistingException
	(
		MusicScheduleTransactionCode	INT,
		Error_Code						INT,
		Error_Key						VARCHAR(10)
	)
	
	CREATE TABLE #TempScheduleData
	(
		BV_Schedule_Transaction_Code INT,
		Title_Code INT,
		Episode_No INT,
		Schedule_Date DATETIME,
		Schedule_Item_Log_Time VARCHAR(50),
		Channel_Code INT,
		Valid_Flag VARCHAR(3)
	)

	DECLARE @DefaultVersionCode INT = 1, @Users_Code INT --,  @Email_Config_Code INT
	SELECT TOP 1 @DefaultVersionCode = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'DefaultVersionCode'
	
	PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select Title_Code and Episode_No, If Parameter @BV_Schedule_Transaction_Code has value - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
	SET @stepNo += 1
		
	/* Revert Schedule*/
	IF(@CallFrom = 'SR')
	BEGIN
	
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete data from Music_Schedule_Exception table for Revert - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		DELETE MSE FROM Music_Schedule_Transaction MST
		INNER JOIN Music_Schedule_Exception MSE ON MST.Music_Schedule_Transaction_Code = MSE.Music_Schedule_Transaction_Code
		INNER JOIN @MusicScheduleProcess msp ON MST.BV_Schedule_Transaction_Code = msp.BV_Schedule_Transaction_Code
		--AND MST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code

		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(B) : Delete data from Music_Schedule_Transaction table for Revert - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		DELETE MST FROM Music_Schedule_Transaction MST
		INNER JOIN @MusicScheduleProcess msp ON MST.BV_Schedule_Transaction_Code = msp.BV_Schedule_Transaction_Code
		
		--------------- RECALCULATE SCHEDULE RUN ON DEAL AND CHANNEL LEVEL --- Need to implement
	END
	ELSE
	BEGIN
	
		/* Get Schedule Data for Title*/
		PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Get Schedule Data for Title - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		SET @stepNo += 1

		INSERT INTO #TempScheduleData(BV_Schedule_Transaction_Code, Title_Code, Episode_No, Schedule_Date,
									  Schedule_Item_Log_Time, Channel_Code, Valid_Flag)
		SELECT BST.BV_Schedule_Transaction_Code, TC.Title_Code, TC.Episode_No, CONVERT(DATETIME, BST.Schedule_Item_Log_Date, 121) AS Schedule_Date,
			   BST.Schedule_Item_Log_Time, BST.Channel_Code, CAST('' AS VARCHAR(3)) AS Valid_Flag
		FROM BV_Schedule_Transaction BST  WITH(NOLOCK)
		INNER JOIN Title_Content TC  WITH(NOLOCK) ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
		INNER JOIN @MusicScheduleProcess MSP ON ((TC.Title_Code = MSP.Title_Code AND TC.Episode_No = MSP.Episode_No) OR (BST.BV_Schedule_Transaction_Code = MSP.BV_Schedule_Transaction_Code))
	
	END

	IF EXISTS (SELECT TOP 1 * FROM #TempScheduleData)
	BEGIN
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Got Schedule Data - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		SET @stepNo += 1

		IF(@CallFrom = 'AR')
		BEGIN

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data from Music_Schedule_Transaction table and Insert in #TempMusicScheduleTransaction in case of Auto Resolve - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1

			INSERT INTO #TempMusicScheduleTransaction(Title_Code, Episode_No, MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT TSD.Title_Code, TSD.Episode_No, MST.Music_Schedule_Transaction_Code, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, MST.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MST.Music_Label_Code, 'N' AS Is_Processed
			FROM Music_Schedule_Transaction MST
			INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
			INNER JOIN #TempScheduleData TSD ON MST.BV_Schedule_Transaction_Code = TSD.BV_Schedule_Transaction_Code
			INNER JOIN @MusicScheduleProcess MSP ON MST.Music_Schedule_Transaction_Code = MSP.Music_Schedule_Transaction_Code 
			WHERE MSP.Music_Schedule_Transaction_Code IS NOT NULL

		END
		
		IF NOT EXISTS(SELECT TOP 1 * FROM @MusicScheduleProcess WHERE Music_Schedule_Transaction_Code IS NOT NULL)
		BEGIN
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for Music_Schedule_Transaction insertion - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
			
			INSERT INTO #TempMusicScheduleTransaction(Title_Code, Episode_No, MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT TSD.Title_Code, TSD.Episode_No, ISNULL(MST.Music_Schedule_Transaction_Code, 0) AS MusicScheduleTransactionCode, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, CML.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MTL.Music_Label_Code, 'N' AS Is_Processed
			FROM Title_Content TC
			INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
			INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code AND TCV.Version_Code = @DefaultVersionCode
			INNER JOIN #TempScheduleData TSD ON TSD.Title_Code = TC.Title_Code AND TSD.Episode_No =  TC.Episode_No
			INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = CML.Music_Title_Code 
			AND TSD.Schedule_Date BETWEEN MTL.Effective_From AND ISNULL(MTL.Effective_To, TSD.Schedule_Date)
			LEFT JOIN Music_Schedule_Transaction MST ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code AND TSD.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
			
				

		END

		/*
			GET Deal Data
			AS : All Show, AF : All Fiction, AN : All Non Fiction, AE : All Event, SP : Specific
		*/
		
		DECLARE @CurrentTitleDealType INT = 0, @DealType_Fiction INT = 0, @DealType_NonFiction INT = 0, @DealType_Event INT = 22
		SELECT TOP 1 @DealType_Fiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content'
		SELECT TOP 1 @DealType_NonFiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'
		SELECT TOP 1 @DealType_Event = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'
		--SELECT TOP 1 @CurrentTitleDealType = Deal_Type_Code FROM Title T WHERE T.Title_Code = @TitleCode

		PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for #AllMusicLabelDealData - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		SET @stepNo += 1

		SELECT DISTINCT TMST.Music_Label_Code, MD.Music_Deal_Code, MD.Agreement_No, MD.Deal_Workflow_Status,
		MD.Rights_Start_Date, MD.Rights_End_Date, MD.Run_Type,
		MD.Right_Rule_Code,
		MD.Channel_Type, MDC.Channel_Code, MD.No_Of_Songs,
		CASE WHEN MD.Channel_Type = 'S' THEN MD.No_Of_Songs ELSE MDC.Defined_Runs END AS Defined_Runs,
		MDC.Scheduled_Runs,
		CASE 
			WHEN MD.Link_Show_Type = 'AS' THEN 'Y'
			WHEN MD.Link_Show_Type = 'AF' AND t.Deal_Type_Code = @DealType_Fiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AN' AND t.Deal_Type_Code = @DealType_NonFiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AE' AND t.Deal_Type_Code = @DealType_Event THEN 'Y'
			WHEN MD.Link_Show_Type = 'SP' AND MDLS.Title_Code = TMST.Title_Code  THEN 'Y'
			ELSE 'N'
		END AS Show_Linked,
		CASE 
			WHEN MD.Link_Show_Type = 'AS' THEN 3
			WHEN MD.Link_Show_Type = 'AF' AND t.Deal_Type_Code = @DealType_Fiction THEN 2
			WHEN MD.Link_Show_Type = 'AN' AND t.Deal_Type_Code = @DealType_NonFiction THEN 2
			WHEN MD.Link_Show_Type = 'AE' AND t.Deal_Type_Code = @DealType_Event THEN 2
			WHEN MD.Link_Show_Type = 'SP' AND MDLS.Title_Code = TMST.Title_Code  THEN 1
			ELSE 4
		END AS Show_Linked_No, MDLS.Title_Code, MD.Inserted_On AS DealCreatedOn, 'N' AS [Is_Active_Deal], CAST(md.Version AS INT) Deal_Version
		INTO #AllMusicLabelDealData
		FROM #TempMusicScheduleTransaction TMST
		INNER JOIN Title t ON t.Title_Code = TMST.Title_Code 
		INNER JOIN Music_Deal MD ON MD.Music_Label_Code = TMST.Music_Label_Code
		INNER JOIN Music_Deal_Channel MDC ON MDC.Music_Deal_Code = MD.Music_Deal_Code
		LEFT JOIN Music_Deal_LinkShow MDLS ON MDLS.Music_Deal_Code = MD.Music_Deal_Code 
		
		IF(@CallFrom <> 'AR')
		BEGIN
			/* Delete the Data, If data already exist, which we are going to Insert */
			PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete the data from Music_Schedule_Exception, If data already exist, which we are going to Insert - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
			
			DELETE MSE FROM Music_Schedule_Exception MSE
			INNER JOIN #TempMusicScheduleTransaction TMST ON MSE.Music_Schedule_Transaction_Code = TMST.MusicScheduleTransactionCode

			/* Insert data in Music Schedule Transaction Table */
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Insert data into Music_Schedule_Transaction - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1

			INSERT INTO Music_Schedule_Transaction(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, Is_Processed, Is_Ignore)
			SELECT BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, Is_Processed, NULL AS IsIgnore
			FROM #TempMusicScheduleTransaction
			WHERE ISNULL(MusicScheduleTransactionCode, 0) = 0
			ORDER BY CAST(Schedule_Date + ' ' + Schedule_Item_Log_Time AS DATETIME)

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : UPDATE DATA OF MUSIC_SCHEDULE_TRANSACTION - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1

			UPDATE TMST SET TMST.MusicScheduleTransactionCode = MST.Music_Schedule_Transaction_Code 
			FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
			AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code AND TMST.Channel_Code = MST.Channel_Code 
			AND ( 
				(TMST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS = MST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS AND @CallFrom <> 'AR') OR @CallFrom = 'AR'
			)
			WHERE ISNULL(MusicScheduleTransactionCode, 0) = 0

		END
		
		IF EXISTS (SELECT TOP 1 * FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N')
		BEGIN

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : UPDATE SCHEDULE DATE AND CHANNEL IN #TempMusicScheduleTransaction TABLE - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
			
			UPDATE TMST SET TMST.Schedule_Date = BST.Schedule_Date, TMST.Channel_Code = BST.Channel_Code
			FROM #TempMusicScheduleTransaction TMST
			INNER JOIN #TempScheduleData BST ON BST.BV_Schedule_Transaction_Code = TMST.BV_Schedule_Transaction_Code

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' ERROR : MUSIC LABEL NOT FOUND - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
						
			BEGIN --------------- CHECKS FOR MUSIC LABEL NOT FOUND VALIDATION

				UPDATE #TempMusicScheduleTransaction SET isError = 'Y', isValid = 'N', NewRaisedErrCodes = ',MLBLNF' WHERE ISNULL(Music_Label_Code, 0) = 0

			END

			BEGIN --------------- CHECKS FOR MUSIC DEAL NOT FOUND VALIDATION ON THE BASIS OF MUSIC LABEL

				-------- CHECK for only valid deal on the basis of schedule date

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' POPULATE TABLE #CurrentMusicLabelDealData - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				TRUNCATE TABLE #CurrentMusicLabelDealData

				INSERT INTO #CurrentMusicLabelDealData(Music_Deal_Code, Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					Run_Type, Right_Rule_Code, Channel_Type, Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, 
					DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				)
				SELECT DISTINCT amdd.Music_Deal_Code, amdd.Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					   Run_Type, Right_Rule_Code, Channel_Type, amdd.Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, amdd.Title_Code, 
					   DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				FROM #AllMusicLabelDealData amdd
				INNER JOIN #TempMusicScheduleTransaction tsmt ON amdd.Music_Label_Code = tsmt.Music_Label_Code AND (amdd.Title_Code = tsmt.Title_Code OR amdd.Show_Linked = 'Y')
				WHERE ISNULL(amdd.Music_Deal_Code, 0) > 0 -- AND ISNULL(Music_Label_Code, 0) = @MusicLabelCode AND (ISNULL(Title_Code, 0) = @TitleCode OR Show_Linked = 'Y')

				INSERT INTO #CurrentMusicLabelDealData(Music_Deal_Code, Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					Run_Type, Right_Rule_Code, Channel_Type, Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, 
					DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				)
				SELECT DISTINCT Music_Deal_Code, amdd.Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					   Run_Type, Right_Rule_Code, Channel_Type, amdd.Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, amdd.Title_Code, 
					   DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				FROM #AllMusicLabelDealData amdd
				WHERE ISNULL(amdd.Music_Deal_Code, 0) > 0 
				AND amdd.Music_Label_Code IN (
					SELECT DISTINCT tsmt.Music_Label_Code FROM #TempMusicScheduleTransaction tsmt
				)
				AND amdd.Music_Label_Code NOT IN (
					SELECT amdd1.Music_Label_Code FROM #AllMusicLabelDealData amdd1 WHERE ISNULL(amdd1.Title_Code, 0) = ISNULL(amdd.Title_Code, 0)
				)

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATIOLN - DEAL NOT FOUND - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				UPDATE #TempMusicScheduleTransaction SET isError = 'Y', isValid = 'N', NewRaisedErrCodes = ',DNF'
				WHERE Music_Label_Code NOT IN (
					SELECT DISTINCT tsmt.Music_Label_Code FROM #AllMusicLabelDealData tsmt
				) AND isValid = 'Y'

				--UPDATE #TempMusicScheduleTransaction SET AutoResolvedErrCodes = ',MLBLNF' WHERE ISNULL(Music_Label_Code, 0) > 0

			END

			BEGIN --------------- IDENTIFY THE MUSIC DEAL

				--SELECT TOP 1 @MusicDealCode = Music_Deal_Code 
				
				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' IDENTIFY THE MUSIC DEAL - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				UPDATE tmst SET tmst.Music_Deal_Code = a.Music_Deal_Code
				FROM (
					SELECT ROW_NUMBER() OVER(PARTITION BY tmst1.IntCode, cml.Music_Label_Code, cml.Channel_Code--, Rights_Start_Date, Rights_End_Date
						ORDER BY cml.DealCreatedOn ASC, cml.Show_Linked_No ASC) AS RowNum, tmst1.IntCode, cml.Music_Deal_Code
					FROM #TempMusicScheduleTransaction tmst1
					INNER JOIN #CurrentMusicLabelDealData cml ON tmst1.Music_Label_Code = cml.Music_Label_Code --AND tmst1.Title_Code = cml.Title_Code 
																  AND cml.Channel_Code = tmst1.Channel_Code AND tmst1.Schedule_Date BETWEEN cml.Rights_Start_Date AND cml.Rights_End_Date
					WHERE cml.Show_Linked = 'Y' --(cml.Deal_Workflow_Status = 'A' OR cml.Deal_Version > 1 )AND 
				) AS a
				INNER JOIN #TempMusicScheduleTransaction tmst ON a.IntCode = tmst.IntCode AND a.RowNum = 1
				WHERE isValid = 'Y' AND isError = 'N'

			END

			BEGIN --------------- EXCEPTION  - MUSIC DEAL NOT APPROVE ONLY WHEN DEAL VERSION IS 1
	
				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - DEAL NOT APPROVE VALIDATION - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',DNA'
				FROM #TempMusicScheduleTransaction tmst
				INNER JOIN Music_Deal md ON tmst.Music_Deal_Code = md.Music_Deal_Code AND md.Deal_Workflow_Status <> 'A' AND CAST(md.Version AS INT) = 1

			END
			
			BEGIN --------------- EXCEPTION  - CHANNEL NOT FOUND IN MUSIC DEAL

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - CHANNEL NOT FOUND IN MUSIC DEAL - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				--SELECT *
				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',CNF'
				FROM #TempMusicScheduleTransaction tmst WHERE tmst.Music_Label_Code NOT IN (
					SELECT cml.Music_Label_Code FROM #AllMusicLabelDealData cml WHERE tmst.Channel_Code = cml.Channel_Code
				) AND isValid = 'Y' AND isError = 'N'

			END
			
			BEGIN --------------- EXCEPTION - SCHEDULE OUTSIDE RIGHTS PERIOD

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - SCHEDULE OUTSIDE RIGHTS PERIOD - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',IRP'
				FROM #TempMusicScheduleTransaction tmst WHERE tmst.Music_Label_Code NOT IN (
					SELECT cml.Music_Label_Code FROM #AllMusicLabelDealData cml WHERE tmst.Schedule_Date BETWEEN cml.Rights_Start_Date AND cml.Rights_End_Date
				) AND isValid = 'Y' AND isError = 'N'

			END
			
			BEGIN --------------- EXCEPTION - SHOW NOT LINK

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - SHOW NOT LINK - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',SNL'
				FROM #TempMusicScheduleTransaction tmst
				WHERE Music_Deal_Code IS NULL AND isValid = 'Y' AND isError = 'N'

			END

			BEGIN --------------- EXCEPTION - Music Track is Deactive

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - Music Track is Deactive - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',MTID'
				FROM #TempMusicScheduleTransaction tmst
				INNER JOIN Music_Title MT ON tmst.Music_Title_Code = MT.Music_Title_Code
				WHERE  isValid = 'Y' AND isError = 'N' AND MT.Is_Active = 'N'

			END

			BEGIN --------------- RIGHT RULE PROCESSING
			
				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' RIGHT RULE PROCESS FOR VALID ENTRIES - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET tmst.RightRuleCode = md.Right_Rule_Code, tmst.NoOfSongs = md.No_Of_Songs, tmst.RunType = md.Run_Type, tmst.ChannelType = md.Channel_Type
				FROM #TempMusicScheduleTransaction tmst
				INNER JOIN Music_Deal md ON tmst.Music_Deal_Code = md.Music_Deal_Code
				WHERE isValid = 'Y' AND isError = 'N'

				--SELECT 
				UPDATE TMST1 SET TMST1.MinDateTime = a.MinDate
				FROM (
					SELECT IntCode, 
						CASE 
							WHEN ISNULL(rr.IS_First_Air,0) > 0 THEN	MAX(CAST(TSD.Schedule_Date + ' ' + CAST(TSD.Schedule_Item_Log_Time AS VARCHAR(8)) AS DATETIME))
							ELSE MAX(CAST(TSD.Schedule_Date + ' ' + CAST(rr.Start_Time as VARCHAR(8)) AS DATETIME))
						END MinDate
					FROM #TempMusicScheduleTransaction TMST
					INNER JOIN #TempScheduleData TSD ON TSD.BV_Schedule_Transaction_Code = TMST.BV_Schedule_Transaction_Code
					INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
					WHERE isError = 'N' AND isValid = 'Y' AND TMST.RightRuleCode IS NOT NULL
					GROUP BY IntCode, rr.IS_First_Air
				) AS a 
				INNER JOIN #TempMusicScheduleTransaction TMST1 ON a.IntCode = TMST1.IntCode
				
				UPDATE TMST SET TMST.MaxDateTime = DATEADD(SECOND,-1,DATEADD(HOUR,ISNULL(rr.Duration_Of_Day,24), TMST.MinDateTime)) 
				FROM #TempMusicScheduleTransaction TMST
				INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
				WHERE isError = 'N' AND isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL

				--SELECT * FROM 
				UPDATE TMST1 SET TMST1.CountSchedule = a.ScheduleCount
				FROM (
					SELECT TMST.IntCode, COUNT(DISTINCT MST.Music_Schedule_Transaction_Code) ScheduleCount
					FROM Music_Schedule_Transaction MST WITH(NOLOCK)
					INNER JOIN Content_Music_Link CML WITH(NOLOCK) ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
					INNER JOIN BV_Schedule_Transaction BST WITH(NOLOCK) ON MST.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code 
					INNER JOIN #TempMusicScheduleTransaction TMST ON CML.Music_Title_Code = TMST.Music_Title_Code
						AND MST.Music_Label_Code = TMST.Music_Label_Code AND MST.Music_Deal_Code = TMST.Music_Deal_Code
						AND MST.Channel_Code = TMST.Channel_Code AND MST.Music_Schedule_Transaction_Code < TMST.MusicScheduleTransactionCode
						AND CAST(BST.Schedule_Item_Log_Date + ' ' + BST.Schedule_Item_Log_Time AS DATETIME) BETWEEN TMST.MinDateTime AND TMST.MaxDateTime
					WHERE TMST.isError = 'N' AND TMST.isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL
					GROUP BY TMST.IntCode
				) AS a 
				INNER JOIN #TempMusicScheduleTransaction TMST1 ON a.IntCode = TMST1.IntCode

				--SELECT * 
				UPDATE TMST SET TMST.isIgnore = 'Y'
				FROM #TempMusicScheduleTransaction TMST
				INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
				WHERE ((TMST.CountSchedule + 1) BETWEEN (rr.Play_Per_Day + 1) AND  (rr.No_Of_Repeat + rr.Play_Per_Day))
					  AND isError = 'N' AND isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL

				UPDATE TMST SET TMST.isValid = 'N', TMST.isError = 'Y', TMST.NewRaisedErrCodes = ISNULL(tmst.NewRaisedErrCodes, '') + ',EARR'
				FROM #TempMusicScheduleTransaction TMST
				INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
				WHERE ((TMST.CountSchedule + 1) > (rr.No_Of_Repeat + rr.Play_Per_Day))
					  AND isError = 'N' AND isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL

			END
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' UPDATE ISIGNORE AND MUSIC DEAL CODE - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE MST SET MST.Is_Ignore = TMST.isIgnore, MST.Music_Deal_Code = TMST.Music_Deal_Code
			FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON MST.Music_Schedule_Transaction_Code = TMST.MusicScheduleTransactionCode

			SELECT DISTINCT TMST.Music_Deal_Code, TMST.Channel_Code INTO #tmpMDC FROM #TempMusicScheduleTransaction TMST WHERE TMST.isValid = 'Y' AND TMST.isError = 'N'
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' UPDATE SCHEDULE RUNS IN MUSIC DEAL CHANNEL - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE mdc SET mdc.Scheduled_Runs = mtran.ScheduleCount
			FROM Music_Deal_Channel mdc
			INNER JOIN (
				SELECT MST.Music_Deal_Code, MST.Channel_Code, COUNT(Music_Schedule_Transaction_Code) ScheduleCount
				FROM Music_Schedule_Transaction MST
				INNER JOIN (
					SELECT DISTINCT TMST.Music_Deal_Code, TMST.Channel_Code FROM #tmpMDC TMST
				) AS a ON MST.Music_Deal_Code = a.Music_Deal_Code AND MST.Channel_Code = a.Channel_Code 
				WHERE MST.Is_Ignore = 'N'
				GROUP BY MST.Music_Deal_Code, MST.Channel_Code
			) mtran ON mdc.Music_Deal_Code = mtran.Music_Deal_Code AND mdc.Channel_Code = mtran.Channel_Code

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - EXCEEDS ALLOCATED RUNS - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE tmst SET tmst.isError = 'Y', tmst.isValid = 'N', tmst.NewRaisedErrCodes = ISNULL(tmst.NewRaisedErrCodes, '') + ',EAR'
			FROM (
				SELECT Music_Deal_Code, ISNULL(SUM(Scheduled_Runs), 0) ScheduleRuns
				FROM Music_Deal_Channel WHERE Music_Deal_Code IN (
					SELECT DISTINCT Music_Deal_Code FROM #tmpMDC
				) 
				GROUP BY Music_Deal_Code
			) AS tmp 
			INNER JOIN #TempMusicScheduleTransaction tmst ON tmp.Music_Deal_Code = tmst.Music_Deal_Code AND tmp.ScheduleRuns > tmst.NoOfSongs
			WHERE tmst.isValid = 'Y' AND tmst.isError = 'N' AND tmst.RunType = 'L'
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - EXCEEDS CHANNEL WISE ALLOCATED RUNS - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE tmst SET tmst.isError = 'Y', tmst.isValid = 'N', tmst.NewRaisedErrCodes = ISNULL(tmst.NewRaisedErrCodes, '') + ',ECAR'
			FROM (
				SELECT mdc.Music_Deal_Code, mdc.Channel_Code
				FROM Music_Deal_Channel mdc
				INNER JOIN #tmpMDC tmdc ON tmdc.Music_Deal_Code = mdc.Music_Deal_Code AND tmdc.Channel_Code = mdc.Channel_Code 
				WHERE ISNULL(mdc.Scheduled_Runs, 0) > ISNULL(mdc.Defined_Runs, 0)
			) AS tmp 
			INNER JOIN #TempMusicScheduleTransaction tmst ON tmp.Music_Deal_Code = tmst.Music_Deal_Code AND tmp.Channel_Code = tmst.Channel_Code
			WHERE tmst.RunType = 'L' AND tmst.ChannelType = 'C' AND tmst.isValid = 'Y' AND tmst.isError = 'N'
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' UPDATE EXCEPTIOLN, PROCESS AND MUSIC DEAL CODE FLAG - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE MST SET MST.Is_Exception = TMST.isError, MST.Music_Deal_Code = TMST.Music_Deal_Code, MST.Is_Processed = 'Y'
			FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON MST.Music_Schedule_Transaction_Code = TMST.MusicScheduleTransactionCode
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' INSERT MUSIC SCHEDULE TRANSACTION - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
	
			INSERT INTO Music_Schedule_Exception(Music_Schedule_Transaction_Code, Error_Code, [Status], Is_Mail_Sent)
			SELECT NRE.MusicScheduleTransactionCode, ECM.Error_Code, 'E', 'N' FROM Error_Code_Master ECM 
			INNER JOIN (
				SELECT tmst.MusicScheduleTransactionCode, number AS Error_Key FROM #TempMusicScheduleTransaction tmst
				CROSS APPLY fn_Split_withdelemiter(ISNULL(tmst.NewRaisedErrCodes, ''), ',') 
				WHERE RTRIM(LTRIM(number)) <> '' AND tmst.isValid = 'N' AND tmst.isError = 'Y'
			) AS NRE ON NRE.Error_Key = ECM.Upload_Error_Code
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' END - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			
		END
		ELSE
		BEGIN
			PRINT ' ERROR : Music Track has not assigned to Title  - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		END
	END
	ELSE
	BEGIN
		PRINT ' Did not get Schedule Data - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
	END
	PRINT 'Music Schedule Process Ended'
	PRINT '==============================================================================================================================================='	
	
	IF(OBJECT_ID('TEMPDB..#TempScheduleData') IS NOT NULL) DROP TABLE #TempScheduleData
	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransaction') IS NOT NULL) DROP TABLE #TempMusicScheduleTransaction
	IF(OBJECT_ID('TEMPDB..#AllMusicLabelDealData') IS NOT NULL) DROP TABLE #AllMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#CurrentMusicLabelDealData') IS NOT NULL) DROP TABLE #CurrentMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#ExistingException') IS NOT NULL) DROP TABLE #ExistingException
	IF(OBJECT_ID('TEMPDB..#tmpMDC') IS NOT NULL) DROP TABLE #tmpMDC

END
GO
PRINT N'Creating [dbo].[USPMHConsumptionRequestListDetail]...';


GO
CREATE PROCEDURE [dbo].[USPMHConsumptionRequestListDetail]
@RequestTypeCode INT,
@UsersCode INT,
@RecordFor VARCHAR(2), 
@RecordCount INT OUT,
@RequestID NVARCHAR(MAX),
@ChannelCode NVARCHAR(MAX),
@ShowCode NVARCHAR(MAX),
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50) = '',
@ToDate NVARCHAR(50)= '',
@SortBy NVARCHAR(50)= '',
@Order NVARCHAR(50)= ''
AS
BEGIN
SET FMTONLY OFF
	
	--BEGIN
	--DECLARE
	--@RequestTypeCode INT = 1,
	--@UsersCode INT = 293,
	--@RecordFor VARCHAR(2) = 'L', 
	--@RecordCount INT,-- OUT,
	--@RequestID NVARCHAR(MAX) = '',
	--@ChannelCode NVARCHAR(MAX) = '',
	--@ShowCode NVARCHAR(MAX) = '',
	--@StatusCode NVARCHAR(MAX) = '',
	--@FromDate NVARCHAR(50) = '',
	--@ToDate NVARCHAR(50)= '',
	--@SortBy NVARCHAR(50)= 'TelecastFrom',
	--@Order NVARCHAR(50)= 'DESC'

	IF(OBJECT_ID('TEMPDB..#TempConsumptionList') IS NOT NULL)
		DROP TABLE #TempConsumptionList
	IF(OBJECT_ID('TEMPDB..#tempApprovedCount') IS NOT NULL)
		DROP TABLE #tempApprovedCount
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal

	CREATE TABLE #TempConsumptionList(
	Row_No INT IDENTITY(1,1),
	RequestID NVARCHAR(50),
	MusicLabel NVARCHAR(MAX),
	RequestCode INT,
	Title_Name NVARCHAR(100),
	EpisodeFrom INT,
	EpisodeTo INT,
	TelecastFrom DATE,
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50)
	)

	CREATE TABLE #TempConsumptionListFinal(
	Row_No INT IDENTITY(1,1),
	RequestID NVARCHAR(50),
	MusicLabel NVARCHAR(MAX),
	RequestCode INT,
	Title_Name NVARCHAR(100),
	EpisodeFrom INT,
	EpisodeTo INT,
	TelecastFrom DATE,
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50),
	ApprovedRequest INT,
	Music_Title NVARCHAR(50),
	MusicMovieAlbum NVARCHAR(50),
	LabelName NVARCHAR(50),
	Remarks NVARCHAR(50)
	)
	
	CREATE TABLE #tempApprovedCount
	(
	MHRequestCode INT,
	Approved INT
	)


	IF(@FromDate = '' AND @ToDate <> '')
		SET @FromDate = '01-Jan-1970'
	ELSE IF(@ToDate = '' AND @FromDate <> '')
		Set @ToDate = '31-Dec-9999'
	ELSE IF(@FromDate = '' AND @ToDate = '')
		BEGIN
			SET @FromDate = '01-Jan-1970'
			Set @ToDate = '31-Dec-9999'
		END
	
	Print @FromDate
	Print @ToDate

	INSERT INTO #tempApprovedCount(Approved,MHRequestCode)
	Select COUNT(MHRequestCode) AS ApprovedCount,MHRequestCode FROM MHRequestDetails WITH (NOLOCK)
	WHERE IsApprove = 'Y' 
	GROUP BY MHRequestCode 

	INSERT INTO #TempConsumptionList(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate)
	SELECT MR.RequestID,
	ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS VARCHAR(Max))[text()]
			 FROM MHRequestDetails MRD
			 --INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
			 LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
			 LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			 Where MRD.MHRequestCode = MR.MHRequestCode
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) MusicLabel,
	ISNULL(MR.MHRequestCode,0) AS RequestCode,ISNULL(T.Title_Name,'') AS Title_Name ,ISNULL(MR.EpisodeFrom,'') AS EpisodeFrom,ISNULL(MR.EpisodeTo,'') AS EpisodeTo,CONVERT(DATE, ISNULL(MR.TelecastFrom,'')) AS TelecastFrom,ISNULL(MR.TelecastTo,'') AS TelecastTo,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS Login_Name,ISNULL(C.Channel_Name,'') AS ChannelName,
	ISNULL(MR.RequestedDate,'') AS RequestDate--, MRD.MusicTitleCode
	--INTO #tempRequest
	FROM MHRequest MR WITH(NOLOCK)
	LEFT JOIN Title T WITH(NOLOCK) ON T.Title_Code = MR.TitleCode
	LEFT JOIN MHRequestStatus MRS WITH(NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
	LEFT JOIN Users U WITH(NOLOCK) ON U.Users_Code = MR.UsersCode
	LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
	LEFT JOIN Channel C WITH(NOLOCK) ON C.Channel_Code = MR.ChannelCode
	WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode) AND
	(@RequestID = '' OR MR.RequestID like '%'+@RequestID+'%') AND (@ChannelCode = '' OR C.Channel_Code IN(select number from dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) AND (@ShowCode = '' OR T.Title_Code IN(select number from dbo.fn_Split_withdelemiter(@ShowCode,','))) 
	AND (@StatusCode = '' OR MRS.MHRequestStatusCode IN(select number from dbo.fn_Split_withdelemiter(@StatusCode,',')))
	AND
	--((REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	((CAST(MR.RequestedDate AS DATE) BETWEEN @FromDate AND @ToDate))
	GROUP BY MRD.MHRequestCode,MR.RequestID,T.Title_Name ,MR.EpisodeFrom,MR.EpisodeTo,MR.TelecastFrom,MR.TelecastTo,MRS.RequestStatusName,MRS.RequestStatusName,U.Login_Name,MR.RequestedDate,MR.MHRequestCode,C.Channel_Name

	SELECT @RecordCount = COUNT(*) FROM #TempConsumptionList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	BEGIN
		IF(@SortBy = 'RequestDate')
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest,Music_Title,MusicMovieAlbum,LabelName,Remarks )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest, ISNULL(MT.Music_Title_Name,'''') AS Music_Title ,MA.Music_Album_Name AS MusicMovieAlbum,ISNULL(ML.Music_Label_Name,'''') AS LabelName,ISNULL(MRD.Remarks,'''') AS Remarks  
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = tcl.RequestCode
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				ORDER BY CAST('+ @SortBy + ' AS DATETIME) ' + @Order)
			END
		ELSE
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest,Music_Title,MusicMovieAlbum,LabelName,Remarks )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest, ISNULL(MT.Music_Title_Name,'''') AS Music_Title ,MA.Music_Album_Name AS MusicMovieAlbum,ISNULL(ML.Music_Label_Name,'''') AS LabelName,ISNULL(MRD.Remarks,'''') AS Remarks 
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = tcl.RequestCode
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				ORDER BY '+ @SortBy + ' ' + @Order)
			END
	END

	SELECT RequestID,ChannelName,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,Music_Title,MusicMovieAlbum,LabelName,Status,Login_Name,RequestDate,Remarks FROM #TempConsumptionListFinal


	IF OBJECT_ID('tempdb..#TempConsumptionList') IS NOT NULL DROP TABLE #TempConsumptionList
	IF OBJECT_ID('tempdb..#tempRequest') IS NOT NULL DROP TABLE #tempRequest
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal
END

--DECLARE @RecordCount INT
--EXEC USPMHConsumptionRequestList 1,1287,'L','Y',10,1,@RecordCount OUTPUT,'','','','','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
GO
PRINT N'Altering [dbo].[USP_Content_Music_PIII]...';


GO
ALTER PROCEDURE [dbo].[USP_Content_Music_PIII]    
    @DM_Master_Import_Code Int    
AS  
--declare
--@dm_master_import_code int = 6281
BEGIN
	IF OBJECT_ID('tempdb..#Temp_Music_Track') IS NOT NULL DROP TABLE #Temp_Music_Track
	IF OBJECT_ID('tempdb..#TempContentStatusHistory') IS NOT NULL DROP TABLE #TempContentStatusHistory
	IF OBJECT_ID('tempdb..#TempSchedule') IS NOT NULL DROP TABLE #TempSchedule
	IF OBJECT_ID('tempdb..#CMLCode') IS NOT NULL DROP TABLE #CMLCode 

	Create Table #Temp_Music_Track    
	(   
		IntCode Int, 
		Music_Title_Code Int,    
		Music_Title_Name NVARCHAR(2000)      
	)
	
	CREATE TABLE #TempSchedule
	(
		BV_Schedule_Transaction_Code INT,
		Content_Music_Link_Code INT,
		Music_Title_Code INT,
		Title_Code INT,
		Program_Episode_Number VARCHAR(100),
		Channel_Code INT
	)

	CREATE TABLE #CMLCode
	(
		BV_Schedule_Transaction_Code INT,
		Content_Music_Link_Code INT
	)

	DECLARE @User_Code INT
    SELECT @User_Code =  Upoaded_By from DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code 
	
	INSERT INTO #Temp_Music_Track (IntCode, Music_Title_Code, Music_Title_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='CM' AND ISNULL(Master_Code, 0) > 0      
     UNION    
	SELECT 0 As IntCode,Music_Title_Code, Music_Title_Name FROM Music_Title    

	DECLARE @frameLimit INT = 0
	SELECT @frameLimit = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'FrameLimit'
	 PRINT 'Start Cursor'    
   --Cursor    
   
   BEGIN TRANSACTION
   BEGIN TRY

   DECLARE @TitleContentCode VARCHAR(100) = '',@IntCode VARCHAR(500), @TitleContentVersionCode VARCHAR(100) = '', @From VARCHAR(1000) = '', @From_Frame INT, @To VARCHAR(MAX) = '',     
   @To_Frame INT, @Duration VARCHAR(500) = '', @Duration_Frame INT, @Music_Track NVARCHAR(2000) = ''
	DECLARE  @hh int = 0, @mm int = 0, @ss int = 0, @totalSec_T bigINT, @totalSec_F BIGINT, @diffSec BIGINT, @Version_Name NVARCHAR(1000)
    DECLARE CUR_Content_Music CURSOR For    
    SELECT LTRIM(RTRIM([IntCode])),LTRIM(RTRIM([Title_Content_Code])),LTRIM(RTRIM([Title_Content_Version_Code])), LTRIM(RTRIM([From])),     
        LTRIM(RTRIM([From_Frame])), LTRIM(RTRIM([To])), LTRIM(RTRIM([To_Frame])),    
        LTRIM(RTRIM(ISNULL([Duration], ''))), LTRIM(RTRIM(ISNULL([Duration_Frame], ''))), LTRIM(RTRIM(ISNULL([Music_Track], ''))),LTRIM(RTRIM([Version_Name])) 
	    FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code  AND Is_Ignore = 'N'

	OPEN CUR_Content_Music    
	FETCH NEXT FROM CUR_Content_Music InTo @IntCode, @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration,  @Duration_Frame, @Music_Track, @Version_Name
	                                                  
	WHILE(@@FETCH_STATUS = 0)                                                  
	BEGIN                                  
    PRINT 'BEGIN Start'  
		DECLARE @Music_Title_Code INT = 0, @Version_Code INT;
	     SELECT Top 1 @Music_Title_Code = Music_Title_Code FROM #Temp_Music_Track WHERE LTRIM(RTRIM(Music_Title_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Track, '')))    collate SQL_Latin1_General_CP1_CI_AS Order by IntCode desc       
 	
		SELECT TOP 1 @Version_Code = Version_Code FROM [Version] WHERE Version_Name  collate SQL_Latin1_General_CP1_CI_AS = @Version_Name collate SQL_Latin1_General_CP1_CI_AS
		
		-- IF(@To_Frame < @From_Frame)
		-- BEGIN
		--	SET @diffSec = (@diffSec - 1)
		--	SET	@Duration_Frame = (@frameLimit - @From_Frame)
		--	SET @Duration_Frame = (@Duration_Frame + @To_Frame)
		-- END
		-- ELSE  IF(@To_Frame > @From_Frame)
		-- BEGIN
		--	SET @Duration_Frame = (@To_Frame - @From_Frame)
		--END
		--ELSE
		--BEGIN
		--	SET @Duration_Frame = @Duration_Frame	
		--END
		
		--IF(@Duration_Frame < 0)
		--	SET @Duration_Frame = 0

			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@To, ':') WHERE id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@To, ':') WHERE id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@To, ':') WHERE id = 3
			
			SET @totalSec_T = ((@hh * 3600) + (@mm * 60) + @ss)

			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@From, ':') WHERE id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@From, ':') WHERE id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@From, ':') WHERE id = 3
			
			SET @totalSec_F = ((@hh * 3600) + (@mm * 60) + @ss)

			SET @diffSec = (@totalSec_T - @totalSec_F)

			 IF(@To_Frame < @From_Frame)
			BEGIN
				SET @diffSec = (@diffSec - 1)
				SET	@Duration_Frame = (@frameLimit - @From_Frame)
				SET @Duration_Frame = (@Duration_Frame + @To_Frame)
			END
			ELSE  IF(@To_Frame > @From_Frame)
			BEGIN
				SET @Duration_Frame = (@To_Frame - @From_Frame)
			END
			ELSE
			BEGIN
				SET @Duration_Frame = @Duration_Frame	
			END
		
			IF(@Duration_Frame < 0)
				SET @Duration_Frame = 0

			IF(@diffSec > 0)
			BEGIN
			SELECT @hh = 0, @mm = 0, @ss = 0
				SET @ss= @diffSec
				IF(@ss >= 3600)
				BEGIN
					SET @hh = (@ss / 3600)
					set @ss = (@ss - (@hh * 3600))
				END

				IF(@ss >= 60)
				BEGIN
					SET @mm = (@ss / 60)
					set @ss= (@ss- (@mm * 60))
				END

				SET @duration = (RIGHT('00' + CAST(@hh AS VARCHAR), 2)  + ':' + RIGHT('00' + CAST(@mm AS VARCHAR), 2) + ':' + RIGHT('00' + CAST(@ss AS VARCHAR), 2))
			END
			ELSE
			BEGIN
			IF EXISTS (SELECT Duration FROM DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND IntCode = @IntCode AND (Duration != '' OR Duration != '00:00:00' ))
				BEgin
					select @duration =  Duration From DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND IntCode= @IntCode
				END
			END

			IF NOT EXISTS (SELECT * FROM Title_Content_Version WHERE Title_Content_Code = @TitleContentCode AND Version_Code = @Version_Code)
			BEGIN
				INSERT INTO Title_Content_Version (Title_Content_Code,Version_Code, Duration)
				SELECT Title_Content_Code,@Version_Code, Duration From Title_Content where Title_Content_Code = @TitleContentCode 
			END
				
		SELECT TOP 1 @TitleContentVersionCode = Title_Content_Version_Code FROM Title_Content_Version WHERE Title_Content_Code = @TitleContentCode AND Version_Code = @Version_Code
		IF EXISTS (SELECT Duration FROM DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND Title_Content_Code = @TitleContentCode AND IntCode = @IntCode AND (Duration= '' OR Duration = '00:00:00' ))
		BEgin
			
			update DM_Content_Music SET Duration = @Duration where DM_Master_Import_Code = @DM_Master_Import_Code AND Title_Content_Code = @TitleContentCode AND IntCode = @IntCode AND (Duration= '' OR Duration = '00:00:00' )
		END
		
	 INSERT INTO Content_Music_Link    
	 (    
		  Title_Content_Code, Title_Content_Version_Code, [From], From_Frame, [To], To_Frame, Duration, Duration_Frame, Music_Title_Code,
		  Inserted_On, Inserted_By, Last_UpDated_Time, Last_Action_By    
     )    
     VALUES    
     (    
		 @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration , @Duration_Frame, @Music_Title_Code
		 , GETDATE(), @User_Code, GETDATE(), @User_Code
     )    
	
	
	 UPDATE DM_Content_Music SET Record_Status = 'C'  WHERE Title_Content_Code = @TitleContentCode AND DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
     PRINT  'UPDATE DM_Content_Music '       
     FETCH NEXT FROM CUR_Content_Music InTo @IntCode, @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration,  @Duration_Frame, @Music_Track  , @Version_Name  
	END   
       
    CLOSE CUR_Content_Music    
    Deallocate CUR_Content_Music   
	
	BEGIN -------------- MUSIC SCHEDULE EXECUTE ---------

			INSERT INTO #TempSchedule(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Title_Code, Program_Episode_Number, Channel_Code, Music_Title_Code)
			SELECT DISTINCT BV_Schedule_Transaction_Code, cml.Content_Music_Link_Code, tc.Title_Code, bst.Program_Episode_Number AS Program_Episode_Number, Channel_Code, Music_Title_Code
			FROM Title_Content tc
			INNER JOIN (
				SELECT DISTINCT LTRIM(RTRIM([Title_Content_Code])) AS [Title_Content_Code] FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
			) AS dm ON tc.Title_Content_Code = dm.Title_Content_Code
			INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
			INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID

			INSERT INTO #CMLCode(Content_Music_Link_Code, BV_Schedule_Transaction_Code)
			SELECT DISTINCT mct.Content_Music_Link_Code, mct.BV_Schedule_Transaction_Code FROM Music_Schedule_Transaction mct
			INNER JOIN (SELECT DISTINCT BV_Schedule_Transaction_Code FROM #TempSchedule) sch ON mct.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code

			INSERT INTO Music_Schedule_Transaction(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Deal_Code, Channel_Code, Music_Label_Code, Is_Exception, Is_Processed)
			SELECT DISTINCT sch.BV_Schedule_Transaction_Code, sch.Content_Music_Link_Code, 0 Music_Deal_Code, sch.Channel_Code, mtl.Music_Label_Code, 'N', 'N'
			FROM #TempSchedule sch
			INNER JOIN VW_Music_Track_Label mtl ON mtl.Music_Title_Code = sch.Music_Title_Code AND GETDATE() > mtl.Effective_From
			WHERE sch.Content_Music_Link_Code NOT IN (
				SELECT cml.Content_Music_Link_Code FROM #CMLCode cml WHERE cml.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code
			)

			DECLARE @MusicScheduleProcess MusicScheduleProcess

			WHILE ((
				SELECT COUNT(*) FROM Music_Schedule_Transaction mst 
				INNER JOIN BV_Schedule_Transaction bv ON mst.BV_Schedule_Transaction_Code = bv.BV_Schedule_Transaction_Code 
				WHERE Is_Processed = 'N'
				) > 0
			)
			BEGIN

				INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
				SELECT DISTINCT TOP 1000 bv.BV_Schedule_Transaction_Code
				FROM Music_Schedule_Transaction mst 
				INNER JOIN BV_Schedule_Transaction bv ON mst.BV_Schedule_Transaction_Code = bv.BV_Schedule_Transaction_Code
				WHERE mst.Is_Processed = 'N'

				EXEC [dbo].[USP_Music_Schedule_Process_Neo] @MusicScheduleProcess, 'SP'

				DELETE FROM @MusicScheduleProcess

			END

		END
    --IF EXISTS(SELECT TOP 1 Record_Status='C' FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code)    
    -- BEGIN    
	 	SELECT Title_Content_Code, COUNT(*) AS RecordCount INTO #TempContentStatusHistory FROM (
				SELECT DISTINCT * FROM DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
			) AS TMP
			GROUP BY Title_Content_Code

		INSERT INTO Content_Status_History(Title_Content_Code, User_Code, User_Action, Record_Count, Created_On)
		SELECT Title_Content_Code, @User_Code, 'B', RecordCount, GETDATE() FROM #TempContentStatusHistory

     UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code    
    --END
	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		UPDATE DM_Master_Import SET Status = 'T' where DM_Master_Import_Code = @DM_Master_Import_Code    
	END CATCH

	IF OBJECT_ID('tempdb..#Temp_Music_Track') IS NOT NULL DROP TABLE #Temp_Music_Track
	IF OBJECT_ID('tempdb..#TempContentStatusHistory') IS NOT NULL DROP TABLE #TempContentStatusHistory
	IF OBJECT_ID('tempdb..#TempSchedule') IS NOT NULL DROP TABLE #TempSchedule
	IF OBJECT_ID('tempdb..#CMLCode') IS NOT NULL DROP TABLE #CMLCode
END
GO
PRINT N'Altering [dbo].[usp_Schedule_Execute_Package_FolderWise]...';


GO
ALTER PROCEDURE [dbo].[usp_Schedule_Execute_Package_FolderWise]
(
	@UserCode VARCHAR(10) = NULL
)
AS      
BEGIN      
-- =============================================
/*
Note:- System Configuration for first time to execute SSIS Package
		on SQL Server.
	---- To allow advanced options to be changed.      
	--EXEC sp_configure 'show advanced options', 1      
	--GO      
	---- To update the currently configured value for advanced options.      
	--RECONFIGURE      
	--GO      
	---- To enable the feature.      
	--EXEC sp_configure 'xp_cmdshell', 1      
	--GO      
	---- To update the currently configured value for this feature.      
	--RECONFIGURE      
	--GO
*/      

/*
------------- Package Execution Status Code-------------
--http://www.bidn.com/blogs/BradSchacht/ssis/941/capture-ssis-package-execution-status
0  The package executed successfully.
1  The package failed.
3  The package was canceled by the user.
4  The utility was unable to locate the requested package. The package could not be found.
5  The utility was unable to load the requested package. The package could not be loaded.
6  The utility encountered an internal error of syntactic or semantic errors in the command line.
*/

/*
Steps:-
	1.0 To execute the Schedule SSIS Package from stored procedure through Auto Scheduler.
*/
-- =============================================
    	
		IF (@UserCode  IS NULL)
		SET @UserCode = 0
	      
		DECLARE @cmd    VARCHAR(2000)      
		DECLARE @PackagePath VARCHAR(2000)
		DECLARE @NotSuccessFilePath VARCHAR(8000);	SET @NotSuccessFilePath = ''
		DECLARE @SuccessFilePath VARCHAR(8000);	SET @SuccessFilePath = ''
		DECLARE @ChannelCode_Cr VARCHAR(20) 
		DECLARE @FilePath_Cr VARCHAR(8000) 
		
		DECLARE Cur_Channel CURSOR       
		FOR   
		SELECT Channel_code, Schedule_Source_FilePath_Pkg FROM Channel where ISNULL(isUseForAsRun,'N') = 'Y' order by Order_For_schedule 

		OPEN Cur_Channel  
		FETCH NEXT FROM Cur_Channel INTO @ChannelCode_Cr, @FilePath_Cr
		WHILE @@FETCH_STATUS<>-1 
		BEGIN                                              
			IF(@@FETCH_STATUS<>-2)                                              
			BEGIN
				SET @SuccessFilePath = @FilePath_Cr + '\Success'
				SET @NotSuccessFilePath = @FilePath_Cr + '\NotSuccess'			
				
				SELECT @PackagePath =     parameter_value FROM system_parameter_new WHERE parameter_name = 'BV_Schedule_Pkg_FolderWise'
				--cd "C:\Program Files\Microsoft SQL Server\100\DTS\Binn\" DTEXEC.exe /F "E:\UTOAMS_Schedule_AsRun\UTOAMS_SSIS_Packages\BV_Schedule_Pkg_FolderWise_neo.dtsx" /De prathesh


				
				PRINT  @PackagePath
				

				--Pass a parameter to SSIS package
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::UserCode].Properties[Value]";' + @UserCode + '"' 
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::InputFile].Properties[Value]";' + @FilePath_Cr + '"' 
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::ChannelCode].Properties[Value]";' + @ChannelCode_Cr + '"' 
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::SuccessFilePath].Properties[Value]";' + @SuccessFilePath + '"'
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::NotSucessFilePath].Properties[Value]";' + @NotSuccessFilePath + '"'
				
				--End Pass a parameter to SSIS package
				
				PRINT  @PackagePath 
				PRINT  @ChannelCode_Cr 
				SET @cmd = @PackagePath      
				 
				
				EXEC MASTER..xp_cmdshell @cmd
				
				------------EXEC MASTER ..xp_cmdshell 	'dtexec /F "C:\inetpub\wwwroot\UTO_AMS_VIACOM_Dada\Package\BV_Schedule_Pkg_FolderWise.dtsx" /De prathesh'
			END
			FETCH NEXT FROM Cur_Channel INTO @ChannelCode_Cr, @FilePath_Cr
		END                                           
		CLOSE Cur_Channel                                               
		DEALLOCATE Cur_Channel   
		
		BEGIN --------------------- MUSIC SCHEDULE PROCESS START

			CREATE TABLE #DELMusicSchCodes
			(
				Music_Schedule_Transaction_Code INT,	
			)

			CREATE TABLE #TempSchedule
			(
				BV_Schedule_Transaction_Code INT,
				Content_Music_Link_Code INT,
				Music_Title_Code INT,
				Title_Code INT,
				Program_Episode_Number VARCHAR(100),
				Channel_Code INT
			)

			CREATE TABLE #CMLCode
			(
				BV_Schedule_Transaction_Code INT,
				Content_Music_Link_Code INT
			)
			
			CREATE TABLE #ProcessingBVSchCodes
			(
				BV_Schedule_Transaction_Code INT,	
			)

			INSERT INTO #DELMusicSchCodes(Music_Schedule_Transaction_Code)
			SELECT Music_Schedule_Transaction_Code FROM Music_Schedule_Transaction WHERE BV_Schedule_Transaction_Code NOT IN (
				SELECT BV_Schedule_Transaction_Code FROM BV_Schedule_Transaction
			)

			DELETE FROM Music_Schedule_Exception WHERE Music_Schedule_Transaction_Code IN (
				SELECT Music_Schedule_Transaction_Code FROM #DELMusicSchCodes
			)
	
			DELETE FROM Music_Schedule_Transaction WHERE Music_Schedule_Transaction_Code IN (
				SELECT Music_Schedule_Transaction_Code FROM #DELMusicSchCodes
			)

			INSERT INTO #TempSchedule(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Title_Code, Program_Episode_Number, Channel_Code, Music_Title_Code)
			SELECT DISTINCT BV_Schedule_Transaction_Code, cml.Content_Music_Link_Code, tc.Title_Code, bst.Program_Episode_Number AS Program_Episode_Number, Channel_Code, Music_Title_Code
			FROM Title_Content tc
			INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
			INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID
			--WHERE tc.Title_Code = 27522

			INSERT INTO #CMLCode(Content_Music_Link_Code, BV_Schedule_Transaction_Code)
			SELECT DISTINCT mct.Content_Music_Link_Code, mct.BV_Schedule_Transaction_Code FROM Music_Schedule_Transaction mct
			INNER JOIN (SELECT DISTINCT BV_Schedule_Transaction_Code FROM #TempSchedule) sch ON mct.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code

			INSERT INTO #ProcessingBVSchCodes(BV_Schedule_Transaction_Code)
			SELECT DISTINCT sch.BV_Schedule_Transaction_Code
			FROM #TempSchedule sch
			INNER JOIN VW_Music_Track_Label mtl ON mtl.Music_Title_Code = sch.Music_Title_Code AND GETDATE() > mtl.Effective_From
			WHERE sch.Content_Music_Link_Code NOT IN (
				SELECT cml.Content_Music_Link_Code FROM #CMLCode cml WHERE cml.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code
			)

			
			DECLARE @MusicScheduleProcess MusicScheduleProcess

			WHILE ((SELECT COUNT(*) FROM #ProcessingBVSchCodes) > 0)
			BEGIN

				INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
				SELECT DISTINCT TOP 1000 BV_Schedule_Transaction_Code FROM #ProcessingBVSchCodes

				EXEC [dbo].[USP_Music_Schedule_Process_Neo] @MusicScheduleProcess, 'SP'

				DELETE FROM #ProcessingBVSchCodes WHERE BV_Schedule_Transaction_Code IN (
					SELECT BV_Schedule_Transaction_Code FROM @MusicScheduleProcess
				)

				DELETE FROM @MusicScheduleProcess

			END

			--DECLARE @BV_Schedule_Transaction_Code INT = 0

			--DECLARE CUR_BVMusicProcess CURSOR FOR SELECT BV_Schedule_Transaction_Code FROM #ProcessingBVSchCodes
			--OPEN CUR_BVMusicProcess  
			--FETCH NEXT FROM CUR_BVMusicProcess INTO @BV_Schedule_Transaction_Code
			--WHILE @@FETCH_STATUS<>-1 
			--BEGIN                                              
			--	IF(@@FETCH_STATUS<>-2)                                              
			--	BEGIN

			--		INSERT INTO MusicScheduleLog VALUES(@BV_Schedule_Transaction_Code, GETDATE())

			--		PRINT 'START USP_Music_Schedule_Process'

			--		EXEC USP_Music_Schedule_Process
			--		@TitleCode = 0, 
			--		@EpisodeNo = 0, 
			--		@BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code, 
			--		@MusicScheduleTransactionCode = 0,
			--		@CallFrom= 'SP'

			--		PRINT 'END USP_Music_Schedule_Process'
		
			--	END
			--	FETCH NEXT FROM CUR_BVMusicProcess INTO @BV_Schedule_Transaction_Code
			--END                                           
			--CLOSE CUR_BVMusicProcess                                               
			--DEALLOCATE CUR_BVMusicProcess  
			
			IF(OBJECT_ID('TEMPDB..#DELMusicSchCodes') IS NOT NULL) DROP TABLE #DELMusicSchCodes
			IF(OBJECT_ID('TEMPDB..#TempSchedule') IS NOT NULL) DROP TABLE #TempSchedule
			IF(OBJECT_ID('TEMPDB..#CMLCode') IS NOT NULL) DROP TABLE #CMLCode
			IF(OBJECT_ID('TEMPDB..#ProcessingBVSchCodes') IS NOT NULL) DROP TABLE #ProcessingBVSchCodes

		END

		if(  (select isnull(Parameter_Value,'N') from System_Parameter_New where Parameter_Name ='IS_Schedule_Mail_Channelwise')  = 'N' )
		BEGIN
			EXEC usp_Schedule_SendException_Userwise_Email
		END

END            
/*
EXEC xp_cmdshell
Exec [usp_Schedule_Execute_Package_FolderWise] 143

*/


--cd "C:\Program Files\Microsoft SQL Server\100\DTS\Binn\" DTEXEC.exe /F "E:\UTOAMS_Schedule_AsRun\UTOAMS_SSIS_Packages\BV_Schedule_Pkg_FolderWise_neo.dtsx" /De prathesh
GO
PRINT N'Refreshing [dbo].[USPMHAutoApproveUsageRequest]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPMHAutoApproveUsageRequest]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Music_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Music_Schedule]';


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b0e704aa-cd07-4ee2-a6e1-345beda02fb5')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b0e704aa-cd07-4ee2-a6e1-345beda02fb5')

GO

GO
PRINT N'Update complete.';


GO


/****** Object:  Table [dbo].[DM_Title_Import_Utility]    Script Date: 16-01-2021 19:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DM_Title_Import_Utility](
	[DM_Title_Import_Utility_Code] [int] IDENTITY(1,1) NOT NULL,
	[Display_Name] [nvarchar](max) NULL,
	[Order_No] [int] NULL,
	[Target_Table] [nvarchar](max) NULL,
	[Target_Column] [nvarchar](max) NULL,
	[Colum_Type] [nvarchar](max) NULL,
	[Is_Multiple] [char](1) NULL,
	[Reference_Table] [nvarchar](max) NULL,
	[Reference_Text_Field] [nvarchar](max) NULL,
	[Reference_Value_Field] [nvarchar](max) NULL,
	[Reference_Whr_Criteria] [nvarchar](max) NULL,
	[Is_Active] [char](1) NULL,
	[validation] [nvarchar](max) NULL,
	[Is_Allowed_For_Resolve_Conflict] [char](1) NULL,
	[ShortName] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DM_Title_Import_Utility_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--FOR OBJECTION Type

CREATE TABLE Objection_Type(
Objection_Type_Code INT IDENTITY(1,1) PRIMARY KEY,
Objection_Type_Name VARCHAR(MAX),
Is_Active CHAR(1),
Inserted_On DATETIME,
Inserted_By int,
Last_Updated_Time Datetime,
Last_Action_By int
)