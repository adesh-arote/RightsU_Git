CREATE PROCEDURE [dbo].[USP_Email_Run_Expiry]
AS
BEGIN	
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Email_Run_Expiry]', 'Step 1', 0, 'Started Procedure', 0, '' 
	-- =============================================
	-- Author:		SAGAR MAHAJAN 
	-- Create date: 21 Sept 2015
	-- Description:	Email Notification
	-- =============================================
		SET NOCOUNT ON;
		---------------------------------------------------------------
		IF OBJECT_ID('tempdb..#Html_Table') IS NOT NULL
		BEGIN
			DROP TABLE #Html_Table
		END	
		IF OBJECT_ID('tempdb..#Temp_Channel') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Channel
		END		
		IF OBJECT_ID('tempdb..#Temp_Channel') IS NOT NULL
		BEGIN
			DROP TABLE #Result1
		END	
		---------------------------------------------------------------
		CREATE TABLE #Html_Table
		(		
			RowID INT,
			html_data VARCHAR(MAX)	,
			Table_ID INT
		)
		CREATE TABLE #Temp_Channel
		(		
			Channel_Name VARCHAR(500)
		)
		CREATE TABLE #Result1
		(
			Deal_no VARCHAR(250), 
			Title_Name NVARCHAR(250), 		
			Right_Start_date DateTime,
			Right_End_date DateTime,		 		
			Channel_Name NVARCHAR(50), 												
			No_Of_Runs INT,
			Schedule_Run INT,
			Balance_Runs VARCHAR(50),
			Expiry_In_Days INT,
			Deal_Desc NVARCHAR(MAX), -- (If run expiry report then Expiry in days)
			Vendor NVARCHAR(MAX)
		)
		--------------------------------------------------------------		
		DECLARE @Channel_Codes VARCHAR(1000), @BU_Code VARCHAR(100)	
		SELECT @Channel_Codes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Run_Expiry_ChannelCode'
		SELECT @BU_Code = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Run_Expiry_BusinessUnit'

		--INSERT INTO #Result
		INSERT INTO #Result1
		(
			Deal_no , 
			Title_Name , 		
			Right_Start_date ,
			Right_End_date ,		 		
			Channel_Name , 												
			No_Of_Runs ,
			Schedule_Run ,
			Deal_Desc ,
			Vendor,
			Expiry_In_Days
		)
		EXEC [USP_Acq_Run_Expiry_Report] @BU_Code ,@Channel_Codes
		--SELECT * FROM #Result1
		--RETURN 
		Declare @SendMail INT =0
		Declare @Business_Unit_Code int,@Users_Email_Id Varchar(100)
		DECLARE curOuter cursor For select distinct Business_Unit_Code,Users_Email_id from Deal_Expiry_Email (NOLOCK) where Business_Unit_Code Is not Null And Alert_Type = 'E'
		OPEN curOuter 
		Fetch Next From curOuter Into @Business_Unit_Code,@Users_Email_Id
		While @@Fetch_Status = 0 
		Begin		

			SET @SendMail = 0
			DECLARE @DefaultSiteUrl VARCHAR(500),@Deal_Expiry_Email_Template_Desc VARCHAR(2000) ='' ;	SET @DefaultSiteUrl = ''
			SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param (NOLOCK)

			SELECT @Deal_Expiry_Email_Template_Desc =REPLACE(Template_Desc ,'{Link}',@DefaultSiteUrl) FROM  Email_Template (NOLOCK) WHERE Template_For= 'USP_Email_Run_Expiry'			
				

			INSERT INTO #Html_Table(RowID, html_data, Table_ID)
			SELECT 1, '<html><head><style>table{border-collapse: collapse;} td {margin: 0;padding: 2px 3px;font-family: verdana,sans-serif;font-size: 10px;text-align: center;}
						.tdHeading {color: #fff;background-color: #6e9eca;font-weight: 700;}
						.tdSubHeading {color: #fff;background-color: SlateGray;}
						</style>
						'+ @Deal_Expiry_Email_Template_Desc +'
						</head>',0
				


			DECLARE @UL INT,@LL INT
			--Add new cur for slab
			Declare @Mail_alert_days_Body int, @Allow_less_Than CHAR(1), @Table_Cnt INT =1 
			Declare curBody cursor For 
		
			select distinct Mail_alert_days,Allow_less_Than from Deal_Expiry_Email (NOLOCK)
			Where Business_Unit_Code = @Business_Unit_Code And Users_Email_id = @Users_Email_Id And  Alert_Type = 'E'
			OPEN curBody 
			Fetch Next From curBody Into @Mail_alert_days_Body, @Allow_less_Than
			While @@Fetch_Status = 0 
			Begin

				SET @UL=0
				SET @LL=0
				IF(@Allow_less_Than = 'Y')
				BEGIN
					SET @LL=0
					SET @UL=@Mail_alert_days_Body
				END
				ELSE
				BEGIN			
						SET @LL=@Mail_alert_days_Body
						SET @UL=@Mail_alert_days_Body
				END
			
				DECLARE @CNT_RECORD INT = 0 
				SELECT  @CNT_RECORD = COUNT(*) FROM #Result1 WHERE Expiry_In_Days BETWEEN @LL And @UL And 0 <=  Expiry_In_Days
				--------------------------------------------------------------		

				IF(@CNT_RECORD > 0)
				BEGIN
				--SELECT @CNT_RECORD
			
				DECLARE @Channel_ColSpan INT= 3,@Agreement_No VARCHAR(100) = '', @Count_Index INT= 3
			
				INSERT INTO #Html_Table(RowID, html_data, Table_ID)
				SELECT 1, '<br><table border="2"><tr><td colspan="7" style="text-align:left"><b>Deals Expiring in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td>',@Table_Cnt
						
				
					INSERT INTO #Html_Table(RowID,html_data,Table_ID)
					SELECT 2 ,'<tr><td class="tdHeading">Deal No.</td><td class="tdHeading">Deal Description</td><td class="tdHeading">Vendor</td><td class="tdHeading">Title</td><td class="tdHeading">Right Start Date</td><td class="tdHeading">Right End Date</td><td class="tdHeading">Expiry In Days</td>',@Table_Cnt
				
					DECLARE @Deal_no VARCHAR(250), @Title_Name NVARCHAR(250), @Rights_Period VARCHAR(50),@Deal_Movie_Code INT,@Channel_Code INT, @Channel_Name NVARCHAR(2000)
					,@Schedule_Run VARCHAR(50),@No_Of_Runs VARCHAR(50),@Balance_Runs VARCHAR(50),@Expiry_In_Days VARCHAR(50)
					,@Temp_Right_Period VARCHAR(100),@Right_Start_date DATETIME,@Right_End_date DATETIME,@Temp_Title_Name NVARCHAR(100)='',
					@Deal_Description NVARCHAR(MAX), @Vendor_Name NVARCHAR(200)
					-----------------------------------------------------------------------
					DECLARE CUR_Channel CURSOR FOR 
								SELECT DISTINCT Channel_Name FROM #Result1 ORDER BY Channel_Name
					OPEN CUR_Channel
								FETCH NEXT FROM CUR_Channel 
									INTO @Channel_Name
							WHILE (@@FETCH_STATUS = 0)
							BEGIN			
								INSERT INTO #Temp_Channel(Channel_Name)
								SELECT @Channel_Name

								UPDATE #Html_Table SET html_data = html_data + '<td class="tdSubHeading">No of Runs</td><td class="tdSubHeading">Schedule</td><td class="tdSubHeading">Balance</td>' WHERE RowID = 2 AND Table_ID = @Table_Cnt

 								UPDATE #Html_Table SET html_data = html_data + CAST('<td class="tdHeading" colspan=''' + CAST(@Channel_ColSpan AS VARCHAR) + '''>'+@Channel_Name+'</td>' AS VARCHAR(100))
								WHERE RowID = 1	AND Table_ID = @Table_Cnt

								FETCH NEXT FROM CUR_Channel INTO 
								@Channel_Name
							END
					CLOSE CUR_Channel
					DEALLOCATE CUR_Channel

	
					---------------------------------------------------------------------------------
					DECLARE CUR_Report CURSOR FOR 
								SELECT  
									Deal_no, Title_Name, Right_Start_date, ISNULL(Right_End_date, '31DEC9999'), Channel_Name, Schedule_Run, No_Of_Runs ,Balance_Runs, Expiry_In_Days,
									Deal_Desc, Vendor  
								FROM #Result1 
								WHERE Expiry_In_Days BETWEEN @LL And @UL
								And 0 <=  Expiry_In_Days
								ORDER BY Expiry_In_Days, Channel_Name
					OPEN CUR_Report
					FETCH NEXT FROM CUR_Report 
						INTO @Deal_no, @Title_Name, @Right_Start_date, @Right_End_date, @Channel_Name, @Schedule_Run, @No_Of_Runs , @Balance_Runs, @Expiry_In_Days, @Deal_Description, @Vendor_Name 
					WHILE (@@FETCH_STATUS = 0)
					BEGIN	

						SET @SendMail = 1

						SET	@Rights_Period = CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_Start_date,103), 106) + ' TO ' + CONVERT(VARCHAR(25), CONVERT(DATETIME,ISNULL(@Right_End_date,'31DEC9999'),103), 106)

						--SELECT @Right_Start_date
						IF(@Agreement_No <> @Deal_no OR (@Agreement_No =  @Deal_no AND ((@Temp_Right_Period <> @Rights_Period)  OR (@Temp_Title_Name <> @Title_Name))))
						BEGIN						

							SET @Count_Index = @Count_Index + 1			
							INSERT INTO #Html_Table(RowID,html_data, Table_ID)				
							SELECT @Count_Index ,'<tr><td>' + @Deal_no + '</td><td>' + @Deal_Description + '</td><td>' + @Vendor_Name + '</td><td>' + @Title_Name + '</td><td>' + CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_Start_date,103), 106) + '</td><td>' + CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_End_date,103), 106) + '</td><td>' + @Expiry_In_Days + '</td>',@Table_Cnt
						END
							UPDATE #Html_Table SET html_data = html_data + '<td>' + @No_Of_Runs + '</td><td>' + @Schedule_Run + '</td><td>' + CAST((CAST(ISNULL(@No_Of_Runs, 0) AS INT) - CAST(ISNULL(@Schedule_Run, 0) AS INT)) AS VARCHAR(100)) +'</td>'				
							WHERE RowID = @Count_Index	AND TAble_ID=@Table_Cnt					
						SET  @Agreement_No = @Deal_no				
						SET  @Temp_Right_Period = @Rights_Period				
						SET @Temp_Title_Name = @Title_Name

		
					FETCH NEXT FROM CUR_Report INTO 
						@Deal_no, @Title_Name, @Right_Start_date, @Right_End_date, @Channel_Name, @Schedule_Run, @No_Of_Runs , @Balance_Runs, @Expiry_In_Days , @Deal_Description, @Vendor_Name
					END
					CLOSE CUR_Report
					DEALLOCATE CUR_Report

					END
					---------------------------------------------------------------------------------
					UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID = 1 AND Table_ID = @Table_Cnt
					UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID = 2 AND Table_ID = @Table_Cnt
			
					UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID > 2  AND Table_ID = @Table_Cnt
					---------------------------------------------------------------------------------
					INSERT INTO #Html_Table(RowID,html_data,Table_ID)
					SELECT @Count_Index ,'</table></html>',@Table_Cnt
			
					SET @Table_Cnt =@Table_Cnt+1

					Fetch Next From curBody Into @Mail_alert_days_Body,@Allow_less_Than
					End -- End of Fetch body
					Close curBody
					Deallocate curBody

			
				SET @Count_Index = @Count_Index + 1		
				---------------------------------------------------------------------------------
				DECLARE @MailSubjectCr NVARCHAR(500)='',@Emailbody NVARCHAR(500)=''	
				DECLARE @EMailFooter NVARCHAR(200),@EmailHead NVARCHAR(max)
						SET @EMailFooter ='&nbsp;</br>&nbsp;</br>Regards,</br>
											RightsU Support</br>
											U-TO Solutions</body></html>'
						DECLARE @DatabaseEmail_Profile varchar(200)	
						SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
						SELECT @DatabaseEmail_Profile AS  DatabaseEmail_Profile
			
						Print @Emailbody
						DECLARE @EmailUser_Body NVARCHAR(Max)=''
						--Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
			
						SET @MailSubjectCr = 'RightsU Email Alert : Rights Run Expiration Report'
			
						SELECT  @EmailUser_Body = @EmailUser_Body + html_data  FROM #Html_Table 
						
						SELECT  @EmailUser_Body + @EMailFooter

						--SELECT *  FROM #Html_Table 
						--SET @EmailUser_Body ='Sagar'

						PRINT '@DatabaseEmail_Profile : ' + @DatabaseEmail_Profile
						PRINT '@@EMAil_User : ' + @Users_Email_Id
						PRINT '@@MailSubjectCr : ' + @MailSubjectCr
						PRINT '@@EmailUser_Body : ' + @EmailUser_Body 

						IF(@SendMail = 1)
						BEGIN
							EXEC msdb.dbo.sp_send_dbmail 
								@profile_name = @DatabaseEmail_Profile,
								@recipients =  @Users_Email_Id,
								@subject = @MailSubjectCr,
								@body = @EmailUser_Body, 
								@body_format = 'HTML';  
							PRINT '@recipients : ' + cast(@Users_Email_Id  as NVARCHAR)
						END

			----------------------------------------------------------------------------------
		Fetch Next From curOuter Into @Business_Unit_Code,@Users_Email_Id
		End -- End of Fetch outer
		Close curOuter
		Deallocate curOuter		

		IF OBJECT_ID('tempdb..#Html_Table') IS NOT NULL DROP TABLE #Html_Table
		IF OBJECT_ID('tempdb..#Result') IS NOT NULL DROP TABLE #Result
		IF OBJECT_ID('tempdb..#Result1') IS NOT NULL DROP TABLE #Result1
		IF OBJECT_ID('tempdb..#Temp_Channel') IS NOT NULL DROP TABLE #Temp_Channel
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Email_Run_Expiry]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END