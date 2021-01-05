CREATE PROCEDURE USPMHGetPieChartData 
@UsersCode INT,
@NoOfMonths INT= 1
AS
BEGIN
	If OBJECT_ID('tempdb..#tempPie') Is Not Null
	Begin
		Drop Table #tempPie
	End
	If OBJECT_ID('tempdb..#FinalCount') Is Not Null
	Begin
		Drop Table #FinalCount
	End
	
	
	Declare @FromDate NVARCHAR(20),@ToDate NVARCHAR(20)
	SET @FromDate =(SELECT CONVERT(VARCHAR(25),DateAdd(month, -(@NoOfMonths), Convert(date, GetDate())),106));
	SET @ToDate = CONVERT(VARCHAR(25),GETDATE(),106)
	PRINT 'FROM DATE: '+ CAST(@FromDate AS NVARCHAR(20))
	PRINT 'To DATE: '+ CAST(@ToDate AS NVARCHAR(20))

	SELECT DISTINCT MR.MHRequestCode,MTL.Music_Label_Code,ML.Music_Label_Name,COUNT(MTL.Music_Label_Code) AS LabelCount
	INTO #tempPie
	from MHRequest MR
	INNER JOIN MHRequestDetails MRD  ON MR.MHRequestCode = MRD.MHRequestCode AND MR.TitleCode IS NOT NULL
	INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND (MTL.Effective_To IS NULL OR MTL.Effective_To Between MTL.Effective_From AND GETDATE())
	INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
	WHERE MR.MHRequestTypeCode = 1 AND  MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
	AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	GROUP BY MTL.Music_Label_Code,MR.MHRequestCode,ML.Music_Label_Name
	Order by MR.MHRequestCode
	
	DECLARE @Count INT
	SET @Count = (select Parameter_Value from System_Parameter_New where Parameter_Name = 'MH_PieChartCount')
	PRINT @Count

	SELECT * --INTO #FinalCount
	FROM (
		Select  top (@Count) 'A' ds, ISNULL(Music_Label_Name,'') AS LabelName, SUM(LabelCount) AS NoOfLabels1
		FROM #tempPie 
		GROUP BY Music_Label_Name
		Order BY NoOfLabels1 desc
	) AS a
	UNION 
	SELECT 'B' ds, LabelName, SUM(NoOfLabels1) AS NoOfLabels1
	FROM 
	(
		Select ROW_NUMBER() OVER(ORDER BY SUM(LabelCount) desc) RowNumber, 'Others' AS LabelName, SUM(LabelCount) AS NoOfLabels1
		FROM #tempPie 
		GROUP BY Music_Label_Name
		)as t
	WHERE t.RowNumber > @Count
	GROUP BY LabelName--,RowNumber
	ORDER BY 1, NoOfLabels1 desc


	--DECLARE @CountRequests INT
	--SET @CountRequests = (Select Count(*) from #FinalCount)

	--IF(@CountRequests > 0)
	--	BEGIN
	--		Select * from #FinalCount
	--	END
	--ELSE
	--	BEGIN
	--		Select 'A' AS ds,'NA' AS LabelName,0 AS NoOfLabels 
	--	END

	--select Distinct STUFF((SELECT ', ' + t1.LabelName 
 --        from #tempA t1
 --           FOR XML PATH(''), TYPE
 --           ).value('.', 'NVARCHAR(MAX)') 
 --       ,1,2,'') Labels,
	--	STUFF((SELECT ', ' + CAST(t2.NoOfLabels1 AS nvarchar(5)) Usage
 --        from #tempA t2
 --        --where t.[user] = t1.[user]
 --           FOR XML PATH(''), TYPE
 --           ).value('.', 'NVARCHAR(MAX)') 
 --       ,1,2,'') AS Data
	--	from #tempA t;

	--Select * from #tempA
	--Select RowNo = ROW_NUMBER() OVER (ORDER BY Music_Label_Name), ISNULL(Music_Label_Name,'') AS LabelName
	--from #tempPie 
	--GROUP BY Music_Label_Name

	--DROP TABLE #tempPie
	--DROP TABLE #tempA

	IF OBJECT_ID('tempdb..#FinalCount') IS NOT NULL DROP TABLE #FinalCount
	--IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
	IF OBJECT_ID('tempdb..#tempPie') IS NOT NULL DROP TABLE #tempPie
END