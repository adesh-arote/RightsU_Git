CREATE PROCEDURE [dbo].[USPDealStatusReport]
(
	@ModuleCode INT=30,
	@BusinessUnitcode VARCHAR(MAX)='',	
	@StartDate NVARCHAR(MAX)='', 
	@EndDate NVARCHAR(MAX)='', 
	@AgreementNo NVARCHAR(MAX) = '',
	@UserCode VARCHAR(MAX)='',
	@Show_Expired CHAR(1) = 'N',
	@DealWorkflowStatus NVARCHAR(MAX) ='0'
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
	--@Show_Expired CHAR(1) = 'N',
	--@DealWorkflowStatus NVARCHAR(MAX) = '0,AM,A,EO,AR,N,R,RO,W,WA'

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

	IF(@AgreementNo <> '0')
	BEGIN
		SET @StartDate = '01JAN1900'
		SET @EndDate = '31DEC9999'
	END

	IF(@StartDate = '' AND @EndDate = '' )
	BEGIN
		SET @StartDate = (SELECT DATEADD(m, -6, GetDate()))--(Select CONVERT(DATE, (SELECT CAST(DATEADD(m, -6, GetDate()) as date)), 103))
		SET @EndDate = GETDATE()
	END

	--Select @StartDate

	DECLARE
	@DealWorkflowStatusCnt INT = (Select COUNT (DISTINCT Deal_WorkflowFlag) from Deal_Workflow_Status ),
	@SelectedWorkflowStatusCnt INT = (SELECT COUNT(number) FROM  dbo.fn_Split_withdelemiter(@DealWorkflowStatus, ','))

	IF(@DealWorkflowStatusCnt = @SelectedWorkflowStatusCnt)
	BEGIN
		SET @DealWorkflowStatus = '0'
	END
	
	--Select @DealWorkflowStatusCnt, @SelectedWorkflowStatusCnt, @DealWorkflowStatus

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
						WHEN MSH.Status = 'E' THEN 'Updated'
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
					AND (@DealWorkflowStatus = '0' OR (MSH.Status IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@DealWorkflowStatus, ','))))
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

			IF(@DealWorkflowStatus <> '0')
			BEGIN
				DELETE FROM #tempVersion_1_Acq
			END

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
					WHEN MSH.Status = 'E' THEN 'Updated'
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
				AND (@DealWorkflowStatus = '0' OR (MSH.Status IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@DealWorkflowStatus, ','))))
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

			IF(@DealWorkflowStatus <> '0')
			BEGIN
				DELETE FROM #tempVersion_1_Syn
			END

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
