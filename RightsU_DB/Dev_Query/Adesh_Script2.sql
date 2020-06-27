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
	@Business_Unit_Code INT, @Title_Name NVARCHAR(MAX), @Platform NVARCHAR(MAX), @Agreement_No NVARCHAR(100), @PeriodFrom VARCHAR(100), @PeriodTo VARCHAR(100), 
	@Region NVARCHAR(max), @Title_Language NVARCHAR(MAX), @Subtitling NVARCHAR(MAX), @Dubbing NVARCHAR(MAX), @Exists_In NVARCHAR(MAX), @ErrorMsg NVARCHAR(MAX), 
	@CAgreement_No NVARCHAR(100), @Vendor_Name VARCHAR(MAX)

	DECLARE CurMail2 CURSOR FOR
	select Users_Email_id,Business_Unit_Code from Deal_Expiry_Email where Alert_Type='E' --order by Business_Unit_Code desc
	OPEN CurMail2
	FETCH NEXT FROM CurMail2 Into @Users_Email_id,@Business_Unit_Code
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF ((SELECT COUNT(*) FROM Syn_Deal_Rights_Error_Details	AS SDE
			INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
			WHERE SDE.Inserted_On<= GETDATE() AND SDE.Inserted_On >= (GETDATE()-1) AND SD.Business_Unit_Code=@Business_Unit_Code)>0)
		BEGIN
			SET @EmailBody = '<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>'
		END
		SET @MailSubject = 'RightsU Error On Syndication Rights '
		SELECT @DatabaseEmailProfile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'  

		DECLARE CurMail1 CURSOR FOR
		SELECT DISTINCT SDE.ErrorMsg
		FROM Syn_Deal_Rights_Error_Details AS SDE
		INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
		WHERE SDE.Inserted_On<= GETDATE() AND SDE.Inserted_On >= (GETDATE()-1) AND SD.Business_Unit_Code=@Business_Unit_Code 
		OPEN CurMail1
		FETCH NEXT FROM CurMail1 Into @ErrorMsg
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			IF ((SELECT COUNT(*) FROM Syn_Deal_Rights_Error_Details	AS SDE
				INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code =SDE.Syn_Deal_Rights_Code
				INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
				WHERE SDE.Inserted_On<= GETDATE() AND SDE.Inserted_On >= (GETDATE()-1) AND SDE.ErrorMsg=@ErrorMsg AND SD.Business_Unit_Code=@Business_Unit_Code)>0)
				BEGIN
					SET @EmailBody1 = '<tr><td colspan="10" style="padding: 8px 0px 3px 0px;">
								<b>Error Description:'+@ErrorMsg+' </b></td></tr>'

					SET @EmailBody1 = @EmailBody1 + '<tr><th align="center" width="10%" ><b>Title Name<b></th>
						<th align="center" width="10%" ><b>Platform<b></th>
						<th align="center" width="10%" ><b>Agreement No<b></th>
						<th align="center" width="10%" ><b>Conflicted Agreement No<b></th>
						<th align="center" width="10%" ><b>Period<b></th>
						<th align="center" width="10%" ><b>Region<b></th>
						<th align="center" width="5%" ><b>Title Language<b></th>
						<th align="center" width="10%" ><b>Subtitling<b></th>
						<th align="center" width="10%" ><b>Dubbing<b></th>
						<th align="center" width="10%" ><b>Primary Licensor<b></th>
						<th align="center" width="5%" ><b>Exists In<b></th>
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
				WHERE SDE.Inserted_On<= GETDATE() AND SDE.Inserted_On >= (GETDATE()-1) AND SDE.ErrorMsg=@ErrorMsg AND SD.Business_Unit_Code=@Business_Unit_Code
				OPEN CurMail
				FETCH NEXT FROM CurMail Into @Title_Name, @Platform ,@Agreement_No,@CAgreement_No, @PeriodFrom, @PeriodTo, @Region,
				 @Title_Language, @Subtitling, @Dubbing, @Exists_In, @Vendor_Name
				WHILE(@@FETCH_STATUS = 0)
				BEGIN
					SET @EmailBody2 = Isnull(@EmailBody2, ' ')+'<tr>
								<td align="center" width="10%" >'+Isnull(@Title_Name, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@Platform, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@Agreement_No, ' ')+'</td>
								<td align="center" width="10%" >'+Isnull(@CAgreement_No, ' ')+'</td>'
								+'<td align="center" width="20%" >'+
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
								<td align="center" width="10%" >'+Isnull(@Vendor_Name, ' ')+'</td>
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
						<Font FACE="verdana" SIZE="2" COLOR="Black">Hello User,<br /><br />
						The following Syndication deals have gone in error:<br /><br />
						</Font>'

				SET @EmailFooter = '&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="2" COLOR="Black">
									(This is a system generated mail. Please do not reply back to the same)</b></br></br></font>
									<FONT FACE="verdana" SIZE="2" COLOR="Black">
									Thanks & Regards,</font></br>
									<FONT FACE="verdana" SIZE="2" COLOR="Black">
									RightsU System</br></font></body></html>'
	
			FETCH NEXT FROM CurMail1 Into @ErrorMsg
		END
		CLOSE CurMail1;
		DEALLOCATE CurMail1;
		DECLARE @EmailDetails NVARCHAR(max)
		if(@EmailBody!='')
		SET @EmailBody=@EmailBody +'</table>'
		SET @EmailDetails = @EmailHeader + @EmailBody  + @EmailFooter
		--select @EmailDetails,@Users_Email_id,@Business_Unit_Code
		IF(@EmailDetails!='')
		EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmailProfile,
			@recipients =  @Users_Email_id,--@UsersEmailId,
			@subject = @MailSubject,
			@body = @EmailDetails, 
			@body_format = 'HTML';
		SEt @EmailDetails='' 	
		SET @EmailBody=''
		SET @EmailFooter=''
		SET @EmailHeader=''
		FETCH NEXT FROM CurMail2 Into @Users_Email_id,@Business_Unit_Code	
	END	
	CLOSE CurMail2;
	DEALLOCATE CurMail2;
END