--create PROCEDURE [dbo].[USP_List_Status_History]	
--	@Record_Code INT, 
--	@Module_Code INT
--AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 11-NOV-2014
-- Description: Get List of Deal(Acq. And Syn.) Or WorkFlow Status History
-- Last Updated by: Aditya A. Bandivadekar
-- Last Change :  Added Version column in output. 
-- =============================================

BEGIN	
	DECLARE 
	@Record_Code INT = 15432,
	@Module_Code INT = 30
	SET FMTONLY OFF
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#Temp_Module_Status_History') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Module_Status_History
	END	

	IF EXISTS (SELECT Module_Status_Code FROM Module_Status_History WHERE Record_Code = @Record_Code AND Module_Code = @Module_Code)
	BEGIN
		SELECT 
		ROW_NUMBER() OVER( ORDER BY MSH.Module_Status_Code ) AS 'MSH_Code',
		MSH.Module_Status_Code as ID,
		CAST( '' AS NVARCHAR(MAX)) AS [Version],
		--MSH.Status,
		CASE  
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'C' THEN 'Created'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'W' THEN 'Sent for authorization'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'A' THEN 'Approved'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'R' THEN 'Rejected'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'E' THEN 'Updated'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'AM' THEN 'Amended'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'RO' THEN 'Re-Open'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'EO' THEN 'Edit Without Approval'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'AP' THEN 'Auto Pushed'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'AR' THEN 'Archived'
				WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'WA' THEN 'Waiting (Archive)'
				ELSE '' 
		END AS [Status],
		MSH.status_changed_on as [Date],U.login_name + ' ('+Security_Group_Name +')' AS [By]  ,CASE WHEN MSH.Status IN('AM','E','C') THEN '' ELSE MSH.remarks  END AS [Remarks]
		INTO #Temp_Module_Status_History
		FROM Module_Status_History  MSH
		INNER JOIN Users U ON MSH.status_changed_by = U.users_code
		INNER JOIN Security_Group SG ON U.Security_Group_Code=SG.Security_Group_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code =MSH.Record_Code
		WHERE record_code = @Record_Code AND module_code = @Module_Code
		--ORDER BY [Date] DESC

		DECLARE @MSH_Code INT,  @Status VARCHAR(MAX), 	@Version_No INT = 1

		DECLARE db_cursor CURSOR FOR 
		SELECT MSH_Code , [Status]
		FROM #Temp_Module_Status_History
	
		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @MSH_Code  ,@Status

		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			 IF (@Status = 'Amended')
			 BEGIN
			 	SET @Version_No = @Version_No + 1
			 END

			 UPDATE TMSH SET [Version] =CAST( @Version_No AS NVARCHAR(MAX)) FROM #Temp_Module_Status_History TMSH WHERE MSH_Code = @MSH_Code
			 FETCH NEXT FROM db_cursor INTO @MSH_Code , @Status
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 

		SELECT ID, [Version], [Status], [Date], [By], [Remarks] from #Temp_Module_Status_History ORDER BY [Date] DESC

	END
	ELSE 
	BEGIN
		DECLARE @dynamicQuery NVARCHAR(MAX) = ''
		
		IF(@Module_Code = 30)  
		BEGIN
			PRINT 'Acquisition Deal Module'
			SET @dynamicQuery += 'SELECT U.Users_Code AS ID,AD.Version,''Created'' AS [Status],
						AD.Inserted_On AS [Date],U.Login_Name + '' (''+Security_Group_Name+ '')'' AS [By]  ,
						'''' AS [Remarks]
						FROM Acq_Deal AD
						INNER JOIN Users U ON AD.Inserted_By = U.Users_Code
						INNER JOIN Security_Group SG ON U.Security_Group_Code=SG.Security_Group_Code where Acq_Deal_Code = '+ CAST(@Record_Code AS VARCHAR)	
						+' ORDER by AD.Inserted_On'
		END
		ELSE IF(@Module_Code = 35)  
		BEGIN
			PRINT 'Syndication Deal Module'
			SET @dynamicQuery += ' SELECT U.Users_Code as ID,AD.Version,''Created'' AS [Status],
						AD.Inserted_On AS [Date],U.Login_Name + '' ('' + Security_Group_Name + '')'' AS [By]  ,
						'''' AS [Remarks]
						FROM Syn_Deal AD
						INNER JOIN Users U ON AD.Inserted_By = U.Users_Code
						INNER JOIN Security_Group SG ON U.Security_Group_Code=SG.Security_Group_Code  where Syn_Deal_Code = '+ CAST( @Record_Code AS VARCHAR)
						+' ORDER by AD.Inserted_On desc'
		END
		ELSE IF(@Module_Code = 154)  
		BEGIN
			PRINT 'Music Exception Handling Module'
			SET @dynamicQuery += 'SELECT U.users_code as ID,''Open'' AS [Status],
						MSH.Status_Changed_On as [Date],U.login_name + '' (''+Security_Group_Name+ '')'' AS [By]  ,
						MSH.Remarks AS [Remarks]
						FROM Module_Status_History  MSH
						INNER JOIN Users U ON MSH.status_changed_by = U.users_code
						INNER JOIN Security_Group SG ON U.Security_Group_Code=SG.Security_Group_Code WHERE MSH.Record_Code = '+ CAST(@Record_Code AS VARCHAR)	
						+' AND MSH.Module_Code='+CAST(@Module_Code AS VARCHAR)+' ORDER BY [Date] DESC'
		END
		ELSE IF(@Module_Code = 163)  
		BEGIN
			PRINT 'Music Deal Module'
			SET @dynamicQuery += ' SELECT U.Users_Code as ID,MD.Version, ''Created'' AS [Status],
						MD.Inserted_On AS [Date], U.Login_Name + '' ('' + Security_Group_Name + '')'' AS [By]  ,
						'''' AS [Remarks]
						FROM Music_Deal MD
						INNER JOIN Users U ON MD.Inserted_By = U.Users_Code
						INNER JOIN Security_Group SG ON U.Security_Group_Code=SG.Security_Group_Code  where MD.Music_Deal_Code = '+ CAST( @Record_Code AS VARCHAR)
						+' ORDER by MD.Inserted_On DESC'
		END
		EXEC (@dynamicQuery)
		--SELECT 0 AS ID,'' AS [Version],'' AS [Status],GETDATE() AS [Date],'' AS [By], '' AS [Remarks] 
	END
END




--Select * from Module_Status_History order by 1 desc Where Record_Code = 15406

--Select * from Acq_Deal Where Agreement_No = 'A-2019-00037'
--Select * from Acq_Deal Where Agreement_No = 'A-2019-00053'

--EXEC USP_Deal_Process