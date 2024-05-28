CREATE View VW_NonRenew_Acq_Rights_Platform
As
SELECT Acq_Deal_Rights_Code, Platform_Code
FROM
(
	SELECT adr.Acq_Deal_Rights_Code, ROW_NUMBER() OVER(PARTITION BY 
		Title_Code
		,country_code
		,platform_code 
		--,adr.Is_Title_Language_Right
		--,IsNull(adrs.Language_Code, 0)
		--,IsNull(adrd.Language_Code, 0)
	ORDER BY [Right_Start_Date] Desc ) AS [row],
	platform_code
	From 
	Acq_Deal_Rights adr
	Inner Join Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
	Inner Join Acq_Deal_Rights_Platform adrp On adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
	Inner Join Acq_Deal_Rights_Territory adrc On adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
	Left Join Acq_Deal_Rights_Subtitling adrs On adr.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code
	--Left Join Acq_Deal_Rights_Dubbing adrd On adr.Acq_Deal_Rights_Code = adrd.Acq_Deal_Rights_Code
) b
WHERE b.[row] = 1