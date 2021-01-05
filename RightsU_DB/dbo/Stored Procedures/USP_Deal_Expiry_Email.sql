CREATE PROCEDURE [dbo].[USP_Deal_Expiry_Email] 
--DECLARE
@Expiry_Type Char(1)='D',
@Alert_Type CHAR(4)='TER'
AS
-- =============================================
-- Author:		Punam Roddewar
-- Create DATE: 23-Jan-2015
-- Description:	Send Acquisition deal expiry mail or ROFR mail
--				@Alert_Type is 'A' means 'Acquisition deal expiry mail' or 
--				@Alert_Type is 'R' means 'ROFR mail' --Expiry_Type=D/W
--				@Alert_Type is 'S' means 'Syn deal expiry mail' or 	
--Last Updated by : Akshay Rane
-- =============================================     
BEGIN 

--DECLARE
--@Expiry_Type Char(1)='D',
--@Alert_Type CHAR(4)='AROD'

	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#EMAIL_ID_TEMP1') IS NOT NULL
	BEGIN
		DROP TABLE #EMAIL_ID_TEMP1
	END 
	IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS') IS NOT NULL
	BEGIN
		DROP TABLE #ACQ_EXPIRING_DEALS
	END
	--DECLARE @Expiry_Type Char(1), @Alert_Type CHAR(1)
	--SELECT  @Expiry_Type = 'D', @Alert_Type = 'A'
	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = @Alert_Type
	DECLARE @EXP_Count	int
	SET @EXP_Count = ''
	
	DECLARE @Deal_heading VARCHAR(20) = 'Expiring'		
	DECLARE @RowTitleCodeOld varchar(max),@RowTitleCodeNew varchar(max),@WhereCondition varchar (2)
	SET @RowTitleCodeOld = ''
	SET @RowTitleCodeNew = ''
	
	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL
	BEGIN
		DROP TABLE #DealDetails
	END
	IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL
	BEGIN
		Drop Table #Alert_Range
	END
	DECLARE @MailSubjectCr AS VARCHAR(250),@Mail_alert_days int,@Deal_Expiry_email_code int
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
	--select * from Email_Config_Detail_Alert
	
	--Select Distinct Case When Allow_less_Than = 'Y' Then 0 Else Mail_alert_days End As Start_Range, Mail_alert_days As End_Range InTo #Alert_Range
	--From Deal_Expiry_Email Where Alert_Type = @Alert_Type
	--select * from Email_Config_Detail_Alert
	--Change
	Select Distinct Case When EDA.Allow_less_Than = 'Y' Then 0 Else Mail_Alert_Days End As Start_Range, Mail_Alert_Days As End_Range
	, EDA.Allow_less_Than, EDA.Mail_Alert_Days 
	InTo #Alert_Range
	From Email_Config_Detail_Alert EDA
	INNER JOIN Email_Config_Detail ED ON ED.Email_Config_Detail_Code=EDA.Email_Config_Detail_Code
	INNER JOIN Email_Config E ON E.Email_Config_Code=ED.Email_Config_Code
	Where E.[Key] = @Alert_Type 
	--Change
	--select * from #Alert_Range
	IF(@Alert_Type = 'ACE')
	BEGIN
	PRINT 'ACE1'
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
						Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #ACQ_EXPIRING_DEALS
		FROM
		(		 
			SELECT DISTINCT adr.Acq_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
					adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
					Country_Code, Territory_Code, Territory_Type,
					ad.Acq_Deal_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
					DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
			From Acq_Deal_Rights adr 
			INNER JOIN Acq_Deal Ad ON Ad.Acq_Deal_Code = adr.Acq_Deal_Code AND Ad.Deal_Workflow_Status = 'A'
			Inner Join Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
			Inner Join Acq_Deal_Rights_Platform adrp On adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
			Inner Join Acq_Deal_Rights_Territory adrc On adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
			Where ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M') 
			AND adr.Is_Tentative != 'Y'
			--Where Actual_Right_End_Date Is Not Null
		) b 
		Where [row] = 1 And getdate() Between Actual_Right_Start_Date And Actual_Right_End_Date
		And Exists (
			Select 1 From #Alert_Range tmp Where b.Expire_In_Days Between tmp.Start_Range And tmp.End_Range
		)

		INSERT INTO #DealDetails(Platform_name,PlatformCodeCount,Acq_Deal_Rights_Code,Agreement_No,Title_Code,Title_Name,
					Right_Start_Date,Right_End_Date,Expire_In_Days,Platform_Code,Country,Is_Processed,Business_Unit_Code,Vendor_Name)
		SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count,MainOutput.*
		FROM (
			Select Acq_Deal_Rights_Code,Ad.Agreement_No, T.Title_Code, T.title_name,Actual_Right_Start_Date,Actual_Right_End_Date,
			Expire_In_Days,
			(
				stuff((SELECT DISTINCT ',' + cast(Platform_Code as varchar(max)) 
				FROM #ACQ_EXPIRING_DEALS t2 
				Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
			) as PlatformCodes,
			CASE t1.Territory_Type
				WHEN 'G' THEN
				(
					stuff((SELECT DISTINCT ', ' + cast(c.Territory_Name as NVARCHAR(max))FROM #ACQ_EXPIRING_DEALS t2
					Inner Join Territory c On t2.Territory_Code = c.Territory_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)	 
				Else
				(
					stuff((SELECT DISTINCT ', ' + cast(c.Country_Name as NVARCHAR(max))FROM #ACQ_EXPIRING_DEALS t2
					Inner Join Country c On t2.Country_Code = c.Country_Code Where t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)
			END	as CountryNames,
			t1.IsProcessed, IsNull(Business_Unit_Code,0) as Business_Unit_Code,
			(
				stuff((SELECT DISTINCT ', ' + cast(Vendor_Name as NVARCHAR(max))
				FROM Vendor v1 
				inner join Acq_Deal_Licensor a1 on v1.Vendor_Code=a1.Vendor_Code 
				WHERE a1.Acq_Deal_Code=AD.Acq_Deal_Code FOR XML PATH('') ), 1, 1, '') 
			) as Vendor_Name
			FROM #ACQ_EXPIRING_DEALS t1
			INNER join  Acq_Deal AD on ad.Acq_Deal_Code= t1.Acq_Deal_Code
			INNER JOIN Title T ON T.Title_Code = t1.Title_Code
			Group By AD.Acq_Deal_Code, Acq_Deal_Rights_Code,Ad.Agreement_No,T.Title_Code,T.title_name,
						Actual_Right_Start_Date,Actual_Right_End_Date,IsProcessed,Business_Unit_Code,Territory_Type,Expire_In_Days--,Vendor_Name
		) MainOutput
		Cross Apply(Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
		) as a
			
		Drop table #ACQ_EXPIRING_DEALS
	END
	ELSE IF(@Alert_Type = 'SYE')
	BEGIN
		SELECT DISTINCT Syn_Deal_Code, Syn_Deal_Rights_Code,Title_Code,Country_Code,Territory_Code,Territory_Type,Platform_Code,Actual_Right_Start_Date,
						Actual_Right_End_Date,IsProcessed, Expire_In_Days InTo #SYN_EXPIRING_DEALS
		FROM
		(
			SELECT DISTINCT adr.Syn_Deal_Rights_Code, ROW_NUMBER()OVER(PARTITION BY Title_Code,country_code,platform_code,
					adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] Desc ) AS [row],Platform_Code,Title_Code,
					Country_Code, Territory_Code, Territory_Type,
					sd.Syn_Deal_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
					DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days, 'N' as IsProcessed
			From Syn_Deal_Rights adr 
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code = adr.Syn_Deal_Code AND SD.Deal_Workflow_Status = 'A'
			Inner Join Syn_Deal_Rights_Title adrt On adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
			Inner Join Syn_Deal_Rights_Platform adrp On adr.Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code
			Inner Join Syn_Deal_Rights_Territory adrc On adr.Syn_Deal_Rights_Code = adrc.Syn_Deal_Rights_Code
			Where ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M')
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

		Drop table #Syn_EXPIRING_DEALS
	END
	ELSE IF(@Alert_Type = 'TER')
	BEGIN
		
			SELECT DISTINCT adr.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adrc.Country_Code, adrc.Territory_Code, Territory_Type, adrp.Platform_Code, 
					 Actual_Right_Start_Date, Actual_Right_End_Date, 'N' as IsProcessed, 
					DATEDIFF(dd, GETDATE(), ISNULL(Actual_Right_Start_Date, '31Dec9999')) AS Expire_In_Days
			INTO #ACQ_TENTATIVE_DEALS
			FROM Acq_Deal_Rights adr 
			INNER JOIN Acq_Deal_Rights_Title adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Territory adrc ON adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
			WHERE 1 =1 --GETDATE() BETWEEN Actual_Right_Start_Date AND Actual_Right_End_Date
			AND EXISTS (
				SELECT 1 FROM #Alert_Range tmp WHERE DATEDIFF(dd, GETDATE(), ISNULL(Actual_Right_Start_Date, '31Dec9999')) BETWEEN tmp.Start_Range AND tmp.End_Range
			)
			AND ISNULL(adr.Is_Tentative, 'Y') = 'Y'
			
		INSERT INTO #DealDetails(Platform_name, PlatformCodeCount, Acq_Deal_Rights_Code, Agreement_No, Title_Code, Title_Name,
					Right_Start_Date, Right_End_Date, Expire_In_Days, Platform_Code, Country, Is_Processed, Business_Unit_Code, Vendor_Name)
		SELECT DISTINCT a.Platform_Hiearachy AS Platform_Name, a.Platform_Count, MainOutput.*
		FROM (
			SELECT Acq_Deal_Rights_Code, Ad.Agreement_No, T.Title_Code, T.title_name, Actual_Right_Start_Date, Actual_Right_End_Date,
			Expire_In_Days,
			(
				STUFF((SELECT DISTINCT ',' + CAST(Platform_Code AS VARCHAR(MAX)) 
				FROM #ACQ_TENTATIVE_DEALS t2 
				WHERE t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code FOR XML PATH('') ), 1, 1, '')
			) AS PlatformCodes,
			CASE t1.Territory_Type
				WHEN 'G' THEN
				(
					STUFF((SELECT DISTINCT ', ' + CAST(c.Territory_Name AS NVARCHAR(MAX))FROM #ACQ_TENTATIVE_DEALS t2
					INNER JOIN Territory c ON t2.Territory_Code = c.Territory_Code WHERE t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)	 
				ELSE
				(
					STUFF((SELECT DISTINCT ', ' + CAST(c.Country_Name AS NVARCHAR(MAX))FROM #ACQ_TENTATIVE_DEALS t2
					INNER JOIN Country c ON t2.Country_Code = c.Country_Code WHERE t2.Acq_Deal_Rights_Code = t1.Acq_Deal_Rights_Code 
					FOR XML PATH('') ), 1, 1, '')
				)
			END	AS CountryNames,
			t1.IsProcessed, ISNULL(Business_Unit_Code,0) AS Business_Unit_Code,
			(
				STUFF((SELECT DISTINCT ', ' + CAST(Vendor_Name AS NVARCHAR(MAX))
				FROM Vendor v1 
				INNER JOIN Acq_Deal_Licensor a1 ON v1.Vendor_Code=a1.Vendor_Code 
				WHERE a1.Acq_Deal_Code=AD.Acq_Deal_Code FOR XML PATH('') ), 1, 1, '') 
			) AS Vendor_Name
			FROM #ACQ_TENTATIVE_DEALS t1
			INNER JOIN  Acq_Deal AD ON ad.Acq_Deal_Code = t1.Acq_Deal_Code
			INNER JOIN Title T ON T.Title_Code = t1.Title_Code
			GROUP BY AD.Acq_Deal_Code, Acq_Deal_Rights_Code, Ad.Agreement_No, T.Title_Code, T.title_name,
						Actual_Right_Start_Date, Actual_Right_End_Date, IsProcessed, Business_Unit_Code, Territory_Type, Expire_In_Days--,Vendor_Name
		) MainOutput
			CROSS APPLY(SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.PlatformCodes)
		) AS a

		DROP TABLE #ACQ_TENTATIVE_DEALS
	END
	ELSE IF(@Alert_Type = 'AROD')
	BEGIN
	PRINT 'AROD'
		SET @Deal_heading ='ROFR'
		INSERT INTO #DealDetails(Agreement_No,Title_Code,Title_Name,Right_Start_Date,Right_End_Date,Platform_Code,Platform_name,
				Country,Is_Processed,PlatformCodeCount,Acq_Deal_Rights_Code,Expire_In_Days,Business_Unit_Code,Vendor_Name,ROFR_Date, ROFR_Type)
		SELECT DISTINCT  Agreement_No, Title_Code, Title_name, Right_Start_Date, Right_End_Date, PlatformCodes, Platform_Name,
				Country,'N' as IsProcessed,Platform_Count,cast (Acq_Deal_Rights_Code as varchar(1000)), ROFR_In_Days,
				IsNull(Business_Unit_Code,0),Vendor_Name , b.ROFR_Date , b.ROFR_Type
		FROM VW_ACQ_EXPIRING_DEALS b
		Where ROFR_In_Days Is Not Null And ROFR_In_Days > 0
		And Exists (
			Select 1 From #Alert_Range tmp Where b.ROFR_In_Days Between tmp.Start_Range And tmp.End_Range
		)
	END	
	ELSE IF(@Alert_Type = 'SROD')
	BEGIN
	PRINT 'SROD'
		SET @Deal_heading ='ROFR'
		INSERT INTO #DealDetails(Agreement_No,Title_Code,Title_Name,Right_Start_Date,Right_End_Date,Platform_Code,Platform_name,
				Country,Is_Processed,PlatformCodeCount,Acq_Deal_Rights_Code,Expire_In_Days,Business_Unit_Code,Vendor_Name,ROFR_Date, ROFR_Type)
		SELECT DISTINCT  Agreement_No, Title_Code, Title_name, Right_Start_Date, Right_End_Date, PlatformCodes, Platform_Name,
				Country,'N' as IsProcessed,Platform_Count,cast (Syn_Deal_Rights_Code as varchar(1000)), ROFR_In_Days,
				IsNull(Business_Unit_Code,0),Vendor_Name , b.ROFR_Date , b.ROFR_Type
		FROM VW_SYN_EXPIRING_DEALS b
		Where ROFR_In_Days Is Not Null And ROFR_In_Days > 0
		And Exists (
			Select 1 From #Alert_Range tmp Where b.ROFR_In_Days Between tmp.Start_Range And tmp.End_Range
		)
	END	

	DECLARE @Users_Code INT
	--Drop Table #Alert_Range
	DECLARE @Index INT = 0
	--Select * from  #DealDetails --------------------------------------------------------------------------------------------------------
	DECLARE @Business_Unit_Code int,@Users_Email_Id NVARCHAR(MAX),@Emailbody NVARCHAR(Max)
	--Change
	DECLARE curOuter CURSOR FOR SELECT BuCode,User_Mail_Id,Users_Code from [dbo].[UFN_Get_Bu_Wise_User](@Alert_Type)
	--Change
	--DECLARE curOuter CURSOR FOR SELECT DISTINCT Business_Unit_Code, Users_Email_id from Deal_Expiry_Email WHERE Business_Unit_Code Is not Null And Alert_Type = @Alert_Type
	OPEN curOuter 
	FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @Users_Email_Id,@Users_Code
	WHILE @@Fetch_Status = 0 
	BEGIN		
		Declare @Temp_tbl_count int
		Set @Temp_tbl_count=0
		Set @Emailbody = ''
		SET @Index = 0
		DECLARE @ID INT, @Record_Found CHAR(1), @Agreement_No VARCHAR(1000), @Title_Name NVARCHAR(MAX),
				@Rights_Start_Date VARCHAR(1000), @Rights_End_Date VARCHAR(1000),@Business_Unit_Code1 varchar(100),@Expire_In_Days1 varchar(100)
		DECLARE @Title_Code INT, @Territory_code INT, @Platform_Code varchar(1000), @Territory_Name NVARCHAR(1000), @Platform_Name NVARCHAR(1000), 
				@PlatformCodeCount VARCHAR(20), @Acq_Deal_Rights_Code VARCHAR(1000),@Vendor_name NVARCHAR(max),@Allow_less_Than CHAR(1),
				@ROFR_Type NVARCHAR(max), @ROFR_Date VARCHAR(1000)
		set @Record_Found = 'N'	
		Set @RowTitleCodeOld = ''
		DECLARE @UL INT,@LL INT
		--Add new cur for slab
		Declare @Mail_alert_days_Body int
		Declare curBody cursor For 
		--select distinct Mail_alert_days,Allow_less_Than from Deal_Expiry_Email
		--Where Business_Unit_Code = @Business_Unit_Code And Users_Email_id = @Users_Email_Id And  Alert_Type = @Alert_Type
		--Change
		--Select Distinct EDA.Mail_Alert_Days,EDA.Allow_less_Than
		--From Email_Config_Detail_Alert EDA
		--INNER JOIN Email_Config_Detail ED ON ED.Email_Config_Detail_Code=EDA.Email_Config_Detail_Code
		--INNER JOIN Email_Config_Detail_User EDU ON ED.Email_Config_Detail_Code=EDU.Email_Config_Detail_Code
		--INNER JOIN Email_Config E ON E.Email_Config_Code=ED.Email_Config_Code
		--Where E.[Key] = @Alert_Type
		--Change
		select DISTINCT Mail_Alert_Days,Allow_less_Than FROM #Alert_Range
		OPEN curBody 
		Fetch Next From curBody Into @Mail_alert_days_Body,@Allow_less_Than
		While @@Fetch_Status = 0 
		Begin
			SET @UL=0
			SET @LL=0
			SET @Index = 0
			IF(@Alert_Type = 'ACE')
			BEGIN
			PRINT 'ACE2'
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
			ELSE IF(@Alert_Type = 'SYE')
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
			ELSE IF(@Alert_Type = 'TER')
			BEGIN
				--SET @Emailbody = @Emailbody + '<table class="tblFormat"><br><tr><td colspan="7"><b>Deals Expiring in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
				IF(@Allow_less_Than = 'Y')
				BEGIN
					SET @LL = 0
					SET @UL = @Mail_alert_days_Body
				END
				ELSE
				BEGIN			
					IF(@Expiry_Type = 'D')
					BEGIN
						SET @LL = @Mail_alert_days_Body
						SET @UL = @Mail_alert_days_Body
					END
					ELSE IF(@Expiry_Type = 'W')
					BEGIN
						SET @LL = @Mail_alert_days_Body
						SET @UL = @Mail_alert_days_Body + 7
					END
				END
			END
			ELSE
			BEGIN
			PRINT 'ROD2'
				--SET @Emailbody = @Emailbody + '<table class="tblFormat" ><br><tr><td colspan="7"><b>Deals ROFR in ' + Cast(@Mail_alert_days_Body As Varchar) + ' days </b></td></tr>'
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

			--SET @Emailbody=@Emailbody + '<tr><td align="center" width="8%" class="tblHead"><b>Agreement#<b></td><td align="center" width="16%" class="tblHead"><b>Licensor<b></td>
			--	<td align="center" width="8%" class="tblHead"><b>Title<b></td>
			--	<td align="center" width="8%" class="tblHead"><b>Right Start Date<b></td>
			--	<td align="center" width="8%" class="tblHead"><b>Right End Date<b></td>
			--	<td align="center" width="12%" class="tblHead"><b>Country / Territory<b></td>
			--	<td align="center" width="40%" class="tblHead"><b>Platform<b></td></tr>'

			SELECT DISTINCT Acq_Deal_Rights_Code,Agreement_No,Title_Name,IsNull(CONVERT(varchar(11),Right_Start_Date, 106),''),IsNull(CONVERT(varchar(11),Right_End_Date,106),''),Country,Platform_code,Platform_name,PlatformCodeCount,Vendor_name,Business_Unit_Code,Expire_In_Days,ROFR_Type,ROFR_Date
					FROM #DealDetails
			Declare curP cursor For
					SELECT DISTINCT Acq_Deal_Rights_Code,Agreement_No,Title_Name,IsNull(CONVERT(varchar(11),Right_Start_Date, 106),''),IsNull(CONVERT(varchar(11),Right_End_Date,106),''),Country,Platform_code,Platform_name,PlatformCodeCount,Vendor_name,Business_Unit_Code,Expire_In_Days,ROFR_Type,ROFR_Date
					FROM #DealDetails
					WHERE Business_Unit_Code=@Business_Unit_Code
					And Expire_in_days BETWEEN @LL And @UL
					And 0 <=  Expire_In_Days
			OPEN curP 
			Fetch Next From curP Into @Acq_Deal_Rights_Code,@Agreement_No,@Title_Name,@Rights_Start_Date,@Rights_End_Date,@Territory_Name,@Platform_code,@Platform_name,@PlatformCodeCount,@Vendor_name,@Business_Unit_Code1,@Expire_In_Days1,@ROFR_Type,@ROFR_Date
			While @@Fetch_Status = 0 
			Begin
			IF(@Index = 0)
			BEGIN
				IF(@Alert_Type = 'TER')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensor</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">Right Start Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'

				END
				ELSE IF(@Alert_Type = 'AROD' OR  @Alert_Type = 'SROD')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
					
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensor</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">ROFR Type</th>
					<th align="center" width="10%" class="tblHead">ROFR Trigger Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'

				END
				ELSE IF(@Alert_Type = 'ACE')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensor</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">Right End Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'
				END
				ELSE IF(@Alert_Type = 'SYE')
				BEGIN
					SET @Emailbody = @Emailbody + '<table class="tblFormat"><br>'
				
					SET @Emailbody=@Emailbody + '<tr><th align="center" width="10%" class="tblHead">Agreement#</th>
					<th align="center" width="15%" class="tblHead">Licensee</th>
					<th align="center" width="10%" class="tblHead">Title</th>
					<th align="center" width="10%" class="tblHead">Right End Date</th>
					<th align="center" width="15%" class="tblHead">Country / Territory</th>
					<th align="center" width="30%" class="tblHead">Platform</th></tr>'
				END
		
			END
				SET @Index  = @Index  + 1

				SET @RowTitleCodeNew=@Agreement_No+'|'+ @Title_Name +'|'+ IsNull(@Rights_Start_Date, '') +'|'+ IsNull(@Rights_End_Date, '') +'|'+ @Territory_Name +'|'+@Acq_Deal_Rights_Code+'|'+@Business_Unit_Code1
				
				if((@RowTitleCodeOld<>@RowTitleCodeNew))
				Begin
					set @Temp_tbl_count=@Temp_tbl_count+1

						IF(@Alert_Type = 'TER')
						BEGIN
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>						
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@Rights_Start_Date,''), 106)  +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'

						END
						ELSE IF(@Alert_Type = 'AROD' OR  @Alert_Type = 'SROD')
						BEGIN
					
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@ROFR_Type, '') as NVARCHAR(1000))+'</td>		
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@ROFR_Date,''), 106)  +'</td>				
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'

						END
						ELSE IF(@Alert_Type = 'ACE')
						BEGIN
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>						
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@Rights_END_Date,''), 106)  +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'
					
						END
						ELSE IF(@Alert_Type = 'SYE')
						BEGIN
							select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Agreement_No, ' ') as NVARCHAR(1000)) +' </td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Vendor_name, ' ') as NVARCHAR(max)) +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST	 (ISNULL(@Title_Name, ' ') as NVARCHAR(1000))+'</td>						
							<td align="center" class="tblData" rowspan='+@PlatformCodeCount+'>'+CONVERT(varchar(11),IsNull(@Rights_END_Date,''), 106)  +'</td>
							<td class="tblData" rowspan='+@PlatformCodeCount+'>'+ CAST  (ISNULL(@Territory_Name, ' ') as NVARCHAR(1000)) +'</td>
							<td class="tblData" >'+ CAST  (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'
					
						END

					Set @RowTitleCodeOld = @RowTitleCodeNew
				End
				Else
				BEGIN
					select @Emailbody=@Emailbody +'<tr>	
					<td  class="tblData">'+ CAST (ISNULL(@Platform_Name, ' ') as NVARCHAR(1000)) +'</td></tr>'
				End
				Fetch Next From curP Into @Acq_Deal_Rights_Code,@Agreement_No,@Title_Name,@Rights_Start_Date,@Rights_End_Date,@Territory_Name,@Platform_code,@Platform_name,@PlatformCodeCount,@Vendor_name,@Business_Unit_Code1,@Expire_In_Days1,@ROFR_Type,@ROFR_Date
			End -- End of Fetch Inner
			Close curP
			Deallocate curP
			
			SET @Emailbody = @Emailbody + '</table>'
			Fetch Next From curBody Into @Mail_alert_days_Body,@Allow_less_Than
		End -- End of Fetch body
		Close curBody
		Deallocate curBody
		IF( @Temp_tbl_count <> 0)
		BEGIN
			DECLARE @DefaultSiteUrl NVARCHAR(500),@Deal_Expiry_Email_Template_Desc NVARCHAR(2000);	SET @DefaultSiteUrl = ''
			SET @Deal_Expiry_Email_Template_Desc=''
			SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
			DECLARE @EmailHead NVARCHAR(max)
			set @EmailHead= '<html><head><style>
			table.tblFormat{border:1px solid black;border-collapse:collapse;}
			th.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px; style="font-weight:bold;"}
			td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>'

			IF(@Alert_Type = 'ACE')
			BEGIN
			PRINT 'ACE3'

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals are expiring on the Rights End Dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					<br><br><table border="1" cellspacing="0" cellpadding="3">'
			END
			ELSE IF(@Alert_Type = 'SYE')
			BEGIN							

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals are expiring on the Rights End Dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
					<br><br><table border="1" cellspacing="0" cellpadding="3">'

			END
			ELSE IF(@Alert_Type = 'TER')
			BEGIN							

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned Deals have tentative start date. You are requested to take note of the same and determine next steps.</b> 
				<br><br><table border="1" cellspacing="0" cellpadding="3">'

			END
			ELSE IF(@Alert_Type = 'AROD')
			BEGIN
				PRINT 'ROD1'

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned deals where Right of First Negotiation (Acquisition ROFR) is available to Viacom18, are nearing the trigger dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact.</b> 
										<br><br><table border="1" cellspacing="0" cellpadding="3">'
			END
			ELSE IF(@Alert_Type = 'SROD')
			BEGIN
				PRINT 'ROD1'

				SET @EmailHead= @EmailHead+'Dear User,<br><br> Kindly take note that the below mentioned deals where Right of First Negotiation (Syndication ROFR) is available to Viacom18, are nearing the trigger dates indicated below. You are requested to take note of the same and determine next steps. If you need any further information regarding any of the below deals, please get in touch with your Legal Contact</b> 
										<br><br><table border="1" cellspacing="0" cellpadding="3">'

			END
			DECLARE @EMailFooter NVARCHAR(200)
			SET @EMailFooter ='&nbsp;</br>&nbsp;</br><FONT FACE="verdana" SIZE="2" COLOR="gray">This email is generated by RightsU (Rights Management System)</font></body></html>'
			DECLARE @DatabaseEmail_Profile NVARCHAR(200)	
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
			--SELECT @DatabaseEmail_Profile
			--Print @Emailbody
			DECLARE @EmailUser_Body NVARCHAR(Max)
			Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
			
			DECLARE @BU_Name NVARCHAR(200)
			SELECT @BU_Name = Business_Unit_Name FROM Business_Unit WHERE Business_Unit_Code =  @Business_Unit_Code
			

			IF(@Alert_Type = 'ACE' OR @Alert_Type = 'SYE')
			BEGIN
				SET @MailSubjectCr = 'Notification of all deals Expiring in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
				END
			ELSE IF(@Alert_Type = 'AROD' )
				SET @MailSubjectCr = 'Notification of Acquisition ROFR becoming available in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
			ELSE IF(@Alert_Type = 'SROD')
				SET @MailSubjectCr = 'Notification of Syndication ROFR becoming available in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +' days - Business Unit: '+ @BU_Name +'.'
			ELSE IF(@Alert_Type = 'TER')
				SET @MailSubjectCr = 'Notification of all deals with Tentative Start Date in the course of the next '+ Cast(@Mail_alert_days_Body As NVARCHAR) +'  days - Business Unit: '+ @BU_Name +'.'
			
			PRINT '@DatabaseEmail_Profile : ' + @DatabaseEmail_Profile
			PRINT '@@EMAil_User : ' + @Users_Email_Id
			PRINT '@@MailSubjectCr : ' + @MailSubjectCr
			PRINT '@@EmailUser_Body : ' + @EmailUser_Body

			--PRINT @EmailUser_Body
			IF(@Emailbody!='')
			BEGIN
				EXEC msdb.dbo.sp_send_dbmail 
				@profile_name = @DatabaseEmail_Profile,
				@recipients =  @Users_Email_Id,
				@subject = @MailSubjectCr,
				@body = @EmailUser_Body, 
				@body_format = 'HTML';  
				
				--Change
				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code,GETDATE(),'N',@Emailbody,@Users_Code,@MailSubjectCr,@Users_Email_Id
				--Change
			END
			PRINT '@recipients : ' + cast(@Users_Email_Id  as varchar)
		END
	Fetch Next From curOuter Into @Business_Unit_Code, @Users_Email_Id,@Users_Code
	End -- End of Fetch outer
	Close curOuter
	Deallocate curOuter		
	
	DROP TABLE #DealDetails --#ACQ_EXPIRING_DEALS#DealDetails 
	IF OBJECT_ID('tempdb..#EMAIL_ID_TEMP1') IS NOT NULL
	BEGIN
		DROP TABLE #EMAIL_ID_TEMP1
	END

	IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS
	IF OBJECT_ID('tempdb..#ACQ_EXPIRING_DEALS#DealDetails') IS NOT NULL DROP TABLE #ACQ_EXPIRING_DEALS#DealDetails
	IF OBJECT_ID('tempdb..#ACQ_TENTATIVE_DEALS') IS NOT NULL DROP TABLE #ACQ_TENTATIVE_DEALS
	IF OBJECT_ID('tempdb..#Alert_Range') IS NOT NULL DROP TABLE #Alert_Range
	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL DROP TABLE #DealDetails
	IF OBJECT_ID('tempdb..#EMAIL_ID_TEMP1') IS NOT NULL DROP TABLE #EMAIL_ID_TEMP1
	IF OBJECT_ID('tempdb..#SYN_EXPIRING_DEALS') IS NOT NULL DROP TABLE #SYN_EXPIRING_DEALS
END
/*k
EXEC [dbo].[USP_Deal_Expiry_Email]  'D','ACE'

*/