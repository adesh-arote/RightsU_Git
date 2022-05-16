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

		--EXEC msdb.dbo.sp_send_dbmail 
		--		@profile_name = @DatabaseEmailProfile,
		--		@recipients =  @To_User_Mail_Id,
		--		@copy_recipients = @CC_User_Mail_Id,
		--		@blind_copy_recipients = @BCC_User_Mail_Id,
		--		@subject = @MailSubject,
		--		@body = @Email_Template, 
		--		@body_format = 'HTML';

				
		INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
		SELECT @Email_Config_Code,@Email_Template, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  @MailSubject

		FETCH NEXT FROM curUserData INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
	END 
	CLOSE curUserData
	DEALLOCATE curUserData		

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

END				