CREATE PROCEDURE USP_Deal_WF_Pending_Automated_Email
AS
------------------------------
--Author: Ayush Dubey
--Description: Deal Pending Automated Would Trigger
--Date Created: 21-MAR-2021
-----------------------------
BEGIN
	SET NOCOUNT ON

	DECLARE @Email_Config_Code INT = 0,  @MailSubject NVARCHAR(MAX) = 'Deals Pending for Approval - Level wise',  @LevelColumns NVARCHAR(MAX) = '', @LevelColumnsConcat NVARCHAR(MAX) = '',@LevelSynColumns NVARCHAR(MAX) = '', @LevelSynColumnsConcat NVARCHAR(MAX) = '',   @LevelColumnsIsNull NVARCHAR(MAX) = '',
	@TableBody NVARCHAR(MAX) = '',@TableBody2 NVARCHAR(MAX) = '', @MaxLevel INT = 0,@MaxSynLevel INT = 0, @Email_Template NVARCHAR(MAX) = '',  @LevelSynColumnsIsNull NVARCHAR(MAX) = '',
	@Users_Email_Id VARCHAR(MAX),@Business_Unit_Code VARCHAR(MAX),@Users_Code VARCHAR(MAX),@DatabaseEmailProfile varchar(200)	= '',@EmailUser_Body NVARCHAR(Max),@EmailUser_Body2 NVARCHAR(Max)
	
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

	INSERT INTO #UserData(User_Mail_Id,Business_Unit_Code,User_Code)
	SELECT DISTINCT CAST(User_Mail_Id AS NVARCHAR)
		,STUFF((
				SELECT DISTINCT ',' + CAST(t1.BuCode AS VARCHAR)
				FROM [dbo].[UFN_Get_Bu_Wise_User]('AMR') T1 WHERE t1.Users_Code = t2.Users_Code GROUP BY Users_Code,BUCode
				FOR XML PATH('')
				), 1, 1, '') AS BUCode
	,Users_Code
	FROM [dbo].[UFN_Get_Bu_Wise_User]('AMR') T2

	INSERT INTO #UserData(User_Mail_Id,Business_Unit_Code,User_Code)
	SELECT DISTINCT TOUser_MailID,STUFF((
				SELECT DISTINCT ',' + CAST(Business_Unit_Code AS VARCHAR)
				FROM Business_Unit T1
				FOR XML PATH('')
				), 1, 1, '') AS BUCode,User_Codes FROM
	EMAIL_CONFIG_DETAIL_USER ECDU 
	INNER JOIN EMAIL_CONFIG_DETAIL ECD ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	INNER JOIN Email_Config EC ON ECD.Email_Config_Code = EC.Email_Config_Code
	WHERE EC.[Key] = 'AMR' AND User_Type = 'E'

	DECLARE curUserData CURSOR FOR  SELECT DISTINCT User_Mail_Id,Business_Unit_Code,User_Code
	FROM #UserData
	OPEN curUserData
	FETCH NEXT FROM curUserData INTO @Users_Email_id, @Business_Unit_Code, @Users_Code
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
		 
		EXEC msdb.dbo.Sp_send_dbmail 
		@profile_name = @DatabaseEmailProfile, 
		@recipients = @Users_Email_id, 
		@subject = @MailSubject, 
		@body = @Email_Template, 
		@body_format = 'HTML'; 

		INSERT INTO Email_Notification_Log(email_config_code,created_time,is_read, email_body,user_code,[subject],email_id) 
		SELECT @Email_Config_Code,Getdate(),'N',@TableBody,@Users_Code, 'Automated Mail Pending',@Users_Email_id 

		FETCH NEXT FROM curUserData Into @Users_Email_Id,@Business_Unit_Code,@Users_Code
	END 
	CLOSE curUserData
	DEALLOCATE curUserData		

END				