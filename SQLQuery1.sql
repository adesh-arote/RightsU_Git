		select * from Acq_deal where agreement_no = 'A-2021-00073'
		SELECT * FROM ACQ_dEAL WHERE ACQ_dEAL_CODE = 15094
		select * from title where title_name = 'Sankala Jey' --36673

		select * from acq_Deal_rights where right_type = 'U' order by 1 desc

		select * from acq_Deal_rights where Acq_deal_code =21739 and acq_deal_Rights_code in (34360,34362)

	select * from acq_Deal_rights_platform adrp
	inner join acq_deal
	where Platform_Code in (SELECT number from dbo.fn_Split_withdelemiter( '17,20,21,22',','))

	SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN acq_Deal_rights_platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
	WHERE ADR.Actual_Right_End_Date >= GETDATE() AND ADR.Acq_Deal_Code = 21739 AND ADM.Title_Code = 36673
		AND ADRP.Platform_Code in (SELECT number from dbo.fn_Split_withdelemiter( '17,20,21,22',','))

		SP_helptext USP_Title_Objection_PreReq

		select * from Deal_Expiry_Email where Alert_Type = 'W'
		Poonam.Upadhyay@indiacast.com,anil.lale@viacom18.com,rms@viacom18.com;Nupur.Mishra@indiacast.com
		select * from Business_Unit
		shruti.gupta@viacom18.com,rms@viacom18.com,anil.lale@viacom18.com,prateek.garg@viacom18.com,pritish.sahoo@viacom18.com,ujjwal.parashar@viacom18.com;Namrata.Adlakha@viacom18.com
		select 
		Shruti.Gupta@viacom18.com;rms@viacom18.comprateek.garg@viacom18.com;pritish.sahoo@viShaheed.Degani@viacom18.com;Sandhya.Saxena@viacom18.com;Rohan.Lavsi@viacom18.comacom18.com;ujjwal.parashar@viacom18.com;Namrata.Adlakha@viacom18.com
		Shaheed.Degani@viacom18.com;Sandhya.Saxena@viacom18.com;Rohan.Lavsi@viacom18.com
		select BU.Business_Unit_Name, DEM.Alert_Type, DEM.* from Deal_Expiry_Email DEM
		INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = DEM.Business_Unit_Code 
		where Alert_Type = 'W' 
		ORDER BY DEM.Alert_Type, Business_Unit_Name

