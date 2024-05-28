CREATE PROCEDURE [dbo].[USP_Music_Availability_Report]  
(  
	@Music_Label_Code NVARCHAR(MAX),
	@Title_Code NVARCHAR(MAX),
	@Music_Title_Code NVARCHAR(MAX),
	@TitleType NVARCHAR(MAX) 
)  
AS  
BEGIN 

	SET FMTONLY OFF   
	SET NOCOUNT ON

	IF OBJECT_ID('tempdb..#TempAcqData') IS NOT NULL DROP TABLE #TempAcqData

	CREATE TABLE #TempAcqData 
	(    
		Acq_Deal_Code INT  NULL
	)

	--INSERT INTO TestParam (AgreementNo)
	--SELECT 'TitleType: ' + @TitleType

	DECLARE @TitleCodes NVARCHAR(MAX) = '';
	IF(UPPER(@TitleType) = 'MOVIE')
	BEGIN
		SET @TitleCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');  	
	END
	ELSE IF(UPPER(@TitleType) = 'SHOW')
	BEGIN
		SET @TitleCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show');
	END

	INSERT INTO #TempAcqData (Acq_Deal_Code)
	SELECT DISTINCT AD.Acq_Deal_Code AS Acq_Deal_Code
	FROM Acq_Deal AD (NOLOCK)			
		INNER JOIN Acq_Deal_Rights SDR (NOLOCK) ON AD.Acq_Deal_Code=SDR.Acq_Deal_Code 
		INNER JOIN Acq_Deal_Rights_Platform SDRP (NOLOCK) ON SDR.Acq_Deal_Rights_Code=SDRP.Acq_Deal_Rights_Code
	WHERE
		SDRP.Platform_Code IN (
			SELECT number FROM dbo.fn_Split_withdelemiter((SELECT Parameter_Value FROM System_Parameter_New 
			WHERE Parameter_Name='Platform_RightsInSongs_Codes'),',')
		)

	SELECT DISTINCT ad.Agreement_No AS Agreement_No, 
		t.Title_Name AS Title, 
		ml.Music_Label_Name AS Music_Label, 
		mt.Music_Title_Name AS Music_Track, 
		CASE WHEN ISNULL(vwsdd.AvailableForExcel,'') = '' THEN 'Yes' ELSE vwsdd.AvailableForExcel END AS Available_For_Excel, 
		vwsdd.Remarks AS Remark,
		CASE WHEN ISNULL(vwsdd.Syn_Deal_Code,'') = '' THEN 'No' ELSE 'Yes' END AS Syndicated, 
		v.Vendor_Name AS Assignee
	FROM Acq_Deal ad 
		INNER JOIN #TempAcqData tad ON tad.Acq_Deal_Code = ad.Acq_Deal_Code 
		INNER JOIN Acq_Deal_Movie adm ON adm.Acq_Deal_Code = ad.Acq_Deal_Code 
		INNER JOIN Title t ON t.Title_Code = adm.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@TitleCodes,',')) 
		INNER JOIN Music_Title mt ON mt.Title_Code = t.Title_Code
		INNER JOIN Music_Title_Label mtl ON mtl.Music_Title_Code = mt.Music_Title_Code
		INNER JOIN Music_Label ml ON ml.Music_Label_Code = mtl.Music_Label_Code
		LEFT JOIN VW_Syn_Deal_Digital vwsdd ON vwsdd.Title_code = t.Title_Code AND vwsdd.Music_Title_Code = mt.Music_Title_Code
		LEFT JOIN Syn_Deal sd ON sd.Syn_Deal_Code = vwsdd.Syn_Deal_Code
		LEFT JOIN Vendor v ON sd.Vendor_Code = v.Vendor_Code
	WHERE (@Music_Label_Code = '' OR ml.Music_Label_Code IN (select number from fn_Split_withdelemiter(@Music_Label_Code,',')))
			AND (@Title_Code = '' OR t.Title_Code in (select number from fn_Split_withdelemiter(@Title_Code,',')))
			AND (@Music_Title_Code = '' OR mt.Music_Title_Code in (select number from fn_Split_withdelemiter(@Music_Title_Code,',')))

	IF OBJECT_ID('tempdb..#TempAcqData') IS NOT NULL DROP TABLE #TempAcqData

END