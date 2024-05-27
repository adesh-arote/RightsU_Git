ALTER Procedure [dbo].[USP_SendMail_On_Rejection]   
	 @RecordCode INT,
	 @module_workflow_detail_code INT,
	 @module_code INT,
	 @RedirectToApprovalList VARCHAR(100),
	 @AutoLoginUser VARCHAR(100),
	 @Login_User INT,
	 @Is_Error CHAR(1) OUTPUT  
AS  
-- =============================================  
-- Author:		<Adesh P Arote>
-- Create date: 02-FEB-2011
-- Description: SEND MAIL TO ALL LAST APPROVER IF DEAL IS REJECT FORM ANY USER  
-- =============================================  
BEGIN 
	 Declare @Loglevel int;
	 select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	 if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_On_Rejection]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE 
		--@RecordCode INT =15226,
		--@module_workflow_detail_code INT = 37288,
		--@module_code INT = 30,
		--@RedirectToApprovalList VARCHAR(100)='Y',
		--@AutoLoginUser VARCHAR(100)='Y',
		--@Login_User VARCHAR(100) = 204,
		--@Is_Error CHAR(1) = 'N'

		SET @Is_Error='N'  
		BEGIN TRY  
			DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 
			DECLARE @Rejected_by NVARCHAR(500) SET @Rejected_by=''  
			DECLARE @cur_first_name NVARCHAR(500)  
			DECLARE @cur_security_group_name NVARCHAR(500)   
			DECLARE @cur_email_id NVARCHAR(500)   
			DECLARE @cur_security_group_code VARCHAR(500)   
			DECLARE @cur_user_code INT  
			DECLARE @DealType VARCHAR(100)   
			DECLARE @DealNo VARCHAR(500) SET @DealNo=0  
			DECLARE @body1 NVARCHAR(MAX)  SET @body1 =''  
			DECLARE @MailSubjectCr NVARCHAR(500)  
			DECLARE @CC NVARCHAR(MAX)SET @CC =''  
			DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
			DECLARE	@DefaultSiteUrl_Param  NVARCHAR(500) = ''
			DECLARE @DefaultSiteUrl NVARCHAR(500) SET @DefaultSiteUrl = ''  
			DECLARE @BUCode INT = 0 
			DECLARE @Email_Table NVARCHAR(MAX) = ''
			DECLARE @Alert_Type CHAR(4)

			--DECLARE @Email_Config_Code INT
			--SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config (NOLOCK) WHERE [Key]='ASCM'
 
			SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param  
  
			SELECT @Rejected_by = ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
			FROM Users U   (NOLOCK)
				INNER JOIN Security_Group SG (NOLOCK) ON SG.Security_Group_Code = U.Security_Group_Code  
			WHERE Users_Code   = @Login_User 

			--IF(@module_code = 30)
			--BEGIN
			--	SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Acquisition'
			--	FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @RecordCode 
			--END
			--ELSE IF(@module_code = 35)
			--BEGIN
			--	SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Syndication'
			--	FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @RecordCode 
			--END
			--ELSE IF(@module_code = 163)
			--BEGIN
			--	SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Music'
			--	FROM Music_Deal (NOLOCK)  WHERE Music_Deal_Code = @RecordCode 
			--END
			--ELSE IF(@Module_code = 262)
			--BEGIN
			--	SELECT @DealNo = Proposal_No, @BUCode = 1, @DealType = 'Recommendation'
			--	FROM AL_Recommendation ar
			--		INNER JOIN AL_Proposal ap ON ar.AL_Proposal_Code = ap.AL_Proposal_Code 
			--	WHERE ar.AL_Recommendation_Code = @RecordCode
			--END
			--ELSE IF(@Module_code = 265)
			--BEGIN
			--	SELECT @DealNo = ISNULL(absh.Booking_Sheet_No,''), @BUCode = 1, @DealType = 'PurchaseOrder'
			--	FROM AL_Purchase_Order apo
			--		INNER JOIN AL_Proposal ap ON apo.AL_Proposal_Code = ap.AL_Proposal_Code 
			--		INNER JOIN AL_Booking_Sheet absh ON absh.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code
			--	WHERE apo.AL_Purchase_Order_Code = @RecordCode
			--END

			DECLARE 
				@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
				@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0, @BU_Name VARCHAR(MAX) = '',
				@Proposal_No NVARCHAR(MAX) = '', @Airline_Name NVARCHAR(MAX) = '', @Proposal_Start_Date NVARCHAR(MAX) = '', @Proposal_End_Date NVARCHAR(MAX) = '', @Total_Movies NVARCHAR(MAX) = 0,
				@Total_Show NVARCHAR(MAX) = 0, @Cycle_Start_Date NVARCHAR(MAX) = '', @Cycle_End_Date NVARCHAR(MAX) = '', @Total_Movie_BO NVARCHAR(MAX) = 0, @Total_Show_BO NVARCHAR(MAX) = 0,
				@No_Of_Movie_PO NVARCHAR(MAX) = 0, @No_Of_Show_PO NVARCHAR(MAX) = 0

            DECLARE @Created_By  VARCHAR(MAX) = '',
					@Creation_Date  VARCHAR(MAX) = '',
					@Last_Actioned_By  VARCHAR(MAX) = '',
					@Last_Actioned_Date  VARCHAR(MAX) = ''

			IF(@RecordCode > 0)
			BEGIN
				SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

				IF(@module_code = 30)
				BEGIN
					SET @Alert_Type = 'AAR'
					
					SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Acquisition'
					FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @RecordCode 

					PRINT 'Acquisition Deal Module'
					SELECT TOP 1 
						@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
						@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name
					FROM Acq_Deal AD (NOLOCK)
						INNER JOIN Vendor V (NOLOCK) ON AD.Vendor_Code = V.Vendor_Code
						INNER JOIN Business_Unit BU  (NOLOCK) ON BU.Business_Unit_Code = AD.Business_Unit_Code
					WHERE Acq_Deal_Code = @RecordCode

					SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Acq_Deal_Movie (NOLOCK) where Acq_Deal_Code = @RecordCode
					IF( @Title_Count > @Max_Titles_In_Approval_Mail)
					BEGIN
						SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
					END
					ELSE
					BEGIN
						SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
						FROM (
							SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM (NOLOCK)
							INNER JOIN Title T (NOLOCK) ON ADM.Title_Code = T.Title_Code
							WHERE Acq_Deal_Code = @RecordCode
						) AS A
					END
				END
				ELSE IF(@module_code = 35)
				BEGIN
					SET @Alert_Type = 'SAR'
					
					SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Syndication'
					FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @RecordCode 

					PRINT 'Syndication Deal Module'
					SELECT TOP 1 
						@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(varchar(15), Agreement_Date, 106), 
						@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name
					FROM Syn_Deal SD (NOLOCK)
						INNER JOIN Vendor V  (NOLOCK) ON SD.Vendor_Code = V.Vendor_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = SD.Business_Unit_Code
					WHERE Syn_Deal_Code = @RecordCode

					SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Syn_Deal_Movie (NOLOCK) where Syn_Deal_Code = @RecordCode
					IF( @Title_Count > @Max_Titles_In_Approval_Mail)
					BEGIN
						SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
					END
					ELSE
					BEGIN
						SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
						FROM (
							SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM (NOLOCK)
							INNER JOIN Title T (NOLOCK) ON SDM.Title_Code = T.Title_Code
							WHERE Syn_Deal_Code = @RecordCode
						) AS A
					END
				END
				ELSE IF(@module_code = 163)
				BEGIN
					SET @Alert_Type = 'MAR'

					SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Music'
					FROM Music_Deal (NOLOCK)  WHERE Music_Deal_Code = @RecordCode 

					PRINT 'Music Deal Module'
					SELECT TOP 1 
						@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
						@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name, @BU_Name =BU.Business_Unit_Name
					FROM Music_Deal MD (NOLOCK)
						INNER JOIN Vendor V  (NOLOCK) ON MD.Primary_Vendor_Code = V.Vendor_Code
						INNER JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MD.Music_Label_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = MD.Business_Unit_Code
					WHERE Music_Deal_Code = @RecordCode
				END
				ELSE IF(@module_code = 262)
				BEGIN
					SET @Alert_Type = 'RAR'

					SELECT @DealNo = Proposal_No, @BUCode = 1, @DealType = 'Recommendation'
					FROM AL_Recommendation ar
						INNER JOIN AL_Proposal ap ON ar.AL_Proposal_Code = ap.AL_Proposal_Code 
					WHERE ar.AL_Recommendation_Code = @RecordCode

					PRINT 'Recommendation Module'

					SELECT TOP 1 @DealNo = ISNULL(alp.Proposal_No,''), @Airline_Name = ISNULL((SELECT TOP 1 Vendor_Name FROM Vendor WHERE Vendor_Code = alp.Vendor_Code),''),
						@Proposal_Start_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alp.Start_Date, 106))),' ','-'),''), @Proposal_End_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alp.End_Date, 106))),' ','-'),''),
						@Total_Movies = (SELECT COUNT(*) FROM AL_Recommendation_Content arc INNER JOIN AL_Vendor_Rule avr ON arc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code WHERE AL_Recommendation_Code = @RecordCode AND Rule_Type = 'M'),
						@Total_Show = (SELECT COUNT(*) FROM AL_Recommendation_Content arc INNER JOIN AL_Vendor_Rule avr ON arc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code WHERE AL_Recommendation_Code = @RecordCode AND Rule_Type = 'S'),
						@Creation_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alp.Inserted_On, 106))),' ','-'),''),
						@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
															+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
															+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), ''),
						@Last_Actioned_By = ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
															+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
															+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '')
					FROM AL_Proposal alp
						INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code 
						LEFT JOIN Users U1 (NOLOCK) ON U1.Users_Code = alp.Inserted_By
						LEFT JOIN Users U2 (NOLOCK) ON U2.Users_Code = alr.Last_Action_By WHERE alr.AL_Recommendation_Code = @RecordCode;

					SET @BUCode = 1;

				END
				ELSE IF(@module_code = 265)
				BEGIN
					SET @Alert_Type = 'PAR'

					SELECT @DealNo = ISNULL(absh.Booking_Sheet_No,''), @BUCode = 1, @DealType = 'PurchaseOrder'
					FROM AL_Purchase_Order apo
						INNER JOIN AL_Proposal ap ON apo.AL_Proposal_Code = ap.AL_Proposal_Code 
						INNER JOIN AL_Booking_Sheet absh ON absh.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code
					WHERE apo.AL_Purchase_Order_Code = @RecordCode

					PRINT 'Purchase Order Module'

					Select TOP 1 @Proposal_No = ISNULL(alp.Proposal_No,''), @DealNo = ISNULL(absh.Booking_Sheet_No,''), @Airline_Name = ISNULL((SELECT TOP 1 Vendor_Name FROM Vendor WHERE Vendor_Code = absh.Vendor_Code),''),
						@Cycle_Start_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alr.Start_Date, 106))),' ','-'),''), @Cycle_End_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alr.End_Date, 106))),' ','-'),''),
						@Total_Movie_BO = ISNULL(Movie_Content_Count,0), @Total_Show_BO = ISNULL(Show_Content_Count,0),
						@No_Of_Movie_PO = (SELECT Count(apor1.AL_Purchase_Order_Rel_Code) FROM AL_Purchase_Order_Rel apor1 
								INNER JOIN AL_Purchase_Order_Details apod1 ON apod1.AL_Purchase_Order_Details_Code = apor1.AL_Purchase_Order_Details_Code 
								INNER JOIN AL_Purchase_Order apo1 ON apo1.AL_Purchase_Order_Code = apor1.AL_Purchase_Order_Code
								INNER JOIN Title t1 ON t1.Title_Code = apod1.Title_Code AND t1.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),','))
						WHERE apor1.Status = 'N' AND apor1.AL_Purchase_Order_Code = apo.AL_Purchase_Order_Code),
						@No_Of_Show_PO = (SELECT Count(apor1.AL_Purchase_Order_Rel_Code) FROM AL_Purchase_Order_Rel apor1 
								INNER JOIN AL_Purchase_Order_Details apod1 ON apod1.AL_Purchase_Order_Details_Code = apor1.AL_Purchase_Order_Details_Code 
								INNER JOIN AL_Purchase_Order apo1 ON apo1.AL_Purchase_Order_Code = apor1.AL_Purchase_Order_Code
								INNER JOIN Title t1 ON t1.Title_Code = apod1.Title_Code AND t1.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
						WHERE apor1.Status = 'N' AND apor1.AL_Purchase_Order_Code = apo.AL_Purchase_Order_Code),
						@Creation_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), apo.Inserted_On, 106))),' ','-'),''),
						@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
															+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
															+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '')
					FROM AL_Proposal alp
						INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code 
						INNER JOIN AL_Purchase_Order  apo ON apo.AL_Proposal_Code = alp.AL_Proposal_Code
						INNER JOIN AL_Booking_Sheet absh ON absh.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code AND absh.AL_Recommendation_Code = alr.AL_Recommendation_Code
						LEFT JOIN Users U1 ON U1.Users_Code = apo.Inserted_By
						LEFT JOIN Users U2 ON U2.Users_Code = apo.Updated_By WHERE apo.AL_Purchase_Order_Code = @RecordCode;

					SET @BUCode = 1;

				END
			END

			DECLARE @DefaultSiteUrlHold NVARCHAR(500)
			SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param 
			
			--IF(@module_code = 262)
			--BEGIN				
			--	SET @MailSubjectCr = 'Proposal (' + @DealNo + ') is rejected'   
			--END
			--ELSE IF(@module_code = 265)
			--BEGIN				
			--	SET @MailSubjectCr = 'Purchase Order for Booking sheet (' + @DealNo + ') is rejected'   
			--END
			--ELSE
			--BEGIN
			--	SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is rejected'   
			--END			

			PRINT 'Start Template Cursor:'+@Alert_Type
			DECLARE @Email_Config_Code INT, @Notification_Subject VARCHAR(2000) = '', @Notification_Body VARCHAR(MAX) = '', @Event_Platform_Code INT = 0, @Event_Template_Type CHAR(1) = ''
			DECLARE curNotificationPlatforms_Rejection CURSOR FOR 
					SELECT ec.Email_Config_Code, et.[Subject], et.Template, ect.Event_Platform_Code, ect.Event_Template_Type FROM Email_Config ec
					INNER JOIN Email_Config_Template ect ON ec.Email_Config_Code = ect.Email_Config_Code
					INNER JOIN Event_Template et ON ect.Event_Template_Code = et.Event_Template_Code
					WHERE ec.[Key] = @Alert_Type
			OPEN curNotificationPlatforms_Rejection 
			FETCH NEXT FROM curNotificationPlatforms_Rejection INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
			WHILE @@FETCH_STATUS = 0
			BEGIN
					DELETE FROM @Email_Config_Users_UDT						

					IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

					CREATE TABLE #TempCursorOnRej (
						First_name NVARCHAR(MAX),
						Security_group_name NVARCHAR(500),
						Email_id NVARCHAR(500),
						Security_group_code INT,
						User_code INT 
					)
		
					INSERT INTO #TempCursorOnRej(First_name, Security_group_name, Email_id, Security_group_code, User_code)
					SELECT DISTINCT ISNULL(U2.First_Name,'') + ' ' + ISNULL(U2.Middle_Name,'') + ' ' + ISNULL(U2.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')', 
					SG.Security_Group_Name, U2.Email_Id, U2.Security_Group_Code, U2.Users_Code   
					FROM Users U1 (NOLOCK)
					INNER JOIN Users_Business_Unit UBU  (NOLOCK) ON UBU.Business_Unit_Code IN (@BUCode)
					INNER JOIN Users U2 (NOLOCK) ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code AND U2.Is_Active = 'Y' AND U1.Is_Active = 'Y'
					INNER JOIN Security_Group SG (NOLOCK) ON SG.Security_Group_Code = U1.Security_Group_Code
					INNER JOIN Module_Workflow_Detail MWD (NOLOCK) ON MWD.Primary_User_Code = U1.Users_Code AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode
						AND Module_Workflow_Detail_Code < @module_workflow_detail_code

					DECLARE @Is_CustomUsers_WF_SendMail VARCHAR(10)
					SELECT @Is_CustomUsers_WF_SendMail = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_CustomUsers_WF_SendMail'
					DECLARE @Email_Config_Code_V18 VARCHAR(10)
					SELECT @Email_Config_Code_V18 = Email_Config_Code from Email_Config (NOLOCK) where [Key] = @Alert_Type

					IF(@Is_CustomUsers_WF_SendMail = 'Y')
					BEGIN
						DECLARE @ENL TABLE (
							BUCode INT,
							User_Code INT,
							EmailId NVARCHAR(MAX)
						)
						--print '111'
						INSERT INTO @ENL (BUCode, User_Code, EmailId)
						EXEC USP_Get_EmailConfig_Users @Alert_Type,@Event_Platform_Code, @Event_Template_Type,'Y'
						--EXEC USP_Get_EmailConfig_Users @Alert_Type,'Y'
				
						INSERT INTO #TempCursorOnRej(First_name, Security_group_name, Email_id, Security_group_code, User_code)
						SELECT DISTINCT ISNULL(usr.First_Name,'') + ' ' + ISNULL(usr.Middle_Name,'') + ' ' + ISNULL(usr.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
						SG.Security_Group_Name, usr.Email_Id, usr.Security_Group_Code, usr.Users_Code 
						FROM @ENL ec
						INNER JOIN Users usr  (NOLOCK) ON usr.Users_Code  = EC.User_Code
						INNER JOIN Security_Group SG  (NOLOCK) ON SG.Security_Group_Code = Usr.Security_Group_Code
					END
	
					/* CURSOR START */
					DECLARE cur_on_rejection CURSOR KEYSET FOR
					SELECT First_name, Security_group_name, Email_id, Security_group_code, User_code FROM #TempCursorOnRej 
					OPEN cur_on_rejection  
					FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
					WHILE (@@fetch_status <> -1)  
					BEGIN  
						IF (@@fetch_status <> -2)  
						BEGIN  
							SELECT @DefaultSiteUrl = @DefaultSiteUrlHold
							--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) +
							--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
							IF(@module_code = 262)
							BEGIN
								SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param 
							END
							ELSE IF(@module_code = 265)
							BEGIN
								SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param 
							END
							ELSE
							BEGIN
								SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=R'
							END	
					
						--IF(@module_code = 262)
						--BEGIN
						--	SET @Email_Table =	
						--			'<table class="tblFormat" style="width:100%"> 
						--				 <tr>
						--								<td align="center" width="9%" class="tblHead">Proposal No.</td>    
						--								<td align="center" width="9%" class="tblHead">Airline Name</td> 
						--								<td align="center" width="9%" class="tblHead">Proposal Start Date</td> 
						--								<td align="center" width="9%" class="tblHead">Proposal End Date</td> 
						--								<td align="center" width="9%" class="tblHead">Total Movies</td> 
						--								<td align="center" width="9%" class="tblHead">Total TV Shows</td>   
						--								<td align="center" width="9%" class="tblHead">Creation Date</td>
						--								<td align="center" width="9%" class="tblHead">Created By</td>
						--								<td align="center" width="9%" class="tblHead">Last Actioned By</td>
						--				 </tr>  
						--				 <tr>											
						--								<td align="center" class="tblData">{Proposal_No}</td>   
						--								<td align="center" class="tblData">{Airline_Name}</td>    
						--								<td align="center" class="tblData">{Proposal_Start_Date}</td>    
						--								<td align="center" class="tblData">{Proposal_End_Date}</td>    
						--								<td align="center" class="tblData">{Total_Movies}</td>    
						--								<td align="center" class="tblData">{Total_Show}</td>   
						--								<td align="center" class="tblData">{Creation_Date}</td> 
						--								<td align="center" class="tblData">{Created_By}</td> 
						--								<td align="center" class="tblData">{Last_Actioned_By}</td>
						--				</tr>  
						--			</table>'
						--END
						--ELSE IF(@module_code = 265)
						--BEGIN
						--	SET @Email_Table =	
						--			'<table class="tblFormat" style="width:100%"> 
						--				 <tr>
						--								<td align="center" width="9%" class="tblHead">Proposal No.</td>
						--								<td align="center" width="9%" class="tblHead">Booking Sheet No.</td> 
						--								<td align="center" width="9%" class="tblHead">Airline Name</td> 
						--								<td align="center" width="9%" class="tblHead">Cycle Start Date</td> 
						--								<td align="center" width="9%" class="tblHead">Cycle End Date</td> 
						--								<td align="center" width="9%" class="tblHead">Total Movies in BO</td> 
						--								<td align="center" width="9%" class="tblHead">Total TV Shows in BO</td>  
						--								<td align="center" width="9%" class="tblHead">No. Movies in PO</td> 
						--								<td align="center" width="9%" class="tblHead">No. TV Shows in PO</td> 
						--								<td align="center" width="9%" class="tblHead">Creation Date</td>
						--								<td align="center" width="9%" class="tblHead">Created By</td>
						--				 </tr>  
						--				 <tr>											
						--								<td align="center" class="tblData">{Proposal_No}</td> 
						--								<td align="center" class="tblData">{Deal_No}</td>
						--								<td align="center" class="tblData">{Airline_Name}</td>    
						--								<td align="center" class="tblData">{Cycle_Start_Date}</td>    
						--								<td align="center" class="tblData">{Cycle_End_Date}</td>    
						--								<td align="center" class="tblData">{Total_Movie_BO}</td>    
						--								<td align="center" class="tblData">{Total_Show_BO}</td>   
						--								<td align="center" class="tblData">{No_Of_Movie_PO}</td>
						--								<td align="center" class="tblData">{No_Of_Show_PO}</td>
						--								<td align="center" class="tblData">{Creation_Date}</td> 
						--								<td align="center" class="tblData">{Created_By}</td>
						--				</tr>  
						--			</table>'
						--END
						--ELSE
						--BEGIN
						--	SET @Email_Table =	
						--		'<table class="tblFormat" style="width:100%"> 
						--			 <tr>     
						--							<th align="center" width="14%" class="tblHead">Agreement No.</th>    
						--							<th align="center" width="14%" class="tblHead">Agreement Date</th>   
						--							<th align="center" width="19%" class="tblHead">Deal Description</th> 
						--							<th align="center" width="19%" class="tblHead">Primary Licensor</th>   
						--							<th align="center" width="25%" class="tblHead">Title(s)</th>
						--							<th align="center" width="10%" class="tblHead">Business Unit</th>
						--			 </tr>  
						--			 <tr>
						--							<td align="center" class="tblData">{Agreement_No}</td>   
						--							<td align="center" class="tblData">{Agreement_Date}</td>     
						--							<td align="center" class="tblData">{Deal_Desc}</td>    
						--							<td align="center" class="tblData">{Primary_Licensor}</td>   
						--							<td align="center" class="tblData">{Titles}</td> 
						--							<td align="center" class="tblData">{BU_Name}</td> 
						--			</tr>  
						--		</table>'
						--END	
							--IF(@module_code = 262)
							--BEGIN
							--	SELECT @body1 = template_desc FROM Email_Template (NOLOCK) WHERE Template_For='Recommendation_Rejected'
							--END
							--ELSE IF(@module_code = 265)
							--BEGIN
							--	SELECT @body1 = template_desc FROM Email_Template (NOLOCK) WHERE Template_For='Purchase_Order_Rejected'
							--END
							--ELSE
							--BEGIN
							--	SELECT @body1 = template_desc FROM Email_Template (NOLOCK) WHERE Template_For='R'
							--END
					
							PRINT @DealNo  
							--REPLACE ALL THE PARAMETER VALUE  
							SET @Notification_Subject = replace(@Notification_Subject,'{Agreement_No}',@DealNo) 

							SET @Notification_Body = replace(@Notification_Body,'{User_Name}',@cur_first_name)  
							SET @Notification_Body = replace(@Notification_Body,'{Agreement_No}',@DealNo)  
							SET @Notification_Body = replace(@Notification_Body,'{deal_type}',@DealType)  
							SET @Notification_Body = replace(@Notification_Body,'{link}',@DefaultSiteUrl)  
							SET @Notification_Body = replace(@Notification_Body,'{rejected_by}',@Rejected_by) 

							IF(@module_code = 262)
							BEGIN
								SET @Notification_Body = replace(@Notification_Body,'{Proposal_No}',@DealNo)  
								SET @Notification_Body = REPLACE(@Notification_Body,'{Airline_Name}',@Airline_Name)  
								SET @Notification_Body = REPLACE(@Notification_Body,'{Proposal_Start_Date}',@Proposal_Start_Date)  
								SET @Notification_Body = replace(@Notification_Body,'{Proposal_End_Date}',@Proposal_End_Date)  
								SET @Notification_Body = replace(@Notification_Body,'{Total_Movies}',@Total_Movies)  
								SET @Notification_Body = replace(@Notification_Body,'{Total_Show}',@Total_Show)
								SET @Notification_Body = replace(@Notification_Body,'{Creation_Date}',@Creation_Date) 
								SET @Notification_Body = replace(@Notification_Body,'{Created_By}',@Created_By) 
								SET @Notification_Body = replace(@Notification_Body,'{Last_Actioned_By}',@Last_Actioned_By) 
							END	
							ELSE IF(@module_code = 265)
							BEGIN
								SET @Notification_Body = replace(@Notification_Body,'{Proposal_No}',@Proposal_No)
								SET @Notification_Body = replace(@Notification_Body,'{Agreement_No}',@DealNo) 
								SET @Notification_Body = REPLACE(@Notification_Body,'{Airline_Name}',@Airline_Name)  
								SET @Notification_Body = REPLACE(@Notification_Body,'{Cycle_Start_Date}',@Cycle_Start_Date)  
								SET @Notification_Body = replace(@Notification_Body,'{Cycle_End_Date}',@Cycle_End_Date)  
								SET @Notification_Body = replace(@Notification_Body,'{Total_Movie_BO}',@Total_Movie_BO)  
								SET @Notification_Body = replace(@Notification_Body,'{Total_Show_BO}',@Total_Show_BO)
								SET @Notification_Body = replace(@Notification_Body,'{No_Of_Movie_PO}',@No_Of_Movie_PO)
								SET @Notification_Body = replace(@Notification_Body,'{No_Of_Show_PO}',@No_Of_Show_PO)  
								SET @Notification_Body = replace(@Notification_Body,'{Creation_Date}',@Creation_Date) 
								SET @Notification_Body = replace(@Notification_Body,'{Created_By}',@Created_By) 
							END
							ELSE
							BEGIN
								SET @Notification_Body = replace(@Notification_Body,'{Agreement_No}',@Agreement_No)  
								SET @Notification_Body = REPLACE(@Notification_Body,'{Agreement_Date}',@Agreement_Date)  
								SET @Notification_Body = REPLACE(@Notification_Body,'{Deal_Description}',@Deal_Desc)  
								SET @Notification_Body = replace(@Notification_Body,'{Primary_Licensor}',@Primary_Licensor)  
								SET @Notification_Body = replace(@Notification_Body,'{Title_Name}',@Titles)  
								SET @Notification_Body = replace(@Notification_Body,'{BU_Name}', @BU_Name)
							END				 
					
      
							SET @CC = ''  
							--SET @body1 = replace(@body1,'{table}',@Email_Table)
							--IF(@Is_Mail_Send_To_Group='Y')  
							--BEGIN  
							--	SELECT @CC = @CC + ';' + Email_Id FROM Users WHERE security_group_code IN (@cur_security_group_code)   
							--	AND Users_Code NOT IN (@cur_user_code)  
							--END
  
							DECLARE @DatabaseEmail_Profile varchar(200)	= ''
							SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

							--EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile, 
							--@recipients =  @cur_email_id, 
							--@copy_recipients = @CC, 
							--@subject = @MailSubjectCr, 
							--@body = @body1,
							--@body_format = 'HTML';
				

							INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
							SELECT @Email_Config_Code,@Notification_Body, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''),  @Notification_Subject

						END  
						FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
					END  
  
					CLOSE cur_on_rejection  
					DEALLOCATE cur_on_rejection  
					/* CURSOR END */
										
					EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT, @module_code, @RecordCode,@Email_Config_Code,@Event_Platform_Code,@Event_Template_Type
    
					IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej
					SET @Is_Error='N' 

					FETCH NEXT FROM curNotificationPlatforms_Rejection INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
			
			END
			CLOSE curNotificationPlatforms_Rejection
			DEALLOCATE curNotificationPlatforms_Rejection
		END TRY  
		BEGIN CATCH		
			SET @Is_Error='Y'
			PRINT ERROR_MESSAGE()   
			CLOSE cur_on_rejection  
			DEALLOCATE cur_on_rejection  
   
			INSERT INTO ERRORON_SENDMAIL_FOR_WORKFLOW   
			SELECT  
				ERROR_NUMBER() AS ERRORNUMBER,  
				ERROR_SEVERITY() AS ERRORSEVERITY,    
				ERROR_STATE() AS ERRORSTATE,  
				ERROR_PROCEDURE() AS ERRORPROCEDURE,  
				ERROR_LINE() AS ERRORLINE,  
				ERROR_MESSAGE() AS ERRORMESSAGE;  
		END CATCH  
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_On_Rejection]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END

