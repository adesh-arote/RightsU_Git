IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'Is_SelfUtilization_inReport')	
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,IsActive)
	VALUES('Is_SelfUtilization_inReport','Y','Y')
END


GO
CREATE TYPE [dbo].[Email_Config_Users_UDT] AS TABLE (
    [Email_Config_Users_UDT_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Email_Config_Code]           INT            NULL,
    [Email_Body]                  NVARCHAR (MAX) NULL,
    [To_Users_Code]               NVARCHAR (MAX) NULL,
    [To_User_Mail_Id]             NVARCHAR (MAX) NULL,
    [CC_Users_Code]               NVARCHAR (MAX) NULL,
    [CC_User_Mail_Id]             NVARCHAR (MAX) NULL,
    [BCC_Users_Code]              NVARCHAR (MAX) NULL,
    [BCC_User_Mail_Id]            NVARCHAR (MAX) NULL,
    [Subject]                     NVARCHAR (MAX) NULL);


GO
PRINT N'Altering [dbo].[UFN_Get_Indiacast_Report_Country]...';


GO
ALTER FUNCTION [dbo].[UFN_Get_Indiacast_Report_Country](@Country_Code VARCHAR(4000), @RowId INT)  
	RETURNS @Tbl_Ret TABLE (  
	 Region_Code INT,  
	 Region_Name NVARCHAR(MAX)  
)
 AS  
BEGIN                                   
 --Declare @Country_Code_Str Varchar(2000) = '1,12,15,17,2,36,48'  
 --DECLARE @Country_Code VARCHAR(2000) = '1,15,2,36,48,17,15,12,56,89,45248,589,698'  
 --Declare @RowId Int = 1  
   
 --Declare @Tbl_Ret TABLE (  
 -- Region_Code Int,  
 -- Region_Name_In NVarchar(MAX),  
 -- Region_Name_NOTIn NVarchar(MAX)  
 --)  
	DECLARE @Temp_Country AS TABLE(  
		Country_Code INT  
	)  
	DECLARE @Indiacast_Avail_India_Code varchar(5)
	SELECT  @Indiacast_Avail_India_Code = Parameter_Value FROM System_Parameter_New where Parameter_Name ='India_Avail'

	INSERT INTO @Temp_Country(Country_Code)  
	SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT IN('0', '')  
  
	DELETE FROM @Temp_Country WHERE Country_Code = 0  
  
	DECLARE @Country_Name NVARCHAR(MAX),  @Country_Name_Not_IN NVARCHAR(MAX)  
  
	set @Country_Name =  Ltrim(STUFF((  
		Select Distinct ', ' + C.Country_Name From @Temp_Country TC  
		INNER JOIN Country C ON C.Country_Code = TC.Country_Code  
		WHERE TC.Country_Code IN(SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code,','))  AND TC.Country_Code NOT IN(@Indiacast_Avail_India_Code)
		FOR XML PATH('')  
	), 1, 1, ''))  
  

  
	Insert InTo @Tbl_Ret(Region_Code, Region_Name)  
	Select @RowId, @Country_Name  
	RETURN  
END
GO
PRINT N'Altering [dbo].[USP_Last_Month_Utilization_Report]...';


GO
ALTER PROCEDURE [dbo].[USP_Last_Month_Utilization_Report]
(
	@Title_Codes VARCHAR(1000),
	@BU_Code INT,
	@Channel_Codes VARCHAR(1000)
)	
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 16 Sept 2015
-- Description:	Last Month Utilization Report(Task ID - RightsU -3508)
-- =============================================
BEGIN	
	SET NOCOUNT ON;
	IF(@BU_Code = 0)
		SET  @BU_Code = 1
	------------------------------------------- DELETE TEMP TABLES -------------------------------------------	   	
	--IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	--BEGIN
	--	DROP TABLE #Result
	--END	
	IF OBJECT_ID('tempdb..#Temp_Channel_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Channel_Code
	END	
	IF OBJECT_ID('tempdb..#Temp_Rights_Run') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Run
	END	
	------------------------------------------- CREATE TEMP TABLES -------------------------------------------	
	CREATE TABLE #Temp_Rights_Run
	(
		Deal_no VARCHAR(250), 
		Deal_Code INT, 
		Deal_Desc NVARCHAR(MAX),
		Vendor_Code INT,
		Deal_Movie_Code INT,		 
		Title_Code INT, 
		Deal_Right_Code INT,
		[Start_Date] DATETIME,                       
		End_Date DATETIME,                       		
		Channel_Code INT, 		
		Is_Yearwise_Definition CHAR(1),				
		Channel_No_Of_Runs VARCHAR(50),
		No_Of_Runs VARCHAR(50),
		Yearwise_No_Of_Runs VARCHAR(50),
		Run_Type CHAR(1)		
	)
	--CREATE TABLE #Result
	--(
	--	Deal_no VARCHAR(250), 
	--	Title_Name NVARCHAR(250), 
	--	Rights_Period VARCHAR(50),                       
	--	Deal_Movie_Code INT,		 
	--	Channel_Code INT, 
	--	Channel_Name NVARCHAR(50), 												
	--	Schedule_Run INT,
	--	No_Of_Runs VARCHAR(50),
	--	Balance_Runs VARCHAR(50),
	--	Count_No_Of_Schedule INT
	--)
	CREATE Table  #Temp_Channel_Code
	(
		ChannelCode INT
	)
	DECLARE @BV_Schedule_Transaction_Codes VARCHAR(MAX) = '',@First_day_Of_Last_Month DateTime = GETDATE()
	,@Last_day_Of_Last_Month DATETIME
	
	--SET @First_day_Of_Last_Month = DATEADD(dd,-(DAY(GETDATE())-1),GETDATE())
	--SET @Last_day_Of_Last_Month = DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))),DATEADD(mm,1,GETDATE()))
	
	SET @First_day_Of_Last_Month = DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	SET @Last_day_Of_Last_Month =DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
	
	------------------------------------------ INSERT TEMP TABLES(BV_Trans)-----------------------------------------
	IF (@Channel_Codes<>'') 
	BEGIN
		INSERT INTO #Temp_Channel_Code
		SELECT number FROM fn_Split_withdelemiter(@Channel_Codes,',')
	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Channel_Code
		SELECT Channel_Code FROM Channel
	END
	------------------------------------------- SELECT FROM Temp Table -------------------------------------------	
	
	------------------------------------------- END DROP TEMP TABLES -------------------------------------------	
	INSERT INTO #Temp_Rights_Run
	(
		Deal_no,
		Deal_Code, 
		Deal_Desc ,
		Vendor_Code,
		Title_Code, 
		[Start_Date], 
		[End_Date],
		Deal_Movie_Code ,		
		Deal_Right_Code, 
		Channel_Code , 		
		Is_Yearwise_Definition ,		
		Channel_No_Of_Runs, 
		No_Of_Runs ,
		Yearwise_No_Of_Runs,
		Run_Type		
	)
	SELECT   AD.Agreement_No,AD.Acq_Deal_Code,AD.Deal_Desc ,AD.Vendor_Code,ADM.Title_Code,
	CASE WHEN  ADMR.Is_Yearwise_Definition = 'Y' THEN ADRY.[Start_Date] ELSE ADR.Actual_Right_Start_Date END AS Actual_Right_Start_Date, 
	CASE WHEN  ADMR.Is_Yearwise_Definition = 'Y' THEN ADRY.End_Date ELSE ADR.Actual_Right_End_Date END AS Actual_Right_End_Date,  
	ADM.Acq_Deal_Movie_Code,ADR.Acq_Deal_Rights_Code,ADMRC.Channel_Code,ADMR.Is_Yearwise_Definition				
	,CASE WHEN ADMR.Run_Definition_Type = 'S'  THEN ADMR.No_Of_Runs / tmp_Run_Channel.No_Of_Channels 
		WHEN ADMR.Run_Definition_Type = 'N'  THEN ADMR.No_Of_Runs / tmp_Run_Channel.No_Of_Channels
		ELSE ADMRC.Min_Runs 
	END Channel_No_Of_Runs
	,ADMR.No_Of_Runs,ISNULL(ADRY.No_Of_Runs, 0) Yearwise_No_Of_Runs,ADMR.Run_Type
	FROM Acq_Deal AD		
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code= AD.Acq_Deal_Code --AND ADM.Acq_Deal_Movie_Code IN(SELECT Deal_Movie_Code FROM #BV_Trans)	
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code= ADM.Acq_Deal_Code --AND ADR.Acq_Deal_Rights_Code IN(SELECT Deal_Right_Code FROM #BV_Trans)	                       
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code= ADRT.Acq_Deal_Rights_Code AND  ADRT.title_code = ADM.Title_Code
	INNER JOIN Acq_Deal_Run ADMR ON ADMR.Acq_Deal_Code= ADR.Acq_Deal_Code 
	INNER JOIN Acq_Deal_Run_Title ADMRT ON ADMR.Acq_Deal_Run_Code= ADMRT.Acq_Deal_Run_Code AND ADMRT.title_code  = ADRT.Title_Code
	INNER JOIN Acq_Deal_Run_Channel ADMRC on ADMR.Acq_Deal_Run_Code= ADMRC.Acq_Deal_Run_Code 
	AND ADMRC.Channel_Code IN(SELECT ChannelCode FROM #Temp_Channel_Code)


	--INNER JOIN #Temp_Channel_Code TCC ON ADMRC.Channel_Code = TCC.ChannelCode	
	INNER JOIN 
		(
			SELECT Acq_Deal_Run_Code, COUNT(Channel_Code) No_Of_Channels 
			FROM Acq_Deal_Run_Channel 
			GROUP BY Acq_Deal_Run_Code
		) AS tmp_Run_Channel ON tmp_Run_Channel.Acq_Deal_Run_Code =  ADMR.Acq_Deal_Run_Code
	LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRY ON ADRY.Acq_Deal_Run_Code = ADMR.Acq_Deal_Run_Code		
	WHERE 1=1 	and  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	


	--SELECT * FROM #Temp_Rights_Run
	-- RETURN 
	-----------------------------------------------------------------------------------------------
	SELECT  DISTINCT 
		trr.Deal_no AS Agreement_No,trr.Deal_Desc,V.Vendor_Name,Deal_Right_Code,t.Title_Name AS Title_Name,  
		trr.[Start_Date] AS Right_Start_Date, trr.End_Date AS Right_End_Date, 
	c.Channel_Name AS Channel_Name,
	CASE 
		WHEN Is_Yearwise_Definition = 'Y' AND trr.No_Of_Runs > 0 THEN (CAST(trr.Channel_No_Of_Runs AS INT) * CAST(trr.Yearwise_No_Of_Runs AS INT)) / CAST(ISNULL(trr.No_Of_Runs,0) AS INT) 
		--WHEN Is_Yearwise_Definition = 'N' AND trr.Run_Type = 'U' THEN 'Unlimited' 	
		ELSE CAST(trr.Channel_No_Of_Runs AS INT) 
	END AS No_Of_Runs
	,ISNULL(COUNT(bst.Channel_Code), 0) AS Scheduled_Runs
	,CASE 
		WHEN trr.Run_Type = 'U' THEN 'Unlimited' 
		ELSE		
			CAST(CASE 
				WHEN Is_Yearwise_Definition = 'Y' AND CAST(trr.No_Of_Runs AS INT) > 0 THEN (CAST(trr.Channel_No_Of_Runs AS INT) * CAST(trr.Yearwise_No_Of_Runs AS INT)) / CAST(trr.No_Of_Runs AS INT) 
				ELSE CAST(ISNULL(trr.Channel_No_Of_Runs,0) AS INT)
			END 
			- ISNULL(COUNT(bst.Channel_Code), 0) AS VARCHAR)  
	END	Balance_Runs
	--,0
	--,dbo.UFN_Get_Count_Schedule_Movie_Channel_Wise(trr.Deal_Movie_Code,trr.Deal_Right_Code,trr.Channel_Code) AS Count_Schedule_Movie_Channel_Wise
	,tmp_Run_Channel.Deal_Movie_Code_Count
	--,0
	FROM #Temp_Rights_Run trr 
	INNER JOIN Channel c on c.Channel_Code = trr.Channel_Code
	INNER JOIN Title t ON t.Title_Code = trr.Title_Code	
	INNER JOIN Vendor V ON V.Vendor_Code= trr.Vendor_Code	
	LEFT JOIN BV_Schedule_Transaction BST ON  trr.Deal_Right_Code = bst.Deal_Movie_Rights_Code AND trr.Deal_Movie_Code = bst.Deal_Movie_Code
	INNER JOIN 
	(
		SELECT Channel_Code,Deal_Movie_Code,Deal_Movie_Rights_Code,COUNT(Deal_Movie_Code) Deal_Movie_Code_Count 
		FROM BV_Schedule_Transaction
		--WHERE CONVERT(DATETIME,Schedule_Item_Log_Date,106) BETWEEN  DATEADD(MONTH, -1, GETDATE()) AND GETDATE() 				
		WHERE CONVERT(DATETIME,Schedule_Item_Log_Date,106) BETWEEN  CONVERT(DATETIME,@First_day_Of_Last_Month,106) 
		AND CONVERT(DATETIME,@Last_day_Of_Last_Month,106)
		AND Channel_Code IN(SELECT ChannelCode FROM #Temp_Channel_Code)
		GROUP BY Deal_Movie_Code ,Channel_Code,Deal_Movie_Rights_Code
	) AS tmp_Run_Channel 
	ON tmp_Run_Channel.Channel_Code =  trr.Channel_Code AND trr.Deal_Movie_Code=tmp_Run_Channel.Deal_Movie_Code 
	AND trr.Deal_Right_Code=tmp_Run_Channel.Deal_Movie_Rights_Code
	AND trr.Channel_Code = bst.Channel_Code 	
	AND ISNULL(IsProcessed,'') = 'Y' 
	AND ISNULL(IsIgnore,'N') = 'N'		
	AND CONVERT(DATETIME,Schedule_Item_Log_Date,106)   BETWEEN TRR.[Start_Date] AND TRR.End_Date
	AND ((trr.No_Of_Runs > 0 AND trr.Run_Type ='C') OR trr.Run_Type ='U')
	--	AND trr.Title_Code = bst.Title_Code AND trr.Channel_Code = bst.Channel_Code
	--WHERE Deal_No like  'A-2012-00024'--'A-2010-00015'
	--	AND Title_Name like 'jab tak%'
	--	-- No_Of_Runs =3
	--	AND Channel_NAme like 'MAX Middle East'
	GROUP BY trr.Deal_no,
			t.Title_Name, 
			trr.Start_Date, 
			trr.End_Date, 
			c.Channel_Name,
			trr.Title_Code,
			trr.Deal_Code,
			trr.Deal_Right_Code,
			trr.Channel_Code,
			trr.No_Of_Runs,			
			trr.Is_Yearwise_Definition,
			trr.Channel_No_Of_Runs,
			trr.Yearwise_No_Of_Runs,
			trr.Run_Type
			,trr.Deal_Movie_Code
			,tmp_Run_Channel.Deal_Movie_Code_Count
			,trr.Deal_Desc,V.Vendor_Name
	ORDER BY trr.End_Date

--	SELECT * FROM #Temp_Rights_Run

	SELECT  DISTINCT AD.Agreement_No AS Agreement_No, AD.Deal_Desc, V.Vendor_Name, 0 AS Deal_Right_Code, t.Title_Name AS Title_Name, CCR.Rights_Start_Date AS Right_Start_Date, 
	CCR.Rights_End_Date AS Right_End_Date, c.Channel_Name AS Channel_Name, CCR.Defined_Runs AS No_Of_Runs, CCR.Schedule_Runs AS Scheduled_Runs,
	CASE WHEN CCR.Run_Type = 'U' THEN 'Unlimited'
	ELSE
		CASE WHEN ISNULL(CCR.Defined_Runs,0) > 0 THEN (ISNULL(CCR.Defined_Runs,0) - ISNULL(CCR.Schedule_Runs,0)) 
		ELSE 'Unlimited' END
	END
	AS Balance_Runs, tmp_Run_Channel.Content_Channel_Run_Count
	FROM Content_Channel_Run CCR
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
	INNER JOIN Channel c on c.Channel_Code = CCR.Channel_Code
	INNER JOIN Title t ON t.Title_Code = CCR.Title_Code	
	INNER JOIN Vendor V ON V.Vendor_Code= AD.Vendor_Code	
	LEFT JOIN BV_Schedule_Transaction BST ON BST.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code 
	INNER JOIN 
	(
		SELECT Content_Channel_Run_Code, COUNT(Content_Channel_Run_Code) Content_Channel_Run_Count
		FROM BV_Schedule_Transaction			
		WHERE CONVERT(DATETIME,Schedule_Item_Log_Date,106) BETWEEN  CONVERT(DATETIME,@First_day_Of_Last_Month,106) 
		AND CONVERT(DATETIME,@Last_day_Of_Last_Month,106)
		AND Channel_Code IN(SELECT ChannelCode FROM #Temp_Channel_Code)
		GROUP BY Content_Channel_Run_Code 
	) AS tmp_Run_Channel 
	ON tmp_Run_Channel.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code
	AND ISNULL(IsProcessed,'') = 'Y' 
	AND ISNULL(IsIgnore,'N') = 'N'		
	AND CONVERT(DATETIME,Schedule_Item_Log_Date,106)   BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date
	AND ((CCR.Defined_Runs > 0 AND CCR.Run_Type ='C') OR CCR.Run_Type ='U')
	where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	--	AND trr.Title_Code = bst.Title_Code AND trr.Channel_Code = bst.Channel_Code
	--WHERE Deal_No like  'A-2012-00024'--'A-2010-00015'
	--	AND Title_Name like 'jab tak%'
	--	-- No_Of_Runs =3
	--	AND Channel_NAme like 'MAX Middle East'
	GROUP BY AD.Agreement_No,
			t.Title_Name, 
			CCR.Rights_Start_Date, 
			CCR.Rights_End_Date, 
			c.Channel_Name,
			CCR.Title_Code,
			CCR.Acq_Deal_Code,
			CCR.Channel_Code,
			CCR.Defined_Runs,
			CCR.Schedule_Runs,
			CCR.Run_Type
			,tmp_Run_Channel.Content_Channel_Run_Count
			,AD.Deal_Desc,V.Vendor_Name
	--ORDER BY trr.End_Date

	------------------------------------------- DROP  TEMP TABLES -------------------------------------------		
	DROP TABLE #Temp_Rights_Run
	--DROP TABLE #Result
	DROP TABLE #Temp_Channel_Code
	------------------------------------------- END DROP TEMP TABLES -------------------------------------------	

	IF OBJECT_ID('tempdb..#BV_Trans') IS NOT NULL DROP TABLE #BV_Trans
	IF OBJECT_ID('tempdb..#Result') IS NOT NULL DROP TABLE #Result
	IF OBJECT_ID('tempdb..#Temp_Channel_Code') IS NOT NULL DROP TABLE #Temp_Channel_Code
	IF OBJECT_ID('tempdb..#Temp_Rights_Run') IS NOT NULL DROP TABLE #Temp_Rights_Run
END
/*
--EXEC USP_Last_Month_Utilization_Report '' ,1 ,'23'
*/
GO
PRINT N'Altering [dbo].[USP_RightsU_Health_Checkup]...';


GO
ALTER PROCEDURE [USP_RightsU_Health_Checkup]
(
	@CS_Curr_Count INT = 1
)
AS
BEGIN
	--SSJ - SQL SERVER JOB = 6
	--DTL - Database Transaction Log = 6
	--DPP - Acq/Syn Deals Pending For Processing = 5
	--DRP - Deals Rights Pending For Processing = 6
	--DAG - Acq/Syn Deals Pending for Avail Generation = 6
	--TAN - Trigger Alert Notification Mail for Schedule
	--DDF - Dirty Data Found

	DECLARE @DatabaseName VARCHAR(MAX)
	SELECT @DatabaseName = Parameter_Value FROM system_parameter_new WHERE parameter_name = 'RightsU_DB'

	IF OBJECT_ID('tempdb..#TmpLogSpace') IS NOT NULL
		DROP TABLE #TmpLogSpace

	IF OBJECT_ID('tempdb..#TempResult') IS NOT NULL
		DROP TABLE #TempResult

	IF OBJECT_ID('tempdb..#Tmp_Pending_Avail_Generation') IS NOT NULL
		DROP TABLE #Tmp_Pending_Avail_Generation

	IF OBJECT_ID('tempdb..#temp_Queries') IS NOT NULL
		DROP TABLE #temp_Queries
		
	CREATE TABLE #TempResult(
		DatabaseName NVARCHAR(MAX),
		SrNo INT,
		Type NVARCHAR(MAX),
		Col1 NVARCHAR(MAX),
		Col2 NVARCHAR(MAX),
		Col3 NVARCHAR(MAX),
		Col4 NVARCHAR(MAX),
		Col5 NVARCHAR(MAX),
		Col6 NVARCHAR(MAX),
		Col7 NVARCHAR(MAX),
		Col8 NVARCHAR(MAX)
	)

	IF(@CS_Curr_Count = 1)
	BEGIN
		PRINT '====== START SQL SERVER JOB ========'
		BEGIN
			INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
			SELECT 'DB Name', 1, 'SSJ', 'Job Name', 'Enabled / Disabled', 'Status', 'Last Run Time'

			INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
			SELECT @DatabaseName, 2, 'SSJ',
				SJ.NAME
				,CASE SJ.enabled WHEN 0 THEN 'Disabled'
						WHEN 1 THEN 'Enabled'
						END
				,CASE jh.run_status WHEN 0 THEN 'Failed'
						WHEN 1 THEN 'Success'
						WHEN 2 THEN 'Retry'
						WHEN 3 THEN 'Canceled'
						WHEN 4 THEN 'In progress'
						ELSE 'NA'
						END
				,MAX(MSDB.DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME))
			FROM 
				msdb.dbo.sysjobs SJ LEFT JOIN  msdb.dbo.SYSJOBHISTORY JH
			ON SJ.job_id = JH.job_id WHERE 1=1  AND (SJ.NAME LIKE 'RightsU%' OR SJ.NAME LIKE 'RU%' )
			GROUP BY SJ.name, JH.run_status, SJ.enabled 
			--ORDER BY  SJ.NAME ,[Last_Time_Job_Ran_On] DESC
		END
		PRINT '====== END SQL SERVER JOB ========'
		PRINT '====== Start Database Size and Transaction Log ========'
		BEGIN
			CREATE TABLE #TmpLogSpace(
				DatabaseName VARCHAR(100)
			  , [Log Size (MB)] DECIMAL(18,5)
			  , [Log Space Used (%)] DECIMAL(18, 5)
			  , [Status] DECIMAL(18, 5)
			 ) 

			 INSERT #TmpLogSpace(DatabaseName, [Log Size (MB)], [Log Space Used (%)], Status) 
			 EXEC('DBCC SQLPERF(LOGSPACE);')

			 INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
			 SELECT 'DB Name', 1, 'DTL', 'Database Name', 'Log Size (MB)', 'Total Disk Space', 'Backup Date'

			 INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
			 SELECT @DatabaseName, 2, 'DTL', A.Database_Name, A.Log_Size_MB, A.Total_Disk_Space, B.backup_finish_date FROM (
					SELECT A.name AS 'Database_Name', CAST(A.[Total disk space] AS NVARCHAR(MAX)) AS 'Total_Disk_Space', B.[Log Size (MB)] AS 'Log_Size_MB' FROM (
		 				 SELECT sys.databases.name,CONVERT(VARCHAR, SUM(size) *8/1024)+' MB' AS[Total disk space]
		 				 FROM sys.databases
		 				 JOIN sys.master_files ON  sys.databases.database_id=sys.master_files.database_id GROUP BY sys.databases.name
		 			) AS A
		 			LEFT JOIN #TmpLogSpace B ON A.name = B.DatabaseName
			 ) AS A
			 LEFT  JOIN (
		 			SELECT 
		 			   [rs].[destination_database_name], 
		 			   [bs].[backup_finish_date]
		 			FROM msdb..restorehistory rs
		 			INNER JOIN msdb..backupset bs ON [rs].[backup_set_id] = [bs].[backup_set_id]
		 			INNER JOIN msdb..backupmediafamily bmf ON [bs].[media_set_id] = [bmf].[media_set_id] 
			 ) AS B ON A.Database_Name = B.destination_database_name
			 WHERE A.Database_Name LIKE 'RightsU%' OR  A.Database_Name LIKE 'RU%' OR A.Database_Name = 'tempdb'
			 ORDER BY A.Database_Name, B.backup_finish_date 
		END
		PRINT '====== End Database Size and Transaction Log ========'
	END
	PRINT '====== Start Acq/Syn Deals Pending For Processing ========'
	BEGIN
		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3)
			 SELECT 'DB Name', 1, 'DPP', 'Deal Type', 'Agreement No', 'Description'

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3)
		SELECT @DatabaseName, 2, 'DPP',
			CASE
				WHEN DP.Module_Code = 30 THEN 'Acquision Deal'
				ELSE 'Syndiation Deal'
			END AS Deal, AD.Agreement_No,
			CASE
				WHEN DP.Record_Status = 'P' THEN 'Pending Since ' + CAST( DP.Inserted_On AS NVARCHAR(MAX))
				WHEN DP.Record_Status = 'W' THEN 'In Process From ' + CAST( DP.Process_Start AS NVARCHAR(MAX))
				ELSE 'NA'
			END AS [Record_Status] 
			FROM Deal_Process DP INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = DP.Deal_Code  
			WHERE DP.Record_Status IN ('P', 'W')  
			ORDER BY Deal, AD.Agreement_No
		END
	PRINT '====== End Acq/Syn Deals Pending For Processing ========'
	PRINT '====== End Acq/Syn Deals Rights Pending For Processing ========'
	BEGIN
		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
			 SELECT 'DB Name', 1, 'DRP', 'Deal Type', 'Agreement No','Deal Rights Code','Description'

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
		SELECT DISTINCT @DatabaseName, 2, 'DRP','Acquision Deal',AD.Agreement_No, DRP.Deal_Rights_Code,
		CASE
				WHEN DRP.Record_Status = 'P' THEN 'Pending Since ' + CAST( DRP.Inserted_On AS NVARCHAR(MAX))
				WHEN DRP.Record_Status = 'W' THEN 'In Process From ' + CAST( DRP.Process_Start AS NVARCHAR(MAX))
				ELSE 'NA'
		END AS [Record_Status] 
		FROM Deal_Rights_Process DRP INNER JOIN Acq_Deal AD ON  AD.Acq_Deal_Code = DRP.Deal_Code  
		WHERE Record_Status IN ('P', 'W')

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
		SELECT DISTINCT @DatabaseName, 2, 'DRP','Syndication Deal',SD.Agreement_No, SDR.Syn_Deal_Rights_Code,
		CASE
				WHEN SDR.Right_Status = 'P' THEN 'Pending Since ' + CAST( SDR.Last_Updated_Time AS NVARCHAR(MAX))
				WHEN SDR.Right_Status = 'W' THEN 'In Process From ' + CAST( SDR.Last_Updated_Time AS NVARCHAR(MAX))
				ELSE 'NA'
		END AS [Record_Status] 
		FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal SD ON  SD.Syn_Deal_Code = SDR.Syn_Deal_Code  
		WHERE SDR.Right_Status IN ('P', 'W')
	END
	PRINT '====== End Acq/Syn Deals Rights Pending For Processing ========'
	PRINT '====== Start Acq/Syn Deals Pending for Avail Generation ========'
	BEGIN
	
		  CREATE TABLE #Tmp_Pending_Avail_Generation
		  (
		 	  Deal_Type NVARCHAR(MAX),
			  Agreement_No NVARCHAR(MAX),
		 	  Deal_Code INT,
		 	  Last_Approved NVARCHAR(MAX),
		 	  Last_Avail_Refresh NVARCHAR(MAX)
		  )

		  -- RightsU_Reports_VMPL_Movies (Acquisition)
		  INSERT INTO #Tmp_Pending_Avail_Generation ( Deal_Type, Deal_Code, Last_Approved, Last_Avail_Refresh)
		  SELECT 'Acquisition', Record_Code ,'Last Approved  Since ' + CAST( Inserted_On AS NVARCHAR(MAX)),''
		  FROM RightsU_Reports_VMPL_Movies.dbo.Approved_Deal_Process
		  WHERE Deal_Status = 'P' AND Deal_Type = 'A'
		  UNION
		  SELECT 'Acquisition', A.Deal_Code,'Last Approved Since '+ CAST( A.Process_End_Date AS NVARCHAR(MAX)), 'Last Avail Refresh Since '+ CAST( B.Process_End_Date AS NVARCHAR(MAX)) FROM (
			  SELECT DISTINCT Deal_Code , MAX(Porcess_End) as [Process_End_Date] 
			  FROM Deal_Process DP 
			  WHERE DP.Action = 'A' AND  DP.Porcess_End > DATEADD(dd,-1,GETDATE()) AND Module_Code = 30
			  GROUP BY dp.Deal_Code
		  ) AS A 
		  LEFT JOIN
		  ( SELECT DISTINCT PS.Record_Code, MAX(start_Time) AS [Process_End_Date] 
				FROM RightsU_Reports_VMPL_Movies.dbo.Process_Schedule PS 
				WHERE PS.Record_Type = 'A' AND job_status = 'D' 
				GROUP BY PS.Record_Code
		  ) AS B on A.Deal_Code = B.Record_Code And A.Process_End_Date > B.Process_End_Date 
		   WHERE
		   A.Deal_Code NOT IN (SELECT Record_Code FROM RightsU_Reports_VMPL_Movies.dbo.Approved_Deal_Process WHERE Deal_Status = 'P' AND Deal_Type = 'A')

	      -- RightsU_Reports_VMPL_Movies (Syndication)
		  INSERT INTO #Tmp_Pending_Avail_Generation ( Deal_Type, Deal_Code, Last_Approved, Last_Avail_Refresh)
		  SELECT 'Syndication', Record_Code ,'Last Approved  Since ' + CAST( Inserted_On AS NVARCHAR(MAX)),''
		  FROM RightsU_Reports_VMPL_Movies.dbo.Approved_Deal_Process
		  WHERE Deal_Status = 'P' AND Deal_Type = 'S'
		  UNION
		  SELECT 'Syndication', A.Deal_Code,'Last Approved Since '+ CAST( A.Process_End_Date AS NVARCHAR(MAX)), 'Last Avail Refresh Since '+ CAST( B.Process_End_Date AS NVARCHAR(MAX)) FROM (
			  SELECT DISTINCT Deal_Code , MAX(Porcess_End) as [Process_End_Date] 
			  FROM Deal_Process DP 
			  WHERE DP.Action = 'A' AND  DP.Porcess_End > DATEADD(dd,-1,GETDATE()) AND Module_Code = 35
			  GROUP BY dp.Deal_Code
		  ) AS A 
		  LEFT JOIN
		  ( SELECT DISTINCT PS.Record_Code, MAX(start_Time) AS [Process_End_Date] 
				FROM RightsU_Reports_VMPL_Movies.dbo.Process_Schedule PS 
				WHERE PS.Record_Type = 'S' AND job_status = 'D' 
				GROUP BY PS.Record_Code
		  ) AS B on A.Deal_Code = B.Record_Code And A.Process_End_Date > B.Process_End_Date 
		   WHERE
		   A.Deal_Code NOT IN (SELECT Record_Code FROM RightsU_Reports_VMPL_Movies.dbo.Approved_Deal_Process WHERE Deal_Status = 'P' AND Deal_Type = 'S')

		   --RightsU_Reports_VMPL_Shows (Acquisition)
		  INSERT INTO #Tmp_Pending_Avail_Generation ( Deal_Type, Deal_Code, Last_Approved, Last_Avail_Refresh)
		  SELECT 'Acquisition', Record_Code ,'Last Approved  Since ' + CAST( Inserted_On AS NVARCHAR(MAX)),''
		  FROM RightsU_Reports_VMPL_Shows.dbo.Approved_Deal_Process
		  WHERE Deal_Status = 'P' AND Deal_Type = 'A'
		  UNION
		  SELECT 'Acquisition', A.Deal_Code,'Last Approved Since '+ CAST( A.Process_End_Date AS NVARCHAR(MAX)), 'Last Avail Refresh Since '+ CAST( B.Process_End_Date AS NVARCHAR(MAX)) FROM (
			  SELECT DISTINCT Deal_Code , MAX(Porcess_End) as [Process_End_Date] 
			  FROM Deal_Process DP 
			  WHERE DP.Action = 'A' AND  DP.Porcess_End > DATEADD(dd,-1,GETDATE()) AND Module_Code = 30
			  GROUP BY dp.Deal_Code
		  ) AS A 
		  LEFT JOIN
		  ( SELECT DISTINCT PS.Record_Code, MAX(start_Time) AS [Process_End_Date] 
				FROM RightsU_Reports_VMPL_Shows.dbo.Process_Schedule PS 
				WHERE PS.Record_Type = 'A' AND job_status = 'D' 
				GROUP BY PS.Record_Code
		  ) AS B on A.Deal_Code = B.Record_Code And A.Process_End_Date > B.Process_End_Date 
		   WHERE
		   A.Deal_Code NOT IN (SELECT Record_Code FROM RightsU_Reports_VMPL_Shows.dbo.Approved_Deal_Process WHERE Deal_Status = 'P' AND Deal_Type = 'A')

		  --RightsU_Reports_VMPL_Shows (Syndication)
		  INSERT INTO #Tmp_Pending_Avail_Generation ( Deal_Type, Deal_Code, Last_Approved, Last_Avail_Refresh)
		  SELECT 'Syndication', Record_Code ,'Last Approved Since ' + CAST( Inserted_On AS NVARCHAR(MAX)),''
		  FROM RightsU_Reports_VMPL_Shows.dbo.Approved_Deal_Process
		  WHERE Deal_Status = 'P' AND Deal_Type = 'S'
		  UNION
		  SELECT 'Syndication', A.Deal_Code,'Last Approved Since '+ CAST( A.Process_End_Date AS NVARCHAR(MAX)), 'Last Avail Refresh Since '+ CAST( B.Process_End_Date AS NVARCHAR(MAX)) FROM (
			  SELECT DISTINCT Deal_Code , MAX(Porcess_End) as [Process_End_Date] 
			  FROM Deal_Process DP 
			  WHERE DP.Action = 'A' AND  DP.Porcess_End > DATEADD(dd,-1,GETDATE()) AND Module_Code = 35
			  GROUP BY dp.Deal_Code
		  ) AS A 
		  LEFT JOIN
		  ( SELECT DISTINCT PS.Record_Code, MAX(start_Time) AS [Process_End_Date] 
				FROM RightsU_Reports_VMPL_Shows.dbo.Process_Schedule PS 
				WHERE PS.Record_Type = 'S' AND job_status = 'D' 
				GROUP BY PS.Record_Code
		  ) AS B on A.Deal_Code = B.Record_Code And A.Process_End_Date > B.Process_End_Date 
		   WHERE
		   A.Deal_Code NOT IN (SELECT Record_Code FROM RightsU_Reports_VMPL_Shows.dbo.Approved_Deal_Process WHERE Deal_Status = 'P' AND Deal_Type = 'S')

		  UPDATE A SET A.Agreement_No = B.Agreement_No from #Tmp_Pending_Avail_Generation A
		  INNER JOIN Acq_Deal B ON A.Deal_Code = B.Acq_Deal_Code AND A.Deal_Type = 'Acquisition'

		  UPDATE A SET A.Agreement_No = B.Agreement_No from #Tmp_Pending_Avail_Generation A
		  INNER JOIN Syn_Deal B ON A.Deal_Code = B.Syn_Deal_Code AND A.Deal_Type = 'Syndication'

		  INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
			 SELECT 'DB Name', 1, 'DAG', 'Deal Type', 'Agreement No','Last Approved','Last Avail Refreshed'

		  INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3, Col4)
		  SELECT @DatabaseName, 2,'DAG', Deal_Type, Agreement_No, Last_Approved, Last_Avail_Refresh from #Tmp_Pending_Avail_Generation
	END
	PRINT '====== End Acq/Syn Deals Pending for Avail Generation ========'
	PRINT '====== Start Trigger Alert Notification Mail for Schedule ========'

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3)
			 SELECT 'DB Name', 1, 'TAN', 'Module Name', 'Record Status','Total No Of Deals'

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2, Col3)
		SELECT @DatabaseName, 2, 'TAN', Module_Name, 
		CASE Record_Status WHEN 'D' THEN 'Done'
					WHEN 'P' THEN 'Pending'
					WHEN 'W' THEN 'Working'
					ELSE 'NA'
					END
		, COUNT(*) 
		FROM BMS_Log
		WHERE Response_Time > DATEADD(HOUR, -24, GETDATE())
		GROUP BY Module_Name, Record_Status

	PRINT '====== End Trigger Alert Notification Mail for Schedule ========'
	PRINT '====== Start Dirty Data Found ========'
	BEGIN
		CREATE TABLE #temp_Queries
		(
			 Agreement_No NVARCHAR(MAX),
			 Error_Description NVARCHAR(MAX),
		)

		INSERT INTO #temp_Queries (Agreement_No, Error_Description)
		--GENERAL
		SELECT DISTINCT e.Agreement_No,
		ISNULL(CASE WHEN ISNULL(e.Deal_Desc,'') = '' THEN 'Description ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.Entity_Code, 0) = 0 THEN 'Licensee/ Assignee '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Vendor_Code, 0) = 0 THEN 'Assignor '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Currency_Code, 0) = 0 THEN 'Currency '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Business_Unit_Code, 0) = 0 THEN 'Business Unit ' END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Category_Code, 0) = 0 THEN 'Category '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.DealMovie,'') = '' THEN 'Acq Deal Movie ' END, '')  
		+ 'is Blank' as 'Error_Description'
		FROM (
			SELECT ad.Agreement_No, ad.Deal_Desc,ad.Entity_Code,ad.Vendor_Code,ad.Currency_Code, ad.Business_Unit_Code,ad.Category_Code,a.Acq_Deal_Movie_Code,
			(SELECT TOP 1 b.Acq_Deal_Movie_Code FROM Acq_Deal_Movie b WHERE b.Acq_Deal_Movie_Code = a.Acq_Deal_Movie_Code) DealMovie
			FROM Acq_Deal_Movie a
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = a.Acq_Deal_Code
		) as e 
		WHERE ISNULL(Deal_Desc, '') = '' OR ISNULL(Entity_Code, 0) = 0 OR ISNULL(Currency_Code, 0) = 0 OR ISNULL(Vendor_Code, 0) = 0 OR ISNULL(Business_Unit_Code, 0) = 0 
		OR ISNULL(Category_Code, 0) = 0 OR e.DealMovie IS NULL
		UNION --RIGHTS
		SELECT e.Agreement_No,
		ISNULL(CASE WHEN ISNULL(e.Is_Exclusive,'') = '' THEN 'Exclusive ' END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Is_Sub_License,'') = '' THEN 'Sub License ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightTitle,'') = '' THEN 'Right Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightPlatform,'') = '' THEN 'Right Platform ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightTerritory,'') = '' THEN 'Right Territory ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Acq_Deal_Rights_Code, a.Is_Exclusive, a.Is_Sub_License,
			(SELECT TOP 1 b.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Title b WHERE b.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code) RightTitle,
			(SELECT TOP 1 c.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory c WHERE c.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code) RightTerritory,
			(SELECT TOP 1 d.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform d WHERE d.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code) RightPlatform
			FROM Acq_Deal_Rights a
			inner join Acq_Deal AD ON AD.Acq_Deal_Code = a.Acq_Deal_Code
		) as e 
		WHERE e.RightPlatform IS NULL or e.RightTitle is null or e.RightTerritory is null
		UNION --REVERSE HOLDBACK
		SELECT e.Agreement_No,
		+ ISNULL(CASE WHEN ISNULL(e.PushbackTitle,'') = '' THEN 'Right Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.PushbackTerritory,'') = '' THEN 'Right Platform ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.PushbackPlatform,'') = '' THEN 'Right Territory ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Acq_Deal_Pushback_Code,
			(SELECT TOP 1 b.Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback_Title b WHERE b.Acq_Deal_Pushback_Code = a.Acq_Deal_Pushback_Code) PushbackTitle,
			(SELECT TOP 1 c.Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback_Territory c WHERE c.Acq_Deal_Pushback_Code = a.Acq_Deal_Pushback_Code) PushbackTerritory,
			(SELECT TOP 1 d.Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback_Platform d WHERE d.Acq_Deal_Pushback_Code = a.Acq_Deal_Pushback_Code) PushbackPlatform
			FROM Acq_Deal_Pushback a
			inner join Acq_Deal AD ON AD.Acq_Deal_Code = a.Acq_Deal_Code
		) as e 
		WHERE e.PushbackTitle IS NULL or e.PushbackTerritory is null or e.PushbackPlatform is null
		UNION --RIGHTS TERM
		SELECT e.Agreement_No,
		 ISNULL(CASE WHEN ISNULL(e.Acq_Deal_Rights_Term,'') = '' THEN 'Right Term ' END, '')  
		 + 'is Blank'
		FROM (
			SELECT ad.Agreement_No , A.Acq_Deal_Rights_Code,
			(SELECT TOP 1 b.Term FROM Acq_Deal_Rights B WHERE ISNULL(B.Term,'') = '' AND B.Right_Type = 'Y' AND B.Acq_Deal_Rights_Code = A.Acq_Deal_Rights_Code) Acq_Deal_Rights_Term
			FROM Acq_Deal_Rights A
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = A.Acq_Deal_Code
		) as e
		WHERE e.Acq_Deal_Rights_Term is not null
		UNION --RUN DEFINATION
		SELECT e.Agreement_No,
		 ISNULL(CASE WHEN ISNULL(e.RunTitle,'') = '' THEN 'Run Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RunChannel,'') = '' THEN 'Run Channel ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No ,
			(SELECT TOP 1 b.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title b WHERE b.Acq_Deal_Run_Code = a.Acq_Deal_Run_Code) RunTitle,
			(SELECT TOP 1 c.Acq_Deal_Run_Code FROM Acq_Deal_Run_Channel c WHERE c.Acq_Deal_Run_Code = a.Acq_Deal_Run_Code) RunChannel
			FROM Acq_Deal_Run a
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = a.Acq_Deal_Code
		) as e 
		WHERE e.RunTitle IS NULL or e.RunChannel IS NULL
		UNION --ANCILLARY
		SELECT e.Agreement_No, 
		 ISNULL(CASE WHEN ISNULL(e.Ancillary_Type_code,'') = '' THEN 'Ancillary Type code ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.AncillaryTitle,'') = '' THEN 'Ancillary Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.AncillaryPlatform,'') = '' THEN 'Ancillary Platform ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Acq_Deal_Ancillary_Code, a.Ancillary_Type_code, 
			(SELECT TOP 1 b.Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary_Title b WHERE b.Acq_Deal_Ancillary_Code = a.Acq_Deal_Ancillary_Code) AncillaryTitle,
			(SELECT TOP 1 c.Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary_Platform c WHERE c.Acq_Deal_Ancillary_Code = a.Acq_Deal_Ancillary_Code) AncillaryPlatform
			FROM Acq_Deal_Ancillary a
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = a.Acq_Deal_Code
		) as e 
		WHERE e.AncillaryTitle IS NULL or e.AncillaryPlatform IS NULL
		UNION --COST
		SELECT e.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(e.CostTitle,'') = '' THEN 'Run Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.Costtype,'') = '' THEN 'Run Platform ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No ,
			(SELECT TOP 1 b.Acq_Deal_Cost_Code FROM Acq_Deal_Cost_Title b WHERE b.Acq_Deal_Cost_Code = a.Acq_Deal_Cost_Code) CostTitle,
			(SELECT TOP 1 c.Acq_Deal_Cost_Code FROM Acq_Deal_Cost_Costtype c WHERE c.Acq_Deal_Cost_Code = a.Acq_Deal_Cost_Code) Costtype
			FROM Acq_Deal_Cost a
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = a.Acq_Deal_Code
		) as e 
		WHERE e.CostTitle IS NULL or e.Costtype IS NULL
		UNION --PAYMENT TERM
		SELECT b.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(a.Payment_Term_Code, 0) = 0 THEN 'Payment Term Code '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Days_After, 0) = 0 THEN 'Days before or after Milestone '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Percentage, 0) = 0 THEN 'Percentage(%) Amount '	END, '') 
		+ 'is Blank'
		FROM Acq_Deal_Payment_Terms a
		INNER JOIN Acq_Deal b on a.Acq_Deal_Code = b.Acq_Deal_Code
		WHERE  ISNULL(a.Payment_Term_Code, 0) = 0 OR ISNULL(a.Days_After, 0) = 0 OR ISNULL(a.Percentage, 0) = 0 
		UNION --MATERIAL
		SELECT b.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(a.Quantity, 0) = 0 THEN 'Quantity '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Material_Medium_Code, 0) = 0 THEN 'Material Medium Code '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Material_Type_Code, 0) = 0 THEN 'Material Type Code '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Title_Code, 0) = 0 THEN 'Title Code '	END, '') 
		+ 'is Blank'
		FROM Acq_Deal_Material a
		INNER JOIN Acq_Deal b on a.Acq_Deal_Code = b.Acq_Deal_Code
		WHERE  ISNULL(a.Material_Medium_Code, 0) = 0 OR ISNULL(a.Material_Type_Code, 0) = 0 OR ISNULL(a.Title_Code, 0) = 0 
		UNION --ATTACHMENT
		SELECT b.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(a.Attachment_Title, '') = '' THEN 'Description '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.System_File_Name, '') = '' THEN 'System File Name '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Document_Type_Code, 0) = 0 THEN 'Document Type Code '	END, '') 
		+ 'is Blank'
		FROM Acq_Deal_Attachment a
		INNER JOIN Acq_Deal b on a.Acq_Deal_Code = b.Acq_Deal_Code
		WHERE  ISNULL(a.Attachment_Title, '') = '' OR ISNULL(a.System_File_Name, '') = '' OR ISNULL(a.Document_Type_Code, 0) = 0 
		UNION --GENERAL
		SELECT DISTINCT e.Agreement_No,
		ISNULL(CASE WHEN ISNULL(e.Deal_Description,'') = '' THEN 'Description ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.Entity_Code, 0) = 0 THEN 'Licensee/ Assignee '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Vendor_Code, 0) = 0 THEN 'Assignor '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Currency_Code, 0) = 0 THEN 'Currency '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Business_Unit_Code, 0) = 0 THEN 'Business Unit ' END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Category_Code, 0) = 0 THEN 'Category '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.DealMovie,'') = '' THEN 'Syn Deal Movie ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No, ad.Deal_Description,ad.Entity_Code,ad.Vendor_Code,ad.Currency_Code, ad.Business_Unit_Code,ad.Category_Code,a.Syn_Deal_Movie_Code,
			(SELECT TOP 1 b.Syn_Deal_Movie_Code FROM Syn_Deal_Movie b WHERE b.Syn_Deal_Movie_Code = a.Syn_Deal_Movie_Code) DealMovie
			FROM Syn_Deal_Movie a
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = a.Syn_Deal_Code
		) as e 
		WHERE ISNULL(Deal_Description, '') = '' OR ISNULL(Entity_Code, 0) = 0 OR ISNULL(Currency_Code, 0) = 0 OR ISNULL(Vendor_Code, 0) = 0 OR ISNULL(Business_Unit_Code, 0) = 0 
		OR ISNULL(Category_Code, 0) = 0 OR e.DealMovie IS NULL
		UNION --RIGHTS
		SELECT e.Agreement_No,
		ISNULL(CASE WHEN ISNULL(e.Is_Exclusive,'') = '' THEN 'Exclusive ' END, '') 
		+ ISNULL(CASE WHEN ISNULL(e.Is_Sub_License,'') = '' THEN 'Sub License ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightTitle,'') = '' THEN 'Right Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightPlatform,'') = '' THEN 'Right Platform ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightTerritory,'') = '' THEN 'Right Territory ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Syn_Deal_Rights_Code, a.Is_Exclusive, a.Is_Sub_License,
			(SELECT TOP 1 b.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Title b WHERE b.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code) RightTitle,
			(SELECT TOP 1 c.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory c WHERE c.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code) RightTerritory,
			(SELECT TOP 1 d.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform d WHERE d.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code) RightPlatform
			FROM Syn_Deal_Rights a
			inner join Syn_Deal AD ON AD.Syn_Deal_Code = a.Syn_Deal_Code
		) as e 
		WHERE e.RightPlatform IS NULL or e.RightTitle is null or e.RightTerritory is null
		UNION --REVERSE HOLDBACK
		SELECT e.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(e.RightTitle,'') = '' THEN 'Right Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightPlatform,'') = '' THEN 'Right Platform ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RightTerritory,'') = '' THEN 'Right Territory ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No ,
			(SELECT TOP 1 b.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Title b WHERE b.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code ) RightTitle,
			(SELECT TOP 1 c.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory c WHERE c.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code ) RightTerritory,
			(SELECT TOP 1 d.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform d WHERE d.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code) RightPlatform
			FROM Syn_Deal_Rights a
			inner join Syn_Deal AD ON AD.Syn_Deal_Code = a.Syn_Deal_Code AND  a.Is_Pushback = 'Y'
		) as e 
		WHERE e.RightPlatform IS NULL or e.RightTitle is null or e.RightTerritory is null
		UNION --RUN DEFINATION
		SELECT e.Agreement_No,
		 ISNULL(CASE WHEN ISNULL(e.Title_Code,'') = '' THEN 'Run Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RunPlatform,'') = '' THEN 'Run Platform ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Syn_Deal_Run_Code,  a.Title_Code,
			(SELECT TOP 1 c.Syn_Deal_Run_Code FROM Syn_Deal_Run_Platform c WHERE c.Syn_Deal_Run_Code = a.Syn_Deal_Run_Code) RunPlatform
			FROM Syn_Deal_Run a
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = a.Syn_Deal_Code
		) as e 
		WHERE  e.RunPlatform IS NULL
		UNION --PAYMENT TERM
		SELECT b.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(a.Payment_Terms_Code, 0) = 0 THEN 'Payment Term Code '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Days_After, 0) = 0 THEN 'Days before or after Milestone '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Percentage, 0) = 0 THEN 'Percentage(%) Amount '	END, '') 
		+ 'is Blank'
		FROM Syn_Deal_Payment_Terms a
		INNER JOIN Syn_Deal b on a.Syn_Deal_Code = b.Syn_Deal_Code
		WHERE  ISNULL(a.Payment_Terms_Code, 0) = 0 OR ISNULL(a.Days_After, 0) = 0 OR ISNULL(a.Percentage, 0) = 0 
		UNION --MATERIAL
		SELECT b.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(a.Quantity, 0) = 0 THEN 'Quantity '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Material_Medium_Code, 0) = 0 THEN 'Material Medium Code '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Material_Type_Code, 0) = 0 THEN 'Material Type Code '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Title_Code, 0) = 0 THEN 'Title Code '	END, '') 
		+ 'is Blank'
		FROM Syn_Deal_Material a
		INNER JOIN Syn_Deal b on a.Syn_Deal_Code = b.Syn_Deal_Code
		WHERE  ISNULL(a.Material_Medium_Code, 0) = 0 OR ISNULL(a.Material_Type_Code, 0) = 0 OR ISNULL(a.Title_Code, 0) = 0 
		UNION --ATTACHMENT
		SELECT b.Agreement_No, 
		+ ISNULL(CASE WHEN ISNULL(a.Attachment_Title, '') = '' THEN 'Description '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.System_File_Name, '') = '' THEN 'System File Name '	END, '') 
		+ ISNULL(CASE WHEN ISNULL(a.Document_Type_Code, 0) = 0 THEN 'Document Type Code '	END, '') 
		+ 'is Blank'
		FROM Syn_Deal_Attachment a
		INNER JOIN Syn_Deal b on a.Syn_Deal_Code = b.Syn_Deal_Code
		WHERE  ISNULL(a.Attachment_Title, '') = '' OR ISNULL(a.System_File_Name, '') = '' OR ISNULL(a.Document_Type_Code, 0) = 0 
		UNION --ANCILLARY
		SELECT e.Agreement_No,
		 ISNULL(CASE WHEN ISNULL(e.Ancillary_Type_code,'') = '' THEN 'Ancillary Type code ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.AncillaryTitle,'') = '' THEN 'Ancillary Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.AncillaryPlatform,'') = '' THEN 'Ancillary Platform ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Syn_Deal_Ancillary_Code, a.Ancillary_Type_code, 
			(SELECT TOP 1 b.Syn_Deal_Ancillary_Code FROM Syn_Deal_Ancillary_Title b WHERE b.Syn_Deal_Ancillary_Code = a.Syn_Deal_Ancillary_Code) AncillaryTitle,
			(SELECT TOP 1 c.Syn_Deal_Ancillary_Code FROM Syn_Deal_Ancillary_Platform c WHERE c.Syn_Deal_Ancillary_Code = a.Syn_Deal_Ancillary_Code) AncillaryPlatform
			FROM Syn_Deal_Ancillary a
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = a.Syn_Deal_Code
		) as e 
		WHERE e.AncillaryTitle IS NULL or e.AncillaryPlatform IS NULL
		UNION --REVENUE
		SELECT e.Agreement_No, 
		 ISNULL(CASE WHEN ISNULL(e.Deal_Cost,0) = 0 THEN 'Deal Cost ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RevenueTitle,0) = 0 THEN 'Revenue Title ' END, '')  
		+ ISNULL(CASE WHEN ISNULL(e.RevenuePlatform,0) = 0 THEN 'Revenue Platform ' END, '')  
		+ 'is Blank'
		FROM (
			SELECT ad.Agreement_No , a.Syn_Deal_Revenue_Code, a.Deal_Cost ,
			(SELECT TOP 1 b.Syn_Deal_Revenue_Code FROM Syn_Deal_Revenue_Title b WHERE b.Syn_Deal_Revenue_Code = a.Syn_Deal_Revenue_Code) RevenueTitle,
			(SELECT TOP 1 c.Syn_Deal_Revenue_Code FROM Syn_Deal_Revenue_Costtype c WHERE c.Syn_Deal_Revenue_Code = a.Syn_Deal_Revenue_Code) RevenuePlatform
			FROM Syn_Deal_Revenue a
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = a.Syn_Deal_Code
		) as e 
		WHERE e.RevenueTitle IS NULL or e.RevenuePlatform IS NULL

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2)
		SELECT 'DB Name', 1, 'DDF', 'Agreement No', 'Error Description'

		INSERT INTO #TempResult (DatabaseName, SrNo, Type, Col1, Col2)
		SELECT DISTINCT @DatabaseName, 2, 'DDF', C.Agreement_No,Error_Description = STUFF((
					SELECT DISTINCT ',' + A.Error_Description
					FROM #temp_Queries A
					WHERE a.Agreement_No = C.Agreement_No
					FOR XML PATH('')
					), 1, 1, '')
		FROM #temp_Queries C
	END
	PRINT '====== End Dirty Data Found ========'
	SELECT DatabaseName, SrNo, Type, ISNULL(Col1,'') 'Col1', ISNULL(Col2,'') 'Col2', ISNULL(Col3,'') 'Col3', ISNULL(Col4,'') 'Col4', ISNULL(Col5,'') 'Col5', ISNULL(Col6,'') 'Col6', ISNULL(Col7,'') 'Col7', ISNULL(Col8,'') 'Col8' FROM #TempResult

	IF OBJECT_ID('tempdb..#TmpLogSpace') IS NOT NULL
		DROP TABLE #TmpLogSpace

	IF OBJECT_ID('tempdb..#TempResult') IS NOT NULL
		DROP TABLE #TempResult

	IF OBJECT_ID('tempdb..#Tmp_Pending_Avail_Generation') IS NOT NULL
		DROP TABLE #Tmp_Pending_Avail_Generation

	IF OBJECT_ID('tempdb..#temp_Queries') IS NOT NULL
		DROP TABLE #temp_Queries
END

--truncate table #TempResult
-- SELECT * FROM #TempResult
--exec [USP_RightsU_Health_Checkup]
GO
PRINT N'Altering [dbo].[USP_Syndication_Deal_List_Report]...';


GO
ALTER Procedure [dbo].[USP_Syndication_Deal_List_Report]
(
	@Agreement_No Varchar(100), 
	@Start_Date Varchar(30), 
	@End_Date Varchar(30), 
	@Deal_Tag_Code Int, 
	@Title_Codes Varchar(100), 
	@Business_Unit_code VARCHAR(100), 
	@Is_Pushback Varchar(100),
	@IS_Expired Varchar(100),
	@IS_Theatrical varchar(100),
	@SysLanguageCode INT,
	@DealSegment INT,
	@TypeOfFilm INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date:	18 Feb 2015
-- Description:	Get Syndication Deal List Report Data
-- =============================================
BEGIN
	--DECLARE   
	--@Agreement_No Varchar(100)
	--, @Is_Master_Deal Varchar(2)
	--, @Start_Date Varchar(30)
	--, @End_Date Varchar(30)
	--, @Deal_Tag_Code Int
	--, @Title_Codes Varchar(100)
	--, @Business_Unit_code VARCHAR(100)
	--, @Is_Pushback Varchar(100)
	--, @IS_Expired Varchar(100)
	--, @IS_Theatrical varchar(100)
	--, @SysLanguageCode INT
	--, @DealSegment INT
	--,@TypeOfFilm INT 
	
	--SET @Agreement_No = ''
	--SET @Start_Date= ''
	--SET @End_Date = ''
	--SET @Deal_Tag_Code = 0
	--SET @Title_Codes = '703'
	--SET @Business_Unit_code = '1,5'
	--SET @Is_Pushback = 'N'
	--SET @IS_Expired  = 'N'
	--SET @IS_Theatrical='N'
	--SET @SysLanguageCode = 1
	--SET @DealSegment = ''
	--SET @TypeOfFilm = ''
	
	--if CHARINDEX(',',@Business_Unit_code) > 0
	--begin
	--   set @Business_Unit_code = 0
	--end
      
	DECLARE
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',
	@Col_Head04 NVARCHAR(MAX) = '', 
	@Col_Head05 NVARCHAR(MAX) = '', 
	@Col_Head06 NVARCHAR(MAX) = '', 
	@Col_Head07 NVARCHAR(MAX) = '', 
	@Col_Head08 NVARCHAR(MAX) = '', 
	@Col_Head09 NVARCHAR(MAX) = '', 
	@Col_Head10 NVARCHAR(MAX) = '', 
	@Col_Head11 NVARCHAR(MAX) = '', 
	@Col_Head12 NVARCHAR(MAX) = '', 
	@Col_Head13 NVARCHAR(MAX) = '', 
	@Col_Head14 NVARCHAR(MAX) = '', 
	@Col_Head15 NVARCHAR(MAX) = '', 
	@Col_Head16 NVARCHAR(MAX) = '', 
	@Col_Head17 NVARCHAR(MAX) = '', 
	@Col_Head18 NVARCHAR(MAX) = '', 
	@Col_Head19 NVARCHAR(MAX) = '', 
	@Col_Head20 NVARCHAR(MAX) = '', 
	@Col_Head21 NVARCHAR(MAX) = '', 
	@Col_Head22 NVARCHAR(MAX) = '', 
	@Col_Head23 NVARCHAR(MAX) = '', 
	@Col_Head24 NVARCHAR(MAX) = '', 
	@Col_Head25 NVARCHAR(MAX) = '', 
	@Col_Head26 NVARCHAR(MAX) = '', 
	@Col_Head27 NVARCHAR(MAX) = '', 
	@Col_Head28 NVARCHAR(MAX) = '', 
	@Col_Head29 NVARCHAR(MAX) = '', 
	@Col_Head30 NVARCHAR(MAX) = '', 
	@Col_Head31 NVARCHAR(MAX) = '', 
	@Col_Head32 NVARCHAR(MAX) = '', 
	@Col_Head33 NVARCHAR(MAX) = '', 
	@Col_Head34 NVARCHAR(MAX) = '', 
	@Col_Head35 NVARCHAR(MAX) = '', 
	@Col_Head36 NVARCHAR(MAX) = '', 
	@Col_Head37 NVARCHAR(MAX) = '', 
	@Col_Head38 NVARCHAR(MAX) = '',
	@Col_Head39 NVARCHAR(MAX) = '',
	@Col_Head40 NVARCHAR(MAX) = '',
	@Col_Head41 NVARCHAR(MAX) = '',
	@Col_Head42 NVARCHAR(MAX) = '',
	@Col_Head43 NVARCHAR(MAX) = '',
	@Col_Head44 NVARCHAR(MAX) = '',
	@Col_Head45 NVARCHAR(MAX) = '',
	@Col_Head46 NVARCHAR(MAX) = '',
	@Col_Head47 NVARCHAR(MAX) = '',
	@Col_Head48 NVARCHAR(MAX) = '',
	@Col_Head49 NVARCHAR(MAX) = '',
	@Col_Head50 NVARCHAR(MAX) = '',
	@Col_Head51 NVARCHAR(MAX) = ''

	BEGIN
		IF OBJECT_ID('tempdb..#TEMP_Syndication_Deal_List_Report') IS NOT NULL
		DROP TABLE #TEMP_Syndication_Deal_List_Report

		IF OBJECT_ID('tempdb..#TempSynDealListReport') IS NOT NULL
		DROP TABLE #TempSynDealListReport

		IF OBJECT_ID('tempdb..#AncData') IS NOT NULL
		DROP TABLE #AncData
		
		IF OBJECT_ID('tempdb..#RightTable') IS NOT NULL
		DROP TABLE #RightTable
		
		IF OBJECT_ID('tempdb..#PlatformTable') IS NOT NULL
		DROP TABLE #PlatformTable

		IF OBJECT_ID('tempdb..#RegionTable') IS NOT NULL
		DROP TABLE #RegionTable

		IF OBJECT_ID('tempdb..#LangTable') IS NOT NULL
		DROP TABLE #LangTable

		IF OBJECT_ID('tempdb..#RegionSubDubTable') IS NOT NULL
		DROP TABLE #RegionSubDubTable
		
		IF OBJECT_ID('tempdb..#TitleTable') IS NOT NULL
		DROP TABLE #TitleTable

		IF OBJECT_ID('tempdb..#DealTitleTable') IS NOT NULL
		DROP TABLE #DealTitleTable
	END

	BEGIN
		CREATE TABLE #RightTable(
			Syn_Deal_Code INT,
			Syn_Deal_Rights_Code INT,
			Platform_Codes NVARCHAR(MAX),
			Region_Codes NVARCHAR(MAX),
			SL_Codes NVARCHAR(MAX),
			DB_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX),
			Region_Name NVARCHAR(MAX),
			Subtitle NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			RunType NVARCHAR(MAX),
			RGType VARCHAR(10),
			SLType VARCHAR(10),
			DBType VARCHAR(10),
			Run_Type VARCHAR(100)
		)
		CREATE TABLE #PlatformTable(
			Platform_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX)
		)
		CREATE TABLE #RegionTable(
			Region_Codes NVARCHAR(MAX),
			Region_Names NVARCHAR(MAX),
			Region_Type NVARCHAR(10)
		)
		CREATE TABLE #LangTable(
			Lang_Codes NVARCHAR(MAX),
			Lang_Names NVARCHAR(MAX),
			Lang_Type NVARCHAR(10)
		)		
		CREATE TABLE #TitleTable(
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Director NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			Genre NVARCHAR(MAX)
		)
		CREATE TABLE #DealTitleTable(
			Syn_Deal_Code INT,
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Run_Type VARCHAR(10)
		)
		CREATE TABLE #TEMP_Syndication_Deal_List_Report(
			Syn_Deal_Right_Code VARCHAR(100),
			Business_Unit_Name NVARCHAR(MAX),
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Deal_Type_Code INT,
			Director NVARCHAR(MAX),
			Star_Cast NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			year_of_production INT,
			Syn_Deal_code INT,
			Agreement_No VARCHAR(MAX),
			Deal_Description NVARCHAR(MAX),
			Reference_No NVARCHAR(MAX),
			Agreement_Date DATETIME,
			Deal_Tag_Code INT,
			Deal_Tag_Description NVARCHAR(MAX),
			Party NVARCHAR(MAX),
			Party_Master NVARCHAR(MAX),
			Platform_Name NVARCHAR(MAX),
			Right_Start_Date DATETIME, 
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Territory_Name NVARCHAR(MAX),
			Is_Exclusive CHAR(1),
			Subtitling NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Sub_Licencing VARCHAR(MAX),
			Is_Tentative CHAR(1),
			Is_ROFR CHAR(1),
			First_Refusal_Date DATETIME,
			Restriction_Remarks NVARCHAR(MAX),
			Holdback_Platform NVARCHAR(MAX),
			Holdback_Rights NVARCHAR(MAX),
			Blackout NVARCHAR(MAX),
			General_Remark NVARCHAR(MAX),
			Rights_Remarks NVARCHAR(MAX),
			Payment_Remarks NVARCHAR(MAX),
			Right_Type VARCHAR(MAX),
			Right_Term VARCHAR(MAX),
			Deal_Workflow_Status VARCHAR(MAX),
			Is_Pushback CHAR(1),
			Run_Type CHAR(9),
			Is_Attachment CHAR(3),
			[Program_Name] NVARCHAR(MAX),
			Promtoer_Group NVARCHAR(MAX),
			Promtoer_Remarks NVARCHAR(MAX),
			Deal_Segment NVARCHAR(MAX),
			Revenue_Vertical NVARCHAR(MAX),
			Category_Name VARCHAR(MAX),
			Columns_Value_Code INT
			
		)
	END

	DECLARE @IsDealSegment VARCHAR(100), @IsRevenueVertical VARCHAR(100), @IsTypeOfFilm VARCHAR(MAX), @Columns_Code INT
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 
	SELECT @IsRevenueVertical = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Revenue_Vertical' 
	SELECT @IsTypeOfFilm = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Type_Of_Film' 
	SELECT @Columns_Code = Columns_Code FROM Extended_Columns WHERE UPPER(Columns_Name) = 'TYPE OF FILM'

	BEGIN
		INSERT INTO #TEMP_Syndication_Deal_List_Report
		(
			Syn_Deal_Right_Code
			,Business_Unit_Name
			,Title_Code
			,Title_Name
			,Episode_From,Episode_To,Deal_Type_Code
			,Director, Star_Cast ,Genre
			, Title_Language, year_of_production, Syn_Deal_code 
			,Deal_Description, Reference_No, Agreement_No, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party, Party_Master
			,Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right
			,Country_Territory_Name
			,Is_Exclusive
			,Subtitling
			,Dubbing
			,Sub_Licencing
			,Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks
			,Holdback_Platform
			,Holdback_Rights 
			,Blackout
			,General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
			,Right_Term
			,Deal_Workflow_Status
			,Is_Pushback
			,Run_Type
			,Is_Attachment
			,[Program_Name]
			,Promtoer_Group
			,Promtoer_Remarks
			,Category_Name
			,Columns_Value_Code
		)
		SELECT 
			SDR.Syn_Deal_Rights_Code
			,BU.Business_Unit_Name
			,T.Title_Code
			,T.Title_Name
			,CAST(SDRT.Episode_From AS INT),SDRT.Episode_To,SD.Deal_Type_Code 
			--, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director
			--, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast
			--, dbo.UFN_Get_Title_Genre(t.title_code) Genre
			,'' AS Director
			,'' AS Star_Cast
			,'' AS Genre
			, ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, SD.Syn_Deal_Code
			, SD.Deal_Description, SD.Ref_No, SD.Agreement_No, CAST(SD.Agreement_Date as date), SD.Deal_Tag_Code, TG.Deal_Tag_Description, V.Vendor_Name,PG.Party_Group_Name
			--, [dbo].[UFN_Get_Platform_Name](SDR.Syn_Deal_Rights_Code, 'SR') Platform_Name
			,'' AS Platform_Name
			, CAST(SDR.Right_Start_Date as date), CAST(SDR.Right_End_Date as date), SDR.Is_Title_Language_Right
			--,CASE (DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '',''))
			--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, '')
			--	ELSE DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '','')
			-- END AS  Country_Territory_Name
			,'' AS  Country_Territory_Name
			,SDR.Is_Exclusive AS Is_Exclusive
			--, DBO.UFN_Get_Rights_Subtitling(SDR.Syn_Deal_Rights_Code, '') Subtitling
			--,DBO.UFN_Get_Rights_Dubbing(SDR.Syn_Deal_Rights_Code, '') Dubbing
			,'' AS Subtitling
			,'' AS Dubbing
			,CASE LTRIM(RTRIM(SDR.Is_Sub_License))
				WHEN 'Y' THEN SL.Sub_License_Name
				ELSE 'No Sub Licensing'
			 END SubLicencing
			, SDR.Is_Tentative, SDR.Is_ROFR, SDR.ROFR_Date AS First_Refusal_Date, SDR.Restriction_Remarks AS Restriction_Remarks
			, [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](SDR.Syn_Deal_Rights_Code, 'SR','P') Holdback_Platform
			, [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](SDR.Syn_Deal_Rights_Code, 'SR','R') Holdback_Right
			--, [dbo].[UFN_Get_Blackout_Period](SDR.Syn_Deal_Rights_Code, 'SR') Blackout
			--,'' as Holdback_Platform
			--,'' as Holdback_Right
			,'' as Blackout
			, SD.Remarks AS General_Remark, SD.Rights_Remarks AS Rights_Remarks, SD.Payment_Terms_Conditions AS Payment_Remarks, SDR.Right_Type
			, CASE SDR.Right_Type
				WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](SDR.Right_Start_Date, Right_End_Date, Term) 
				WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
				WHEN 'U' THEN 'Perpetuity'
			 END Right_Term
			,CASE UPPER(LTRIM(RTRIM(ISNULL(SD.Deal_Workflow_Status, '')))) 
				WHEN 'N' THEN 'Created'
				WHEN 'W' THEN 'Sent for authorization'
				WHEN 'A' THEN 'Approved' 
				WHEN 'R' THEN 'Declined'
				WHEN 'AM' THEN 'Amended'
				ELSE Deal_Workflow_Status 
			 END AS Deal_Workflow_Status
			,ISNULL(SDR.Is_Pushback, 'N')
			, '' AS Run_Type --[dbo].[UFN_Get_Run_Type] (SD.Syn_Deal_Code,@Title_Codes) AS Run_Type
			,CASE WHEN (SELECT count(*) FROM Syn_Deal_Attachment SDT WHERE SDT.Syn_Deal_Code = SD.Syn_Deal_Code) > 0 THEN 'Yes'
					   ELSE 'No'
			 END AS Is_Attachment
			, P.Program_Name as Program_Name
			, dBO.UFN_Get_Rights_Promoter_Group_Remarks(SDR.Syn_Deal_Rights_Code,'P','S') as Promoter_Group_Name
			, dBO.UFN_Get_Rights_Promoter_Group_Remarks(SDR.Syn_Deal_Rights_Code,'R','S') as Promoter_Remarks_Name
			, C.Category_Name AS Category_Name,MEC.Columns_Value_Code
		FROM Syn_Deal SD
			INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
			INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C'
			INNER JOIN Syn_Deal_Rights_Process_Validation SDRTV ON SDRTV.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND LTRIM(RTRIM(SDRTV.Status)) = 'D'
			INNER JOIN Syn_Deal_Rights_Title SDRT On SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code 
			INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
			LEFT JOIN Party_Group PG ON V.Party_Group_Code = PG.Party_Group_Code
			LEFT JOIN Sub_License SL ON SDR.Sub_License_Code = SL.Sub_License_Code
			INNER JOIN Deal_Tag TG On SD.Deal_Tag_Code = TG.Deal_Tag_Code
			INNER JOIN Title T On SDRT.Title_Code = T.title_code
			LEFT JOIN Program P on T.Program_Code = P.Program_Code
			LEFT JOIN Language L on T.Title_Language_Code = L.language_code
			INNER JOIN Category C ON SD.Category_Code = C.Category_Code
			LEFT JOIN Map_Extended_columns MEC ON MEC.Record_Code = T.Title_Code AND MEC.Columns_Code = @Columns_Code
		WHERE  
			((@IS_Theatrical = 'Y' AND @IS_Theatrical = SDR.Is_Theatrical_Right) OR (@IS_Theatrical <> 'Y')) AND 
			--sdr.Is_Theatrical_Right = @IS_Theatrical  And
			(ISNULL(CONVERT(datetime,SDR.Right_Start_Date,1) , '') >= CONVERT(datetime,@Start_Date,1) OR CONVERT(datetime,@Start_Date,1) = '')		
			AND (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), '') <= CONVERT(datetime,@End_Date,1) OR CONVERT(datetime,@End_Date,1) = '')
			AND SD.Agreement_No like '%' + @Agreement_No + '%' 
			AND (ISNULL(SDR.Is_Pushback, 'N') = @Is_Pushback OR @Is_Pushback = '')
			AND (SD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
			--AND(@Business_Unit_code = '' OR SD.Business_Unit_Code in(select number from fn_Split_withdelemiter(@Title_Codes,',')))
			--AND (SD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
			AND (SD.Business_Unit_Code IN (select number from fn_Split_withdelemiter(@Business_Unit_code,',')))
			AND (@Title_Codes = '' OR SDRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,',')))
			AND (SDR.Syn_Deal_Rights_Code In 
			(SELECT SDRP.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform SDRP 
			Inner Join [Platform] P ON SDRP.Platform_Code = P.Platform_Code AND P.Applicable_For_Demestic_Territory = @IS_Theatrical 
			AND @IS_Theatrical = 'Y'
			) OR @IS_Theatrical = 'N')
			AND (@IS_Expired ='Y' OR (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), GETDATE()) >= GETDATE() AND @IS_Expired ='N'))
	END

	BEGIN
		INSERT INTO #RightTable(Syn_Deal_Code,Syn_Deal_Rights_Code,Platform_Codes,Platform_Names,Region_Name,Subtitle,Dubbing,RunType)
		SELECT Syn_Deal_Code,Syn_Deal_Right_Code,null,null,null,null,null,null  FROM #TEMP_Syndication_Deal_List_Report

		INSERT INTO #TitleTable(Title_Code,Eps_From,Eps_To,Director,StarCast,Genre)
		Select DISTINCT Title_Code,Episode_From,Episode_To,null,null,null FROM #TEMP_Syndication_Deal_List_Report

		INSERT INTO #DealTitleTable(Syn_Deal_Code,Title_Code,Eps_From,Eps_To,Run_Type)
		SELECT DISTINCT Syn_Deal_code,Title_Code,Episode_From,Episode_To,null FROM #TEMP_Syndication_Deal_List_Report
	END


	
	BEGIN
		IF(@IsDealSegment = 'Y' )
		BEGIN
			DELETE tsdlr FROM #TEMP_Syndication_Deal_List_Report tsdlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tsdlr.Syn_Deal_Code
			WHERE AD.Deal_Segment_Code <> @DealSegment AND @DealSegment > 0

			UPDATE tadlr
			SET Deal_Segment = DS.Deal_Segment_Name
			FROM #TEMP_Syndication_Deal_List_Report tadlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tadlr.Syn_Deal_Code
			INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code

		END

		IF(@IsRevenueVertical = 'Y')
		BEGIN
			UPDATE tadlr
			SET Revenue_Vertical = DS.Revenue_Vertical_Name
			FROM #TEMP_Syndication_Deal_List_Report tadlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tadlr.Syn_Deal_Code
			INNER JOIN Revenue_Vertical DS ON DS.Revenue_Vertical_Code = AD.Revenue_Vertical_Code
		END

		IF(@IsTypeOfFilm = 'Y' AND @TypeOfFilm > 0)
		BEGIN
			DELETE FROM #TEMP_Syndication_Deal_List_Report
			WHERE (Columns_Value_Code <> @TypeOfFilm ) OR Columns_Value_Code IS NULL
		END
		
		
		PRINT 'Director, StartCast Insert and update for Primary Rights'
			
		UPDATE TT SET TT.Director = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 1),TT.StarCast = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 2),TT.Genre = dbo.UFN_Get_Title_Genre(TT.TItle_Code)  
		FROM #TitleTable TT
	
		UPDATE TADLR SET TADLR.Director = TT.Director,TADLR.Star_Cast = TT.StarCast,TADLR.Genre = TT.Genre
		FROM #TEMP_Syndication_Deal_List_Report TADLR
		INNER JOIN #TitleTable TT ON TADLR.Title_Code = TT.Title_Code AND TADLR.Episode_From = TT.Eps_From AND TADLR.Episode_To = Eps_To
	
		PRINT 'Platform Insert and update for Primary Rights'
		
		UPDATE RT SET RT.Platform_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(AADRP.Platform_Code AS NVARCHAR(MAX)) from  Syn_Deal_Rights_Platform AADRP 
		WHERE  AADRP.Syn_Deal_Rights_Code = RT.Syn_Deal_Rights_Code  --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		INSERT INTO #PlatformTable(Platform_Codes,Platform_Names)
		SELECT DISTINCT Platform_Codes,Platform_Names FROM #RightTable
		
		UPDATE PT SET PT.Platform_Names = a.Platform_Hierarchy
		from #PlatformTable PT
		CROSS APPLY  [dbo].[UFN_Get_Platform_Hierarchy_WithNo](Platform_Codes) a
		WHERE Platform_Codes IS NOT NULL
	
		UPDATE RT SET RT.Platform_Names = PT.Platform_Names
		FROM #RightTable RT
		INNER JOIN #PlatformTable PT ON RT.Platform_Codes = PT.Platform_Codes
	
		UPDATE TADLR SET TADLR.Platform_Name = RT.Platform_Names
		FROM #TEMP_Syndication_Deal_List_Report TADLR 
		INNER JOIN #RightTable RT ON TADLR.Syn_Deal_Right_Code = RT.Syn_Deal_Rights_Code
	
		PRINT 'Region,Subtitle,Dubbing Insert and update for Primary Rights'
	
		UPDATE RT SET RT.Region_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRP.Country_Code IS NULL THEN AADRP.Territory_Code ELSE AADRP.Country_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Territory AADRP 
		WHERE RT.Syn_Deal_Rights_Code = AADRP.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		UPDATE RT SET RT.RGType = ADRT.Territory_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Territory ADRT ON RT.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code 

		UPDATE RT SET RT.SL_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRS.Language_Code IS NULL THEN AADRS.Language_Group_Code ELSE AADRS.Language_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Subtitling AADRS 
		WHERE RT.Syn_Deal_Rights_Code = AADRS.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,''),
		RT.DB_Codes =
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRD.Language_Code IS NULL THEN AADRD.Language_Group_Code ELSE AADRD.Language_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Dubbing AADRD 
		WHERE RT.Syn_Deal_Rights_Code = AADRD.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		UPDATE RT SET RT.SLType = ADRS.Language_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Subtitling ADRS ON RT.Syn_Deal_Rights_Code = ADRS.Syn_Deal_Rights_Code 
	
		UPDATE RT SET RT.DBType = ADRD.Language_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Dubbing ADRD ON RT.Syn_Deal_Rights_Code = ADRD.Syn_Deal_Rights_Code 
	
		INSERT INTO #RegionTable(Region_Codes,Region_Names,Region_Type)
		SELECT DISTINCT Region_Codes,NULL,RGType FROM #RightTable
	
		INSERT INTO #LangTable(Lang_Codes,Lang_Names,Lang_Type)
		SELECT DISTINCT SL_Codes,NULL,SLType FROM #RightTable
		UNION
		SELECT DISTINCT DB_Codes,NULL,DBType FROM #RightTable
	
		UPDATE RT SET RT.Region_Names = CT.Criteria_Name FROM #RegionTable RT
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](RT.Region_Codes,RT.Region_Type,'RG') CT
	
		UPDATE LTB SET LTB.Lang_Names = LT.Criteria_Name FROM #LangTable LTB
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.Lang_Codes,LTB.Lang_Type,'SL') LT
	
		UPDATE RT SET RT.Region_Name = RTG.Region_Names FROM #RightTable RT
		INNER JOIN #RegionTable RTG ON RT.Region_Codes = RTG.Region_Codes AND RT.RGType = RTG.Region_Type
	
		UPDATE RT SET RT.Subtitle = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.SL_Codes = LTG.Lang_Codes AND RT.SLType = LTG.Lang_Type
	
		UPDATE RT SET RT.Dubbing = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.DB_Codes = LTG.Lang_Codes AND RT.DBType = LTG.Lang_Type
	
		UPDATE TADLR SET TADLR.Country_Territory_Name = RT.Region_Name
		,TADLR.Subtitling = ISNULL(RT.Subtitle,''),TADLR.Dubbing = ISNULL(RT.Dubbing,'') FROM #TEMP_Syndication_Deal_List_Report TADLR
		INNER JOIN #RightTable RT ON TADLR.Syn_Deal_Right_Code = RT.Syn_Deal_Rights_Code
		
	
	END

	BEGIN
		SELECT DISTINCT 
		DBO.UFN_GetTitleNameInFormat( dbo.UFN_GetDealTypeCondition(TEMP_SDLR.Deal_Type_Code), TEMP_SDLR.Title_Name, TEMP_SDLR.Episode_From, TEMP_SDLR.Episode_To) AS Title_Name,
		TEMP_SDLR.Director AS Director,
		TEMP_SDLR.Star_Cast AS Star_Cast,
		TEMP_SDLR.Genre AS Genre,
		TEMP_SDLR.Title_Language AS Title_Language,
		TEMP_SDLR.year_of_production AS Year_Of_Production,
		TEMP_SDLR.Agreement_No AS Agreement_No, 
		TEMP_SDLR.Deal_Description AS Deal_Description, 
		TEMP_SDLR.Reference_No AS Reference_No, 
		TEMP_SDLR.Agreement_Date AS Agreement_Date, TEMP_SDLR.Deal_Tag_Description AS Deal_Tag_Description, 
		TEMP_SDLR.Deal_Segment,
		TEMP_SDLR.Revenue_Vertical,
		TEMP_SDLR.Party AS Party, TEMP_SDLR.Party_Master AS Party_Master,
		CASE WHEN Is_PushBack = 'N' THEN TEMP_SDLR.Platform_Name ELSE '--' END AS Platform_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Start_Date ELSE NULL END AS Rights_Start_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_End_Date ELSE NULL END AS Rights_End_Date, 
		TEMP_SDLR.Is_Title_Language_Right,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Country_Territory_Name ELSE '--' END AS Country_Territory_Name,
		TEMP_SDLR.Is_Exclusive AS Is_Exclusive, 
		CASE LTRIM(RTRIM(TEMP_SDLR.Subtitling)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_SDLR.Subtitling)) END AS Subtitling, 
		CASE LTRIM(RTRIM(TEMP_SDLR.Dubbing)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_SDLR.Dubbing)) END AS Dubbing, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Sub_Licencing ELSE '--' END AS Sub_Licencing,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Is_Tentative ELSE '--' END AS Is_Tentative,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' AND TEMP_SDLR.Is_ROFR = 'Y' THEN TEMP_SDLR.First_Refusal_Date ELSE NULL END AS First_Refusal_Date,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Restriction_Remarks ELSE '--' END AS Restriction_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Holdback_Platform ELSE '--' END AS Holdback_Platform,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Holdback_Rights ELSE '--' END AS Holdback_Rights,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Blackout ELSE '--' END AS Blackout,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.General_Remark ELSE '--' END AS General_Remark,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Rights_Remarks ELSE '--' END AS Rights_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Payment_Remarks ELSE '--' END AS Payment_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Type ELSE '--' END AS Right_Type,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Term ELSE '--' END AS Term,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Is_Tentative ELSE '--' END AS Pushback_Is_Tentative, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Platform_Name ELSE '--' END AS Pushback_Platform_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_Start_Date ELSE NULL END AS Pushback_Start_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_End_Date ELSE NULL END AS Pushback_End_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Country_Territory_Name ELSE '--' END AS Pushback_Country_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Restriction_Remarks ELSE '--' END AS Pushback_Remark, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_Term ELSE '--' END AS Pushback_Term,
		TEMP_SDLR.Deal_Workflow_Status AS Deal_Workflow_Status, 
		TEMP_SDLR.Is_PushBack AS Is_PushBack,
		TEMP_SDLR.Run_Type AS Run_Type,
		TEMP_SDLR.Is_Attachment AS Is_Attachment,
		TEMP_SDLR.[Program_Name] AS [Program_Name],
		(SELECT Deal_Type_Name FROM Deal_Type AS DT WHERE DT.Deal_Type_Code=TEMP_SDLR.Deal_Type_Code) AS Deal_Type,
		TEMP_SDLR.Promtoer_Group AS Promoter_Group_Name,
		TEMP_SDLR.Promtoer_Remarks AS Promoter_Remarks_Name,
		TEMP_SDLR.Category_Name,
		TEMP_SDLR.Business_Unit_Name
		INTO #TempSynDealListReport
		FROM #TEMP_Syndication_Deal_List_Report TEMP_SDLR
		ORDER BY TEMP_SDLR.Agreement_No, TEMP_SDLR.Is_Pushback
	END

	BEGIN
		SELECT 
			@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'Director' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'starCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			@Col_Head13 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			@Col_Head14 = CASE WHEN  SM.Message_Key = 'ReleaseYear' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			@Col_Head15 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			@Col_Head16 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			@Col_Head17 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			@Col_Head18 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			@Col_Head19 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			@Col_Head20 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			@Col_Head21 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			@Col_Head22 = CASE WHEN  SM.Message_Key = 'TitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			@Col_Head23 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			@Col_Head24 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			@Col_Head25 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			@Col_Head26 = CASE WHEN  SM.Message_Key = 'ROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			@Col_Head27 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
			@Col_Head28 = CASE WHEN  SM.Message_Key = 'RightsHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END,
			@Col_Head29 = CASE WHEN  SM.Message_Key = 'RightsHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head29 END,
			@Col_Head30 = CASE WHEN  SM.Message_Key = 'Blackout' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head30 END,
			@Col_Head31 = CASE WHEN  SM.Message_Key = 'RightsRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head31 END,
			@Col_Head32 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head32 END,
 			@Col_Head33 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head33 END,
			@Col_Head34 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head34 END,
			@Col_Head35 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head35 END,
			@Col_Head36 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head36 END,
			@Col_Head37 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackCountry' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head37 END,
			@Col_Head38 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head38 END,
			@Col_Head39 = CASE WHEN  SM.Message_Key = 'GeneralRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head39 END,
			@Col_Head40 = CASE WHEN  SM.Message_Key = 'Paymenttermsconditions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head40 END,
			@Col_Head41 = CASE WHEN  SM.Message_Key = 'WorkflowStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head41 END,
			@Col_Head42 = CASE WHEN  SM.Message_Key = 'RunType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head42 END,
			@Col_Head43 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head43 END,
			@Col_Head44 = CASE WHEN  SM.Message_Key = 'SelfUtilizationGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head44 END,
			@Col_Head45 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END,
			@Col_Head47 = CASE WHEN  SM.Message_Key = 'PartyMasterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head47 END,
			@Col_Head48 = 'Deal Segment',
			@Col_Head49 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head49 END,
			@Col_Head50 = 'Revenue Vertical',
			@Col_Head51 = 'Business Unit Name'

		 FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','AgreementDate','Status','Party','PartyMasterName','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
		 'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
		 ,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks','CategoryName')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

		 IF EXISTS(SELECT TOP 1 * FROM #TempSynDealListReport)
		 BEGIN
			 SELECT 
					 [Agreement_No] , [Business Unit Name],
					 [Title Type], [Deal Description], [Reference No], [Agreement Date], [Status], [Deal Segment], [Revenue Vertical], [Party],[Party_Master], [Program], [Title], [Director]
					 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
					 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
					 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
					 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks],[Category_Name]
				FROM (
			 SELECT
					sorter = 1,
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], CAST(Business_Unit_Name AS VARCHAR(100))  AS [Business Unit Name] ,
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No],
					--CONVERT(VARCHAR(30),[Agreement_Date],103) As [Agreement Date],
					CONVERT(DATE, [Agreement_Date], 103) As [Agreement Date],
					CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status],
					CAST([Deal_Segment] AS NVARCHAR(MAX)) As [Deal Segment], CAST([Revenue_Vertical] AS NVARCHAR(MAX)) As [Revenue Vertical]
					, CAST([Party] AS NVARCHAR(MAX)) As [Party],CAST([Party_Master] AS NVARCHAR(MAX)) As [Party_Master], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(DATE,[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(DATE,[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CONVERT(DATE,[First_Refusal_Date] , 103) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], Convert(DATE,[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(DATE,[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks], CAST([Category_Name] AS NVARCHAR(MAX)) AS [Category_Name]
				From #TempSynDealListReport
				UNION ALL
					SELECT CAST(0 AS Varchar(100)), @Col_Head01, @Col_Head51, 
					@Col_Head02, @Col_Head03, @Col_Head04, GETDATE() , @Col_Head06, @Col_Head48, @Col_Head50, @Col_Head07,@Col_Head47, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
					, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  GETDATE(), GETDATE(), @Col_Head18, 'Pushback', @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, GETDATE()
					, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, GETDATE(), GETDATE(), @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
					, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45,@Col_Head49
				) X   
			ORDER BY Sorter
		END
		ELSE
		BEGIN
			SELECT * FROM #TempSynDealListReport
		END

	END
END
GO
PRINT N'Altering [dbo].[USP_Validate_Delay_Rights_Duplication_Acq]...';


GO
ALTER PROCEDURE [dbo].[USP_Validate_Delay_Rights_Duplication_Acq]
AS
-- =============================================
-- Author:		Akshay Rane
-- Create DATE: 19-Februrary-2021
-- Description:	
-- =============================================
BEGIN
   SET NOCOUNT ON

   IF OBJECT_ID('tempdb..#Tmp_Validate_Rights_Duplication') IS NOT NULL 
		DROP TABLE #Tmp_Validate_Rights_Duplication

	IF OBJECT_ID('tempdb..#Tmp_Linear_Title_Status') IS NOT NULL 
		DROP TABLE #Tmp_Linear_Title_Status

   DECLARE 
   	@Deal_Rights Deal_Rights ,
	@Deal_Rights_Title Deal_Rights_Title  ,
	@Deal_Rights_Platform Deal_Rights_Platform ,
	@Deal_Rights_Territory Deal_Rights_Territory ,
	@Deal_Rights_Subtitling Deal_Rights_Subtitling ,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing 

	CREATE TABLE #Tmp_Linear_Title_Status
	(
		Id INT IDENTITY(1,1),
		Title_Name NVARCHAR(MAX),
		Title_Added NVARCHAR(MAX),
		Runs_Added NVARCHAR(MAX)
	)

	CREATE TABLE #Tmp_Validate_Rights_Duplication
	(
		Acq_Deal_Rights_Code INT,
		Title_Name NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX),
		Right_Start_Date DATETIME,
		Right_End_Date DATETIME,
		Right_Type NVARCHAR(MAX),
		Is_Sub_License NVARCHAR(MAX),
		Is_Title_Language_Right NVARCHAR(MAX),
		Country_Name NVARCHAR(MAX),
		Subtitling_Language NVARCHAR(MAX),
		Dubbing_Language NVARCHAR(MAX),
		Agreement_No NVARCHAR(MAX),
		ErrorMSG NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT
	)

   	DECLARE @Acq_Deal_Rights_Code INT = 0, @Deal_Rights_Process_Code INT = 0, @ErrorCount INT = 0, @Deal_Code INT = 0
	DECLARE @RunPending INT, @RightsPending INT ,@DealCompleteFlag NVARCHAR(MAX)=''

	SELECT @DealCompleteFlag = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Deal_Complete_Flag'
	SET  @DealCompleteFlag = REPLACE(@DealCompleteFlag,' ','')

	DECLARE db_cursor CURSOR FOR 
	SELECT DISTINCT Deal_Rights_Code, Deal_Rights_Process_Code, Deal_Code FROM Deal_Rights_Process WHERE Record_Status = 'P' AND ISNULL(Rights_Bulk_Update_Code , 0) = 0

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Rights_Process_Code, @Deal_Code
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN 	
		SELECT  @ErrorCount = 0, @RunPending = 0, @RightsPending = 0

		DELETE FROM #Tmp_Linear_Title_Status
		DELETE FROM Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

		INSERT INTO @Deal_Rights (
			Deal_Rights_Code, Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type,Is_Tentative,
			Term, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Right_Start_Date, Right_End_Date
			)
		SELECT 
			0,Acq_Deal_Code,Is_Exclusive,Is_Title_Language_Right,Is_Sub_License,Sub_License_Code,Is_Theatrical_Right,Right_Type,Is_Tentative,
			Term,Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_ROFR,ROFR_Date,Restriction_Remarks,Right_Start_Date, Right_End_Date
		FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To )
		SELECT 0,Title_Code,Episode_From,Episode_To
		FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Platform (Deal_Rights_Code, Platform_Code)
		SELECT 0, Platform_Code FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Territory (Deal_Rights_Code, Territory_Type, Territory_Code, Country_Code)
		SELECT 0, Territory_Type, Territory_Code, Country_Code
		FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Subtitling (Deal_Rights_Code, Language_Type, Language_Group_Code, Subtitling_Code)
		SELECT 0, Language_Type, Language_Group_Code, Language_Code
		FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Dubbing (Deal_Rights_Code, Language_Type, Language_Group_Code, Dubbing_Code)
		SELECT 0, Language_Type, Language_Group_Code, Language_Code
		FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		IF((SELECT COUNT(*) From Deal_Rights_Process WHERE ISNULL(Rights_Bulk_Update_Code , 0) = 0 AND Record_Status = 'W') = 0)
		BEGIN

			UPDATE Deal_Rights_Process SET Record_Status = 'W', Process_Start = GETDATE(), Porcess_End = NULL, Error_Messages= NULL WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code
			UPDATE Acq_Deal_Rights SET Right_Status = 'W' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

			BEGIN TRY
			BEGIN TRANSACTION 
				INSERT INTO #Tmp_Validate_Rights_Duplication
				(
					Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
					Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To 
				)
				EXECUTE USP_Validate_Rights_Duplication_UDT_ACQ
					 @Deal_Rights ,@Deal_Rights_Title ,@Deal_Rights_Platform ,@Deal_Rights_Territory ,@Deal_Rights_Subtitling ,@Deal_Rights_Dubbing ,'AR','N',@Deal_Rights_Process_Code
			COMMIT
			END TRY
			BEGIN CATCH
					ROLLBACK

				IF((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Acq_rights_delay_validation') = 'Y')
				BEGIN
					 UPDATE Deal_Rights_Process SET Porcess_End = GETDATE(), Error_Messages = ERROR_MESSAGE(), Record_Status = 'E'
					 WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code AND Record_Status = 'W'

					 UPDATE Acq_Deal_Rights set Right_Status = 'E' WHERE Acq_Deal_Rights_Code = (SELECT Deal_Rights_Code FROM Deal_Rights_Process WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code)
				 END

			END CATCH
			
			SELECT @ErrorCount = COUNT(*) FROM #Tmp_Validate_Rights_Duplication

			IF (@ErrorCount = 0)
			BEGIN
					IF(SELECT Record_Status FROM Deal_Rights_Process  WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code ) <> 'E'
					BEGIN
						UPDATE Deal_Rights_Process SET Record_Status = 'D', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Rights_Process_Code = @Deal_Rights_Process_Code
						UPDATE Acq_Deal_Rights SET Right_Status = 'C' WHERE Right_Status = 'W' AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
						--Check Linear Status
						BEGIN

							INSERT INTO #Tmp_Linear_Title_Status (Title_Name, Title_Added, Runs_Added)
							EXEC USP_List_Acq_Linear_Title_Status @Deal_Code

							SELECT @RunPending = COUNT(*) FROM #Tmp_Linear_Title_Status WHERE Title_Added = 'Yes~'
							SELECT @RightsPending =  COUNT(*) FROM #Tmp_Linear_Title_Status WHERE Title_Added = 'No'
							SELECT @RunPending = CASE WHEN @DealCompleteFlag = 'R,R' OR @DealCompleteFlag = 'R,R,C' THEN @RunPending ELSE 0 END

							UPDATE Acq_Deal SET Deal_Workflow_Status = 
							CASE WHEN @RunPending > 0 AND @RightsPending > 0 THEN 'RR' 
								 WHEN @RunPending > 0 AND @RightsPending = 0 THEN 'RP' 
								 ELSE 'N' END
							WHERE  Acq_Deal_Code = @Deal_Code 

						END
					END
			END
			ELSE IF (@ErrorCount > 0)
			BEGIN
				
				 UPDATE #Tmp_Validate_Rights_Duplication SET Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				 
				 INSERT INTO Acq_Deal_Rights_Error_Details
				 (
				 	 Acq_Deal_Rights_Code, Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
				 	Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To, Is_Updated , Inserted_On 
				 )
				 SELECT DISTINCT  Acq_Deal_Rights_Code, Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
				 	Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To,'N', GETDATE() 
				 FROM #Tmp_Validate_Rights_Duplication

				 UPDATE Deal_Rights_Process SET Record_Status = 'E', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Rights_Process_Code = @Deal_Rights_Process_Code
				 UPDATE Acq_Deal_Rights SET Right_Status = 'E' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
			END		
		END

		FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Rights_Process_Code, @Deal_Code
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 
END


--select * from @Deal_Rights 
--select * from @Deal_Rights_Title 
--select * from @Deal_Rights_Platform
--select * from @Deal_Rights_Territory 
--select * from @Deal_Rights_Subtitling
--select * from @Deal_Rights_Dubbing 
--select * from Deal_Rights_Process
GO
PRINT N'Creating [dbo].[USP_Get_EmailConfig_Users]...';


GO
CREATE PROCEDURE USP_Get_EmailConfig_Users 
(
	@Key VARCHAR(4),
	@CallFor CHAR(1) = 'N'
)       
AS    
BEGIN
	--DECLARE @Key NVARCHAR(MAX) = 'CUR', @CallFor  CHAR(1) = 'Y'
	DECLARE @Tbl2 TABLE (
		Id INT IDENTITY(1,1),
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)

	DECLARE	@tbl TABLE (
		id int identity(1,1),
		BuCode INT, 
		To_Users_Code INT, 
		To_User_Mail_Id NVARCHAR(MAX),
		CC_Users_Code INT, 
		CC_User_Mail_Id NVARCHAR(MAX), 
		BCC_Users_Code INT, 
		BCC_User_Mail_Id NVARCHAR(MAX),
		Channel_Codes VARCHAR(MAX))

	DECLARE 
	@Business_Unit_Codes NVARCHAR(MAX),
	@To_User_Codes NVARCHAR(MAX),
	@CC_Users NVARCHAR(MAX),
	@BCC_Users  NVARCHAR(MAX),
	@Security_Group_Code NVARCHAR(MAX),
	@User_Type NVARCHAR(MAX),
	@Channel_Codes NVARCHAR(MAX),
	@ToUser_MailID NVARCHAR(MAX),
	@CCUser_MailID NVARCHAR(MAX),
	@BCCUser_MailID NVARCHAR(MAX),
	@BUCode INT

	DECLARE db_cursor CURSOR FOR 
	SELECT  ECDU.Business_Unit_Codes,
			ECDU.User_Codes, 
			ECDU.CC_Users, 
			ECDU.BCC_Users, 
			ECDU.Security_Group_Code, 
			User_Type, 
			ECDU.Channel_Codes,
			ECDU.ToUser_MailID,	
			ECDU.CCUser_MailID,	
			ECDU.BCCUser_MailID
	FROM Email_Config EC 
		INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
		INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	WHERE [Key] = @Key
	
	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO 	@Business_Unit_Codes  ,@To_User_Codes	,@CC_Users  ,@BCC_Users   ,@Security_Group_Code  ,@User_Type  ,@Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID 

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		  
		  IF(@User_Type = 'U')
		  BEGIN
				INSERT INTO @tbl(BuCode, To_Users_Code, Channel_Codes, To_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
				WHERE U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@To_User_Codes,','))
					AND (UBU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'OR ISNULL(@Business_Unit_Codes,'0') = '0')
				
		  END
		  ELSE IF(@User_Type = 'G')
		  BEGIN
				INSERT INTO @tbl(BuCode, To_Users_Code, Channel_Codes, To_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code,U.Users_Code,@Channel_Codes,U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code=U.Users_Code
				WHERE U.Security_Group_Code IN (@Security_Group_Code)
					AND (UBU.Business_Unit_Code IN(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y' OR ISNULL(@Business_Unit_Codes,'0') = '0')
		  END
		  ELSE IF(@User_Type = 'E')
		  BEGIN

				INSERT INTO @tbl(BuCode, Channel_Codes, To_User_Mail_Id, CC_User_Mail_Id, BCC_User_Mail_Id)
				SELECT number, @Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID from fn_Split_withdelemiter(@Business_Unit_Codes,',')

		  END

		  IF(@CC_Users IS NOT NULL)
		  BEGIN
				INSERT INTO @tbl(BuCode, CC_Users_Code, Channel_Codes, CC_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
				WHERE U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@CC_Users,','))
					AND (UBU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'OR ISNULL(@Business_Unit_Codes,'0') = '0')
		   END

		  IF(@BCC_Users IS NOT NULL)
		  BEGIN
				INSERT INTO @tbl(BuCode, BCC_Users_Code, Channel_Codes, BCC_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
				WHERE U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@BCC_Users,','))
					AND (UBU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'OR ISNULL(@Business_Unit_Codes,'0') = '0')
		  END

		  FETCH NEXT FROM db_cursor INTO 	@Business_Unit_Codes  ,@To_User_Codes	,@CC_Users  ,@BCC_Users   ,@Security_Group_Code  ,@User_Type  ,@Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID 
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor

	IF @CallFor = 'Y'
	BEGIN
		SELECT A. BUCode, A.Users_Code , A.User_Mail_Id  FROM (
		SELECT BUCode, To_Users_Code As Users_Code , To_User_Mail_Id AS User_Mail_Id  
		FROM @tbl WHERE To_Users_Code IS NOT NULL OR CC_Users_Code IS NOT NULL or BCC_Users_Code IS NOT NULL
		UNION ALL
		SELECT BuCode, NULL, To_User_Mail_Id FROM @tbl WHERE To_Users_Code IS NULL AND CC_Users_Code IS NULL AND BCC_Users_Code IS NULL
		) AS A WHERE ISNULL(A.Users_Code,'') <> ''

		--SELECT BUCode, COALESCE(To_Users_Code,CC_Users_Code, BCC_Users_Code) As Users_Code , COALESCE(To_User_Mail_Id,CC_User_Mail_Id, BCC_User_Mail_Id) AS User_Mail_Id  
		--FROM @tbl WHERE To_Users_Code IS NOT NULL OR CC_Users_Code IS NOT NULL or BCC_Users_Code IS NOT NULL
		--UNION ALL
		--SELECT BuCode, NULL, To_User_Mail_Id+';'+CC_User_Mail_Id+';'+BCC_User_Mail_Id FROM @tbl WHERE To_Users_Code IS NULL AND CC_Users_Code IS NULL AND BCC_Users_Code IS NULL
	END

	DECLARE db_BU_cursor CURSOR FOR 
	SELECT DISTINCT BuCode, Channel_Codes FROM @tbl

	OPEN db_BU_cursor  
	FETCH NEXT FROM db_BU_cursor INTO @BUCode ,@Channel_Codes

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
			INSERT INTO @Tbl2 (BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes)
			SELECT @BUCode, STUFF((
					SELECT ',' + CAST(To_Users_Code AS NVARCHAR(MAX))
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ';' + To_User_Mail_Id
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ',' + CAST(CC_Users_Code AS NVARCHAR(MAX))
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ';' + CC_User_Mail_Id
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''),
				STUFF((
					SELECT ',' + CAST(BCC_Users_Code AS NVARCHAR(MAX))
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ';' + BCC_User_Mail_Id
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), @Channel_Codes

		 
		  FETCH NEXT FROM db_BU_cursor INTO @BUCode , @Channel_Codes
	END 

	CLOSE db_BU_cursor  
	DEALLOCATE db_BU_cursor 
	
	IF @CallFor = 'N'
		SELECT Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes FROM @tbl2

END
GO
PRINT N'Creating [dbo].[USP_Insert_Email_Notification_Log]...';


GO
CREATE PROCEDURE [dbo].[USP_Insert_Email_Notification_Log]
(
	@Email_Config_Users_UDT Email_Config_Users_UDT  READONLY
)
As
-- =============================================
-- Author:		Akshay Rane
-- Create Date:   22-October-2021
-- Description:	
-- =============================================
BEGIN
	
	--DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	--INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
	--SELECT 1,'Table 1', '', '','143,254','utosupport_uto@uto.in;viraj_Bhagat@uto.in','204,208','Jatin_Patel@uto.in;Deepak_Kurian@uto.in','Subject'
	--UNION
	--SELECT 1,'Table 2', '1319,1324', 'sds_daf@uto.in;Test_K@uto.in','136,1319','Ragnar_Tygerian@uto.in;sds_daf@uto.in','','Uto_Cs@uto.in;sds_daf@uto.in','Subject'


	IF OBJECT_ID('tempdb..#Email_Config_Users_UDT') IS NOT NULL  
		DROP TABLE #Email_Config_Users_UDT 

	SELECT * INTO #Email_Config_Users_UDT FROM @Email_Config_Users_UDT

	DELETE FROM #Email_Config_Users_UDT WHERE To_Users_Code = '' AND BCC_Users_Code = '' AND CC_Users_Code = ''

	BEGIN
		INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
		SELECT tbl1.Email_Config_Code, GETDATE(), 'N', Tbl1.Email_Body, Tbl2.number, Tbl1.Subject ,Tbl1.number FROM 
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY A.Email_Config_Users_UDT_Code) AS RowNo, B.number
			, A.Email_Config_Code, A.Email_Body, A.[Subject]
			FROM #Email_Config_Users_UDT A
			CROSS APPLY dbo.fn_Split_withdelemiter(A.To_User_Mail_Id,';') AS B  
			WHERE ISNULL(A.To_User_Mail_Id,'') <> ''
		) AS Tbl1
		INNER JOIN 
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY  C.Email_Config_Users_UDT_Code) AS RowNo, D.number 
			, C.Email_Config_Code, C.Email_Body, C.[Subject]
			FROM #Email_Config_Users_UDT C
			CROSS APPLY dbo.fn_Split_withdelemiter(C.To_Users_Code,',')  AS D 
			WHERE ISNULL(C.To_User_Mail_Id,'') <> ''
		) as Tbl2 ON Tbl1.RowNo = Tbl2.RowNo

		UNION ALL 

		SELECT tbl1.Email_Config_Code, GETDATE(), 'N', Tbl1.Email_Body, Tbl2.number, Tbl1.Subject ,Tbl1.number FROM 
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY A.Email_Config_Users_UDT_Code) AS RowNo, B.number
			, A.Email_Config_Code, A.Email_Body, A.[Subject]
			FROM #Email_Config_Users_UDT A
			CROSS APPLY dbo.fn_Split_withdelemiter(A.CC_User_Mail_Id,';') AS B 
			WHERE ISNULL(A.CC_User_Mail_Id,'') <> ''
		) AS Tbl1
		INNER JOIN 
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY  C.Email_Config_Users_UDT_Code) AS RowNo, D.number 
			, C.Email_Config_Code, C.Email_Body, C.[Subject]
			FROM #Email_Config_Users_UDT C
			CROSS APPLY dbo.fn_Split_withdelemiter(C.CC_Users_Code,',')  AS D 
			WHERE ISNULL(C.CC_User_Mail_Id,'') <> ''
		) as Tbl2 ON Tbl1.RowNo = Tbl2.RowNo

		UNION ALL 

		SELECT tbl1.Email_Config_Code, GETDATE(), 'N', Tbl1.Email_Body, Tbl2.number, Tbl1.Subject ,Tbl1.number FROM 
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY A.Email_Config_Users_UDT_Code) AS RowNo, B.number
			, A.Email_Config_Code, A.Email_Body, A.[Subject]
			FROM #Email_Config_Users_UDT A
			CROSS APPLY dbo.fn_Split_withdelemiter(A.BCC_User_Mail_Id,';') AS B  
			WHERE ISNULL(A.BCC_User_Mail_Id,'') <> ''
		) AS Tbl1
		INNER JOIN 
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY  C.Email_Config_Users_UDT_Code) AS RowNo, D.number 
			, C.Email_Config_Code, C.Email_Body, C.[Subject]
			FROM #Email_Config_Users_UDT C
			CROSS APPLY dbo.fn_Split_withdelemiter(C.BCC_Users_Code,',')  AS D 
			WHERE ISNULL(C.BCC_User_Mail_Id,'') <> ''
		) as Tbl2 ON Tbl1.RowNo = Tbl2.RowNo
	END
END
GO
PRINT N'Altering [dbo].[USP_Deal_Expiry_Email]...';


GO
ALTER PROCEDURE [dbo].[USP_Deal_Expiry_Email] 
	--DECLARE
	@Expiry_Type Char(1)='D',
	@Alert_Type CHAR(4)='TER'
AS
-- =============================================
-- Author:		Punam Roddewar
-- Create DATE: 23-Jan-2015
-- Description:	Send Acquisition deal expiry mail or ROFR mail
--				@Alert_Type is 'A' means 'Acquisition deal expiry mail' or 
--				@Alert_Type is 'R' means 'ROFR mail' --Expiry_Type=D/W
--				@Alert_Type is 'S' means 'Syn deal expiry mail' or 	
--Last Updated by : Akshay Rane
-- =============================================     
BEGIN 

	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#EMAIL_ID_TEMP1') IS NOT NULL
	BEGIN
		DROP TABLE #EMAIL_ID_TEMP1
	END 
	IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS') IS NOT NULL
	BEGIN
		DROP TABLE #ACQ_EXPIRING_DEALS
	END

	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = @Alert_Type
	DECLARE @EXP_Count	int
	SET @EXP_Count = ''
	
	DECLARE @Deal_heading VARCHAR(20) = 'Expiring'		
	DECLARE @RowTitleCodeOld varchar(max),@RowTitleCodeNew varchar(max),@WhereCondition varchar (2)
	SET @RowTitleCodeOld = ''
	SET @RowTitleCodeNew = ''
	
	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL
	BEGIN
		DROP TABLE #DealDetails
	END
	IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL
	BEGIN
		Drop Table #Alert_Range
	END
	DECLARE @MailSubjectCr AS VARCHAR(250),@Mail_alert_days int,@Deal_Expiry_email_code int
	Create table #DealDetails
	(
		ID INT IDENTITY (1,1),
		Agreement_No VARCHAR(100),
		Title_Code INT,
		Title_Name NVARCHAR(MAX),
		Right_Start_Date DateTime,
		Right_End_Date DateTime,
		Platform_Code VARCHAR(2000),
		Platform_name NVARCHAR(4000),
		Country NVARCHAR(MAX),
		Is_Available CHAR(1) NULL,
		Is_Processed CHAR(1),
		PlatformCodeCount INT,
		Acq_Deal_Rights_Code VARCHAR(1000),
		Expire_In_Days VARCHAR(30),
		Business_Unit_Code int,
		Vendor_Name NVARCHAR(max),
		ROFR_Type  NVARCHAR(max),
		ROFR_Date DateTime
	)
	--select * from Email_Config_Detail_Alert
	
	--Select Distinct Case When Allow_less_Than = 'Y' Then 0 Else Mail_alert_days End As Start_Range, Mail_alert_days As End_Range InTo #Alert_Range
	--From Deal_Expiry_Email Where Alert_Type = @Alert_Type
	--select * from Email_Config_Detail_Alert
	--Change
	Select Distinct Case When EDA.Allow_less_Than = 'Y' Then 0 Else Mail_Alert_Days End As Start_Range, Mail_Alert_Days As End_Range
	, EDA.Allow_less_Than, EDA.Mail_Alert_Days 
	InTo #Alert_Range
	From Email_Config_Detail_Alert EDA
	INNER JOIN Email_Config_Detail ED ON ED.Email_Config_Detail_Code=EDA.Email_Config_Detail_Code
	INNER JOIN Email_Config E ON E.Email_Config_Code=ED.Email_Config_Code
	Where E.[Key] = @Alert_Type 
	--Change
	--select * from #Alert_Range
	IF(@Alert_Type = 'ACE')
	BEGIN
	PRINT 'ACE1'
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
						Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #ACQ_EXPIRING_DEALS
		FROM
		(		 
			SELECT DISTINCT adr.Acq_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
					adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
					Country_Code, Territory_Code, Territory_Type,
					ad.Acq_Deal_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
					DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
			From Acq_Deal_Rights adr 
			INNER JOIN Acq_Deal Ad ON Ad.Acq_Deal_Code = adr.Acq_Deal_Code AND Ad.Deal_Workflow_Status = 'A'
			Inner Join Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
			Inner Join Acq_Deal_Rights_Platform adrp On adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
			Inner Join Acq_Deal_Rights_Territory adrc On adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
			Where ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M') 
			AND adr.Is_Tentative != 'Y'
			--Where Actual_Right_End_Date Is Not Null
		) b 
		Where [row] = 1 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
		And Exists (
			Select 1 From #Alert_Range tmp Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
		)

		INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
					Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
		SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
		FROM (
			Select Acq_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
			Expire_In_Days,
			(
				stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
				FROM #ACQ_EXPIRING_DEALS t2 
				Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
			) as PlatformCodes,
			CASE t1.Territory_Type
				WHEN 'G' THEN
				(
					stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #ACQ_EXPIRING_DEALS t2
					Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)	 
				Else
				(
					stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #ACQ_EXPIRING_DEALS t2
					Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)
			END	as CountryNames,
			t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
			(
				stuff((SELECT DISTINCT ', ' + cast(Vendor_Name as NVARCHAR(max))
				FROM Vendor v1 
				inner join Acq_Deal_Licensor a1 on v1.Vendor_Code=a1.Vendor_Code 
				WHERE a1.Acq_Deal_Code=AD.Acq_Deal_Code FOR XML PATH('') ), 1, 1, '') 
			) as Vendor_Name
			FROM #ACQ_EXPIRING_DEALS t1
			INNER join  Acq_Deal AD on ad.Acq_Deal_Code= t1.Acq_Deal_Code
			INNER JOIN Title T ON T.Title_Code = t1.Title_Code
			Group By AD.Acq_Deal_Code, Acq_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
						Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days--,Vendor_Name
		) MainOutput
		Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
		) as a
			
		Drop table #ACQ_EXPIRING_DEALS
	END
	ELSE IF(@Alert_Type = 'SYE')
	BEGIN
		SELECT DISTINCT Syn_Deal_Code, Syn_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
						Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #SYN_EXPIRING_DEALS
		FROM
		(
			SELECT DISTINCT adr.Syn_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
					adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
					Country_Code, Territory_Code, Territory_Type,
					sd.Syn_Deal_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
					DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
			From Syn_Deal_Rights adr 
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code = adr.Syn_Deal_Code AND SD.Deal_Workflow_Status = 'A'
			Inner Join Syn_Deal_Rights_Title adrt On adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
			Inner Join Syn_Deal_Rights_Platform adrp On adr.Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code
			Inner Join Syn_Deal_Rights_Territory adrc On adr.Syn_Deal_Rights_Code = adrc.Syn_Deal_Rights_Code
			Where ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M')
			AND ISNULL(Right_Status,'') = 'C'
			AND adr.Is_Tentative != 'Y'
			--Where Actual_Right_End_Date Is Not Null
		) b 
		Where [row] = 1
		 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
		And Exists 
		(
			Select 1 From #Alert_Range tmp 
			Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
		)
		INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
					Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
		SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
		FROM (
			Select Syn_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
			Expire_In_Days,
			(
				stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
				FROM #Syn_EXPIRING_DEALS t2 
				Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
			) as PlatformCodes,
			CASE t1.Territory_Type
				WHEN 'G' THEN
				(
					stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #Syn_EXPIRING_DEALS t2
					Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)	 
				Else
				(
					stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #Syn_EXPIRING_DEALS t2
					Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)
			END	as CountryNames,
			t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
			V.Vendor_Name 
			FROM #Syn_EXPIRING_DEALS t1
			INNER join  Syn_Deal AD on ad.Syn_Deal_Code= t1.Syn_Deal_Code
			INNER join  Vendor V on V.Vendor_Code= AD.Vendor_Code
			INNER JOIN Title T ON T.Title_Code = t1.Title_Code
			Group By AD.Syn_Deal_Code, Syn_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
						Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days,Vendor_Name
		) MainOutput
		Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
		) as a

		Drop table #Syn_EXPIRING_DEALS
	END
	ELSE IF(@Alert_Type = 'TER')
	BEGIN
		
			SELECT DISTINCT adr.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adrc.Country_Code, adrc.Territory_Code, Territory_Type, adrp.Platform_Code, 
					 Actual_Right_Start_Date, Actual_Right_End_Date, 'N' as IsProcessed, 
					DATEDIFF(dd, GETDATE(), ISNULL(Actual_Right_Start_Date, '31Dec9999')) AS Expire_In_Days
			INTO #ACQ_TENTATIVE_DEALS
			FROM Acq_Deal_Rights adr 
			INNER JOIN Acq_Deal_Rights_Title adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Territory adrc ON adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
			WHERE 1 =1 --GETDATE() BETWEEN Actual_Right_Start_Date AND Actual_Right_End_Date
			AND EXISTS (
				SELECT 1 FROM #Alert_Range tmp WHERE DATEDIFF(dd, GETDATE(), ISNULL(Actual_Right_Start_Date, '31Dec9999')) BETWEEN tmp.Start_Range AND tmp.End_Range
			)
			AND ISNULL(adr.Is_Tentative, 'Y') = 'Y'
			
		INSERT INTO #DealDetails(Platform_name, PlatformCodeCount, Acq_Deal_Rights_Code, Agreement_No, Title_Code, Title_Name,
					Right_Start_Date, Right_End_Date, Expire_In_Days, Platform_Code, Country, Is_Processed, Business_Unit_Code, Vendor_Name)
		SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count, MainOutput.*
		FROM (
			SELECT Acq_Deal_Rights_Code, Ad.Agreement_No, T.Title_Code, T.title_name, Actual_Right_Start_Date, Actual_Right_End_Date,
			Expire_In_Days,
			(
				STUFF((SELECT DISTINCT ',' + CAST(Platform_Code AS VARCHAR(MAX)) 
				FROM #ACQ_TENTATIVE_DEALS t2 
				WHERE t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
			) AS PlatformCodes,
			CASE t1.Territory_Type
				WHEN 'G' THEN
				(
					STUFF((SELECT DISTINCT ', ' + CAST(c.Territory_Name AS NVARCHAR(MAX))FROM #ACQ_TENTATIVE_DEALS t2
					INNER JOIN Territory c ON t2.Territory_Code = c.Territory_Code WHERE t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)	 
				ELSE
				(
					STUFF((SELECT DISTINCT ', ' + CAST(c.Country_Name AS NVARCHAR(MAX))FROM #ACQ_TENTATIVE_DEALS t2
					INNER JOIN Country c ON t2.Country_Code = c.Country_Code WHERE t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)
			END	AS CountryNames,
			t1.IsProcessed, ISNULL(Business_Unit_Code,0) AS Business_Unit_Code,
			(
				STUFF((SELECT DISTINCT ', ' + CAST(Vendor_Name AS NVARCHAR(MAX))
				FROM Vendor v1 
				INNER JOIN Acq_Deal_Licensor a1 ON v1.Vendor_Code=a1.Vendor_Code 
				WHERE a1.Acq_Deal_Code=AD.Acq_Deal_Code FOR XML PATH('') ), 1, 1, '') 
			) AS Vendor_Name
			FROM #ACQ_TENTATIVE_DEALS t1
			INNER JOIN  Acq_Deal AD ON ad.Acq_Deal_Code = t1.Acq_Deal_Code
			INNER JOIN Title T ON T.Title_Code = t1.Title_Code
			GROUP BY AD.Acq_Deal_Code, Acq_Deal_Rights_Code, Ad.Agreement_No, T.Title_Code, T.title_name,
						Actual_Right_Start_Date, Actual_Right_End_Date, IsProcessed, Business_Unit_Code, Territory_Type, Expire_In_Days--,Vendor_Name
		) MainOutput
			CROSS APPLY(SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
		) AS a

		DROP TABLE #ACQ_TENTATIVE_DEALS
	END
	ELSE IF(@Alert_Type = 'AROD')
	BEGIN
	PRINT 'AROD'
		SET @Deal_heading ='ROFR'
		INSERT INTO #DealDetails(Agreement_No,Title_Code,Title_Name,Right_Start_Date,Right_End_Date,Platform_Code,Platform_name,
				Country,Is_Processed,PlatformCodeCount,Acq_Deal_Rights_Code,Expire_In_Days,Business_Unit_Code,Vendor_Name,ROFR_Date, ROFR_Type)
		SELECT DISTINCT  Agreement_No, Title_Code, Title_name, Right_Start_Date, Right_End_Date, PlatformCodes, Platform_Name,
				Country,'N' as IsProcessed,Platform_Count,cast (Acq_Deal_Rights_Code as varchar(1000)), ROFR_In_Days,
				IsNull(Business_Unit_Code,0),Vendor_Name , b.ROFR_Date , b.ROFR_Type
		FROM VW_ACQ_EXPIRING_DEALS b
		Where ROFR_In_Days Is Not Null And ROFR_In_Days > 0
		And Exists (
			Select 1 From #Alert_Range tmp Where b.ROFR_In_Days Between tmp.Start_Range And tmp.End_Range
		)
	END	
	ELSE IF(@Alert_Type = 'SROD')
	BEGIN
	PRINT 'SROD'
		SET @Deal_heading ='ROFR'
		INSERT INTO #DealDetails(Agreement_No,Title_Code,Title_Name,Right_Start_Date,Right_End_Date,Platform_Code,Platform_name,
				Country,Is_Processed,PlatformCodeCount,Acq_Deal_Rights_Code,Expire_In_Days,Business_Unit_Code,Vendor_Name,ROFR_Date, ROFR_Type)
		SELECT DISTINCT  Agreement_No, Title_Code, Title_name, Right_Start_Date, Right_End_Date, PlatformCodes, Platform_Name,
				Country,'N' as IsProcessed,Platform_Count,cast (Syn_Deal_Rights_Code as varchar(1000)), ROFR_In_Days,
				IsNull(Business_Unit_Code,0),Vendor_Name , b.ROFR_Date , b.ROFR_Type
		FROM VW_SYN_EXPIRING_DEALS b
		Where ROFR_In_Days Is Not Null And ROFR_In_Days > 0
		And Exists (
			Select 1 From #Alert_Range tmp Where b.ROFR_In_Days Between tmp.Start_Range And tmp.End_Range
		)
	END	

	------------
	DECLARE
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX),
	@Channel_Codes  NVARCHAR(MAX)
	
	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)	
	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users @Alert_Type, 'N'
	
	------------------

	DECLARE @Users_Code INT
	--Drop Table #Alert_Range
	DECLARE @Index INT = 0
	--Select * from  #DealDetails --------------------------------------------------------------------------------------------------------
	DECLARE @Business_Unit_Code int,@Users_Email_Id NVARCHAR(MAX),@Emailbody NVARCHAR(Max)
	--Change
	DECLARE curOuter CURSOR FOR SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
	--Change
	OPEN curOuter 
	FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
	WHILE @@Fetch_Status = 0 
	BEGIN	
		Declare @Temp_tbl_count int
		Set @Temp_tbl_count=0
		Set @Emailbody = ''
		SET @Index = 0
		DECLARE @ID INT, @Record_Found CHAR(1), @Agreement_No VARCHAR(1000), @Title_Name NVARCHAR(MAX),
				@Rights_Start_Date VARCHAR(1000), @Rights_End_Date VARCHAR(1000),@Business_Unit_Code1 varchar(100),@Expire_In_Days1 varchar(100)
		DECLARE @Title_Code INT, @Territory_code INT, @Platform_Code varchar(1000), @Territory_Name NVARCHAR(1000), @Platform_Name NVARCHAR(1000), 
				@PlatformCodeCount VARCHAR(20), @Acq_Deal_Rights_Code VARCHAR(1000),@Vendor_name NVARCHAR(max),@Allow_less_Than CHAR(1),
				@ROFR_Type NVARCHAR(max), @ROFR_Date VARCHAR(1000)
		set @Record_Found = 'N'	
		Set @RowTitleCodeOld = ''
		DECLARE @UL INT,@LL INT
		--Add new cur for slab
		Declare @Mail_alert_days_Body int
		Declare curBody cursor For 
	
		select DISTINCT Mail_Alert_Days,Allow_less_Than FROM #Alert_Range
		OPEN curBody 
		Fetch Next From curBody Into @Mail_alert_days_Body,@Allow_less_Than
		While @@Fetch_Status = 0 
		Begin
			SET @UL=0
			SET @LL=0
			SET @Index = 0
			IF(@Alert_Type = 'ACE')
			BEGIN
			PRINT 'ACE2'
				--SET @Emailbody = @Emailbody + '<table class="tblFormat"><br><tr><td colspan="7"><b>Deals Expiring in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
				IF(@Allow_less_Than = 'Y')
				BEGIN
					SET @LL=0
					SET @UL=@Mail_alert_days_Body
				END
				ELSE
				BEGIN			
					IF(@Expiry_Type = 'D')
					BEGIN
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body
					END
					ELSE IF(@Expiry_Type = 'W')
					BEGIN
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body+7
					END
				END
			END
			ELSE IF(@Alert_Type = 'SYE')
			BEGIN
				--SET @Emailbody = @Emailbody + '<table class="tblFormat"><br><tr><td colspan="7"><b>Deals Expiring in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
				IF(@Allow_less_Than = 'Y')
				BEGIN
					SET @LL=0
					SET @UL=@Mail_alert_days_Body
				END
				ELSE
				BEGIN			
					IF(@Expiry_Type = 'D')
					BEGIN
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body
					END
					ELSE IF(@Expiry_Type = 'W')
					BEGIN
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body+7
					END
				END
			END
			ELSE IF(@Alert_Type = 'TER')
			BEGIN
				--SET @Emailbody = @Emailbody + '<table class="tblFormat"><br><tr><td colspan="7"><b>Deals Expiring in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
				IF(@Allow_less_Than = 'Y')
				BEGIN
					SET @LL = 0
					SET @UL = @Mail_alert_days_Body
				END
				ELSE
				BEGIN			
					IF(@Expiry_Type = 'D')
					BEGIN
						SET @LL = @Mail_alert_days_Body
						SET @UL = @Mail_alert_days_Body
					END
					ELSE IF(@Expiry_Type = 'W')
					BEGIN
						SET @LL = @Mail_alert_days_Body
						SET @UL = @Mail_alert_days_Body + 7
					END
				END
			END
			ELSE
			BEGIN
			PRINT 'ROD2'
				--SET @Emailbody = @Emailbody + '<table class="tblFormat" ><br><tr><td colspan="7"><b>Deals ROFR in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
				IF(@Allow_less_Than = 'Y')
				BEGIN
					SET @LL=0
					SET @UL=@Mail_alert_days_Body
				END
				ELSE
				BEGIN			
					IF(@Expiry_Type = 'D')
					BEGIN
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body
					END
					ELSE IF(@Expiry_Type = 'W')
					BEGIN
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body+7
					END
				END
			END	

			--SET @Emailbody=@Emailbody + '<tr><td align="center" width="8%" class="tblHead"><b>Agreement#<b></td><td align="center" width="16%" class="tblHead"><b>Licensor<b></td>
			--	<td align="center" width="8%" class="tblHead"><b>Title<b></td>
			--	<td align="center" width="8%" class="tblHead"><b>Right Start Date<b></td>
			--	<td align="center" width="8%" class="tblHead"><b>Right End Date<b></td>
			--	<td align="center" width="12%" class="tblHead"><b>Country / Territory<b></td>
			--	<td align="center" width="40%" class="tblHead"><b>Platform<b></td></tr>'

			--SELECT DISTINCT Acq_Deal_Rights_Code,Agreement_No,Title_Name,IsNull(CONVERT(varchar(11),Right_Start_Date, 106),''),IsNull(CONVERT(varchar(11),Right_End_Date,106),''),Country,Platform_code,Platform_name,PlatformCodeCount,Vendor_name,Business_Unit_Code,Expire_In_Days,ROFR_Type,ROFR_Date
			--		FROM #DealDetails
			Declare curP cursor For
					SELECT DISTINCT Acq_Deal_Rights_Code,Agreement_No,Title_Name,IsNull(CONVERT(varchar(11),Right_Start_Date, 106),''),IsNull(CONVERT(varchar(11),Right_End_Date,106),''),Country,Platform_code,Platform_name,PlatformCodeCount,Vendor_name,Business_Unit_Code,Expire_In_Days,ROFR_Type,ROFR_Date
					FROM #DealDetails
					WHERE Business_Unit_Code=@Business_Unit_Code
					And Expire_in_days BETWEEN @LL And @UL
					And 0 <=  Expire_In_Days
			OPEN curP 
			Fetch Next From curP Into @Acq_Deal_Rights_Code,@Agreement_No,@Title_Name,@Rights_Start_Date,@Rights_End_Date,@Territory_Name,@Platform_code,@Platform_name,@PlatformCodeCount,@Vendor_name,@Business_Unit_Code1,@Expire_In_Days1,@ROFR_Type,@ROFR_Date
			While @@Fetch_Status = 0 
			Begin
			IF(@Index = 0)
			BEGIN
				IF(@Alert_Type = 'TER')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensor</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">Right Start Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'

				END
				ELSE IF(@Alert_Type = 'AROD' OR  @Alert_Type = 'SROD')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
					
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensor</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">ROFR Type</th>
					<th align="center" width="10%" class="tblHead">ROFR Trigger Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'

				END
				ELSE IF(@Alert_Type = 'ACE')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensor</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">Right End Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'
				END
				ELSE IF(@Alert_Type = 'SYE')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensee</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">Right End Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'
				END
		
			END
				SET @Index  = @Index  + 1

				SET @RowTitleCodeNew=@Agreement_No+'|'+ @Title_Name +'|'+ IsNull(@Rights_Start_Date, '') +'|'+ IsNull(@Rights_End_Date, '') +'|'+ @Territory_Name +'|'+@Acq_Deal_Rights_Code+'|'+@Business_Unit_Code1
				
				if((@RowTitleCodeOld<>@RowTitleCodeNew))
				Begin
					set @Temp_tbl_count=@Temp_tbl_count+1

						IF(@Alert_Type = 'TER')
						BEGIN
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>						
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@Rights_Start_Date,''), 106)  +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'

						END
						ELSE IF(@Alert_Type = 'AROD' OR  @Alert_Type = 'SROD')
						BEGIN
					
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@ROFR_Type, '') as NVARCHAR(1000))+'</td>		
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@ROFR_Date,''), 106)  +'</td>				
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'

						END
						ELSE IF(@Alert_Type = 'ACE')
						BEGIN
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>						
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@Rights_END_Date,''), 106)  +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'
					
						END
						ELSE IF(@Alert_Type = 'SYE')
						BEGIN
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>						
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@Rights_END_Date,''), 106)  +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'
					
						END

					Set @RowTitleCodeOld = @RowTitleCodeNew
				End
				Else
				BEGIN
					select @Emailbody=@Emailbody +'<tr>	
					<td  class="tblData">'+ CAST (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'
				End
				Fetch Next From curP Into @Acq_Deal_Rights_Code,@Agreement_No,@Title_Name,@Rights_Start_Date,@Rights_End_Date,@Territory_Name,@Platform_code,@Platform_name,@PlatformCodeCount,@Vendor_name,@Business_Unit_Code1,@Expire_In_Days1,@ROFR_Type,@ROFR_Date
			End -- End of Fetch Inner
			Close curP
			Deallocate curP
			
			SET @Emailbody = @Emailbody + '</table>'
			Fetch Next From curBody Into @Mail_alert_days_Body,@Allow_less_Than
		End -- End of Fetch body
		Close curBody
		Deallocate curBody
		IF( @Temp_tbl_count <> 0)
		BEGIN
			DECLARE @DefaultSiteUrl NVARCHAR(500),@Deal_Expiry_Email_Template_Desc NVARCHAR(2000);	SET @DefaultSiteUrl = ''
			SET @Deal_Expiry_Email_Template_Desc=''
			SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
			DECLARE @EmailHead NVARCHAR(max)
			set @EmailHead= '<html><head><style>
			table.tblFormat{border:1px solid black;border-collapse:collapse;}
			th.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px; style="font-weight:bold;"}
			td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>'

			IF(@Alert_Type = 'ACE')
			BEGIN
			PRINT 'ACE3'

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals are expiring on the Rights End Dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					<br><br><table border="1" cellspacing="0" cellpadding="3">'
			END
			ELSE IF(@Alert_Type = 'SYE')
			BEGIN							

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals are expiring on the Rights End Dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					<br><br><table border="1" cellspacing="0" cellpadding="3">'

			END
			ELSE IF(@Alert_Type = 'TER')
			BEGIN							

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals have tentative start date. You are requested to take note of the same and determine next steps.</b> 
				<br><br><table border="1" cellspacing="0" cellpadding="3">'

			END
			ELSE IF(@Alert_Type = 'AROD')
			BEGIN
				PRINT 'ROD1'

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned deals where Right of First Negotiation (Acquisition ROFR) is available to Viacom18, are nearing the trigger dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
										<br><br><table border="1" cellspacing="0" cellpadding="3">'
			END
			ELSE IF(@Alert_Type = 'SROD')
			BEGIN
				PRINT 'ROD1'

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned deals where Right of First Negotiation (Syndication ROFR) is available to Viacom18, are nearing the trigger dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact</b> 
										<br><br><table border="1" cellspacing="0" cellpadding="3">'

			END
			DECLARE @EMailFooter NVARCHAR(200)
			SET @EMailFooter ='&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="2" COLOR="gray">This email is generated by RightsU (Rights Management System)</font></body></html>'
			DECLARE @DatabaseEmail_Profile NVARCHAR(200)	
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
			--SELECT @DatabaseEmail_Profile
			--Print @Emailbody
			DECLARE @EmailUser_Body NVARCHAR(Max)
			Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
			
			DECLARE @BU_Name NVARCHAR(200)
			SELECT @BU_Name = Business_Unit_Name FROM Business_Unit WHERE Business_Unit_Code =  @Business_Unit_Code
			

			IF(@Alert_Type = 'ACE' OR @Alert_Type = 'SYE')
			BEGIN
				SET @MailSubjectCr = 'Notification of all deals Expiring in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
				END
			ELSE IF(@Alert_Type = 'AROD' )
				SET @MailSubjectCr = 'Notification of Acquisition ROFR becoming available in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
			ELSE IF(@Alert_Type = 'SROD')
				SET @MailSubjectCr = 'Notification of Syndication ROFR becoming available in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
			ELSE IF(@Alert_Type = 'TER')
				SET @MailSubjectCr = 'Notification of all deals with Tentative Start Date in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +'  days - Business Unit: '+ @BU_Name +'.'
			
			PRINT '@DatabaseEmail_Profile : ' + @DatabaseEmail_Profile
			PRINT '@@EMAil_User : ' + @Users_Email_Id
			PRINT '@@MailSubjectCr : ' + @MailSubjectCr
			PRINT '@@EmailUser_Body : ' + @EmailUser_Body

			--PRINT @EmailUser_Body
			IF(@Emailbody!='')
			BEGIN

				EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmail_Profile,
				@recipients =  @To_User_Mail_Id,
				@copy_recipients = @CC_User_Mail_Id,
				@blind_copy_recipients = @BCC_User_Mail_Id,
				@subject =@MailSubjectCr,
				@body = @EmailUser_Body, 
				@body_format = 'HTML';

				INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@EmailUser_Body, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), @MailSubjectCr

			END
			PRINT '@recipients : ' + cast(@Users_Email_Id  as varchar)
		END
	Fetch Next From curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes

	End -- End of Fetch outer
	Close curOuter
	Deallocate curOuter		
	

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

	DROP TABLE #DealDetails --#ACQ_EXPIRING_DEALS#DealDetails 
	IF OBJECT_ID('tempdb..#EMAIL_ID_TEMP1') IS NOT NULL
	BEGIN
		DROP TABLE #EMAIL_ID_TEMP1
	END

	IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS
	IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS#DealDetails') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS#DealDetails
	IF OBJECT_ID('tempdb..#ACQ_TENTATIVE_DEALS') IS NOT NULL DROP TABLE #ACQ_TENTATIVE_DEALS
	IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL DROP TABLE #Alert_Range
	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL DROP TABLE #DealDetails
	IF OBJECT_ID('tempdb..#EMAIL_ID_TEMP1') IS NOT NULL DROP TABLE #EMAIL_ID_TEMP1
	IF OBJECT_ID('tempdb..#SYN_EXPIRING_DEALS') IS NOT NULL DROP TABLE #SYN_EXPIRING_DEALS
END
/*k
EXEC [dbo].[USP_Deal_Expiry_Email]  'D','ACE'

*/
GO
PRINT N'Altering [dbo].[USP_Email_Run_Utilization]...';


GO
--EXEC USP_Email_Run_Utilization  'L','',2,'24'
--select * from Email_Notification_Log
ALTER PROCEDURE [dbo].[USP_Email_Run_Utilization]
(
	@Call_From CHAR(1),
	@Title_Codes VARCHAR(1000),
	@BU_Code INT=2,
	@Channel_Codes VARCHAR(1000)
)
 --=============================================
 --Author:		SAGAR MAHAJAN
 --Create date: 21 Sept 2015
 --Description:	Email Notification
 --=============================================	
AS
BEGIN	
	--DECLARE 
	--@Call_From CHAR(1) ='',
	--@Title_Codes VARCHAR(1000) ='',
	--@BU_Code INT=2,
	--@Channel_Codes VARCHAR(1000)=''

	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END
	---------------------------------------------------------------		
	IF(ISNULL(@Call_From,'') = '')
	SET @Call_From = 'L'
	DECLARE @Users_Code INT, @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = 'LMR'
	--SELECT @Channel_Codes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Run_Expiry_ChannelCode'
	--SELECT @BU_Code = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Run_Expiry_BusinessUnit'
	--SELECT User_Mail_Id, BuCode, Users_Code, Channel_Codes INTO #Temp from [dbo].[UFN_Get_Bu_Wise_User]('LMR')
	
	--------

	DECLARE @Business_Unit_Code INT,
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX)

	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)
	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'LMR', 'N'

	--SET @BU_Code = STUFF((SELECT DISTINCT ',' + CAST(BuCode AS VARCHAR(MAX)) 
	--			FROM @Tbl2 FOR XML PATH('') ), 1, 1, '')

	SET @Channel_Codes = STUFF((SELECT DISTINCT ',' + P.number
									FROM @Tbl2 A 
									CROSS APPLY  dbo.fn_Split_withdelemiter(A.Channel_Codes,',') p
							FOR XML PATH('') ), 1, 1, '')


	IF OBJECT_ID('tempdb..#Html_Table') IS NOT NULL
	BEGIN
		DROP TABLE #Html_Table
	END	
	IF OBJECT_ID('tempdb..#Temp_Channel') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Channel
	END		
	IF OBJECT_ID('tempdb..#Result1') IS NOT NULL
	BEGIN
		DROP TABLE #Result1
	END	
	---------------------------------------------------------------
	CREATE TABLE #Html_Table
	(		
		RowID INT,
		html_data NVARCHAR(MAX)	
	)
	CREATE TABLE #Temp_Channel
	(		
		Channel_Name VARCHAR(500)
	)
	CREATE TABLE #Result1
	(
		Deal_no VARCHAR(250), 
		Deal_Desc NVARCHAR(MAX),
		Vendor NVARCHAR(MAX),
		Deal_Right_Code INT,
		Title_Name NVARCHAR(1000), 		
		Right_Start_date DATETIME,
		Right_End_date DATETIME,		 		
		Channel_Name NVARCHAR(1000), 												
		No_Of_Runs VARCHAR(50),
		Schedule_Run VARCHAR(50),
		Balance_Runs VARCHAR(50),
		Count_No_Of_Schedule VARCHAR(50)		
	)
	DECLARE @Column_Name_Count_Sch VARCHAR(20)='',@First_day_Of_Last_Month DateTime = GETDATE()
	SET @First_day_Of_Last_Month = DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	SET @Column_Name_Count_Sch  = 'Schedule of ' + CONVERT(VARCHAR(3), @First_day_Of_Last_Month, 100) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR)
	PRINT  'Column_Name_Count_Sch : '  + @Column_Name_Count_Sch  
	--------------------------------------------------------------		
	
	--INSERT INTO #Result
	INSERT INTO #Result1
	(
		Deal_no , 
		Deal_Desc,Vendor,
		Deal_Right_Code ,
		Title_Name , 		
		Right_Start_date ,
		Right_End_date ,		 		
		Channel_Name , 												
		No_Of_Runs ,
		Schedule_Run ,
		Balance_Runs ,
		Count_No_Of_Schedule 
	)
	EXEC USP_Last_Month_Utilization_Report '' ,@BU_Code ,@Channel_Codes
	--EXEC USP_Last_Month_Utilization_Report '' ,1 ,'23'
	--SELECT * FROM #Result1
	--RETURN 
	--------------------------------------------------------------		
	DECLARE @Channel_ColSpan INT= 4,@Agreement_No VARCHAR(100) = '', @Count_Index INT= 3,
	@Deal_Run_Email_Template_Desc VARCHAR(1000),@DefaultSiteUrl VARCHAR(500)='', @Email_header NVARCHAR(MAX) =''
	
	SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param			
	SELECT @Deal_Run_Email_Template_Desc =REPLACE(Template_Desc ,'{Link}',@DefaultSiteUrl) FROM  Email_Template 
	WHERE Template_For= 'USP_Email_Run_Utilization'			
	
	SET @Email_header = '<html>
				<head>
				<style>
					.tblFormat {border-collapse: collapse;} 
					.tblFormat td {margin: 0;padding: 2px 3px;font-family: ''segoe ui'',sans-serif;font-size: 14px;text-align: center;}
					.tdHeading {color: #fff;background-color: #6e9eca;font-weight: 700;}
					.tdSubHeading {color: #fff;background-color: SlateGray;}					
				</style>
				'+ @Deal_Run_Email_Template_Desc +'
				</head>'
	----------------------------------------------------------------------------------------------------------------------------				
	INSERT INTO #Html_Table(RowID,html_data)
	SELECT 1, 
	--'<html>
	--			<head>
	--			<style>
	--				.tblFormat {border-collapse: collapse;} 
	--				.tblFormat td {margin: 0;padding: 2px 3px;font-family: ''segoe ui'',sans-serif;font-size: 14px;text-align: center;}
	--				.tdHeading {color: #fff;background-color: #6e9eca;font-weight: 700;}
	--				.tdSubHeading {color: #fff;background-color: SlateGray;}					
	--			</style>
	--			'+ @Deal_Run_Email_Template_Desc +'
	--			</head>'+
				'<table border="5" class="tblFormat"><tr><td colspan="6"></td>'
	INSERT INTO #Html_Table(RowID,html_data)
	--SELECT 2 ,'<tr><td>Deal No</td><td>Title</td><td>Right Period</td>'
	SELECT 2 ,'<tr><th class="tdHeading">Deal No</th>
	<th class="tdHeading">Deal Description</th>
	<th class="tdHeading">Vendor</th>
	<th class="tdHeading">Title</th>
	<th class="tdHeading">Right Start Date</th>
	<th class="tdHeading">Right End Date</th>'	
	DECLARE @Deal_no VARCHAR(250), @Title_Name VARCHAR(250), @Rights_Period VARCHAR(50),@Deal_Movie_Code INT,@Channel_Code INT, @Channel_Name VARCHAR(2000)
	,@Schedule_Run VARCHAR(50),@No_Of_Runs VARCHAR(50),@Balance_Runs VARCHAR(50)
	,@Temp_Right_Period VARCHAR(100),@Right_Start_date DATETIME,@Right_End_date DATETIME,@Temp_Title_Name NVARCHAR(100)='',
	@Deal_Description NVARCHAR(MAX), @Vendor_Name NVARCHAR(200),@Count_No_Of_Schedule VARCHAR(50)
	
	
	-----------------------------------------------------------------------
	DECLARE CUR_Channel CURSOR FOR 
				SELECT DISTINCT Channel_Name FROM #Result1 ORDER BY Channel_Name
	OPEN CUR_Channel
				FETCH NEXT FROM CUR_Channel 
					INTO @Channel_Name
			WHILE (@@FETCH_STATUS = 0)
			BEGIN			
				INSERT INTO #Temp_Channel(Channel_Name)
				SELECT @Channel_Name
					
				UPDATE #Html_Table SET html_data = html_data 
				+ '<td class="tdSubHeading">No of Run</td>
				<td class="tdSubHeading">Schedule</td>
				<td class="tdSubHeading">Balance</td>
				<td class="tdSubHeading">'+@Column_Name_Count_Sch+'</td>' WHERE RowID = 2

 				UPDATE #Html_Table SET html_data = html_data + CAST('<td class="tdHeading" colspan=''' + CAST(@Channel_ColSpan AS VARCHAR) + '''>'+@Channel_Name+'</td>' AS VARCHAR(100))

				WHERE RowID = 1				
					FETCH NEXT FROM CUR_Channel INTO 
						@Channel_Name
			END
	CLOSE CUR_Channel
	DEALLOCATE CUR_Channel
	--SELECT * FROM #Result1
	--RETURN
	---------------------------------------------------------------------------------
	DECLARE CUR_Report CURSOR FOR 
				--SELECT  
				--	Deal_no,Title_Name,Right_Start_date,ISNULL(Right_End_date,'31DEC9999'),Channel_Name,Schedule_Run,No_Of_Runs ,Balance_Runs,Count_No_Of_Schedule 
				--FROM #Result1 ORDER BY Channel_Name
				SELECT  
					Deal_no, Title_Name, Right_Start_date, ISNULL(Right_End_date, '31DEC9999'), Channel_Name, Schedule_Run, No_Of_Runs ,Balance_Runs, Count_No_Of_Schedule,
					Deal_Desc, Vendor  
				FROM #Result1 ORDER BY Channel_Name
	OPEN CUR_Report
	PRINT 'Cursor'
				FETCH NEXT FROM CUR_Report 
					INTO @Deal_no,@Title_Name,@Right_Start_date,@Right_End_date,@Channel_Name,@Schedule_Run,@No_Of_Runs ,@Balance_Runs,@Count_No_Of_Schedule , @Deal_Description, @Vendor_Name
			WHILE (@@FETCH_STATUS = 0)
			BEGIN	
				SET	@Rights_Period = CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_Start_date,103), 106) + ' TO ' + CONVERT(VARCHAR(25), CONVERT(DATETIME,ISNULL(@Right_End_date,'31DEC9999'),103), 106)
				IF(@Balance_Runs='Unlimited')
				SET  @No_Of_Runs = 'Unlimited'
				--SELECT @Right_Start_date
				IF(@Agreement_No <> @Deal_no OR (@Agreement_No =  @Deal_no AND ((@Temp_Right_Period <> @Rights_Period)  OR (@Temp_Title_Name <> @Title_Name))))
				BEGIN						
					SET @Count_Index = @Count_Index + 1			
					INSERT INTO #Html_Table(RowID,html_data)				
					SELECT @Count_Index ,'<tr><td>'+@Deal_no+'</td><td>'+@Deal_Description+'</td><td>'+@Vendor_Name+'</td><td>'+@Title_Name+'</td><td>'+CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_Start_date,103), 106) +'</td><td>'+CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_End_date,103), 106) +'</td>'
				END
					UPDATE #Html_Table SET html_data = html_data + '<td>'+@No_Of_Runs+'</td><td>'+@Schedule_Run+'</td><td>'+@Balance_Runs+'</td><td>'+@Count_No_Of_Schedule+'</td>'				
					WHERE RowID = @Count_Index						
				SET  @Agreement_No = @Deal_no				
				SET  @Temp_Right_Period = @Rights_Period				
				SET @Temp_Title_Name = @Title_Name
				FETCH NEXT FROM CUR_Report 
					INTO @Deal_no,@Title_Name,@Right_Start_date,@Right_End_date,@Channel_Name,@Schedule_Run,@No_Of_Runs ,@Balance_Runs,@Count_No_Of_Schedule , @Deal_Description, @Vendor_Name
				
				--INTO @Deal_no,@Title_Name,@Right_Start_date,@Right_End_date,@Channel_Name,@Schedule_Run,@No_Of_Runs ,@Balance_Runs,@Count_No_Of_Schedule , @Deal_Description, @Vendor_Name
			END
	CLOSE CUR_Report
	DEALLOCATE CUR_Report
	---------------------------------------------------------------------------------
	UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID = 1
	UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID = 2
	SET @Count_Index = @Count_Index + 1		
	UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID > 2 
	---------------------------------------------------------------------------------
	INSERT INTO #Html_Table(RowID,html_data)
	SELECT @Count_Index ,'</table>'
	
	---------------------------------------------------------------------------------
	DECLARE @Users_Email_Id VARCHAR(1000)='',@MailSubjectCr NVARCHAR(500)='',@Emailbody NVARCHAR(MAX)=''	
			--SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param			
	DECLARE @EMailFooter NVARCHAR(200),@EmailHead NVARCHAR(max)
			SET @EMailFooter ='&nbsp;</br>&nbsp;</br>Regards,</br>
			RightsU Support</br>
			U-TO Solutions</body></html>'
			DECLARE @DatabaseEmail_Profile varchar(200)	
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
		
			
			Print @Emailbody
			DECLARE @EmailUser_Body NVARCHAR(Max)=''
			--Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
			
			IF(@Call_From  = 'L')
				SET @MailSubjectCr = 'RightsU Email Alert : Last Month Run Utilization Report '--Expiration 
			ELSE IF(@Call_From = 'E')
				SET @MailSubjectCr = 'RightsU Email Alert : Rights Run Expiration Report'
			
			SELECT  @EmailUser_Body = @EmailUser_Body + html_data FROM #Html_Table 
			
			Set @Emailbody= @Email_header + @EmailUser_Body + @EMailFooter
			
			--SELECT *  FROM #Html_Table 
			--SET @EmailUser_Body ='Sagar'

			PRINT '@DatabaseEmail_Profile : ' + @DatabaseEmail_Profile
			PRINT '@@EMAil_User : ' + @Users_Email_Id
			PRINT '@@MailSubjectCr : ' + @MailSubjectCr
			PRINT '@@EmailUser_Body : ' + @EmailUser_Body
			
	IF(@EmailUser_Body != '')
	BEGIN
		DECLARE curOuter CURSOR FOR 
					SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
	
		OPEN curOuter 
		FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		WHILE (@@Fetch_Status = 0) 
		BEGIN		

			   EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmail_Profile,
				@recipients =  @To_User_Mail_Id,
				@copy_recipients = @CC_User_Mail_Id,
				@blind_copy_recipients = @BCC_User_Mail_Id,
				@subject = @MailSubjectCr,
				@body = @Emailbody, 
				@body_format = 'HTML';


				INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@EmailUser_Body, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'Last Month Run Utilization'

			FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		END -- End of Fetch outer
		CLOSE curOuter
		DEALLOCATE curOuter	
	END
	----------------------------------------------------------------------------------
	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT


	IF OBJECT_ID('tempdb..#Html_Table') IS NOT NULL DROP TABLE #Html_Table
	IF OBJECT_ID('tempdb..#Result') IS NOT NULL DROP TABLE #Result
	IF OBJECT_ID('tempdb..#Result1') IS NOT NULL DROP TABLE #Result1
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp_Channel') IS NOT NULL DROP TABLE #Temp_Channel

END
GO
PRINT N'Altering [dbo].[USP_Get_Unutilized_Run]...';


GO
ALTER PROCEDURE [dbo].[USP_Get_Unutilized_Run] 
-- =============================================
-- Author:		Rajesh Godse
-- Create date: 12 Jan 2015
-- Description:	Get run details for current year based on title
-- Changed by : Anchal sikarwar 
-- Reason : Change about email Configuration
-- =============================================
AS
BEGIN	
	IF OBJECT_ID('tempdb..#RunDetail') IS NOT NULL
	BEGIN
		DROP TABLE #RunDetail
	END
	IF OBJECT_ID('tempdb..#RunDetailFilter') IS NOT NULL
	BEGIN
		DROP TABLE #RunDetailFilter
	END
	DECLARE @enddate AS DATETIME
	DECLARE @ROWNUMBER AS INT
	DECLARE @RowCount AS INT
	DECLARE @Channel_Codes NVARCHAR(MAX)
	DECLARE @EmailTable NVARCHAR(MAX)
	SET @enddate = DATEADD(dd, -DAY(GETDATE()) + 1, GETDATE())
	SELECT test.* 
	INTO #RunDetail
	FROM
	(SELECT distinct ADRYR.Acq_Deal_Run_Code, t.Title_Name AS Title,
	(SELECT CONVERT(VARCHAR(11),MIN([Start_Date]),106)+' To '+ CONVERT(VARCHAR(11),MAX([End_Date]),106) FROM 
	Acq_Deal_Run_Yearwise_Run
	WHERE Acq_Deal_Run_Code = ADRYR.Acq_Deal_Run_Code) AS 'Period',
	CONVERT(VARCHAR(11),[Start_Date],106)+' To '+CONVERT(VARCHAR(11),End_Date,106) AS 'Current Year',
	[dbo].[UFN_Get_Run_Channel](ADRYR.Acq_Deal_Run_Code) 'Run_Channel',
	CONVERT(INT,ROUND(((CONVERT(DECIMAL(5,2),ADRYR.No_Of_Runs)/CONVERT(DECIMAL(5,2),DATEDIFF(MONTH,[Start_Date],[End_Date]))))* DATEDIFF(MONTH,[Start_Date],@enddate),0)) AS 'Avg to be OnAir',
	ISNULL(ADRYR.No_Of_Runs_Sched,0) AS OnAired,
	CONVERT(INT,ROUND(((CONVERT(DECIMAL(5,2),ADRYR.No_Of_Runs)/CONVERT(DECIMAL(5,2),DATEDIFF(MONTH,[Start_Date],[End_Date]))))* DATEDIFF(MONTH,[Start_Date],@enddate),0)) - ISNULL(ADRYR.No_Of_Runs_Sched,0) AS 'Balance till date',
	ADRYR.No_Of_Runs - CONVERT(INT,ROUND(((CONVERT(DECIMAL(5,2),ADRYR.No_Of_Runs)/CONVERT(DECIMAL(5,2),DATEDIFF(MONTH,[Start_Date],[End_Date]))))* DATEDIFF(MONTH,[Start_Date],@enddate),0)) AS 'To be consume(yearly)',
	ADRYR.No_Of_Runs - ISNULL(ADRYR.No_Of_Runs_Sched,0) AS 'Total balance (yearly)'
	FROM Acq_Deal_Run_Yearwise_Run AS ADRYR
	INNER JOIN Acq_Deal_Run_Title AS ADRT ON ADRYR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
	INNER JOIN Title t ON ADRT.Title_Code = t.Title_Code
	WHERE GETDATE() between [Start_Date] and End_Date AND DATEDIFF(MONTH,[Start_Date],@enddate) > 0) test
	--select * from #RunDetail
	--return
	CREATE TABLE #RunDetailFilter
	(
		Row_Numbe INT,
		Acq_Deal_Run_Code INT,
		Title NVARCHAR(MAX),
		Period VARCHAR(100),
		Current_Year VARCHAR(100),
		Run_Channel VARCHAR(100),
		Avg_to_be_OnAir INT,
		OnAired INT,
		Balance_till_date INT,
		To_be_consume INT,
		Total_balance INT
	)

	
	DECLARE @EmailId NVARCHAR(50)
	DECLARE @Emailbody AS NVARCHAR(MAX)=''
	DECLARE @Title AS NVARCHAR(MAX)
	DECLARE @Period AS VARCHAR(50)
	DECLARE @CurrentYear AS VARCHAR(50)
	DECLARE @Channel AS NVARCHAR(MAX)
	DECLARE @AvgtobeOnAir AS VARCHAR(10)
	DECLARE @OnAired AS VARCHAR(10)
	DECLARE @Balancetilldate AS VARCHAR(10)
	DECLARE @Tobeconsume AS VARCHAR(10)
	DECLARE @TotalBalance AS VARCHAR(10)
	DECLARE @Users_Code INT
	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='CUR'

	--SELECT * FROM UFN_Get_EmailConfig_Users('CUR')

	DECLARE @Business_Unit_Code INT,
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX)
	
	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)

	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'CUR', 'N'

	DECLARE cPointer CURSOR FOR SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
	--Change
	OPEN cPointer
		FETCH NEXT FROM cPointer INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			DECLARE @ParameterValue as NVARCHAR(20)
			
				SET @ParameterValue = ''
				Select @ParameterValue = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'UnutilizedRun_Program_Category'
				
				DELETE FROM #RunDetailFilter
				INSERT INTO #RunDetailFilter(Row_Numbe,Acq_Deal_Run_Code,Title,Period,Current_Year, Run_Channel,Avg_to_be_OnAir,OnAired,Balance_till_date,To_be_consume,Total_balance)
				SELECT ROW_NUMBER() OVER (ORDER BY Title ASC) Row_Numbe,Acq_Deal_Run_Code,Title,Period,[Current Year] Current_Year,
				--Change
				CASE WHEN Run_Channel!='' THEN
				stuff((SELECT DISTINCT ', ' + cast(RC.number as NVARCHAR(max)) FROM dbo.fn_Split_withdelemiter(Run_Channel,',') AS RC
				INNER JOIN Channel AS C ON RTRIM(LTRIM(RC.number))=C.Channel_Name 
				WHERE C.Channel_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(@Channel_Codes,','))
				FOR XML PATH('')), 1, 1, '') ELSE '' END AS Run_Channel
				--Change
				,
				[Avg to be OnAir] Avg_to_be_OnAir,OnAired,[Balance till date] Balance_till_date,[To be consume(yearly)] To_be_consume,[Total balance (yearly)] Total_balance
				FROM #RunDetail 
				WHERE Acq_Deal_Run_Code IN(
				SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run ADR
				INNER JOIN Acq_Deal AD ON  ADR.Acq_Deal_Code = Ad.Acq_Deal_Code AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Business_Unit_Code = @Business_Unit_Code
				AND AD.Deal_Type_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@ParameterValue,',')
				))
				--Change
				AND (
				(SELECT COUNT(*) FROM dbo.fn_Split_withdelemiter(Run_Channel,',') AS RC
				INNER JOIN Channel AS C ON RTRIM(LTRIM(RC.number))=C.Channel_Name 
				 WHERE C.Channel_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(@Channel_Codes,',')))>0
				 )
				 --Change
				SET @RowCount = @@ROWCOUNT
				SET @ROWNUMBER = 1
				IF EXISTS(select * FROM #RunDetailFilter 
					WHERE Row_Numbe = @ROWNUMBER AND Acq_Deal_Run_Code in(
					Select ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run ADR
					INNER JOIN Acq_Deal AD ON  ADR.Acq_Deal_Code = Ad.Acq_Deal_Code
					AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Business_Unit_Code = @Business_Unit_Code AND AD.Deal_Type_Code in
					(
						select number from dbo.fn_Split_withdelemiter(@ParameterValue,','))
					)
					)
				BEGIN
					SET @Emailbody = '<html><head><style>th.middle{border-right:1px solid white;background-color: cadetblue; vertical-align:middle;
					}th.first{border-left:1px solid cadetblue;border-right:1px solid white;background-color: cadetblue; vertical-align:middle;}
					th.last{border-right:1px solid cadetblue;background-color: cadetblue; vertical-align:middle;}td.first
					{border-left:1px solid cadetblue;border-right:1px solid cadetblue;border-bottom:1px solid cadetblue; vertical-align:middle;}
					td.rest{border-right:1px solid cadetblue;border-bottom:1px solid cadetblue; vertical-align:middle;}</style></head><body>'
					SET @Emailbody = @Emailbody + 'Dear User,<br/><br/>Below report shows Unutilized run details as on ' + CONVERT(VARCHAR(11),@enddate,106) + '.<br/><br/>'
					
					SET @EmailTable = '<table cellspacing=''0'' class="tblFormat"><tr>
								<th align="center" class="first">Title</th>
								<th align="center" class="middle">Rights Period</th>
								<th align="center" class="middle">Current Year</th>
								<th align="center" class="middle">Channel(s)</th>
								<th align="center" class="middle">Avg to be OnAir</th>
								<th align="center" class="middle">OnAired</th>
								<th align="center" class="middle">Balance till Date</th>
								<th align="center" class="middle">To be Consumed</th>
								<th align="center" class="last">Total Balance</th>
								</tr>'
				END
				WHILE @ROWNUMBER <= @RowCount
				BEGIN				
					SELECT @Title = Title,@Period = Period,@CurrentYear = Current_Year,@Channel = Run_Channel,@AvgtobeOnAir = Avg_to_be_OnAir,@OnAired = OnAired,@Balancetilldate = Balance_till_date,@Tobeconsume = To_be_consume,@TotalBalance = Total_balance
					FROM #RunDetailFilter 
					WHERE Row_Numbe = @ROWNUMBER AND Acq_Deal_Run_Code in(
					Select ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run ADR
					INNER JOIN Acq_Deal AD ON  ADR.Acq_Deal_Code = Ad.Acq_Deal_Code
					AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Business_Unit_Code = @Business_Unit_Code AND AD.Deal_Type_Code in
					(
						select number from dbo.fn_Split_withdelemiter(@ParameterValue,','))
					)
					SET @EmailTable= @EmailTable +'<tr>
							<td align="center" class="first">'+ISNull(@Title,'')+'</td>
							<td align="center" class="rest">' +ISNull(@Period,'')+' </td>
							<td align="center" class="rest">' +ISNull(@CurrentYear,'')+' </td>
							<td align="center" class="rest">' +ISNull(@Channel,'')+' </td>
							<td align="center" class="rest">' +ISNull(@AvgtobeOnAir,'')+' </td>
							<td align="center" class="rest">' +ISNull(@OnAired,'')+' </td>
							<td align="center" class="rest">' +ISNull(@Balancetilldate,'')+' </td>
							<td align="center" class="rest">' +ISNull(@Tobeconsume,'')+' </td>
							<td align="center" class="rest">' +ISNull(@TotalBalance,'')+' </td>
							</tr>'
							
					SET @ROWNUMBER = @ROWNUMBER + 1
				END
				IF(@EmailTable != '')
				SET @EmailTable = @EmailTable + '</table>'

				IF(@Emailbody != '' AND @EmailTable != '')
				SET @Emailbody = @Emailbody + @EmailTable + '</body></html>'

				--Sending mail start
				DECLARE @DatabaseEmail_Profile VARCHAR(200)	
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
			
				IF(@Emailbody IS NOT NULL AND @Emailbody != '')
				BEGIN
				
				EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmail_Profile,
				@recipients =  @To_User_Mail_Id,
				@copy_recipients = @CC_User_Mail_Id,
				@blind_copy_recipients = @BCC_User_Mail_Id,
				@subject = 'Unutilized Run Details',
				@body = @Emailbody, 
				@body_format = 'HTML';
				  
				INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@EmailTable, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'Channel Unutilized Run'
				
				END
				--Change
				--Sending mail end
				SET @EmailTable = ''
				SET @Emailbody = ''
			--END
			FETCH NEXT FROM cPointer INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		END
	CLOSE cPointer
	DEALLOCATE cPointer

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

	IF OBJECT_ID('tempdb..#RunDetail') IS NOT NULL DROP TABLE #RunDetail
	IF OBJECT_ID('tempdb..#RunDetailFilter') IS NOT NULL DROP TABLE #RunDetailFilter
END
GO
PRINT N'Altering [dbo].[USP_Music_Schedule_Process]...';


GO
ALTER PROC [dbo].[USP_Music_Schedule_Process]
(
	@TitleCode BIGINT = 12921, 
	@EpisodeNo INT = 1, 
	@BV_Schedule_Transaction_Code BIGINT = 0, 
	@MusicScheduleTransactionCode BIGINT = 0,
	@CallFrom VARCHAR(10) = ''
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	20 October 2016
Description:	Music Schedule Process and Email Exception
Value for @CallFrom :
	'AM'	= Called from Assign Music Page
	'SR'	= Called from USP_Schedule_Revert_Count
	'AR'	= Called from USP_Music_Schedule_Exception_AutoResolver
	'SP'	= Called from USP_Schedule_Process
=======================================================================================================================================*/
BEGIN
	SET NOCOUNT ON
	--DECLARE
	--@TitleCode BIGINT = 31640,
	--@EpisodeNo INT = 1, 
	--@BV_Schedule_Transaction_Code BIGINT = 0, 
	--@MusicScheduleTransactionCode BIGINT = 0,
	--@CallFrom VARCHAR(10) = 'AM'

	DECLARE @stepNo INT = 1;
	PRINT 'Music Schedule Process Started'

	IF(OBJECT_ID('TEMPDB..#TempScheduleData') IS NOT NULL)
		DROP TABLE #TempScheduleData

	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransaction') IS NOT NULL)
		DROP TABLE #TempMusicScheduleTransaction

	IF(OBJECT_ID('TEMPDB..#AllMusicLabelDealData') IS NOT NULL)
		DROP TABLE #AllMusicLabelDealData

	IF(OBJECT_ID('TEMPDB..#CurrentMusicLabelDealData') IS NOT NULL)
		DROP TABLE #CurrentMusicLabelDealData

	IF(OBJECT_ID('TEMPDB..#ExistingException') IS NOT NULL)
		DROP TABLE #ExistingException

	CREATE TABLE #TempMusicScheduleTransaction
	(
		MusicScheduleTransactionCode	BIGINT, 
		BV_Schedule_Transaction_Code	BIGINT, 
		Schedule_Date					DATETIME, 
		Schedule_Item_Log_Time			VARCHAR(50), 
		Content_Music_Link_Code			BIGINT, 
		Music_Title_Code					BIGINT, 
		Channel_Code					BIGINT, 
		Music_Label_Code				BIGINT, 
		Is_Processed					CHAR(1) DEFAULT('N')
	)

	CREATE TABLE #CurrentMusicLabelDealData
	(
		Music_Deal_Code			INT,
		Agreement_No			VARCHAR(50),
		Deal_Workflow_Status	VARCHAR(5),
		Rights_Start_Date		DATETIME,
		Rights_End_Date			DATETIME,
		Run_Type				CHAR(4),
		Right_Rule_Code			INT,
		Channel_Type			CHAR(1),
		Channel_Code			INT,
		No_Of_Songs				INT,
		Defined_Runs			INT,
		Scheduled_Runs			INT,
		Show_Linked				VARCHAR(1),
		Title_Code				INT,
		DealCreatedOn			DATETIME,
		Is_Active_Deal			VARCHAR(1)
	)

	CREATE TABLE #ExistingException
	(
		MusicScheduleTransactionCode	INT,
		Error_Code						INT,
		Error_Key						VARCHAR(10)
	)

	DECLARE @DefaultVersionCode INT = 1, @Users_Code INT,  @Email_Config_Code INT
	SELECT TOP 1 @DefaultVersionCode = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'DefaultVersionCode'
	
	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config where [Key]='MSE'
	--EXEC SP_HELP BV_Schedule_Transaction
	PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select Title_Code and Episode_No, If Parameter @BV_Schedule_Transaction_Code has value' 
	SET @stepNo += 1
	IF(@BV_Schedule_Transaction_Code > 0)
	BEGIN
		PRINT ' Selecting Title_Code and Episode_No for @BV_Schedule_Transaction_Code = ' + CAST(@BV_Schedule_Transaction_Code AS VARCHAR) 
		SELECT TOP 1 @TitleCode = TC.Title_Code, @EpisodeNo = TC.Episode_No
		FROM BV_Schedule_Transaction BST
		INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
		WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code
	END

	/* Revert Schedule*/
	IF(@CallFrom = 'SR')
	BEGIN
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete data from Music_Schedule_Exception table for Revert'
		DELETE MSE FROM Music_Schedule_Transaction MST
		INNER JOIN Music_Schedule_Exception MSE ON MST.Music_Schedule_Transaction_Code = MSE.Music_Schedule_Transaction_Code
		AND MST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code

		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(B) : Delete data from Music_Schedule_Transaction table for Revert'
		DELETE FROM Music_Schedule_Transaction WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code
	END

	/* Get Schedule Data for Title*/
	PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Get Schedule Data for Title'
	SET @stepNo += 1
	SELECT BST.BV_Schedule_Transaction_Code, TC.Title_Code, TC.Episode_No, CONVERT(DATETIME, BST.Schedule_Item_Log_Date, 121) AS Schedule_Date,
	BST.Schedule_Item_Log_Time, BST.Channel_Code, CAST('' AS VARCHAR(3)) AS Valid_Flag
	INTO #TempScheduleData
	FROM BV_Schedule_Transaction BST
	INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
	WHERE TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo
		AND (BST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code OR @BV_Schedule_Transaction_Code = 0)

	IF EXISTS (SELECT * FROM #TempScheduleData)
	BEGIN
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Got Schedule Data'
		IF(@CallFrom = 'AR' AND ISNULL(@MusicScheduleTransactionCode, 0) > 0)
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data from Music_Schedule_Transaction table and Insert in #TempMusicScheduleTransaction in case of Auto Resolve'	
			INSERT INTO #TempMusicScheduleTransaction(MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT MST.Music_Schedule_Transaction_Code, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, MST.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MST.Music_Label_Code, 'N' AS Is_Processed
			FROM Music_Schedule_Transaction MST
			INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
			INNER JOIN #TempScheduleData TSD ON MST.BV_Schedule_Transaction_Code = TSD.BV_Schedule_Transaction_Code
			WHERE MST.Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode
		END
		
		IF(ISNULL(@MusicScheduleTransactionCode, 0) = 0)
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for Music_Schedule_Transaction insertion'	
			INSERT INTO #TempMusicScheduleTransaction(MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT 0 AS MusicScheduleTransactionCode, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, CML.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MTL.Music_Label_Code, 'N' AS Is_Processed
			FROM Title_Content TC
			INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
			INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code AND TCV.Version_Code = @DefaultVersionCode
			INNER JOIN #TempScheduleData TSD ON TSD.Title_Code = TC.Title_Code AND TSD.Episode_No =  TC.Episode_No
			LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = CML.Music_Title_Code 
				AND TSD.Schedule_Date BETWEEN MTL.Effective_From AND ISNULL(MTL.Effective_To, TSD.Schedule_Date)
			WHERE TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo 
		END

		SET @stepNo += 1

		/*	GET Deal Data
			AS : All Show, AF : All Fiction, AN : All Non Fiction, AE : All Event, SP : Specific
		*/

		DECLARE @CurrentTitleDealType INT = 0, @DealType_Fiction INT = 0, @DealType_NonFiction INT = 0, @DealType_Event INT = 22
		SELECT TOP 1 @DealType_Fiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content'
		SELECT TOP 1 @DealType_NonFiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'
		SELECT TOP 1 @DealType_Event = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'
		SELECT TOP 1 @CurrentTitleDealType = Deal_Type_Code FROM Title T WHERE T.Title_Code = @TitleCode

		PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for #AllMusicLabelDealData '	
		SET @stepNo += 1
		SELECT TMST.Music_Label_Code, MD.Music_Deal_Code, MD.Agreement_No, MD.Deal_Workflow_Status, 
		MD.Rights_Start_Date, MD.Rights_End_Date, MD.Run_Type, 
		MD.Right_Rule_Code,
		MD.Channel_Type, MDC.Channel_Code, MD.No_Of_Songs,
		CASE WHEN MD.Channel_Type = 'S' THEN MD.No_Of_Songs ELSE MDC.Defined_Runs END AS Defined_Runs, 
		MDC.Scheduled_Runs,
		CASE 
			WHEN MD.Link_Show_Type = 'AS' THEN 'Y'
			WHEN MD.Link_Show_Type = 'AF' AND @CurrentTitleDealType = @DealType_Fiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AN' AND @CurrentTitleDealType = @DealType_NonFiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AE' AND @CurrentTitleDealType = @DealType_Event THEN 'Y'
			WHEN MD.Link_Show_Type = 'SP' AND MDLS.Title_Code = @TitleCode THEN 'Y'
			ELSE 'N'
		END AS Show_Linked, MDLS.Title_Code, MD.Inserted_On AS DealCreatedOn, 'N' AS [Is_Active_Deal]
		INTO #AllMusicLabelDealData
		FROM #TempMusicScheduleTransaction TMST
		INNER JOIN Music_Deal MD ON MD.Music_Label_Code = TMST.Music_Label_Code
		INNER JOIN Music_Deal_Channel MDC ON MDC.Music_Deal_Code = MD.Music_Deal_Code
		LEFT JOIN Music_Deal_LinkShow MDLS ON MDLS.Music_Deal_Code = MD.Music_Deal_Code 
				
		IF(@CallFrom <> 'AR')
		BEGIN
			/* Delete the Data, If data already exist, which we are going to Insert */
			PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete the data from Music_Schedule_Exception, If data already exist, which we are going to Insert'
			DELETE MSE FROM Music_Schedule_Transaction MST
			INNER JOIN Music_Schedule_Exception MSE ON MSE.Music_Schedule_Transaction_Code = MST.Music_Schedule_Transaction_Code
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code 

			PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(B) : Delete the data from Music_Schedule_Transaction, If data already exist, which we are going to Insert'
			DELETE MST FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code 

			/* Insert data in Music Schedule Transaction Table */
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Insert data into Music_Schedule_Transaction'
			SET @stepNo += 1
			INSERT INTO Music_Schedule_Transaction(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, 
				Is_Processed, Is_Ignore)
			SELECT BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, Is_Processed, 
				NULL AS IsIgnore
			FROM #TempMusicScheduleTransaction
			ORDER BY CAST(Schedule_Date + ' ' + Schedule_Item_Log_Time AS DATETIME)
		END

		IF(ISNULL(@MusicScheduleTransactionCode, 0) = 0)
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Update MusicScheduleTransactionCode column of #TempMusicScheduleTransaction table'
			SET @stepNo += 1
			UPDATE TMST SET TMST.MusicScheduleTransactionCode = MST.Music_Schedule_Transaction_Code FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code AND TMST.Channel_Code = MST.Channel_Code 
				AND (
					(TMST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS = MST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS AND @CallFrom <> 'AR') OR 
					@CallFrom = 'AR'
				)
		END

		IF EXISTS (SELECT TOP 1 * FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N')
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Loop on #TempMusicScheduleTransaction table'
			SET @stepNo += 1
			DECLARE @MusicLabelCode BIGINT = 0, @MusicTitleCode BIGINT = 0, @IsError CHAR(1) = 'N',  @MusicDealCode BIGINT = 0, @lastMDCode BIGINT = 0,
					@ErrorCode BIGINT = 0, @RightRuleCode BIGINT = 0,  
					@NoOfSongs INT = 0,  @IsIgnore CHAR(1) = 'N', @RunType CHAR(1) = '', @ChannelType CHAR(1) = '', 
					@Schedule_Date DATETIME = NULL, @ChannelCode BIGINT = 0, @isValid CHAR(1) = 'Y', 
					@AutoResolvedErrCodes VARCHAR(MAX) = '', @NewRaisedErrCodes VARCHAR(MAX) = '',
					@ShowLinked CHAR(1) = 'Y', @isApprovedDeal CHAR(1) = 'Y'

			PRINT ' ---------------------------------------------------------'
			SET @MusicScheduleTransactionCode  = 0
			SELECT TOP 1 @MusicScheduleTransactionCode = MusicScheduleTransactionCode, @BV_Schedule_Transaction_Code = BV_Schedule_Transaction_Code,
			@MusicLabelCode = ISNULL(Music_Label_Code, 0), @MusicTitleCode = ISNULL(Music_Title_Code ,0) 
			FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N'
			ORDER BY MusicScheduleTransactionCode

			INSERT INTO #ExistingException(MusicScheduleTransactionCode, Error_Code, Error_Key)
			SELECT DISTINCT MSE.Music_Schedule_Transaction_Code, ECM.Error_Code, ECM.Upload_Error_Code FROM Music_Schedule_Exception MSE
			INNER JOIN #TempMusicScheduleTransaction MST ON MST.MusicScheduleTransactionCode = MSE.Music_Schedule_Transaction_Code
			INNER JOIN Error_Code_Master ECM ON ECM.Error_Code = MSE.Error_Code

			WHILE(@MusicScheduleTransactionCode > 0)
			BEGIN
				PRINT ' Process Started For @MusicScheduleTransactionCode = ' + CAST(@MusicScheduleTransactionCode AS VARCHAR) 
					+ ', @MusicLabelCode = ' + CAST(@MusicLabelCode AS VARCHAR)

				SELECT  @MusicDealCode = 0, @lastMDCode = 0, @ErrorCode = 0, @Schedule_Date = NULL, @ChannelCode = 0, @isValid  = 'Y', 
				@AutoResolvedErrCodes = '', @NewRaisedErrCodes = '', @ShowLinked = 'Y', @isApprovedDeal = 'Y'

				SELECT TOP 1 @Schedule_Date = BST.Schedule_Date, @ChannelCode = BST.Channel_Code
				FROM #TempScheduleData BST WHERE BST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code

				PRINT '  MESSAGE : @Schedule_Date : ' + CAST(@Schedule_Date AS VARCHAR) + ', @ChannelCode : ' + CAST(@ChannelCode AS VARCHAR)


				/* START : VALIDATION */
				IF(@MusicLabelCode = 0)
				BEGIN
					PRINT '  ERROR : Music Label Not Found'
					SELECT @IsError  = 'Y', @isValid = 'N'
					SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',MLBLNF'
				END
				ELSE
				BEGIN
					SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',MLBLNF'

					DELETE FROM #CurrentMusicLabelDealData
					INSERT INTO #CurrentMusicLabelDealData(
						Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
						Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
					)
					SELECT 
						Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
						Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
					FROM #AllMusicLabelDealData 
					WHERE ISNULL(Music_Deal_Code, 0) > 0 AND ISNULL(Music_Label_Code, 0) = @MusicLabelCode AND ISNULL(Title_Code, 0) = @TitleCode

					IF NOT EXISTS (SELECT * FROM #CurrentMusicLabelDealData)
					BEGIN
						INSERT INTO #CurrentMusicLabelDealData(
							Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
							Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
						)
						SELECT 
							Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
							Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
						FROM #AllMusicLabelDealData 
						WHERE ISNULL(Music_Deal_Code, 0) > 0 AND ISNULL(Music_Label_Code, 0) = @MusicLabelCode 
					END
				END

				IF(@isValid = 'Y')
				BEGIN
					IF NOT EXISTS(SELECT * FROM #CurrentMusicLabelDealData)
					BEGIN
						PRINT '  ERROR : Deal Not Found'
						SELECT @IsError  = 'Y', @isValid = 'N'
						SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',DNF'
					END
					ELSE
						SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',DNF'
				END
			
				IF(@isValid = 'Y')
				BEGIN
					SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
					WHERE Deal_Workflow_Status = 'A' AND Channel_Code = @ChannelCode AND Show_Linked = 'Y'
					AND @Schedule_Date BETWEEN Rights_Start_Date  AND Rights_End_Date
					ORDER BY DealCreatedOn ASC

					IF(@MusicDealCode = 0)
					BEGIN
						SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
						WHERE Deal_Workflow_Status = 'A' AND Show_Linked = 'Y' 
						ORDER BY DealCreatedOn ASC

						IF (@MusicDealCode > 0)
						BEGIN
							SELECT @ShowLinked = 'Y'
							PRINT '  MSG : Show Linked with approved deal'
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',SNL,DNA'
						END

						IF (@MusicDealCode = 0)
						BEGIN
							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
							WHERE Show_Linked = 'Y'
							ORDER BY DealCreatedOn ASC

							IF (@MusicDealCode > 0)
							BEGIN
								SELECT @ShowLinked = 'Y', @isApprovedDeal = 'N', @IsError  = 'Y', @isValid = 'N'
								PRINT '  MSG : Show Linked with non - approved deal'
								PRINT '  ERROR : Deal not approved'
								SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',SNL'
								SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',DNA'
							END
						END

						IF (@MusicDealCode = 0)
						BEGIN
							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
							WHERE Deal_Workflow_Status = 'A'

							IF (@MusicDealCode > 0)
							BEGIN
								SELECT @ShowLinked = 'N', @isApprovedDeal = 'Y', @IsError  = 'Y', @isValid = 'N'
								PRINT '  MSG : Found approved deal'
								PRINT '  ERROR : Show not linked'
								SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',DNA'
								SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',SNL'
							END
						END

						IF (@MusicDealCode = 0)
						BEGIN
							SELECT @ShowLinked = 'N', @isApprovedDeal = 'N', @IsError  = 'Y', @isValid = 'N'
							PRINT '  ERROR : Show not linked'
							PRINT '  ERROR : Deal not approved'
							SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',SNL,DNA'

							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
							ORDER BY DealCreatedOn ASC
						END

						SELECT @lastMDCode = @MusicDealCode, @MusicDealCode = 0

						SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData WHERE 
						((Deal_Workflow_Status = 'A' AND @isApprovedDeal = 'Y') OR @isApprovedDeal = 'N')
						AND Show_Linked = @ShowLinked
						AND @Schedule_Date BETWEEN Rights_Start_Date  AND Rights_End_Date
						AND Channel_Code = @ChannelCode 
						ORDER BY DealCreatedOn

						IF(@MusicDealCode = 0)
						BEGIN
							PRINT '  ERROR : Deal not found with valid channel and valid right period'
							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData WHERE 
							((Deal_Workflow_Status = 'A' AND @isApprovedDeal = 'Y') OR @isApprovedDeal = 'N')
							AND Show_Linked = @ShowLinked
							AND @Schedule_Date BETWEEN Rights_Start_Date  AND Rights_End_Date
							ORDER BY DealCreatedOn

							IF(@MusicDealCode > 0)
							BEGIN
								PRINT '  ERROR : Channel not found in current deal'
								SELECT	@lastMDCode = @MusicDealCode, 
										@IsError  = 'Y', @isValid = 'N',
										@AutoResolvedErrCodes = @AutoResolvedErrCodes + ',IRP', 
										@NewRaisedErrCodes = @NewRaisedErrCodes + ',CNF'
							END
							ELSE
							BEGIN
								PRINT '  ERROR : Schedule date is out of right period'
								SELECT @IsError  = 'Y', @isValid = 'N', @NewRaisedErrCodes = @NewRaisedErrCodes + ',IRP'

								SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData WHERE 
								((Deal_Workflow_Status = 'A' AND @isApprovedDeal = 'Y') OR @isApprovedDeal = 'N')
								AND Show_Linked = @ShowLinked AND Channel_Code = @ChannelCode 
								ORDER BY DealCreatedOn

								IF(@MusicDealCode = 0)
								BEGIN
									PRINT '  ERROR : Channel not found in current deal'	
									SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',CNF'
								END
								ELSE
								BEGIN
									SELECT	@lastMDCode = @MusicDealCode, 
											@AutoResolvedErrCodes = @AutoResolvedErrCodes + ',CNF'
								END
							END

							SET @MusicDealCode = @lastMDCode
						END
						ELSE
						BEGIN
							PRINT '  ERROR : Deal found with valid channel and valid right period'
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',IRP,CNF'
						END
					END
					ELSE
					BEGIN
						SELECT	@IsError  = 'N', @isValid = 'Y',
								@AutoResolvedErrCodes = @AutoResolvedErrCodes + ',SNL,DNA,IRP,CNF'
					END
					
				END

				IF(@isValid = 'Y')
				BEGIN
					PRINT '  MESSAGE : Found Valid Deal (Deal Code : ' + CAST(@MusicDealCode AS VARCHAR) + ')'
					DELETE FROM #CurrentMusicLabelDealData WHERE Music_Deal_Code <> @MusicDealCode

					PRINT '  Process Started For Run Validation'
					SELECT @RightRuleCode = 0, @NoOfSongs = 0,  @IsIgnore = 'N', @RunType = '', @ChannelType = ''

					SELECT TOP 1 @RightRuleCode = ISNULL(Right_Rule_Code, 0), @NoOfSongs = ISNULL(No_Of_Songs, 0), @RunType = Run_Type, @ChannelType = Channel_Type
					FROM #CurrentMusicLabelDealData WHERE Channel_Code = @ChannelCode
					ORDER BY DealCreatedOn

					IF(@RightRuleCode > 0)
					BEGIN
						PRINT '   Found Right Rule Code : ' + CAST(@RightRuleCode AS VARCHAR)
						DECLARE @DurationOfDay INT, @IsFirstAir CHAR(10), @NoOfRepeat INT, @PlayPerDay INT, @StartTime TIME, 
						@ScheduleItemLogDateTime VARCHAR(50), @MinDateTime DATETIME,@MaxDateTime DATETIME, @CountSchedule INT

						SELECT @StartTime=Start_Time, @PlayPerDay = Play_Per_Day, @DurationOfDay = Duration_Of_Day,
							@NoOfRepeat = No_Of_Repeat ,@IsFirstAir = CASE WHEN ISNULL(IS_First_Air,0) > 0 THEN 'Y' ELSE 'N' END
						FROM Right_Rule
						WHERE Right_Rule_Code = @RightRuleCode

						PRINT '    Start Time : ' + CAST(@StartTime AS VARCHAR)
						PRINT '    Play Per Day : ' + CAST(@PlayPerDay AS VARCHAR)
						PRINT '    Duration Of Day : ' + CAST(@DurationOfDay AS VARCHAR)
						PRINT '    No Of Repeat : ' + CAST(@NoOfRepeat AS VARCHAR)
						PRINT '    Is First Air : ' + CASE WHEN @IsFirstAir = 'Y' THEN 'Yes' ELSE 'No' END

						PRINT '    Timing Calculation For Repeat Run Duration'
						SELECT TOP 1 @MinDateTime = CASE 
								WHEN @IsFirstAir = 'Y' THEN	MAX(CAST(TSD.Schedule_Date + ' ' + CAST(TSD.Schedule_Item_Log_Time AS VARCHAR(8)) AS DATETIME))
								ELSE MAX(CAST(TSD.Schedule_Date + ' ' + CAST(@StartTime as VARCHAR(8)) AS DATETIME))
							END
						FROM Music_Schedule_Transaction MST
						INNER JOIN #TempScheduleData TSD ON MST.BV_Schedule_Transaction_Code = TSD.BV_Schedule_Transaction_Code
						WHERE MST.Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode AND MST.Is_Ignore = 'N'

						SELECT @MaxDateTime = DATEADD(SECOND,-1,DATEADD(HOUR,ISNULL(@DurationOfDay,24),@MinDateTime)) 
						PRINT '    Min Date Time : ' + CAST(@MinDateTime AS VARCHAR)
						PRINT '    Max Date Time : ' + CAST(@MaxDateTime AS VARCHAR)

						SET @CountSchedule = 0
						SELECT @CountSchedule = COUNT(Music_Schedule_Transaction_Code)
						FROM Music_Schedule_Transaction MST
						INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
						INNER JOIN BV_Schedule_Transaction BST  ON MST.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code 
						WHERE CML.Music_Title_Code = @MusicTitleCode 
						AND MST.Music_Label_Code = @MusicLabelCode
						AND MST.Music_Deal_Code = @MusicDealCode
						AND MST.Channel_Code = @ChannelCode
						AND MST.Music_Schedule_Transaction_Code < @MusicScheduleTransactionCode
						AND CAST(BST.Schedule_Item_Log_Date + ' ' + BST.Schedule_Item_Log_Time AS DATETIME) BETWEEN @MinDateTime AND @MaxDateTime

						PRINT '    Count of Total Scheduled Run Before Current MusicScheduleTransactionCode (' + CAST(@MusicScheduleTransactionCode AS VARCHAR) 
							+ ') : ' + CAST(@CountSchedule AS VARCHAR)
						PRINT '    Execute logic to set value of ''IsIgnore'' flag'
						IF((@CountSchedule + 1) BETWEEN (@PlayPerDay + 1) AND  (@NoOfRepeat + @PlayPerDay))
						BEGIN
							SET @IsIgnore = 'Y'
							PRINT '   Ignore This Run'
						END
						IF((@CountSchedule + 1) > (@NoOfRepeat + @PlayPerDay))
						BEGIN
							PRINT '   ERROR : Exceeds Allocated Repeat run'
							SELECT @IsError  = 'Y'
							SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',EARR'
						END
						ELSE
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',EARR'
					END

					UPDATE Music_Schedule_Transaction SET Is_Ignore = @IsIgnore, Music_Deal_Code = @MusicDealCode
					WHERE Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode

					PRINT '   Update Scheduled_Runs in Music_Deal_Channel table'
					SET @CountSchedule = 0
					SELECT @CountSchedule = COUNT(Music_Schedule_Transaction_Code) 
					FROM Music_Schedule_Transaction WHERE  Music_Deal_Code = @MusicDealCode AND Is_Ignore = 'N' AND Channel_Code = @ChannelCode

					UPDATE Music_Deal_Channel SET Scheduled_Runs = @CountSchedule 
					WHERE Music_Deal_Code = @MusicDealCode AND Channel_Code = @ChannelCode

					IF(@RunType = 'L')
					BEGIN
						DECLARE @Scheduled_Runs INT = 0
						SELECT @Scheduled_Runs = ISNULL(SUM(Scheduled_Runs), 0) FROM Music_Deal_Channel WHERE Music_Deal_Code = @MusicDealCode

						IF (@Scheduled_Runs > @NoOfSongs)
						BEGIN
							PRINT '   Scheduled_Runs : ' +  CAST(@Scheduled_Runs AS VARCHAR)
							PRINT '   NoOfSongs : ' +  CAST(@NoOfSongs AS VARCHAR)
							PRINT '   ERROR : Exceeds Allocated Runs'
							SELECT @IsError  = 'Y'
							SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',EAR'
						END
						ELSE
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',EAR'

						IF(@ChannelType = 'C')
						BEGIN
							IF EXISTS (
								SELECT * FROM Music_Deal_Channel 
								WHERE Music_Deal_Code = @MusicDealCode AND Channel_Code = @ChannelCode  AND 
									ISNULL(Scheduled_Runs, 0) > ISNULL(Defined_Runs, 0)
							)
							BEGIN
								PRINT '   ERROR : Exceeds Channel Wise Allocated Runs'
								SELECT @IsError  = 'Y'
								SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',ECAR'
							END
							ELSE
								SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',ECAR'
						END
						ELSE
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',ECAR'
					END
					ELSE
						SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',EAR,ECAR'
					
					PRINT '  Process End For Run Validation'
				END

				IF(@CallFrom = 'AR')
				BEGIN
					PRINT '  MESSAGE : Set Status = ''AR'' for Upload_Error_Code ' + @AutoResolvedErrCodes
					UPDATE MSE SET MSE.[Status] = 'AR' FROM Music_Schedule_Exception MSE
					INNER JOIN Error_Code_Master ECM ON ECM.Error_Code = MSE.Error_Code
					WHERE MSE.Music_schedule_Transaction_Code = @MusicScheduleTransactionCode AND ISNULL(MSE.[Status], 'E') = 'E'
					AND ECM.Error_For = 'MSE' AND ECM.Upload_Error_Code IN (
						SELECT number FROM fn_Split_withdelemiter(@AutoResolvedErrCodes, ',') WHERE LTRIM(number) <> ''
					)
				END

				IF(@NewRaisedErrCodes <> '')
				BEGIN
					PRINT '  MESSAGE : Add Exception or Set Status = ''E'' for Upload_Error_Code ' + @NewRaisedErrCodes
					INSERT INTO Music_Schedule_Exception(Music_Schedule_Transaction_Code, Error_Code, [Status], Is_Mail_Sent)
					SELECT @MusicScheduleTransactionCode, ECM.Error_Code, 'E', 'N' FROM Error_Code_Master ECM 
					INNER JOIN (
						SELECT number AS Error_Key FROM fn_Split_withdelemiter(@NewRaisedErrCodes, ',') WHERE LTRIM(number) <> ''
					) NRE ON NRE.Error_Key = ECM.Upload_Error_Code
					WHERE ECM.Error_For = 'MSE' AND
					NOT EXISTS(
						SELECT * FROM #ExistingException EE WHERE EE.Error_Code = ECM.Error_Code AND 
						EE.MusicScheduleTransactionCode = @MusicScheduleTransactionCode 
					)

					UPDATE MSE SET MSE.[Status] = 'E' FROM #ExistingException EE
					INNER JOIN (
						SELECT number AS Error_Key FROM fn_Split_withdelemiter(@NewRaisedErrCodes, ',') WHERE LTRIM(number) <> ''
					) NRE ON NRE.Error_Key COLLATE SQL_Latin1_General_CP1_CI_AS = EE.Error_Key COLLATE SQL_Latin1_General_CP1_CI_AS
					INNER JOIN Music_Schedule_Exception MSE ON MSE.Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode
						AND EE.Error_Code = MSE.Error_Code AND MSE.[Status] <> 'E'
				END

				PRINT '  @MusicDealCode = ' + CAST(@MusicDealCode AS VARCHAR)
				PRINT '  @IsError = ' + @IsError

				UPDATE Music_Schedule_Transaction SET Music_Deal_Code = @MusicDealCode, 
					Is_Exception = @IsError, Is_Processed = 'Y'
				WHERE Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode
				/* END : VALIDATION */

				UPDATE #TempMusicScheduleTransaction SET Is_Processed = 'Y' WHERE MusicScheduleTransactionCode = @MusicScheduleTransactionCode
				PRINT ' Process End For @MusicScheduleTransactionCode = ' + CAST(@MusicScheduleTransactionCode AS VARCHAR)
				PRINT ' ---------------------------------------------------------'
				SELECT @MusicScheduleTransactionCode = 0, @BV_Schedule_Transaction_Code = 0, @MusicLabelCode = 0, @IsError  = 'N', @MusicTitleCode = 0

				SELECT TOP 1 @MusicScheduleTransactionCode = MusicScheduleTransactionCode, @BV_Schedule_Transaction_Code = BV_Schedule_Transaction_Code,
				@MusicLabelCode = ISNULL(Music_Label_Code, 0), @MusicTitleCode = ISNULL(Music_Title_Code ,0) 
				FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N'
				ORDER BY MusicScheduleTransactionCode
			END

			IF(@MusicDealCode > 0 AND @isValid = 'Y')
			BEGIN
				SELECT @RunType = Run_Type FROM Music_Deal MD WHERE Music_Deal_Code = @MusicDealCode

			END
		END
		ELSE
		BEGIN
			PRINT ' ERROR : Music Track has not assigned to Title'
		END
	END
	ELSE
	BEGIN
		PRINT ' Did not get Schedule Data'
	END
	PRINT 'Music Schedule Process Ended'
	PRINT '==============================================================================================================================================='	
	
	BEGIN
		PRINT 'Music Schedule Exception Mail Process Started'
		DECLARE @IsChannelwiseMail VARCHAR(1) = 'N'
		SELECT TOP 1 @IsChannelwiseMail = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'IS_Schedule_Mail_Channelwise'

		IF(OBJECT_ID('TEMPDB..#TempMailData') IS NOT NULL)
			DROP TABLE #TempMailData

		DECLARE @To_Users_Code NVARCHAR(MAX),@CC_Users_Code  NVARCHAR(MAX),@BCC_Users_Code  NVARCHAR(MAX)

		CREATE TABLE #TempMailData
		(
			RowNo INT IDENTITY(1,1),
			Channel_Codes VARCHAR(MAX),
			To_User_Mail_Id NVARCHAR(MAX), CC_User_Mail_Id NVARCHAR(MAX), BCC_User_Mail_Id NVARCHAR(MAX),
			Record_Count INT,
			Email_Data NVARCHAR(MAX),
			IsMailSent CHAR(1) DEFAULT('N')
		)
		-----------------------------------------------
		DECLARE @Tbl2 TABLE (
			Id INT,
			BuCode INT,
			To_Users_Code NVARCHAR(MAX),
			To_User_Mail_Id  NVARCHAR(MAX),
			CC_Users_Code  NVARCHAR(MAX),
			CC_User_Mail_Id  NVARCHAR(MAX),
			BCC_Users_Code  NVARCHAR(MAX),
			BCC_User_Mail_Id  NVARCHAR(MAX),
			Channel_Codes NVARCHAR(MAX)
		)
		DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 
		INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
		EXEC USP_Get_EmailConfig_Users 'CUR', 'N'

						
	-----------------------------------------------------------
		IF(@IsChannelwiseMail = 'Y')
		BEGIN
			PRINT ' Send seperate mail for every channel'
			INSERT INTO #TempMailData(channel_codes, to_user_mail_id, cc_user_mail_id, bcc_user_mail_id, record_count, email_data)
			SELECT DISTINCT p.number , To_User_Mail_Id, CC_User_Mail_Id, BCC_User_Mail_Id,  0, ''
			FROM @Tbl2 A
			CROSS APPLY dbo.fn_Split_withdelemiter(A.Channel_Codes, ',') p
			--INSERT INTO #TempMailData(Channel_Codes, User_Email_Id, Record_Count, Email_Data, User_Code)
			--SELECT distinct	','+ cast(c.Channel_Code as varchar(10)) + ',',
			--U.email_id, 0, '' , u.Users_Code
			--from [dbo].[UFN_Get_Bu_Wise_User]('MSE') buUsers
			--INNER JOIN Users u on u.Users_Code = buUsers.Users_Code
			--INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
			--inner join Channel c on ','+buUsers.Channel_Codes+ ',' like '%,'+ cast(c.Channel_Code as varchar(20)) +',%'
		END
		ELSE
		BEGIN
			insert into #TempMailData(channel_codes, to_user_mail_id, cc_user_mail_id, bcc_user_mail_id, record_count, email_data)
			select channel_Codes, To_User_Mail_Id, CC_User_Mail_Id, BCC_User_Mail_Id,  0, '' from @Tbl2

			--PRINT ' Send single mail for All Channel'
			--INSERT INTO #TempMailData(Channel_Codes, User_Email_Id, Record_Count, Email_Data, User_Code)
			--SELECT distinct
			--','+ buUsers.Channel_Codes + ',',
			--U.email_id, 0, '' , u.Users_Code
			--from [dbo].[UFN_Get_Bu_Wise_User]('MSE') buUsers
			--INNER JOIN Users u on u.Users_Code = buUsers.Users_Code
			--INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
		END
	
		DECLARE @Music_Schedule_Transaction_Code INT = 0, @Exception VARCHAR(250), @Content NVARCHAR(1000), @Episode_No INT, @Airing_Date VARCHAR(50), @Airing_Time VARCHAR(50),
		@Channel_Code BIGINT, @Channel_Name NVARCHAR(200), @Music_Title_Name NVARCHAR(2000), @Movie_Album NVARCHAR(1000), @Music_Label_Name VARCHAR(100)

		DECLARE @trTable NVARCHAR(MAX) = '', @RowNo INT = 0, @User_Email_Id VARCHAR(MAX) = '', @cc_user_mail_id  NVARCHAR(MAX) = '', @bcc_user_mail_id   NVARCHAR(MAX) = '', @totalException BIGINT = 0
		SET @trTable = '<tr>      
			<th align="center" width="15%" class="tblHead"><b>Exception<b></th>    
			<th align="center" width="15%" class="tblHead"><b>Content<b></th>      
			<th align="center" width="5%" class="tblHead"><b>Episode No<b></th>      
			<th align="center" width="10%" class="tblHead"><b>Airing Date<b></th>      
			<th align="center" width="10%" class="tblHead"><b>Airing Time<b></th>      
			<th align="center" width="10%" class="tblHead"><b>Channel Name<b></th>
			<th align="center" width="15%" class="tblHead"><b>Music Track<b></th>
			<th align="center" width="10%" class="tblHead"><b>Movie / Album<b></th>
			<th align="center" width="10%" class="tblHead"><b>Music Label<b></th>
		</tr>'

		UPDATE #TempMailData SET Email_Data = @trTable

		PRINT ' Fetch Exceptional Data for TitleCode : ' + CAST(ISNULL(@TitleCode, 0) AS VARCHAR) + ', Episode_No : ' + CAST(ISNULL(@EpisodeNo, 0) AS VARCHAR)
		DECLARE curMailData CURSOR FOR
			SELECT DISTINCT MST.Music_Schedule_Transaction_Code,
			CASE WHEN ISNULL(MD.Agreement_No, '') <> '' THEN ECM.Error_Description +' (' + MD.Agreement_No  +')' ELSE ECM.Error_Description END AS Exception , ISNULL(T.Title_Name, '') AS Content, 
			ISNULL(TC.Episode_No, 0) AS Episode_No, BST.Schedule_Item_Log_Date AS Airing_Date, BST.Schedule_Item_Log_Time AS Airing_Time, 
			ISNULL(MST.Channel_Code, 0) AS Channel_Code, ISNULL(C.Channel_Name, '') AS Channel_Name , ISNULL(MT.Music_Title_Name, '') AS Music_Title_Name,
			ISNULL(MA.Music_Album_Name, MT.Movie_Album) AS Movie_Album, ISNULL(ML.Music_Label_Name, '') AS Music_Label_Name
			FROM Music_Schedule_Transaction MST
			INNER JOIN Music_Schedule_Exception MSE ON MSE.Music_Schedule_Transaction_Code = MST.Music_Schedule_Transaction_Code
			INNER JOIN Error_Code_Master ECM ON ECM.Error_Code = MSE.Error_Code
			INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
			INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
			INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
				AND TC.Title_Content_Code =  CML.Title_Content_Code
			INNER JOIN Title T ON T.Title_Code = BST.Title_Code AND T.Title_Code = TC.Title_Code
			INNER JOIN Music_Title MT ON MT.Music_Title_Code = CML.Music_Title_Code
			LEFT JOIN Channel C ON C.Channel_Code = MST.Channel_Code
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MST.Music_Label_Code
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
			LEFT JOIN Music_Deal MD ON MD.Music_Deal_Code = MST.Music_Deal_Code
			WHERE ISNULL(MSE.Is_Mail_Sent, 'N') = 'N' AND ISNULL(MST.Is_Exception, 'N') = 'Y'
			AND TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo
		OPEN curMailData
		FETCH NEXT FROM curMailData INTO @Music_Schedule_Transaction_Code, @Exception, @Content, @Episode_No, 
			@Airing_Date, @Airing_Time, @Channel_Code, @Channel_Name, @Music_Title_Name, 
			@Movie_Album, @Music_Label_Name
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @totalException = (@totalException + 1)
			SELECT @RowNo = 0, @trTable = ''
			SELECT TOP 1 @RowNo = RowNo FROM #TempMailData WHERE Channel_Codes LIKE '%,' + CAST(@Channel_Code AS VARCHAR) + ',%'
			PRINT '  Generate HTML Row for @Channel_Code : ' + CAST(@Channel_Code AS VARCHAR) + ',  @RowNo : ' + CAST(@RowNo AS VARCHAR)

			IF(@RowNo > 0)
			BEGIN
				SET @trTable = @trTable + '<tr>'
				SET @trTable = @trTable + '<td align="center" class="tblData">' + @Exception + '</td>
					<td align="center" class="tblData">' + @Content + '</td>
					<td align="center" class="tblData">' + CAST(@Episode_No AS VARCHAR) + '</td>
					<td align="center" class="tblData">' + @Airing_Date + '</td>
					<td align="center" class="tblData">' + @Airing_Time + '</td>
					<td align="center" class="tblData">' + @Channel_Name + '</td>
					<td align="center" class="tblData">' + @Music_Title_Name + '</td>
					<td align="center" class="tblData">' + @Movie_Album + '</td>
					<td align="center" class="tblData">' + @Music_Label_Name + '</td>'
				SET @trTable = @trTable + '</tr>'

				IF NOT EXISTS (SELECT * FROM #TempMailData WHERE Email_Data LIKE '%'+ @trTable +'%')
					UPDATE #TempMailData SET Email_Data = (Email_Data +  @trTable), Record_Count = (Record_Count + 1)  
					WHERE Channel_Codes LIKE '%,' + CAST(@Channel_Code AS VARCHAR) + ',%'

				UPDATE Music_Schedule_Transaction SET Is_Mail_Sent = 'Q' WHERE Music_Schedule_Transaction_Code = @Music_Schedule_Transaction_Code

				UPDATE Music_Schedule_Exception SET Is_Mail_Sent = 'Q' WHERE Music_Schedule_Transaction_Code = @Music_Schedule_Transaction_Code
				AND Is_Mail_Sent = 'N'
			END

			FETCH NEXT FROM curMailData INTO @Music_Schedule_Transaction_Code, @Exception, @Content, @Episode_No, 
			@Airing_Date, @Airing_Time, @Channel_Code, @Channel_Name, @Music_Title_Name, 
			@Movie_Album, @Music_Label_Name
		END
		CLOSE curMailData
		DEALLOCATE curMailData


		IF(@totalException > 0)
		BEGIN
			IF EXISTS (SELECT * FROM #TempMailData WHERE Record_Count > 0)
			BEGIN
				PRINT ' Fetch Mail Body and Email Profile'
				DECLARE @mailBody NVARCHAR(MAX), @mailBodyWithData NVARCHAR(MAX), @dbEmail_Profile VARCHAR(100) = '', @DefaultSiteUrl VARCHAR(500) = ''
				SELECT top 1 @dbEmail_Profile = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile'
				SELECT TOP 1 @mailBody = Template_Desc FROM Email_Template WHERE Template_For = 'MS'
				
			
				SELECT TOP 1 @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
				SET @mailBody = REPLACE(@mailBody, '{Link}', @DefaultSiteUrl)
				
				SELECT @RowNo = 0, @trTable = '', @User_Email_Id = ''
				SELECT TOP 1 @RowNo =  RowNo, @trTable = Email_Data, @User_Email_Id = to_user_mail_id, @cc_user_mail_id = cc_user_mail_id, @bcc_user_mail_id = bcc_user_mail_id
				FROM #TempMailData WHERE IsMailSent = 'N' AND Record_Count > 0
				
				WHILE(@RowNo > 0 AND @trTable <> '' AND @User_Email_Id <> '')
				BEGIN	
					SET @mailBodyWithData = ''
					SET @mailBodyWithData = REPLACE(@mailBody, '{TABLE_DATA}', @trTable)

					PRINT '  @User_Email_Id : ' + @User_Email_Id
					PRINT '  @mailBodyWithData : ' + @mailBodyWithData

					
					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @dbEmail_Profile,
					@recipients =  @User_Email_Id,
					@copy_recipients = @CC_User_Mail_Id,
					@blind_copy_recipients = @BCC_User_Mail_Id,
					@subject = 'Music Schedule Exception',
					@body = @mailBodyWithData, 
					@body_format = 'HTML';

		
					SELECT  @User_Email_Id = ISNULL(STUFF((SELECT ';' + A.number FROM dbo.fn_Split_withdelemiter(@User_Email_Id,';') AS A INNER JOIN Users U on U.Email_Id = A.number FOR XML PATH('')), 1, 1, '') ,''),
							@To_Users_Code = ISNULL( STUFF(( SELECT ',' + CAST(U.Users_Code AS NVARCHAR(MAX)) FROM dbo.fn_Split_withdelemiter(@User_Email_Id,';') AS A INNER JOIN Users U on U.Email_Id = A.number FOR XML PATH('')), 1, 1, '') ,''),
							@CC_User_Mail_Id = ISNULL(STUFF((SELECT ';' + A.number FROM dbo.fn_Split_withdelemiter(@CC_User_Mail_Id,';') AS A INNER JOIN Users U on U.Email_Id = A.number FOR XML PATH('')), 1, 1, '') ,''),
							@CC_Users_Code = ISNULL( STUFF(( SELECT ',' + CAST(U.Users_Code AS NVARCHAR(MAX)) FROM dbo.fn_Split_withdelemiter(@CC_User_Mail_Id,';') AS A INNER JOIN Users U on U.Email_Id = A.number FOR XML PATH('')), 1, 1, '') ,''),
							@BCC_User_Mail_Id = ISNULL(STUFF((SELECT ';' + A.number FROM dbo.fn_Split_withdelemiter(@BCC_User_Mail_Id,';') AS A INNER JOIN Users U on U.Email_Id = A.number FOR XML PATH('')), 1, 1, '') ,''),
							@BCC_Users_Code = ISNULL( STUFF(( SELECT ',' + CAST(U.Users_Code AS NVARCHAR(MAX)) FROM dbo.fn_Split_withdelemiter(@BCC_User_Mail_Id,';') AS A INNER JOIN Users U on U.Email_Id = A.number FOR XML PATH('')), 1, 1, '') ,'')
	
					INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
					SELECT @Email_Config_Code,'<table class=''tblFormat'' >'+@trTable+'</table>', ISNULL(@To_Users_Code,''), ISNULL(@User_Email_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), 'Music Schedule Exception'
				
					UPDATE #TempMailData SET IsMailSent = 'Y' WHERE RowNo = @RowNo

					SELECT @RowNo = 0, @trTable = '', @User_Email_Id = '', @cc_user_mail_id = '', @bcc_user_mail_id = ''
					SELECT TOP 1 @RowNo =  RowNo, @trTable = Email_Data, @User_Email_Id = to_user_mail_id,
					@cc_user_mail_id = CC_User_Mail_Id, @bcc_user_mail_id = BCC_User_Mail_Id
					FROM #TempMailData WHERE IsMailSent = 'N' AND Record_Count > 0

					print 'End - @RowNo - '+cast(@RowNo as varchar(50))
				END
				PRINT ' All Mail Sent'
				UPDATE Music_Schedule_Transaction SET Is_Mail_Sent = 'Y' WHERE Is_Mail_Sent = 'Q' AND Is_Exception = 'Y'
				UPDATE Music_Schedule_Exception SET Is_Mail_Sent = 'Y' WHERE Is_Mail_Sent = 'Q'
			END
			ELSE
			BEGIN
				PRINT ' Exceptional Data Not Found for Configured Channel'
			END
		END
		ELSE
		BEGIN
			PRINT ' Exceptional Data Not Found '
		END
		PRINT 'Music Schedule Exception Mail Process Ended'
		PRINT '==============================================================================================================================================='	
	END

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

	IF OBJECT_ID('tempdb..#AllMusicLabelDealData') IS NOT NULL DROP TABLE #AllMusicLabelDealData
	IF OBJECT_ID('tempdb..#CurrentMusicLabelDealData') IS NOT NULL DROP TABLE #CurrentMusicLabelDealData
	IF OBJECT_ID('tempdb..#ExistingException') IS NOT NULL DROP TABLE #ExistingException
	IF OBJECT_ID('tempdb..#TempMailData') IS NOT NULL DROP TABLE #TempMailData
	IF OBJECT_ID('tempdb..#TempMusicScheduleTransaction') IS NOT NULL DROP TABLE #TempMusicScheduleTransaction
	IF OBJECT_ID('tempdb..#TempScheduleData') IS NOT NULL DROP TABLE #TempScheduleData
END
GO
PRINT N'Altering [dbo].[USP_Send_Mail_WBS_Linked_Titles]...';


GO
ALTER PROC USP_Send_Mail_WBS_Linked_Titles
(
	@WBS_Codes VARCHAR(MAX)
)
AS
--=============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 16-July-2015
-- Description:	While importing any WBS comes with these status (TECO, CLSD or LKD) and that WBS is already in RightsU SAP_WBS table, 
--				so RightsU will update WBS entry and RightsU will check wether this WBS is linked, 
--				If yes then RightsU will send an email alert to user asking him to assign a new WBS Code for that particular deal and title.
-- =============================================
BEGIN
	--DECLARE @WBS_Codes VARCHAR(MAX) = 'F/LIC-0000001.01,F/LIC-0000001.02,F/LIC-0000001.03'
	DECLARE   @Is_Processed CHAR(1)
	DECLARE @BuCode INT, @User_Mail_Id NVARCHAR(1000), @Users_Code INT
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END
	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config where [Key]='WTL'

	SELECT SW.WBS_Code, AD.Agreement_No, 
	dbo.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADB.Episode_From, ADB.Episode_To) AS Title_Name,
	AD.Business_Unit_Code
	INTO #Linked_Title
	FROM Acq_Deal_Budget ADB 
	INNER JOIN SAP_WBS SW ON ADB.SAP_WBS_Code = SW.SAP_WBS_Code
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADB.Acq_Deal_Code
	INNER JOIN Title T ON T.Title_Code = ADB.Title_Code
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND SW.WBS_Code IN ( SELECT number from dbo.fn_Split_withdelemiter(@WBS_Codes, ','))

	IF EXISTS(SELECT * FROM #Linked_Title)
	BEGIN
	PRINT 'Fount Linked Title Data'


		DECLARE @Business_Unit_Code INT,
		@To_Users_Code NVARCHAR(MAX),
		@To_User_Mail_Id  NVARCHAR(MAX),
		@CC_Users_Code  NVARCHAR(MAX),
		@CC_User_Mail_Id  NVARCHAR(MAX),
		@BCC_Users_Code  NVARCHAR(MAX),
		@BCC_User_Mail_Id  NVARCHAR(MAX),
		@Channel_Codes NVARCHAR(MAX)
	
		DECLARE @Tbl2 TABLE (
			Id INT,
			BuCode INT,
			To_Users_Code NVARCHAR(MAX),
			To_User_Mail_Id  NVARCHAR(MAX),
			CC_Users_Code  NVARCHAR(MAX),
			CC_User_Mail_Id  NVARCHAR(MAX),
			BCC_Users_Code  NVARCHAR(MAX),
			BCC_User_Mail_Id  NVARCHAR(MAX),
			Channel_Codes NVARCHAR(MAX)
		)

	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2(Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'WTL', 'N'


		DECLARE @emailTemplate VARCHAR(MAX)
		SELECT @emailTemplate = Template_Desc FROM Email_Template WHERE Template_For='SAP_WBS_LINKED'

		DECLARE @WBS_Code VARCHAR(MAX) = NULL, @Agreement_No VARCHAR(MAX) = NULL, @Title_Name VARCHAR(MAX) = ''
		SELECT DISTINCT WBS_Code, Agreement_No, 'N' AS Is_Processed INTO #TEMP_AgreementNo FROM #Linked_Title

		DECLARE CurOuter CURSOR FOR
		SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
		--SELECT BuCode, User_Mail_Id, Users_Code from [dbo].[UFN_Get_Bu_Wise_User]('WTL')

		OPEN CurOuter
		FETCH NEXT FROM CurOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		--Into @BuCode, @User_Mail_Id, @Users_Code
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			DECLARE @mailBody VARCHAR(MAX) = ''
			
			DECLARE @EmailTable VARCHAR(MAX) = '' 
			IF EXISTS(SELECT * FROM #Linked_Title WHERE Business_Unit_Code = @Business_Unit_Code )
			BEGIN
			SET @EmailTable = '<table class="tblFormat"><tr>
				<th align="center" width="20%" class="tblHead">WBS Code</th>      
				<th align="center" width="15%" class="tblHead">Agreement No.</th>      
				<th align="center" width="30%" class="tblHead">Title(s)</th> 
			</tr>'
			END
			DECLARE CurInner CURSOR FOR
			SELECT DISTINCT WBS_Code, Agreement_No, 'N' AS Is_Processed, Business_Unit_Code FROM #Linked_Title 
			where Business_Unit_Code=@Business_Unit_Code
			OPEN CurInner
			FETCH NEXT FROM CurInner Into @WBS_Code, @Agreement_No, @Is_Processed, @BuCode
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				SET @Title_Name = ''
				SELECT @Title_Name += ', ' + Title_Name FROM #Linked_Title WHERE Agreement_No = @Agreement_No
				SET @Title_Name = RIGHT(@Title_Name, (LEN(@Title_Name) - 2))
			
				SET @EmailTable =@EmailTable +  '<tr>
				<td align="center" class="tblData">' + @WBS_Code + '</td>
				<td align="center" class="tblData">' + @Agreement_No + '</td>  
				<td align="center" class="tblData">'+@Title_Name + '</td></tr>'

				FETCH NEXT FROM CurInner Into @WBS_Code, @Agreement_No, @Is_Processed, @BuCode
			END
			CLOSE CurInner
			DEALLOCATE CurInner

			IF(@EmailTable!='')
			BEGIN
				SET @EmailTable =@EmailTable +  '</table>'
				SET @mailBody = REPLACE(@emailTemplate,'{TABLE_DATA}',@EmailTable)  
			
			DECLARE @DatabaseEmail_Profile varchar(200), @emailAddresses VARCHAR(MAX) = ''
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'

				
				EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmail_Profile,
				@recipients =  @To_User_Mail_Id,
				@copy_recipients = @CC_User_Mail_Id,
				@blind_copy_recipients = @BCC_User_Mail_Id,
				@subject = 'WBS Codes are already linked',
				@body = @mailBody, 
				@body_format = 'HTML';


				
				INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@EmailTable, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'WBS Title Link'

			END
			FETCH NEXT FROM CurOuter Into  @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		END
		CLOSE CurOuter
		DEALLOCATE CurOuter

	END

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT


	IF OBJECT_ID('tempdb..#Linked_Title') IS NOT NULL
	BEGIN
		DROP TABLE #Linked_Title
	END
	IF OBJECT_ID('tempdb..#TEMP_AgreementNo') IS NOT NULL
	BEGIN
		DROP TABLE #TEMP_AgreementNo
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp

END
GO
PRINT N'Altering [dbo].[USP_Syn_Deal_Rights_Error_Details_Mail]...';


GO
ALTER PROCEDURE [dbo].[USP_Syn_Deal_Rights_Error_Details_Mail] 
-- =============================================
-- Author:	Akshay R Rane
-- Edited by: Anchal Sikarwar
-- Create date: 3-03-2017
-- =============================================
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @EmailBody NVARCHAR(MAX)='',@EmailBody1 NVARCHAR(MAX)='',@EmailBody2 NVARCHAR(MAX)='',@MailSubject NVARCHAR(MAX), @DatabaseEmailProfile NVARCHAR(25),
	@EmailHeader NVARCHAR(MAX)='', @EmailFooter NVARCHAR(MAX)='', @users NVARCHAR(MAX), @UsersEmailId NVARCHAR(MAX),@Users_Email_id NVARCHAR(MAX),
	@Title_Name NVARCHAR(MAX), @Platform NVARCHAR(MAX), @Agreement_No NVARCHAR(100), @PeriodFrom VARCHAR(100), @PeriodTo VARCHAR(100), 
	@Region NVARCHAR(max), @Title_Language NVARCHAR(MAX), @Subtitling NVARCHAR(MAX), @Dubbing NVARCHAR(MAX), @Exists_In NVARCHAR(MAX), @ErrorMsg NVARCHAR(MAX), 
	@CAgreement_No NVARCHAR(100), @Users_Code INT, @Email_Config_Code INT, @Vendor_Name NVARCHAR(MAX)

	---------------
	DECLARE @Business_Unit_Code INT,
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX),
	@Channel_Codes NVARCHAR(MAX)
	
	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)

	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'SRV', 'N'


	--------------


	DECLARE @DefaultSiteUrl VARCHAR(MAX)
	Select @DefaultSiteUrl = DefaultSiteUrl from System_Param	
	DECLARE @DefaultDate datetime = GETDATE() - 7
	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config where [Key]='SRV'
	DECLARE CurMail2 CURSOR FOR
	--Change
	--SELECT User_Mail_Id, BuCode,Users_Code from [dbo].[UFN_Get_Bu_Wise_User]('SRV')
	SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
	--Change

	OPEN CurMail2
	FETCH NEXT FROM CurMail2 INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
	--Into @Users_Email_id,@Business_Unit_Code,@Users_Code
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF ((SELECT COUNT(*) FROM Syn_Deal_Rights_Error_Details	AS SDE
			INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
			WHERE SDE.Inserted_On < @DefaultDate AND SD.Business_Unit_Code=@Business_Unit_Code)>0)
		BEGIN
			SET @EmailBody = '<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>'
		END
		SET @MailSubject = 'RightsU : Conflict found in Syndication Deal Rights'
		SELECT @DatabaseEmailProfile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'  

		DECLARE CurMail1 CURSOR FOR
		SELECT DISTINCT SDE.ErrorMsg
		FROM Syn_Deal_Rights_Error_Details AS SDE
		INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
		WHERE SDE.Inserted_On < @DefaultDate AND SD.Business_Unit_Code=@Business_Unit_Code 
		OPEN CurMail1
		FETCH NEXT FROM CurMail1 Into @ErrorMsg
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			IF ((SELECT COUNT(*) FROM Syn_Deal_Rights_Error_Details	AS SDE
				INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
				INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
				WHERE SDE.Inserted_On < @DefaultDate AND SDE.ErrorMsg=@ErrorMsg AND SD.Business_Unit_Code=@Business_Unit_Code)>0)
				BEGIN
					SET @EmailBody1 = '<tr><th colspan="11" style="padding: 8px 0px 3px 0px; font-weight:bold">
								Error Description:'+@ErrorMsg+' </th></tr>'

					SET @EmailBody1 = @EmailBody1 + '<tr><th align="center" width="10%">Title Name</th>      
														 <th align="center" width="10%">Platform</th>    
														 <th align="center" width="10%">Agreement No</th>    
														 <th align="center" width="10%">Conflicted Agreement No</th>    
														 <th align="center" width="5%" >Party</th>    
														 <th align="center" width="10%">Period</th>    
														 <th align="center" width="5%" >Region</th>    
														 <th align="center" width="10%">Title Language</th>    
														 <th align="center" width="10%">Subtitling</th>    
														 <th align="center" width="10%">Dubbing</th>  
														 <th align="center" width="10%">Exists In</th>    
													 </tr>'
				END
				SET @EmailBody2=''
				DECLARE CurMail CURSOR FOR
				SELECT Isnull(SDE.Title_Name,' '), Isnull(SDE.Platform_Name,' '), Isnull(SD.Agreement_No, ' '), Isnull(SDE.Agreement_No, ' '), ISNULL(CONVERT(VARCHAR,SDE.Right_Start_Date,106),''), 
				
				
				  ISNULL(CONVERT(VARCHAR,SDE.Right_End_Date,106),'')
				 , Isnull(SDE.Country_Name , ' '), Isnull(SDE.Is_Title_Language_Right, ' '), Isnull(SDE.Subtitling_Language, ' '), 
				ISNULL(SDE.Dubbing_Language, ' '), Isnull(SDE.IsPushback ,' '),
				(SELECT Vendor_Name from Vendor where Vendor_Code=
					SD.Vendor_Code) AS Vendor_Name
				
				FROM Syn_Deal_Rights_Error_Details SDE
				INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
				INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
				WHERE SDE.Inserted_On < @DefaultDate AND SDE.ErrorMsg=@ErrorMsg AND SD.Business_Unit_Code=@Business_Unit_Code
				OPEN CurMail
				FETCH NEXT FROM CurMail Into @Title_Name, @Platform ,@Agreement_No,@CAgreement_No, @PeriodFrom, @PeriodTo, @Region, @Title_Language,
				 @Subtitling, @Dubbing, @Exists_In, @Vendor_Name
				WHILE(@@FETCH_STATUS = 0)
				BEGIN
					SET @EmailBody2 = Isnull(@EmailBody2, ' ')+'<tr>
								<td align="center" width="10%" >'+Isnull(@Title_Name, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@Platform, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@Agreement_No, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@CAgreement_No, ' ')+'</td>
								<td align="center" width="5%" >'+Isnull(@Vendor_Name, ' ')+'</td>'
								+'<td align="center" width="10%" >'+
								CASE 
								WHEN @PeriodFrom='NA' THEN @PeriodFrom 
								WHEN @PeriodTo ='' THEN 
								--'Perpetuity from '+
								replace(@PeriodFrom,' ','-') 
								ELSE
								replace(@PeriodFrom ,' ','-') 
								+' To '+replace(Convert(NVARCHAR ,@PeriodTo ,106),' ','-') END+'</td>'
								+'<td align="center" width="10%" >'+Isnull(@Region, ' ')+'</td>
								<td align="center" width="5%" >'+Isnull(@Title_Language, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@Subtitling, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@Dubbing, ' ')+'</td>
								<td align="center" width="5%" >'+ CASE WHEN ISNULL(@Exists_In,'N')='N' THEN 'Rights' ELSE @Exists_In END+'</td>
								</tr>'
					FETCH NEXT FROM CurMail Into @Title_Name, @Platform ,@Agreement_No,@CAgreement_No, @PeriodFrom, @PeriodTo, @Region,
					 @Title_Language, @Subtitling, @Dubbing, @Exists_In, @Vendor_Name
				END
		
				CLOSE CurMail;
				DEALLOCATE CurMail;
				SET @EmailBody = ISNULL(@EmailBody,'')+ISNULL(@EmailBody1,'')+ISNULL(@EmailBody2,'')
				--+'<tr><td colspan=10 style="border-bottom-color: white;"></td></tr>'
				SET @EmailHeader= '<html>
					<head>	<style>table {border-collapse: collapse;width: 100%;border-color:black}th, td {text-align: left;padding: 2px;border-color:black; Font-Size:12; font-family: verdana;}
					 th {background-color: #c7c6c6;color: black;border-color:black}</style></head>
					<body>
						<Font FACE="verdana" SIZE="1" COLOR="Black">Hello User,<br /><br />
						Mentioned below is a list of conflicting details found in syndications deal rights. Request you to kindly review.<br /><br />
						</Font>'

				SET @EmailFooter = '&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="1" COLOR="Black">
									Kindly login <a href="'+@DefaultSiteUrl+'">here</a> to know more.</b></br></br></font>
									<FONT FACE="verdana" SIZE="1" COLOR="Black">
									If you have any questions or need further clarifications, please feel free to reach the support team at
									<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
									</br></br></font><FONT FACE="verdana" SIZE="1" COLOR="Black">
									Regards,</font></br>
									<FONT FACE="verdana" SIZE="1" COLOR="Black">
									RightsU System</br></font></body></html>'
	
			FETCH NEXT FROM CurMail1 Into @ErrorMsg
		END
		CLOSE CurMail1;
		DEALLOCATE CurMail1;
		DECLARE @EmailDetails NVARCHAR(max)
		if(@EmailBody!='')
		SET @EmailBody=@EmailBody +'</table>'
		SET @EmailDetails = @EmailHeader + @EmailBody  + @EmailFooter
		
		IF(@EmailDetails!='')
		BEGIN
				EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmailProfile,
				@recipients =  @To_User_Mail_Id,
				@copy_recipients = @CC_User_Mail_Id,
				@blind_copy_recipients = @BCC_User_Mail_Id,
				@subject = @MailSubject,
				@body = @EmailDetails,
				@body_format = 'HTML';

				INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@EmailBody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'Syndication Rights Validation'

		END
			--Change
		SEt @EmailDetails='' 	
		SET @EmailBody=''
		SET @EmailFooter=''
		SET @EmailHeader=''
		SET @EmailBody1=''
		SET @EmailBody2=''

		FETCH NEXT FROM CurMail2 INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes

	END	
	CLOSE CurMail2;
	DEALLOCATE CurMail2;

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT
END
GO
PRINT N'Altering [dbo].[USPDealExpiryMailForTitleMilestone]...';


GO
ALTER PROCEDURE USPDealExpiryMailForTitleMilestone 
AS
BEGIN
-----------------------------------
--Author: Aditya bandivadekar
--Description: Title Milestone Expiry mails would trigger 
--Date Created: 16-AUG-2018
---------------------------------------------
SET NOCOUNT ON;

DECLARE 
@Users_Email_Id VARCHAR(1000),
@Email_Config_Code INT,
@Is_Abandoned VARCHAR(5)
SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = 'TME'
--SELECT @Users_Email_Id = 'jatin@uto.in'

	IF(OBJECT_ID('TEMPDB..#tempExpired') IS NOT NULL)
		DROP TABLE #tempExpired

	IF(OBJECT_ID('TEMPDB..#tempEmail') IS NOT NULL)
		DROP TABLE #tempEmail

	IF(OBJECT_ID('TEMPDB..#TempIsab') IS NOT NULL)
		DROP TABLE #TempIsab

	DECLARE @MailSubjectCr AS NVARCHAR(MAX),
			@DatabaseEmail_Profile varchar(MAX),
			@EmailUser_Body NVARCHAR(Max), 
			@Emailbody NVARCHAR(MAX)= '',
			@EmailHead NVARCHAR(max),
			@EMailFooter NVARCHAR(max),
			@TitleMilestoneCodeExpired INT, 
			@TitleCode INT,
			@TitleNameExpired NVARCHAR(MAX),
			@TalentNameExpired NVARCHAR(MAX),
			@MilestoneNatureExpired NVARCHAR(MAX),
			@ExpiryDateExpired NVARCHAR(500),
			@MilestoneExpired NVARCHAR(MAX),
			@ActionItemExpired NVARCHAR(MAX)

			SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_User_Master'
			
			SET @MailSubjectCr='Notification of all important milestones/ dates for VMP projects under development';

		------------------------------ 
			set @EmailHead= 
			'<html><head><style>
					table{width:90%; border:1px solid black;border-collapse:collapse;}
					th{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;}
					td{border:1px solid black; vertical-align:top;font-family:verdana;font-size:12px; padding:5px;}
					td.center{text-align:center;}
			</style></head><body>
					<p>Dear User,</p>
					<p>Kindly take note of the important milestones/ dates and corresponding action items for the business teams, pursuant to agreements executed by Viacom 18 Motion Pictures,
					for various projects that are currently under development.</p>
					<p>If you require any furthur information or clarifications regarding any of the below deals, or the milestones/ action item listed below, please feel free to get in touch with the legal team.</p>
					'
		
		CREATE TABLE #tempExpired (
			Title_Milestone_Code		INT,
			Title_Code INT,
			TitleNameExpired			NVARCHAR(MAX),
			TalentNameExpired			NVARCHAR(MAX),
			MilestonenatureNameExpired	NVARCHAR(MAX),
			ExpiryDateExpired			NVARCHAR(MAX),
			MilestoneExpired			NVARCHAR(MAX),
			ActionItemExpired			NVARCHAR(MAX)
		)

		CREATE TABLE #tempEmail (
			UserCode NVARCHAR(MAX),
			CC_Users NVARCHAR(MAX),
			BCC_Users NVARCHAR(MAX)
		)
		---------------
		DECLARE @Business_Unit_Code INT,
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX),
	@Channel_Codes NVARCHAR(MAX)
	
	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)
	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'TME', 'N'

		-----------------

		
			DECLARE @i INT = 1 , @TableHeader NVARCHAR(MAX) = '', @index INT = 1

			WHILE @i <= 2
			BEGIN
				
				DECLARE @EndRange NVARCHAR(MAX), @Count VARCHAR(20) ='', @GenTD VARCHAR(10)= '',  @val nvarchar(max) = '' 
				SET @EndRange =(SELECT CONVERT(VARCHAR(25),DateAdd(DAY, (45), Convert(date, GetDate())),106))
				
				DELETE FROM #tempExpired 

				IF	@i = 1
				BEGIN
					SET @TableHeader = 'MILESTONES/ DATES THAT ARE EXPIRING IN THE NEXT 45 DAYS'

					INSERT INTO #tempExpired (Title_Milestone_Code,Title_Code,TitleNameExpired,TalentNameExpired,MilestonenatureNameExpired,ExpiryDateExpired,MilestoneExpired,ActionItemExpired)
					SELECT TM.Title_Milestone_Code,T.Title_Code ,T.Title_Name ,TL.Talent_Name ,MN.Milestone_Nature_Name,CONVERT(VARCHAR(100),TM.Expiry_Date,106) ,TM.Milestone , TM.Action_Item 
					FROM Title_Milestone TM
						INNER JOIN Title T ON T.Title_Code = Tm.Title_Code
						INNER JOIN Talent TL ON TL.Talent_Code = TM.Talent_Code
						INNER JOIN Milestone_Nature MN ON MN.Milestone_Nature_Code = TM.Milestone_Nature_Code
					WHERE CONVERT(DATE,TM.Expiry_Date,106) BETWEEN CONVERT(DATE,GETDATE(),106) AND @EndRange AND TM.Is_Abandoned = 'N' --AND TM.Title_Code = @Title_code
				END
				ELSE IF @i = 2
				BEGIN
					SET @TableHeader = 'MILESTONES/ DATES THAT HAVE EXPIRED'
					INSERT INTO #tempExpired (Title_Milestone_Code,Title_Code,TitleNameExpired,TalentNameExpired,MilestonenatureNameExpired,ExpiryDateExpired,MilestoneExpired,ActionItemExpired)
					SELECT TM.Title_Milestone_Code ,T.Title_Code,T.Title_Name ,TL.Talent_Name ,MN.Milestone_Nature_Name,CONVERT(VARCHAR(100),TM.Expiry_Date,106) ,TM.Milestone , TM.Action_Item 
					FROM Title_Milestone TM
						INNER JOIN Title T ON T.Title_Code = Tm.Title_Code
						INNER JOIN Talent TL ON TL.Talent_Code = TM.Talent_Code
						INNER JOIN Milestone_Nature MN ON MN.Milestone_Nature_Code = TM.Milestone_Nature_Code
					WHERE CONVERT(DATE,GETDATE(),106) > CONVERT(DATE,TM.Expiry_Date,106) AND Tm.Is_Abandoned = 'N'--AND TM.Title_Code = @Title_code
				END
						
				 SET @Count = (Select Count(*) From #tempExpired)		
				 IF @Count > 0
				 BEGIN
							SET @val = ''
							SELECT @Emailbody = @Emailbody +
							'<p><b>'+ @TableHeader +'</b></p>
							<table>
								<tr>
									<th width="15%">Name of the project</th>
									<th width="17%">Name of the Counter Party</th>
									<th width="14%">Nature of Deal</th>
									<th width="14%">Expiry Date/ Important Milestone Date</th>
									<th width="20%">Key Events/ Milestones Assosiated with such Date</th>
									<th width="20%">Action Items for VMP in Relation to such Date/ Milestone</th>
								</tr>'

							DECLARE @TempTitleCode INT, @IsDup CHAR(1) = 'N'
							DECLARE Cur_On_ExpiryMail CURSOR  FOR 
							SELECT DISTINCT Title_Milestone_Code,Title_Code,TitleNameExpired,TalentNameExpired,MilestonenatureNameExpired,ExpiryDateExpired,MilestoneExpired,ActionItemExpired FROM #tempExpired ORDER BY Title_Code 
							OPEN Cur_On_ExpiryMail 

							FETCH NEXT FROM Cur_On_ExpiryMail INTO  @TitleMilestoneCodeExpired,@TitleCode, @TitleNameExpired, @TalentNameExpired, @MilestoneNatureExpired, @ExpiryDateExpired, @MilestoneExpired,@ActionItemExpired
							While @@Fetch_Status = 0 
							BEGIN	
							SET @Count = (Select Count(*) From #tempExpired WHERE Title_Code = @TitleCode)	
							IF(@index > 1)
							BEGIN
								IF (@TempTitleCode = @TitleCode)
									SET @IsDup = 'Y'
								ELSE
									SET @IsDup = 'N'
							END
							
								SET @TempTitleCode = @TitleCode

							--------------------------------------------
					
								SET @Emailbody = @Emailbody +
									'<tr>
											{{DYNAMIC}}
											<td>'+ CAST(ISNULL(@TalentNameExpired, '') AS NVARCHAR(MAX)) +' </td>
											<td>'+CAST(ISNULL(@MilestoneNatureExpired, '') AS nvarchar(MAX)) +' </td>
											<td class="center">'+ CONVERT(VARCHAR(25), @ExpiryDateExpired, 106)+' </td>
											<td>'+ CAST(ISNULL(@MilestoneExpired, '') AS nvarchar(MAX)) +' </td>
											<td>'+ CAST(ISNULL(@ActionItemExpired, '') AS nvarchar(MAX)) +' </td>
									</tr>
									'
			
								IF (@IsDup = 'N')
										SELECT @Emailbody = REPLACE(@Emailbody, '{{DYNAMIC}}', '<td rowspan = '+ @Count +'>'+ CAST(ISNULL(@TitleNameExpired, '') AS varchar(MAX)) +'</td>');
								ELSE
										SELECT @Emailbody = REPLACE(@Emailbody, '{{DYNAMIC}}','')

								
			
							SET @index += 1
							FETCH NEXT FROM Cur_On_ExpiryMail INTO @TitleMilestoneCodeExpired ,@TitleCode,@TitleNameExpired, @TalentNameExpired, @MilestoneNatureExpired, @ExpiryDateExpired, @MilestoneExpired,@ActionItemExpired
							END
							Close Cur_On_ExpiryMail
							Deallocate Cur_On_ExpiryMail
							SET @Emailbody =  @Emailbody+ '</table>'

				 END
				select  @i = @i + 1,  @index = 1, @IsDup = 'N', @TempTitleCode = NULL
			END
		
			SET @EMailFooter =
					'</br>
					(This is a system generated mail from RightsU. Please do not reply back to the same)</br>
					</p>
					</body></html>'

				SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
	
				DECLARE cPointer CURSOR FOR SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
				OPEN cPointer
				FETCH NEXT FROM cPointer INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
					WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC msdb.dbo.sp_send_dbmail 
						@profile_name = @DatabaseEmail_Profile,
						@recipients =  @To_User_Mail_Id,
						@copy_recipients = @CC_User_Mail_Id,
						@blind_copy_recipients = @BCC_User_Mail_Id,
						@subject = @MailSubjectCr,
						@body = @EmailUser_Body, 
						@body_format = 'HTML';

						INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
						SELECT @Email_Config_Code,@Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), @MailSubjectCr
				

					FETCH NEXT FROM cPointer INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
					END
				CLOSE cPointer
				DEALLOCATE cPointer
		
	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

	IF OBJECT_ID('tempdb..#tempEmail') IS NOT NULL DROP TABLE #tempEmail
	IF OBJECT_ID('tempdb..#tempExpired') IS NOT NULL DROP TABLE #tempExpired
	IF OBJECT_ID('tempdb..#TempIsab') IS NOT NULL DROP TABLE #TempIsab
			
		
END
GO
PRINT N'Creating [dbo].[USP_Deal_WF_Pending_Automated_Email]...';


GO
CREATE PROCEDURE USP_Deal_WF_Pending_Automated_Email
AS
----------------------------
--Author: Ayush Dubey
--Description: Deal Pending Automated Would Trigger
--Date Created: 21-MAR-2021
-----------------------------
BEGIN
	SET NOCOUNT ON

	DECLARE @Email_Config_Code INT = 0,  @MailSubject NVARCHAR(MAX) = 'Deals Pending for Approval - Level wise',  @LevelColumns NVARCHAR(MAX) = '', @LevelColumnsConcat NVARCHAR(MAX) = '',@LevelSynColumns NVARCHAR(MAX) = '', @LevelSynColumnsConcat NVARCHAR(MAX) = '',   @LevelColumnsIsNull NVARCHAR(MAX) = '',
	@TableBody NVARCHAR(MAX) = '',@TableBody2 NVARCHAR(MAX) = '', @MaxLevel INT = 0,@MaxSynLevel INT = 0, @Email_Template NVARCHAR(MAX) = '',  @LevelSynColumnsIsNull NVARCHAR(MAX) = '',
	@Users_Email_Id VARCHAR(MAX),@Business_Unit_Code INT,@Users_Code VARCHAR(MAX),@DatabaseEmailProfile varchar(200)	= '',@EmailUser_Body NVARCHAR(Max),@EmailUser_Body2 NVARCHAR(Max)
	
	DECLARE @Counter INT = 1 , @HeaderName NVARCHAR(MAX) = ''

	IF OBJECT_ID('tempdb..#Tmp_DealWorkFlow_Status_Pending') IS NOT NULL
		DROP TABLE #Tmp_DealWorkFlow_Status_Pending
	IF OBJECT_ID('tempdb..#Tmp_Pivot_Result') IS NOT NULL
		DROP TABLE #Tmp_Pivot_Result
	IF OBJECT_ID('tempdb..#TableHeader') IS NOT NULL
		DROP TABLE #TableHeader
	IF OBJECT_ID('tempdb..#tdValue') IS NOT NULL
		DROP TABLE #tdValue
	IF OBJECT_ID('tempdb..#TableSynHeader') IS NOT NULL
		DROP TABLE #TableSynHeader
	IF OBJECT_ID('tempdb..#UserData') IS NOT NULL
		DROP TABLE #UserData

	CREATE TABLE #Tmp_DealWorkFlow_Status_Pending(
		Content_Category VARCHAR(MAX),
		[Level] VARCHAR(MAX),
		Deal_Count INT
	)

	CREATE TABLE #tdValue(Result VARCHAR(MAX))

	CREATE TABLE #Tmp_Pivot_Result(
		Tmp_Pivot_Result_Code INT IDENTITY(1,1),
		Content_Category VARCHAR(MAX)
		,[Level 1] VARCHAR(MAX)
		,[Level 2] VARCHAR(MAX)
		,[Level 3] VARCHAR(MAX)
		,[Level 4] VARCHAR(MAX)
		,[Level 5] VARCHAR(MAX)
		,[Level 6] VARCHAR(MAX)
		,[Level 7] VARCHAR(MAX)
		,[Level 8] VARCHAR(MAX)
		,[Level 9] VARCHAR(MAX)
		,[Level 10] VARCHAR(MAX)
		,[Level 11] VARCHAR(MAX)
		,[Level 12] VARCHAR(MAX)
		,[Level 13] VARCHAR(MAX)
		,[Level 14] VARCHAR(MAX)
		,[Level 15] VARCHAR(MAX)
		,[Level 16] VARCHAR(MAX)
		,[Level 17] VARCHAR(MAX)
		,[Level 18] VARCHAR(MAX)
		,[Level 19] VARCHAR(MAX)
		,[Level 20] VARCHAR(MAX)
	)

	CREATE TABLE #UserData(
	User_Mail_Id VARCHAR(MAX),
	Business_Unit_Code VARCHAR(MAX),
	User_Code VARCHAR(MAX)
	)

	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='AMR'

	SELECT @DatabaseEmailProfile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

	DECLARE
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX),
	@Channel_Codes NVARCHAR(MAX)
	
	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)

	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'AMR', 'N'


	DECLARE curUserData CURSOR FOR  SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
	--Change
	OPEN curUserData
	FETCH NEXT FROM curUserData INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
	WHILE @@Fetch_Status = 0 
	BEGIN
		SELECT @Email_Template = Template_Desc FROM Email_Template WHERE Template_For = 'Acq_Syn_Deal_Pending'
		TRUNCATE TABLE #Tmp_DealWorkFlow_Status_Pending
		TRUNCATE TABLE #Tmp_Pivot_Result
		TRUNCATE TABLE #tdValue
		SELECT  @TableBody = '', @LevelColumns = '' , @LevelColumnsIsNull = '', @MaxLevel = '', @HeaderName = '', @Counter = 1

		IF OBJECT_ID('tempdb..#TableHeader') IS NOT NULL
			DROP TABLE #TableHeader
		IF OBJECT_ID('tempdb..#TableSynHeader') IS NOT NULL
			DROP TABLE #TableSynHeader
	

		INSERT INTO #Tmp_DealWorkFlow_Status_Pending																				
		EXEC [USP_DealWorkFlow_Status_Pending_Reports] 30,@Business_Unit_Code
	
		IF((SELECT COUNT(*) FROM #Tmp_DealWorkFlow_Status_Pending ) > 0)
		BEGIN
			SELECT @LevelColumns = STUFF(( SELECT DISTINCT ',[' + Level +']' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')	
			SELECT @LevelColumnsIsNull = STUFF(( SELECT DISTINCT ',ISNULL(CAST(A.[' + Level +'] AS VARCHAR),''NA'')' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')			

			EXEC (' INSERT INTO #Tmp_Pivot_Result ( Content_Category, '+@LevelColumns+')
			SELECT A.Content_Category, '+ @LevelColumnsIsNull +' FROM (
			SELECT Content_Category  , '+@LevelColumns+' FROM #Tmp_DealWorkFlow_Status_Pending AS Tbl PIVOT( SUM(Deal_Count) 
			FOR [Level] IN ('+@LevelColumns+')) AS Pvt ) AS A ') 

			SELECT id, REPLACE(REPLACE(number,'[',''),']','') as Header INTO #TableHeader from DBO.FN_Split_WithDelemiter('Content Category,' + @LevelColumns, ',')

			SELECT @MaxLevel = COUNT(*) FROM #TableHeader

			SELECT @TableBody += '<table  class="tblFormat" Border = 1px style="solid black; border-collapse: collapse">
							<tr> <td colspan="'+CAST(@MaxLevel AS VARCHAR)+'" style="padding: 8px 0px 3px 0px;font-weight:bold;background-color:#000080;color:white;"> Acquisition Deals </td> </tr> 
							<tr>'

			WHILE ( @Counter <= @MaxLevel)
			BEGIN
			   SELECT @HeaderName = Header from #TableHeader where id = @Counter
			   SELECT @TableBody += '<th align="center" width="7%"> '+@HeaderName+'</th>'
			   SET @Counter  = @Counter  + 1
			END

			SELECT  @TableBody += '</tr>', @Counter = 1

			WHILE ( @Counter <= (SELECT COUNT(*) FROM #Tmp_Pivot_Result))
			BEGIN
				SELECT @LevelColumnsConcat = ''
				DELETE FROM #tdValue

				SELECT @LevelColumnsConcat = '''<td width="7%">'' + Content_Category + ''</td>''+' + STUFF(( SELECT DISTINCT '+ ''<td align="center" width="7%">'' + [' + Level +'] + ''</td>'' ' FROM #Tmp_DealWorkFlow_Status_Pending  FOR XML PATH (''), TYPE).value('.', 'nvarchar(max)'), 1, 1, '')

				INSERT INTO #tdValue(result)
				EXEC('select '+ @LevelColumnsConcat +' from #Tmp_Pivot_Result where  Tmp_Pivot_Result_Code  = ' +@Counter )
		
				SELECT TOP 1  @TableBody = @TableBody + '<tr>' + Result + '</tr>' FROM #tdValue
				SET @Counter  = @Counter  + 1
			END

			SELECT @TableBody += '</table>'
		END
		ELSE
		BEGIN
				SELECT @TableBody += '<table  class="tblFormat" Border = 1px style="solid black; border-collapse: collapse">
							<tr> <td colspan="4" style="padding: 8px 0px 3px 0px;font-weight:bold;background-color:#000080;color:white;"> Acquisition Deals </td> </tr>
							<tr> <td colspan="4"> No Records Found </td> </tr>
							</table>'
		END

		SET @Email_Template = REPLACE(@Email_Template , '{acqtable}',@TableBody)
		
		--------------Clearing Variable and temp table for Reuse

		TRUNCATE TABLE #Tmp_DealWorkFlow_Status_Pending
		TRUNCATE TABLE #Tmp_Pivot_Result
		TRUNCATE TABLE #tdValue

		SELECT  @TableBody = '', @LevelColumns = '' , @LevelColumnsIsNull = '', @MaxLevel = '', @HeaderName = '', @Counter = 1

		INSERT INTO #Tmp_DealWorkFlow_Status_Pending														
		EXEC [USP_DealWorkFlow_Status_Pending_Reports] 35,@Business_Unit_Code

		IF((SELECT COUNT(*) FROM #Tmp_DealWorkFlow_Status_Pending ) > 0)
		BEGIN
			SELECT @LevelColumns = STUFF(( SELECT DISTINCT ',[' + Level +']' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')	
			SELECT @LevelColumnsIsNull = STUFF(( SELECT DISTINCT ',ISNULL(CAST(A.[' + Level +'] AS VARCHAR),''NA'')' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')	

			EXEC (' INSERT INTO #Tmp_Pivot_Result ( Content_Category, '+@LevelColumns+')
			SELECT A.Content_Category, '+ @LevelColumnsIsNull +' FROM (
			SELECT Content_Category  as ''Content_Category'' , '+@LevelColumns+' FROM #Tmp_DealWorkFlow_Status_Pending AS Tbl PIVOT( SUM(Deal_Count) 
			FOR [Level] IN ('+@LevelColumns+')) AS Pvt ) AS A ') 
	
			SELECT id, REPLACE(REPLACE(number,'[',''),']','') as Header INTO #TableSynHeader from DBO.FN_Split_WithDelemiter('Content Category,' + @LevelColumns, ',')

			SELECT @MaxLevel = COUNT(*) FROM #TableSynHeader
	
			SELECT @TableBody += '<table  class="tblFormat" Border = 1px style="solid black; border-collapse: collapse">
							<tr> <td colspan="'+CAST(@MaxLevel AS VARCHAR)+'" style="padding: 8px 0px 3px 0px;font-weight:bold;background-color:red;color:white;"> Syndication Deals </td> </tr> 
							<tr>'

			WHILE ( @Counter <= @MaxLevel)
			BEGIN
			   SELECT @HeaderName = Header FROM #TableSynHeader WHERE id = @Counter
			   SELECT @TableBody += '<th align="center" width="7%"> '+@HeaderName+'</th>'
			   SET @Counter  = @Counter  + 1
			END
			
			SELECT  @TableBody += '</tr>', @Counter = 1

			WHILE ( @Counter <= (SELECT COUNT(*) FROM #Tmp_Pivot_Result))
			BEGIN
				SELECT @LevelColumnsConcat = ''
				DELETE FROM #tdValue

				SELECT @LevelColumnsConcat = '''<td width="7%">'' + Content_Category + ''</td>''+' + STUFF(( SELECT DISTINCT '+ ''<td align="center" width="7%">'' + [' + Level +'] + ''</td>'' ' FROM #Tmp_DealWorkFlow_Status_Pending  FOR XML PATH (''), TYPE).value('.', 'nvarchar(max)'), 1, 1, '')
	
				INSERT INTO #tdValue(result)
				EXEC('select '+ @LevelColumnsConcat +' from #Tmp_Pivot_Result where Tmp_Pivot_Result_Code  = ' +@Counter )

				SELECT TOP 1  @TableBody = @TableBody + '<tr>' + Result + '</tr>' FROM #tdValue
				SET @Counter  = @Counter  + 1
			END

			SELECT @TableBody += '</table>'
		END
		ELSE
		BEGIN
			SELECT @TableBody += '<table  class="tblFormat" Border = 1px style="solid black; border-collapse: collapse">
						<tr> <td colspan="4" style="padding: 8px 0px 3px 0px;font-weight:bold;background-color:red;color:white;"> Syndication Deals </td> </tr>
						<tr> <td colspan="4"> No Records Found </td> </tr>
						</table>'
		END

		SET @Email_Template = REPLACE(@Email_Template , '{syntable}',@TableBody)

		EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmailProfile,
				@recipients =  @To_User_Mail_Id,
				@copy_recipients = @CC_User_Mail_Id,
				@blind_copy_recipients = @BCC_User_Mail_Id,
				@subject = @MailSubject,
				@body = @Email_Template, 
				@body_format = 'HTML';

				
		INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
		SELECT @Email_Config_Code,@TableBody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'Automated Mail Pending'

		FETCH NEXT FROM curUserData INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
	END 
	CLOSE curUserData
	DEALLOCATE curUserData		

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

END
GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Expiry_Email_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Expiry_Email_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Multi_Music_Schedule_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Multi_Music_Schedule_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Schedule_Exception_AutoResolver]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Schedule_Exception_AutoResolver]';


GO
PRINT N'Refreshing [dbo].[USP_Schedule_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Schedule_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Schedule_Revert_Count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Schedule_Revert_Count]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_RUN_SAVE_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_RUN_SAVE_Process]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Validate_Temp_BV_Sche]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Validate_Temp_BV_Sche]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Mapped_titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Mapped_titles]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_ReProcess]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_ReProcess]';


GO
PRINT N'Refreshing [dbo].[USP_INSERT_SAP_WBS_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_INSERT_SAP_WBS_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Notification]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Notification]';


GO
PRINT N'Update complete.';


GO
