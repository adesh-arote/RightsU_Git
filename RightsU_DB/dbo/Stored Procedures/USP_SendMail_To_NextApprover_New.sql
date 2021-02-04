ALTER PROCEDURE [dbo].[USP_SendMail_To_NextApprover_New]
(
	@RecordCode Int=3
	,@Module_code Int=30
	,@RedirectToApprovalList Varchar(100)='N'
	,@AutoLoginUser Varchar(100)=143
	,@Is_Error Char(1) 	Output
)
AS
BEGIN	
	--declare
	--@RecordCode Int=21617
	--,@Module_code Int=30
	--,@RedirectToApprovalList Varchar(100)='N'
	--,@AutoLoginUser Varchar(100)=143
	--,@Is_Error Char(1) ='N'

	SET NOCOUNT ON;
	--DECLARE @Module_code INT --//--This  is a module code for Acquisition Deal	
	--SET @Module_code =30
	-- =============================================
	-- Declare and using a KEYSET cursor
	-- =============================================
	SET @Is_Error = 'N'
	BEGIN TRY

		DECLARE @Cur_first_name NVARCHAR(500)
		DECLARE @Cur_security_group_name NVARCHAR(500) 
		DECLARE @Cur_email_id NVARCHAR(500) 
		DECLARE @Cur_security_group_code NVARCHAR(500) 
		DECLARE @Cur_user_code INT

		DECLARE @DealType VARCHAR(100) 
		DECLARE @DealNo VARCHAR(500) = 0
		DECLARE @body1 NVARCHAR(MAX) = ''
		DECLARE @MailSubjectCr NVARCHAR(500)
		DECLARE @CC NVARCHAR(MAX) = ''
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
		DECLARE @DefaultSiteUrl_Param NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl NVARCHAR(500) = ''
		DECLARE @BU_Code Int = 0
		DECLARE @Email_Table NVARCHAR(MAX) = ''
		DECLARE @Email_Config_Code INT
		DECLARE @Acq_Deal_Rights_Code varchar(max)=''
		DECLARE @Promoter_Count int
		DECLARE @Promoter_Message varchar(max) =''
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='SFA'

		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param	--// FLAG FOR SEND MAIL TO INDIVIDUAL PERSON ON GROUP //--

		SET @DealType = ''
		IF(@Module_code = 30)
		BEGIN
			SELECT TOP 1  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode
			SELECT @Acq_Deal_Rights_Code   =  @Acq_Deal_Rights_Code + CAST(acq_deal_rights_Code AS varchar)+ ', '  FROM acq_deal_Rights WHERE Acq_Deal_Code = @RecordCode
			select @Promoter_Count = count(*) from Acq_Deal_Rights_Promoter where Acq_Deal_Rights_Code in (SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Code,',')) 
			IF(@Promoter_Count > 0)
			BEGIN
			 SET @Promoter_Message = 'Self Utilization Group details are  added for the deal'
			END
			ELSE
			BEGIN
			SET @Promoter_Message = 'Self Utilization Group details are not added for the deal'
			END

		END
		ELSE IF(@Module_code = 35)
		BEGIN
			SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal WHERE Syn_Deal_Code = @RecordCode
		END
		ELSE IF(@Module_code = 163)
		BEGIN
			SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal WHERE Music_Deal_Code = @RecordCode
		END

		DECLARE 
		@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
		@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0,@BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''

		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) 
			FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@Module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode
			
				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT  @Titles += CASE  WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@Module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
	
		/* SELECT SITE URL */
		DECLARE @DefaultSiteUrlHold NVARCHAR(500) ,  @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is waiting for approval' 

		SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

		IF(@Is_RU_Content_Category = 'Y')
			SET  @BU_CC= 'Content Category'

		--@Primary_User_Code is nothing by group code 
		/* TO SEND EMAIL TO INDIVIDUAL USER */
		DECLARE @Primary_User_Code INT = 0
		SELECT TOP 1 @Primary_User_Code = Group_Code  
		FROM Module_Workflow_Detail 
		WHERE Is_Done = 'N' AND Module_Code = @Module_code AND Record_Code = @RecordCode 
		ORDER BY Module_Workflow_Detail_Code

		/* CURSOR START */
		DECLARE Cur_On_Rejection CURSOR KEYSET FOR 
		SELECT DISTINCT U2.Email_Id ,ISNULL(U2.First_Name,'') + ' ' + ISNULL(U2.Middle_Name,'') + ' ' + ISNULL(U2.Last_Name,'') + 
		'   ('+ ISNULL(SG.Security_Group_Name,'') + ')', SG.Security_Group_Name, U2.Security_Group_Code, U2.Users_Code 
		FROM Users U1
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		WHERE U1.Security_Group_Code = @Primary_User_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'


		OPEN Cur_On_Rejection
		FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				
				SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=SA'
				
				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
					SET @Email_Table =	'<table class="tblFormat" >
					<tr>
						<td align="center" width="12%" class="tblHead">Agreement No.</td>      
						<td align="center" width="12%" class="tblHead">Agreement Date</td>      
						<td align="center" width="17%" class="tblHead">Deal Description</td>      
						<td align="center" width="12%" class="tblHead">Primary Licensor</td>      
						<td align="center" width="20%" class="tblHead">Title(s)</td>
						<td align="center" width="12%"  class="tblHead">'+@BU_CC+'</td>
					'
				END
				ELSE
				BEGIN 
					SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
							<td align="center" width="9%" class="tblHead">Agreement No.</td>    
							<td align="center" width="9%" class="tblHead">Agreement Date</td> 
							<td align="center" width="9%" class="tblHead">Created By</td> 
							<td align="center" width="9%" class="tblHead">Creation Date</td> 
							<td align="center" width="9%" class="tblHead">Deal Description</td> 
							<td align="center" width="9%" class="tblHead">Primary Licensor</td>   
							<td align="center" width="9%" class="tblHead">Title(s)</td>
							<td align="center" width="9%" class="tblHead">'+@BU_CC+'</td>
							<td align="center" width="9%" class="tblHead">Last Actioned By</td>
							<td align="center" width="9%" class="tblHead">Last Actioned Date</td>
					'
				END


			   IF(@DealType = 'Acquisition')
			   BEGIN
					SET @Email_Table += '<td align="center" width="10%" class="tblHead">Self Utilization</td>'
			   END   

			   SET @Email_Table += '</tr>'
			   
			   IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
				 SET @Email_Table += '<tr>      
						<td align="center" class="tblData">{Agreement_No}</td>     
						<td align="center" class="tblData">{Agreement_Date}</td>     
						<td align="center" class="tblData">{Deal_Desc}</td>     
						<td align="center" class="tblData">{Primary_Licensor}</td>  
						<td align="center" class="tblData">{Titles}</td>
						<td align="center" class="tblData">{BU_Name}</td>
				'
				END
				ELSE
				BEGIN
					 SET @Email_Table += ' <tr>
						<td align="center" class="tblData">{Agreement_No}</td>   
						<td align="center" class="tblData">{Agreement_Date}</td>    
						<td align="center" class="tblData">{Created_By}</td>    
						<td align="center" class="tblData">{Creation_Date}</td>    
						<td align="center" class="tblData">{Deal_Desc}</td>    
						<td align="center" class="tblData">{Primary_Licensor}</td>   
						<td align="center" class="tblData">{Titles}</td> 
						<td align="center" class="tblData">{BU_Name}</td> 
						<td align="center" class="tblData">{Last_Actioned_By}</td> 
						<td align="center" class="tblData">{Last_Actioned_Date}</td> 
					'
				END
			   IF(@DealType = 'Acquisition')
			   BEGIN
					SET @Email_Table += '<td align="center" class="tblData">{Promoter}</td>'
				END   
			
			SET @Email_Table += '</tr></table>'

				
				--REPLACE ALL THE PARAMETER VALUE
				SELECT @body1 = template_desc FROM Email_Template WHERE Template_For='A' 
				SET @body1 = replace(@body1,'{login_name}',@Cur_first_name)
				SET @body1 = replace(@body1,'{deal_no}',@DealNo)
				SET @body1 = replace(@body1,'{deal_type}',@DealType)
				set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)
				SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)

				SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
				SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
				SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
				SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
				SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
				SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)  
				IF(@DealType = 'Acquisition')
				BEGIN
					SET @Email_Table = replace(@Email_Table,'{Promoter}',@Promoter_Message)  
				END   

				IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
				BEGIN
					SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
					SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
				END

				SET @CC = ''
				--IF(@Is_Mail_Send_To_Group='Y')
				--BEGIN
				--	SELECT @CC = @CC + ';' + email_id FROM Users U
				--	INNER JOIN Users_Business_Unit UBU ON U.Users_Code =UBU.Users_Code AND 
				--	UBU.Business_Unit_Code IN (@BU_Code)
				--	WHERE security_group_code IN (@Cur_security_group_code) 
				--	AND UBU.Users_Code NOT IN(@Cur_user_code)
				--END
				
				SET @body1 = replace(@body1,'{table}',@Email_Table)

				DECLARE @DatabaseEmail_Profile varchar(200)	
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
				
				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile,
				@Recipients =  @Cur_email_id,
				@Copy_recipients = @CC,
				@subject = @MailSubjectCr,
				@body = @body1,@body_format = 'HTML';  

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id

				--select @body1

			END
			FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
		END

		CLOSE Cur_On_Rejection
		DEALLOCATE Cur_On_Rejection
		/* CURSOR END */
					 --select @DefaultSiteUrl
		SET @Is_Error='N'
	END TRY
	BEGIN CATCH
		SET @Is_Error='Y'
		CLOSE Cur_On_Rejection
		DEALLOCATE Cur_On_Rejection

		INSERT INTO	ERRORON_SENDMAIL_FOR_WORKFLOW 
		SELECT 
			ERROR_NUMBER() AS ERRORNUMBER,
			ERROR_SEVERITY() AS ERRORSEVERITY,		
			ERROR_STATE() AS ERRORSTATE,
			ERROR_PROCEDURE() AS ERRORPROCEDURE,
			ERROR_LINE() AS ERRORLINE,
			ERROR_MESSAGE() AS ERRORMESSAGE;
	END CATCH							
END



--update Email_Template SET template_desc =
--'<html>   <head>    <style>     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }    
-- th.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
-- font-size:12px; font-weight:bold    }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
-- font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }    
--       #divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear&nbsp;{login_name},<br />
--	   <br />     The {deal_type} Deal No: <b>{deal_no}</b> is waiting for approval.<br /><br />   
--	     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> to approve {deal_type} deal<br /><br />    </div>    
--		 {table}
--		 <br /><br /><br /><br /> 
--				     <div id="divFooter" class="textFont">    
--					  This email is generated by RightsU    </div>   </body>  </html>' WHERE Template_For='A'
