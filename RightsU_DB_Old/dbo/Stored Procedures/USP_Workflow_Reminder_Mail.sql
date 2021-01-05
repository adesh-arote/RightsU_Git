alter PROCEDURE [dbo].[USP_Workflow_Reminder_Mail] 
-- =============================================
-- Author:		Anchal Sikarwar
-- Create date:	23-03-2017
-- =============================================
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @EmailBody NVARCHAR(max)='',@EmailBody1 NVARCHAR(max)='',@EmailBody2 NVARCHAR(max)='',@MailSubject NVARCHAR(Max), @DatabaseEmailProfile NVARCHAR(25), @EmailHeader NVARCHAR(max)='',
		@EmailFooter NVARCHAR(max)='', @users NVARCHAR(max), @UsersEmailId NVARCHAR(max),@Users_Email_id NVARCHAR(max),@Business_Unit_Code INT, @Title_Name NVARCHAR(max)
		, @Agreement_No NVARCHAR(max), @Deal_Desc NVARCHAR(max),@Email_Id NVARCHAR(MAX),@Vender_Name NVARCHAR(500), @Agreement_Date NVARCHAR(max), @Is_Daily CHAR(1)
		,@Days INT, @Bu_Name NVARCHAR(100), @Users_Code INT, @TUser_Code INT, @EmailDetails NVarchar(max),@U_Code INT
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='ARE'

	SELECT @DatabaseEmailProfile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'  
	
	SELECT @Is_Daily = parameter_value FROM system_parameter_new WHERE parameter_name = 'Approver_Alert_Is_Daily'  
	IF OBJECT_ID('tempdb..#TempAcq') IS NOT NULL
	BEGIN
		DROP TABLE #TempAcq
	END
	IF OBJECT_ID('tempdb..#TempSyn') IS NOT NULL
	BEGIN
		DROP TABLE #TempSyn
	END
	IF OBJECT_ID('tempdb..#Email_Config_Alert') IS NOT NULL
	BEGIN
		DROP TABLE #Email_Config_Alert
	END
	IF OBJECT_ID('tempdb..#Temp_UnApproved_Deals') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_UnApproved_Deals
	END
	IF OBJECT_ID('tempdb..#Temp_UnApproved_Syn_Deals') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_UnApproved_Syn_Deals
	END
	

	CREATE TABLE #TempAcq
	(
		Record_Code INT,
		Business_Unit_Code INT,
		Users_Code INT,
		Email_Id NVARCHAR(1000),
		[Days] INT,
		Business_Unit_Name NVARCHAR(1000)
	)
	CREATE TABLE #TempSyn
	(
		Record_Code INT,
		Business_Unit_Code INT,
		Users_Code INT,
		Email_Id NVARCHAR(1000),
		[Days] INT,
		Business_Unit_Name NVARCHAR(1000)
	)

	SELECT F.User_Mail_Id, F.BuCode, F.Users_Code, Mail_Alert_Days 
	INTO #Email_Config_Alert 
	from [dbo].[UFN_Get_Bu_Wise_User]('ARE') AS F
	INNER JOIN Email_Config E ON E.[Key] = 'ARE' 
	INNER JOIN Email_Config_Detail ED ON  E.Email_Config_Code=ED.Email_Config_Code
	INNER JOIN Email_Config_Detail_Alert EDA ON  ED.Email_Config_Detail_Code=EDA.Email_Config_Detail_Code

	SET @MailSubject = 'RightsU Approval Reminder'
	SET @EmailFooter = '&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="2" COLOR="Black">
							(This is a system generated mail. Please do not reply back to the same)</b></br></br></font>
							<FONT FACE="verdana" SIZE="2" COLOR="Black">
							Thanks & Regards,</font></br>
							<FONT FACE="verdana" SIZE="2" COLOR="Black">
							RightsU System</br></font></body></html>'
	SELECT DISTINCT 
	MWD.Record_Code
    ,AD.Business_Unit_Code
	,(dateadd(d, WMR.Reminder_Days, MSH.Status_Changed_On)) AS Reminder_Days
	,DATEDIFF(d,MSH.Status_Changed_On,GETDATE()) AS [Days]
	,MWD.Group_Code
	,BU.Business_Unit_Name
	INTO #Temp_UnApproved_Deals
	FROM Module_Workflow_Detail MWD
	INNER JOIN Module_Status_History MSH ON MSH.Record_Code=MWD.Record_Code AND MSH.Module_Code=30
	INNER JOIN Acq_Deal AD ON MSH.Record_Code=AD.Acq_Deal_Code
	INNER JOIN Workflow_Module WM ON WM.Workflow_Code=AD.Work_Flow_Code AND WM.Module_Code=MSH.Module_Code 
	AND WM.Business_Unit_Code=AD.Business_Unit_Code
	AND (MSH.Status_Changed_On>=WM.Effective_Start_Date AND MSH.Status_Changed_On<=ISNULL(WM.System_End_Date,CONVERT(datetime,'31 Dec 9999')))  
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code=AD.Business_Unit_Code AND BU.Is_Active='Y'
	INNER JOIN Workflow_Module_Role WMR ON WMR.Workflow_Module_Code=WM.Workflow_Module_Code AND WMR.Group_Code=MWD.Group_Code
	AND WMR.Group_Level=MWD.Role_Level
	--INNER JOIN Users U ON U.Security_Group_Code=MWD.Group_Code
	--LEFT JOIN #Email_Config_Alert T ON T.BUCode=AD.Business_Unit_Code
	where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND   MWD.Module_Workflow_Detail_Code IN(
	select MIN(Module_Workflow_Detail_Code) from Module_Workflow_Detail
	WHERE Is_Done='N' and Module_Code = 30
		GROUP BY Record_Code,Module_Code,Is_Done) 
		AND
	( MSH.Module_Status_Code in (
	select  MAX(Module_Status_Code) from Module_Status_History WHERE Module_Code=30
	group by Record_Code, Module_Code 
	)
	and MSH.Status = 'W')

	INSERT INTO #TempAcq(Record_Code ,Business_Unit_Code ,Users_Code ,Email_Id ,[Days] ,Business_Unit_Name)
	select DISTINCT T.Record_Code, T.Business_Unit_Code, U.Users_Code, U.Email_Id, T.[Days], T.Business_Unit_Name
	 from #Temp_UnApproved_Deals T
	INNER JOIN Users U ON U.Security_Group_Code = T.Group_Code 
	WHERE (
			(
				Reminder_Days <= GETDATE() AND @Is_Daily = 'Y'
			)
			OR 
			(
				Reminder_Days = GETDATE() AND @Is_Daily = 'N'
			)
		)

		--select * from #TempAcq
	INSERT INTO #TempAcq(Record_Code ,Business_Unit_Code ,Users_Code ,Email_Id ,[Days] ,Business_Unit_Name)
	select DISTINCT T.Record_Code, T.Business_Unit_Code, ECA.Users_Code, ECA.User_Mail_Id, T.[Days], T.Business_Unit_Name
	from #Temp_UnApproved_Deals T
	INNER JOIN #Email_Config_Alert ECA ON ECA.BUCode=T.Business_Unit_Code
	WHERE 
	(
		(
			[Days] >= ECA.Mail_alert_days AND @Is_Daily = 'Y'
		)
		OR 
		(
			[Days] = ECA.Mail_alert_days AND @Is_Daily = 'N'
		)
	)

	SELECT DISTINCT 
	MWD.Record_Code
    ,SD.Business_Unit_Code
	,(dateadd(d, WMR.Reminder_Days, MSH.Status_Changed_On)) AS Reminder_Days
	,DATEDIFF(d,MSH.Status_Changed_On,GETDATE()) AS [Days]
	,MWD.Group_Code
	,BU.Business_Unit_Name
	INTO #Temp_UnApproved_Syn_Deals
	FROM Module_Workflow_Detail MWD
	INNER JOIN Module_Status_History MSH ON MSH.Record_Code=MWD.Record_Code AND MSH.Module_Code=35
	INNER JOIN Syn_Deal SD ON MSH.Record_Code=SD.Syn_Deal_Code
	INNER JOIN Workflow_Module WM ON WM.Workflow_Code=SD.Work_Flow_Code AND WM.Module_Code=MSH.Module_Code AND WM.Business_Unit_Code=SD.Business_Unit_Code
	AND (MSH.Status_Changed_On >= WM.Effective_Start_Date AND MSH.Status_Changed_On <= ISNULL(WM.System_End_Date,CONVERT(datetime,'31 Dec 9999')))  
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code AND BU.Is_Active='Y'
	INNER JOIN Workflow_Module_Role WMR ON WMR.Workflow_Module_Code = WM.Workflow_Module_Code AND WMR.Group_Code=MWD.Group_Code AND WMR.Group_Level=MWD.Role_Level
	--INNER JOIN Users U ON U.Security_Group_Code=MWD.Group_Code
	--LEFT JOIN Deal_Expiry_Email DEE ON DEE.Business_Unit_Code=SD.Business_Unit_Code
	--LEFT JOIN #Email_Config_Alert T ON T.BUCode = SD.Business_Unit_Code
	where MWD.Module_Workflow_Detail_Code IN(
	select MIN(Module_Workflow_Detail_Code) from Module_Workflow_Detail
	WHERE Is_Done='N' and Module_Code = 35
		GROUP BY Record_Code,Module_Code,Is_Done) 
		AND
	( MSH.Module_Status_Code in (
	select  MAX(Module_Status_Code) from Module_Status_History WHERE Module_Code=35
	group by Record_Code, Module_Code 
	)
	and MSH.Status = 'W')

	INSERT INTO #TempSyn(Record_Code ,Business_Unit_Code ,Users_Code ,Email_Id ,[Days] ,Business_Unit_Name)
	select DISTINCT T.Record_Code, T.Business_Unit_Code, U.Users_Code, U.Email_Id, T.[Days], T.Business_Unit_Name
	 from #Temp_UnApproved_Syn_Deals T
	INNER JOIN Users U ON U.Security_Group_Code = T.Group_Code 
	WHERE (
			(
				Reminder_Days <= GETDATE() AND @Is_Daily = 'Y'
			)
			OR 
			(
				Reminder_Days = GETDATE() AND @Is_Daily = 'N'
			)
		)

	INSERT INTO #TempSyn(Record_Code ,Business_Unit_Code ,Users_Code ,Email_Id ,[Days] ,Business_Unit_Name)
	select DISTINCT T.Record_Code, T.Business_Unit_Code, ECA.Users_Code, ECA.User_Mail_Id, T.[Days], T.Business_Unit_Name
	from #Temp_UnApproved_Syn_Deals T
	INNER JOIN #Email_Config_Alert ECA ON ECA.BUCode=T.Business_Unit_Code
	WHERE 
	(
		(
			[Days] >= ECA.Mail_alert_days AND @Is_Daily = 'Y'
		)
		OR 
		(
			[Days] = ECA.Mail_alert_days AND @Is_Daily = 'N'
		)
	)

	IF EXISTS(SELECT * FROM #TempAcq)
	BEGIN
		DECLARE CurMail1 CURSOR FOR
		SELECT DISTINCT Email_Id, Users_Code FROM #TempAcq
		OPEN CurMail1
		FETCH NEXT FROM CurMail1 Into @Email_Id, @U_Code
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

		SET @EmailBody = '<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>'
			DECLARE CurMail2 CURSOR FOR
			SELECT DISTINCT Business_Unit_Name, Users_Code FROM #TempAcq where Users_Code=@U_Code
			OPEN CurMail2
			FETCH NEXT FROM CurMail2 Into @Bu_Name, @Users_Code
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				if EXISTS (SELECT * FROM #TempAcq t INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code=t.Record_Code 
				WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND   t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name)
				BEGIN
					SET @EmailBody1 = @EmailBody1 + '<tr><td colspan="6" style="padding: 8px 0px 3px 0px;font-weight:bold">
										Business Unit:'+@Bu_Name+' </td></tr>'
					SET @EmailBody1 = @EmailBody1 + '<tr>
						<th align="center" width="7%"  >Agreement No</th>
						<th align="center" width="5%"  >Agreement Date</th>
						<th align="center" width="12%" >Deal Description</th>
						<th align="center" width="13%" >Primary Licensor</th>
						<th align="center" width="12%" >Title Name</th>
						<th align="center" width="10%" >Pending Since (Days)</th>
						</tr>'
				
					DECLARE CurMail CURSOR FOR
					SELECT 
					DISTINCT
					AD.Agreement_No,AD.Deal_Desc,
					(SELECT Vendor_Name from Vendor where Vendor_Code=
					AD.Vendor_Code) AS Vendor_Name,CONVERT(VARCHAR,AD.Agreement_Date,106),
					REVERSE(
						STUFF(REVERSE(STUFF((
							SELECT DISTINCT
							[dbo].[UFN_GetTitleNameInFormat]
							(
								'DEAL_'+UPPER(
								DT.Deal_Type_Name)
								, 
								T.Title_Name, 
								ADRT.Episode_From, 
								ADRT.Episode_To
							)+','
							from Acq_Deal_Rights ADR
							INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
							INNER JOIN Title T ON T.Title_Code=ADRT.Title_Code
							INNER JOIN Acq_Deal AD1 ON AD1.Acq_Deal_Code=ADR.Acq_Deal_Code
							INNER JOIN Deal_Type DT ON DT.Deal_Type_Code=AD1.Deal_Type_Code
							where ADR.Acq_Deal_Code=AD.Acq_Deal_Code
							FOR XML PATH(''), root('Title_Name'), type
							).value('/Title_Name[1]','NVARCHAR(max)'

						),2,0, '')), 1, 1, '')) as Title_Name,t.Days

					FROM #TempAcq t
					INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code=t.Record_Code
					WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND   t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name
					ORDER BY t.Days DESC
					OPEN CurMail
					FETCH NEXT FROM CurMail Into @Agreement_No,@Deal_Desc,@Vender_Name,@Agreement_Date,@Title_Name,@Days
					WHILE(@@FETCH_STATUS = 0)
					BEGIN
						SET @EmailBody2 = Isnull(@EmailBody2, ' ')+'<tr>
									<td align="center" width="7%" >'+Isnull(@Agreement_No, ' ')+'</td>
									<td align="center" width="5%" >'+REPLACE(ISNULL(@Agreement_Date, ' '),' ','-')+'</td>
									<td width="12%" >'+Isnull(@Deal_Desc, ' ')+'</td>
									<td width="13%" >'+Isnull(@Vender_Name, ' ')+'</td>
									<td width="12%" >'+Isnull(@Title_Name, ' ')+'</td>
									<td align="center" width="10%" >'+CONVERT(VARCHAR,Isnull(@Days, 0),0)+'</td>
									</tr>'
						FETCH NEXT FROM CurMail Into @Agreement_No,@Deal_Desc,@Vender_Name,@Agreement_Date,@Title_Name,@Days
					END
		
					CLOSE CurMail;
					DEALLOCATE CurMail;
					SET @EmailBody = ISNULL(@EmailBody,'')+ISNULL(@EmailBody1,'')+ISNULL(@EmailBody2,'')
				END
				SET @EmailBody1=''
				SET @EmailBody2=''
				FETCH NEXT FROM CurMail2 Into @Bu_Name, @Users_Code
			END
			CLOSE CurMail2;
		DEALLOCATE CurMail2;
				
				SET @EmailHeader= '<html>
					<head>	<style>table {border-collapse: collapse;width: 100%;border-color:black}th, td {padding: 2px;border-color:black; Font-Size:12; font-family: verdana;}
						th {background-color: #c7c6c6;color: black;border-color:black; font-weight:bold}</style></head>
					<body>
						<Font FACE="verdana" SIZE="2" COLOR="Black">Hello User,<br /><br />
						The following Acquisition deals have not been approved:<br /><br />
						</Font>'

			
			if(@EmailBody!='')
			SET @EmailBody=@EmailBody +'</table>'
			SET @EmailDetails = @EmailHeader + @EmailBody  + @EmailFooter
			IF(@EmailBody!='')
			BEGIN
				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmailProfile,
				@recipients = @Email_Id,
				@subject = @MailSubject,
				@body = @EmailDetails, 
				@body_format = 'HTML';

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @EmailBody, @Users_Code, 'Approval Remainder', @Email_Id
			END
			SEt @EmailDetails=''
			SET @EmailBody=''
			SET @EmailBody2=''
			FETCH NEXT FROM CurMail1 Into @Email_Id, @U_Code
		END
		CLOSE CurMail1;
		DEALLOCATE CurMail1
	END

	IF EXISTS(SELECT * FROM #TempSyn)
	BEGIN
	SET @EmailBody = ''
	SET @EmailBody1 = ''
	SET @EmailBody2 = ''
		DECLARE CurMail1 CURSOR FOR
	SELECT DISTINCT Email_Id, Users_Code  FROM #TempSyn
	OPEN CurMail1
	FETCH NEXT FROM CurMail1 Into @Email_Id, @U_Code
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
			SET @EmailBody = '<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>'
			
			SET @EmailBody2=''

			DECLARE CurMail2 CURSOR FOR
			SELECT DISTINCT Business_Unit_Name, Users_Code FROM #TempSyn where Users_Code=@U_Code
			OPEN CurMail2
			FETCH NEXT FROM CurMail2 Into @Bu_Name, @Users_Code
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				if EXISTS (SELECT * FROM #TempSyn t
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=t.Record_Code
			WHERE t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name)
				BEGIN
					SET @EmailBody1 = @EmailBody1 + '<tr><td colspan="6" style="padding: 8px 0px 3px 0px;font-weight:bold">
										Business Unit:'+@Bu_Name+' </td></tr>'
					SET @EmailBody1 = @EmailBody1 + '<tr>
						<th align="center" width="7%" >Agreement No</th>
						<th align="center" width="5%" >Agreement Date</th>
						<th align="center" width="12%">Deal Description</th>
						<th align="center" width="13%">Primary Licensor</th>
						<th align="center" width="12%">Title Name</th>
						<th align="center" width="10%">Pending Since (Days)</th>
						</tr>'

			DECLARE CurMail CURSOR FOR
			SELECT DISTINCT
			SD.Agreement_No,SD.Deal_Description,
			(SELECT Vendor_Name from Vendor where Vendor_Code=
				SD.Vendor_Code) AS Vendor_Name,CONVERT(VARCHAR,SD.Agreement_Date,106),
			REVERSE(
				STUFF(REVERSE(STUFF((
					Select DISTINCT
					[dbo].[UFN_GetTitleNameInFormat]
					(
						'DEAL_'+UPPER(
						DT.Deal_Type_Name)
						, 
						T.Title_Name, 
						SDRT.Episode_From, 
						SDRT.Episode_To
					)+','
					from Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					INNER JOIN Title T ON T.Title_Code=SDRT.Title_Code
					INNER JOIN Syn_Deal SD1 ON SD1.Syn_Deal_Code=SDR.Syn_Deal_Code
					INNER JOIN Deal_Type DT ON DT.Deal_Type_Code=SD1.Deal_Type_Code
					where SDR.Syn_Deal_Code=SD.Syn_Deal_Code
					FOR XML PATH(''), root('Title_Name'), type
					).value('/Title_Name[1]','NVARCHAR(max)'

				),2,0, '')), 1, 1, '')) as Title_Name,t.Days

			FROM #TempSyn t
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=t.Record_Code
			WHERE t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name
			ORDER BY t.Days DESC
			OPEN CurMail
			FETCH NEXT FROM CurMail Into @Agreement_No,@Deal_Desc,@Vender_Name,@Agreement_Date,@Title_Name,@Days
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				SET @EmailBody2 = Isnull(@EmailBody2, ' ')+'<tr>
							<td align="center" width="7%">'+Isnull(@Agreement_No, ' ')+'</td>
							<td align="center" width="5%" >'+REPLACE(ISNULL(@Agreement_Date, ' '),' ','-')+'</td>
							<td width="12%">'+Isnull(@Deal_Desc, ' ')+'</td>
							<td width="13%">'+Isnull(@Vender_Name, ' ')+'</td>
							<td width="12%">'+Isnull(@Title_Name, ' ')+'</td>
							<td align="center" width="10%" >'+CONVERT(VARCHAR,Isnull(@Days, 0),0)+'</td>
							</tr>'
				FETCH NEXT FROM CurMail Into @Agreement_No,@Deal_Desc,@Vender_Name,@Agreement_Date,@Title_Name,@Days
			END
			CLOSE CurMail;
			DEALLOCATE CurMail;
			SET @EmailBody = ISNULL(@EmailBody,'')+ISNULL(@EmailBody1,'')+ISNULL(@EmailBody2,'')
			END
			SET @EmailBody1=''
				SET @EmailBody2=''
			FETCH NEXT FROM CurMail2 Into @Bu_Name, @Users_Code
			END
			CLOSE CurMail2;
		DEALLOCATE CurMail2;
			SET @EmailHeader= '<html>
				<head>	<style>table {border-collapse: collapse;width: 100%;border-color:black}
				th{padding: 2px;border-color:black; Font-Size:12; font-family: verdana;font-weight:bold}
				 td {padding: 2px;border-color:black; Font-Size:12; font-family: verdana;}
					th {background-color: #c7c6c6;color: black;border-color:black}</style></head>
				<body>
					<Font FACE="verdana" SIZE="2" COLOR="Black">Hello User,<br /><br />
					The following Syndication deals have not been approved:<br /><br />
					</Font>'
		if(@EmailBody!='')
		SET @EmailBody=@EmailBody +'</table>'
		SET @EmailDetails = @EmailHeader + @EmailBody  + @EmailFooter
		IF(@EmailBody!='')
		BEGIN
			EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmailProfile,
			@recipients = @Email_Id,
			@subject = @MailSubject,
			@body = @EmailDetails, 
			@body_format = 'HTML';

			INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @EmailBody, @Users_Code, 'Approval Remainder', @Email_Id
		END
		SEt @EmailDetails='' 	
		SET @EmailBody=''
		SET @EmailBody1=''
		SET @EmailFooter=''
		SET @EmailHeader=''
		FETCH NEXT FROM CurMail1 Into @Email_Id, @U_Code
	END
	CLOSE CurMail1;
	DEALLOCATE CurMail1;
	END
END
--select * from Acq_Deal where Deal_Workflow_Status='W'
--select * from Syn_Deal where Deal_Workflow_Status='W'