CREATE PROCEDURE [dbo].[USPDealExpiryMailForTitleMilestone] 
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2) Exec [USPLogSQLSteps] '[USPDealExpiryMailForTitleMilestone]', 'Step 1', 0, 'Started Procedure', 0, ''
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
		SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config (NOLOCK) where [Key] = 'TME'
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
							FROM Title_Milestone TM (NOLOCK)
								INNER JOIN Title T (NOLOCK) ON T.Title_Code = Tm.Title_Code
								INNER JOIN Talent TL (NOLOCK) ON TL.Talent_Code = TM.Talent_Code
								INNER JOIN Milestone_Nature MN  (NOLOCK) ON MN.Milestone_Nature_Code = TM.Milestone_Nature_Code
							WHERE CONVERT(DATE,TM.Expiry_Date,106) BETWEEN CONVERT(DATE,GETDATE(),106) AND @EndRange AND TM.Is_Abandoned = 'N' --AND TM.Title_Code = @Title_code
						END
						ELSE IF @i = 2
						BEGIN
							SET @TableHeader = 'MILESTONES/ DATES THAT HAVE EXPIRED'
							INSERT INTO #tempExpired (Title_Milestone_Code,Title_Code,TitleNameExpired,TalentNameExpired,MilestonenatureNameExpired,ExpiryDateExpired,MilestoneExpired,ActionItemExpired)
							SELECT TM.Title_Milestone_Code ,T.Title_Code,T.Title_Name ,TL.Talent_Name ,MN.Milestone_Nature_Name,CONVERT(VARCHAR(100),TM.Expiry_Date,106) ,TM.Milestone , TM.Action_Item 
							FROM Title_Milestone TM (NOLOCK)
								INNER JOIN Title T (NOLOCK) ON T.Title_Code = Tm.Title_Code
								INNER JOIN Talent TL (NOLOCK) ON TL.Talent_Code = TM.Talent_Code
								INNER JOIN Milestone_Nature MN (NOLOCK) ON MN.Milestone_Nature_Code = TM.Milestone_Nature_Code
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
								--EXEC msdb.dbo.sp_send_dbmail 
								--@profile_name = @DatabaseEmail_Profile,
								--@recipients =  @To_User_Mail_Id,
								--@copy_recipients = @CC_User_Mail_Id,
								--@blind_copy_recipients = @BCC_User_Mail_Id,
								--@subject = @MailSubjectCr,
								--@body = @EmailUser_Body, 
								--@body_format = 'HTML';

								INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
								SELECT @Email_Config_Code,@EmailUser_Body, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), @MailSubjectCr
				

							FETCH NEXT FROM cPointer INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
							END
						CLOSE cPointer
						DEALLOCATE cPointer
		
			EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

			IF OBJECT_ID('tempdb..#tempEmail') IS NOT NULL DROP TABLE #tempEmail
			IF OBJECT_ID('tempdb..#tempExpired') IS NOT NULL DROP TABLE #tempExpired
			IF OBJECT_ID('tempdb..#TempIsab') IS NOT NULL DROP TABLE #TempIsab
	
	if(@Loglevel< 2) Exec [USPLogSQLSteps] '[USPDealExpiryMailForTitleMilestone]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''		
END

