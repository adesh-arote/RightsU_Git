CREATE PROCEDURE [dbo].[USP_Import_SubDeal]  
(  
 @UserCode INT  
)  
AS  
-- =============================================  
-- Author:  Akshay Rane  
-- Create date: 24 July 2017  
-- =============================================  
BEGIN  
 SET NOCOUNT ON  
 --I- Insert Row  
 --W- Working In Progress  
 --E- Error In row  
 --R- Rights Duplication Validate  
 --D- Done whole process  
 --p- Process  
  
 IF(OBJECT_ID('TEMPDB..#TempImportSubDeal') IS NOT NULL)  
  DROP TABLE #TempImportSubDeal  
  
 IF(OBJECT_ID('TEMPDB..#Temp_Talent') IS NOT NULL)  
  DROP TABLE #Temp_Talent  
  
 IF(OBJECT_ID('TEMPDB..#Temp_Title_Talent') IS NOT NULL)  
  DROP TABLE #Temp_Title_Talent  
    
 IF(OBJECT_ID('TEMPDB..#TempErrorDetails') IS NOT NULL)  
  DROP TABLE #TempErrorDetails  
  
 IF(OBJECT_ID('TEMPDB..#Temp_Test_Talent') IS NOT NULL)  
  DROP TABLE #Temp_Test_Talent  
    
 IF(OBJECT_ID('TEMPDB..#temp_Talent_Name') IS NOT NULL)  
  DROP TABLE #temp_Talent_Name  
  
 IF(OBJECT_ID('TEMPDB..#TempYearOfDef') IS NOT NULL)  
 DROP TABLE #TempYearOfDef  
  
 CREATE TABLE #TempErrorDetails  
 (  
  [RowNo]     INT IDENTITY(1,1),  
  [DealDesc]              NVARCHAR (MAX) NULL,  
  [AgreementDate]         DATETIME       NULL,  
  [ModeOfAcquisition]     NVARCHAR (100) NULL,  
  [MasterDealAgreementNo] VARCHAR  (20)  NULL,  
  [MasterDealTitle]       NVARCHAR (MAX) NULL,  
  [YearOfDefinition]      CHAR  (2)   NULL,  
  [DealFor]               NVARCHAR (500) NULL,  
  [BusinessUnit]          NVARCHAR (500) NULL,  
  [Talent]                NVARCHAR (MAX) NULL,  
  [Remarks]               NVARCHAR (MAX) NULL,  
  [Error_Details]         NVARCHAR (MAX) NULL  
 )  
  
 CREATE TABLE #TempYearOfDef(YearofDef VARCHAR(50))  
 insert into #TempYearOfDef(YearofDef)   
 select ('DY')  
 UNION  select ('CY')  
 UNION  select ('FY')  
  
 SELECT ROW_NUMBER() OVER (ORDER BY [MasterDealAgreementNo]) AS RowNo, [ImportSubDeal_Code],  [DealDesc], [AgreementDate], [ModeOfAcquisition], [MasterDealAgreementNo],  
 [MasterDealTitle], [YearOfDefinition], [DealFor], [BusinessUnit],[Talent],[Remarks], [IsProcessed]   
 INTO #TempImportSubDeal   
 FROM  ImportSubDeal  
 WHERE  [IsProcessed] = 'N'  
  
 DECLARE @RowNo INT = 0, @RowCounter INT = 0 ,@Current_Status CHAR(1) = '', @YearOfDefCount INT = 0  
 SELECT TOP 1 @RowNo = RowNo FROM #TempImportSubDeal WHERE IsProcessed = 'N'  
  
 WHILE(@RowNo > 0)  
  BEGIN  
    
   IF(OBJECT_ID('TEMPDB..#Temp_Talent') IS NOT NULL)  
    DROP TABLE #Temp_Talent  
  
   IF(OBJECT_ID('TEMPDB..#Temp_Test_Talent') IS NOT NULL)  
    DROP TABLE #Temp_Test_Talent  
  
   IF(OBJECT_ID('TEMPDB..#temp_Talent_Name') IS NOT NULL)  
    DROP TABLE #temp_Talent_Name  
  
   SET @RowCounter =(@RowCounter + 1)  
  
   DECLARE @isErrorInRow CHAR(1) = 'N' ,  @errorMessage NVARCHAR(MAX) = ''  
  
   DECLARE @ImportSubDeal_Code INT = 0, @Deal_Type_Code_Sub_Deal INT = 0, @Deal_Type_Name VARCHAR(MAX) = '',  @Talent_Name NVARCHAR(MAX) = '',  
   @Remarks NVARCHAR(MAX) = '',@YearOfDefinition CHAR(2) = '', @DealDesc NVARCHAR(MAX) = '', @AgreementDate DATETIME = NULL,   
   @MasterDealAgreementNo VARCHAR(20) = '', @MasterDealTitle NVARCHAR(MAX) = '', @ModeOfAcquisition  NVARCHAR (100) = '',  
   @BusinessUnit  NVARCHAR (500) = '' , @Acq_Deal_Code INT = 0 , @Title_Name NVARCHAR(MAX) = '', @Business_Unit_Code INT = 0 , @RoleCode INT = 0,  
   @MasterDealTitleCode INT = 0,@Master_Deal_Movie_Code_ToLink INT = 0  
    
   DECLARE @Title_Code INT = 0 , @Invalid_Talent_name NVARCHAR(MAX) = ''  
  
   DECLARE @Acq_Deal_Code_Sub_Deal INT = 0 ,@Agreement_No_Sub_Deal VARCHAR(200) = '' , @Count_Null INT = 0  
  
   SELECT @ImportSubDeal_Code = ImportSubDeal_Code, @Deal_Type_Name = DealFor, @Talent_Name = Talent,  @Remarks = Remarks, @YearOfDefinition = YearOfDefinition, @DealDesc = DealDesc, @AgreementDate = AgreementDate, @MasterDealAgreementNo = MasterDealAgreementNo , @MasterDealTitle = MasterDealTitle ,@ModeOfAcquisition = ModeOfAcquisition,@BusinessUnit = BusinessUnit  
   FROM #TempImportSubDeal WHERE IsProcessed = 'N' AND RowNo = @RowNo  
  
   PRINT 'Insert all talnet name in temp table'  
  
   SELECT id AS id,LTRIM(RTRIM(number)) as number INTO #temp_Talent_Name FROM fn_Split_withdelemiter(@Talent_Name, ',')  
  
  
   --Status to 'W'  
   UPDATE ImportSubDeal  SET IsProcessed = 'W' WHERE ImportSubDeal_Code = @ImportSubDeal_Code  
  
   PRINT 'Validation for any columns is blank or not except Remarks'  
  
   SELECT  @Count_Null = COUNT(*) FROM #TempImportSubDeal WHERE  
   (ISNULL(DealDesc,'') = '' OR  
   ISNULL(YearOfDefinition,'') = '' OR  
   ISNULL(ModeOfAcquisition,'') = '' OR  
   ISNULL(MasterDealAgreementNo,'') = '' OR  
   ISNULL(MasterDealTitle,'') = '' OR  
   ISNULL(DealFor,'') = '' OR  
   ISNULL(BusinessUnit,'') = '' OR  
   ISNULL(Talent,'') = '') AND  
   IsProcessed = 'N' AND RowNo = @RowNo  
   IF(@Count_Null <> 0)  
   BEGIN  
    SET  @errorMessage = @errorMessage + 'Some of the columns are blank or null ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
     
   PRINT 'Validation for Role_Name'  
   SELECT @RoleCode = ISNULL(Role_Code,0) FROM Role where Role_Name = @ModeOfAcquisition AND Role_Type = 'A'  
   IF (@RoleCode = 0)  
   BEGIN  
    SET  @errorMessage = @errorMessage + 'Mode of Acquisition does not exist ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
  
   PRINT 'Validation for Business_Unit_Name'  
   SELECT @Business_Unit_Code = ISNULL(Business_Unit_Code,0) FROM Business_Unit WHERE Business_Unit_Name = @BusinessUnit AND Is_Active = 'Y'  
   IF (@Business_Unit_Code = 0)  
   BEGIN  
    SET @errorMessage =  @errorMessage + 'Business Unit Name does not match ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
  
   PRINT 'Validation for Deal_Type_Name SUB DEAL'  
   SELECT @Deal_Type_Code_Sub_Deal =  ISNULL(Deal_Type_Code,0) FROM Deal_Type WHERE Deal_Type_Name = @Deal_Type_Name AND Is_Active = 'Y'  
   IF (@Deal_Type_Code_Sub_Deal = 0)  
   BEGIN  
    SET @errorMessage = @errorMessage + 'Deal type name does not match ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
  
   PRINT 'Validation for title name if exist in title table or not'  
   SELECT @MasterDealTitleCode = ISNULL(Title_Code,0) FROM Title where Title_name = @MasterDealTitle AND Is_Active = 'Y'  
   IF (@MasterDealTitleCode = 0)  
   BEGIN  
    SET @errorMessage = @errorMessage + 'Title name does not exist in title table  ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
  
   PRINT 'Validation for Agreement_No'  
   IF NOT EXISTS (SELECT Agreement_No FROM Acq_Deal WHERE Agreement_No = @MasterDealAgreementNo AND Is_Active = 'Y' AND Business_Unit_Code = @Business_Unit_Code)  
   BEGIN  
    SET @errorMessage = @errorMessage + 'Master Deal Agreement No doesnot exist ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
   ELSE  
   BEGIN  
    Print 'get Acq_Deal_Code related to the particular agreement no'  
    SELECT  @Acq_Deal_Code = Acq_Deal_Code  
    FROM Acq_Deal                  
    WHERE Agreement_No = @MasterDealAgreementNo AND Is_Active = 'Y'     
                       
    SELECT @Title_Code = T.Title_Code, @Master_Deal_Movie_Code_ToLink = ADM.Acq_Deal_Movie_Code , @Title_Name = T.Title_Name  
    FROM Acq_Deal_Movie ADM INNER JOIN Title T on T.Title_Code = ADM.Title_Code   
    WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code AND T.Title_Name = @MasterDealTitle   
      
    PRINT 'Validation for Title whether it exist or not to a particular agreement no or deal'  
    IF (@Title_Name <> @MasterDealTitle)  
    BEGIN  
     SET @errorMessage = @errorMessage + 'Title Name doesnot match in particular Master Deal ~ '  
     SET  @isErrorInRow = 'Y'  
    END                   
   END                     
     
   PRINT 'Validation for YearOfDefination'  
   SELECT @YearOfDefCount = Count(*) FROM #TempYearOfDef where YearOfDef IN(@YearOfDefinition)  
   IF (@YearOfDefCount != 1)  
   BEGIN  
    SET @errorMessage = @errorMessage + 'Year of Definition should be DY/CY/FY ~ '  
    SET  @isErrorInRow = 'Y'  
   END  
  
   PRINT 'Validation for Talent_Name'  
   DECLARE @Actual_Count INT = 0 , @Talent_Count INT = 0 ,@Compare_Talent_Count INT = 0;  
  
   SELECT @Actual_Count = Count(*) FROM #temp_Talent_Name where number <> ''  
   SELECT @Talent_Count= COUNT(*)  
   FROM #temp_Talent_Name AS C  
   INNER JOIN Talent AS S ON S.Talent_Name = C.number -- ltrin and rtrin for number  
  
   IF  (@Actual_Count <> @Talent_Count)  
   BEGIN  
      
    SELECT @Invalid_Talent_name = STUFF((SELECT ',' + number FROM #temp_Talent_Name where LTRIM(number) <> ''and  number NOT IN (SELECT S.Talent_Name  
    FROM #temp_Talent_Name AS C  
    INNER JOIN Talent AS S ON S.Talent_Name = C.number)  
    FOR XML PATH ('')), 1, 1, '')   
  
    IF(ISNULL(@Invalid_Talent_name,'') <> '')  
    BEGIN   
     SET @errormessage = @errormessage + 'Talent Name as '+ @Invalid_Talent_name +' does not exist in Talent table ~ '    
    END  
    SET  @isErrorInRow = 'Y'  
    SET @Invalid_Talent_name = ''  
       
   END  
   ELSE  
   BEGIN  
  
    SELECT ROW_NUMBER() OVER (ORDER BY talent_code) AS Id, S.Talent_Code,S.Talent_Name ,t.Title_Code , t.Title_Name  
    INTO #Temp_Talent  
    FROM #temp_Talent_Name AS C   
    INNER JOIN Talent AS S ON S.Talent_Name = C.number  
    INNER JOIN Title T ON T.Reference_Key  = s.Talent_Code  
    where T.Reference_Flag= 'T' and T.deal_type_code = @Deal_Type_Code_Sub_Deal AND T.Is_Active = 'Y'  
  
    DECLARE @Title_Matching_Talent_Count INT = 0  
    SELECT @Title_Matching_Talent_Count =  COUNT(*) FROM #Temp_Talent  
     
    IF (@Title_Matching_Talent_Count <> @Actual_Count)  
    BEGIN  
      SET @errormessage = @errormessage + 'Not all Talent matched with the Title table as per their DealtypeCode ~ '  
      SET  @isErrorInRow = 'Y'  
    END  
    --ELSE    Commented because talent is not map with that main title  
    --BEGIN  
    -- IF (@MasterDealTitleCode <> 0)  
    -- BEGIN  
    --  PRINT 'Validation for Talent_Code'  
    --  SELECT ROW_NUMBER() OVER (ORDER BY talent_code) AS Id, S.Talent_Code,S.Talent_Name INTO #Temp_Test_Talent   
    --  FROM #temp_Talent_Name AS C   
    --  INNER JOIN Talent AS S ON S.Talent_Name = C.number  
  
    --  IF EXISTS (SELECT * FROM #Temp_Test_Talent WHERE Talent_Code NOT IN (SELECT Talent_Code FROM Title_Talent WHERE Title_Code = @MasterDealTitleCode)) -- @Title_Code  
    --  BEGIN  
    --   SET @Invalid_Talent_name = ''  
    --   SELECT @Invalid_Talent_name = STUFF(  
    --   (SELECT ',' + talent_name FROM #Temp_Test_Talent WHERE Talent_Code NOT IN (SELECT Talent_Code FROM Title_Talent WHERE Title_Code = @MasterDealTitleCode)  
    --    FOR XML PATH ('')), 1, 1, '')   
  
    --   SET @errormessage = @errormessage + ' Talent code of '+ @Invalid_Talent_name +' doesnot match with the actual title code in Title_Talent table ~ '  
    --   SET  @isErrorInRow = 'Y'  
    --   SET @Invalid_Talent_name = ''  
    --  END  
    -- END  
    --END     
   END  
  
   IF (@isErrorInRow <> 'Y')  
   BEGIN  
    UPDATE ImportSubDeal  SET IsProcessed = 'I' WHERE ImportSubDeal_Code = @ImportSubDeal_Code  
   END    
   ELSE  
   BEGIN  
     
    INSERT INTO #TempErrorDetails  
    ([DealDesc],[AgreementDate],[ModeOfAcquisition],[MasterDealAgreementNo],[MasterDealTitle],[YearOfDefinition],[DealFor],  
    [BusinessUnit],[Talent],[Remarks],[Error_Details])    
    SELECT DealDesc,AgreementDate,ModeOfAcquisition,MasterDealAgreementNo,MasterDealTitle,YearOfDefinition,DealFor,  
    BusinessUnit,Talent,Remarks,@errormessage  
    FROM #TempImportSubDeal WHERE IsProcessed = 'N' AND RowNo = @RowNo      
      
    --Status to 'E'  
    UPDATE ImportSubDeal  SET IsProcessed = 'E' WHERE ImportSubDeal_Code = @ImportSubDeal_Code          
   END  
  
   UPDATE #TempImportSubDeal SET IsProcessed  = 'Y' WHERE IsProcessed = 'N' AND RowNo = @RowNo  
   SELECT @RowNo = 0  
   SELECT TOP 1 @RowNo = RowNo FROM #TempImportSubDeal WHERE IsProcessed = 'N'  
  
  END  
   
 DECLARE @Error_Count INT = 0  
  
 SELECT @Error_Count = COUNT(*)  FROM  ImportSubDeal  
 WHERE  [IsProcessed] = 'E'  
  
 IF (@Error_Count <> 0)  
 BEGIN  
  SELECT @Current_Status = 'E'  
  SELECT @Current_Status AS [Status] , * FROM #TempErrorDetails  
 END    
 --ELSE  
 --BEGIN  
 -- EXEC [USP_Import_SubDeal_Insert] @UserCode        
 --END  

	IF OBJECT_ID('tempdb..#Temp_Talent') IS NOT NULL DROP TABLE #Temp_Talent
	IF OBJECT_ID('tempdb..#temp_Talent_Name') IS NOT NULL DROP TABLE #temp_Talent_Name
	IF OBJECT_ID('tempdb..#Temp_Test_Talent') IS NOT NULL DROP TABLE #Temp_Test_Talent
	IF OBJECT_ID('tempdb..#Temp_Title_Talent') IS NOT NULL DROP TABLE #Temp_Title_Talent
	IF OBJECT_ID('tempdb..#TempErrorDetails') IS NOT NULL DROP TABLE #TempErrorDetails
	IF OBJECT_ID('tempdb..#TempImportSubDeal') IS NOT NULL DROP TABLE #TempImportSubDeal
	IF OBJECT_ID('tempdb..#TempYearOfDef') IS NOT NULL DROP TABLE #TempYearOfDef
END