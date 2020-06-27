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

	DECLARE @Business_Unit_Code INT
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
	--Cursor Start
	--DECLARE cPointer CURSOR FOR SELECT Users_Email_id, Business_Unit_Code FROM Deal_Expiry_Email WHERE Alert_Type = 'U'
	--Change
	--UPDATE System_Parameter_New SET Parameter_Value='5,8' WHERE Parameter_Name='UnutilizedRun_Business_Unit'
	DECLARE cPointer CURSOR FOR SELECT User_Mail_Id, BuCode,Users_Code,Channel_Codes FROM [dbo].[UFN_Get_Bu_Wise_User]('CUR')
	--Change
	OPEN cPointer
		FETCH NEXT FROM cPointer INTO @EmailId, @Business_Unit_Code, @Users_Code, @Channel_Codes																																																					WHILE @@FETCH_STATUS = 0
		BEGIN
			
			DECLARE @ParameterValue as NVARCHAR(20)
			--'UnutilizedRun_Business_Unit' is not needed as we have already selected Bu from Email_Config_Detail_User table
			--SELECT @ParameterValue = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='UnutilizedRun_Business_Unit'
			
			--IF EXISTS(
			----Change
			--SELECT number FROM dbo.fn_Split_withdelemiter(@ParameterValue,',') where number=@Business_Unit_Code 
			----Old
			----SELECT * FROM 
			----Deal_Expiry_Email WHERE Alert_Type = 'U' AND Business_Unit_Code = @Business_Unit_Code
			---- AND Business_Unit_Code in
			----(SELECT number FROM dbo.fn_Split_withdelemiter(@ParameterValue,','))
			--)
			--BEGIN
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
				@recipients =  @EmailId,
				@subject = 'Unutilized Run Details',
				@body = @Emailbody, 
				@body_format = 'HTML';
				  
				--Change
				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code,GETDATE(),'N',@EmailTable,@Users_Code,'Channel Unutilized Run',@EmailId
				END
				--Change
				--Sending mail end
				SET @EmailTable = ''
				SET @Emailbody = ''
			--END
			FETCH NEXT FROM cPointer INTO @EmailId, @Business_Unit_Code, @Users_Code, @Channel_Codes
		END
	CLOSE cPointer
	DEALLOCATE cPointer
END