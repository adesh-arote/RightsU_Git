ALTER PROCEDURE USPMHGetMaxVendorCodes
	@LastRequiredDate VARCHAR(20) = '',
	@DealTypeCode VARCHAR(MAX) = '',
	@BusinessUnitCode VARCHAR(MAX) = ''

--Created By : Darshana
AS
BEGIN
		IF(OBJECT_ID('TEMPDB..#TempVendor') IS NOT NULL)  
			DROP TABLE #TempVendor
		
		IF(OBJECT_ID('TEMPDB..#TempProdVendors') IS NOT NULL)  
			DROP TABLE #TempProdVendors
		 
		SELECT MR.VendorCode,Count(MRD.MHRequestCode) as SongsCount 
		INTO #TempVendor FROM MHRequest MR 
			INNER JOIN MHRequestDetails MRD ON MRD.MHRequestCode =  MR.MHRequestCode 
			LEFT JOIN Vendor V ON V.Vendor_Code = MR.VendorCode
			LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
			LEFT JOIN Music_Deal_LinkShow MDL ON MDL.Title_Code = T.Title_Code
			LEFT JOIN Music_Deal MD ON MD.Music_Deal_Code = MDL.Music_Deal_Code
		WHERE 
		MR.MHRequestTypeCode = 1 AND MR.VendorCode IS NOT NULL AND (CONVERT(DATE,MR.RequestedDate,103)  >= (CONVERT(DATE,@LastRequiredDate,103)))
		AND (@DealTypeCode = '' OR T.Deal_Type_Code in (select number from dbo.fn_Split_withdelemiter(''+@DealTypeCode+'',','))) 
		AND (@BusinessUnitCode = '' OR MD.Business_Unit_Code IN(select number from dbo.fn_Split_withdelemiter(''+@BusinessUnitCode+'',','))) 
		GROUP BY MR.MHRequestCode , MR.VendorCode  ORDER BY MR.VendorCode DESC

		SELECT DISTINCT TOP (select CAST(Parameter_Value as int) from System_Parameter_New where Parameter_Name = 'MH_TotalProductionHouseCount') VendorCode, sum(SongsCount) AS SongsCount 
		INTO #TempProdVendors  FROM #TempVendor GROUP BY VendorCode ORDER BY SongsCount DESC  
	
		SELECT  STUFF((
            SELECT DISTINCT  ',' + CAST(VendorCode AS NVARCHAR(MAX)) FROM #TempProdVendors FOR XML PATH('')
            ), 1, 1, '') AS VendorCodes
	
END

--EXEC USPMHGetMaxVendorCodes '','',''

--CREATE PROCEDURE USPMHGetMaxVendorCodes
--	@LastRequiredDate VARCHAR(20) = ''
--AS
--BEGIN
--	SELECT  '' AS VendorCodes
--END




