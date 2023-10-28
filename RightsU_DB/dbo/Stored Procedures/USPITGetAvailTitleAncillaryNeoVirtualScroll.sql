CREATE PROCEDURE [dbo].[USPITGetAvailTitleAncillaryNeoVirtualScroll]
@UDT TitleCriteria READONLY,
@IsDDL CHAR(2),
@SearchString NVARCHAR(MAX),
@BufferValue INT,
@BufferIncrementValue INT,
@RecordCount INT OUT
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetAvailTitleAncillaryNeoVirtualScroll]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE
	--@IsDDL CHAR(2) = 'Y',
	--@UDT TitleCriteria	

		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
		IF OBJECT_ID('tempdb..#tempAvailTitles') IS NOT NULL DROP TABLE #tempAvailTitles
		IF OBJECT_ID('tempdb..#tempAvailTitlesFinal') IS NOT NULL DROP TABLE #tempAvailTitlesFinal

		CREATE TABLE #tempCriteria(
			ValueField NVARCHAR(MAX),
			TextField NVARCHAR(MAX)
		)

		CREATE TABLE #tempAvailTitles(
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			ReleaseYear VARCHAR(10)

		) 

		CREATE TABLE #tempAvailTitlesFinal(
			Row_No INT IDENTITY(1,1),
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			ReleaseYear VARCHAR(10)

		) 

		--INSERT INTO @UDT VALUES('Country','1,2,3')
		--INSERT INTO @UDT VALUES('Media Platform','Cable-HITS,IPTV')
		--INSERT INTO @UDT VALUES('Mode of Exploitation','Free,NVOD,Pay' )
		--INSERT INTO @UDT VALUES('PeriodType','Min')
		--INSERT INTO @UDT VALUES('Start Date','12Jan2020')
		--INSERT INTO @UDT VALUES('End Date','12Jan2021')
		--INSERT INTO @UDT VALUES('Exclusivity','Y')
		--INSERT INTO @UDT VALUES('Title Language','1,2,3,4')
		--INSERT INTO @UDT VALUES('Subtitling Language','')
		--INSERT INTO @UDT VALUES('Dubbing Language','')
		--INSERT INTO @UDT VALUES('Licensor','1,2,3,4')
		--INSERT INTO @UDT VALUES('Star Cast','')


		INSERT INTO #tempCriteria
		SELECT * FROM @UDT

		DECLARE @EXECSQLUDT NVARCHAR(MAX) = N'
			USE RightsU_Avail_Neo
			DECLARE @UDT [TitleCriteria]
			INSERT INTO @UDT
			SELECT * FROM #tempCriteria
			EXEC [USPITGetAvailTitleAncillary] @UDT, ''' + CAST(@IsDDL AS VARCHAR) + ''' '

			INSERT INTO #tempAvailTitles(Title_Code, Title_Name, Title_Language, Genre, StarCast, ReleaseYear)
			EXEC sp_executesql @EXECSQLUDT

			INSERT INTO #tempAvailTitlesFinal
			SELECT * FROM #tempAvailTitles

			SET @RecordCount = (Select COUNT(*) from #tempAvailTitlesFinal)

			DECLARE @Start INT,@End INT

			SET @Start = @BufferValue + 1
			SET @End = @BufferValue + @BufferIncrementValue

			Select Title_Code, Title_Name, Title_Language, Genre, StarCast, ReleaseYear from #tempAvailTitlesFinal WHERE Row_No BETWEEN @Start and @End order by 2
		
			--Select * INTO ##tempGlobal FROM @UDT
			--EXECUTE RightsU_Avail_Neo.dbo.USPITGetAvailTitle 
		
			IF OBJECT_ID('tempdb..##tempGlobal') IS NOT NULL DROP TABLE ##tempGlobal
			IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
			IF OBJECT_ID('tempdb..#tempAvailTitles') IS NOT NULL DROP TABLE #tempAvailTitles
			IF OBJECT_ID('tempdb..#tempAvailTitlesFinal') IS NOT NULL DROP TABLE #tempAvailTitlesFinal

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetAvailTitleAncillaryNeoVirtualScroll]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END