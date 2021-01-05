CREATE PROCEDURE [dbo].[USP_Get_Title_Availability_LanguageWise]
(
	@Title_Code VARCHAR(MAX), 
	@Platform_Code VARCHAR(MAX),
    @Country_Code VARCHAR(MAX),
	@Is_Original_Language bit,
	@Dubbing_Subtitling Varchar(20)
)
AS
-- =============================================
-- Author:		Rajesh J. Godse
-- Create date: 13 March 2015
-- Description:	Get title availability report languagewise
-- =============================================
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #tempTitleAvail
	(
		Avail_Acq_Code int,
		Title_Code int,
		Platform_Code int,
		Country_Code int,
		Right_Start_Date varchar(12),
		Rights_End_Date varchar(12),
		[Type] varchar(1),
		Language_Code int
	)


    IF(@Is_Original_Language = 1)
	BEGIN
	INSERT INTO #tempTitleAvail(Avail_Acq_Code,Title_Code,Platform_Code,Country_Code,Right_Start_Date,Rights_End_Date,[Type],Language_Code)
	Select distinct AA.Avail_Acq_Code,AA.Title_Code,AA.Platform_Code,AA.Country_Code,CONVERT(varchar(12), AAD.Rights_Start_Date,106) AS Right_Start_Date,Convert(varchar(12), AAD.Rights_End_Date,106) AS Right_End_Date,'O' AS [Type],t.Title_Language_Code
	from Avail_Acq AA
	INNER JOIN Avail_Acq_Details AAD ON AA.Avail_Acq_Code = AAD.Avail_Acq_Code
	INNER JOIN Title t ON AA.Title_Code = t.Title_Code
	WHERE ((AA.Title_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Code,',') ) AND @Title_Code <> '0') OR @Title_Code = '0')
	AND ((AA.Platform_Code in ( Select Platform_Code from [Platform] Where Base_Platform_Code in (select number from dbo.fn_Split_withdelemiter(@Platform_Code,','))) AND @Platform_Code <> '0') OR @Platform_Code = '0')
	AND ((AA.Country_Code in (select number from dbo.fn_Split_withdelemiter(@Country_Code,',') ) AND @Country_Code <> '0') OR @Country_Code = '0')
	END

	IF(@Dubbing_Subtitling <> '0')
	BEGIN
	INSERT INTO #tempTitleAvail(Avail_Acq_Code,Title_Code,Platform_Code,Country_Code,Right_Start_Date,Rights_End_Date,[Type],Language_Code)
	Select distinct AA.Avail_Acq_Code,AA.Title_Code,AA.Platform_Code,AA.Country_Code,
	(Select CONVERT(varchar(12), Rights_Start_Date,106) from Avail_Acq_Details Where Avail_Acq_Code = AA.Avail_Acq_Code) AS Right_Start_Date,
	(Select CONVERT(varchar(12), Rights_End_Date,106) from Avail_Acq_Details Where Avail_Acq_Code = AA.Avail_Acq_Code) AS Right_End_Date, [Type] = AAL.Dubbing_Subtitling ,AAL.Language_Code
	from Avail_Acq AA
	INNER JOIN Avail_Acq_Language AAL ON AA.Avail_Acq_Code = AAL.Avail_Acq_Code
	WHERE ((AA.Title_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Code,',') ) AND @Title_Code <> '0') OR @Title_Code = '0')
	AND ((AA.Platform_Code in ( Select Platform_Code from [Platform] Where Base_Platform_Code in (select number from dbo.fn_Split_withdelemiter(@Platform_Code,','))) AND @Platform_Code <> '0') OR @Platform_Code = '0')
	AND ((AA.Country_Code in (select number from dbo.fn_Split_withdelemiter(@Country_Code,',') ) AND @Country_Code <> '0') OR @Country_Code = '0')
	AND AAL.Dubbing_Subtitling in (select number from dbo.fn_Split_withdelemiter(@Dubbing_Subtitling,','))
	END

	Select  MainOutput.Title_Name,
	abcd.Platform_Hiearachy Platform_Name,
	MainOutput.Country_Name,
	MainOutput.Right_Start_Date,
	MainOutput.Rights_End_Date,
	CASE
	WHEN [TYPE] = 'O' THEN 'Title Language'
	WHEN [TYPE] = 'D' THEN 'Dubbing'
	WHEN [TYPE] = 'S' THEN 'Subtitling'
	END [TYPE],
	MainOutput.Language_Name
	from
	(Select *,
			STUFF(
			(Select Distinct ', ' + C.Country_Name
				From #tempTitleAvail b
				INNER JOIN Country C ON b.Country_Code = C.Country_Code
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
				AND a.[Type] = b.[Type]
			FOR XML PATH('')), 1, 1, '') as Country_Name,
			STUFF(
			(Select Distinct ', ' + CAST(Platform_Code as Varchar) From #tempTitleAvail b
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
				AND a.[Type] = b.[Type]
			FOR XML PATH('')), 1, 1, '') as Platform_Code,
			STUFF(
			(Select Distinct ', ' + CAST(L.Language_Name as NVARCHAR)
				From #tempTitleAvail b
				INNER JOIN [Language] L ON b.Language_Code=L.Language_Code
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
				AND a.[Type] = b.[Type]
			FOR XML PATH('')), 1, 1, '') as Language_Name
			From(Select ta.Title_Code,t.Title_Name,ta.Type,ta.Right_Start_Date,ta.Rights_End_Date from #tempTitleAvail ta
	INNER JOIN Title t ON t.Title_Code = ta.Title_Code
	GROUP BY ta.Title_Code,t.Title_Name,ta.Type,ta.Right_Start_Date,ta.Rights_End_Date) as a) as MainOutput
		Cross Apply(	
			Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
		) as abcd

		IF OBJECT_ID('tempdb..#tempTitleAvail') IS NOT NULL DROP TABLE #tempTitleAvail

END