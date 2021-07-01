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
	--@UserCode VARCHAR(MAX)='',
	--@Show_Expired CHAR(1) = 'N'

	IF(@StartDate = '' AND @EndDate = '' )
	BEGIN
		SET @StartDate = (SELECT DATEADD(m, -6, GetDate()))--(Select CONVERT(DATE, (SELECT CAST(DATEADD(m, -6, GetDate()) as date)), 103))
		SET @EndDate = GETDATE()
	END

	--Select @StartDate

	IF(@ModuleCode = 30)
	BEGIN

		SELECT A.Agreement_No AS [Agreement Number], A.Business_Unit_Name AS [Content Category], A.Vendor_Name AS [Licensor], A.[Agreement Date], A.Version_No AS Version, A.Status AS [Status], 
		A.Status_Changed_On AS [Last Updated On], A.[User], A.Remarks 
		FROM (
				Select Record_Code,AD.Agreement_No, BU.Business_Unit_Name, V.Vendor_Name,AD.Inserted_On AS 'Agreement Date', MSH.Version_No ,
				CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date' 
					WHEN MSH.Status = 'AM' THEN 'Deal Amended Date'
					WHEN MSH.Status = 'W' THEN 'Send for Approval Date'
					ELSE 'Approved Date' END AS Status,
				MSH.Status_Changed_On ,
				U1.First_Name +' '+ U1.Last_Name AS [User], Ad.Remarks from 
				Acq_Deal AD 
				INNER JOIN Vendor V WITH (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Business_Unit BU WITH (NOLOCK) ON AD.Business_Unit_Code = BU.Business_Unit_Code
				INNER JOIN Acq_Deal_Movie ADM WITH (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
				INNER JOIN Users U WITH (NOLOCK) ON U.Users_Code = AD.Inserted_By
				INNER JOIN Module_Status_History MSH WITH (NOLOCK) ON MSH.Record_Code = AD.Acq_Deal_Code AND MSH.Module_Code = @ModuleCode
				INNER JOIN Users U1 ON MSH.Status_Changed_By = U1.Users_Code
				INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = AD.Acq_Deal_Code
				WHERE 
				(@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
				AND (@UserCode='' OR (AD.Inserted_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
				AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
				AND (@AgreementNo ='0' OR AD.Acq_Deal_Code = @AgreementNo) 
				AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, AD.Last_Updated_Time, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))
				--order by MSH.Record_Code desc, Status_Changed_On desc
		) AS A
		order by A.Record_Code desc, A.Status_Changed_On desc

	END
	ELSE
	BEGIN
		SELECT A.Agreement_No AS [Agreement Number], A.Business_Unit_Name AS [Content Category], A.Vendor_Name AS [Licensor], A.[Agreement Date], A.Version_No AS Version, A.Status AS [Status], 
		A.Status_Changed_On AS [Last Updated On], A.[User], A.Remarks 
		FROM (
				Select Record_Code,AD.Agreement_No, BU.Business_Unit_Name, V.Vendor_Name,AD.Inserted_On AS 'Agreement Date', MSH.Version_No ,
				CASE WHEN MSH.Status = 'C' THEN 'Deal Creation Date' 
					WHEN MSH.Status = 'AM' THEN 'Deal Amended Date'
					WHEN MSH.Status = 'W' THEN 'Send for Approval Date'
					ELSE 'Approved Date' END AS Status,
				MSH.Status_Changed_On ,
				U1.First_Name +' '+ U1.Last_Name AS [User], Ad.Remarks from 
				Syn_Deal AD 
				INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Business_Unit BU ON AD.Business_Unit_Code = BU.Business_Unit_Code
				INNER JOIN Syn_Deal_Movie ADM ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code
				INNER JOIN Users U ON U.Users_Code = AD.Inserted_By
				INNER JOIN Module_Status_History MSH ON MSH.Record_Code = AD.Syn_Deal_Code AND MSH.Module_Code= @ModuleCode
				INNER JOIN Users U1 ON MSH.Status_Changed_By = U1.Users_Code
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = AD.Syn_Deal_Code
				where (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
				AND (@UserCode='' OR (AD.Inserted_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
				AND ((@Show_Expired = 'N' AND ISNULL(adr.Actual_Right_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'Y')
				AND (@AgreementNo ='0' OR AD.Syn_Deal_Code = @AgreementNo) 
				AND (@StartDate = '' OR @EndDate = '' OR (CONVERT(DATE, AD.Last_Updated_Time, 103) BETWEEN CONVERT(DATE, @StartDate, 103) AND CONVERT(DATE, @EndDate, 103)))
				) AS A
				order by A.Record_Code desc, A.Status_Changed_On desc
	END
END
