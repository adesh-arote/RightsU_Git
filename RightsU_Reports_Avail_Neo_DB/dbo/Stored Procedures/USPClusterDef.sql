CREATE PROCEDURE [dbo].[USPClusterDef]
AS
BEGIN
	IF OBJECT_ID('tempdb..#TempCountry') IS NOT NULL DROP TABLE  #TempCountry
 
	Create Table #TempCountry(
		IntCode Int,
		Col1   NVarchar(1000),
		Col2   NVarchar(1000),
		Col3   NVarchar(1000),
		Col4   NVarchar(1000),
		Col5   NVarchar(1000),
		Col6   NVarchar(1000),
		Col7   NVarchar(1000),
		Col8   NVarchar(1000),
		Col9   NVarchar(1000),
		Col10  NVarchar(1000),
		Col11  NVarchar(1000),
		Col12  NVarchar(1000),
		Col13  NVarchar(1000),
		Col14  NVarchar(1000),
		Col15  NVarchar(1000),
		Col16  NVarchar(1000),
		Col17  NVarchar(1000),
		Col18  NVarchar(1000),
		Col19  NVarchar(1000),
		Col20  NVarchar(1000),
		Col21  NVarchar(1000),
		Col22  NVarchar(1000),
		Col23  NVarchar(1000),
		Col24  NVarchar(1000),
		Col25  NVarchar(1000),
		Col26  NVarchar(1000),
		Col27  NVarchar(1000),
		Col28  NVarchar(1000),
		Col29  NVarchar(1000),
		Col30  NVarchar(1000),
		Col31  NVarchar(1000),
		Col32  NVarchar(1000),
		Col33  NVarchar(1000),
		Col34  NVarchar(1000),
		Col35  NVarchar(1000),
		Col36  NVarchar(1000),
		Col37  NVarchar(1000),
		Col38  NVarchar(1000),
		Col39  NVarchar(1000),
		Col40  NVarchar(1000),
		Col41  NVarchar(1000),
		Col42  NVarchar(1000),
		Col43  NVarchar(1000),
		Col44  NVarchar(1000),
		Col45  NVarchar(1000),
		Col46  NVarchar(1000),
		Col47  NVarchar(1000),
		Col48  NVarchar(1000),
		Col49  NVarchar(1000),
		Col50  NVarchar(1000),
		Col51  NVarchar(1000),
		Col52  NVarchar(1000),
		Col53  NVarchar(1000),
		Col54  NVarchar(1000),
		Col55  NVarchar(1000),
		Col56  NVarchar(1000),
		Col57  NVarchar(1000),
		Col58  NVarchar(1000),
		Col59  NVarchar(1000),
		Col60  NVarchar(1000),
		Col61  NVarchar(1000),
		Col62  NVarchar(1000),
		Col63  NVarchar(1000),
		Col64  NVarchar(1000),
		Col65  NVarchar(1000),
		Col66  NVarchar(1000),
		Col67  NVarchar(1000),
		Col68  NVarchar(1000),
		Col69  NVarchar(1000),
		Col70  NVarchar(1000),
		Col71  NVarchar(1000),
		Col72  NVarchar(1000),
		Col73  NVarchar(1000),
		Col74  NVarchar(1000),
		Col75  NVarchar(1000),
		Col76  NVarchar(1000),
		Col77  NVarchar(1000),
		Col78  NVarchar(1000),
		Col79  NVarchar(1000),
		Col80  NVarchar(1000),
		Col81  NVarchar(1000),
		Col82  NVarchar(1000),
		Col83  NVarchar(1000),
		Col84  NVarchar(1000),
		Col85  NVarchar(1000),
		Col86  NVarchar(1000),
		Col87  NVarchar(1000),
		Col88  NVarchar(1000),
		Col89  NVarchar(1000),
		Col90  NVarchar(1000),
		Col91  NVarchar(1000),
		Col92  NVarchar(1000),
		Col93  NVarchar(1000),
		Col94  NVarchar(1000),
		Col95  NVarchar(1000),
		Col96  NVarchar(1000),
		Col97  NVarchar(1000),
		Col98  NVarchar(1000),
		Col99  NVarchar(1000),
		Col100  NVarchar(1000)
	)

	Declare @Counter INT = 0
	SELECT @Counter = Count(*) fROM Country Where Is_Theatrical_Territory = 'N'
	While (@Counter > -1)
	BEGIN
		INSERT INTO #TempCountry(IntCode) Values(@Counter)
		SET @Counter = @Counter - 1
	END
  
	 SET @Counter = 0
	 DECLARE @ReportTerritoryCode VARCHAR(100) = '', @ReportTerritoryName NVARCHAR(1000) = ''
   
	DECLARE CUR_Cluster CURSOR FOR SELECT TOP 100 Report_Territory_Code, Report_Territory_Name
           FROM Report_Territory WHERE Is_Active = 'Y' order by Report_Territory_Name ASC
    OPEN CUR_Cluster
	FETCH NEXT FROM CUR_Cluster InTo @ReportTerritoryCode, @ReportTerritoryName
	WHILE @@FETCH_STATUS<>-1
	BEGIN
		IF(@@FETCH_STATUS<>-2)
		BEGIN
    
		   SET @Counter = @Counter + 1  
		   EXEC('UPDATE #TempCountry SET [Col' + @Counter + '] = ''' + @ReportTerritoryName + ''' where IntCode = 0')  
  
			EXEC('UPDATE  TC set [Col' + @Counter + '] = A.Country_Name FROM #TempCountry TC  
			INNER JOIN   
			(SELECT   
			ROW_NUMBER() OVER(ORDER BY  c.Country_Name ASC) AS Row#,  
			C.Country_Name  
			FROM Report_Territory_Country RTC  
			INNER JOIN Country AS C ON C.Country_Code = RTC.Country_Code AND Report_Territory_Code = ' + @ReportTerritoryCode + ') AS A  
			ON A.Row# = TC.IntCode')  
  
  
			FETCH NEXT FROM CUR_Cluster InTo @ReportTerritoryCode, @ReportTerritoryName  
		END  
	END  
	CLOSE CUR_Cluster      
	DEALLOCATE CUR_Cluster  
  
	SELECT Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24,  
		   Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, 
		   Col46, Col47, Col48, Col49, Col50, Col51, Col52, Col53, Col54, Col55, Col56, Col57, Col58, Col59, Col60, Col61, Col62, Col63, Col64, Col65, Col66, 
		   Col67, Col68, Col69, Col70, Col71, Col72, Col73, Col74, Col75, Col76, Col77, Col78, Col79, Col80, Col81, Col82, Col83, Col84, Col85, Col86, Col87, 
		   Col88, Col89, Col90, Col91, Col92, Col93, Col94, Col95, Col96, Col97, Col98, Col99, Col100
	from #TempCountry ORDER BY IntCode  

	IF OBJECT_ID('tempdb..#TempCountry') IS NOT NULL DROP TABLE  #TempCountry   
END


