CREATE PROCEDURE [dbo].[USP_AT_Acq_Deal]
(
	@Acq_Deal_Code INT, @Is_Error Varchar(1) Output, @Is_Edit_WO_Approval CHAR(1)='N'
)
AS
-- =============================================
-- Author:		Khan Faisal
-- Create date: 07 Oct, 2014
-- Description:	Archieve an acquisition deal
-- Last update by : Akshay Rane
-- Last Change : Added One column in AT_Acq_Deal_Cost_Costtype_Episode (Per_Eps_Amount)
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_AT_Acq_Deal]', 'Step 1', 0, 'Started Procedure', 0, ''

		DECLARE @Parameter_Name VARCHAR(500), @Process_User INT, @Title_Code VARCHAR(4000)
		DECLARE @Acq_Deal_Tab_Version_Code INT
		SELECT @Parameter_Name=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Edit_WO_Approval_Tabs'
		CREATE TABLE #Edit_WO_Approval(Tab_Name VARCHAR(10))

		INSERT INTO #Edit_WO_Approval(Tab_Name)	
		SELECT number FROM dbo.[fn_Split_withdelemiter](@Parameter_Name,',') WHERE number!=''

		SET NOCOUNT ON 
	
		UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'P' WHERE Acq_Deal_Code = @Acq_Deal_Code AND ISNULL(Is_Deal_Approved,'') = 'N'

		Select @Process_User = User_Code From Deal_PRocess (NOLOCK) Where Deal_Code = @Acq_Deal_Code AND Record_Status = 'W'
		SELECT @Title_Code =
		STUFF((
			SELECT DISTINCT  ', ' + (CAST(Title_Code AS VARCHAR)) FROM Acq_Deal_Movie (NOLOCK)
			where Acq_Deal_Code = @Acq_Deal_Code 
			FOR XML PATH('')), 1, 1, ''
		) 
		--SELECT @Title_Code = Title_Code FROM Acq_Deal_Movie where Acq_Deal_Code = @Acq_Deal_Code 
		EXEC DBO.USP_Generate_Title_Content @Acq_Deal_Code, @Title_Code, @Process_User

		IF(@Is_Edit_WO_Approval='N')
		BEGIN
		IF((SELECT COUNT(Acq_Deal_Code) FROM Acq_Deal (NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code AND Is_Master_Deal = 'Y' And (Cast([Version] As float) = 1 OR Acq_Deal_Code IN(SELECT Acq_Deal_Code FROM BMS_Deal (NOLOCK)))) > 0)
		BEGIN
			--EXEC USP_BMS_Deal_Data_Generation @Acq_Deal_Code
			INSERT INTO BMS_Process_Deals( [Acq_Deal_Code], [Record_Status],[Created_On],[Process_Start],[Process_End])
			SELECT @Acq_Deal_Code ,'P',GETDATE(),NULL,NULL
		END

		IF((SELECT COUNT(Acq_Deal_Code) FROM Acq_Deal (NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code AND Is_Master_Deal = 'Y' ) > 0)
		BEGIN
			INSERT INTO Integration_Deal( [Acq_Deal_Code], [Record_Status],[Created_On],[Process_Start],[Process_End])
			SELECT @Acq_Deal_Code ,'P',GETDATE(),NULL,NULL
		END

		UPDATE Acq_Deal_Movie SET Is_Closed = 'Y' WHERE Is_Closed = 'X' AND Acq_Deal_Code = @Acq_Deal_Code

		IF((SELECT COUNT(Record_Code) FROM Module_Status_History (NOLOCK) WHERE Record_Code = @Acq_Deal_Code AND Module_Code = 30  AND [Status] = 'AM') > 0)
		BEGIN
		--	EXEC [dbo].[USP_Avail_Acq_Cache]  @Acq_Deal_Code ,'Y'
			INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend)
			VALUES(@Acq_Deal_Code, 'A', 'P', GETDATE(), 'Y')
		END
		ELSE	
		BEGIN
		--	EXEC USP_Avail_Acq_Cache @Acq_Deal_Code,'N'
			INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend)
			VALUES(@Acq_Deal_Code, 'A', 'P', GETDATE(), 'N')
				
		END

		--EXEC USP_Generate_Acq_Rights_Title_Eps @Acq_Deal_Code

		/******************************** Insert into AT_Acq_Deal *****************************************/ 
		INSERT INTO AT_Acq_Deal (
			Acq_Deal_Code, Agreement_No, Version, Agreement_Date, Deal_Desc, Deal_Type_Code, Year_Type, Entity_Code, Is_Master_Deal, 
			Category_Code, Vendor_Code, Vendor_Contacts_Code, Currency_Code, Exchange_Rate, Ref_No, Attach_Workflow, Deal_Workflow_Status, 
			Parent_Deal_Code, Work_Flow_Code, Amendment_Date, Is_Released, Release_On, Release_By, Is_Completed, Is_Active, Content_Type, 
			Payment_Terms_Conditions, Status, Is_Auto_Generated, Is_Migrated, Cost_Center_Id, Master_Deal_Movie_Code_ToLink, BudgetWise_Costing_Applicable, 
			Validate_CostWith_Budget, Deal_Tag_Code, Business_Unit_Code, Ref_BMS_Code, Remarks, Rights_Remarks, Payment_Remarks, Inserted_By, 
			Inserted_On, Last_Updated_Time, Last_Action_By, Deal_Complete_Flag, All_Channel,Role_Code, Channel_Cluster_Code, Is_Auto_Push, Deal_Segment_Code, Revenue_Vertical_Code, Confirming_Party, Material_Remarks)
		SELECT Acq_Deal_Code, Agreement_No, Version, Agreement_Date, Deal_Desc, Deal_Type_Code, Year_Type, Entity_Code, Is_Master_Deal,
			Category_Code, Vendor_Code, Vendor_Contacts_Code, Currency_Code, Exchange_Rate, Ref_No, Attach_Workflow, Deal_Workflow_Status,
			Parent_Deal_Code, Work_Flow_Code, Amendment_Date, Is_Released, Release_On, Release_By, Is_Completed, Is_Active, Content_Type,
			Payment_Terms_Conditions, Status, Is_Auto_Generated, Is_Migrated, Cost_Center_Id, Master_Deal_Movie_Code_ToLink, BudgetWise_Costing_Applicable,
			Validate_CostWith_Budget, Deal_Tag_Code, Business_Unit_Code, Ref_BMS_Code, Remarks, Rights_Remarks, Payment_Remarks, Inserted_By,
			Inserted_On, Last_Updated_Time, Last_Action_By, Deal_Complete_Flag, All_Channel,Role_Code, Channel_Cluster_Code, Is_Auto_Push, Deal_Segment_Code, Revenue_Vertical_Code,Confirming_Party, Material_Remarks
		FROM Acq_Deal (NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code 
			
		/******************************** Holding identity of AT_Acq_Deal *****************************************/ 
		DECLARE @CurrIdent_AT_Acq_Deal INT
		SET @CurrIdent_AT_Acq_Deal = 0
		SELECT @CurrIdent_AT_Acq_Deal = IDENT_CURRENT('AT_Acq_Deal')


		/******************************** Insert into AT_Syn_Acq_Mapping *****************************************/ 
		INSERT INTO AT_Syn_Acq_Mapping( Syn_Acq_Mapping_Code, Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, AT_Acq_Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
		SELECT  Syn_Acq_Mapping_Code,  Syn_Deal_Code,  Syn_Deal_Movie_Code,  Syn_Deal_Rights_Code,  @CurrIdent_AT_Acq_Deal,  Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
		FROM Syn_Acq_Mapping   (NOLOCK)
		WHERE Deal_Code = @Acq_Deal_Code 
		AND Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code)

		/******************************** Insert into AT_Acq_Deal_Licensor *****************************************/ 
		INSERT INTO AT_Acq_Deal_Licensor(AT_Acq_Deal_Code, Vendor_Code,Acq_Deal_Licensor_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Vendor_Code , Acq_Deal_Licensor_Code
		FROM Acq_Deal_Licensor (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

		/******************************** Insert into AT_Acq_Deal_Movie *****************************************/ 
		INSERT INTO AT_Acq_Deal_Movie(
			AT_Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction)
		SELECT @CurrIdent_AT_Acq_Deal, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction
		FROM Acq_Deal_Movie (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

		--Create Temp table for Deal Movie

		CREATE TABLE #TEMPDealMovie(	
			AT_Acq_Deal_Movie_Code INT,
			Acq_Deal_Movie_Code INT
		)

		/******************************** Insert into AT_Acq_Deal_Rights *****************************************/ 
		DECLARE @AT_Acq_Deal_Rights_Code INT
		SET @AT_Acq_Deal_Rights_Code = 0

		INSERT INTO AT_Acq_Deal_Rights (AT_Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
			Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
			Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date,
			Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag, Buyback_Syn_Rights_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
			Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
			Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
			Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag, Buyback_Syn_Rights_Code
		FROM Acq_Deal_Rights (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

		-------------------Insert for AT_Acq_Deal_Rights_Title ---------------------

		INSERT INTO AT_Acq_Deal_Rights_Title (AT_Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To,Acq_Deal_Rights_Title_Code)
		SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To,ADRT.Acq_Deal_Rights_Title_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal  AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code

		-------------------Insert for AT_Acq_Deal_Rights_Title_Eps -----------------

		INSERT INTO AT_Acq_Deal_Rights_Title_Eps (
			AT_Acq_Deal_Rights_Title_Code, EPS_No,Acq_Deal_Rights_Title_EPS_Code)
		SELECT
			AtADRT.AT_Acq_Deal_Rights_Title_Code, ADRTE.EPS_No,Acq_Deal_Rights_Title_EPS_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Title_EPS ADRTE (NOLOCK) ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			Inner Join AT_Acq_Deal_Rights_Title AtADRT (NOLOCK) On AtADR.AT_Acq_Deal_Rights_Code = AtADRT.AT_Acq_Deal_Rights_Code 
			AND AtADRT.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code


		-------------------Insert for AT_Acq_Deal_Rights_Platform -------------------

		INSERT INTO AT_Acq_Deal_Rights_Platform (AT_Acq_Deal_Rights_Code, Platform_Code,Acq_Deal_Rights_Platform_Code)	
		SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRP.Platform_Code,Acq_Deal_Rights_Platform_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code

		------------------Check and Do Mass Territory Update-------------------------
			
		DECLARE @Acq_Deal_Rights_Code INT = 0,@Territory_Code INT = 0
			
		DECLARE rights_Territory_Cursor CURSOR FOR
		Select distinct adr.Acq_Deal_Rights_Code,adrt.Territory_Code from Acq_Deal_Rights adr (NOLOCK) INNER JOIN 
		Acq_Deal_Rights_Territory adrt (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		Where adrt.Territory_Type = 'G' AND adr.Acq_Deal_Code = @Acq_Deal_Code
			
		OPEN rights_Territory_Cursor

		FETCH NEXT FROM rights_Territory_Cursor INTO @Acq_Deal_Rights_Code,@Territory_Code

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO Acq_Deal_Rights_Territory(Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
			Select @Acq_Deal_Rights_Code,'G', Country_Code,Territory_Code 
			FROM Territory_Details (NOLOCK) where Territory_Code = @Territory_Code AND Country_Code not in 
			(Select Country_Code from Acq_Deal_Rights_Territory (NOLOCK)
			Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and Territory_Code = @Territory_Code)
				
			FETCH NEXT FROM rights_Territory_Cursor INTO @Acq_Deal_Rights_Code,@Territory_Code
		END

		CLOSE rights_Territory_Cursor;
		DEALLOCATE rights_Territory_Cursor;
			
		-------------------Insert for AT_Acq_Deal_Rights_Territory ----------------------

		INSERT INTO AT_Acq_Deal_Rights_Territory (AT_Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code , Acq_Deal_Rights_Territory_Code)	
		SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRT.Territory_Code, ADRT.Territory_Type, ADRT.Country_Code , Acq_Deal_Rights_Territory_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Territory ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code =  @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			
		--------------------Insert for AT_Acq_Deal_Rights_Subtitling ----------------------

		INSERT INTO AT_Acq_Deal_Rights_Subtitling (AT_Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type ,Acq_Deal_Rights_Subtitling_Code)	
		SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRS.Language_Code, ADRS.Language_Group_Code, ADRS.Language_Type,Acq_Deal_Rights_Subtitling_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Subtitling ADRS (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			
		--------------------Insert for AT_Acq_Deal_Rights_Dubbing -------------------------

		INSERT INTO AT_Acq_Deal_Rights_Dubbing (AT_Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type,Acq_Deal_Rights_Dubbing_Code)	
		SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRD.Language_Code, ADRD.Language_Group_Code, ADRD.Language_Type,Acq_Deal_Rights_Dubbing_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Dubbing ADRD (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			
		--------------------Insert for AT_Acq_Deal_Rights_Holdback -------------------------

		INSERT INTO AT_Acq_Deal_Rights_Holdback (AT_Acq_Deal_Rights_Code, 
			Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
			Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right,Acq_Deal_Rights_Holdback_Code)
		SELECT AtADR.AT_Acq_Deal_Rights_Code, 
			ADRH.Holdback_Type, ADRH.HB_Run_After_Release_No, ADRH.HB_Run_After_Release_Units, 
			ADRH.Holdback_On_Platform_Code, ADRH.Holdback_Release_Date, ADRH.Holdback_Comment, ADRH.Is_Title_Language_Right,Acq_Deal_Rights_Holdback_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Holdback ADRH (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
		---------------------Insert for AT_Acq_Deal_Rights_Holdback_Dubbing ------------------

		INSERT INTO AT_Acq_Deal_Rights_Holdback_Dubbing (
			AT_Acq_Deal_Rights_Holdback_Code, Language_Code,Acq_Deal_Rights_Holdback_Dubbing_Code)
		SELECT
			AtADRH.AT_Acq_Deal_Rights_Holdback_Code, ADRHD.Language_Code,ADRHD.Acq_Deal_Rights_Holdback_Dubbing_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Holdback ADRH (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Holdback_Dubbing ADRHD (NOLOCK) ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH (NOLOCK) ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
				
		---------------------Insert for AT_Acq_Deal_Rights_Holdback_Platform ------------------

		INSERT INTO AT_Acq_Deal_Rights_Holdback_Platform (
			AT_Acq_Deal_Rights_Holdback_Code, Platform_Code,Acq_Deal_Rights_Holdback_Platform_Code)
		SELECT
			AtADRH.AT_Acq_Deal_Rights_Holdback_Code, ADRHP.Platform_Code,ADRHP.Acq_Deal_Rights_Holdback_Platform_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Holdback ADRH  (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP (NOLOCK) ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH (NOLOCK) ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
				
		---------------------Insert for AT_Acq_Deal_Rights_Holdback_Subtitling ----------------------

		INSERT INTO AT_Acq_Deal_Rights_Holdback_Subtitling (
			AT_Acq_Deal_Rights_Holdback_Code, Language_Code, Acq_Deal_Rights_Holdback_Subtitling_Code)
		SELECT
			AtADRH.AT_Acq_Deal_Rights_Holdback_Code, ADRHS.Language_Code,ADRHS.Acq_Deal_Rights_Holdback_Subtitling_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Holdback ADRH (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Holdback_Subtitling ADRHS (NOLOCK) ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH (NOLOCK) ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
				
			
		----------------------Insert for AT_Acq_Deal_Rights_Holdback_Territory -----------------------

		INSERT INTO AT_Acq_Deal_Rights_Holdback_Territory (
			AT_Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code,Acq_Deal_Rights_Holdback_Territory_Code)
		SELECT
			AtADRH.AT_Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code, Acq_Deal_Rights_Holdback_Territory_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Holdback ADRH (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT (NOLOCK) ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH (NOLOCK) ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
			
		----------------------Insert for AT_Acq_Deal_Rights_Blackout ----------------------------------

		INSERT INTO AT_Acq_Deal_Rights_Blackout (
			AT_Acq_Deal_Rights_Code, 
			Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Blackout_Code)
		SELECT 
			AtADR.AT_Acq_Deal_Rights_Code, 
			ADRB.Start_Date, ADRB.End_Date, ADRB.Inserted_By, ADRB.Inserted_On, ADRB.Last_Updated_Time, ADRB.Last_Action_By,ADRB.Acq_Deal_Rights_Blackout_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Blackout ADRB (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
		-----------------------Insert for AT_Acq_Deal_Rights_Blackout_Dubbing --------------------------

		INSERT INTO AT_Acq_Deal_Rights_Blackout_Dubbing (
			AT_Acq_Deal_Rights_Blackout_Code, Language_Code, Acq_Deal_Rights_Blackout_Dubbing_Code)
		SELECT
			AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBD.Language_Code, ADRBD.Acq_Deal_Rights_Blackout_Dubbing_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Blackout ADRB (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Blackout_Dubbing ADRBD (NOLOCK) ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB (NOLOCK) ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			
		------------------------Insert for AT_Acq_Deal_Rights_Blackout_Platform ------------------------

		INSERT INTO AT_Acq_Deal_Rights_Blackout_Platform (
			AT_Acq_Deal_Rights_Blackout_Code, Platform_Code, Acq_Deal_Rights_Blackout_Platform_Code)
		SELECT
			AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBP.Platform_Code, ADRBP.Acq_Deal_Rights_Blackout_Platform_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Blackout ADRB (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Blackout_Platform ADRBP (NOLOCK) ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB (NOLOCK) ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code


		------------------------Insert for AT_Acq_Deal_Rights_Blackout_Subtitling -----------------------

		INSERT INTO AT_Acq_Deal_Rights_Blackout_Subtitling(
			AT_Acq_Deal_Rights_Blackout_Code, Language_Code, Acq_Deal_Rights_Blackout_Subtitling_Code)
		SELECT
			AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBS.Language_Code, ADRBS.Acq_Deal_Rights_Blackout_Subtitling_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Blackout ADRB (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Blackout_Subtitling ADRBS (NOLOCK) ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB (NOLOCK) ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			
		--------------------------Insert for AT_Acq_Deal_Rights_Blackout_Territory ------------------------

		INSERT INTO AT_Acq_Deal_Rights_Blackout_Territory(
			AT_Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type, Acq_Deal_Rights_Blackout_Territory_Code)
		SELECT
			AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBT.Country_Code, ADRBT.Territory_Code, ADRBT.Territory_Type, ADRBT.Acq_Deal_Rights_Blackout_Territory_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Blackout ADRB (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Blackout_Territory ADRBT (NOLOCK) ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR  (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB (NOLOCK) ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code

			----------------------Insert for AT_Acq_Deal_Rights_Promoter ----------------------------------

		INSERT INTO AT_Acq_Deal_Rights_Promoter (
			AT_Acq_Deal_Rights_Code, 
			Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Promoter_Code)
		SELECT 
			AtADR.AT_Acq_Deal_Rights_Code, 
			 ADRP.Inserted_By, ADRP.Inserted_On, ADRP.Last_Updated_Time, ADRP.Last_Action_By,ADRP.Acq_Deal_Rights_Promoter_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Promoter ADRP (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
				-----------------------Insert for AT_Acq_Deal_Rights_Promoter_Group --------------------------

		INSERT INTO AT_Acq_Deal_Rights_Promoter_Group (
			AT_Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code, Acq_Deal_Rights_Promoter_Group_Code)
		SELECT
			AtADRP.AT_Acq_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code, ADRPG.Acq_Deal_Rights_Promoter_Group_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Promoter ADRP (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG (NOLOCK) ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Promoter AtADRP (NOLOCK) ON AtADRP.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRP.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code

				-----------------------Insert for AT_Acq_Deal_Rights_Promoter_Remarks --------------------------

		INSERT INTO AT_Acq_Deal_Rights_Promoter_Remarks (
			AT_Acq_Deal_Rights_Promoter_Code, Promoter_Remarks_Code, Acq_Deal_Rights_Promoter_Remarks_Code)
		SELECT
			AtADRP.AT_Acq_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code, ADRPR.Acq_Deal_Rights_Promoter_Remarks_Code
		FROM Acq_Deal_Rights ADR (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Promoter ADRP (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR (NOLOCK) ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
			INNER JOIN AT_Acq_Deal_Rights AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN AT_Acq_Deal_Rights_Promoter AtADRP (NOLOCK) ON AtADRP.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRP.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code

		---------------------------Insert for AT_Acq_Deal_Pushback ------------------------------------------

		INSERT INTO AT_Acq_Deal_Pushback(AT_Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
				Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Pushback_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
			Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By , Acq_Deal_Pushback_Code
		FROM Acq_Deal_Pushback  (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

		---------------------------Insert for AT_Acq_Deal_Pushback_Dubbing -----------------------------------

		INSERT INTO AT_Acq_Deal_Pushback_Dubbing(
			AT_Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code, Acq_Deal_Pushback_Dubbing_Code)
		SELECT 
			AtADP.AT_Acq_Deal_Pushback_Code, ADPD.Language_Type, ADPD.Language_Code, ADPD.Language_Group_Code, ADPD.Acq_Deal_Pushback_Dubbing_Code
		FROM Acq_Deal_Pushback ADP (NOLOCK)
			INNER JOIN Acq_Deal_Pushback_Dubbing ADPD (NOLOCK) ON ADPD.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Pushback AtADP (NOLOCK) ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
				
		---------------------------Insert for AT_Acq_Deal_Pushback_Platform ----------------------------------

		INSERT INTO AT_Acq_Deal_Pushback_Platform(
			AT_Acq_Deal_Pushback_Code, Platform_Code,Acq_Deal_Pushback_Platform_Code)
		SELECT 
			AtADP.AT_Acq_Deal_Pushback_Code, ADPP.Platform_Code, ADPP.Acq_Deal_Pushback_Platform_Code
		FROM Acq_Deal_Pushback ADP (NOLOCK)
			INNER JOIN Acq_Deal_Pushback_Platform ADPP (NOLOCK) ON ADPP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Pushback AtADP (NOLOCK) ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
			
		----------------------------Insert for AT_Acq_Deal_Pushback_Subtitling --------------------------------

		INSERT INTO AT_Acq_Deal_Pushback_Subtitling(
			AT_Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code, Acq_Deal_Pushback_Subtitling_Code)
		SELECT 
			AtADP.AT_Acq_Deal_Pushback_Code, ADPS.Language_Type, ADPS.Language_Code, ADPS.Language_Group_Code, ADPS.Acq_Deal_Pushback_Subtitling_Code
		FROM Acq_Deal_Pushback ADP (NOLOCK)
			INNER JOIN Acq_Deal_Pushback_Subtitling ADPS (NOLOCK) ON ADPS.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Pushback AtADP (NOLOCK) ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
			
		-----------------------------Insert for AT_Acq_Deal_Pushback_Territory ---------------------------------

		INSERT INTO AT_Acq_Deal_Pushback_Territory(
			AT_Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code, Acq_Deal_Pushback_Territory_Code)
		SELECT 
			AtADP.AT_Acq_Deal_Pushback_Code, ADPT.Territory_Type, ADPT.Country_Code, ADPT.Territory_Code, ADPT.Acq_Deal_Pushback_Territory_Code
		FROM Acq_Deal_Pushback ADP (NOLOCK)
			INNER JOIN Acq_Deal_Pushback_Territory ADPT (NOLOCK) ON ADPT.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Pushback AtADP (NOLOCK) ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
			
		------------------------------Insert for AT_Acq_Deal_Pushback_Title -------------------------------------

		INSERT INTO AT_Acq_Deal_Pushback_Title(
			AT_Acq_Deal_Pushback_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Pushback_Title_Code)
		SELECT 
			AtADP.AT_Acq_Deal_Pushback_Code, ADPT.Title_Code, ADPT.Episode_From, ADPT.Episode_To,ADPT.Acq_Deal_Pushback_Title_Code
		FROM Acq_Deal_Pushback ADP (NOLOCK)
			INNER JOIN Acq_Deal_Pushback_Title ADPT (NOLOCK) ON ADPT.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Pushback AtADP (NOLOCK) ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
	
	
		/******************************** Insert into AT_Acq_Deal_Supplementary *****************************************/ 
		INSERT INTO AT_Acq_Deal_Supplementary (AT_Acq_Deal_Code, Title_code, Episode_From, Episode_To, Remarks, Acq_Deal_Supplementary_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Title_code, Episode_From, Episode_To, Remarks, Acq_Deal_Supplementary_Code
		FROM Acq_Deal_Supplementary  (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			
		/******************************** Insert into AT_Acq_Deal_Supplementary_Details *****************************************/ 

		INSERT INTO AT_Acq_Deal_Supplementary_Detail (AT_Acq_Deal_Supplementary_Code, Supplementary_Tab_Code, Supplementary_Config_Code, 
			Supplementary_Data_Code, User_Value, Row_Num, Acq_Deal_Supplementary_Detail_Code)
		SELECT AtADA.AT_Acq_Deal_Supplementary_Code, ADAP.Supplementary_Tab_Code, ADAP.Supplementary_Config_Code, 
			ADAP.Supplementary_Data_Code, ADAP.User_Value, ADAP.Row_Num, ADAP.Acq_Deal_Supplementary_Detail_Code
		FROM Acq_Deal_Supplementary ADA (NOLOCK)
			INNER JOIN Acq_Deal_Supplementary_Detail ADAP (NOLOCK) ON ADAP.Acq_Deal_Supplementary_Code = ADA.Acq_Deal_Supplementary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Supplementary AtADA (NOLOCK) ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Supplementary_Code = ADA.Acq_Deal_Supplementary_Code

		/******************************** Insert into AT_Acq_Deal_Ancillary *****************************************/ 
		INSERT INTO AT_Acq_Deal_Ancillary (
			AT_Acq_Deal_Code, Ancillary_Type_code, Duration, Day, Remarks, Group_No, Acq_Deal_Ancillary_Code,Catch_Up_From)
		SELECT @CurrIdent_AT_Acq_Deal, Ancillary_Type_code, Duration, Day, Remarks, Group_No, Acq_Deal_Ancillary_Code, Catch_Up_From
			FROM Acq_Deal_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			
		/******************************** Insert into AT_Acq_Deal_Ancillary_Platform *****************************************/ 

		INSERT INTO AT_Acq_Deal_Ancillary_Platform (
			AT_Acq_Deal_Ancillary_Code, Ancillary_Platform_code, Acq_Deal_Ancillary_Platform_Code, Platform_Code)
		SELECT AtADA.AT_Acq_Deal_Ancillary_Code, ADAP.Ancillary_Platform_code, ADAP.Acq_Deal_Ancillary_Platform_Code, ADAP.Platform_Code
		FROM Acq_Deal_Ancillary ADA (NOLOCK)
			INNER JOIN Acq_Deal_Ancillary_Platform ADAP (NOLOCK) ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Ancillary AtADA (NOLOCK) ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Ancillary_Platform_Medium *****************************************/ 

		INSERT INTO AT_Acq_Deal_Ancillary_Platform_Medium(
			AT_Acq_Deal_Ancillary_Platform_Code, Ancillary_Platform_Medium_Code, Acq_Deal_Ancillary_Platform_Medium_Code)
		SELECT AtADAP.AT_Acq_Deal_Ancillary_Platform_Code, ADAPM.Ancillary_Platform_Medium_Code,ADAPM.Acq_Deal_Ancillary_Platform_Medium_Code
		FROM Acq_Deal_Ancillary ADA (NOLOCK)
			INNER JOIN Acq_Deal_Ancillary_Platform ADAP (NOLOCK) ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code  and ADA.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Ancillary_Platform_Medium ADAPM (NOLOCK) ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code
			INNER JOIN AT_Acq_Deal_Ancillary AtADA (NOLOCK) ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Ancillary_Platform AtADAP (NOLOCK) ON AtADAP.AT_Acq_Deal_Ancillary_Code = AtADA.AT_Acq_Deal_Ancillary_Code
				AND AtADAP.AT_Acq_Deal_Ancillary_Code = AtADA.AT_Acq_Deal_Ancillary_Code
				AND	AtADAP.Ancillary_Platform_code = ADAP.Ancillary_Platform_code

		/******************************** Insert into AT_Acq_Deal_Ancillary_Title *****************************************/ 

		INSERT INTO AT_Acq_Deal_Ancillary_Title (
			AT_Acq_Deal_Ancillary_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Ancillary_Title_Code)
		SELECT AtADA.AT_Acq_Deal_Ancillary_Code, ADAT.Title_Code, ADAT.Episode_From, ADAT.Episode_To , ADAT.Acq_Deal_Ancillary_Title_Code
		FROM Acq_Deal_Ancillary ADA (NOLOCK)
			INNER JOIN Acq_Deal_Ancillary_Title ADAT (NOLOCK) ON ADAT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Ancillary AtADA (NOLOCK) ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
	END

		IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='RU'))
		BEGIN   
		/******************************** Insert into AT_Acq_Deal_Run *****************************************/ 
	
			IF(@Is_Edit_WO_Approval='Y')
			BEGIN
			SET @CurrIdent_AT_Acq_Deal=(Select TOP 1 AT_Acq_Deal_Code from AT_Acq_Deal (NOLOCK) Where Acq_Deal_Code=@Acq_Deal_Code ORDER BY AT_Acq_Deal_Code DESC)
			END
			Select TOP 1 @Acq_Deal_Tab_Version_Code=Acq_Deal_Tab_Version_Code from Acq_Deal_Tab_Version (NOLOCK) Where Acq_Deal_Code=@Acq_Deal_Code ORDER BY Acq_Deal_Tab_Version_Code DESC
		
			INSERT INTO AT_Acq_Deal_Run(
				AT_Acq_Deal_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
				Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights, Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,
				All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,
				Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,
				Off_Prime_Time_Balance_Count,Acq_Deal_Run_Code,Acq_Deal_Tab_Version_Code,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time, Channel_Type, Channel_Category_Code)
			SELECT @CurrIdent_AT_Acq_Deal, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
				Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights, Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,
				All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,
				Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,
				Off_Prime_Time_Balance_Count,Acq_Deal_Run_Code,@Acq_Deal_Tab_Version_Code,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,
				Channel_Type, Channel_Category_Code
			FROM Acq_Deal_Run (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			
			/******************************** Insert into AT_Acq_Deal_Run_Channel *****************************************/ 
			 
			INSERT INTO AT_Acq_Deal_Run_Channel (
				AT_Acq_Deal_Run_Code, Channel_Code, Min_Runs, Max_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Do_Not_Consume_Rights, 
				Is_Primary, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time, Acq_Deal_Run_Channel_Code)
			SELECT 
				AtADR.AT_Acq_Deal_Run_Code, ADRC.Channel_Code, ADRC.Min_Runs, ADRC.Max_Runs, ADRC.No_Of_Runs_Sched, ADRC.No_Of_AsRuns, ADRC.Do_Not_Consume_Rights, 
				ADRC.Is_Primary, ADRC.Inserted_By, ADRC.Inserted_On, ADRC.Last_action_By, ADRC.Last_updated_Time, ADRC.Acq_Deal_Run_Channel_Code
			FROM Acq_Deal_Run ADR (NOLOCK)
				INNER JOIN Acq_Deal_Run_Channel ADRC (NOLOCK) ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Run AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			
			/******************************** Insert into AT_Acq_Deal_Run_Repeat_On_Day *****************************************/ 

			INSERT INTO AT_Acq_Deal_Run_Repeat_On_Day (AT_Acq_Deal_Run_Code, Day_Code, Acq_Deal_Run_Repeat_On_Day_Code)
			SELECT AtADR.AT_Acq_Deal_Run_Code, ADRRD.Day_Code , ADRRD.Acq_Deal_Run_Repeat_On_Day_Code
			FROM Acq_Deal_Run ADR (NOLOCK)
				INNER JOIN Acq_Deal_Run_Repeat_On_Day ADRRD (NOLOCK) ON ADRRD.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Run AtADR  (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

			/******************************** Insert into AT_Acq_Deal_Run_Shows *****************************************/ 			
			CREATE TABLE #Temp_Shows
			(
				AT_Acq_Deal_Run_Code INT,
				Data_For CHAR(1),
				Title_Code INT,
				Episode_From INT,
				Episode_To INT,
				Inserted_By INT,
				Inserted_On DATETIME,				
				Acq_Deal_Run_Shows_Code INT,
				Acq_Deal_Movie_Code INT,
				AT_Acq_Deal_Movie_Code INT
			)
			INSERT INTO #Temp_Shows(
				AT_Acq_Deal_Run_Code,
				Acq_Deal_Movie_Code,
				Data_For,
				Title_Code,
				Episode_From,
				Episode_To,
				Inserted_By,
				Inserted_On,
				Acq_Deal_Run_Shows_Code
			)
			SELECT DISTINCT AtADR.AT_Acq_Deal_Run_Code,ADRS.Acq_Deal_Movie_Code,ADRS.Data_For,ADRS.Title_Code,ADRS.Episode_From,ADRS.Episode_To,ADRS.Inserted_By,ADRS.Inserted_On,ADRS.Acq_Deal_Run_Shows_Code
			FROM Acq_Deal_Run ADR (NOLOCK)
			INNER JOIN Acq_Deal_Run_Shows ADRS (NOLOCK) ON ADRS.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Run AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code						

			UPDATE T SET T.AT_Acq_Deal_Movie_Code = ATADM.AT_Acq_Deal_Movie_Code
			FROM #Temp_Shows T
			INNER JOIN AT_Acq_Deal_Movie ATADM ON T.Acq_Deal_Movie_Code = ATADM.Acq_Deal_Movie_Code

			INSERT INTO AT_Acq_Deal_Run_Shows(AT_Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,
				AT_Acq_Deal_Movie_Code,Inserted_By,Inserted_On,Acq_Deal_Run_Shows_Code)
			SELECT AT_Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,
			AT_Acq_Deal_Movie_Code,Inserted_By,Inserted_On,Acq_Deal_Run_Shows_Code
			FROM #Temp_Shows T

			DROP TABLE #Temp_Shows

			/******************************** Insert into AT_Acq_Deal_Run_Title *****************************************/ 

			INSERT INTO AT_Acq_Deal_Run_Title (AT_Acq_Deal_Run_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Run_Title_Code)
			SELECT AtADR.AT_Acq_Deal_Run_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADRT.Acq_Deal_Run_Title_Code
			FROM Acq_Deal_Run ADR (NOLOCK)
				INNER JOIN Acq_Deal_Run_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Run AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			
			/******************************** Insert into AT_Acq_Deal_Run_Yearwise_Run *****************************************/ 

			INSERT INTO AT_Acq_Deal_Run_Yearwise_Run ( 
				AT_Acq_Deal_Run_Code, Start_Date, End_Date, No_Of_Runs, No_Of_Runs_Sched, 
				No_Of_AsRuns, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time, Acq_Deal_Run_Yearwise_Run_Code)
			SELECT 
				AtADR.AT_Acq_Deal_Run_Code, ADRYR.Start_Date, ADRYR.End_Date, ADRYR.No_Of_Runs, ADRYR.No_Of_Runs_Sched, 
				ADRYR.No_Of_AsRuns, ADRYR.Inserted_By, ADRYR.Inserted_On, ADRYR.Last_action_By, ADRYR.Last_updated_Time,ADRYR.Acq_Deal_Run_Yearwise_Run_Code
			FROM Acq_Deal_Run ADR (NOLOCK)
				INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR (NOLOCK) ON ADRYR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Run AtADR  (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			
			/******************************** Insert into AT_Acq_Deal_Run_Yearwise_Run_Week *****************************************/ 

			INSERT INTO AT_Acq_Deal_Run_Yearwise_Run_Week ( 
				AT_Acq_Deal_Run_Yearwise_Run_Code, AT_Acq_Deal_Run_Code, Start_Week_Date, End_Week_Date, Is_Preferred, 
				Inserted_By, Inserted_On, Last_action_By, Last_updated_Time, Acq_Deal_Run_Yearwise_Run_Week_Code)
			SELECT 
				AtADRYR.AT_Acq_Deal_Run_Yearwise_Run_Code, AtADR.AT_Acq_Deal_Run_Code, 
				ADRYRW.Start_Week_Date, ADRYRW.End_Week_Date, ADRYRW.Is_Preferred, ADRYRW.Inserted_By, ADRYRW.Inserted_On, 
				ADRYRW.Last_action_By, ADRYRW.Last_updated_Time, ADRYRW.Acq_Deal_Run_Yearwise_Run_Week_Code
			FROM Acq_Deal_Run ADR (NOLOCK)
				INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR (NOLOCK) ON ADRYR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN Acq_Deal_Run_Yearwise_Run_Week ADRYRW (NOLOCK) ON ADRYRW.Acq_Deal_Run_Yearwise_Run_Code = ADRYR.Acq_Deal_Run_Yearwise_Run_Code
				INNER JOIN AT_Acq_Deal_Run AtADR (NOLOCK) ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
				INNER JOIN AT_Acq_Deal_Run_Yearwise_Run AtADRYR (NOLOCK) ON AtADRYR.AT_Acq_Deal_Run_Code = AtADR.AT_Acq_Deal_Run_Code AND
				AtADRYR.Acq_Deal_Run_Yearwise_Run_Code = ADRYR.Acq_Deal_Run_Yearwise_Run_Code
		END
		IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='CO'))
		BEGIN 
			/******************************** Insert into Acq_Deal_Cost *****************************************/ 
		
			INSERT INTO AT_Acq_Deal_Cost(
				AT_Acq_Deal_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost, 
				Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By,Incentive,Remarks, Acq_Deal_Cost_Code,Acq_Deal_Tab_Version_Code)
			SELECT @CurrIdent_AT_Acq_Deal, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost, 
				Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By,Incentive,Remarks, Acq_Deal_Cost_Code,@Acq_Deal_Tab_Version_Code
			FROM Acq_Deal_Cost (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

			
			/**************** Insert into AT_Acq_Deal_Cost_Additional_Exp ****************/ 

			INSERT INTO AT_Acq_Deal_Cost_Additional_Exp (
				AT_Acq_Deal_Cost_Code, Additional_Expense_Code, Amount, Min_Max, 
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Acq_Deal_Cost_Additional_Exp_Code)
			SELECT 
				AtADC.AT_Acq_Deal_Cost_Code, ADCAE.Additional_Expense_Code, ADCAE.Amount, ADCAE.Min_Max, 
				ADCAE.Inserted_On, ADCAE.Inserted_By, ADCAE.Last_Updated_Time, ADCAE.Last_Action_By, ADCAE.Acq_Deal_Cost_Additional_Exp_Code
			FROM Acq_Deal_Cost ADC (NOLOCK)
				INNER JOIN Acq_Deal_Cost_Additional_Exp ADCAE  (NOLOCK) ON ADCAE.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Cost AtADC (NOLOCK) ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
			/**************** Insert into AT_Acq_Deal_Cost_Commission ****************/ 

			INSERT INTO AT_Acq_Deal_Cost_Commission (
				AT_Acq_Deal_Cost_Code, Cost_Type_Code, Royalty_Commission_Code, Entity_Code,
				Vendor_Code, Type, Commission_Type, Percentage, Amount)
			SELECT 
				AtADC.AT_Acq_Deal_Cost_Code, ADCC.Cost_Type_Code, ADCC.Royalty_Commission_Code, ADCC.Entity_Code,
				ADCC.Vendor_Code, ADCC.Type, ADCC.Commission_Type, ADCC.Percentage, ADCC.Amount
			FROM Acq_Deal_Cost ADC (NOLOCK)
				INNER JOIN Acq_Deal_Cost_Commission ADCC (NOLOCK) ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Cost AtADC (NOLOCK) ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
			/**************** Insert into AT_Acq_Deal_Cost_Title ****************/
						 
			INSERT INTO AT_Acq_Deal_Cost_Title (AT_Acq_Deal_Cost_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Cost_Title_Code)
			SELECT 
				AtADC.AT_Acq_Deal_Cost_Code, ADCT.Title_Code, ADCT.Episode_From, ADCT.Episode_To, ADCT.Acq_Deal_Cost_Title_Code
			FROM Acq_Deal_Cost ADC (NOLOCK)
				INNER JOIN Acq_Deal_Cost_Title ADCT (NOLOCK) ON ADCT.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Cost AtADC (NOLOCK) ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
			/**************** Insert into AT_Acq_Deal_Cost_Variable_Cost ****************/

			INSERT INTO AT_Acq_Deal_Cost_Variable_Cost (
				AT_Acq_Deal_Cost_Code, Entity_Code, Vendor_Code, Percentage, Amount, 
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Acq_Deal_Cost_Variable_Cost_Code)
			SELECT 
				AtADC.AT_Acq_Deal_Cost_Code, ADCVC.Entity_Code, ADCVC.Vendor_Code, ADCVC.Percentage, ADCVC.Amount, 
				ADCVC.Inserted_On, ADCVC.Inserted_By, ADCVC.Last_Updated_Time, ADCVC.Last_Action_By, ADCVC.Acq_Deal_Cost_Variable_Cost_Code
			FROM Acq_Deal_Cost ADC (NOLOCK)
				INNER JOIN Acq_Deal_Cost_Variable_Cost ADCVC (NOLOCK) ON ADCVC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Cost AtADC (NOLOCK) ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
			/**************** Insert into AT_Acq_Deal_Cost_Costtype ****************/ 
			
			INSERT INTO AT_Acq_Deal_Cost_Costtype (
				AT_Acq_Deal_Cost_Code, Cost_Type_Code, Amount, Consumed_Amount, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Acq_Deal_Cost_Costtype_Code)
			SELECT 
				AtADC.AT_Acq_Deal_Cost_Code, 
				ADCC.Cost_Type_Code, ADCC.Amount, ADCC.Consumed_Amount, ADCC.Inserted_On, ADCC.Inserted_By, ADCC.Last_Updated_Time, ADCC.Last_Action_By, ADCC.Acq_Deal_Cost_Costtype_Code
			FROM Acq_Deal_Cost ADC (NOLOCK)
				INNER JOIN Acq_Deal_Cost_Costtype ADCC (NOLOCK) ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN AT_Acq_Deal_Cost AtADC (NOLOCK) ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
			/******** Insert into AT_Acq_Deal_Cost_Costtype_Episode ********/ 

			INSERT INTO AT_Acq_Deal_Cost_Costtype_Episode (
				AT_Acq_Deal_Cost_Costtype_Code, Episode_From, Episode_To, Amount_Type, Amount, Percentage, Remarks, Acq_Deal_Cost_Costtype_Episode_Code,Per_Eps_Amount)
			SELECT 
				AtADCC.AT_Acq_Deal_Cost_Costtype_Code,
				ADCCE.Episode_From, ADCCE.Episode_To, ADCCE.Amount_Type, ADCCE.Amount, ADCCE.Percentage, ADCCE.Remarks, ADCCE.Acq_Deal_Cost_Costtype_Episode_Code
				,ADCCE.Per_Eps_Amount
			FROM Acq_Deal_Cost ADC (NOLOCK)
				INNER JOIN Acq_Deal_Cost_Costtype ADCC (NOLOCK) ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
				INNER JOIN Acq_Deal_Cost_Costtype_Episode ADCCE (NOLOCK) ON ADCCE.Acq_Deal_Cost_Costtype_Code = ADCC.Acq_Deal_Cost_Costtype_Code
				INNER JOIN AT_Acq_Deal_Cost AtADC (NOLOCK) ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
				INNER JOIN AT_Acq_Deal_Cost_Costtype AtADCC (NOLOCK) ON AtADCC.AT_Acq_Deal_Cost_Code = AtADC.AT_Acq_Deal_Cost_Code AND AtADCC.Acq_Deal_Cost_Costtype_Code = ADCC.Acq_Deal_Cost_Costtype_Code

			/******** Insert into AT_Acq_Deal_Tab_Version****************/
			INSERT INTO AT_Acq_Deal_Tab_Version(Acq_Deal_Tab_Version_Code,[Version],Remarks,Acq_Deal_Code,Inserted_On,Approved_On,Approved_By)
			SELECT Acq_Deal_Tab_Version_Code,[Version],Remarks,Acq_Deal_Code,Inserted_On,Approved_On,Approved_By FROM Acq_Deal_Tab_Version (NOLOCK)
		
		END

		IF(@Is_Edit_WO_Approval='N')
		BEGIN
			/******************************** Insert into AT_Acq_Deal_Sport *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport(
				AT_Acq_Deal_Code, Content_Delivery, Obligation_Broadcast, Deferred_Live, Deferred_Live_Duration,Tape_Delayed, Tape_Delayed_Duration, Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial, 
				[File_Name], Sys_File_Name, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, MBO_Note, Acq_Deal_Sport_Code)
			SELECT @CurrIdent_AT_Acq_Deal,Content_Delivery,Obligation_Broadcast,Deferred_Live,Deferred_Live_Duration,Tape_Delayed,Tape_Delayed_Duration,Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial,
					[File_Name],Sys_File_Name,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By, MBO_Note, Acq_Deal_Sport_Code
			FROM Acq_Deal_Sport (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code


			/**************** Insert into AT_Acq_Deal_Sport_Broadcast ****************/ 

			INSERT INTO AT_Acq_Deal_Sport_Broadcast(
				AT_Acq_Deal_Sport_Code,Broadcast_Mode_Code,[Type], Acq_Deal_Sport_Broadcast_Code)
			SELECT 
				AtADS.AT_Acq_Deal_Sport_Code,ADSB.Broadcast_Mode_Code,ADSB.[Type], ADSB.Acq_Deal_Sport_Broadcast_Code
			FROM Acq_Deal_Sport_Broadcast ADSB (NOLOCK) INNER JOIN Acq_Deal_Sport ADS (NOLOCK) ON ADSB.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code
				INNER JOIN AT_Acq_Deal_Sport AtADS (NOLOCK) ON AtADS.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADS.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADS.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code

			/**************** Insert into AT_Acq_Deal_Sport_Platform ****************/ 

			INSERT INTO AT_Acq_Deal_Sport_Platform(
				AT_Acq_Deal_Sport_Code,Platform_Code,[Type], Acq_Deal_Sport_Platform_Code)
			SELECT 
				AtADS.AT_Acq_Deal_Sport_Code,ADSP.Platform_Code,ADSP.[Type], ADSP.Acq_Deal_Sport_Platform_Code
			FROM Acq_Deal_Sport_Platform ADSP (NOLOCK) INNER JOIN Acq_Deal_Sport ADS (NOLOCK) ON ADSP.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code
				INNER JOIN AT_Acq_Deal_Sport AtADS (NOLOCK) ON AtADS.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADS.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADS.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code

			/**************** Insert into AT_Acq_Deal_Sport_Title ****************/ 

			INSERT INTO AT_Acq_Deal_Sport_Title(
				AT_Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To, Acq_Deal_Sport_Title_Code)
			SELECT 
				AtADS.AT_Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To,ADST.Acq_Deal_Sport_Title_Code
			FROM Acq_Deal_Sport_Title ADST (NOLOCK) INNER JOIN Acq_Deal_Sport ADS (NOLOCK) ON ADST.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code
				INNER JOIN AT_Acq_Deal_Sport AtADS (NOLOCK) ON AtADS.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADS.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADS.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Ancillary(
				AT_Acq_Deal_Code, Ancillary_For, Sport_Ancillary_Type_Code, Obligation_Broadcast, Broadcast_Window,Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code,
				Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks,Acq_Deal_Sport_Ancillary_Code)
			SELECT @CurrIdent_AT_Acq_Deal,Ancillary_For, Sport_Ancillary_Type_Code, Obligation_Broadcast, Broadcast_Window,Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code,
				Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks,Acq_Deal_Sport_Ancillary_Code
			FROM Acq_Deal_Sport_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Broadcast *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Ancillary_Broadcast(
				AT_Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code,Acq_Deal_Sport_Ancillary_Broadcast_Code)
			SELECT 
				AtADSA.AT_Acq_Deal_Sport_Ancillary_Code,ADSAB.Sport_Ancillary_Broadcast_Code,ADSAB.Acq_Deal_Sport_Ancillary_Broadcast_Code
			FROM Acq_Deal_Sport_Ancillary_Broadcast ADSAB (NOLOCK) INNER JOIN Acq_Deal_Sport_Ancillary ADSA (NOLOCK) ON ADSAB.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Ancillary AtADSA (NOLOCK) ON AtADSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSA.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Source *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Ancillary_Source(
				AT_Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code,Acq_Deal_Sport_Ancillary_Source_Code)
			SELECT 
				AtADSA.AT_Acq_Deal_Sport_Ancillary_Code,ADSAS.Sport_Ancillary_Source_Code,ADSAS.Acq_Deal_Sport_Ancillary_Source_Code
			FROM Acq_Deal_Sport_Ancillary_Source ADSAS (NOLOCK) INNER JOIN Acq_Deal_Sport_Ancillary ADSA (NOLOCK) ON ADSAS.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Ancillary AtADSA (NOLOCK) ON AtADSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSA.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Title *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Ancillary_Title(
				AT_Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To,Acq_Deal_Sport_Ancillary_Title_Code)
			SELECT 
				AtADSA.AT_Acq_Deal_Sport_Ancillary_Code,ADSAT.Title_Code,ADSAT.Episode_From,ADSAT.Episode_To,ADSAT.Acq_Deal_Sport_Ancillary_Title_Code
			FROM Acq_Deal_Sport_Ancillary_Title ADSAT (NOLOCK) INNER JOIN Acq_Deal_Sport_Ancillary ADSA (NOLOCK) ON ADSAT.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Ancillary AtADSA (NOLOCK) ON AtADSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSA.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Monetisation_Ancillary(
				AT_Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks,Acq_Deal_Sport_Monetisation_Ancillary_Code)
			SELECT @CurrIdent_AT_Acq_Deal,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks,Acq_Deal_Sport_Monetisation_Ancillary_Code
			FROM Acq_Deal_Sport_Monetisation_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary_Title *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Monetisation_Ancillary_Title(
				AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To,Acq_Deal_Sport_Monetisation_Ancillary_Title_Code)
			SELECT 
				AtADSMA.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Title_Code,ADSMAT.Episode_From,ADSMAT.Episode_To,ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Title_Code
			FROM Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMAT (NOLOCK) INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary ADSMA (NOLOCK) ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Monetisation_Ancillary AtADSMA (NOLOCK) ON AtADSMA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary_Type *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Monetisation_Ancillary_Type(
				AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights,Acq_Deal_Sport_Monetisation_Ancillary_Type_Code)
			SELECT 
				AtADSMA.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Monetisation_Type_Code,ADSMAT.Monetisation_Rights,ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Type_Code
			FROM Acq_Deal_Sport_Monetisation_Ancillary_Type ADSMAT (NOLOCK) INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary ADSMA (NOLOCK) ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Monetisation_Ancillary AtADSMA (NOLOCK) ON AtADSMA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Sales_Ancillary(
				AT_Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,
				Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,
				Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity,Acq_Deal_Sport_Sales_Ancillary_Code)
			SELECT @CurrIdent_AT_Acq_Deal,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,
				Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,
				Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity,Acq_Deal_Sport_Sales_Ancillary_Code
			FROM Acq_Deal_Sport_Sales_Ancillary (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary_Title *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Sales_Ancillary_Title(
				AT_Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To,Acq_Deal_Sport_Sales_Ancillary_Title_Code)
			SELECT 
				AtADSSA.AT_Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAT.Title_Code,ADSSAT.Episode_From,ADSSAT.Episode_To,ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Title_Code
			FROM Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT (NOLOCK) INNER JOIN Acq_Deal_Sport_Sales_Ancillary ADSSA (NOLOCK) ON ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Sales_Ancillary AtADSSA  (NOLOCK) ON AtADSSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSSA.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code

			/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor *****************************************/ 

			INSERT INTO AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor(
				AT_Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type,Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code)
			SELECT 
				AtADSSA.AT_Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAS.Sponsor_Code,ADSSAS.Sponsor_Type,ADSSAS.Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code
			FROM Acq_Deal_Sport_Sales_Ancillary_Sponsor ADSSAS  (NOLOCK) INNER JOIN Acq_Deal_Sport_Sales_Ancillary ADSSA (NOLOCK) ON ADSSAS.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code
				INNER JOIN AT_Acq_Deal_Sport_Sales_Ancillary AtADSSA (NOLOCK) ON AtADSSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code AND 
				AtADSSA.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code

			
			/******************************** Insert into Acq_Deal_Payment_Terms *****************************************/ 
			INSERT INTO AT_Acq_Deal_Payment_Terms
				(AT_Acq_Deal_Code,Acq_Deal_Payment_Terms_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
			SELECT @CurrIdent_AT_Acq_Deal,Acq_Deal_Payment_Terms_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By
				FROM Acq_Deal_Payment_Terms (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
			
			
			/******************************** Insert into Acq_Deal_Attachment *****************************************/ 
			INSERT INTO AT_Acq_Deal_Attachment 
				(AT_Acq_Deal_Code,Acq_Deal_Attachment_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To)
			SELECT @CurrIdent_AT_Acq_Deal,Acq_Deal_Attachment_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To
				FROM Acq_Deal_Attachment (NOLOCK) WHERE Acq_Deal_Code =  @Acq_Deal_Code
			
			
			/******************************** Insert into AT_Acq_Deal_Material *****************************************/ 
			INSERT INTO AT_Acq_Deal_Material (
				AT_Acq_Deal_Code,Acq_Deal_Material_Code , Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By, Episode_From, Episode_To)
			SELECT @CurrIdent_AT_Acq_Deal,Acq_Deal_Material_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By, Episode_From, Episode_To
				FROM Acq_Deal_Material (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code

			/******************************** Insert into AT_Acq_Deal_Budget *****************************************/ 
			INSERT INTO AT_Acq_Deal_Budget(
				AT_Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code , Acq_Deal_Budget_Code)
			SELECT @CurrIdent_AT_Acq_Deal, Title_Code, Episode_From, Episode_To, SAP_WBS_Code, Acq_Deal_Budget_Code
				FROM Acq_Deal_Budget (NOLOCK) WHERE Acq_Deal_Code = @Acq_Deal_Code
		END	
		Set @Is_Error = 'N'		

		IF OBJECT_ID('tempdb..#Edit_WO_Approval') IS NOT NULL DROP TABLE #Edit_WO_Approval
		IF OBJECT_ID('tempdb..#Temp_Shows') IS NOT NULL DROP TABLE #Temp_Shows
		IF OBJECT_ID('tempdb..#TEMPDealMovie') IS NOT NULL DROP TABLE #TEMPDealMovie

	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_AT_Acq_Deal]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END