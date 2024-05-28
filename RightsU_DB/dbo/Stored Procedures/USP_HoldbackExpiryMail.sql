ALTER PROCEDURE [dbo].[USP_HoldbackExpiryMail] 
	@Expiry_Type Char(1),
	@Alert_Type CHAR(4)
AS
-- =============================================
-- Author:		Rahul Kembhavi
-- Create DATE: 14-OCt-2022
-- Description:	Send Acq/Syn Rev HB/HB mail
--				@Alert_Type is 'SRHB' means 'Syn Rev HB 
--				@Alert_Type is 'ARHB' means ' Acq Rev HB
--				@Alert_Type is 'SHB' means 'Syn HB
--
-- =============================================     
BEGIN 
--declare
--	@expiry_type char(1)='d',
--	@alert_type char(4)='ARHB'

	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel' 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_HoldbackExpiryMail]', 'Step 1', 0, 'Started Procedure', 0, ''


		SET NOCOUNT ON;

		IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL DROP TABLE #Alert_Range

		--Change
		SELECT DISTINCT CASE WHEN EDA.Allow_less_Than = 'Y' Then 0 Else Mail_Alert_Days End As Start_Range, Mail_Alert_Days As End_Range,
				EDA.Allow_less_Than, EDA.Mail_Alert_Days INTO #Alert_Range
		FROM Email_Config_Detail_Alert EDA (NOLOCK)
		INNER JOIN Email_Config_Detail ED (NOLOCK) ON ED.Email_Config_Detail_Code=EDA.Email_Config_Detail_Code
		INNER JOIN Email_Config E (NOLOCK) ON E.Email_Config_Code=ED.Email_Config_Code
		Where E.[Key] = @Alert_Type 

		DECLARE @Email_Config_Code INT, @Notification_Subject VARCHAR(2000) = '', @Notification_Body VARCHAR(MAX) = '', @Event_Platform_Code INT = 0, @Event_Template_Type CHAR(1) = ''
		DECLARE curNotificationPlatforms CURSOR FOR 
				SELECT ec.Email_Config_Code, et.[Subject], et.Template, ect.Event_Platform_Code, ect.Event_Template_Type FROM Email_Config ec
				INNER JOIN Email_Config_Template ect ON ec.Email_Config_Code = ect.Email_Config_Code
				INNER JOIN Event_Template et ON ect.Event_Template_Code = et.Event_Template_Code
				WHERE ec.[Key] = @Alert_Type
		OPEN curNotificationPlatforms
		FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
		WHILE @@FETCH_STATUS = 0
		BEGIN
	
				IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS#DealDetails') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS#DealDetails
				IF OBJECT_ID('tempdb..#ACQ_TENTATIVE_DEALS') IS NOT NULL DROP TABLE #ACQ_TENTATIVE_DEALS		
				IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL DROP TABLE #DealDetails				
				IF OBJECT_ID('tempdb..#SYN_EXPIRING_DEALS') IS NOT NULL DROP TABLE #SYN_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ACQ_HB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_HB_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ACQ_RHB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_RHB_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#SYN_HB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #SYN_HB_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ComparePlatform') IS NOT NULL DROP TABLE #ComparePlatform
	
				Create table #DealDetails
				(
					ID INT IDENTITY (1,1),
					Agreement_No VARCHAR(100),
					Title_Code INT,
					Title_Name NVARCHAR(MAX),
					Right_Start_Date DateTime,
					Right_End_Date DateTime,
					Platform_Code VARCHAR(2000),
					Platform_name NVARCHAR(4000),
					Country NVARCHAR(MAX),
					Is_Available CHAR(1) NULL,
					Is_Processed CHAR(1),
					PlatformCodeCount INT,
					Acq_Deal_Rights_Code VARCHAR(1000),
					Expire_In_Days VARCHAR(30),
					Business_Unit_Code int,
					Vendor_Name NVARCHAR(max),
					ROFR_Type  NVARCHAR(max),
					ROFR_Date DateTime
				)


				--DECLARE @Email_Config_Code INT
				--SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = @Alert_Type
				DECLARE @EXP_Count	int
				SET @EXP_Count = ''
	
				--DECLARE @Deal_heading VARCHAR(20) = 'Expiring'		
				DECLARE @RowTitleCodeOld varchar(max),@RowTitleCodeNew varchar(max),@WhereCondition varchar (2)
				SET @RowTitleCodeOld = ''
				SET @RowTitleCodeNew = ''
	
				DECLARE @MailSubjectCr AS VARCHAR(250),@Mail_alert_days int,@Deal_Expiry_email_code int

				CREATE TABLE #ComparePlatform
				(
				Agreement_No NVARCHAR(100), 
				Acq_Deal_Rights_Code INT,
				Platform_Name NVARCHAR(MAX),
				IsInsert CHAR(1)
				)
				--select * from Email_Config_Detail_Alert
	
				--Select Distinct Case When Allow_less_Than = 'Y' Then 0 Else Mail_alert_days End As Start_Range, Mail_alert_days As End_Range InTo #Alert_Range
				--From Deal_Expiry_Email Where Alert_Type = @Alert_Type
				--select * from Email_Config_Detail_Alert
		
				--Change
				
				IF(@Alert_Type = 'SRHB')
				BEGIN
					PRINT 'SRHB'

					SELECT DISTINCT Syn_Deal_Code, Syn_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
									Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #SYN_EXPIRING_DEALS
					FROM
					(
						SELECT DISTINCT adr.Syn_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
								adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
								Country_Code, Territory_Code, Territory_Type,
								sd.Syn_Deal_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
								DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
						From Syn_Deal_Rights adr (NOLOCK)
						INNER JOIN Syn_Deal SD (NOLOCK) ON SD.Syn_Deal_Code = adr.Syn_Deal_Code AND SD.Deal_Workflow_Status = 'A'
						Inner Join Syn_Deal_Rights_Title adrt (NOLOCK) On adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
						Inner Join Syn_Deal_Rights_Platform adrp (NOLOCK) On adr.Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code
						Inner Join Syn_Deal_Rights_Territory adrc (NOLOCK) On adr.Syn_Deal_Rights_Code = adrc.Syn_Deal_Rights_Code
						Where ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M')
						AND ISNULL(Right_Status,'') = 'C'
						AND adr.Is_Tentative != 'Y' AND adr.Is_Pushback = 'Y'
						--Where Actual_Right_End_Date Is Not Null
					) b 
					Where [row] = 1
					 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
					And Exists 
					(
						Select 1 From #Alert_Range tmp 
						Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
					)
			   		
					INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
								Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
					SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
					FROM (
						Select Syn_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
						Expire_In_Days,
						(
							stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
							FROM #Syn_EXPIRING_DEALS t2 
							Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
						) as PlatformCodes,
						CASE t1.Territory_Type
							WHEN 'G' THEN
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #Syn_EXPIRING_DEALS t2
								Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)	 
							Else
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #Syn_EXPIRING_DEALS t2
								Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)
						END	as CountryNames,
						t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
						V.Vendor_Name 
						FROM #Syn_EXPIRING_DEALS t1
						INNER join  Syn_Deal AD on ad.Syn_Deal_Code= t1.Syn_Deal_Code
						INNER join  Vendor V on V.Vendor_Code= AD.Vendor_Code
						INNER JOIN Title T ON T.Title_Code = t1.Title_Code
						Group By AD.Syn_Deal_Code, Syn_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
									Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days,Vendor_Name
					) MainOutput
					Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
					) as a


					IF OBJECT_ID('tempdb..#Syn_EXPIRING_DEALS') IS NOT NULL DROP TABLE #Syn_EXPIRING_DEALS					

				END
				ELSE IF(@Alert_Type = 'ARHB')
				BEGIN
					PRINT 'ARHB'

					SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
									Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #ACQ_RHB_EXPIRING_DEALS
					FROM
					(
						SELECT adr.Acq_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
								adp.Is_Title_Language_Right ORDER BY adp.[Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
								Country_Code, Territory_Code, Territory_Type,
								sd.Acq_Deal_Code,adp.Right_Start_Date AS Actual_Right_Start_Date,adp.Right_End_Date AS Actual_Right_End_Date,
								DATEDIFF(dd,GETDATE(),IsNull(adp.Right_End_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
						From Acq_Deal_Rights adr (NOLOCK)
						INNER JOIN Acq_Deal SD (NOLOCK) ON SD.Acq_Deal_Code = adr.Acq_Deal_Code AND SD.Deal_Workflow_Status = 'A'
						INNER JOIN Acq_Deal_Pushback adp (NOLOCK) ON adp.Acq_Deal_Code = sd.Acq_Deal_Code
						INNER JOIN Acq_Deal_Pushback_Title adpt (NOLOCK) on adpt.Acq_Deal_Pushback_Code = adp.Acq_Deal_Pushback_Code
						--Inner Join Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
						Inner Join Acq_Deal_Pushback_Platform adrp (NOLOCK) On adp.Acq_Deal_Pushback_Code = adrp.Acq_Deal_Pushback_Code
						Inner Join Acq_Deal_Pushback_Territory adrc (NOLOCK) On adp.Acq_Deal_Pushback_Code = adrc.Acq_Deal_Pushback_Code
						Where ((adr.Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or adr.Right_Type <> 'M')
						AND ISNULL(Right_Status,'') = 'C'
						AND adr.Is_Tentative != 'Y'

					) b 
					Where [row] = 1
					 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
					And Exists 
					(
						Select 1 From #Alert_Range tmp 
						Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
					)
										

					INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
								Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
					SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
					FROM (
						Select Acq_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
						Expire_In_Days,
						(
							stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
							FROM #ACQ_RHB_EXPIRING_DEALS t2 
							Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
						) as PlatformCodes,
						CASE t1.Territory_Type
							WHEN 'G' THEN
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #ACQ_RHB_EXPIRING_DEALS t2
								Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)	 
							Else
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #ACQ_RHB_EXPIRING_DEALS t2
								Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)
						END	as CountryNames,
						t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
						V.Vendor_Name 
						FROM #ACQ_RHB_EXPIRING_DEALS t1
						INNER join  Acq_Deal AD on ad.Acq_Deal_Code= t1.Acq_Deal_Code
						INNER join  Vendor V on V.Vendor_Code= AD.Vendor_Code
						INNER JOIN Title T ON T.Title_Code = t1.Title_Code
						Group By AD.Acq_Deal_Code, Acq_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
									Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days,Vendor_Name
					) MainOutput
					Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
					) as a
							
					IF OBJECT_ID('tempdb..#ACQ_RHB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_RHB_EXPIRING_DEALS
					--select * from #DealDetails
				END
				ELSE IF(@Alert_Type = 'AHB')
				BEGIN
					PRINT 'AHB'

					SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
									Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #ACQ_HB_EXPIRING_DEALS
					FROM
					(
						SELECT adr.Acq_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
								adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
								Country_Code, Territory_Code, Territory_Type,
								sd.Acq_Deal_Code,Actual_Right_Start_Date,adrh.Holdback_Release_Date Actual_Right_End_Date,
								DATEDIFF(dd,GETDATE(),IsNull(adrh.Holdback_Release_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
						From Acq_Deal_Rights adr (NOLOCK)
						INNER JOIN Acq_Deal SD (NOLOCK) ON SD.Acq_Deal_Code = adr.Acq_Deal_Code AND SD.Deal_Workflow_Status = 'A'
						Inner Join Acq_Deal_Rights_Title adrt (NOLOCK) On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
						INNER JOIN Acq_Deal_Rights_Holdback adrh (NOLOCK) ON adrh.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
						Inner Join Acq_Deal_Rights_Holdback_Platform adrp (NOLOCK) On adrh.Acq_Deal_Rights_Holdback_Code = adrp.Acq_Deal_Rights_Holdback_Code
						Inner Join Acq_Deal_Rights_Holdback_Territory adrc (NOLOCK) On adrh.Acq_Deal_Rights_Holdback_Code = adrc.Acq_Deal_Rights_Holdback_Code
						--INNER JOIN Acq_Deal_Pushback adp ON adp.Acq_Deal_Code = sd.Acq_Deal_Code
						Where ((adr.Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or adr.Right_Type <> 'M')
						AND ISNULL(Right_Status,'') = 'C'
						AND adr.Is_Tentative != 'Y'
						--Where Actual_Right_End_Date Is Not Null
					) b 
					Where [row] = 1
					 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
					And Exists 
					(
						Select 1 From #Alert_Range tmp 
						Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
					)


					INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
								Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
					SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
					FROM (
						Select Acq_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
						Expire_In_Days,
						(
							stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
							FROM #ACQ_HB_EXPIRING_DEALS t2 
							Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
						) as PlatformCodes,
						CASE t1.Territory_Type
							WHEN 'G' THEN
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #ACQ_HB_EXPIRING_DEALS t2
								Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)	 
							Else
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #ACQ_HB_EXPIRING_DEALS t2
								Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)
						END	as CountryNames,
						t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
						V.Vendor_Name 
						FROM #ACQ_HB_EXPIRING_DEALS t1
						INNER join  Acq_Deal AD on ad.Acq_Deal_Code= t1.Acq_Deal_Code
						INNER join  Vendor V on V.Vendor_Code= AD.Vendor_Code
						INNER JOIN Title T ON T.Title_Code = t1.Title_Code
						Group By AD.Acq_Deal_Code, Acq_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
									Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days,Vendor_Name
					) MainOutput
					Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
					) as a

					IF OBJECT_ID('tempdb..#ACQ_HB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_HB_EXPIRING_DEALS
					
				END
				ELSE IF(@Alert_Type = 'SHB')
				BEGIN
					PRINT 'SHB'
					
					SELECT DISTINCT Syn_Deal_Code, Syn_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
									Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #SYN_HB_EXPIRING_DEALS
					FROM
					(
						SELECT adr.Syn_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
						adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
						Country_Code, Territory_Code, Territory_Type,
						sd.Syn_Deal_Code,Actual_Right_Start_Date,adrh.Holdback_Release_Date AS Actual_Right_End_Date,
						DATEDIFF(dd,GETDATE(),IsNull(adrh.Holdback_Release_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
						From Syn_Deal_Rights adr (NOLOCK)
						INNER JOIN Syn_Deal SD (NOLOCK) ON SD.Syn_Deal_Code = adr.Syn_Deal_Code AND SD.Deal_Workflow_Status = 'A'
						Inner Join Syn_Deal_Rights_Title adrt (NOLOCK) On adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
						INNER JOIN Syn_Deal_Rights_Holdback adrh (NOLOCK) ON adrh.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						Inner Join Syn_Deal_Rights_Holdback_Platform adrp (NOLOCK) On adrh.Syn_Deal_Rights_Holdback_Code = adrp.Syn_Deal_Rights_Holdback_Code
						Inner Join Syn_Deal_Rights_Holdback_Territory adrc (NOLOCK) On adrh.Syn_Deal_Rights_Holdback_Code = adrc.Syn_Deal_Rights_Holdback_Code
						--INNER JOIN Syn_Deal_Pushback adp ON adp.Syn_Deal_Code = sd.Acq_Deal_Code
						Where ((adr.Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or adr.Right_Type <> 'M')
						AND ISNULL(Right_Status,'') = 'C'
						AND adr.Is_Tentative != 'Y'
						--Where Actual_Right_End_Date Is Not Null
					) b 
					Where [row] = 1
					 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
					And Exists 
					(
						Select 1 From #Alert_Range tmp 
						Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
					)

					INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
								Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
					SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
					FROM (
						Select Syn_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
						Expire_In_Days,
						(
							stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
							FROM #SYN_HB_EXPIRING_DEALS t2 
							Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
						) as PlatformCodes,
						CASE t1.Territory_Type
							WHEN 'G' THEN
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #SYN_HB_EXPIRING_DEALS t2
								Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)	 
							Else
							(
								stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #SYN_HB_EXPIRING_DEALS t2
								Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Syn_Deal_Rights_Code = t1.Syn_Deal_Rights_Code 
								FOR XML PATH('') ), 1, 1, '')
							)
						END	as CountryNames,
						t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
						V.Vendor_Name 
						FROM #SYN_HB_EXPIRING_DEALS t1
						INNER join  Syn_Deal AD on ad.Syn_Deal_Code= t1.Syn_Deal_Code
						INNER join  Vendor V on V.Vendor_Code= AD.Vendor_Code
						INNER JOIN Title T ON T.Title_Code = t1.Title_Code
						Group By AD.Syn_Deal_Code, Syn_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
									Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days,Vendor_Name
					) MainOutput
					Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
					) as a

		
					IF OBJECT_ID('tempdb..#SYN_HB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #SYN_HB_EXPIRING_DEALS
					
				END


				------------
				DECLARE
				@To_Users_Code NVARCHAR(MAX),
				@To_User_Mail_Id  NVARCHAR(MAX),
				@CC_Users_Code  NVARCHAR(MAX),
				@CC_User_Mail_Id  NVARCHAR(MAX),
				@BCC_Users_Code  NVARCHAR(MAX),
				@BCC_User_Mail_Id  NVARCHAR(MAX),
				@Channel_Codes  NVARCHAR(MAX)
	
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

				PRINT @Alert_Type+'_'+CAST(@Event_Platform_Code as VARCHAR)+'_'+@Event_Template_Type+'_N'

				INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)				
				EXEC USP_Get_EmailConfig_Users @Alert_Type,@Event_Platform_Code, @Event_Template_Type,'N'
				--Select * from @Tbl2
				------------------

				DECLARE @Users_Code INT				
				DECLARE @Index INT = 0				
				DECLARE @Business_Unit_Code int,@Users_Email_Id NVARCHAR(MAX),@Emailbody NVARCHAR(Max)=''

				--IF(@Alert_Type = 'SHB' OR @Alert_Type = 'AHB')
				--			BEGIN
				--				SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
				--				SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
				--				<th align="center" width="15%" class="tblHead">Licensee</th>
				--				<th align="center" width="10%" class="tblHead">Title</th>
				--				<th align="center" width="10%" class="tblHead">Holdback Expiry Date</th>
				--				<th align="center" width="15%" class="tblHead">Country / Territory</th>
				--				<th align="center" width="30%" class="tblHead">Platform</th></tr>'
				--			END
				--			IF(@Alert_Type = 'SRHB' OR @Alert_Type = 'ARHB')
				--			BEGIN
				--				SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
				--				SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
				--				<th align="center" width="15%" class="tblHead">Licensee</th>
				--				<th align="center" width="10%" class="tblHead">Title</th>
				--				<th align="center" width="10%" class="tblHead">Holdback On Seller Period</th>
				--				<th align="center" width="15%" class="tblHead">Country / Territory</th>
				--				<th align="center" width="30%" class="tblHead">Platform</th></tr>'
				--			END

				--Change
	
				DECLARE curOuter CURSOR FOR SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
				--Change
				OPEN curOuter 
				FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
				WHILE @@Fetch_Status = 0 
				BEGIN	
					PRINT 'Outer Cursor'
					DECLARE @ID INT, @Record_Found CHAR(1), @Agreement_No VARCHAR(1000), @Title_Name NVARCHAR(MAX),
							@Rights_Start_Date VARCHAR(1000), @Rights_End_Date VARCHAR(1000),@Business_Unit_Code1 varchar(100),@Expire_In_Days1 varchar(100)
					DECLARE @Title_Code INT, @Territory_code INT, @Platform_Code varchar(1000), @Territory_Name NVARCHAR(MAX), @Platform_Name NVARCHAR(1000), 
							@PlatformCodeCount VARCHAR(20), @Acq_Deal_Rights_Code VARCHAR(1000),@Vendor_name NVARCHAR(max),@Allow_less_Than CHAR(1),
							@ROFR_Type NVARCHAR(max), @ROFR_Date VARCHAR(1000),
							@UL INT,@LL INT,@Mail_alert_days_Body int

					DECLARE @Temp_tbl_count int
					SELECT @Temp_tbl_count = 0, @Emailbody = '', @Index = 0, @Record_Found = 'N', @RowTitleCodeOld = ''
					
					

					DECLARE curBody CURSOR FOR SELECT DISTINCT Mail_Alert_Days,Allow_less_Than FROM #Alert_Range
					OPEN curBody 
					FETCH NEXT FROM curBody Into @Mail_alert_days_Body,@Allow_less_Than
					WHILE @@Fetch_Status = 0 
					BEGIN
						PRINT 'Cursor BOdy'
						SELECT @UL = 0, @LL = 0, @Index = 0
		
						IF(@Alert_Type = 'SRHB' OR @Alert_Type = 'AHB' OR @Alert_Type = 'SHB' OR @Alert_Type = 'ARHB')
						BEGIN
							--SET @Emailbody = @Emailbody + '<table class="tblFormat"><br><tr><td colspan="7"><b>Deals Expiring in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
							IF(@Allow_less_Than = 'Y')
							BEGIN
								SET @LL=0
								SET @UL=@Mail_alert_days_Body
							END
							ELSE
							BEGIN			
								IF(@Expiry_Type = 'D')
								BEGIN
									SET @LL=@Mail_alert_days_Body
									SET @UL=@Mail_alert_days_Body
								END
								ELSE IF(@Expiry_Type = 'W')
								BEGIN
									SET @LL=@Mail_alert_days_Body
									SET @UL=@Mail_alert_days_Body+7
								END
							END
						END
				
						PRINT 'LL:'+ CAST(@LL as varchar)
						PRINT 'UL:'+ CAST(@UL as varchar)
								
						--SET @Emailbody=@Emailbody + '<tr><td align="center" width="8%" class="tblHead"><b>Agreement#<b></td><td align="center" width="16%" class="tblHead"><b>Licensor<b></td>
						--	<td align="center" width="8%" class="tblHead"><b>Title<b></td>
						--	<td align="center" width="8%" class="tblHead"><b>Right Start Date<b></td>
						--	<td align="center" width="8%" class="tblHead"><b>Right End Date<b></td>
						--	<td align="center" width="12%" class="tblHead"><b>Country / Territory<b></td>
						--	<td align="center" width="40%" class="tblHead"><b>Platform<b></td></tr>'

							--SELECT DISTINCT Acq_Deal_Rights_Code,Agreement_No,Title_Name,IsNull(CONVERT(varchar(11),Right_Start_Date, 106),''),IsNull(CONVERT(varchar(11),Right_End_Date,106),''),Country,Platform_code,Platform_name,PlatformCodeCount,Vendor_name,Business_Unit_Code,Expire_In_Days,ROFR_Type,ROFR_Date
							--	FROM #DealDetails
							--	WHERE Business_Unit_Code=@Business_Unit_Code
							--	And Expire_in_days BETWEEN @LL And @UL
							--	And 0 <=  Expire_In_Days

							SET @Emailbody = @Notification_Body
							DECLARE @MainRowBody VARCHAR(MAX) = '', @ReplaceRowBody VARCHAR(MAX) = '', @PerRowBody VARCHAR(MAX) = '', @StartIndex INT = 0, @EndIndex INT = 0
							SELECT @StartIndex = CHARINDEX('<!--ROWSETSTART-->', @Emailbody), @EndIndex = CHARINDEX('<!--ROWSETEND-->', @Emailbody)

							SELECT @MainRowBody = SUBSTRING(@Emailbody, @StartIndex, (@EndIndex - @StartIndex) + 16)

							SET @Temp_tbl_count = 0
							
							DECLARE curP CURSOR FOR
								SELECT DISTINCT Acq_Deal_Rights_Code,Agreement_No,Title_Name,IsNull(CONVERT(varchar(11),Right_Start_Date, 106),''),IsNull(CONVERT(varchar(11),Right_End_Date,106),''),Country,Platform_code,Platform_name,PlatformCodeCount,Vendor_name,Business_Unit_Code,Expire_In_Days,ROFR_Type,ROFR_Date
								FROM #DealDetails
								WHERE Business_Unit_Code=@Business_Unit_Code
								And Expire_in_days BETWEEN @LL And @UL
								And 0 <=  Expire_In_Days

						OPEN curP 
						FETCH NEXT FROM curP INTO @Acq_Deal_Rights_Code,@Agreement_No,@Title_Name,@Rights_Start_Date,@Rights_End_Date,@Territory_Name,
												  @Platform_code,@Platform_name,@PlatformCodeCount,@Vendor_name,@Business_Unit_Code1,@Expire_In_Days1,@ROFR_Type,@ROFR_Date
						WHILE @@Fetch_Status = 0 
						BEGIN
						
							SET @Index  = @Index  + 1

							SELECT @PerRowBody = ''
							SET @RowTitleCodeNew=@Agreement_No+'|'+ @Title_Name +'|'+ ISNULL(@Rights_Start_Date, '') +'|'+ ISNULL(@Rights_End_Date, '') +'|'+ @Territory_Name +'|'+@Acq_Deal_Rights_Code+'|'+@Business_Unit_Code1
											
							if((@RowTitleCodeOld<>@RowTitleCodeNew))
							BEGIN					
								SET @Temp_tbl_count = @Temp_tbl_count + 1
								SELECT @PerRowBody = @MainRowBody

								SELECT @PerRowBody = REPLACE(@PerRowBody, '{Agreement_No}', CAST(ISNULL(@Agreement_No, ' ') AS NVARCHAR(1000)))								
								SELECT @PerRowBody = REPLACE(@PerRowBody, '{Licensee}', CAST(ISNULL(@Vendor_name, ' ') AS NVARCHAR(1000)))
								SELECT @PerRowBody = REPLACE(@PerRowBody, '{Title_Name}', CAST(ISNULL(@Title_Name, ' ') AS NVARCHAR(1000)))
								SELECT @PerRowBody = REPLACE(@PerRowBody, '{Country/Territory}', CAST(ISNULL(@Territory_Name, ' ') AS NVARCHAR(1000)))
								SELECT @PerRowBody = REPLACE(@PerRowBody, '{Platform}', CAST(ISNULL(@Platform_Name, ' ') AS NVARCHAR(1000)))								

								IF(@Alert_Type = 'SRHB' OR @Alert_type= 'ARHB') 
								BEGIN
									SELECT @PerRowBody = REPLACE(@PerRowBody, '{HoldbackPeriod}', CONVERT(varchar(11),IsNull(@Rights_Start_Date,''), 106)+' - '+CONVERT(varchar(11),IsNull(@Rights_END_Date,''), 106))

									INSERT INTO #ComparePlatform(Agreement_No, Acq_Deal_Rights_Code ,Platform_Name, IsInsert)
									Select @Agreement_No, @Acq_Deal_Rights_Code ,@Platform_Name, 'Y'
					
								END
												
								IF(@Alert_Type = 'SHB' OR @Alert_type= 'AHB') 
								BEGIN
									SELECT @PerRowBody = REPLACE(@PerRowBody, '{HoldbackExpiryDate}', CAST(ISNULL(CONVERT(VARCHAR(11),ISNULL(@Rights_END_Date,''), 106), ' ') AS NVARCHAR(1000)))

									INSERT INTO #ComparePlatform(Agreement_No, Acq_Deal_Rights_Code ,Platform_Name, IsInsert)
									Select @Agreement_No, @Acq_Deal_Rights_Code ,@Platform_Name, 'Y'
								END

								SELECT @ReplaceRowBody = @ReplaceRowBody + @PerRowBody

								SET @RowTitleCodeOld = @RowTitleCodeNew
							END
							ELSE
							BEGIN
				
								IF NOT EXISTS(SELECT * FROM #ComparePlatform WHERE Agreement_No = @Agreement_No AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Platform_Name = @Platform_Name)
								BEGIN
									SELECT @PerRowBody = REPLACE(@PerRowBody, '{Platform}', CAST(ISNULL(@Platform_Name, ' ') AS NVARCHAR(1000)))									
								END

								INSERT INTO #ComparePlatform(Agreement_No, Acq_Deal_Rights_Code ,Platform_Name, IsInsert)
								SELECT @Agreement_No, @Acq_Deal_Rights_Code ,@Platform_Name, 'Y'
							END
														
							FETCH NEXT FROM curP INTO @Acq_Deal_Rights_Code,@Agreement_No,@Title_Name,@Rights_Start_Date,@Rights_End_Date,@Territory_Name,@Platform_code,@Platform_name,@PlatformCodeCount,@Vendor_name,@Business_Unit_Code1,@Expire_In_Days1,@ROFR_Type,@ROFR_Date
						END -- End of Fetch Inner
						CLOSE curP
						DEALLOCATE curP
									
						IF( @Temp_tbl_count <> 0)
						BEGIN
							SELECT @Emailbody = REPLACE(@Emailbody, @MainRowBody, @ReplaceRowBody)

							DECLARE @DefaultSiteUrl NVARCHAR(500),@Deal_Expiry_Email_Template_Desc NVARCHAR(2000);	SET @DefaultSiteUrl = ''
							SET @Deal_Expiry_Email_Template_Desc=''
							SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
							
							DECLARE @BU_Name NVARCHAR(200)
							SELECT @BU_Name = Business_Unit_Name FROM Business_Unit WHERE Business_Unit_Code =  @Business_Unit_Code
														
							DECLARE @DatabaseEmail_Profile NVARCHAR(200)	
							SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
							
							SELECT @MailSubjectCr = REPLACE(@Notification_Subject, '{Expiring_Days}', CAST(@Mail_alert_days_Body AS NVARCHAR))
							SELECT @MailSubjectCr = REPLACE(@MailSubjectCr, '{BU_Name}', @BU_Name)

							SELECT @Emailbody = REPLACE(@Emailbody, '{BU_Name}', @BU_Name)
			
							IF(@Emailbody!='' AND @Index > 0)
							BEGIN
								INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
								SELECT @Email_Config_Code,@Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), @MailSubjectCr
							END

							SET @Emailbody = ''
						END
			
						FETCH NEXT FROM curBody INTO @Mail_alert_days_Body,@Allow_less_Than
					END -- End of Fetch body
					CLOSE curBody
					DEALLOCATE curBody


					--SET @Emailbody = ''

	
					--IF( @Temp_tbl_count <> 0)
					--BEGIN
					--	DECLARE @DefaultSiteUrl NVARCHAR(500),@Deal_Expiry_Email_Template_Desc NVARCHAR(2000);	SET @DefaultSiteUrl = ''
					--	SET @Deal_Expiry_Email_Template_Desc=''
					--	SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
					--	DECLARE @EmailHead NVARCHAR(max)

					--	DECLARE @BU_Name NVARCHAR(200)
					--	SELECT @BU_Name = Business_Unit_Name FROM Business_Unit WHERE Business_Unit_Code =  @Business_Unit_Code

					--	set @EmailHead= '<html><head><style>
					--	table.tblFormat{border:1px solid black;border-collapse:collapse;}
					--	th.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px; style="font-weight:bold;"}
					--	td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>'

					--	IF(@Alert_Type = 'SRHB')
					--	BEGIN							

					--		SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals have Syndication Holdback on Seller expiring on the Period indicated below. You are requested to take note of the same and determine the next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					--			<br><br>Business Unit: '+@BU_Name+''

					--	END
					--	IF(@Alert_Type = 'AHB')
					--	BEGIN							

					--		SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Acquisition Deals have Holdback expiring on the End Dates indicated below. You are requested to take note of the same and determine the next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					--			<br><br>Business Unit: '+@BU_Name+''

					--	END
					--	IF(@Alert_Type = 'SHB')
					--	BEGIN							

					--		SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Syndication Deals have Holdback expiring on the End Dates indicated below. You are requested to take note of the same and determine the next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					--			<br><br>Business Unit: '+@BU_Name+''

					--	END
					--	IF(@Alert_Type = 'ARHB')
					--	BEGIN							

					--		SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals have Acquisition Holdback on Seller expiring on the Period indicated below. You are requested to take note of the same and determine the next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					--			<br><br>Business Unit: '+@BU_Name+''

					--	END

			
					--	DECLARE @EMailFooter NVARCHAR(200)
					--	SET @EMailFooter ='&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="2" COLOR="gray">This email is generated by RightsU (Rights Management System)</font></body></html>'
					--	DECLARE @DatabaseEmail_Profile NVARCHAR(200)	
					--	SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
					--	--SELECT @DatabaseEmail_Profile
					--	Print @Emailbody
		

					--	DECLARE @EmailUser_Body NVARCHAR(Max)
					--	Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
			

					--	IF(@Alert_Type = 'ACE' OR @Alert_Type = 'SRHB')
					--	BEGIN
					--		SET @MailSubjectCr = 'Notification of all Syndication Holdback on Seller Expiring in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
					--	END
					--	IF(@Alert_Type = 'AHB')
					--	BEGIN
					--		SET @MailSubjectCr = 'Notification of all Acquisition Holdbacks Expiring in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
					--	END
					--	IF(@Alert_Type = 'SHB')
					--	BEGIN
					--		SET @MailSubjectCr = 'Notification of all Syndication Holdbacks Expiring in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
					--	END
					--	IF(@Alert_Type = 'ARHB')
					--	BEGIN
					--		SET @MailSubjectCr = 'Notification of all Acquisition Holdback on Seller Expiring in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
					--	END
			
					--	IF(@Emailbody!='')
					--	BEGIN
					--		INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
					--		SELECT @Email_Config_Code,@EmailUser_Body, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), @MailSubjectCr
					--	END

					--	SET @Emailbody = ''
					--END
				FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes

				END -- End of Fetch outer
				CLOSE curOuter
				DEALLOCATE curOuter		
	
				--Select * from @Email_Config_Users_UDT

				EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT, 0, 0, @Email_Config_Code, @Event_Platform_Code, @Event_Template_Type

				DELETE FROM @Email_Config_Users_UDT

				DROP TABLE #DealDetails --#ACQ_EXPIRING_DEALS#DealDetails 
				
				IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS#DealDetails') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS#DealDetails
				IF OBJECT_ID('tempdb..#ACQ_TENTATIVE_DEALS') IS NOT NULL DROP TABLE #ACQ_TENTATIVE_DEALS
				--IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL DROP TABLE #Alert_Range
				IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL DROP TABLE #DealDetails				
				IF OBJECT_ID('tempdb..#SYN_EXPIRING_DEALS') IS NOT NULL DROP TABLE #SYN_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ACQ_HB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_HB_EXPIRING_DEALS
				IF OBJECT_ID('tempdb..#ACQ_RHB_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_RHB_EXPIRING_DEALS

				FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type

		END
		CLOSE curNotificationPlatforms
		DEALLOCATE curNotificationPlatforms
	
		IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL DROP TABLE #Alert_Range
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_HoldbackExpiryMail]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''  	 
END