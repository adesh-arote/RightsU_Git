GO
PRINT N'Altering [dbo].[Language]...';


GO
ALTER TABLE [dbo].[Language] ALTER COLUMN [Language_Name] NVARCHAR (1000) NOT NULL;


GO
PRINT N'Altering [dbo].[Language_Group]...';


GO
ALTER TABLE [dbo].[Language_Group] ALTER COLUMN [Language_Group_Name] NVARCHAR (1000) NOT NULL;


GO
PRINT N'Refreshing [dbo].[VW_Acq_Deals]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_Acq_Deals]';


GO
PRINT N'Refreshing [dbo].[vwMovieTitleContent]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwMovieTitleContent]';


GO
PRINT N'Refreshing [dbo].[vwProgramTitleContent]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwProgramTitleContent]';


GO
PRINT N'Refreshing [dbo].[UFN_Get_PR_Rights_Criteria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UFN_Get_PR_Rights_Criteria]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_SDM_Title]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_SDM_Title]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW_Syndication]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW_Syndication]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Title_Platform_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Title_Platform_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Syndication_Sales_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syndication_Sales_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Syn_New]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Syn_New]';


GO
PRINT N'Refreshing [dbo].[USP_Bulk_Update]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Bulk_Update]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_Availability]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_Availability]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Final]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Final]';


GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Acquisition_Neo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Acquisition_Neo]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Validation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Validation]';


GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Syndication_Neo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Syndication_Neo]';


GO
PRINT N'Refreshing [dbo].[USP_List_Rights]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Rights]';


GO
PRINT N'Refreshing [dbo].[USP_List_Country]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Country]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Data_Restriction_Remark_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Data_Restriction_Remark_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Generic]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Generic]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Generic_BAK]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Generic_BAK]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Migrate_Syndication]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Migrate_Syndication]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Rights_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Rights_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Audit_Log_Report_for_Territory_and_Language_Group]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Audit_Log_Report_for_Territory_and_Language_Group]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_Asset_Mapping_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_Asset_Mapping_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_Deal_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_Deal_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_Insert_Update_Masters]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_Insert_Update_Masters]';


GO
PRINT N'Refreshing [dbo].[USP_BV_Deal_Data_Generation_bkp16Oct2015]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BV_Deal_Data_Generation_bkp16Oct2015]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Channel_Run_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Channel_Run_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_Dashboard_AcqSyn_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Dashboard_AcqSyn_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_DealReport_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DealReport_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_DM_Title_PIV]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DM_Title_PIV]';


GO
PRINT N'Refreshing [dbo].[USP_Export_Table_To_Excel]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Export_Table_To_Excel]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Dashboard_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Dashboard_Data]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_Availability_LanguageWise]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_Availability_LanguageWise]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_Availability_LanguageWise_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_Availability_LanguageWise_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_Language]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_Language]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Insert_Title_Import_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Insert_Title_Import_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_List_Title_Content_ExportToXml]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Title_Content_ExportToXml]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW]';


GO
PRINT N'Refreshing [dbo].[USP_Provisional_Content_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Provisional_Content_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Acquisition_Neo_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Bind_listbox_Bulk_Update]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Bind_listbox_Bulk_Update]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Bulk_Populate]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Bulk_Populate]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Rights_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Rights_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Details_Report_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Details_Report_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Import_Utility_PII]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Import_Utility_PII]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_Country_Lang]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_Country_Lang]';


GO
PRINT N'Refreshing [dbo].[USPGetRURContentMappedData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPGetRURContentMappedData]';


GO
PRINT N'Refreshing [dbo].[USPListResolveConflict]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPListResolveConflict]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW_Main_Syndication]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW_Main_Syndication]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Rights_Validate]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Rights_Validate]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Delay_Rights_Duplication_Acq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Delay_Rights_Duplication_Acq]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Import_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Import_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW_Main]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW_Main]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Rights_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Rights_Process]';


GO
PRINT N'Update complete.';


GO

CREATE PROCEDURE USPDealStatusReport
(
	@ModuleCode INT=30,
	@BusinessUnitcode VARCHAR(MAX)='',	
	@StartDate NVARCHAR(MAX)='', 
	@EndDate NVARCHAR(MAX)='', 
	@AgreementNo NVARCHAR(MAX) = '',
	@UserCode VARCHAR(MAX)='',
	@Show_Expired CHAR(1) = 'N'
)
AS 
BEGIN	
	--DECLARE
	--@ModuleCode INT=30,
	--@BusinessUnitcode VARCHAR(MAX)='',	
	--@StartDate VARCHAR(MAX)='', 
	--@EndDate VARCHAR(MAX)='', 
	--@AgreementNo NVARCHAR(MAX) = '0',
	--@UserCode VARCHAR(MAX)='1265',
	--@Show_Expired CHAR(1) = 'N'

	If OBJECT_ID('tempdb..#tempMain_Acq') Is Not Null Drop Table #tempMain_Acq
	If OBJECT_ID('tempdb..#tempVersion_1_Acq') Is Not Null Drop Table #tempVersion_1_Acq
	If OBJECT_ID('tempdb..#tempMain_Syn') Is Not Null Drop Table #tempMain_Syn
	If OBJECT_ID('tempdb..#tempVersion_1_Syn') Is Not Null Drop Table #tempVersion_1_Syn

	IF(@StartDate = '' AND @EndDate = '' )
	BEGIN
		SET @StartDate = (SELECT DATEADD(m, -6, GetDate()))--(Select CONVERT(DATE, (SELECT CAST(DATEADD(m, -6, GetDate()) as date)), 103))
		SET @EndDate = GETDATE()
	END

	--Select @StartDate
	
	IF(@ModuleCode = 30)
	BEGIN

		--IF EXISTS (SELECT top 1 * FROM Module_Status_History WHERE Record_Code = @AgreementNo)
		--BEGIN
			SELECT DISTINCT A.Agreement_No AS [Agreement Number], A.Business_Unit_Name AS [Content Category], A.Vendor_Name AS [Licensor], A.[Agreement Date], A.Version_No AS Version, A.Status AS [Status], 
			A.Status_Changed_On AS [Last Updated On], A.[User], A.Remarks, A.Record_Code, A.Status_Changed_On INTO #tempMain_Acq
			FROM (
					Select Record_Code,AD.Agreement_No, BU.Business_Unit_Name, V.Vendor_Name,AD.Inserted_On AS 'Agreement Date', '000' + CAST(MSH.Version_No AS NVARCHAR(MAX)) AS Version_No  ,
					--CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date' 
					--	WHEN MSH.Status = 'AM' THEN 'Deal Amended Date'
					--	WHEN MSH.Status = 'W' THEN 'Send for Approval Date'
					--	WHEN MSH.Status = 'R' THEN 'Deal Reject Date'
					--	WHEN MSH.Status = 'A' THEN 'Approved Date'
					--	ELSE '' END AS Status,
					CASE   WHEN MSH.Status = 'C' THEN 'Deal Creation Date'
						WHEN MSH.Status = 'W' THEN 'Deal Send for Approval Date'
						ELSE 'Deal '+DWS.Deal_Workflow_Status_Name + ' Date' END AS Status,
					MSH.Status_Changed_On ,
					U1.First_Name +' '+ U1.Last_Name AS [User], MSH.Remarks from 
					Acq_Deal AD 
					INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
					INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
					INNER JOIN Acq_Deal_Movie ADM WITH (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
					INNER JOIN Users U WITH (NOLOCK) ON U.Users_Code = AD.Inserted_By
					INNER JOIN Module_Status_History MSH WITH (NOLOCK) ON MSH.Record_Code = AD.Acq_Deal_Code AND MSH.Module_Code = @ModuleCode
					INNER JOIN Users U1 ON MSH.Status_Changed_By = U1.Users_Code
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = AD.Acq_Deal_Code
					LEFT JOIN Deal_Workflow_Status DWS ON DWS.Deal_WorkflowFlag = msh.Status
					WHERE 
					(@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
					AND (@UserCode='' OR (MSH.Status_Changed_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
					AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
					AND (@AgreementNo ='0' OR AD.Acq_Deal_Code = @AgreementNo) 
					AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, MSH.Status_Changed_On, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))
					--order by MSH.Record_Code desc, Status_Changed_On desc
			) AS A
			order by A.Record_Code desc, A.Status_Changed_On desc
		--END
		--ELSE
		--BEGIN
			
			SELECT  AD.Agreement_No AS [Agreement Number], Business_Unit_Name AS [Content Category], V.Vendor_Name AS [Licensor], AD.Agreement_Date AS [Agreement Date],
			CAST(AD.Version AS NVARCHAR(MAX)) AS [Version], 'Deal Creation Date' AS [Status], AD.Inserted_On AS [Last Updated On],u.First_Name +' '+ u.Last_Name AS [User], Ad.Remarks,
			AD.Acq_Deal_Code AS Record_Code, AD.Last_Updated_Time AS Status_Changed_On INTO #tempVersion_1_Acq
			FROM Acq_Deal AD
			INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
			INNER JOIN Users u ON u.Users_Code = AD.Last_Action_By
			WHERE 
			(@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
			AND (@UserCode='' OR (AD.Last_Action_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
			--AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
			AND (@AgreementNo ='0' OR AD.Acq_Deal_Code = @AgreementNo) 
			AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, AD.Last_Updated_Time, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))

		--END

		SELECT * FROM (
		Select * from #tempMain_Acq
		UNION
		Select * from #tempVersion_1_Acq WHERE Record_Code NOT IN (Select Distinct Record_Code from Module_Status_History)--(Select [Agreement Number] from #tempMain_Acq)
	) AS A order by A.Record_Code desc, A.Status_Changed_On desc
	END
	ELSE
	BEGIN
	
		--IF EXISTS (SELECT top 1 * FROM Module_Status_History WHERE Record_Code = @AgreementNo)
		--BEGIN
			SELECT DISTINCT A.Agreement_No AS [Agreement Number], A.Business_Unit_Name AS [Content Category], A.Vendor_Name AS [Licensor], A.[Agreement Date], A.Version_No AS Version, A.Status AS [Status], 
			A.Status_Changed_On AS [Last Updated On], A.[User], A.Remarks, A.Record_Code, A.Status_Changed_On INTO #tempMain_Syn
			FROM (
				Select Record_Code,AD.Agreement_No, BU.Business_Unit_Name, V.Vendor_Name,AD.Inserted_On AS 'Agreement Date', '000' + CAST(MSH.Version_No AS NVARCHAR(MAX))  AS Version_No,
				--CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date' 
				--	WHEN MSH.Status = 'AM' THEN 'Deal Amended Date'
				--	WHEN MSH.Status = 'W' THEN 'Send for Approval Date'
				--	WHEN MSH.Status = 'R' THEN 'Deal Reject Date'
				--	WHEN MSH.Status = 'A' THEN 'Approved Date'
				--	ELSE '' END AS Status,
				CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date'
					WHEN MSH.Status = 'W' THEN 'Deal Send for Approval Date'
					ELSE 'Deal '+DWS.Deal_Workflow_Status_Name + ' Date' END AS Status,
				MSH.Status_Changed_On ,
				U1.First_Name +' '+ U1.Last_Name AS [User], MSH.Remarks 
				FROM Syn_Deal AD 
				INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Business_Unit BU ON AD.Business_Unit_Code = BU.Business_Unit_Code
				INNER JOIN Syn_Deal_Movie ADM ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code
				INNER JOIN Users U ON U.Users_Code = AD.Inserted_By
				INNER JOIN Module_Status_History MSH ON MSH.Record_Code = AD.Syn_Deal_Code AND MSH.Module_Code= @ModuleCode
				INNER JOIN Users U1 ON MSH.Status_Changed_By = U1.Users_Code
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = AD.Syn_Deal_Code
				LEFT JOIN Deal_Workflow_Status DWS ON DWS.Deal_WorkflowFlag = msh.Status
				where (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
				AND (@UserCode='' OR (MSH.Status_Changed_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
				AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
				AND (@AgreementNo ='0' OR AD.Syn_Deal_Code = @AgreementNo) 
				AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, MSH.Status_Changed_On, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))
			) AS A
			order by A.Record_Code desc, A.Status_Changed_On desc

		--END
		--ELSE
		--BEGIN
			
			SELECT  AD.Agreement_No AS [Agreement Number], Business_Unit_Name AS [Content Category], V.Vendor_Name AS [Licensor], AD.Agreement_Date AS [Agreement Date],
			CAST(AD.Version AS NVARCHAR(MAX)) AS Version, 'Deal Creation Date' AS [Status], AD.Inserted_On AS [Last Updated On],u.First_Name +' '+ u.Last_Name AS [User], Ad.Remarks,
			AD.Syn_Deal_Code AS Record_Code, AD.Last_Updated_Time AS Status_Changed_On INTO #tempVersion_1_Syn
			FROM Syn_Deal AD
			INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
			INNER JOIN Users u ON u.Users_Code = AD.Last_Action_By
			WHERE (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
			AND (@UserCode='' OR (AD.Last_Action_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
			--AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
			AND (@AgreementNo ='0' OR AD.Syn_Deal_Code = @AgreementNo) 
			AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, AD.Last_Updated_Time, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))

		--END


		SELECT * FROM (
		Select * from #tempMain_Syn
		UNION
		Select * from #tempVersion_1_Syn WHERE Record_Code NOT IN (Select Distinct Record_Code from Module_Status_History) --WHERE [Agreement Number] NOT IN (Select [Agreement Number] from #tempMain_Syn)
	) AS A order by A.Record_Code desc, A.Status_Changed_On desc
	END
	
	If OBJECT_ID('tempdb..#tempMain_Acq') Is Not Null Drop Table #tempMain_Acq
	If OBJECT_ID('tempdb..#tempVersion_1_Acq') Is Not Null Drop Table #tempVersion_1_Acq
	If OBJECT_ID('tempdb..#tempMain_Syn') Is Not Null Drop Table #tempMain_Syn
	If OBJECT_ID('tempdb..#tempVersion_1_Syn') Is Not Null Drop Table #tempVersion_1_Syn
END

GO
CREATE Procedure USPDealStatusReportFilter
@BusinessUnitcode NVARCHAR(MAX) = '',
@UserCode NVARCHAR(MAX) = '',
@ModuleCode NVARCHAR(MAX) = '',
@AgreementNo NVARCHAR(MAX) = ''
AS
BEGIN
DECLARE @BussinessUnitNames NVARCHAR(MAX),
@UserNames NVARCHAR(MAX)


	
	SET @BussinessUnitNames =ISNULL(STUFF((SELECT DISTINCT ',' + b.Business_Unit_Name      
	FROM Business_Unit b       
	WHERE b.Business_Unit_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@BusinessUnitcode,',') WHERE number NOT IN('0', ''))      
	AND b.Is_Active = 'Y'      
	FOR XML PATH(''), TYPE      
	   ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
	IF(@BusinessUnitcode = '')
	BEGIN
		SET @BussinessUnitNames = 'All Business Unit'
	END
	ELSE
	BEGIN
		SET @BussinessUnitNames= Case when @BusinessUnitcode = '' Then 'NA' ELSE @BussinessUnitNames END
		
	END

	SET @UserNames =ISNULL(STUFF((SELECT DISTINCT ', ' + (b.First_Name+' '+b.Last_Name)      
	FROM Users b       
	WHERE b.Users_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@UserCode,',') WHERE number NOT IN('0', ''))      
	AND b.Is_Active = 'Y'      
	FOR XML PATH(''), TYPE      
	   ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
	IF(@UserCode = '')
	BEGIN
		SET @UserNames = 'All Users'
	END
	ELSE
	BEGIN
		SET @UserNames= Case when @UserCode = '' Then 'NA' ELSE @UserNames END
		
	END

	DECLARE @DealFor NVARCHAR(MAX)=''
	IF(@ModuleCode = 30)
	BEGIN
		SET @DealFor = 'Acquisition Deal'
	END
	ELSE
	BEGIN
		SET @DealFor = 'Syndication Deal'
	END

	DECLARE @AgreementNumber NVARCHAR(MAX)=''

	SET @AgreementNumber = (Select top 1 Agreement_No from Acq_Deal WHERE Acq_Deal_Code = @AgreementNo) 

	Select @BussinessUnitNames AS BusinessUnit, @UserNames AS Users, @DealFor AS Deal, ISNULL(@AgreementNumber,'NA') AS AgreementNumber



END

go


ALTER Procedure [dbo].[USPDealStatusReportFilter]
@BusinessUnitcode NVARCHAR(MAX) = '',
@UserCode NVARCHAR(MAX) = '',
@ModuleCode NVARCHAR(MAX) = '',
@AgreementNo NVARCHAR(MAX) = ''
AS
BEGIN
DECLARE @BussinessUnitNames NVARCHAR(MAX),
@UserNames NVARCHAR(MAX)


	
	SET @BussinessUnitNames =ISNULL(STUFF((SELECT DISTINCT ',' + b.Business_Unit_Name      
	FROM Business_Unit b       
	WHERE b.Business_Unit_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@BusinessUnitcode,',') WHERE number NOT IN('0', ''))      
	AND b.Is_Active = 'Y'      
	FOR XML PATH(''), TYPE      
	   ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
	IF(@BusinessUnitcode = '')
	BEGIN
		SET @BussinessUnitNames = 'All Business Unit'
	END
	ELSE
	BEGIN
		SET @BussinessUnitNames= Case when @BusinessUnitcode = '' Then 'NA' ELSE @BussinessUnitNames END
		
	END

	SET @UserNames =ISNULL(STUFF((SELECT DISTINCT ', ' + (b.First_Name+' '+b.Last_Name)      
	FROM Users b       
	WHERE b.Users_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@UserCode,',') WHERE number NOT IN('0', ''))      
	AND b.Is_Active = 'Y'      
	FOR XML PATH(''), TYPE      
	   ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
	IF(@UserCode = '')
	BEGIN
		SET @UserNames = 'All Users'
	END
	ELSE
	BEGIN
		SET @UserNames= Case when @UserCode = '' Then 'NA' ELSE @UserNames END
		
	END

	DECLARE @DealFor NVARCHAR(MAX)=''
	IF(@ModuleCode = 30)
	BEGIN
		SET @DealFor = 'Acquisition Deal'
	END
	ELSE
	BEGIN
		SET @DealFor = 'Syndication Deal'
	END

	DECLARE @AgreementNumber NVARCHAR(MAX)=''

	SET @AgreementNumber = (Select top 1 Agreement_No from Acq_Deal WHERE Acq_Deal_Code = @AgreementNo) 

	Select @BussinessUnitNames AS BusinessUnit, @UserNames AS Users, @DealFor AS Deal, ISNULL(@AgreementNumber,'NA') AS AgreementNumber



END
go


ALTER PROCEDURE [dbo].[USPDealStatusReport]
(
	@ModuleCode INT=30,
	@BusinessUnitcode VARCHAR(MAX)='',	
	@StartDate NVARCHAR(MAX)='', 
	@EndDate NVARCHAR(MAX)='', 
	@AgreementNo NVARCHAR(MAX) = '',
	@UserCode VARCHAR(MAX)='',
	@Show_Expired CHAR(1) = 'N'
)
AS 
BEGIN	
	--DECLARE
	--@ModuleCode INT=35,
	--@BusinessUnitcode VARCHAR(MAX)='',	
	--@StartDate VARCHAR(MAX)='', 
	--@EndDate VARCHAR(MAX)='', 
	--@AgreementNo NVARCHAR(MAX) = '0',
	--@UserCode VARCHAR(MAX)='',
	--@Show_Expired CHAR(1) = 'N'

	If OBJECT_ID('tempdb..#tempMain_Acq') Is Not Null Drop Table #tempMain_Acq
	If OBJECT_ID('tempdb..#tempVersion_1_Acq') Is Not Null Drop Table #tempVersion_1_Acq
	If OBJECT_ID('tempdb..#tempMain_Syn') Is Not Null Drop Table #tempMain_Syn
	If OBJECT_ID('tempdb..#tempVersion_1_Syn') Is Not Null Drop Table #tempVersion_1_Syn
	If OBJECT_ID('tempdb..#tempReportData') Is Not Null Drop Table #tempReportData
	If OBJECT_ID('tempdb..#tempReportFinalData') Is Not Null Drop Table #tempReportFinalData
	If OBJECT_ID('tempdb..#tempPartion') Is Not Null Drop Table #tempPartion

	CREATE TABLE #tempReportFinalData
	(
		[Agreement Number] NVARCHAR(MAX),
		[Content Category] NVARCHAR(MAX),
		[Licensor] NVARCHAR(MAX),
		[Agreement Date] DATETIME,
		[Version] NVARCHAR(MAX),	
		[Status] NVARCHAR(MAX),
		[Last Updated On] DATETIME,
		[User] NVARCHAR(MAX),
		[Remarks] NVARCHAR(MAX),
		[Record_Code] INT,
		[Status_Changed_On] DATETIME
	)

	DECLARE @tblReportData AS TABLE 
	(
		[Agreement Number] NVARCHAR(MAX),
		[Content Category] NVARCHAR(MAX),
		[Licensor] NVARCHAR(MAX),
		[Agreement Date] DATETIME,
		[Version] NVARCHAR(MAX),	
		[Status] NVARCHAR(MAX),
		[Last Updated On] DATETIME,
		[User] NVARCHAR(MAX),
		[Remarks] NVARCHAR(MAX),
		[Record_Code] INT,
		[Status_Changed_On] DATETIME
	)

	CREATE TABLE #tempReportData
	(
		[DenseRank] INT,
		[Partition] INT,
		[Agreement Number] NVARCHAR(MAX),
		[Content Category] NVARCHAR(MAX),
		[Licensor] NVARCHAR(MAX),
		[Agreement Date] DATETIME,
		[Version] NVARCHAR(MAX),	
		[Status] NVARCHAR(MAX),
		[Last Updated On] DATETIME,
		[User] NVARCHAR(MAX),
		[Remarks] NVARCHAR(MAX),
		[Record_Code] INT,
		[Status_Changed_On] DATETIME
	)

	CREATE TABLE #tempPartion(
		DenseRank INT,
		Status_Changed_On Datetime
	)

	IF(@StartDate = '' AND @EndDate = '' )
	BEGIN
		SET @StartDate = (SELECT DATEADD(m, -6, GetDate()))--(Select CONVERT(DATE, (SELECT CAST(DATEADD(m, -6, GetDate()) as date)), 103))
		SET @EndDate = GETDATE()
	END

	--Select @StartDate
	
	IF(@ModuleCode = 30)
	BEGIN

		--IF EXISTS (SELECT top 1 * FROM Module_Status_History WHERE Record_Code = @AgreementNo)
		--BEGIN
			SELECT DISTINCT A.Agreement_No AS [Agreement Number], A.Business_Unit_Name AS [Content Category], A.Vendor_Name AS [Licensor], A.[Agreement Date], A.Version_No AS Version, A.Status AS [Status], 
			A.Status_Changed_On AS [Last Updated On], A.[User], A.Remarks, A.Record_Code, A.Status_Changed_On INTO #tempMain_Acq
			FROM (
					Select Record_Code,AD.Agreement_No, BU.Business_Unit_Name, V.Vendor_Name,AD.Inserted_On AS 'Agreement Date', '000' + CAST(MSH.Version_No AS NVARCHAR(MAX)) AS Version_No  ,
					--CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date' 
					--	WHEN MSH.Status = 'AM' THEN 'Deal Amended Date'
					--	WHEN MSH.Status = 'W' THEN 'Send for Approval Date'
					--	WHEN MSH.Status = 'R' THEN 'Deal Reject Date'
					--	WHEN MSH.Status = 'A' THEN 'Approved Date'
					--	ELSE '' END AS Status,
					CASE   WHEN MSH.Status = 'C' THEN 'Deal Creation'
						WHEN MSH.Status = 'W' THEN 'Deal Send for Approval'
						WHEN MSH.Status = 'E' THEN 'Deal Updated'
						ELSE 'Deal '+DWS.Deal_Workflow_Status_Name END AS Status,
					MSH.Status_Changed_On ,
					U1.First_Name +' '+ U1.Last_Name AS [User], MSH.Remarks from 
					Acq_Deal AD 
					INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
					INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
					INNER JOIN Acq_Deal_Movie ADM WITH (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
					INNER JOIN Users U WITH (NOLOCK) ON U.Users_Code = AD.Inserted_By
					INNER JOIN Module_Status_History MSH WITH (NOLOCK) ON MSH.Record_Code = AD.Acq_Deal_Code AND MSH.Module_Code = @ModuleCode
					INNER JOIN Users U1 ON MSH.Status_Changed_By = U1.Users_Code
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = AD.Acq_Deal_Code
					LEFT JOIN Deal_Workflow_Status DWS ON DWS.Deal_WorkflowFlag = msh.Status
					WHERE 
					(@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
					AND (@UserCode='' OR (MSH.Status_Changed_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
					AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
					AND (@AgreementNo ='0' OR AD.Acq_Deal_Code = @AgreementNo) 
					AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, MSH.Status_Changed_On, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))
					--order by MSH.Record_Code desc, Status_Changed_On desc
			) AS A
			order by A.Record_Code desc, A.Status_Changed_On desc
		--END
		--ELSE
		--BEGIN
			
			SELECT  AD.Agreement_No AS [Agreement Number], Business_Unit_Name AS [Content Category], V.Vendor_Name AS [Licensor], AD.Agreement_Date AS [Agreement Date],
			CAST(AD.Version AS NVARCHAR(MAX)) AS [Version], 'Deal Creation' AS [Status], AD.Last_Updated_Time AS [Last Updated On],u.First_Name +' '+ u.Last_Name AS [User], Ad.Remarks,
			AD.Acq_Deal_Code AS Record_Code, AD.Last_Updated_Time AS Status_Changed_On INTO #tempVersion_1_Acq
			FROM Acq_Deal AD
			INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
			INNER JOIN Users u ON u.Users_Code = AD.Last_Action_By
			WHERE 
			(@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
			AND (@UserCode='' OR (AD.Last_Action_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
			--AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
			AND (@AgreementNo ='0' OR AD.Acq_Deal_Code = @AgreementNo) 
			AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, AD.Last_Updated_Time, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))

		--END

		INSERT INTO @tblReportData
		SELECT * FROM 
		(
			Select * from #tempMain_Acq
			UNION
			Select * from #tempVersion_1_Acq WHERE Record_Code NOT IN (Select Distinct Record_Code from Module_Status_History)--(Select [Agreement Number] from #tempMain_Acq)
		) AS A 
		order by A.Record_Code desc, A.Status_Changed_On desc
	END
	ELSE
	BEGIN
	
		--IF EXISTS (SELECT top 1 * FROM Module_Status_History WHERE Record_Code = @AgreementNo)
		--BEGIN
			SELECT DISTINCT A.Agreement_No AS [Agreement Number], A.Business_Unit_Name AS [Content Category], A.Vendor_Name AS [Licensor], A.[Agreement Date], A.Version_No AS Version, A.Status AS [Status], 
			A.Status_Changed_On AS [Last Updated On], A.[User], A.Remarks, A.Record_Code, A.Status_Changed_On INTO #tempMain_Syn
			FROM (
				Select Record_Code,AD.Agreement_No, BU.Business_Unit_Name, V.Vendor_Name,AD.Inserted_On AS 'Agreement Date', '000' + CAST(MSH.Version_No AS NVARCHAR(MAX))  AS Version_No,
				--CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date' 
				--	WHEN MSH.Status = 'AM' THEN 'Deal Amended Date'
				--	WHEN MSH.Status = 'W' THEN 'Send for Approval Date'
				--	WHEN MSH.Status = 'R' THEN 'Deal Reject Date'
				--	WHEN MSH.Status = 'A' THEN 'Approved Date'
				--	ELSE '' END AS Status,
				CASE WHEN MSH.Status = 'C' THEN 'Deal Creation'
					WHEN MSH.Status = 'W' THEN 'Deal Send for Approval'
					WHEN MSH.Status = 'E' THEN 'Deal Updated'
					ELSE 'Deal '+DWS.Deal_Workflow_Status_Name END AS Status,
				MSH.Status_Changed_On ,
				U1.First_Name +' '+ U1.Last_Name AS [User], MSH.Remarks 
				FROM Syn_Deal AD 
				INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Business_Unit BU ON AD.Business_Unit_Code = BU.Business_Unit_Code
				INNER JOIN Syn_Deal_Movie ADM ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code
				INNER JOIN Users U ON U.Users_Code = AD.Inserted_By
				INNER JOIN Module_Status_History MSH ON MSH.Record_Code = AD.Syn_Deal_Code AND MSH.Module_Code= @ModuleCode
				INNER JOIN Users U1 ON MSH.Status_Changed_By = U1.Users_Code
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = AD.Syn_Deal_Code
				LEFT JOIN Deal_Workflow_Status DWS ON DWS.Deal_WorkflowFlag = msh.Status
				where (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
				AND (@UserCode='' OR (MSH.Status_Changed_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
				AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
				AND (@AgreementNo ='0' OR AD.Syn_Deal_Code = @AgreementNo) 
				AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, MSH.Status_Changed_On, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))
			) AS A
			order by A.Record_Code desc, A.Status_Changed_On desc

		--END
		--ELSE
		--BEGIN
			
			SELECT  AD.Agreement_No AS [Agreement Number], Business_Unit_Name AS [Content Category], V.Vendor_Name AS [Licensor], AD.Agreement_Date AS [Agreement Date],
			CAST(AD.Version AS NVARCHAR(MAX)) AS Version, 'Deal Creation' AS [Status], AD.Last_Updated_Time AS [Last Updated On],u.First_Name +' '+ u.Last_Name AS [User], Ad.Remarks,
			AD.Syn_Deal_Code AS Record_Code, AD.Last_Updated_Time AS Status_Changed_On INTO #tempVersion_1_Syn
			FROM Syn_Deal AD
			INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
			INNER JOIN Users u ON u.Users_Code = AD.Last_Action_By
			WHERE (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
			AND (@UserCode='' OR (AD.Last_Action_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
			--AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
			AND (@AgreementNo ='0' OR AD.Syn_Deal_Code = @AgreementNo) 
			AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, AD.Last_Updated_Time, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))

		--END

		INSERT INTO @tblReportData
		SELECT * FROM 
		(
			Select * from #tempMain_Syn
			UNION
			Select * from #tempVersion_1_Syn WHERE Record_Code NOT IN (Select Distinct Record_Code from Module_Status_History) --WHERE [Agreement Number] NOT IN (Select [Agreement Number] from #tempMain_Syn)
		) AS A 
		order by A.Record_Code desc, A.Status_Changed_On desc

	END

	BEGIN /* Sorting logic acc to Last Updated time along with same deal*/

		INSERT INTO #tempReportData
		SELECT * FROM 
		(
			Select DENSE_RANK () OVER ( ORDER BY Record_Code) AS DenseRank,
			row_number() over (partition by Record_Code order by Status_Changed_On desc) AS Partion,*
			from @tblReportData 
		) AS A
		ORDER bY Status_Changed_On desc

		INSERT INTO #tempPartion(DenseRank, Status_Changed_On)
		SELECT DenseRank, Status_Changed_On FROM #tempReportData WHERE [Partition] = 1 ORDER bY Status_Changed_On desc

		DECLARE @DenseRank INT

		DECLARE Cur_Report CURSOR FOR SELECT DenseRank FROM #tempPartion order by Status_Changed_On desc
		OPEN Cur_Report
		FETCH NEXT FROM Cur_Report INTO @DenseRank
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			INSERT INTO #tempReportFinalData
			SELECT * FROM 
			(
				SELECT [Agreement Number], [Content Category], [Licensor], [Agreement Date], [Version],	[Status], [Last Updated On], 
				[User], [Remarks], [Record_Code],[Status_Changed_On] 
				FROM #tempReportData WHERE DenseRank = @DenseRank
			) AS curData
			ORDER by curData.Status_Changed_On desc

			FETCH NEXT FROM Cur_Report INTO @DenseRank	
		END
		CLOSE Cur_Report
		DEALLOCATE Cur_Report


		SELECT * FROM #tempReportFinalData

	END
	
	If OBJECT_ID('tempdb..#tempMain_Acq') Is Not Null Drop Table #tempMain_Acq
	If OBJECT_ID('tempdb..#tempVersion_1_Acq') Is Not Null Drop Table #tempVersion_1_Acq
	If OBJECT_ID('tempdb..#tempMain_Syn') Is Not Null Drop Table #tempMain_Syn
	If OBJECT_ID('tempdb..#tempVersion_1_Syn') Is Not Null Drop Table #tempVersion_1_Syn
	If OBJECT_ID('tempdb..#tempReportData') Is Not Null Drop Table #tempReportData
	If OBJECT_ID('tempdb..#tempReportFinalData') Is Not Null Drop Table #tempReportFinalData
	If OBJECT_ID('tempdb..#tempPartion') Is Not Null Drop Table #tempPartion
END

