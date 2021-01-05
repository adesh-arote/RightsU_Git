
CREATE View [dbo].[VW_ACQ_EXPIRING_DEALS]
As
Select abcd.Platform_Hiearachy AS Platform_Name, abcd.Platform_Count,
MainOutput.* From ( 
	SELECT DISTINCT AD.Acq_Deal_Code, AD.Agreement_No, AD.Deal_Desc, AD.Entity_Code, E.Entity_Name, AD.Vendor_Code,
	IsNull((stuff((SELECT DISTINCT ', ' + cast(Vendor_Name as varchar(max))FROM Vendor v1 inner join Acq_Deal_Licensor a1 
	on v1.Vendor_Code=a1.Vendor_Code Where a1.Acq_Deal_Code=AD.Acq_Deal_Code FOR XML PATH('') ), 1, 1, '') ) ,'')as 'Vendor_Name',ADM.Notes,
	
	T.Title_Code, T.Title_Name, T.Original_Title, ADR.Acq_Deal_Rights_Code, ADR.Right_Start_Date,ADR.Right_End_Date,
	ADR.Is_Tentative, ADR.Is_ROFR, CONVERT(varchar, ADR.ROFR_Date, 106) AS ROFR_Date, R.ROFR_Type ,
	--dbo.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'AR') AS 'Country',
	CASE
		WHEN dbo.UFN_Get_Rights_Territory(ADR.Acq_Deal_Rights_Code, 'AR') = '' THEN dbo.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'AR','')
		ELSE dbo.UFN_Get_Rights_Territory(ADR.Acq_Deal_Rights_Code, 'AR')
	END AS 'Country',
		
	CASE 
		WHEN Right_Start_Date IS NOT NULL AND Right_End_Date IS NOT NULL THEN CONVERT(varchar, Right_Start_Date, 103) + ' - ' +
		CONVERT(varchar, Right_End_Date, 103) 
		WHEN Right_Start_Date IS NOT NULL THEN CONVERT(varchar, Right_Start_Date, 103)
		ELSE ''	
	END AS Right_Period,
	DATEDIFF(dd,GETDATE(),Right_Start_Date) AS 'Start_In_Days', DATEDIFF(dd,GETDATE(),Right_End_Date) AS 'Expire_In_Days',
	DATEDIFF(dd,GETDATE(),ROFR_Date) AS 'ROFR_In_Days',
	
	(stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) FROM Acq_Deal_Rights_Platform adrp 
	Where adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '') ) as PlatformCodes,
	IsNull(Business_Unit_Code,0) as 'Business_Unit_Code'
	
	FROM Acq_Deal AD
	INNER JOIN Entity E ON E.Entity_Code = AD.Entity_Code
	INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Title ADR_TIT ON ADR_TIT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR_TIT.Title_Code = ADM.Title_Code
	LEFT JOIN ROFR R ON R.ROFR_Code = ADR.ROFR_Code
	WHERE AD.Deal_Workflow_Status = 'A'
	--INNER JOIN Acq_Deal_Licensor a1 On A1.Vendor_Code=V.Vendor_Code
	--inner join Vendor v on v.Vendor_Code=a.Vendor_Code
) MainOutput
Cross Apply(	
	Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
) as abcd