﻿CREATE PROCEDURE [dbo].[USPITGetAvailTitleNeo]
@UDT TitleCriteria READONLY,
@IsDDL CHAR(2)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetAvailTitleNeo]', 'Step 1', 0, 'Started Procedure', 0, ''

	--DECLARE
	--@IsDDL CHAR(2) = 'Y',
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
			EXEC [USPITGetAvailTitle] @UDT, ''' + CAST(@IsDDL AS VARCHAR) + ''' '

			EXEC sp_executesql @EXECSQLUDT


	
		--Select * INTO ##tempGlobal FROM @UDT
		--EXECUTE RightsU_Avail_Neo.dbo.USPITGetAvailTitle 
	
		IF OBJECT_ID('tempdb..##tempGlobal') IS NOT NULL DROP TABLE ##tempGlobal
		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetAvailTitleNeo]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END