CREATE PROC [dbo].[USP_Get_Syn_PreReq]  
(  
 @Data_For VARCHAR(MAX),  
 @Call_From VARCHAR(3),  
 @LoginUserCode INT,  
 @Syn_Deal_Code INT,  
 @Deal_Type_Code INT,  
 @BusinessUnitCode INT  
) 
AS  
/*=======================================================================================================================================  
Author:   Abhaysingh N. Rajpurohit  
Create date: 29 Mar, 2016  
Description: It will select data from those master whose flag exist in '@Data_For' parameter  
Note:   Parameter '@Data_For' will containg the flag value comma seperated, whose data should be selected.  
    Parameter '@LoginUserCode' will contain current LoggedIn user code  
    Pass value as 'LST' for Syn List Page, 'GEN' for Syn General Tab in '@Call_From' parameter  
      
      
Flag for All Masters :  
    DTG = Deal Tag  DTP = Deal Type Parents  ROL = Role   DIR = Director List  
    CTG = Category  DTC = Deal Type Childs  TIT = Title List LAC = Licensee/ Assignee Contact  
    CUR = Currency  LAV = Licensee/ Assignee SAV = Sale Agent SAC = Sales Agent Contact  
         BUT = Business Unit  
  
Applicable for List Page: 'DTG,DTP,DTC,BUT,LAV,DIR,TIT'  
Applicable for General Tab: 'DTG,ROL,DTP,DTC,CTG,LAV,SAV,BUT,CUR,LAC,SAC'  
=======================================================================================================================================*/  
BEGIN   
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Get_Syn_PreReq]', 'Step 1', 0, 'Started Procedure', 0, ''
	 SET NOCOUNT ON;  
	 SET FMTONLY OFF;   
  
	 --declare  
	 --@data_for varchar(max) = 'ROL',  
	 --@call_from varchar(3) = 'GEN',  
	 --@loginusercode int = 143,  
	 --@syn_deal_code int = 0,  
	 --@deal_type_code int = 0,  
	 --@businessunitcode int = 0  
  
	 IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)  
	  DROP TABLE #PreReqData  
  
	 CREATE TABLE #PreReqData  
	 (  
	  RowID INT IDENTITY(1,1),  
	  Display_Value INT,  
	  Display_Text NVARCHAR(MAX),  
	  Data_For VARCHAR(50)  
	 )  
  
	 DECLARE @Deal_Type_Code_Other INT = 17, @Deal_Type_ContentMusic INT = 30,  
	 @RoleCode_Director INT  = 1, @Selected_Licensee_Code INT = 0, @Selected_Seles_Agent_Code INT = 0  
  
	 SELECT TOP 1 @Deal_Type_Code_Other = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Other'  
	 SELECT TOP 1 @Deal_Type_ContentMusic = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_ContentMusic'  
  
	 IF(@Syn_Deal_Code > 0)  
	  SELECT TOP 1 @Selected_Licensee_Code = Vendor_Code, @Selected_Seles_Agent_Code = Sales_Agent_Code FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @Syn_Deal_Code  
  
	 IF(OBJECT_ID('TEMPDB..#TempCT') IS NOT NULL)  
	  DROP TABLE #TempCT  
  
	 IF(OBJECT_ID('TEMPDB..#CustomerType') IS NOT NULL)  
	  DROP TABLE #CustomerType  
  
	 IF(OBJECT_ID('TEMPDB..#BusinessUnit') IS NOT NULL)  
	  DROP TABLE #BusinessUnit  
  
	 CREATE TABLE #CustomerType  
	 (  
	  Role_Code INT,  
	  Role_Name NVARCHAR(MAX)  
	 )  
  
	 CREATE TABLE #BusinessUnit  
	 (  
	  BusinessUnitCode INT,  
	  BusinessUnitName NVARCHAR(MAX)  
	 )  
  
	 --DECLARE @paramCustomer_Types NVARCHAR(MAX) = '', @paramDefault_Customer NVARCHAR(MAX) = ''    
	 --SELECT TOP 1 @paramCustomer_Types = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Customer_Types'  
	 --SELECT TOP 1 @paramDefault_Customer = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Default_Customer'  
   
	 --SELECT number AS Customer_Type INTO #TempCT FROM dbo.fn_Split_withdelemiter(@paramCustomer_Types, ',')  
  
	 --INSERT INTO #CustomerType(Role_Code, Role_Name)  
	 --SELECT DISTINCT R.Role_Code, R.Role_Name FROM [Role] R  
	 --INNER JOIN #TempCT T ON R.Role_Name = T.Customer_Type  
	 --WHERE R.Role_Name = @paramDefault_Customer  
  
	 --INSERT INTO #CustomerType(Role_Code, Role_Name)  
	 --SELECT DISTINCT R.Role_Code, R.Role_Name FROM [Role] R  
	 --INNER JOIN #TempCT T ON R.Role_Name = T.Customer_Type  
	 --WHERE R.Role_Name <> @paramDefault_Customer  
  
	 INSERT INTO #BusinessUnit(BusinessUnitCode, BusinessUnitName)  
	 SELECT DISTINCT BU.Business_Unit_Code, BU.Business_Unit_Name FROM Business_Unit BU   (NOLOCK) 
	 INNER JOIN Users_Business_Unit UBU  (NOLOCK) ON BU.Business_Unit_Code = UBU.Business_Unit_Code AND UBU.Users_Code = @LoginUserCode  
	 WHERE BU.Is_Active  = 'Y'  
  
	 IF(CHARINDEX('DTG', @Data_For) > 0)  
	 BEGIN  
	  IF(@Call_From = 'LST')  
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'DTG' AS Data_For   
	  END  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT Deal_Tag_Code, Deal_Tag_Description, 'DTG' AS Data_For FROM Deal_Tag  (NOLOCK)  WHERE Deal_Flag IN ('AS')
	 END  
  
	 IF(CHARINDEX('ROL', @Data_For) > 0)  
	 BEGIN  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT Role_Code, Role_Name, 'ROL' AS Data_For FROM Role (NOLOCK) where Role_Type like '%S%' --AND Is_Rate_Card = 'Y'
	  --UNION
	  --SELECT Role_Code, Role_Name, 'ROL_Other' AS Data_For FROM Role where Role_Type like '%S%' AND Is_Rate_Card = 'N'
	  --SELECT Role_Code, Role_Name, 'ROL' AS Data_For FROM #CustomerType  
	 END  
  
	 IF(CHARINDEX('DTP', @Data_For) > 0)  
	 BEGIN  
	  IF(@Call_From = 'GEN')   
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTP' AS Data_For FROM Deal_Type   (NOLOCK)  
	   WHERE ISNULL(Parent_Code, 0) = 0 AND Deal_Or_Title LIKE '%S%' AND Is_Active  = 'Y'  
	  END  
	  ELSE  
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'DTP' AS Data_For  
	   UNION  
	   SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTP' AS Data_For FROM Deal_Type (NOLOCK)  
	   WHERE ISNULL(Parent_Code, 0) = 0 AND Deal_Type_Code <> @Deal_Type_Code_Other   
	   AND Deal_Or_Title LIKE '%S%' AND Is_Active  = 'Y'  
	  END  
	 END  
  
	 IF(CHARINDEX('DTC', @Data_For) > 0)  
	 BEGIN  
	  IF(@Call_From = 'GEN')   
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'DTC' AS Data_For  
	  END  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTC' AS Data_For FROM Deal_Type    (NOLOCK) 
	  WHERE ISNULL(Parent_Code, 0) = @Deal_Type_Code_Other AND Deal_Or_Title LIKE '%S%' AND Is_Active  = 'Y'  
	 END  
    
	 IF(CHARINDEX('CTG', @Data_For) > 0)  
	 BEGIN  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'CTG' AS Data_For  
	  UNION  
	  SELECT DISTINCT Category_Code, Category_Name, 'CTG' AS Data_For FROM Category (NOLOCK) WHERE Is_Active  = 'Y'  
	 END  
  
	 IF(CHARINDEX('BUT', @Data_For) > 0)  
	 BEGIN  
	  IF(@Call_From = 'GEN')   
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'BUT' AS Data_For  
	  END  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT BusinessUnitCode, BusinessUnitName, 'BUT' AS Data_For FROM #BusinessUnit  
	 END  
  
	 IF(CHARINDEX('CUR', @Data_For) > 0)  
	 BEGIN  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'CUR' AS Data_For  
	  UNION  
	  SELECT DISTINCT Currency_Code, Currency_Name + ' - ' + Currency_Sign, 'CUR' AS Data_For FROM Currency (NOLOCK) WHERE Is_Active  = 'Y'  
	 END  
  
	 IF(CHARINDEX('LAV', @Data_For) > 0)  
	 BEGIN  
	  IF(@Call_From = 'GEN')   
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'LAV' AS Data_For  
  
	   DECLARE @Role_Code_Entity INT = 14 /*THIS IS FOR INTERNAL SALE*/, @Selected_Role_Code INT = 0  
	   SELECT TOP 1 @Selected_Role_Code = Role_Code FROM #CustomerType  
  
	   IF(@Selected_Role_Code <> @Role_Code_Entity)  
	   BEGIN  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'LAV' AS Data_For FROM Vendor V   (NOLOCK)  
		INNER JOIN Vendor_Role VR (NOLOCK)  ON V.Vendor_Code = VR.Vendor_Code --AND VR.Role_Code = @Selected_Role_Code  
		INNER JOIN #CustomerType CT ON CT.Role_Code = VR.Role_Code  
		ORDER BY V.Vendor_Name  
	   END  
	  END  
	  ELSE  
	  BEGIN  
	   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	   SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'LAV' AS Data_For FROM Vendor V  (NOLOCK)   
	   INNER JOIN Vendor_Role VR (NOLOCK)  ON V.Vendor_Code = VR.Vendor_Code AND V.Is_Active = 'Y' AND ISNULL(VR.Is_Active, 'Y') = 'Y'  
	   AND V.Vendor_Code IN (select Vendor_Code from Syn_Deal  (NOLOCK) )  
	   ORDER BY V.Vendor_Name  
	  END  
	 END  
  
	 IF(CHARINDEX('SAV', @Data_For) > 0)  
	 BEGIN    
	  DECLARE @paramSaleAgent NVARCHAR(MAX) = ''  
	  SELECT TOP 1 @paramSaleAgent = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'SaleAgent'  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'SAV' AS Data_For  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'SAV' AS Data_For FROM Vendor V (NOLOCK)    
	  INNER JOIN Vendor_Role VR (NOLOCK)  ON V.Vendor_Code = VR.Vendor_Code  
	  INNER JOIN [Role] R  (NOLOCK) ON VR.Role_Code = R.Role_Code AND R.Role_Name = @paramSaleAgent  
	  ORDER BY V.Vendor_Name  
	 END  
  
	 IF(CHARINDEX('LAC', @Data_For) > 0)  
	 BEGIN    
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'LAC' AS Data_For  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT VC.Vendor_Contacts_Code, VC.Contact_Name, 'LAC' AS Data_For FROM Vendor_Contacts VC (NOLOCK) 
	  WHERE VC.Vendor_Code = @Selected_Licensee_Code  
	  ORDER BY VC.Contact_Name  
	 END  
  
	 IF(CHARINDEX('SAC', @Data_For) > 0)  
	 BEGIN    
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'SAC' AS Data_For  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT VC.Vendor_Contacts_Code, VC.Contact_Name, 'SAC' AS Data_For FROM Vendor_Contacts VC (NOLOCK) 
	  WHERE VC.Vendor_Code = @Selected_Seles_Agent_Code  
	  ORDER BY VC.Contact_Name  
	 END  
  
	 IF(CHARINDEX('DIR', @Data_For) > 0)  
	 BEGIN  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT T.Talent_Code, T.Talent_Name, 'DIR' AS Data_For FROM Talent T  (NOLOCK)   
	  INNER JOIN Talent_Role TR (NOLOCK) ON T.Talent_Code = TR.Talent_Code AND TR.Role_Code = @RoleCode_Director  
	  WHERE T.Is_Active  = 'Y'  
	 END  
  
	 IF(CHARINDEX('TIT', @Data_For) > 0)  
	 BEGIN  
	  IF(@BusinessUnitCode = 0)  
	  SELECT TOP 1 @BusinessUnitCode = BusinessUnitCode FROM #BusinessUnit  
  
	  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
	  SELECT DISTINCT T.Title_Code, T.Title_Name, 'TIT' AS Data_For FROM Title T (NOLOCK)    
	  INNER JOIN Syn_Deal_Movie ADM (NOLOCK)  ON T.Title_Code = ADM.Title_Code  
	  INNER JOIN Syn_Deal AD (NOLOCK)  ON ADM.Syn_Deal_Code = AD.Syn_Deal_Code AND AD.Business_Unit_Code = @BusinessUnitCode  
	   AND (AD.Deal_Type_Code = @Deal_Type_Code OR @Deal_Type_Code = 0)  
	  WHERE T.Is_Active  = 'Y'    
	 END  
  
	 SELECT Display_Value, Display_Text, Data_For FROM #PreReqData  
	 ORDER BY RowID  

		IF OBJECT_ID('tempdb..#BusinessUnit') IS NOT NULL DROP TABLE #BusinessUnit
		IF OBJECT_ID('tempdb..#CustomerType') IS NOT NULL DROP TABLE #CustomerType
		IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData
		IF OBJECT_ID('tempdb..#TempCT') IS NOT NULL DROP TABLE #TempCT
	 
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Get_Syn_PreReq]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
