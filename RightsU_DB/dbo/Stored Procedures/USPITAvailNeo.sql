CREATE PROCEDURE [dbo].[USPITAvailNeo]
@UDT TitleCriteria readonly
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITAvailNeo]', 'Step 1', 0, 'Started Procedure', 0, ''

	--DECLARE
	--@UDT TitleCriteria	

	IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria

		CREATE TABLE #tempCriteria(
			ValueField NVARCHAR(MAX),
			TextField NVARCHAR(MAX)
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
			USE RightsU_Avail_Neo_V18
			DECLARE @UDT [TitleCriteria]
			INSERT INTO @UDT
			SELECT * FROM #tempCriteria
			EXEC [USPITAvail] @UDT'

			EXEC sp_executesql @EXECSQLUDT

		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITAvailNeo]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END