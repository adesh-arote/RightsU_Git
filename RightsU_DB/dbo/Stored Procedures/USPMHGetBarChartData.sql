CREATE PROCEDURE [dbo].[USPMHGetBarChartData]
@UsersCode INT,
@NoOfMonths INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetBarChartData]', 'Step 1', 0, 'Started Procedure', 0, ''
		If OBJECT_ID('tempdb..#tempPie') Is Not Null
		Begin
			Drop Table #tempPie
		End
		If OBJECT_ID('tempdb..#tempA') Is Not Null
		Begin
			Drop Table #tempA
		End
		If OBJECT_ID('tempdb..#tmpUnion') Is Not Null
		Begin
			Drop Table #tmpUnion
		End
		If OBJECT_ID('tempdb..#tempFinal') Is Not Null
		Begin
			Drop Table #tempFinal
		End
		If OBJECT_ID('tempdb..#tempLabelName') Is Not Null
		Begin
			Drop Table #tempLabelName
		End
		If OBJECT_ID('tempdb..#TempShow') Is Not Null
		Begin
			Drop Table #TempShow
		End
		If OBJECT_ID('tempdb..#tempP') Is Not Null
		Begin
			Drop Table #tempP
		End
		If OBJECT_ID('tempdb..#tempOthers') Is Not Null
		Begin
			Drop Table #tempOthers
		End
		If OBJECT_ID('tempdb..#tempMergedAll') Is Not Null
		Begin
			Drop Table #tempMergedAll
		End
		If OBJECT_ID('tempdb..#TempPieChart') Is Not Null
		Begin
			Drop Table #TempPieChart
		End
		If OBJECT_ID('tempdb..#tempOtherShows') Is Not Null
		Begin
			Drop Table #tempOtherShows
		End

		Declare @FromDate NVARCHAR(20),@ToDate NVARCHAR(20)
		SET @FromDate =(SELECT CONVERT(VARCHAR(25),DateAdd(month, -(@NoOfMonths), Convert(date, GetDate())),106));
		SET @ToDate = CONVERT(VARCHAR(25),GETDATE(),106)
		PRINT 'FROM DATE: '+ CAST(@FromDate AS NVARCHAR(20))
		PRINT 'To DATE: '+ CAST(@ToDate AS NVARCHAR(20))

		CREATE TABLE #tempLabelName(
		LabelName NVARCHAR(MAX),
		Pos Char(1)
		)

		CREATE TABLE #TempPieChart(
		ds varchar(2),
		LabelName NVARCHAR(MAX),
		NoOfLabels INT 
			)

		DECLARE @BarDataCount INT,@LabelCount INT
		SET @BarDataCount = (select Parameter_Value from System_Parameter_New Where Parameter_Name = 'MH_BarChartCount')

		SET @LabelCount = (select Parameter_Value from System_Parameter_New Where Parameter_Name = 'MH_LabelCount')
		PRINT @BarDataCount
		PRINT @LabelCount

		---- Data for LabelName  -----
		BEGIN 
			--INSERT INTO #TempPieChart
			--EXEC USPMHGetPieChartData @UsersCode
		
			--INSERT INTO #tempLabelName(Pos,LabelName)
			--Select  top(@LabelCount) ds,LabelName from #TempPieChart

			--INSERT INTO #tempLabelName(LabelName, Pos)
			--SELECT 'Others', 'B'
			SELECT DISTINCT MR.MHRequestCode,MRD.MHRequestDetailsCode,MR.RequestID,MTL.Music_Label_Code,ML.Music_Label_Name,COUNT(MTL.Music_Label_Code) AS LabelCount
			INTO #tempP
			from MHRequest MR (NOLOCK)
			INNER JOIN MHRequestDetails MRD (NOLOCK)  ON MR.MHRequestCode = MRD.MHRequestCode
			LEFT JOIN Music_Title_Label MTL (NOLOCK) ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
			LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MTL.Music_Label_Code
			WHERE MR.MHRequestTypeCode = 1 AND  MR.VendorCode In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode)
			AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
			GROUP BY MTL.Music_Label_Code,MR.MHRequestCode,ML.Music_Label_Name,MR.RequestID,MRD.MHRequestDetailsCode
			Order by MR.MHRequestCode
	
			INSERT INTO #tempLabelName(LabelName, Pos)
			SELECT top(@LabelCount) LabelName, 'A' FROM (
			Select ISNULL(Music_Label_Name,'') AS LabelName, SUM(LabelCount) AS NoOfLabels1
			FROM #tempP
			GROUP BY Music_Label_Name
		--	Order BY NoOfLabels1 desc
			) AS t
			ORDER BY t.NoOfLabels1 desc
		
			INSERT INTO #tempLabelName(LabelName, Pos)
			SELECT 'Others', 'B'

		--	Select * from #tempLabelName

		END

		---- Data for BarChart  -----
		BEGIN
			SELECT  MR.MHRequestCode,MR.RequestID,MR.TitleCode,T.Title_Name,MTL.Music_Label_Code,ML.Music_Label_Name,COUNT(MTL.Music_Label_Code) AS LabelCount 
			INTO #tempPie
			from MHRequest MR (NOLOCK)
			INNER JOIN MHRequestDetails MRD  (NOLOCK) ON MR.MHRequestCode = MRD.MHRequestCode AND MR.TitleCode IS NOT NULL
			INNER JOIN Music_Title_Label MTL (NOLOCK) ON MTL.Music_Title_Code = MRD.MusicTitleCode AND (MTL.Effective_To IS NULL OR MTL.Effective_To between MTL.Effective_From AND GETDATE())
			INNER JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MTL.Music_Label_Code
			INNER JOIN Title T  (NOLOCK) ON T.Title_Code = MR.TitleCode
			WHERE MR.MHRequestTypeCode = 1 AND MR.VendorCode In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode)
			AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
			GROUP BY MTL.Music_Label_Code,MR.MHRequestCode,ML.Music_Label_Name,T.Title_Name,MR.TitleCode,MR.RequestID
			Order by MR.MHRequestCode
		
			select Distinct TitleCode,Title_Name AS ShowName,LabelName,sum(Usage) AS Usage INTO #tempA
			from(
			Select Distinct TitleCode,RequestID,Title_Name,ISNULL(Music_Label_Name,'') AS LabelName, SUM(LabelCount) AS Usage from #tempPie 
			GROUP BY TitleCode,Music_Label_Name,Title_Name,MHRequestCode,RequestID) as w
			group by TitleCode,Title_Name,LabelName
			ORder By Title_Name
		END
		--Select * from #tempA 
		BEGIN
			SELECT * INTO #tmpUnion FROM (
			SELECT * FROM (
			SELECT top(@BarDataCount) 'A' AS ds,ShowName,SUM(Usage) AS Usage from #tempA
			GROUP BY ShowName
			ORDER BY Usage desc
			) AS a
			Union
			SELECT 'B' ds,ShowName, SUM(Usage) AS Usage
			FROM 
			(
			Select ROW_NUMBER() OVER(ORDER BY SUM(Usage) desc) RowNumber, 'Others' AS ShowName,SUM(Usage) AS Usage from #tempA
			GROUP BY ShowName
			--ORDER BY Usage desc
			)as t
			WHERE t.RowNumber > @BarDataCount
			GROUP BY ShowName--,RowNumber
			--ORDER BY 1,Usage desc
			) as tmp

			---------------Detailed showName for others----------------
			Select * INTO #tempOtherShows from (
			Select ROW_NUMBER() OVER(ORDER BY SUM(Usage) desc) RowNumber, ShowName AS ShowName,SUM(Usage) AS Usage from #tempA
			GROUP BY ShowName 
			)as t
			WHERE t.RowNumber> @BarDataCount

		END

		----- Union for 
		BEGIN 
			SELECT * INTO #tempFinal FROM(
			SELECT 'A' ds,ShowName,LabelName,Usage from( 
			Select  Row_number() 
					  OVER( 
						partition BY ta.ShowName 
						ORDER BY ta.Usage Desc) AS RowNumber, ta.ShowName,ta.LabelName,ta.Usage from #tmpUnion tu
			INNER JOIN #tempA ta ON ta.ShowName = tu.ShowName
			) as t
			UNION
			SELECT 'B',ShowName,LabelName ,SUM(Usage) AS Usage
			FROM 
			(
			--Select ROW_NUMBER() OVER(ORDER BY SUM(Usage) desc) RowNumber, 'Others' AS ShowName,LabelName,SUM(Usage) AS Usage from #tempA
			--GROUP BY ShowName,LabelName
			Select  Row_number() 
					  OVER( 
						partition BY ta.ShowName 
						ORDER BY ta.Usage Desc) AS RowNumber,'Others' AS ShowName ,ta.LabelName,ta.Usage from #tempOtherShows tu
			INNER JOIN #tempA ta ON ta.ShowName = tu.ShowName

			--ORDER BY Usage desc
			)as t
			--WHERE t.RowNumber > 4
			GROUP BY ShowName,LabelName--,RowNumber
			--ORDER BY 1
			) AS a
		END
		--Select * from #tempFinal
		--Select LabelName from #tempLabelName

		----- Actual Logic to merge Labels and shows----------
		BEGIN
			SELECT * INTO #TempShow from (
			Select Row_number() 
					  OVER( 
						partition BY ta.ShowName 
						ORDER BY ta.Usage Desc) AS RowNumber,* from #tempFinal ta --Order by 2 
			) AS A
			ORDER BY A.ds

			SELECT s.ShowName, l.LabelName,
			ISNULL((
				SELECT s1.Usage FROM #TempShow AS s1 WHERE s1.ShowName COLLATE DATABASE_DEFAULT = s.ShowName COLLATE DATABASE_DEFAULT
				AND s1.LabelName COLLATE DATABASE_DEFAULT = l.LabelName COLLATE DATABASE_DEFAULT
			),0)AS Usage
			INTO #tempMergedAll
			FROM (
				SELECT Distinct ds, ShowName FROM #TempShow
			) As s
			INNER JOIN #tempLabelName l ON 1=1
			Order By s.ds, s.ShowName, l.Pos

			---------This will give Usage total of labels which are there in #tempShow but in #temLabelName 
			select ShowName,'Others' AS LabelName,SUM(Usage) AS Usage INTO  #tempOthers
			from #TempShow ts where LabelName
			COLLATE DATABASE_DEFAULT NOT IN (SELEct LabelName from #tempLabelName)
			GROUP BY ShowName
		
			-------Cursor For Updatin Others label Name with actual usage
			DECLARE @ShowName  VARCHAR(MAX),@LabelName VARCHAR(MAX),@Usage INT
			DECLARE db_cursor CURSOR FOR
				SELECT ShowName,LabelName,Usage FRom #tempMergedAll where Usage = 0
			OPEN db_cursor
			FETCH NEXT FROM db_cursor INTO @ShowName, @LabelName,@Usage
			WHILE @@FETCH_STATUS = 0
			BEGIN
					UPDATE TC
					SET TC.Usage = t3.Usage
					FROM #tempMergedAll TC
					INNER JOIN #tempOthers t3  ON t3.LabelName Collate DATABASE_DEFAULT = tc.LabelName Collate DATABASE_DEFAULT
					AND t3.ShowName Collate DATABASE_DEFAULT = tc.ShowName Collate DATABASE_DEFAULT

				FETCH NEXT FROM db_cursor INTO  @ShowName, @LabelName,@Usage
			END
			CLOSE db_cursor
			DEALLOCATE db_cursor
		
			--SELECT * FROM #tempMergedAll
			DECLARE @Count INT;

			SET @Count = (Select Count(*) from #tmpUnion tu
						 INNER JOIN #tempMergedAll tm ON tm.ShowName COLLATE DATABASE_DEFAULT = tu.ShowName COLLATE DATABASE_DEFAULT)
			--IF(@Count > 0)
			--	BEGIN
					Select tu.ShowName,tm.LabelName,tm.Usage from #tmpUnion tu
					INNER JOIN #tempMergedAll tm ON tm.ShowName COLLATE DATABASE_DEFAULT = tu.ShowName COLLATE DATABASE_DEFAULT
					ORDER BY tu.ds
			--	END
			--ELSE
			--	BEGIN
			--		Select 'NA' AS ShowName,'NA' AS LabelName,0 AS Usage
			--	END
		
		END

		IF OBJECT_ID('tempdb..#temLabelName') IS NOT NULL DROP TABLE #temLabelName
		IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
		IF OBJECT_ID('tempdb..#tempFinal') IS NOT NULL DROP TABLE #tempFinal
		IF OBJECT_ID('tempdb..#tempLabelName') IS NOT NULL DROP TABLE #tempLabelName
		IF OBJECT_ID('tempdb..#tempMergedAll') IS NOT NULL DROP TABLE #tempMergedAll
		IF OBJECT_ID('tempdb..#tempOthers') IS NOT NULL DROP TABLE #tempOthers
		IF OBJECT_ID('tempdb..#tempOtherShows') IS NOT NULL DROP TABLE #tempOtherShows
		IF OBJECT_ID('tempdb..#tempP') IS NOT NULL DROP TABLE #tempP
		IF OBJECT_ID('tempdb..#tempPie') IS NOT NULL DROP TABLE #tempPie
		IF OBJECT_ID('tempdb..#TempPieChart') IS NOT NULL DROP TABLE #TempPieChart
		IF OBJECT_ID('tempdb..#TempShow') IS NOT NULL DROP TABLE #TempShow
		IF OBJECT_ID('tempdb..#tmpUnion') IS NOT NULL DROP TABLE #tmpUnion
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetBarChartData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END