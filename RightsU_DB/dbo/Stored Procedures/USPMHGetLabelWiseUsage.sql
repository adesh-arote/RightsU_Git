CREATE PROCEDURE USPMHGetLabelWiseUsage 
@UsersCode INT,
@LabelName NVARCHAR(max), 
@ShowName NVARCHAR(Max),
@NoOfMonths INT
AS
BEGIN
	If OBJECT_ID('tempdb..#tempPie') Is Not Null
		Begin
			Drop Table #tempPie
		End
	If OBJECT_ID('tempdb..#tempLabelName1') Is Not Null
		Begin
			Drop Table #tempLabelName1
		End
	If OBJECT_ID('tempdb..#tempShowNames') Is Not Null
		Begin
			Drop Table #tempShowNames
		End

	Declare @FromDate NVARCHAR(20),@ToDate NVARCHAR(20)
	SET @FromDate =(SELECT CONVERT(VARCHAR(25),DateAdd(month, -(@NoOfMonths), Convert(date, GetDate())),106));
	SET @ToDate = CONVERT(VARCHAR(25),GETDATE(),106)
	PRINT 'FROM DATE: '+ CAST(@FromDate AS NVARCHAR(20))
	PRINT 'To DATE: '+ CAST(@ToDate AS NVARCHAR(20))

	CREATE TABLE #tempLabelName1 (
		LabelName Nvarchar(max) --COLLATE Database_default
	)

	CREATE TABLE #tempShowNames(
		ShowName NVARCHAR(max),
		LabelName NVARCHAR(max),
		Usage INT
	)

	DECLARE @Count INT,@LabelCount INT
	IF(@LabelName = 'Others')
		BEGIN
			print 'others'
			SET @Count = (SELECT Parameter_Value from System_Parameter_New Where Parameter_Name = 'MH_PieChartCount')
			SET @LabelCount = (select Parameter_Value from System_Parameter_New Where Parameter_Name = 'MH_LabelCount')

			SELECT DISTINCT MR.MHRequestCode,MTL.Music_Label_Code,ML.Music_Label_Name,COUNT(MTL.Music_Label_Code) AS LabelCount
			INTO #tempPie
			from MHRequest MR
			INNER JOIN MHRequestDetails MRD  ON MR.MHRequestCode = MRD.MHRequestCode AND MR.TitleCode IS NOT NULL
			LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND (Effective_To IS NULL OR Effective_To BETWEEN Effective_From AND GETDATE())
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			WHERE MR.MHRequestTypeCode = 1 AND  MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
			AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
			GROUP BY MTL.Music_Label_Code,MR.MHRequestCode,ML.Music_Label_Name
			Order by MR.MHRequestCode
		
			INSERT INTO #tempLabelName1(LabelName) 
			SELECT LabelName --INTO #tempLabelName1 
			FROM 
			(
				Select ROW_NUMBER() OVER(ORDER BY SUM(LabelCount) desc) RowNumber,  ISNULL(Music_Label_Name,'') AS LabelName, SUM(LabelCount) AS NoOfLabels1
				FROM #tempPie 
				GROUP BY Music_Label_Name
				)as t
			WHERE t.RowNumber > IIF(@ShowName <> '',@LabelCount,@Count)
			ORDER BY NoOfLabels1 desc
		END
	ELSE
		BEGIN
			print 'no others'
			INSERT INTO #tempLabelName1 VALUES(@LabelName)
			print 'labels complete'
			--select * from #tempLabelName1
		END
	

	IF(@ShowName = '')
		BEGIN
			print 'Show name blank'
			--SELECT Music_Label_Code FROM MUSIC_Label WHERE Music_Label_Name = @LabelName
			--SELECT Music_Title_Code FROM Music_Title_Label WHERE Music_Label_Code IN (SELECT Music_Label_Code FROM MUSIC_Label WHERE Music_Label_Name = @LabelName) AND
			--Effective_To IS NULL

			SELECT DISTINCT MRD.MusicTitleCode,MRD.MHRequestDetailsCode,MR.RequestID AS RequestID,ISNULL(T.Title_Name,'') AS ShowName,MT.Music_Title_Name AS MusicTrackName,MT.Movie_Album,MT.Music_Tag,ISNULL(ML.Language_Name,'') AS MusicLanguage,ISNULL(MT.Release_Year,'') AS YearOfRelease 
			--INTO #tempMusicTitleCode
			FROM MHRequestDetails MRD
			INNER JOIN MHRequest MR ON MRD.MHRequestCode = MR.MHRequestCode AND MR.TitleCode IS NOT NULL AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
			LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode
			INNER JOIN Music_Title MT ON MT.Music_Title_Code = MTL.Music_Title_Code
			LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
			LEFT JOIN Music_Language ML ON ML.Music_Language_Code = MT.Language_Code
			WHERE MR.MHRequestTypeCode = 1 AND MusicTitleCode IN (SELECT Music_Title_Code FROM Music_Title_Label WHERE Music_Label_Code IN (SELECT Music_Label_Code FROM MUSIC_Label WHERE Music_Label_Name COLLATE DATABASE_DEFAULT IN(Select LabelName from #tempLabelName1)-- @LabelName
			) AND
			(Effective_To IS NULL OR Effective_To BETWEEN Effective_From AND GETDATE()))
			AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
			ORDER BY ShowName

		END
	ELSE IF(@ShowName = 'Others')
		BEGIN
			print 'Show name others'
			INSERT INTO #tempShowNames(ShowName,LabelName,Usage)
			EXEC USPMHGetBarChartData @UsersCode,@NoOfMonths 

			SELECT Distinct  MRD.MusicTitleCode,MRD.MHRequestDetailsCode,MR.RequestID AS RequestID,ISNULL(T.Title_Name,'') AS ShowName,MT.Music_Title_Name AS MusicTrackName,MT.Movie_Album,MT.Music_Tag,ISNULL(ML.Language_Name,'') AS MusicLanguage,ISNULL(MT.Release_Year,'') AS YearOfRelease
			FROM MHRequestDetails MRD
			INNER JOIN MHRequest MR ON MRD.MHRequestCode = MR.MHRequestCode AND MR.TitleCode IS NOT NULL AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
			LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode
			INNER JOIN Music_Title MT ON MT.Music_Title_Code = MTL.Music_Title_Code
			LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
			LEFT JOIN Music_Language ML ON ML.Music_Language_Code = MT.Language_Code
			WHERE MR.MHRequestTypeCode = 1 AND MusicTitleCode IN (SELECT Music_Title_Code FROM Music_Title_Label WHERE Music_Label_Code IN (SELECT Music_Label_Code FROM MUSIC_Label WHERE  Music_Label_Name COLLATE DATABASE_DEFAULT IN(Select LabelName from #tempLabelName1)
			) AND
			(Effective_To IS NULL OR Effective_To BETWEEN Effective_From AND GETDATE()))
			AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
			AND T.Title_Name  COLLATE DATABASE_DEFAULT NOT IN  (Select distinct ShowName from #tempShowNames WHERE ShowName <> 'Others')--('Aisha','Zindagi ke Musafir','Weird Wind','Shingham')--= @ShowName
			ORDER BY MT.Music_Title_Name
		END
	ELSE
		BEGIN
		print 'Show name = ' + @ShowName
			SELECT Distinct MRD.MusicTitleCode,MRD.MHRequestDetailsCode,MR.RequestID AS RequestID,ISNULL(T.Title_Name,'') AS ShowName,MT.Music_Title_Name AS MusicTrackName,MT.Movie_Album,MT.Music_Tag,ISNULL(ML.Language_Name,'') AS MusicLanguage,ISNULL(MT.Release_Year,'') AS YearOfRelease
			FROM MHRequestDetails MRD
			INNER JOIN MHRequest MR ON MRD.MHRequestCode = MR.MHRequestCode AND MR.TitleCode IS NOT NULL AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
			LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode
			INNER JOIN Music_Title MT ON MT.Music_Title_Code = MTL.Music_Title_Code
			LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
			LEFT JOIN Music_Language ML ON ML.Music_Language_Code = MT.Language_Code
			WHERE MR.MHRequestTypeCode = 1 AND MusicTitleCode IN (SELECT Music_Title_Code FROM Music_Title_Label WHERE Music_Label_Code IN (SELECT Music_Label_Code FROM MUSIC_Label WHERE  Music_Label_Name COLLATE DATABASE_DEFAULT IN(Select LabelName from #tempLabelName1)
			) AND
			(Effective_To IS NULL OR Effective_To BETWEEN Effective_From AND GETDATE()))
			AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
			AND T.Title_Name = @ShowName
			ORDER BY MT.Music_Title_Name
		END
	IF OBJECT_ID('tempdb..#tempLabelName1') IS NOT NULL DROP TABLE #tempLabelName1
	IF OBJECT_ID('tempdb..#tempMusicTitleCode') IS NOT NULL DROP TABLE #tempMusicTitleCode
	IF OBJECT_ID('tempdb..#tempPie') IS NOT NULL DROP TABLE #tempPie
	IF OBJECT_ID('tempdb..#tempShowNames') IS NOT NULL DROP TABLE #tempShowNames
END


--EXEC USPMHGetLabelWiseUsage 1280,'T-Series',''