--EXEC USP_Email_Run_Utilization  'L','',2,'24'
--select * from Email_Notification_Log
CREATE PROCEDURE [dbo].[USP_Email_Run_Utilization]
(
	@Call_From CHAR(1),
	@Title_Codes VARCHAR(1000),
	@BU_Code INT=2,
	@Channel_Codes VARCHAR(1000)
)
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 21 Sept 2015
-- Description:	Email Notification
-- =============================================	
AS
BEGIN	
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END
	---------------------------------------------------------------		
	IF(ISNULL(@Call_From,'') = '')
	SET @Call_From = 'L'
	DECLARE @Users_Code INT, @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = 'LMR'
	--SELECT @Channel_Codes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Run_Expiry_ChannelCode'
	--SELECT @BU_Code = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Run_Expiry_BusinessUnit'
	SELECT User_Mail_Id, BuCode, Users_Code, Channel_Codes INTO #Temp from [dbo].[UFN_Get_Bu_Wise_User]('LMR')

	SELECT DISTINCT BuCode from #Temp
	SELECT DISTINCT Channel_Codes from #Temp

	SET @BU_Code = STUFF((SELECT DISTINCT ',' + CAST(BuCode AS VARCHAR(MAX)) 
				FROM #Temp FOR XML PATH('') ), 1, 1, '')

	SET @Channel_Codes = STUFF((SELECT DISTINCT ',' + CAST(Channel_Codes AS VARCHAR(MAX)) 
						FROM #Temp FOR XML PATH('') ), 1, 1, '')

	PRINT @Channel_Codes
	PRINT  @BU_Code
	IF OBJECT_ID('tempdb..#Html_Table') IS NOT NULL
	BEGIN
		DROP TABLE #Html_Table
	END	
	IF OBJECT_ID('tempdb..#Temp_Channel') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Channel
	END		
	IF OBJECT_ID('tempdb..#Result1') IS NOT NULL
	BEGIN
		DROP TABLE #Result1
	END	
	---------------------------------------------------------------
	CREATE TABLE #Html_Table
	(		
		RowID INT,
		html_data NVARCHAR(MAX)	
	)
	CREATE TABLE #Temp_Channel
	(		
		Channel_Name VARCHAR(500)
	)
	CREATE TABLE #Result1
	(
		Deal_no VARCHAR(250), 
		Deal_Desc NVARCHAR(MAX),
		Vendor NVARCHAR(MAX),
		Deal_Right_Code INT,
		Title_Name NVARCHAR(1000), 		
		Right_Start_date DATETIME,
		Right_End_date DATETIME,		 		
		Channel_Name NVARCHAR(1000), 												
		No_Of_Runs VARCHAR(50),
		Schedule_Run VARCHAR(50),
		Balance_Runs VARCHAR(50),
		Count_No_Of_Schedule VARCHAR(50)		
	)
	DECLARE @Column_Name_Count_Sch VARCHAR(20)='',@First_day_Of_Last_Month DateTime = GETDATE()
	SET @First_day_Of_Last_Month = DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	SET @Column_Name_Count_Sch  = 'Schedule of ' + CONVERT(VARCHAR(3), @First_day_Of_Last_Month, 100) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR)
	PRINT  'Column_Name_Count_Sch : '  + @Column_Name_Count_Sch  
	--------------------------------------------------------------		
	
	--INSERT INTO #Result
	INSERT INTO #Result1
	(
		Deal_no , 
		Deal_Desc,Vendor,
		Deal_Right_Code ,
		Title_Name , 		
		Right_Start_date ,
		Right_End_date ,		 		
		Channel_Name , 												
		No_Of_Runs ,
		Schedule_Run ,
		Balance_Runs ,
		Count_No_Of_Schedule 
	)
	EXEC USP_Last_Month_Utilization_Report '' ,@BU_Code ,@Channel_Codes
	--EXEC USP_Last_Month_Utilization_Report '' ,1 ,'23'
	--SELECT * FROM #Result1
	--RETURN 
	--------------------------------------------------------------		
	DECLARE @Channel_ColSpan INT= 4,@Agreement_No VARCHAR(100) = '', @Count_Index INT= 3,
	@Deal_Run_Email_Template_Desc VARCHAR(1000),@DefaultSiteUrl VARCHAR(500)='', @Email_header NVARCHAR(MAX) =''
	
	SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param			
	SELECT @Deal_Run_Email_Template_Desc =REPLACE(Template_Desc ,'{Link}',@DefaultSiteUrl) FROM  Email_Template 
	WHERE Template_For= 'USP_Email_Run_Utilization'			
	
	SET @Email_header = '<html>
				<head>
				<style>
					.tblFormat {border-collapse: collapse;} 
					.tblFormat td {margin: 0;padding: 2px 3px;font-family: ''segoe ui'',sans-serif;font-size: 14px;text-align: center;}
					.tdHeading {color: #fff;background-color: #6e9eca;font-weight: 700;}
					.tdSubHeading {color: #fff;background-color: SlateGray;}					
				</style>
				'+ @Deal_Run_Email_Template_Desc +'
				</head>'
	----------------------------------------------------------------------------------------------------------------------------				
	INSERT INTO #Html_Table(RowID,html_data)
	SELECT 1, 
	--'<html>
	--			<head>
	--			<style>
	--				.tblFormat {border-collapse: collapse;} 
	--				.tblFormat td {margin: 0;padding: 2px 3px;font-family: ''segoe ui'',sans-serif;font-size: 14px;text-align: center;}
	--				.tdHeading {color: #fff;background-color: #6e9eca;font-weight: 700;}
	--				.tdSubHeading {color: #fff;background-color: SlateGray;}					
	--			</style>
	--			'+ @Deal_Run_Email_Template_Desc +'
	--			</head>'+
				'<table border="5" class="tblFormat"><tr><td colspan="6"></td>'
	INSERT INTO #Html_Table(RowID,html_data)
	--SELECT 2 ,'<tr><td>Deal No</td><td>Title</td><td>Right Period</td>'
	SELECT 2 ,'<tr><th class="tdHeading">Deal No</th>
	<th class="tdHeading">Deal Description</th>
	<th class="tdHeading">Vendor</th>
	<th class="tdHeading">Title</th>
	<th class="tdHeading">Right Start Date</th>
	<th class="tdHeading">Right End Date</th>'	
	DECLARE @Deal_no VARCHAR(250), @Title_Name VARCHAR(250), @Rights_Period VARCHAR(50),@Deal_Movie_Code INT,@Channel_Code INT, @Channel_Name VARCHAR(2000)
	,@Schedule_Run VARCHAR(50),@No_Of_Runs VARCHAR(50),@Balance_Runs VARCHAR(50)
	,@Temp_Right_Period VARCHAR(100),@Right_Start_date DATETIME,@Right_End_date DATETIME,@Temp_Title_Name NVARCHAR(100)='',
	@Deal_Description NVARCHAR(MAX), @Vendor_Name NVARCHAR(200),@Count_No_Of_Schedule VARCHAR(50)
	
	
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
					
				UPDATE #Html_Table SET html_data = html_data 
				+ '<td class="tdSubHeading">No of Run</td>
				<td class="tdSubHeading">Schedule</td>
				<td class="tdSubHeading">Balance</td>
				<td class="tdSubHeading">'+@Column_Name_Count_Sch+'</td>' WHERE RowID = 2

 				UPDATE #Html_Table SET html_data = html_data + CAST('<td class="tdHeading" colspan=''' + CAST(@Channel_ColSpan AS VARCHAR) + '''>'+@Channel_Name+'</td>' AS VARCHAR(100))

				WHERE RowID = 1				
					FETCH NEXT FROM CUR_Channel INTO 
						@Channel_Name
			END
	CLOSE CUR_Channel
	DEALLOCATE CUR_Channel
	---------------------------------------------------------------------------------
	DECLARE CUR_Report CURSOR FOR 
				--SELECT  
				--	Deal_no,Title_Name,Right_Start_date,ISNULL(Right_End_date,'31DEC9999'),Channel_Name,Schedule_Run,No_Of_Runs ,Balance_Runs,Count_No_Of_Schedule 
				--FROM #Result1 ORDER BY Channel_Name
				SELECT  
					Deal_no, Title_Name, Right_Start_date, ISNULL(Right_End_date, '31DEC9999'), Channel_Name, Schedule_Run, No_Of_Runs ,Balance_Runs, Count_No_Of_Schedule,
					Deal_Desc, Vendor  
				FROM #Result1 ORDER BY Channel_Name
	OPEN CUR_Report
	PRINT 'Cursor'
				FETCH NEXT FROM CUR_Report 
					INTO @Deal_no,@Title_Name,@Right_Start_date,@Right_End_date,@Channel_Name,@Schedule_Run,@No_Of_Runs ,@Balance_Runs,@Count_No_Of_Schedule , @Deal_Description, @Vendor_Name
			WHILE (@@FETCH_STATUS = 0)
			BEGIN	
				SET	@Rights_Period = CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_Start_date,103), 106) + ' TO ' + CONVERT(VARCHAR(25), CONVERT(DATETIME,ISNULL(@Right_End_date,'31DEC9999'),103), 106)
				IF(@Balance_Runs='Unlimited')
				SET  @No_Of_Runs = 'Unlimited'
				--SELECT @Right_Start_date
				IF(@Agreement_No <> @Deal_no OR (@Agreement_No =  @Deal_no AND ((@Temp_Right_Period <> @Rights_Period)  OR (@Temp_Title_Name <> @Title_Name))))
				BEGIN						
					SET @Count_Index = @Count_Index + 1			
					INSERT INTO #Html_Table(RowID,html_data)				
					SELECT @Count_Index ,'<tr><td>'+@Deal_no+'</td><td>'+@Deal_Description+'</td><td>'+@Vendor_Name+'</td><td>'+@Title_Name+'</td><td>'+CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_Start_date,103), 106) +'</td><td>'+CONVERT(VARCHAR(25), CONVERT(DATETIME,@Right_End_date,103), 106) +'</td>'
				END
					UPDATE #Html_Table SET html_data = html_data + '<td>'+@No_Of_Runs+'</td><td>'+@Schedule_Run+'</td><td>'+@Balance_Runs+'</td><td>'+@Count_No_Of_Schedule+'</td>'				
					WHERE RowID = @Count_Index						
				SET  @Agreement_No = @Deal_no				
				SET  @Temp_Right_Period = @Rights_Period				
				SET @Temp_Title_Name = @Title_Name
				FETCH NEXT FROM CUR_Report INTO 
					@Deal_no,@Title_Name,@Right_Start_date,@Right_End_date,@Channel_Name,@Schedule_Run,@No_Of_Runs ,@Balance_Runs,@Count_No_Of_Schedule , @Deal_Description, @Vendor_Name
			END
	CLOSE CUR_Report
	DEALLOCATE CUR_Report
	---------------------------------------------------------------------------------
	UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID = 1
	UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID = 2
	SET @Count_Index = @Count_Index + 1		
	UPDATE #Html_Table SET html_data = html_data + '</tr>' WHERE RowID > 2 
	---------------------------------------------------------------------------------
	INSERT INTO #Html_Table(RowID,html_data)
	SELECT @Count_Index ,'</table>'
	
	---------------------------------------------------------------------------------
	DECLARE @Users_Email_Id VARCHAR(1000)='',@MailSubjectCr NVARCHAR(500)='',@Emailbody NVARCHAR(MAX)=''	
			--SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param			
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
			
			IF(@Call_From  = 'L')
				SET @MailSubjectCr = 'RightsU Email Alert : Last Month Run Utilization Report '--Expiration 
			ELSE IF(@Call_From = 'E')
				SET @MailSubjectCr = 'RightsU Email Alert : Rights Run Expiration Report'
			
			SELECT  @EmailUser_Body = @EmailUser_Body + html_data FROM #Html_Table 
			
			Set @Emailbody= @Email_header + @EmailUser_Body + @EMailFooter
			
			--SELECT *  FROM #Html_Table 
			--SET @EmailUser_Body ='Sagar'

			PRINT '@DatabaseEmail_Profile : ' + @DatabaseEmail_Profile
			PRINT '@@EMAil_User : ' + @Users_Email_Id
			PRINT '@@MailSubjectCr : ' + @MailSubjectCr
			PRINT '@@EmailUser_Body : ' + @EmailUser_Body
			
	IF(@EmailUser_Body != '')
	BEGIN
		DECLARE curOuter CURSOR FOR 
					SELECT DISTINCT BuCode, User_Mail_Id, Users_Code from #Temp
		--SELECT DISTINCT Business_Unit_Code,Users_Email_id FROM Deal_Expiry_Email 
		--WHERE Business_Unit_Code Is not Null And Alert_Type = 'L'
		OPEN curOuter 
		FETCH NEXT FROM curOuter INTO @BU_Code, @Users_Email_Id, @Users_Code
		WHILE (@@Fetch_Status = 0) 
		BEGIN		
			EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmail_Profile,
				@recipients =  @Users_Email_Id,
				@subject = @MailSubjectCr,
				@body = @Emailbody, 
				@body_format = 'HTML';  
				--PRINT '@recipients : ' + cast(@Users_Email_Id  AS VARCHAR)
				--select @Emailbody AS Emailbody
			INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @EmailUser_Body, @Users_Code, 'Last Month Run Utilization', @Users_Email_Id
		FETCH NEXT FROM curOuter INTO @BU_Code,@Users_Email_Id, @Users_Code
		END -- End of Fetch outer
		CLOSE curOuter
		DEALLOCATE curOuter	
	END
	----------------------------------------------------------------------------------

END