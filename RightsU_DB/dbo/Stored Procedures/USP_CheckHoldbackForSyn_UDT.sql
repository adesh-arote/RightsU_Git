CREATE PROC [dbo].[USP_CheckHoldbackForSyn_UDT]
(
	@Deal_Rights Deal_Rights READONLY,
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Territory Deal_Rights_Territory READONLY,	
	@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY
)
AS

--DECLARE @Start_Date VARCHAR(20) --= '01 Feb 2016'
--DECLARE @End_Date VARCHAR(20) --= '01 Feb 2018'
--DECLARE @Territory_Type CHAR(1) --= 'I', @Get_Country_Code VARCHAR(MAX) = ''

--SELECT TOP 1 @Territory_Type = Territory_Type FROM @Deal_Rights_Territory

--SELECT TOP 1 @Start_Date = Right_Start_Date,@End_Date = Right_End_Date FROM @Deal_Rights

--CREATE TABLE #temp_Country
--(
--	Country_Code INT
--)

--IF(@Territory_Type = 'G')
--BEGIN
--	INSERT INTO #temp_Country(Country_Code)
--	SELECT TD.Country_Code 
--	FROM Territory_Details TD 
--	WHERE TD.Territory_Code IN(SELECT Territory_Code FROM @Deal_Rights_Territory)
--END
--ELSE 
--BEGIN
--	INSERT INTO #temp_Country(Country_Code)
--	SELECT Country_Code FROM @Deal_Rights_Territory
--END




--SELECT 
--	A.Acq_Deal_Rights_Code,
--	ADRHD.Language_Code [Dubbing_Lang_Code],
--	ADRHP.Platform_Code, 
--	(CASE WHEN ADRHT.Territory_Type != 'G' THEN ADRHT.Country_Code ELSE ADRHT.Territory_Code END ) Region_Code,
--	ADRHS.Language_Code [Sub_Lan_Code],
--	ADRH.Holdback_Type,A.Is_Title_Language_Right,
--	ADRH.HB_Run_After_Release_No,ADRH.HB_Run_After_Release_Units,ADRH.Holdback_On_Platform_Code,ADRH.Holdback_Release_Date,ADRH.Holdback_Comment
--FROM
--(	
--	SELECT DISTINCT ADR.Acq_Deal_Rights_Code ,ADR.Is_Title_Language_Right
--	FROM Acq_Deal_Rights_Title ADRT
--	INNER JOIN Acq_Deal_Rights ADR ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
--	WHERE Title_Code IN (SELECT Title_Code FROM @Deal_Rights_Title) AND 
--	(
--		(ADR.Right_Start_Date BETWEEN @Start_Date and @End_Date AND
--		ADR.Right_End_Date BETWEEN @Start_Date and @End_Date)
--		OR
--		(@Start_Date BETWEEN ADR.Right_Start_Date and ADR.Right_End_Date AND
--		@End_Date BETWEEN ADR.Right_Start_Date and ADR.Right_End_Date)
--	)
--) A
--INNER JOIN Acq_Deal_Rights_Holdback ADRH ON A.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code
--INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
--INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
--LEFT JOIN Acq_Deal_Rights_Holdback_Dubbing ADRHD ON ADRH.Acq_Deal_Rights_Holdback_Code =  ADRHD.Acq_Deal_Rights_Holdback_Code
--LEFT JOIN Acq_Deal_Rights_Holdback_Subtitling ADRHS ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
--WHERE 
--ADRHP.Platform_Code IN (Select Platform_Code FROM @Deal_Rights_Platform) 
----AND ADRHT.Country_Code = @Country_Code
--AND
--(
--	ADRHT.Country_Code IN(SELECT Country_Code FROM #temp_Country)
--)
--AND 
--(
--	ADRH.Is_Title_Language_Right = 'Y' 
--	OR ADRHD.Language_Code IN (SELECT DR.Language_Group_Code FROM @Deal_Rights_Dubbing DR)
--	OR ADRHS.Language_Code IN (SELECT DRS.Language_Group_Code FROM @Deal_Rights_Subtitling DRS)
--)
select 
	1 Acq_Deal_Rights_Code,
	1 [Dubbing_Lang_Code],
	1 Platform_Code, 
	1 Region_Code,
	1 [Sub_Lan_Code],
	'Y' Holdback_Type,
	'Y' Is_Title_Language_Right,
	1 HB_Run_After_Release_No,
	1 HB_Run_After_Release_Units,
	1 Holdback_On_Platform_Code,
	getdate() Holdback_Release_Date,
	'sda' Holdback_Comment
