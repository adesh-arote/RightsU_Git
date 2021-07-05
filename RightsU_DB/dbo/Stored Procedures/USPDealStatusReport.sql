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
