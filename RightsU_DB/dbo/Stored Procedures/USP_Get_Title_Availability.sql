
alter PROCEDURE [dbo].[USP_Get_Title_Availability] 
	-- Add the parameters for the stored procedure here
	@Platform_Code Varchar(Max),
	@strTitleCode Varchar(MAX),                      
	@Business_Unit varchar(2) ,                      
	@StartDate Varchar(50) ,--dd/MM/yyyy                      
	@EndDate Varchar(50), --dd/MM/yyyy                
	@Country_Code Varchar(Max) 
AS
-- =============================================
-- Author:		<Rajesh Godse>
-- Create date: <26 Nov 2014>
-- Description:	<Title Availability Report>
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
Select t.Title_Code, t.Title_Name,ISNULL(g.Genres_Name,'') Genres_Name,
	Star_Cast = [dbo].[UFN_GetStarCastForTitle](t.Title_Code),
	Director = [dbo].[UFN_GetDirectorForTitle](t.Title_Code),
COALESCE(t.Duration_In_Min,'0') Duration_In_Min,COALESCE(t.Year_Of_Production,'') Year_Of_Production,ISNULL(l.Language_Name,'') Language_Name INTO #temp
from Title t
LEFT OUTER JOIN Title_Geners AS tg ON t.Title_Code =tg.Title_Code
LEFT OUTER JOIN Genres AS g ON tg.Genres_Code = g.Genres_Code
LEFT OUTER JOIN [Language] AS l ON t.Title_Language_Code = l.Language_Code
 WHERE((@strTitleCode<>'0' AND t.Title_Code in (Select number from fn_Split_withdelemiter(@strTitleCode,','))) OR @strTitleCode = '0')

Select d.Acq_Deal_Code,a.Country_Code,a.Platform_Code,d.Avail_Acq_Details_Code,d.Rights_Start_Date,
    d.Rights_End_Date,l.Avail_Acq_Language,l.Dubbing_Subtitling,t.Title_Code, t.Title_Name,t.Genres_Name,
	t.Star_Cast,
	t.Director,
t.Duration_In_Min,t.Year_Of_Production,t.Language_Name	INTO #tem
	FROM Avail_Acq AS a 
	INNER JOIN Avail_Acq_Details AS d ON a.Avail_Acq_Code = d.Avail_Acq_Code
	INNER JOIN #temp t ON a.Title_Code = t.Title_Code
	LEFT OUTER JOIN Avail_Acq_Language AS l ON a.Avail_Acq_Code = l.Avail_Acq_Code
	WHERE((@strTitleCode<>'0' AND a.Title_Code in (Select number from fn_Split_withdelemiter(@strTitleCode,','))) OR @strTitleCode = '0')
	AND ((@Platform_Code<>'0' AND a.Platform_Code in (Select number from fn_Split_withdelemiter(@Platform_Code,','))) OR @Platform_Code = '0')
	AND ((@Country_Code<>'0' AND a.Country_Code in (Select number from fn_Split_withdelemiter(@Country_Code,','))) OR @Country_Code = '0')

Select MainOutput.Acq_Deal_Code,
	MainOutput.Country_Name,
	abcd.Platform_Hiearachy,
	abcd.Platform_Code,
	MainOutput.Rights_Start_Date,
	MainOutput.Rights_End_Date ,
	MainOutput.Title_Code,
	MainOutput.Title_Name,
	MainOutput.Genres_Name,
	MainOutput.Star_Cast,
	MainOutput.Director,MainOutput.Duration_In_Min,MainOutput.Year_Of_Production,MainOutput.Language_Name
	INTO #tempAvail
	from 
	(Select *,
			STUFF(
			(Select Distinct ', ' + C.Country_Name
				From #tem b
				INNER JOIN Country C ON b.Country_Code = C.Country_Code
				Where a.Title_Code = b.Title_Code And a.Rights_Start_Date = b.Rights_Start_Date AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
				AND a.Genres_Name = b.Genres_Name AND a.Star_Cast = b.Star_Cast AND a.Director = b.Director
				AND a.Duration_In_Min = b.Duration_In_Min AND a.Year_Of_Production = b.Year_Of_Production AND a.Language_Name = b.Language_Name
			FOR XML PATH('')), 1, 1, '') as Country_Name,
			STUFF(
			(Select Distinct ', ' + CAST(Platform_Code as Varchar) From #tem b
				Where a.Title_Code = b.Title_Code And a.Rights_Start_Date = b.Rights_Start_Date AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
				AND a.Genres_Name = b.Genres_Name AND a.Star_Cast = b.Star_Cast AND a.Director = b.Director
				AND a.Duration_In_Min = b.Duration_In_Min AND a.Year_Of_Production = b.Year_Of_Production AND a.Language_Name = b.Language_Name
			FOR XML PATH('')), 1, 1, '') as Platform_Code
			From
	(Select  t.Acq_Deal_Code,t.Rights_Start_Date,t.Rights_End_Date,t.Title_Code,t.Title_Name,t.Genres_Name,t.Star_Cast,t.Director,t.Duration_In_Min,t.Year_Of_Production,t.Language_Name from #tem t
	GROUP BY t.Acq_Deal_Code,t.Rights_Start_Date,t.Rights_End_Date,t.Title_Code,t.Title_Name,t.Genres_Name,t.Star_Cast,t.Director,t.Duration_In_Min,t.Year_Of_Production,t.Language_Name) as a) as MainOutput
	Cross Apply(	
			Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
		) as abcd
	
	Select ar.Acq_Deal_Code,ar.Restriction_Remarks,adrp.Platform_Code,ADRT.Title_Code INTO #tempRight from Acq_Deal_Rights AS ar
INNER JOIN Acq_Deal_Rights_Platform AS adrp ON adrp.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Title AS ADRT ON ADRT.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	WHERE((@strTitleCode<>'0' AND ADRT.Title_Code in (Select number from fn_Split_withdelemiter(@strTitleCode,','))) OR @strTitleCode = '0')

 Declare @strQuery Varchar(MAX)
 SET @strQuery = 'select * from 
	(SELECT DISTINCT Title = tem.Title_Name, Title_Language = tem.Language_Name,Available_Regions = tem.Country_Name
,Available_Platforms = tem.Platform_Hiearachy,
Right_Start_Date = CONVERT(VARCHAR(11),tem.Rights_Start_Date,106) ,Right_End_Date = coalesce(CONVERT(VARCHAR(11),tem.Rights_End_Date,106),''Perpetuity'',''''), Genre = tem.Genres_Name,
Star_Cast = tem.Star_Cast,Year_Of_Release = tem.Year_Of_Production,Director = tem.Director,
Duration = tem.Duration_In_Min,Restriction_Remark = CASE WHEN ad.Is_Master_Deal = ''Y''THEN tr.Restriction_Remarks ELSE '''' END,
Sub_Deal_Restriction_Remark = CASE WHEN ad.Is_Master_Deal = ''N'' THEN tr.Restriction_Remarks ELSE '''' END,
Remarks= ad.Remarks ,Rights_Remarks =ISNULL(ad.Rights_Remarks,''''),Payment_terms_conditions=ISNULL(ad.Payment_Remarks,'''')
from #tempAvail AS tem
	INNER JOIN Acq_Deal AS ad ON tem.Acq_Deal_Code = ad.Acq_Deal_Code
	INNER JOIN #tempRight AS tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
	and tr.Platform_Code = tem.Platform_Code and tr.Title_Code = tem.Title_Code
	WHERE  ad.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND tem.Rights_Start_Date >= '''+@StartDate+''' and ((tem.Rights_End_Date<= '''+@EndDate+''' AND tem.Rights_End_Date IS NOT NULL) OR tem.Rights_End_Date IS NULL) and ad.Business_Unit_Code = '+ @Business_Unit +'
	)
	as a
	order by a.Title,a.Available_Platforms,a.Available_Regions,CONVERT(datetime,a.Right_Start_Date) 
	'
	Print @strQuery
	EXECUTE(@strQuery)
END