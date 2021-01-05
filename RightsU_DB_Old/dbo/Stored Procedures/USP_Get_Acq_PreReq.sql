ALTER PROC [dbo].[USP_Get_Acq_PreReq]  
(  
	@Data_For VARCHAR(MAX),  
	@Call_From VARCHAR(3),  
	@LoginUserCode INT,  
	@Acq_Deal_Code INT,  
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
    Parameter '@Acq_Deal_Code' for call 'USP_Populate_Master_Deal_Titles' procedure, and pass Acq_Deal_Movie_Code as parameter  
    Pass value as 'LST' for Acq List Page, 'GEN' for Acq General Tab in '@Call_From' parameter  
      
      
Flag for All Masters :  
    DTG = Deal Tag  DTP = Deal Type Parents  ROL = Role  MDS = Master Deals    
    CTG = Category  DTC = Deal Type Childs  ENT = Entity BUT = Business Unit     
    CUR = Currency  TIT = Title List   VEN = Vendor DIR = Director List  
                    VPC = Vendor Primary Contact  
  
Applicable for List Page: 'DTG,DTP,DTC,BUT,VEN,DIR,TIT'  
Applicable for General Tab: 'DTG,ROL,DTP,MDS,DTC,CTG,ENT,BUT,CUR,VEN,VPC'  
=======================================================================================================================================*/  
	BEGIN  
		SET FMTONLY OFF  
		SET NOCOUNT ON  
  
 --DECLARE  
 --@Data_For VARCHAR(MAX) = 'DTG,ROL,DTP,MDS,DTC,CTG,ENT,BUT,CUR,VEN,VPC',  
 --@Call_From VARCHAR(3) = 'GEN',  
 --@LoginUserCode INT = 143,  
 --@Acq_Deal_Code INT = 0,  
 --@Deal_Type_Code INT = 0,  
 --@BusinessUnitCode INT = 0  
  
	IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)  
		DROP TABLE #PreReqData  
  
	CREATE TABLE #PreReqData  
	(  
		RowID INT IDENTITY(1,1),  
		Display_Value INT,  
		Display_Text NVARCHAR(MAX),  
		Data_For VARCHAR(3)  
	)  
  
	IF(OBJECT_ID('TEMPDB..#BusinessUnit') IS NOT NULL)  
		DROP TABLE #BusinessUnit  
  
	CREATE TABLE #BusinessUnit  
	(  
		BusinessUnitCode INT,  
		BusinessUnitName VARCHAR(MAX)  
	)  
  
	INSERT INTO #BusinessUnit(BusinessUnitCode, BusinessUnitName)  
	SELECT DISTINCT BU.Business_Unit_Code, BU.Business_Unit_Name FROM Business_Unit BU  
	INNER JOIN Users_Business_Unit UBU ON BU.Business_Unit_Code = UBU.Business_Unit_Code AND UBU.Users_Code = @LoginUserCode  
	WHERE BU.Is_Active  = 'Y'  
  
	DECLARE @Deal_Type_Code_Other INT = 17, @RoleCode_Director INT  = 1, @Selected_Vendor_Code INT = 0 ,@Is_Vendor_Validation_For_Deal CHAR(1)
	SELECT TOP 1 @Deal_Type_Code_Other = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Other'  
	SELECT @Is_Vendor_Validation_For_Deal = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name= 'Is_Vendor_Validation_For_Deal'
	IF(@Acq_Deal_Code > 0)  
		SELECT TOP 1 @Selected_Vendor_Code = Vendor_Code FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
	IF(CHARINDEX('DTG', @Data_For) > 0)  
	BEGIN  
		IF(@Call_From = 'LST')   
		BEGIN  
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
			SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'DTG' AS Data_For  
		END  
    
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT Deal_Tag_Code, Deal_Tag_Description, 'DTG' AS Data_For FROM Deal_Tag  Where Deal_Flag IN ('AS')
		ORDER BY Deal_Tag_Description  
	END  
  
	IF(CHARINDEX('ROL', @Data_For) > 0)  
	BEGIN  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT Role_Code, Role_Name, 'ROL' AS Data_For FROM [Role] WHERE Role_Type = 'A'  
	END  
  
	IF(CHARINDEX('DTP', @Data_For) > 0)  
	BEGIN  
		PRINT @Call_From
		IF(@Call_From = 'GEN')   
			BEGIN  
				INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
				SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTP' AS Data_For FROM Deal_Type   
				WHERE ISNULL(Parent_Code, 0) = 0 AND Deal_Or_Title LIKE '%A%' AND Is_Active  = 'Y'  
			END 
			ELSE IF(@Call_From='PRO')
				BEGIN
				INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
				SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTP' AS Data_For FROM Deal_Type   
				WHERE (ISNULL(Parent_Code, 0) = 0  AND Is_Active  = 'Y' and Deal_Type_Name not in ('Other')) or Deal_Type_Name = 'Event'
			END
			ELSE  
			BEGIN  
				INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
				SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'DTP' AS Data_For  
				UNION  
				SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTP' AS Data_For FROM Deal_Type   
				WHERE ISNULL(Parent_Code, 0) = 0 AND Deal_Type_Code <> @Deal_Type_Code_Other AND Deal_Or_Title LIKE '%A%' AND Is_Active  = 'Y'  
		END  
	END  
  
	IF(CHARINDEX('MDS', @Data_For) > 0)  
	BEGIN  
		DECLARE @ADM_Code INT = 0  
  
		SELECT TOP 1 @ADM_Code = ISNULL(Master_Deal_Movie_Code_ToLink, 0) FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'MDS' AS Data_For  
  
		INSERT INTO #PreReqData(Display_Value, Display_Text)  
		EXEC USP_Populate_Master_Deal_Titles @ADM_Code  
		UPDATE #PreReqData SET Data_For = 'MDS' WHERE Data_For IS NULL  
	END  
  
	IF(CHARINDEX('DTC', @Data_For) > 0)  
	BEGIN  
		IF(@Call_From = 'GEN')   
		BEGIN  
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
			SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'DTC' AS Data_For  
		END  
  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT Deal_Type_Code, Deal_Type_Name, 'DTC' AS Data_For FROM Deal_Type   
		WHERE ISNULL(Parent_Code, 0) = @Deal_Type_Code_Other AND Deal_Or_Title LIKE '%A%' AND Is_Active  = 'Y'  
		ORDER BY Deal_Type_Name  
	END  
  
	IF(CHARINDEX('CTG', @Data_For) > 0)  
	BEGIN  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'CTG' AS Data_For  
		UNION  
		SELECT DISTINCT Category_Code, Category_Name, 'CTG' AS Data_For FROM Category WHERE Is_Active  = 'Y'  
	END  
  
	IF(CHARINDEX('ENT', @Data_For) > 0)  
		BEGIN  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'ENT' AS Data_For  
		UNION  
		SELECT DISTINCT Entity_Code, [Entity_Name], 'ENT' AS Data_For FROM Entity WHERE Is_Active  = 'Y'  
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
		SELECT DISTINCT Currency_Code, Currency_Name + ' - ' + Currency_Sign, 'CUR' AS Data_For FROM Currency WHERE Is_Active  = 'Y'  
	END  
  
	IF(CHARINDEX('VEN', @Data_For) > 0)  
	BEGIN  
		IF(@Call_From = 'GEN')   
		BEGIN  
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
			SELECT DISTINCT Vendor_Code, Vendor_Name, 'VEN' AS Data_For FROM Vendor   
			WHERE (Vendor_Code IN(SELECT Vendor_Code FROM Acq_Deal_Licensor where Acq_Deal_Code = @Acq_Deal_Code) AND @Is_Vendor_Validation_For_Deal = 'Y') OR Is_Active  = 'Y'  
			ORDER BY Vendor_Name  
		END 
		ELSE  
		BEGIN  
			DECLARE @roleCodes VARCHAR(MAX) = '0'  
			SELECT TOP 1 @roleCodes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AcqLicensorRoleCode'  
  
			;WITH Temp_Role AS (  
			SELECT number AS Role_Code FROM DBO.fn_Split_withdelemiter(@roleCodes, ',')  
			)  
  
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
			SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'VEN' AS Data_For FROM Vendor V  
			INNER JOIN Vendor_Role VR ON V.Vendor_Code = VR.Vendor_Code AND ISNULL(VR.Is_Active, 'Y') = 'Y'  
			--INNER JOIN Temp_Role TR ON TR.Role_Code = vr.Role_Code  
			WHERE V.Is_Active  = 'Y'  
			AND V.Vendor_Code IN(select Vendor_Code from Acq_Deal WHERE  Deal_Workflow_Status NOT IN ('AR', 'WA'))  
			ORDER BY V.Vendor_Name  
		END  
	END  
  
	IF(CHARINDEX('VPC', @Data_For) > 0)  
	BEGIN  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT 0 AS Display_Value, 'Please Select' AS Display_Text, 'VPC' AS Data_For  
  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT VC.Vendor_Contacts_Code, VC.Contact_Name, 'VPC' AS Data_For FROM Vendor_Contacts VC  
		WHERE VC.Vendor_Code = @Selected_Vendor_Code  
		ORDER BY VC.Contact_Name  
	END  
  
	IF(CHARINDEX('DIR', @Data_For) > 0)  
	BEGIN  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT T.Talent_Code, T.Talent_Name, 'DIR' AS Data_For FROM Talent T   
		INNER JOIN Talent_Role TR ON T.Talent_Code = TR.Talent_Code AND TR.Role_Code = @RoleCode_Director  
		WHERE T.Is_Active  = 'Y'  
		ORDER BY T.Talent_Name  
	END  
  
	IF(CHARINDEX('TIT', @Data_For) > 0)  
	BEGIN  
		IF(@BusinessUnitCode = 0)  
		SELECT TOP 1 @BusinessUnitCode = BusinessUnitCode FROM #BusinessUnit  
  
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
		SELECT DISTINCT T.Title_Code, T.Title_Name, 'TIT' AS Data_For FROM Title T   
		INNER JOIN Acq_Deal_Movie ADM ON T.Title_Code = ADM.Title_Code  
		INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Business_Unit_Code = @BusinessUnitCode  
		AND (AD.Deal_Type_Code = @Deal_Type_Code OR @Deal_Type_Code = 0)  
     
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  T.Is_Active  = 'Y'  
		ORDER BY T.Title_Name  
	END  
  
 
	SELECT Display_Value, Display_Text, Data_For FROM #PreReqData  
	ORDER BY RowID  
END  