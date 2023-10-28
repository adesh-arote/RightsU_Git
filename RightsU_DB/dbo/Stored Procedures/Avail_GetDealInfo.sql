CREATE PROCEDURE [dbo].[Avail_GetDealInfo]
(
	@Title_Code INT
)
AS

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetDealInfo]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE @Title_Code INT = 1041
	SET FMTONLY OFF
	IF OBJECT_ID('TEMPDB..#Temp_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Data
	END
	CREATE TABLE #Temp_Data
	(
		Deal_Code INT,
		Module_Code INT,
		Agreement_No VARCHAR(50),
		VENDor_Code INT, 	
		Licensee_Code INT,
		Rights_Code INT,
		Right_Type CHAR(1),
		Is_Tentative CHAR(1),
		R_Start_Date DATETIME,
		R_END_Date DATETIME,
		Is_Title_Lang CHAR(1),
		Is_Exclusive  CHAR(1),
		Is_Sub_License CHAR(1),	
		Is_Expiring_In_Days INT,	
		VENDor_Name NVARCHAR(200),
		Licensee_Name NVARCHAR(200),
		Platform_Name NVARCHAR(MAX),
		Country_Name NVARCHAR(4000),
		Territory_Name NVARCHAR(4000),
		Sub_Lang_Name NVARCHAR(4000),
		Dub_Lang_Name NVARCHAR(4000),
		Term VARCHAR(10),
		M_Type_Code INT,
		M_No_Of_Unit INT,
		M_Unit_Type INT,
		Is_Gift_box_Show CHAR(1) DEFAULT 'N' 
	)	
	INSERT INTO #Temp_Data
	(
	Deal_Code,Module_Code,Agreement_No,
	VENDor_Code,Licensee_Code,Rights_Code,
	Right_Type,Is_Tentative,R_Start_Date,
	R_END_Date,Is_Title_Lang,Is_Exclusive,
	Is_Sub_License,Term,M_Type_Code,M_No_Of_Unit,M_Unit_Type 
	)				   
	SELECT DISTINCT    
		AD.Acq_Deal_Code , 30 Module_Code, AD.Agreement_No,
		AD.VENDor_Code,AD.Entity_Code,ADR.Acq_Deal_Rights_Code,
		ADR.Right_Type,ADR.Is_Tentative,ISNULL(ADR.Actual_Right_Start_Date,'31Dec9999'),
		ISNULL(ADR.Actual_Right_END_Date,'31Dec9999'),ADR.Is_Title_Language_Right,ADR.Is_Exclusive,
		ADR.Is_Sub_License,ADR.Term,ADR.Milestone_Type_Code,ADR.Milestone_No_Of_Unit,ADR.Milestone_Unit_Type
	FROM Acq_Deal AD (NOLOCK)
	--INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Title_Code = @Title_Code
	INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADRT.Title_Code = @Title_Code  
	Where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') --AND AD.Business_Unit_Code IN(select Business_Unit_Code from Users_Business_Unit where Users_Code=@User_Code)
	UNION
	SELECT SD.Syn_Deal_Code , 35 Module_Code , SD.Agreement_No,
	SD.VENDor_Code,SD.Entity_Code,SDR.Syn_Deal_Rights_Code,
	SDR.Right_Type,SDR.Is_Tentative,ISNULL(SDR.Actual_Right_Start_Date,'31Dec9999'),
	ISNULL(SDR.Actual_Right_END_Date,'31Dec9999'),SDR.Is_Title_Language_Right,SDR.Is_Exclusive,
	SDR.Is_Sub_License,SDR.Term,SDR.Milestone_Type_Code,SDR.Milestone_No_Of_Unit,SDR.Milestone_Unit_Type
	FROM Syn_Deal SD (NOLOCK)
	--INNER JOIN Syn_Deal_Movie SDM ON SD.Syn_Deal_Code = SDM.Syn_Deal_Code AND SDM.Title_Code = @Title_Code
	INNER JOIN Syn_Deal_Rights SDR (NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Title SDRT (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND SDRT.Title_Code = @Title_Code  
	WHERE ISNULL(SDR.Is_Pushback, 'N') = 'N'
	--Where SD.Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit where Users_Code=@User_Code)
	--AND ISNULL(SDR.Is_Pushback, 'N') = 'N'

	
	--update All MAsters
	--Licensor or vENDor
	UPDATE temp SET temp.VENDor_Name =V.VENDor_Name
	FROM VENDor V 
	INNER JOIN #Temp_Data temp ON V.VENDor_Code = temp.VENDor_Code 
	----Licensee 
	UPDATE temp SET temp.Licensee_Name =E.[Entity_Name]
	FROM Entity E 
	INNER JOIN #Temp_Data temp ON E.Entity_Code = temp.Licensee_Code

	UPDATE #Temp_Data SET Country_Name = DBO.UFN_Get_Rights_Country(Rights_Code, 'A','') ,Territory_Name = DBO.UFN_Get_Rights_Territory(Rights_Code, 'A') 
	WHERE Module_Code = 30
	UPDATE #Temp_Data SET Country_Name = DBO.UFN_Get_Rights_Country(Rights_Code, 'S','') ,Territory_Name = DBO.UFN_Get_Rights_Territory(Rights_Code, 'S')
	WHERE Module_Code = 35
	UPDATE #Temp_Data SET Sub_Lang_Name= DBO.UFN_Get_Rights_Subtitling(Rights_Code, 'A') , Dub_Lang_Name= DBO.UFN_Get_Rights_Dubbing(Rights_Code, 'A') 
	WHERE Module_Code = 30
	UPDATE #Temp_Data SET Sub_Lang_Name= DBO.UFN_Get_Rights_Subtitling(Rights_Code, 'S') , Dub_Lang_Name= DBO.UFN_Get_Rights_Dubbing(Rights_Code, 'S') 
	WHERE Module_Code = 35


	--PlatformCode
	DECLARE @Codes  VARCHAR(MAX),@Platform_Name VARCHAR(MAX),@Right_Code INT = 0,@Module_Code INT = 0
	SET @Codes = ''
	DECLARE CUR_Right CURSOR FOR SELECT DISTINCT Rights_Code,Module_Code FROM #Temp_Data 
	OPEN CUR_Right
		FETCH NEXT FROM CUR_Right InTo @Right_Code,@Module_Code
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
						SET @Codes = ''
						IF(@Module_Code = 30)					
							SELECT @Codes = @Codes + CAST(Platform_Code AS VARCHAR) + ',' FROM Acq_Deal_Rights_Platform Where Acq_Deal_Rights_Code = @Right_Code
						ELSE						
							SELECT @Codes = @Codes + CAST(Platform_Code AS VARCHAR) + ',' FROM Syn_Deal_Rights_Platform Where Syn_Deal_Rights_Code = @Right_Code
					
						SET @Platform_Name = ''
						SELECT @Platform_Name = @Platform_Name + Platform_Hiearachy + '~' FROM dbo.UFN_Get_Platform_With_Parent (@Codes)
						SET @Platform_Name = REVERSE(STUFF(REVERSE(@Platform_Name), 1, 1, ''))						
						UPDATE #Temp_Data SET Platform_Name = @Platform_Name WHERE Rights_Code = @Right_Code AND Module_Code = @Module_Code 					
				FETCH NEXT FROM CUR_Right INTO @Right_Code,@Module_Code
			END
	CLOSE CUR_Right
	DEALLOCATE CUR_Right
	
		--Start Deal Exiring Logic
	DECLARE @Acq_Mail_alert_days INT = 30 , @Syn_Mail_alert_days INT = 30,@Start_Range INT= 0
	IF EXISTS(SELECT TOP 1  Mail_alert_days FROM  Deal_Expiry_Email Where Alert_Type = 'A' AND ISNULL(Mail_alert_days,0) > 0)
		SELECT TOP 1 @Acq_Mail_alert_days = Mail_alert_days FROM  Deal_Expiry_Email Where Alert_Type = 'A' 
	IF EXISTS(SELECT TOP 1  Mail_alert_days FROM  Deal_Expiry_Email Where Alert_Type = 'S' AND ISNULL(Mail_alert_days,0) > 0)
		SELECT TOP 1 @Syn_Mail_alert_days = Mail_alert_days FROM  Deal_Expiry_Email Where Alert_Type = 'S' 

	--SELECT DATEDIFF(dd,GETDATE(),IsNull(R_END_Date, '31Dec9999')) AS Expire_In_Days 
	--FROM #Temp_Data TD
	UPDATE #Temp_Data  SET Is_Expiring_In_Days = DATEDIFF(dd,GETDATE(),IsNull(R_END_Date, '31Dec9999'))
	WHERE DATEDIFF(dd,GETDATE(),IsNull(R_END_Date, '31Dec9999')) BETWEEN @Start_Range AND @Acq_Mail_alert_days
	AND GETDATE() BETWEEN R_Start_Date AND R_END_Date		

	----Title Lang
	DECLARE @Title_Lang NVARCHAR(50) = 'Hindi'
	
	SELECT TOP 1 @Title_Lang = L.Language_Name
	FROM  [Language]  L (NOLOCK)
	WHERE L.Language_Code IN
	(
		SELECT T.Title_Language_Code FROM  Title (NOLOCK) T WHERE T.Title_Code = @Title_Code
	)

	;WITH tbl_ADM as(
	SELECT COUNT(DISTINCT ADM.Title_Code) AS Count_Title,ADM.Acq_Deal_Code	
	FROM Acq_Deal_Movie ADM (NOLOCK)
	WHERE ADM.Acq_Deal_Code IN(
		SELECT DISTINCT TD.Deal_Code FROM #Temp_Data TD WHERE TD.Module_Code = 30
	)
	GROUP BY ADM.Acq_Deal_Code 
	)
	
	UPDATE TD SET TD.Is_Gift_box_Show = 'Y'
	FROM #Temp_Data TD 
	INNER JOIN tbl_ADM T ON TD.Deal_Code = T.Acq_Deal_Code AND TD.Module_Code = 30
	WHERE T.Count_Title > 1
	
	;WITH tbl_SDM as(
	SELECT COUNT(DISTINCT SDM.Title_Code) AS Count_Title,SDM.Syn_Deal_Code	
	FROM Syn_Deal_Movie SDM (NOLOCK)
	WHERE SDM.Syn_Deal_Code IN(
		SELECT DISTINCT TD.Deal_Code FROM #Temp_Data TD WHERE TD.Module_Code = 35
	)
	GROUP BY SDM.Syn_Deal_Code 
	)

	UPDATE TD SET TD.Is_Gift_box_Show = 'Y'
	FROM #Temp_Data TD 
	INNER JOIN tbl_SDM T ON TD.Deal_Code = T.Syn_Deal_Code AND TD.Module_Code = 35
	WHERE T.Count_Title > 1
	
	SELECT DISTINCT 
		CAST(DENSE_RANK() OVER (ORDER BY Agreement_No) AS INT) AS Group_No,
		--1 AS Group_No,
		CASE WHEN TD.Module_Code = 30 THEN 'A' ELSE 'S' END AS Deal_Type,
		TD.Agreement_No,TD.Licensee_Name,TD.VENDor_Name AS Vendor_Name,TD.R_Start_Date,
		TD.R_END_Date,
		CASE TD.Is_Exclusive WHEN 'Y' THEN 'Exclusive' WHEN 'N' THEN 'Non Exclusive' ELSE '' END Is_Exclusive, 
		CASE TD.Is_Sub_License WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE '' END Is_Sub_License,
		CASE WHEN  ISNULL(TD.Is_Expiring_In_Days,0) > 0 THEN  'Expiring in ' + CAST(TD.Is_Expiring_In_Days AS VARCHAR) + ' days' ELSE '' END AS Expiring_In_Days,
		--'Expiring' +  (CASE WHEN Module_Code = 30 THEN  CAST(@Acq_Mail_alert_days AS VARCHAR) ELSE CAST(@Syn_Mail_alert_days AS VARCHAR) END) + 'days' AS Expiring_In_Days,
		TD.Platform_Name,TD.Country_Name,TD.Territory_Name,TD.Sub_Lang_Name,TD.Dub_Lang_Name,
		--@Title_Lang Is_Title_Lang
		CASE WHEN ISNULL(Is_Title_Lang,'N') =  'Y' THEN  @Title_Lang ELSE 'No' END AS Is_Title_Lang,TD.Right_Type,TD.Deal_Code,TD.Term,Case TD.Right_Type
			   When 'Y' Then [dbo].[UFN_Get_Rights_Term](TD.R_Start_Date, TD.R_END_Date, TD.Term) 
			   When 'M' Then [dbo].[UFN_Get_Rights_Milestone](TD.M_Type_Code, TD.M_No_Of_Unit, TD.M_Unit_Type)
			   When 'U' Then 'Perpetuity'
		   End Right_Term,TD.Is_Gift_box_Show
		   ,TD.Rights_Code
	FROM #Temp_Data TD
	ORDER BY Deal_Type,Agreement_No
	--DROP TABLE #Temp_Data

	IF OBJECT_ID('tempdb..#Temp_Data') IS NOT NULL DROP TABLE #Temp_Data
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetDealInfo]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END