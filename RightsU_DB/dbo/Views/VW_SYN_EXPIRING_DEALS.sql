
CREATE View [dbo].[VW_SYN_EXPIRING_DEALS]
As
Select abcd.Platform_Hiearachy AS Platform_Name, abcd.Platform_Count,
MainOutput.* From ( 
	SELECT DISTINCT SD.Syn_Deal_Code, SD.Agreement_No, SD.Deal_Description, SD.Entity_Code, E.Entity_Name, SD.Vendor_Code,
	IsNull((stuff((SELECT DISTINCT ', ' + cast(Vendor_Name as varchar(max))FROM Vendor v1 inner join Acq_Deal_Licensor a1 
	on v1.Vendor_Code=a1.Vendor_Code Where a1.Acq_Deal_Code=SD.Syn_Deal_Code FOR XML PATH('') ), 1, 1, '') ) ,'')as 'Vendor_Name',--SDM.Notes,
	
	T.Title_Code, T.Title_Name, T.Original_Title, SDR.Syn_Deal_Rights_Code, SDR.Right_Start_Date,SDR.Right_End_Date,
	SDR.Is_Tentative, SDR.Is_ROFR, CONVERT(varchar, SDR.ROFR_Date, 106) AS ROFR_Date, R.ROFR_Type ,
	--dbo.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, 'AR') AS 'Country',
	CASE
		WHEN dbo.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, 'SR') = '' THEN dbo.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, 'SR','')
		ELSE dbo.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, 'SR')
	END AS 'Country',
		
	CASE 
		WHEN Right_Start_Date IS NOT NULL AND Right_End_Date IS NOT NULL THEN CONVERT(varchar, Right_Start_Date, 103) + ' - ' +
		CONVERT(varchar, Right_End_Date, 103) 
		WHEN Right_Start_Date IS NOT NULL THEN CONVERT(varchar, Right_Start_Date, 103)
		ELSE ''	
	END AS Right_Period,
	DATEDIFF(dd,GETDATE(),Right_Start_Date) AS 'Start_In_Days', DATEDIFF(dd,GETDATE(),Right_End_Date) AS 'Expire_In_Days',
	DATEDIFF(dd,GETDATE(),ROFR_Date) AS 'ROFR_In_Days',
	
	(stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) FROM Syn_Deal_Rights_Platform adrp 
	Where adrp.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '') ) as PlatformCodes,
	IsNull(Business_Unit_Code,0) as 'Business_Unit_Code'
	
	FROM Syn_Deal SD
	INNER JOIN Entity E ON E.Entity_Code = SD.Entity_Code
	INNER JOIN Vendor V ON V.Vendor_Code = SD.Vendor_Code
	INNER JOIN Syn_Deal_Movie SDM ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code
	INNER JOIN Title T ON T.Title_Code = SDM.Title_Code
	INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Code = SD.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Title ADR_TIT ON ADR_TIT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND ADR_TIT.Title_Code = SDM.Title_Code
	LEFT JOIN ROFR R ON R.ROFR_Code = SDR.ROFR_Code
	WHERE Sd.Deal_Workflow_Status = 'A'
	--INNER JOIN Syn_Deal_Licensor a1 On A1.Vendor_Code=V.Vendor_Code
	--inner join Vendor v on v.Vendor_Code=a.Vendor_Code
) MainOutput
Cross Apply(	
	Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
) as abcd