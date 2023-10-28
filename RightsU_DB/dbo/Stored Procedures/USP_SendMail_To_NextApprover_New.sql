CREATE PROCEDURE [dbo].[USP_SendMail_To_NextApprover_New]
(
	@RecordCode Int=3
	,@Module_code Int=30
	,@RedirectToApprovalList Varchar(100)='N'
	,@AutoLoginUser Varchar(100)=143
	,@Is_Error Char(1) 	Output
)
AS
BEGIN	
	 Declare @Loglevel int;
	 select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_To_NextApprover_New]', 'Step 1', 0, 'Started Procedure', 0, ''
		--declare
		--@RecordCode Int=2118
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
			DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 
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
			DECLARE @Approved_by NVARCHAR(MAX) = ''
			DECLARE @current_approval NVARCHAR(MAX) = ''

			SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config (NOLOCK) WHERE [Key]='SFA'

			SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param	--// FLAG FOR SEND MAIL TO INDIVIDUAL PERSON ON GROUP //--

			SET @DealType = ''
			IF(@Module_code = 30)
			BEGIN
				SELECT TOP 1  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
				FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @RecordCode
				SELECT @Acq_Deal_Rights_Code   =  @Acq_Deal_Rights_Code + CAST(acq_deal_rights_Code AS varchar)+ ', '  FROM acq_deal_Rights (NOLOCK) WHERE Acq_Deal_Code = @RecordCode
				select @Promoter_Count = count(*) from Acq_Deal_Rights_Promoter (NOLOCK) where Acq_Deal_Rights_Code in (SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Code,',')) 
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
				FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @RecordCode
			END
			ELSE IF(@Module_code = 163)
			BEGIN
				SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
				FROM Music_Deal (NOLOCK) WHERE Music_Deal_Code = @RecordCode
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
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
			@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0,@BU_Name VARCHAR(MAX) = '',
			@Proposal_No NVARCHAR(MAX) = '', @Airline_Name NVARCHAR(MAX) = '', @Proposal_Start_Date NVARCHAR(MAX) = '', @Proposal_End_Date NVARCHAR(MAX) = '', @Total_Movies NVARCHAR(MAX) = 0,
			@Total_Show NVARCHAR(MAX) = 0, @Cycle_Start_Date NVARCHAR(MAX) = '', @Cycle_End_Date NVARCHAR(MAX) = '', @Total_Movie_BO NVARCHAR(MAX) = 0, @Total_Show_BO NVARCHAR(MAX) = 0,
			@No_Of_Movie_PO NVARCHAR(MAX) = 0, @No_Of_Show_PO NVARCHAR(MAX) = 0

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
						@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
						@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
						@Last_Actioned_By =ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
						@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
					FROM Acq_Deal AD (NOLOCK)
						INNER JOIN Vendor V (NOLOCK) ON AD.Vendor_Code = V.Vendor_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = AD.Business_Unit_Code
						LEFT JOIN Users U1 (NOLOCK) ON U1.Users_Code = AD.Inserted_By
						LEFT JOIN Users U2 (NOLOCK) ON U2.Users_Code = AD.Last_Action_By
					WHERE Acq_Deal_Code = @RecordCode
			
					SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie (NOLOCK) where Acq_Deal_Code = @RecordCode
					IF( @Title_Count > @Max_Titles_In_Approval_Mail)
					BEGIN
						SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
					END
					ELSE
					BEGIN
						SELECT  @Titles += CASE  WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
						FROM (
							SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM (NOLOCK)
							INNER JOIN Title T (NOLOCK) ON ADM.Title_Code = T.Title_Code
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
						@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
						@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
						@Last_Actioned_By =ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
									+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
						@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
					FROM Syn_Deal SD (NOLOCK)
						INNER JOIN Vendor V (NOLOCK) ON SD.Vendor_Code = V.Vendor_Code
						INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = SD.Business_Unit_Code
						LEFT JOIN Users U1 (NOLOCK) ON U1.Users_Code = SD.Inserted_By
						LEFT JOIN Users U2 (NOLOCK) ON U2.Users_Code = SD.Last_Action_By
					WHERE Syn_Deal_Code = @RecordCode

					SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie  (NOLOCK) where Syn_Deal_Code = @RecordCode
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
						INNER JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MD.Music_Label_Code
						INNER JOIN Business_Unit BU  (NOLOCK) ON BU.Business_Unit_Code = MD.Business_Unit_Code
					WHERE Music_Deal_Code = @RecordCode
				END
				ELSE IF(@module_code = 262)
				BEGIN
					PRINT 'Recommendation Module'

					SELECT TOP 1 @DealNo = ISNULL(alp.Proposal_No,''), @Airline_Name = ISNULL((SELECT TOP 1 Vendor_Name FROM Vendor WHERE Vendor_Code = alp.Vendor_Code),''),
						@Proposal_Start_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alr.Start_Date, 106))),' ','-'),''), @Proposal_End_Date = ISNULL(REPLACE(RTRIM(LTRIM(CONVERT(CHAR(15), alr.End_Date, 106))),' ','-'),''),
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
	
			/* SELECT SITE URL */
			DECLARE @DefaultSiteUrlHold NVARCHAR(500) ,  @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
			SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param
			IF(@module_code = 262)
			BEGIN
				SET @MailSubjectCr = 'Proposal ('+ @DealNo + ') is waiting for approval'
			END
			ELSE IF(@module_code = 265)
			BEGIN
				SET @MailSubjectCr = 'Purchase Order for BO No. ('+ @DealNo + ') is waiting for approval'
			END
			ELSE
			BEGIN
				SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is waiting for approval' 
			END

			SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

			IF(@Is_RU_Content_Category = 'Y')
				SET  @BU_CC= 'Content Category'

			--@Primary_User_Code is nothing by group code 
			/* TO SEND EMAIL TO INDIVIDUAL USER */
			DECLARE @Primary_User_Code INT = 0
			SELECT TOP 1 @Primary_User_Code = Group_Code  
			FROM Module_Workflow_Detail  (NOLOCK)
			WHERE Is_Done = 'N' AND Module_Code = @Module_code AND Record_Code = @RecordCode 
			ORDER BY Module_Workflow_Detail_Code

			/* CURSOR START */
			DECLARE Cur_On_Rejection CURSOR KEYSET FOR 
			SELECT DISTINCT U2.Email_Id ,ISNULL(U2.First_Name,'') + ' ' + ISNULL(U2.Middle_Name,'') + ' ' + ISNULL(U2.Last_Name,'') + 
			'   ('+ ISNULL(SG.Security_Group_Name,'') + ')', SG.Security_Group_Name, U2.Security_Group_Code, U2.Users_Code 
			FROM Users U1 (NOLOCK)
				INNER JOIN Users_Business_Unit UBU (NOLOCK) ON UBU.Business_Unit_Code IN (@BU_Code)
				INNER JOIN Users U2 (NOLOCK) ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code
				INNER JOIN Security_Group SG (NOLOCK) ON SG.Security_Group_Code = U1.Security_Group_Code
			WHERE U1.Security_Group_Code = @Primary_User_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'


			OPEN Cur_On_Rejection
			FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
			WHILE (@@fetch_status <> -1)
			BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
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
						SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=SA'
					END					
				
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
						'
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


				   IF(@DealType = 'Acquisition'  AND @Is_RU_Content_Category = 'N')
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
					ELSE IF(@module_code = 262)
					BEGIN
						 SET @Email_Table += ' <tr>
							<td align="center" class="tblData">{Proposal_No}</td>   
							<td align="center" class="tblData">{Airline_Name}</td>    
							<td align="center" class="tblData">{Proposal_Start_Date}</td>    
							<td align="center" class="tblData">{Proposal_End_Date}</td>    
							<td align="center" class="tblData">{Total_Movies}</td>    
							<td align="center" class="tblData">{Total_Show}</td>   
							<td align="center" class="tblData">{Creation_Date}</td> 
							<td align="center" class="tblData">{Created_By}</td> 
							<td align="center" class="tblData">{Last_Actioned_By}</td> 
						'
					END 
					ELSE IF(@module_code = 265)
					BEGIN
						 SET @Email_Table += ' <tr>
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
				   IF(@DealType = 'Acquisition' AND @Is_RU_Content_Category = 'N')
				   BEGIN
						SET @Email_Table += '<td align="center" class="tblData">{Promoter}</td>'
					END   
			
				SET @Email_Table += '</tr></table>'

				
					IF(@module_code = 262)
					BEGIN
						SELECT @body1 = template_desc FROM Email_Template (NOLOCK) WHERE Template_For='Recommendation_Approval' 
					    SELECT @Approved_by = dbo.UFN_Get_UsernName_Last_Approved(@RecordCode, @Module_code, 'A')
						SELECT TOP 1 @current_approval =
							ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
							+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
							+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), '') 
							+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
							FROM Module_Status_History MSH 
							INNER JOIN Users U on MSH.Status_Changed_By = U.Users_Code
							INNER JOIN Security_Group SG ON U.Security_Group_Code = SG.Security_Group_Code
						WHERE Record_Code = @RecordCode  AND Module_Code = @Module_code -- AND Status = 'A'
						ORDER BY MSH.Module_Status_Code DESC 
					END
					ELSE IF(@module_code = 265)
					BEGIN
						SELECT @body1 = template_desc FROM Email_Template (NOLOCK) WHERE Template_For='Purchase_Order_Approval' 
					    SELECT @Approved_by = dbo.UFN_Get_UsernName_Last_Approved(@RecordCode, @Module_code, 'A')
						SELECT TOP 1 @current_approval =
							ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
							+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
							+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), '') 
							+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
							FROM Module_Status_History MSH 
							INNER JOIN Users U on MSH.Status_Changed_By = U.Users_Code
							INNER JOIN Security_Group SG ON U.Security_Group_Code = SG.Security_Group_Code
						WHERE Record_Code = @RecordCode  AND Module_Code = @Module_code -- AND Status = 'A'
						ORDER BY MSH.Module_Status_Code DESC 
					END
					ELSE
					BEGIN
						--REPLACE ALL THE PARAMETER VALUE
						SELECT @body1 = template_desc FROM Email_Template (NOLOCK) WHERE Template_For='A' 
						SELECT @Approved_by = dbo.UFN_Get_UsernName_Last_Approved(@RecordCode, @Module_code, 'A')
					END	

					SET @body1 = replace(@body1,'{login_name}',@Cur_first_name)
					SET @body1 = replace(@body1,'{deal_no}',@DealNo)
					SET @body1 = replace(@body1,'{deal_type}',@DealType)
					set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)
					SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)
					SET @body1 = replace(@body1,'{approved_by}',@Approved_by)
					SET @body1 = replace(@body1,'{current_approval}',@current_approval)

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
					
					IF(@DealType = 'Acquisition' AND @Is_RU_Content_Category = 'N')
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

					--EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile,
					--@Recipients =  @Cur_email_id,
					--@Copy_recipients = @CC,
					--@subject = @MailSubjectCr,
					--@body = @body1,
					--@body_format = 'HTML';  

					INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
					SELECT @Email_Config_Code,@body1, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''),  @MailSubjectCr

					--select @body1

				END
				FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
			END

			CLOSE Cur_On_Rejection
			DEALLOCATE Cur_On_Rejection
			/* CURSOR END */
						 --select @DefaultSiteUrl

			EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT, @Module_code, @RecordCode
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
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_To_NextApprover_New]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''					
END
