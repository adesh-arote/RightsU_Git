CREATE PROCEDURE [dbo].[USP_SendMail_Intimation_New]
	@RecordCode INT,
	@module_workflow_detail_code INT,
	@module_code INT,
	@RedirectToApprovalList VARCHAR(100),
	@AutoLoginUser VARCHAR(100),
	@Is_Error CHAR(1) OUTPUT
AS  
-- =============================================  
-- Author:  Dadasaheb G. Karande  
-- Create date: 03-FEB-2011  
-- Description: To Send mail to a Last All approver after the Aquisition Or Syndication deal   
--    is approve from user  
-- =============================================  
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_Intimation_New]', 'Step 1', 0, 'Started Procedure', 0, ''

		--DECLARE 
		--@RecordCode INT =2058,
		--@module_workflow_detail_code INT = 6547,
		--@module_code INT = 30,
		--@RedirectToApprovalList VARCHAR(100)='',
		--@AutoLoginUser VARCHAR(100) = 143,
		--@Is_Error CHAR(1) = 'N'

		SET NOCOUNT ON; 
		SET @Is_Error='N'  

		IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		BEGIN TRY
			DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 
			DECLARE @Approved_by VARCHAR(MAX) = ''
			DECLARE @cur_first_name NVARCHAR(500)
			DECLARE @cur_security_group_name NVARCHAR(500)
			DECLARE @cur_email_id VARCHAR(500)
			DECLARE @cur_security_group_code VARCHAR(500)
			DECLARE @cur_user_code INT
			DECLARE @cur_next_level_group INT

			DECLARE @DealType VARCHAR(100) = ''
			DECLARE @DealNo VARCHAR(500) = 0
			DECLARE @body1 NVARCHAR(MAX) = ''
			DECLARE @MailSubjectCr NVARCHAR(500)  
			DECLARE @CC VARCHAR(MAX) = ''  
			DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)  
			DECLARE @BU_Code Int = 0
			DECLARE  @DefaultSiteUrl_Param NVARCHAR(500) = ''
			DECLARE @DefaultSiteUrl VARCHAR(500) SET @DefaultSiteUrl = ''  
			DECLARE @Is_CustomUsers_WF_SendMail VARCHAR(10) = ''
			DECLARE @Email_Config_Code INT
			DECLARE @Appr_by NVARCHAR(MAX) = ''

			SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config (NOLOCK) WHERE [Key]='ASCM'

			SELECT @Approved_by = --ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') 
			ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
			FROM Users U  (NOLOCK) 
				INNER JOIN Security_Group SG (NOLOCK) ON SG.Security_Group_Code = U.Security_Group_Code  
			WHERE Users_Code   = @AutoLoginUser 

			SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param --// SET A FLAG FOR SEND MAIL TO INDIVIDUAL PERSON OR SECURITY GROUP //--  

			IF(@module_code = 30)
			BEGIN
				SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
				FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @RecordCode 
			END
			ELSE IF(@module_code = 35)
			BEGIN
				SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
				FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @RecordCode 
			END
			ELSE IF(@module_code = 163)
			BEGIN
				SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
				FROM Music_Deal  (NOLOCK) WHERE Music_Deal_Code = @RecordCode 
			END
			ELSE IF(@Module_code = 262)
			BEGIN
				SELECT @DealNo = Proposal_No, @BU_Code = 1, @DealType = 'Recommendation'
				FROM AL_Recommendation ar
					INNER JOIN AL_Proposal ap ON ar.AL_Proposal_Code = ap.AL_Proposal_Code 
				WHERE ar.AL_Recommendation_Code = @RecordCode
			END
			ELSE IF(@Module_code = 265)
			BEGIN
				SELECT @DealNo = ISNULL(absh.Booking_Sheet_No,''), @BU_Code = 1, @DealType = 'PurchaseOrder'
				FROM AL_Purchase_Order apo
					INNER JOIN AL_Proposal ap ON apo.AL_Proposal_Code = ap.AL_Proposal_Code 
					INNER JOIN AL_Booking_Sheet absh ON absh.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code
				WHERE apo.AL_Purchase_Order_Code = @RecordCode
			END

			DECLARE 
				@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', @Primary_Licensor NVARCHAR(MAX) = '', 
				@Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0 ,@BU_Name VARCHAR(MAX) = '',
				@Proposal_No NVARCHAR(MAX) = '', @Airline_Name NVARCHAR(MAX) = '', @Proposal_Start_Date NVARCHAR(MAX) = '', @Proposal_End_Date NVARCHAR(MAX) = '', @Total_Movies NVARCHAR(MAX) = 0,
				@Total_Show NVARCHAR(MAX) = 0, @Cycle_Start_Date NVARCHAR(MAX) = '', @Cycle_End_Date NVARCHAR(MAX) = '', @Total_Movie_BO NVARCHAR(MAX) = 0, @Total_Show_BO NVARCHAR(MAX) = 0,
				@No_Of_Movie_PO NVARCHAR(MAX) = 0, @No_Of_Show_PO NVARCHAR(MAX) = 0

			DECLARE @Created_By  VARCHAR(MAX) = '',
					@Creation_Date  VARCHAR(MAX) = '',
					@Last_Actioned_By  VARCHAR(MAX) = '',
					@Last_Actioned_Date  VARCHAR(MAX) = ''

			IF(@RecordCode > 0)
			BEGIN
				SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New 
				WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

				IF(@module_code = 30)
				BEGIN
					PRINT 'Acquisition Deal Module'
					SELECT TOP 1 
						@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106),
						@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name,
						@Created_By = U1.Login_Name ,
						@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
						@Last_Actioned_By = U2.Login_Name,
						@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
					FROM Acq_Deal AD (NOLOCK)
						INNER JOIN Vendor V (NOLOCK) ON AD.Vendor_Code = V.Vendor_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = AD.Business_Unit_Code
						LEFT JOIN Users U1 (NOLOCK) ON U1.Users_Code = AD.Inserted_By
						LEFT JOIN Users U2 (NOLOCK) ON U2.Users_Code = AD.Last_Action_By
					WHERE Acq_Deal_Code = @RecordCode

			
					SELECT @Title_Count = COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie (NOLOCK) where Acq_Deal_Code = @RecordCode
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
					PRINT 'Syndication Deal Module'
					SELECT TOP 1 
						@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
						@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
						@Created_By = U1.Login_Name ,
						@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
						@Last_Actioned_By = U2.Login_Name,
						@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
					FROM Syn_Deal SD (NOLOCK)
						INNER JOIN Vendor V (NOLOCK) ON SD.Vendor_Code = V.Vendor_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = SD.Business_Unit_Code
						LEFT JOIN Users U1 (NOLOCK) ON U1.Users_Code = SD.Inserted_By
						LEFT JOIN Users U2 (NOLOCK) ON U2.Users_Code = SD.Last_Action_By
					WHERE Syn_Deal_Code = @RecordCode
			
					SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie (NOLOCK) where Syn_Deal_Code = @RecordCode
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
					PRINT 'Music Deal Module'
					SELECT TOP 1 
						@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
						@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
					FROM Music_Deal MD (NOLOCK)
						INNER JOIN Vendor V (NOLOCK) ON MD.Primary_Vendor_Code = V.Vendor_Code
						INNER JOIN Music_Label ML  (NOLOCK) ON ML.Music_Label_Code = MD.Music_Label_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = MD.Business_Unit_Code
					WHERE Music_Deal_Code = @RecordCode
				END
				ELSE IF(@module_code = 262)
				BEGIN
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

					SET @BU_Code = 1;

				END
				ELSE IF(@module_code = 265)
				BEGIN
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

					SET @BU_Code = 1;

				END
			END
  
			/* CHECK THAT DEAL IS APPROVED THROUGH ALL WORKFLOW LEVEL OR NOT */
			DECLARE @Is_Deal_Approved INT  = 0  
			SELECT @Is_Deal_Approved = COUNT(*) FROM Module_Workflow_Detail MWD  (NOLOCK)
			WHERE  Module_Workflow_Detail_Code IN (  
				SELECT Module_Workflow_Detail_Code FROM Module_Workflow_Detail (NOLOCK) 
				WHERE Record_Code = @RecordCode  AND Module_Code = @module_code  AND Is_Done = 'N'  
			)
   
			/* GET NEXT APPROVAL NAME */
			DECLARE @NextApprovalName NVARCHAR(500) = ''  
			SELECT @NextApprovalName = Security_Group_Name FROM Security_Group  (NOLOCK)  
			WHERE Security_Group_Code IN (
				SELECT ISNULL(Next_Level_Group, 0) FROM Module_Workflow_Detail (NOLOCK) WHERE Module_Workflow_Detail_Code = @module_workflow_detail_code
			)    
    
			/* SELECT SITE URL */
			DECLARE @DefaultSiteUrlHold VARCHAR(500)
			SELECT  @DefaultSiteUrl_Param = DefaultSiteUrl , @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  

			IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

			CREATE TABLE #TempCursorOnRej (
				Email_id NVARCHAR(500),
				First_name NVARCHAR(MAX),
				Security_group_name NVARCHAR(500),
				Next_level_group INT,
				Security_group_code INT,
				User_code INT 
			)

			IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
			BEGIN
				INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
				SELECT DISTINCT U1.Email_Id, 
				ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
				+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
				SG.Security_Group_Name, 
				MWD.Next_Level_Group, 
				U1.Security_Group_Code, 
				U1.Users_Code 
				FROM Module_Workflow_Detail MWD  (NOLOCK)
				INNER JOIN Users U1 (NOLOCK) ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
				INNER JOIN Users_Business_Unit UBU (NOLOCK) ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
				INNER JOIN Security_Group SG (NOLOCK) ON SG.Security_Group_Code = U1.Security_Group_Code
				WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
					  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
			END
			ELSE
			BEGIN
				INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
				SELECT DISTINCT U1.Email_Id, 
				ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
				+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
				SG.Security_Group_Name, 
				MWD.Next_Level_Group, 
				U1.Security_Group_Code, 
				U1.Users_Code 
				FROM Module_Workflow_Detail MWD  (NOLOCK)
				INNER JOIN Users U1 (NOLOCK) ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
				INNER JOIN Users_Business_Unit UBU (NOLOCK) ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
				INNER JOIN Security_Group SG (NOLOCK) ON SG.Security_Group_Code = U1.Security_Group_Code
				WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
					  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
			END
			SELECT @Is_CustomUsers_WF_SendMail = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_CustomUsers_WF_SendMail'
			DECLARE @Email_Config_Code_V18 VARCHAR(10)
			SELECT @Email_Config_Code_V18 = Email_Config_Code from Email_Config (NOLOCK) where [Key] = 'ASCM'
			IF(@Is_CustomUsers_WF_SendMail = 'Y' AND @Is_Deal_Approved = 0)
			BEGIN
				DECLARE @ENL TABLE (
					BUCode INT,
					User_Code INT,
					EmailId NVARCHAR(MAX)
					--User_Type NVARCHAR(MAX)
				)
				INSERT INTO @ENL (BUCode, User_Code, EmailId)
				EXEC USP_Get_EmailConfig_Users 'ASCM', 'Y'

				INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
				SELECT DISTINCT usr.Email_id,
				ISNULL(UPPER(LEFT(usr.First_Name,1))+LOWER(SUBSTRING(usr.First_Name,2,LEN(usr.First_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(usr.Middle_Name,1))+LOWER(SUBSTRING(usr.Middle_Name,2,LEN(usr.Middle_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(usr.Last_Name,1))+LOWER(SUBSTRING(usr.Last_Name,2,LEN(usr.Last_Name))), '') 
				+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
				SG.Security_Group_Name, '', usr.Security_Group_Code, usr.Users_Code 
				FROM @ENL ec
				INNER JOIN Users usr (NOLOCK) ON usr.Users_Code  = EC.User_Code
				INNER JOIN Security_Group SG  (NOLOCK) ON SG.Security_Group_Code = Usr.Security_Group_Code
			
			END
			--select * from #TempCursorOnRej
			--return
			/* CURSOR START */
			DECLARE cur_on_rejection CURSOR KEYSET FOR 
			SELECT Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code FROM #TempCursorOnRej
			OPEN cur_on_rejection  
			FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, @cur_next_level_group, @cur_security_group_code, @cur_user_code  
			WHILE (@@fetch_status <> -1)  
			BEGIN  
				IF (@@fetch_status <> -2)  
				BEGIN  
					SELECT @DefaultSiteUrl  = @DefaultSiteUrlHold

					IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
					BEGIN
						SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=Y&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'
				
						select @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='AR'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
					
						IF (@RedirectToApprovalList = 'WA')
						BEGIN
							SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Sent For Archive' 
							SET @body1 = REPLACE(@body1,'{archive_by}',' Sent For Archive by') 
						END
						ELSE IF @RedirectToApprovalList = 'AR'
						BEGIN
							SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Archived' 
							SET @body1 = REPLACE(@body1,'{archive_by}',' Approved For Archived by') 
						END
						ELSE IF @RedirectToApprovalList = 'A'
						BEGIN
							SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Rejected For Archive' 
							SET @body1 = REPLACE(@body1,'{archive_by}',' Rejected For Archive by') 
						END
					END
					ELSE
					BEGIN
						SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'

						IF(@Is_Deal_Approved > 0)  /* IF DEAL IS NOT APPROVED BY ALL WORKFLOW */
						BEGIN  
							IF(@module_code = 262)
							BEGIN
								SELECT @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='Recommendation_Intimation'
								SELECT @Appr_by = dbo.UFN_Get_UsernName_Last_Approved(@RecordCode, @module_code, 'I')
							END
							ELSE IF(@module_code = 265)
							BEGIN
								SELECT @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='Purchase_Order_Intimation'
								SELECT @Appr_by = dbo.UFN_Get_UsernName_Last_Approved(@RecordCode, @module_code, 'I')
							END
							ELSE
							BEGIN
								SELECT @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='I'
								SELECT @Appr_by = dbo.UFN_Get_UsernName_Last_Approved(@RecordCode, @module_code, 'I')
							END

							SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
							set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
							set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
							set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
							set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
							SET @body1 = REPLACE(@body1, '{next_approval}',@NextApprovalName) 	
							SET @body1 = REPLACE(@body1, '{approved_by}',@Appr_by) 	

							IF(@module_code = 262)
							BEGIN
								SET @MailSubjectCr = 'Proposal - (' + @DealNo + ') is sent for approve to next approval'
							END
							ELSE IF(@module_code = 265)
							BEGIN
								SET @MailSubjectCr = 'Purchase Order for Booking sheet - (' + @DealNo + ') is sent for approve to next approval'
							END
							ELSE
							BEGIN
								SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is sent for approve to next approval'
							END	  
						END  
						ELSE IF(@Is_Deal_Approved = 0) /* IF DEAL APPROVED BY ALL WORKFLOW */
						BEGIN  
							print '2'
							--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
							--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
							IF(@module_code = 262)
							BEGIN
								select @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='Recommendation_Approved'
							END
							ELSE IF(@module_code = 265)
							BEGIN
								select @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='Purchase_Order_Approved'
							END
							ELSE
							BEGIN
								select @body1 = template_desc FROM Email_template (NOLOCK) WHERE Template_For='D'
							END

							SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
							set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
							set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
							set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
							set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
							SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 

							IF(@module_code = 262)
							BEGIN
								SET @MailSubjectCr = 'Proposal - (' + @DealNo + ') is approved' 
							END
							ELSE IF(@module_code = 265)
							BEGIN
								SET @MailSubjectCr = 'Purchase Order for Booking sheet - (' + @DealNo + ') is approved' 
							END
							ELSE
							BEGIN
								SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is approved' 
							END	 
						END  
					END

					DECLARE @Email_Table NVARCHAR(MAX) = '' , @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'

					SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

					IF(@Is_RU_Content_Category = 'Y')
						SET  @BU_CC= 'Content Category'

					IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
					BEGIN
						SET @Email_Table = '
						<table class="tblFormat" style="width:100%">    
							<tr>      
								<th align="center" width="14%" class="tblHead">Agreement No.</th>      
								<th align="center" width="14%" class="tblHead">Agreement Date</th>      
								<th align="center" width="19%" class="tblHead">Deal Description</th>      
								<th align="center" width="19%" class="tblHead">Primary Licensor</th>      
								<th align="center" width="25%" class="tblHead">Title(s)</th>  
								<th align="center" width="10%" class="tblHead">'+@BU_CC+'</th>
							</tr>     
							<tr>      
								<td align="center" class="tblData">{Agreement_No}</td>      
								<td align="center" class="tblData">{Agreement_Date}</td>      
								<td align="center" class="tblData">{Deal_Desc}</td>      
								<td align="center" class="tblData">{Primary_Licensor}</td>      
								<td align="center" class="tblData">{Titles}</td>     
								<td align="center" class="tblData">{BU_Name}</td>     
							</tr>   
						</table>'
					END
					ELSE IF(@module_code = 262)
					BEGIN 
						SET @Email_Table =	
						'<table class="tblFormat" style="width:100%"> 
							 <tr>
											<td align="center" width="9%" class="tblHead">Proposal No.</td>    
											<td align="center" width="9%" class="tblHead">Airline Name</td> 
											<td align="center" width="9%" class="tblHead">Proposal Start Date</td> 
											<td align="center" width="9%" class="tblHead">Proposal End Date</td> 
											<td align="center" width="9%" class="tblHead">Total Movies</td> 
											<td align="center" width="9%" class="tblHead">Total TV Shows</td>   
											<td align="center" width="9%" class="tblHead">Creation Date</td>
											<td align="center" width="9%" class="tblHead">Created By</td>
											<td align="center" width="9%" class="tblHead">Last Actioned By</td>
							 </tr>  
							 <tr>											
											<td align="center" class="tblData">{Proposal_No}</td>   
											<td align="center" class="tblData">{Airline_Name}</td>    
											<td align="center" class="tblData">{Proposal_Start_Date}</td>    
											<td align="center" class="tblData">{Proposal_End_Date}</td>    
											<td align="center" class="tblData">{Total_Movies}</td>    
											<td align="center" class="tblData">{Total_Show}</td>   
											<td align="center" class="tblData">{Creation_Date}</td> 
											<td align="center" class="tblData">{Created_By}</td> 
											<td align="center" class="tblData">{Last_Actioned_By}</td>
							</tr>  
						</table>'
					END
					ELSE IF(@module_code = 265)
					BEGIN 
						SET @Email_Table =	
						'<table class="tblFormat" style="width:100%"> 
							 <tr>											
											<td align="center" width="9%" class="tblHead">Proposal No.</td>
											<td align="center" width="9%" class="tblHead">Booking Sheet No.</td> 
											<td align="center" width="9%" class="tblHead">Airline Name</td> 
											<td align="center" width="9%" class="tblHead">Cycle Start Date</td> 
											<td align="center" width="9%" class="tblHead">Cycle End Date</td> 
											<td align="center" width="9%" class="tblHead">Total Movies in BO</td> 
											<td align="center" width="9%" class="tblHead">Total TV Shows in BO</td>  
											<td align="center" width="9%" class="tblHead">No. Movies in PO</td> 
											<td align="center" width="9%" class="tblHead">No. TV Shows in PO</td> 
											<td align="center" width="9%" class="tblHead">Creation Date</td>
											<td align="center" width="9%" class="tblHead">Created By</td>
							 </tr>  
							 <tr>											
											<td align="center" class="tblData">{Proposal_No}</td> 
											<td align="center" class="tblData">{Deal_No}</td>
											<td align="center" class="tblData">{Airline_Name}</td>    
											<td align="center" class="tblData">{Cycle_Start_Date}</td>    
											<td align="center" class="tblData">{Cycle_End_Date}</td>    
											<td align="center" class="tblData">{Total_Movie_BO}</td>    
											<td align="center" class="tblData">{Total_Show_BO}</td>   
											<td align="center" class="tblData">{No_Of_Movie_PO}</td>
											<td align="center" class="tblData">{No_Of_Show_PO}</td>
											<td align="center" class="tblData">{Creation_Date}</td> 
											<td align="center" class="tblData">{Created_By}</td>
							</tr>  
						</table>'
					END
					ELSE
					BEGIN 
						SET @Email_Table =	
						'<table class="tblFormat" style="width:100%"> 
							 <tr>
											<th align="center" width="10%" class="tblHead">Agreement No.</th>    
											<th align="center" width="10%" class="tblHead">Agreement Date</th> 
											<th align="center" width="10%" class="tblHead">Created By</th> 
											<th align="center" width="10%" class="tblHead">Creation Date</th> 
											<th align="center" width="10%" class="tblHead">Deal Description</th> 
											<th align="center" width="10%" class="tblHead">Primary Licensor</th>   
											<th align="center" width="10%" class="tblHead">Title(s)</th>
											<th align="center" width="10%" class="tblHead">'+@BU_CC+'</th>
											<th align="center" width="10%" class="tblHead">Last Actioned By</th>
											<th align="center" width="10%" class="tblHead">Last Actioned Date</th>
							 </tr>  
							 <tr>
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
							</tr>  
						</table>'
					END


					print @DefaultSiteUrl
					IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
					BEGIN
						SET @body1 = replace(@body1,'{Agreement_No}',@Agreement_No)  
						SET @body1 = REPLACE(@body1,'{Agreement_Date}',@Agreement_Date)  
						SET @body1 = REPLACE(@body1,'{Deal_Desc}',@Deal_Desc)  
						SET @body1 = replace(@body1,'{Primary_Licensor}',@Primary_Licensor)  
						SET @body1 = replace(@body1,'{Titles}',@Titles)  
						SET @body1 = replace(@body1,'{BU_Name}',@BU_Name)
						SET @CC=''  
						--SET @body1 = replace(@body1,'{table}',@Email_Table)
					END
					ELSE
					BEGIN
						IF(@module_code = 262)
						BEGIN
							SET @Email_Table = replace(@Email_Table,'{Proposal_No}',@DealNo)  
							SET @Email_Table = REPLACE(@Email_Table,'{Airline_Name}',@Airline_Name)  
							SET @Email_Table = REPLACE(@Email_Table,'{Proposal_Start_Date}',@Proposal_Start_Date)  
							SET @Email_Table = replace(@Email_Table,'{Proposal_End_Date}',@Proposal_End_Date)  
							SET @Email_Table = replace(@Email_Table,'{Total_Movies}',@Total_Movies)  
							SET @Email_Table = replace(@Email_Table,'{Total_Show}',@Total_Show)
							SET @Email_Table = replace(@Email_Table,'{Creation_Date}',@Creation_Date) 
							SET @Email_Table = replace(@Email_Table,'{Created_By}',@Created_By) 
							SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}',@Last_Actioned_By) 
						END	
						ELSE IF(@module_code = 265)
						BEGIN							 
							SET @Email_Table = replace(@Email_Table,'{Proposal_No}',@Proposal_No)
							SET @Email_Table = replace(@Email_Table,'{Deal_No}',@DealNo) 
							SET @Email_Table = REPLACE(@Email_Table,'{Airline_Name}',@Airline_Name)  
							SET @Email_Table = REPLACE(@Email_Table,'{Cycle_Start_Date}',@Cycle_Start_Date)  
							SET @Email_Table = replace(@Email_Table,'{Cycle_End_Date}',@Cycle_End_Date)  
							SET @Email_Table = replace(@Email_Table,'{Total_Movie_BO}',@Total_Movie_BO)  
							SET @Email_Table = replace(@Email_Table,'{Total_Show_BO}',@Total_Show_BO)
							SET @Email_Table = replace(@Email_Table,'{No_Of_Movie_PO}',@No_Of_Movie_PO)
							SET @Email_Table = replace(@Email_Table,'{No_Of_Show_PO}',@No_Of_Show_PO)  
							SET @Email_Table = replace(@Email_Table,'{Creation_Date}',@Creation_Date) 
							SET @Email_Table = replace(@Email_Table,'{Created_By}',@Created_By) 
						END	
						ELSE
						BEGIN
							SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
							SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
							SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
							SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
							SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
							SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)
						END

						IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
						BEGIN
							SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
							SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
							SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
							SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
						END

						SET @CC=''  
						SET @body1 = replace(@body1,'{table}',@Email_Table)
					END

					DECLARE @DatabaseEmail_Profile varchar(200)	= ''
					SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

					--EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile  
					--,@recipients =  @cur_email_id    
					--,@copy_recipients = @CC  
					--,@subject = @MailSubjectCr  
					--,@body = @body1,
					--@body_format = 'HTML';    

					IF (@RedirectToApprovalList = 'WA')
						INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
						SELECT @Email_Config_Code,@body1, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''),  @MailSubjectCr --'Waiting for Archive'
					ELSE IF (@RedirectToApprovalList = 'AR')
						INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
						SELECT @Email_Config_Code,@body1, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''), @MailSubjectCr -- 'Archived'
					ELSE IF (@RedirectToApprovalList = 'A')
						INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
						SELECT @Email_Config_Code,@body1, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''), @MailSubjectCr -- 'Rejected For Archive'
					ELSE
						INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
						SELECT @Email_Config_Code,@body1, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''), @MailSubjectCr -- 'Send for Approval'
				
				END  
				FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, @cur_next_level_group ,@cur_security_group_code ,@cur_user_code  
			END
			CLOSE cur_on_rejection  
			DEALLOCATE cur_on_rejection  
			/* CURSOR END */

			EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT, @module_code, @RecordCode

    		IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

			SET @Is_Error='N'
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
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_Intimation_New]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
