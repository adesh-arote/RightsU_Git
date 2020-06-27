CREATE PROCEDURE [USP_RightsU_Health_Checkup]
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

