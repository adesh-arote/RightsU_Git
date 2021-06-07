CREATE PROCEDURE [dbo].[USP_Workflow_Reminder_Mail] 
 --=============================================
 --Author:		Anchal Sikarwar
 --Create date:	23-03-2017
 --=============================================
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @EmailBody NVARCHAR(max)='',@EmailBody1 NVARCHAR(max)='',@EmailBody2 NVARCHAR(max)='',@MailSubject NVARCHAR(Max), @DatabaseEmailProfile NVARCHAR(25), @EmailHeader NVARCHAR(max)='',
		@EmailFooter NVARCHAR(max)='', @users NVARCHAR(max), @UsersEmailId NVARCHAR(max),@Users_Email_id NVARCHAR(max),@Business_Unit_Code INT, @Title_Name NVARCHAR(max)
		, @Agreement_No NVARCHAR(max), @Deal_Desc NVARCHAR(max),@Email_Id NVARCHAR(MAX),@Vender_Name NVARCHAR(500), @Agreement_Date NVARCHAR(max), @Is_Daily CHAR(1)
		,@Days INT, @Bu_Name NVARCHAR(100) 

	DECLARE @Mail_alert_days INT = 7
	SELECT @DatabaseEmailProfile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'  
	
	SELECT @Is_Daily = parameter_value FROM system_parameter_new WHERE parameter_name = 'Approver_Alert_Is_Daily'  
	IF OBJECT_ID('tempdb..#TempA') IS NOT NULL
	BEGIN
		DROP TABLE #TempA
	END
	IF OBJECT_ID('tempdb..#TempS') IS NOT NULL
	BEGIN
		DROP TABLE #TempS
	END

	IF OBJECT_ID('tempdb..#TmpEmail_Config') IS NOT NULL
	BEGIN
		DROP TABLE #TmpEmail_Config
	END

	SET @MailSubject = 'RightsU Approval Reminder'
	SET @EmailFooter = '&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="2" COLOR="Black">
							(This is a system generated mail. Please do not reply back to the same)</b></br></br></font>
							<FONT FACE="verdana" SIZE="2" COLOR="Black">
							Thanks & Regards,</font></br>
							<FONT FACE="verdana" SIZE="2" COLOR="Black">
							RightsU System</br></font></body></html>'

		DECLARE @ENL TABLE (
			BUCode INT,
			User_Code INT,
			EmailId NVARCHAR(MAX)
		)

		INSERT INTO @ENL (BUCode, User_Code, EmailId)
		EXEC USP_Get_EmailConfig_Users 'ARE', 'Y'

		SELECT DISTINCT BUCode, STUFF((SELECT DISTINCT ';' + EmailId FROM @ENL WHERE BUCode = A.BUCode FOR XML PATH ('')) , 1, 1, '') AS Users_Email_id  INTO #TmpEmail_Config FROM @ENL A

	SELECT DISTINCT MWD.Record_Code, ISNULL(DEE.Users_Email_id,'') + ';' +
		STUFF(( SELECT DISTINCT  ';' + U.Email_Id FROM Users U
		INNER JOIN Users_Business_Unit ubu on ubu.Users_Code = u.Users_Code and ubu.Business_Unit_Code = bu.Business_Unit_Code
		WHERE  U.Security_Group_Code = MWD.Group_Code AND U.Is_Active = 'Y'
		FOR XML PATH('')), 1, 1, '')
		AS Email_Id,
		DATEDIFF(d,MSH.Status_Changed_On,GETDATE()) AS [Days], BU.Business_Unit_Name--, msh.Status_Changed_On, @Mail_alert_days, DATEADD(d, @Mail_alert_days, MSH.Status_Changed_On)
		INTO #TempA
	FROM Module_Workflow_Detail MWD
	INNER JOIN Module_Status_History MSH ON MSH.Record_Code = MWD.Record_Code AND MSH.Module_Code = MWD.Module_Code AND MSH.Module_Code = 30
	INNER JOIN Acq_Deal AD ON MSH.Record_Code=AD.Acq_Deal_Code
	INNER JOIN Workflow_Module WM ON WM.Workflow_Code=AD.Work_Flow_Code AND WM.Module_Code=MSH.Module_Code AND WM.Business_Unit_Code=AD.Business_Unit_Code 
									 AND (MSH.Status_Changed_On>=WM.Effective_Start_Date AND MSH.Status_Changed_On<=ISNULL(WM.System_End_Date,CONVERT(datetime,'31 Dec 9999')))  
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code=AD.Business_Unit_Code AND BU.Is_Active='Y'
	INNER JOIN Workflow_Module_Role WMR ON WMR.Workflow_Module_Code=WM.Workflow_Module_Code AND WMR.Group_Code=MWD.Group_Code AND WMR.Group_Level=MWD.Role_Level
	LEFT JOIN #TmpEmail_Config DEE ON DEE.BUCode= AD.Business_Unit_Code
	WHERE MWD.Module_Workflow_Detail_Code IN(
		SELECT MIN(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail
		WHERE Is_Done='N' and Module_Code = 30
		GROUP BY Record_Code,Module_Code,Is_Done
	) AND MSH.Module_Status_Code IN (
		SELECT MAX(Module_Status_Code) FROM Module_Status_History WHERE Module_Code = 30 AND Record_Code IN (
			SELECT Acq_Deal_Code FROM Acq_Deal WHERE Deal_Workflow_Status = 'W'
		)
		GROUP BY Record_Code
	) --AND MSH.Status = 'W'
	AND (
		(
			(
				(DATEADD(d, @Mail_alert_days, MSH.Status_Changed_On) <= GETDATE()) OR
				(DATEDIFF(d, MSH.Status_Changed_On, GETDATE()) > @Mail_alert_days)
			) AND @Is_Daily='Y'
		) OR (
			(
				(dateadd(d, @Mail_alert_days, MSH.Status_Changed_On)=GETDATE()) OR
				(DATEDIFF(d,MSH.Status_Changed_On,GETDATE())=@Mail_alert_days)
			) AND @Is_Daily = 'N'
		)
	)


	SELECT DISTINCT MWD.Record_Code, ISNULL(DEE.Users_Email_id,'') + ';' +
	   STUFF(( SELECT DISTINCT  ';' + U.Email_Id FROM Users U
		INNER JOIN Users_Business_Unit ubu on ubu.Users_Code = u.Users_Code and ubu.Business_Unit_Code = bu.Business_Unit_Code
		WHERE  U.Security_Group_Code = MWD.Group_Code AND U.Is_Active = 'Y'
        FOR XML PATH('') ), 1, 1, '')  AS Email_Id,
		DATEDIFF(d,MSH.Status_Changed_On,GETDATE()) AS [Days], BU.Business_Unit_Name
	INTO #TempS
	FROM Module_Workflow_Detail MWD
	INNER JOIN Module_Status_History MSH ON MSH.Record_Code=MWD.Record_Code AND MSH.Module_Code = MWD.Module_Code AND MSH.Module_Code=35
	INNER JOIN Syn_Deal SD ON MSH.Record_Code=SD.Syn_Deal_Code
	INNER JOIN Workflow_Module WM ON WM.Workflow_Code=SD.Work_Flow_Code AND WM.Module_Code=MSH.Module_Code AND WM.Business_Unit_Code=SD.Business_Unit_Code
									 AND (MSH.Status_Changed_On>=WM.Effective_Start_Date AND MSH.Status_Changed_On<=ISNULL(WM.System_End_Date,CONVERT(datetime,'31 Dec 9999')))  
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code=SD.Business_Unit_Code AND BU.Is_Active='Y'
	INNER JOIN Workflow_Module_Role WMR ON WMR.Workflow_Module_Code=WM.Workflow_Module_Code AND WMR.Group_Code=MWD.Group_Code AND WMR.Group_Level=MWD.Role_Level
	LEFT JOIN #TmpEmail_Config DEE ON DEE.BUCode= SD.Business_Unit_Code
	WHERE MWD.Module_Workflow_Detail_Code IN(
		SELECT MIN(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail
		WHERE Is_Done='N' and Module_Code = 35
		GROUP BY Record_Code,Module_Code,Is_Done
	) AND  MSH.Module_Status_Code IN (
		SELECT MAX(Module_Status_Code) FROM Module_Status_History WHERE Module_Code = 35 AND Record_Code IN (
			SELECT Syn_Deal_Code FROM Syn_Deal WHERE Deal_Workflow_Status = 'W'
		)
		GROUP BY Record_Code
	) --AND MSH.Status = 'W')
	AND (
		(
			(
				(DATEADD(d, @Mail_alert_days, MSH.Status_Changed_On) <= GETDATE()) OR
				(DATEDIFF(d, MSH.Status_Changed_On, GETDATE()) > @Mail_alert_days)
			) AND @Is_Daily='Y'
		) OR (
			(
				(dateadd(d, @Mail_alert_days, MSH.Status_Changed_On)=GETDATE()) OR
				(DATEDIFF(d,MSH.Status_Changed_On,GETDATE())=@Mail_alert_days)
			) AND @Is_Daily = 'N'
		)
	)


	IF EXISTS(SELECT * FROM #TempA)
	BEGIN
		DECLARE CurMail1 CURSOR FOR
		SELECT DISTINCT Email_Id FROM #TempA
		OPEN CurMail1
		FETCH NEXT FROM CurMail1 Into @Email_Id
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

		SET @EmailBody = '<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>'
		--SET @EmailBody2=''
			DECLARE CurMail2 CURSOR FOR
			SELECT DISTINCT Business_Unit_Name FROM #TempA where Email_Id=@Email_Id
			OPEN CurMail2
			FETCH NEXT FROM CurMail2 Into @Bu_Name
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				if EXISTS (SELECT * FROM #TempA t INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code=t.Record_Code 
				WHERE t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name)
				BEGIN
					SET @EmailBody1 = @EmailBody1 + '<tr><td colspan="6" style="padding: 8px 0px 3px 0px;">
										<b>Business Unit:'+@Bu_Name+' </b></td></tr>'
					SET @EmailBody1 = @EmailBody1 + '<tr>
						<th align="center" width="7%" ><b>Agreement No<b></th>
						<th align="center" width="5%" ><b>Agreement Date<b></th>
						<th align="center" width="12%" ><b>Deal Description<b></th>
						<th align="center" width="13%" ><b>Primary Licensor<b></th>
						<th align="center" width="12%" ><b>Title Name<b></th>
						<th align="center" width="10%" ><b>Pending Since (Days)<b></th>
						</tr>'
				
					DECLARE CurMail CURSOR FOR
					SELECT 
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

					FROM #TempA t
					INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code=t.Record_Code
					WHERE t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name
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
				FETCH NEXT FROM CurMail2 Into @Bu_Name
			END
			CLOSE CurMail2;
		DEALLOCATE CurMail2;
				
				SET @EmailHeader= '<html>
					<head>	<style>table {border-collapse: collapse;width: 100%;border-color:black}th, td {padding: 2px;border-color:black; Font-Size:12; font-family: verdana;}
						th {background-color: #c7c6c6;color: black;border-color:black}</style></head>
					<body>
						<Font FACE="verdana" SIZE="2" COLOR="Black">Hello User,<br /><br />
						The following Acquisition deals have not been approved:<br /><br />
						</Font>'
						
			DECLARE @EmailDetails NVarchar(max)
			if(@EmailBody!='')
			SET @EmailBody=@EmailBody +'</table>'
			SET @EmailDetails = @EmailHeader + @EmailBody  + @EmailFooter
			--select @EmailDetails,@Email_Id
			IF(@EmailDetails!='')
			BEGIN
					EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmailProfile,
					@recipients =  @Email_Id,
					@subject = @MailSubject,
					@body = @EmailDetails, 
					--@blind_copy_recipients = 'adesh@uto.in;vishal.onkar@uto.in',
					@body_format = 'HTML';
			END
			SEt @EmailDetails='' 	
			SET @EmailBody=''
			SET @EmailBody2=''

			FETCH NEXT FROM CurMail1 Into @Email_Id
		END
		CLOSE CurMail1;
		DEALLOCATE CurMail1
	END

	IF EXISTS(SELECT * FROM #TempS)
	BEGIN
	SET @EmailBody = ''
	SET @EmailBody1 = ''
	SET @EmailBody2 = ''
		DECLARE CurMail1 CURSOR FOR
	SELECT DISTINCT Email_Id FROM #TempS
	OPEN CurMail1
	FETCH NEXT FROM CurMail1 Into @Email_Id
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
			SET @EmailBody = '<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>'
			--SET @EmailBody1 = @EmailBody1 + '<tr>
			--		<th align="center" width="10%" ><b>Agreement No<b></th>
			--		<th align="center" width="20%" ><b>Agreement Date<b></th>
			--		<th align="center" width="20%" ><b>Deal Description<b></th>
			--		<th align="center" width="10%" ><b>Primary Licensor<b></th>
			--		<th align="center" width="20%" ><b>Title Name<b></th>
			--		<th align="center" width="20%" ><b>Pending Since (Days)<b></th>
			--	</tr>'
			SET @EmailBody2=''

			DECLARE CurMail2 CURSOR FOR
			SELECT DISTINCT Business_Unit_Name FROM #TempS where Email_Id=@Email_Id
			OPEN CurMail2
			FETCH NEXT FROM CurMail2 Into @Bu_Name
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				if EXISTS (SELECT * FROM #TempS t
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=t.Record_Code
			WHERE t.Email_Id=@Email_Id AND t.Business_Unit_Name=@Bu_Name)
				BEGIN
					SET @EmailBody1 = @EmailBody1 + '<tr><td colspan="6" style="padding: 8px 0px 3px 0px;">
										<b>Business Unit:'+@Bu_Name+' </b></td></tr>'
					SET @EmailBody1 = @EmailBody1 + '<tr>
						<th align="center" width="7%"  ><b>Agreement No<b></th>
						<th align="center" width="5%"  ><b>Agreement Date<b></th>
						<th align="center" width="12%" ><b>Deal Description<b></th>
						<th align="center" width="13%" ><b>Primary Licensor<b></th>
						<th align="center" width="12%" ><b>Title Name<b></th>
						<th align="center" width="10%"  ><b>Pending Since (Days)<b></th>
						</tr>'

			DECLARE CurMail CURSOR FOR
			SELECT 
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

			FROM #TempS t
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
			FETCH NEXT FROM CurMail2 Into @Bu_Name
			END
			CLOSE CurMail2;
		DEALLOCATE CurMail2;
			SET @EmailHeader= '<html>
				<head>	<style>table {border-collapse: collapse;width: 100%;border-color:black}th, td {padding: 2px;border-color:black; Font-Size:12; font-family: verdana;}
					th {background-color: #c7c6c6;color: black;border-color:black}</style></head>
				<body>
					<Font FACE="verdana" SIZE="2" COLOR="Black">Hello User,<br /><br />
					The following Syndication deals have not been approved:<br /><br />
					</Font>'
		if(@EmailBody!='')
		SET @EmailBody=@EmailBody +'</table>'
		SET @EmailDetails = @EmailHeader + @EmailBody  + @EmailFooter
		--select @EmailDetails,@Email_Id
		IF(@EmailDetails!='')
		BEGIN

			EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmailProfile,
				@recipients = @Email_Id,
				@subject = @MailSubject,
				@body = @EmailDetails, 
				@body_format = 'HTML';
		END
		SEt @EmailDetails='' 	
		SET @EmailBody=''
		SET @EmailBody1=''
		SET @EmailFooter=''
		SET @EmailHeader=''
		FETCH NEXT FROM CurMail1 Into @Email_Id
	END
	CLOSE CurMail1;
	DEALLOCATE CurMail1;
	END
END









