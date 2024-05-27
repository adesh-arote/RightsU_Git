ALTER PROCEDURE [dbo].[USP_Deal_WF_Pending_Automated_Email]
AS
----------------------------
--Author: Jaydeep Parmar
--Description: Deal Pending Automated Would Trigger
--Date Created: 22-MAY-2024
-----------------------------
BEGIN
SET NOCOUNT ON;

	DECLARE @Email_Config_Code INT, @Notification_Subject VARCHAR(2000) = '', @Notification_Body VARCHAR(MAX) = '', @Event_Platform_Code INT = 0, @Event_Template_Type CHAR(1) = '', @Alert_Type CHAR(4)

	SET @Alert_Type = 'AMR'

	DECLARE curNotificationPlatforms CURSOR FOR 
			SELECT ec.Email_Config_Code, et.[Subject], et.Template, ect.Event_Platform_Code, ect.Event_Template_Type FROM Email_Config ec
			INNER JOIN Email_Config_Template ect ON ec.Email_Config_Code = ect.Email_Config_Code
			INNER JOIN Event_Template et ON ect.Event_Template_Code = et.Event_Template_Code
			WHERE ec.[Key] = @Alert_Type
	OPEN curNotificationPlatforms
	FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE @MailSubject NVARCHAR(MAX) = 'Deals Pending For Approval - Level Wise',  @LevelColumns NVARCHAR(MAX) = '', @LevelColumnsConcat NVARCHAR(MAX) = '',@LevelSynColumns NVARCHAR(MAX) = '', @LevelSynColumnsConcat NVARCHAR(MAX) = '',   @LevelColumnsIsNull NVARCHAR(MAX) = '',
		@TableBody NVARCHAR(MAX) = '',@TableBody2 NVARCHAR(MAX) = '', @MaxLevel INT = 0,@MaxSynLevel INT = 0, @Email_Template NVARCHAR(MAX) = '',  @LevelSynColumnsIsNull NVARCHAR(MAX) = '',
		@Users_Email_Id NVARCHAR(max),@Business_Unit_Code VARCHAR(MAX),@Users_Code VARCHAR(MAX),@DatabaseEmailProfile varchar(200)	= '',@EmailUser_Body NVARCHAR(Max),@EmailUser_Body2 NVARCHAR(Max)

		IF OBJECT_ID('tempdb..#Tmp_DealWorkFlow_Status_Pending') IS NOT NULL DROP TABLE #Tmp_DealWorkFlow_Status_Pending
		IF OBJECT_ID('tempdb..#Tmp_Pivot_Result') IS NOT NULL DROP TABLE #Tmp_Pivot_Result
		IF OBJECT_ID('tempdb..#TableHeader') IS NOT NULL DROP TABLE #TableHeader
		IF OBJECT_ID('tempdb..#tdValue') IS NOT NULL DROP TABLE #tdValue
		IF OBJECT_ID('tempdb..#TableSynHeader') IS NOT NULL DROP TABLE #TableSynHeader
		IF OBJECT_ID('tempdb..#UserData') IS NOT NULL DROP TABLE #UserData

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
	
		--SELECT @Email_Template = Template_Desc FROM Email_Template WHERE Template_For = 'Acq_Syn_Deal_Pending'

		--SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='AMR'
	
		DECLARE @Tbl2 TABLE (
			--BuCode INT,
			--To_Users_Code NVARCHAR(MAX),
			--To_User_Mail_Id  NVARCHAR(MAX),
			--User_Type CHAR(2)
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
	
		INSERT INTO @Tbl2(Id,BuCode,To_Users_Code ,To_User_Mail_Id, CC_Users_Code,CC_User_Mail_Id,BCC_Users_Code,BCC_User_Mail_Id,Channel_Codes)
		EXEC USP_Get_EmailConfig_Users @Alert_Type,@Event_Platform_Code, @Event_Template_Type, 'N'
	

		DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

		DELETE FROM @Tbl2 WHERE To_Users_Code IS NULL 

		DECLARE @To_Users_Email_id NVARCHAR(MAX), @CC_Users_Email_id NVARCHAR(MAX), @BCC_Users_Email_id NVARCHAR(MAX),
				@To_Users_Code NVARCHAR(MAX), @CC_Users_Code NVARCHAR(MAX), @BCC_Users_Code NVARCHAR(MAX)

		SELECT @Business_Unit_Code = STUFF((
			SELECT DISTINCT ',' + CAST( Business_Unit_Code AS NVARCHAR(MAX))
			FROM Users_Business_Unit WHERE Users_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter((SELECT distinct To_Users_Code FROM @Tbl2),','))
		FOR XML PATH('')), 1, 1, '')

		PRINT @Business_Unit_Code
			
		SELECT
			 @To_Users_Email_id = STUFF((
				SELECT DISTINCT ';' + CAST( B.To_User_Mail_Id AS NVARCHAR(MAX))
				FROM @Tbl2 B-- WHERE B.User_Type  = 'TO' 
			FOR XML PATH('')), 1, 1, ''),	
			@CC_Users_Email_id = STUFF((
				SELECT DISTINCT ';' + CAST( B.CC_User_Mail_Id AS NVARCHAR(MAX))
				FROM @Tbl2 B --WHERE  B.User_Type  = 'CC' 
			FOR XML PATH('')), 1, 1, ''),
			@BCC_Users_Email_id= STUFF((
				SELECT DISTINCT ';' + CAST( B.BCC_User_Mail_Id AS NVARCHAR(MAX))
				FROM @Tbl2 B --WHERE  B.User_Type  = 'BC' 
			FOR XML PATH('')), 1, 1, '')
			
			PRINT @To_Users_Email_id

		SELECT
			 @To_Users_Code = STUFF((
				SELECT DISTINCT ';' + CAST( B.To_Users_Code AS NVARCHAR(MAX))
				FROM @Tbl2 B --WHERE B.User_Type  = 'TO' 
			FOR XML PATH('')), 1, 1, ''),
			@CC_Users_Code = STUFF((
				SELECT DISTINCT ';' + CAST( B.CC_Users_Code AS NVARCHAR(MAX))
				FROM @Tbl2 B --WHERE  B.User_Type  = 'CC' 
			FOR XML PATH('')), 1, 1, ''),
			@BCC_Users_Code = STUFF((
				SELECT DISTINCT ';' + CAST( B.BCC_User_Mail_Id AS NVARCHAR(MAX))
				FROM @Tbl2 B --WHERE  B.User_Type  = 'BC' 
			FOR XML PATH('')), 1, 1, '')

			
		SELECT @DatabaseEmailProfile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
	
		INSERT INTO #Tmp_DealWorkFlow_Status_Pending																				
		EXEC [USP_DealWorkFlow_Status_Pending_Reports] 30,@Business_Unit_Code
	
	
		SELECT @LevelColumns = STUFF(( SELECT DISTINCT ',[' + Level +']' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')		
		SELECT @LevelColumnsIsNull = STUFF(( SELECT DISTINCT ',ISNULL(CAST(A.[' + Level +'] AS VARCHAR),''NA'')' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')			

		EXEC (' INSERT INTO #Tmp_Pivot_Result ( Content_Category, '+@LevelColumns+')
		SELECT A.Content_Category, '+ @LevelColumnsIsNull +' FROM (
		SELECT Content_Category  , '+@LevelColumns+' FROM #Tmp_DealWorkFlow_Status_Pending AS Tbl PIVOT( SUM(Deal_Count) 
		FOR [Level] IN ('+@LevelColumns+')) AS Pvt ) AS A ') 

		--SELECT id, REPLACE(REPLACE(number,'[',''),']','') as Header INTO #TableHeader from DBO.FN_Split_WithDelemiter('Content Category,' + @LevelColumns, ',')

		--SELECT @MaxLevel = COUNT(*) FROM #TableHeader

		--SELECT @TableBody += '<table  class="tblFormat" Border = 1px style="solid black; border-collapse: collapse">
		--				<tr> <td colspan="'+CAST(@MaxLevel AS VARCHAR)+'" style="padding: 8px 0px 3px 0px;font-weight:bold;background-color:#000080;color:white;"> Acquisition Deals </td> </tr> 
		--				<tr>'
	
		DECLARE @Counter INT = 1 , @HeaderName NVARCHAR(MAX) = ''

		--WHILE ( @Counter <= @MaxLevel)
		--BEGIN
		--   SELECT @HeaderName = Header from #TableHeader where id = @Counter
		--   SELECT @TableBody += '<th align="center" width="7%"> '+@HeaderName+'</th>'
		--   SET @Counter  = @Counter  + 1
		--END

		--SELECT  @TableBody += '</tr>', @Counter = 1

		--DECLARE @Counter INT = 1
				
		DECLARE @Content_Category VARCHAR(MAX),@Level_1 VARCHAR(MAX),@Level_2 VARCHAR(MAX),@Level_3 VARCHAR(MAX),@Level_4 VARCHAR(MAX),@Level_5 VARCHAR(MAX),
		@Level_6 VARCHAR(MAX),@Level_7 VARCHAR(MAX),@Level_8 VARCHAR(MAX),@Level_9 VARCHAR(MAX),@Level_10 VARCHAR(MAX),@Level_11 VARCHAR(MAX),@Level_12 VARCHAR(MAX),
		@Level_13 VARCHAR(MAX),@Level_14 VARCHAR(MAX),@Level_15 VARCHAR(MAX),@Level_16 VARCHAR(MAX),@Level_17 VARCHAR(MAX),@Level_18 VARCHAR(MAX),@Level_19 VARCHAR(MAX),
		@Level_20 VARCHAR(MAX)

		DECLARE @Temp_tbl_count int,@Emailbody NVARCHAR(Max)=''
		SELECT @Temp_tbl_count = 0, @Emailbody = ''

		SET @Emailbody = @Notification_Body
		DECLARE @MainRowBody VARCHAR(MAX) = '', @ReplaceRowBody VARCHAR(MAX) = '', @PerRowBody VARCHAR(MAX) = '', @StartIndex INT = 0, @EndIndex INT = 0
		SELECT @StartIndex = CHARINDEX('<!--ACQ_ROWSETSTART-->', @Emailbody), @EndIndex = CHARINDEX('<!--ACQ_ROWSETEND-->', @Emailbody)

		SELECT @MainRowBody = SUBSTRING(@Emailbody, @StartIndex, (@EndIndex - @StartIndex) + 20)
		
		SET @Temp_tbl_count = 0

		WHILE ( @Counter <= (SELECT COUNT(*) FROM #Tmp_Pivot_Result))
		BEGIN
			
			SELECT @Content_Category = Content_Category ,@Level_1=[Level 1],@Level_2=[Level 2],@Level_3=[Level 3],@Level_4=[Level 4],@Level_5=[Level 5]
			,@Level_6=[Level 6],@Level_7=[Level 7],@Level_8=[Level 8],@Level_9=[Level 9],@Level_10=[Level 10],@Level_11=[Level 11],@Level_12=[Level 12]
			,@Level_13=[Level 13],@Level_14=[Level 14],@Level_15=[Level 15],@Level_16=[Level 16],@Level_17=[Level 17],@Level_18=[Level 18],@Level_19=[Level 19]
			,@Level_20=[Level 20]
			FROM #Tmp_Pivot_Result
			WHERE Tmp_Pivot_Result_Code = @Counter

			--SELECT @LevelColumnsConcat = ''
			--DELETE FROM #tdValue

			--SELECT @LevelColumnsConcat = '''<td width="7%">'' + Content_Category + ''</td>''+' + STUFF(( SELECT DISTINCT '+ ''<td align="center" width="7%">'' + [' + Level +'] + ''</td>'' ' FROM #Tmp_DealWorkFlow_Status_Pending  FOR XML PATH (''), TYPE).value('.', 'nvarchar(max)'), 1, 1, '')

			--INSERT INTO #tdValue(result)
			--EXEC('select '+ @LevelColumnsConcat +' from #Tmp_Pivot_Result where  Tmp_Pivot_Result_Code  = ' +@Counter )
		
			--SELECT TOP 1  @TableBody = @TableBody + '<tr>' + Result + '</tr>' FROM #tdValue		
			

			SELECT @PerRowBody = ''
			
			SET @Temp_tbl_count = @Temp_tbl_count + 1
			SELECT @PerRowBody = @MainRowBody

			SELECT @PerRowBody = REPLACE(@PerRowBody, '{BU_Name}', CAST(ISNULL(@Content_Category, ' ') AS NVARCHAR(1000)))								
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level1}', CAST(ISNULL(@Level_1, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level2}', CAST(ISNULL(@Level_2 , ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level3}', CAST(ISNULL(@Level_3, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level4}', CAST(ISNULL(@Level_4, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level5}', CAST(ISNULL(@Level_5, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level6}', CAST(ISNULL(@Level_6, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level7}', CAST(ISNULL(@Level_7, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level8}', CAST(ISNULL(@Level_8, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level9}', CAST(ISNULL(@Level_9, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level10}', CAST(ISNULL(@Level_10, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level11}', CAST(ISNULL(@Level_11, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level12}', CAST(ISNULL(@Level_12, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level13}', CAST(ISNULL(@Level_13, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level14}', CAST(ISNULL(@Level_14, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level15}', CAST(ISNULL(@Level_15, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level16}', CAST(ISNULL(@Level_16, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level17}', CAST(ISNULL(@Level_17, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level18}', CAST(ISNULL(@Level_18, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level19}', CAST(ISNULL(@Level_19, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level20}', CAST(ISNULL(@Level_20, ' ') AS NVARCHAR(1000)))

			SELECT @ReplaceRowBody = @ReplaceRowBody + @PerRowBody

			SET @Counter  = @Counter  + 1
		END

		IF( @Temp_tbl_count <> 0)
		BEGIN

			SELECT @Emailbody = REPLACE(@Emailbody, @MainRowBody, @ReplaceRowBody)

		END

		--SELECT @TableBody += '</table>'
		--SET @Email_Template = REPLACE(@Email_Template , '{acqtable}',@TableBody)
		--------------Clearing Variable and temp table for Reuse
		TRUNCATE TABLE #Tmp_DealWorkFlow_Status_Pending
		TRUNCATE TABLE #Tmp_Pivot_Result
		TRUNCATE TABLE #tdValue

		SELECT  @TableBody = '', @LevelColumns = '' , @LevelColumnsIsNull = '', @MaxLevel = '', @HeaderName = '', @Counter = 1
		SELECT @MainRowBody = '', @ReplaceRowBody = '', @PerRowBody = '', @StartIndex = 0, @EndIndex = 0

		INSERT INTO #Tmp_DealWorkFlow_Status_Pending														
		EXEC [USP_DealWorkFlow_Status_Pending_Reports] 35, @Business_Unit_Code

		SELECT @LevelColumns = STUFF(( SELECT DISTINCT ',[' + Level +']' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')		
		SELECT @LevelColumnsIsNull = STUFF(( SELECT DISTINCT ',ISNULL(CAST(A.[' + Level +'] AS VARCHAR),''NA'')' FROM #Tmp_DealWorkFlow_Status_Pending FOR XML PATH('') ), 1, 1, '')	

		EXEC (' INSERT INTO #Tmp_Pivot_Result ( Content_Category, '+@LevelColumns+')
		SELECT A.Content_Category, '+ @LevelColumnsIsNull +' FROM (
		SELECT Content_Category  as ''Content_Category'' , '+@LevelColumns+' FROM #Tmp_DealWorkFlow_Status_Pending AS Tbl PIVOT( SUM(Deal_Count) 
		FOR [Level] IN ('+@LevelColumns+')) AS Pvt ) AS A ') 
	
	--	SELECT id, REPLACE(REPLACE(number,'[',''),']','') as Header INTO #TableSynHeader from DBO.FN_Split_WithDelemiter('Content Category,' + @LevelColumns, ',')

	--	SELECT @MaxLevel = COUNT(*) FROM #TableSynHeader

	--	SELECT @TableBody += '<table  class="tblFormat" Border = 1px style="solid black; border-collapse: collapse">
	--					<tr> <td colspan="'+CAST(@MaxLevel AS VARCHAR)+'" style="padding: 8px 0px 3px 0px;font-weight:bold;background-color:red;color:white;"> Syndication Deals </td> </tr> 
	--					<tr>'
	-------------------------
	--	WHILE ( @Counter <= @MaxLevel)
	--	BEGIN
	--	   SELECT @HeaderName = Header FROM #TableSynHeader WHERE id = @Counter
	--	   SELECT @TableBody += '<th align="center" width="7%"> '+@HeaderName+'</th>'
	--	   SET @Counter  = @Counter  + 1
	--	END
	--	SELECT  @TableBody += '</tr>', @Counter = 1
			
		SELECT @StartIndex = CHARINDEX('<!--SYN_ROWSETSTART-->', @Emailbody), @EndIndex = CHARINDEX('<!--SYN_ROWSETEND-->', @Emailbody)

		SELECT @MainRowBody = SUBSTRING(@Emailbody, @StartIndex, (@EndIndex - @StartIndex) + 20)
		
		SET @Temp_tbl_count = 0

		WHILE ( @Counter <= (SELECT COUNT(*) FROM #Tmp_Pivot_Result))
		BEGIN
			SELECT @Content_Category = Content_Category ,@Level_1=[Level 1],@Level_2=[Level 2],@Level_3=[Level 3],@Level_4=[Level 4],@Level_5=[Level 5]
			,@Level_6=[Level 6],@Level_7=[Level 7],@Level_8=[Level 8],@Level_9=[Level 9],@Level_10=[Level 10],@Level_11=[Level 11],@Level_12=[Level 12]
			,@Level_13=[Level 13],@Level_14=[Level 14],@Level_15=[Level 15],@Level_16=[Level 16],@Level_17=[Level 17],@Level_18=[Level 18],@Level_19=[Level 19]
			,@Level_20=[Level 20]
			FROM #Tmp_Pivot_Result
			WHERE Tmp_Pivot_Result_Code = @Counter

			--SELECT @LevelColumnsConcat = ''
			--DELETE FROM #tdValue

			--SELECT @LevelColumnsConcat = '''<td width="7%">'' + Content_Category + ''</td>''+' + STUFF(( SELECT DISTINCT '+ ''<td align="center" width="7%">'' + [' + Level +'] + ''</td>'' ' FROM #Tmp_DealWorkFlow_Status_Pending  FOR XML PATH (''), TYPE).value('.', 'nvarchar(max)'), 1, 1, '')
	
			--INSERT INTO #tdValue(result)
			--EXEC('select '+ @LevelColumnsConcat +' from #Tmp_Pivot_Result where Tmp_Pivot_Result_Code  = ' +@Counter )
		
	
			--SELECT TOP 1  @TableBody = @TableBody + '<tr>' + Result + '</tr>' FROM #tdValue

			SELECT @PerRowBody = ''
			
			SET @Temp_tbl_count = @Temp_tbl_count + 1
			SELECT @PerRowBody = @MainRowBody

			SELECT @PerRowBody = REPLACE(@PerRowBody, '{BU_Name}', CAST(ISNULL(@Content_Category, ' ') AS NVARCHAR(1000)))								
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level1}', CAST(ISNULL(@Level_1, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level2}', CAST(ISNULL(@Level_2 , ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level3}', CAST(ISNULL(@Level_3, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level4}', CAST(ISNULL(@Level_4, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level5}', CAST(ISNULL(@Level_5, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level6}', CAST(ISNULL(@Level_6, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level7}', CAST(ISNULL(@Level_7, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level8}', CAST(ISNULL(@Level_8, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level9}', CAST(ISNULL(@Level_9, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level10}', CAST(ISNULL(@Level_10, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level11}', CAST(ISNULL(@Level_11, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level12}', CAST(ISNULL(@Level_12, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level13}', CAST(ISNULL(@Level_13, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level14}', CAST(ISNULL(@Level_14, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level15}', CAST(ISNULL(@Level_15, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level16}', CAST(ISNULL(@Level_16, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level17}', CAST(ISNULL(@Level_17, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level18}', CAST(ISNULL(@Level_18, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level19}', CAST(ISNULL(@Level_19, ' ') AS NVARCHAR(1000)))
			SELECT @PerRowBody = REPLACE(@PerRowBody, '{Level20}', CAST(ISNULL(@Level_20, ' ') AS NVARCHAR(1000)))

			SELECT @ReplaceRowBody = @ReplaceRowBody + @PerRowBody

			SET @Counter  = @Counter  + 1
		 END

		 IF( @Temp_tbl_count <> 0)
		BEGIN
			SELECT @Emailbody = REPLACE(@Emailbody, @MainRowBody, @ReplaceRowBody)
		END
		 --SELECT @TableBody += '</table>'
		 --SET @Email_Template = REPLACE(@Email_Template , '{syntable}',@TableBody)

		--SELECT @Email_Template,  @To_Users_Email_id, @CC_Users_Email_id , @BCC_Users_Email_id

		--PRINT @Email_Template
		INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
		SELECT @Email_Config_Code,@Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_Users_Email_id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_Users_Email_id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_Users_Email_id,''),  @Notification_Subject

		EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT, 0, 0, @Email_Config_Code, @Event_Platform_Code, @Event_Template_Type

		 -- EXEC msdb.dbo.sp_send_dbmail 
			--@profile_name = @DatabaseEmailProfile,
			--@recipients =  @To_Users_Email_id,
			--@copy_recipients = @CC_Users_Email_id,
			--@blind_copy_recipients = @BCC_Users_Email_id,
			--@subject = @MailSubject,
			--@body = @Email_Template, 
			--@body_format = 'HTML';
		DELETE FROM @Email_Config_Users_UDT
		FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
	END
	CLOSE curNotificationPlatforms
	DEALLOCATE curNotificationPlatforms
END
