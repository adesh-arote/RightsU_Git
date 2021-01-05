CREATE PROCEDURE [dbo].[USP_RollBack_Syn_Deal]
	@Syn_Deal_Code INT,
	@User_Code INT
AS
-- =============================================
-- Author:		Khan Faisal
-- Create date: 07 Oct, 2014
-- Description:	Will restore syndication deal to its last approved state
/*
	exec [USP_AT_Syn_Deal] 0
*/
-- =============================================
BEGIN

	SET NOCOUNT ON 
	
	BEGIN TRY
		BEGIN TRAN
			/********************************Delete From Mapping Table **********************************************/			
			DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Code = @Syn_Deal_Code
			/********************************  Holding identity of AT_Syn_Deal ***********************************/
			DECLARE @AT_Syn_Deal_Code INT
			SET @AT_Syn_Deal_Code = 0
			SELECT TOP 1 @AT_Syn_Deal_Code = ISNULL(AT_Syn_Deal_Code, 0) FROM AT_Syn_Deal WHERE Syn_Deal_Code = @Syn_Deal_Code
			ORDER BY Cast(Version AS INT) DESC			
			
			/********************************  Update Syn_Deal *********************************************************/
			UPDATE Syn_Deal
			SET
				Syn_Deal.Deal_Type_Code = AtSD.Deal_Type_Code, Syn_Deal.Other_Deal = AtSD.Other_Deal, Syn_Deal.Agreement_No = AtSD.Agreement_No, 
				Syn_Deal.Version = AtSD.Version, Syn_Deal.Agreement_Date = AtSD.Agreement_Date, Syn_Deal.Deal_Description = AtSD.Deal_Description, 
				Syn_Deal.Status = AtSD.Status, Syn_Deal.Total_Sale = AtSD.Total_Sale, Syn_Deal.Year_Type = AtSD.Year_Type, 
				Syn_Deal.Customer_Type = AtSD.Customer_Type, Syn_Deal.Vendor_Code = AtSD.Vendor_Code, Syn_Deal.Vendor_Contact_Code = AtSD.Vendor_Contact_Code, 
				Syn_Deal.Sales_Agent_Code = AtSD.Sales_Agent_Code, Syn_Deal.Sales_Agent_Contact_Code = AtSD.Sales_Agent_Contact_Code, 
				Syn_Deal.Entity_Code = AtSD.Entity_Code, Syn_Deal.Currency_Code = AtSD.Currency_Code, Syn_Deal.Exchange_Rate = AtSD.Exchange_Rate, 
				Syn_Deal.Ref_No = AtSD.Ref_No, Syn_Deal.Attach_Workflow = AtSD.Attach_Workflow, Syn_Deal.Deal_Workflow_Status = AtSD.Deal_Workflow_Status, 
				Syn_Deal.Work_Flow_Code = AtSD.Work_Flow_Code, Syn_Deal.Is_Completed = AtSD.Is_Completed, Syn_Deal.Category_Code = AtSD.Category_Code, 
				Syn_Deal.Parent_Syn_Deal_Code = AtSD.Parent_AT_Syn_Deal_Code , Syn_Deal.Is_Migrated = AtSD.Is_Migrated, 
				Syn_Deal.Payment_Terms_Conditions = AtSD.Payment_Terms_Conditions, Syn_Deal.Deal_Tag_Code = AtSD.Deal_Tag_Code, 
				Syn_Deal.Ref_BMS_Code = AtSD.Ref_BMS_Code, Syn_Deal.Remarks = AtSD.Remarks, Syn_Deal.Rights_Remarks = AtSD.Rights_Remarks, 
				Syn_Deal.Payment_Remarks = AtSD.Payment_Remarks, Syn_Deal.Is_Active = AtSD.Is_Active, Syn_Deal.Inserted_On = AtSD.Inserted_On, 
				Syn_Deal.Inserted_By = AtSD.Inserted_By, Syn_Deal.Lock_Time = NULL, Syn_Deal.Business_Unit_Code = AtSD.Business_Unit_Code,
				Syn_Deal.Last_Updated_Time = GETDATE(), Syn_Deal.Last_Action_By = @User_Code,
				Syn_Deal.Deal_Segment_Code = AtSD.Deal_Segment_Code,
				Syn_Deal.Revenue_Vertical_Code = AtSD.Revenue_Vertical_Code
			FROM AT_Syn_Deal AtSD 
			WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code AND Syn_Deal.Syn_Deal_Code = @Syn_Deal_Code
			
			
			/******************************** Delete from Syn_Deal_Movie *****************************************/ 
			DELETE FROM Syn_Deal_Movie WHERE Syn_Deal_Code = @Syn_Deal_Code
			
			/********************************  Insert into AT_Syn_Deal_Movie *********************************************************/
			
			Set IDENTITY_INSERT Syn_Deal_Movie On

			INSERT INTO Syn_Deal_Movie(Syn_Deal_Movie_Code, Syn_Deal_Code, Title_Code, No_Of_Episode,Episode_From,Episode_End_To, Is_Closed, Syn_Title_Type, Remark)
			SELECT Syn_Deal_Movie_Code, @Syn_Deal_Code, Title_Code, No_Of_Episode,Episode_From,Episode_End_To, Is_Closed, Syn_Title_Type, Remark
			FROM AT_Syn_Deal_Movie WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code And Syn_Deal_Movie_Code Is Not Null 
			
			Set IDENTITY_INSERT Syn_Deal_Movie Off

			INSERT INTO Syn_Deal_Movie(Syn_Deal_Code, Title_Code, No_Of_Episode,Episode_From,Episode_End_To, Is_Closed, Syn_Title_Type, Remark)
			SELECT @Syn_Deal_Code, Title_Code, No_Of_Episode,Episode_From,Episode_End_To, Is_Closed, Syn_Title_Type, Remark
			FROM AT_Syn_Deal_Movie WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code And Syn_Deal_Movie_Code Is Null 
			
			/******************************** Delete from Syn_Deal_Rights *****************************************/ 
			/** Delete from Syn_Deal_Rights_Title **/
			DELETE SDRT FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Title SDRT 
				ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Rights_Platform **/
			DELETE SDRP FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Platform SDRP
				ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Rights_Subtitling **/
			DELETE SDRS FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Subtitling SDRS
				ON SDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Rights_Territory **/
			DELETE SDRT FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Territory SDRT
				ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Rights_Dubbing **/
			DELETE SDRD FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Dubbing SDRD
				ON SDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/*** Delete from Syn_Deal_Rights_Holdback_Dubbing ***/
			DELETE SDRHD FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Holdback_Dubbing SDRHD ON SDRHD.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code

			/*** Delete from Syn_Deal_Rights_Holdback_Platform ***/
			DELETE SDRHP FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Holdback_Platform SDRHP ON SDRHP.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code

			/*** Delete from Syn_Deal_Rights_Holdback_Subtitling ***/
			DELETE SDRHS FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Holdback_Subtitling SDRHS ON SDRHS.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code

			/*** Delete from Syn_Deal_Rights_Holdback_Territory ***/
			DELETE SDRHT FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Holdback_Territory SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code

			/** Delete from Syn_Deal_Rights_Holdback **/
			DELETE SDRH FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Holdback SDRH
				ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code	


			/*** Delete from Syn_Deal_Rights_Blackout_Dubbing ***/
			DELETE SDRBD FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Blackout SDRB ON SDRB.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Blackout_Dubbing SDRBD ON SDRBD.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code

			/*** Delete from Syn_Deal_Rights_Blackout_Platform ***/
			DELETE SDRBP FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Blackout SDRB ON SDRB.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Blackout_Platform SDRBP ON SDRBP.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code

			/*** Delete from Syn_Deal_Rights_Blackout_Subtitling ***/
			DELETE SDRBS FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Blackout SDRB ON SDRB.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Blackout_Subtitling SDRBS ON SDRBS.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code

			/*** Delete from Syn_Deal_Rights_Blackout_Territory ***/
			DELETE SDRBT FROM Syn_Deal_Rights SDR 
				INNER JOIN Syn_Deal_Rights_Blackout SDRB ON SDRB.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Blackout_Territory SDRBT ON SDRBT.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code
				
			/** Delete from Syn_Deal_Rights_Blackout **/
			DELETE SDRB FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Blackout SDRB
				ON SDRB.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code	

			DELETE SDRPG FROM Syn_Deal_Rights SDR   
			INNER JOIN Syn_Deal_Rights_Promoter SDRP ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code  
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code     

			 	/* Delete from Acq_Deal_Rights_Promoter_Remarks */   
			DELETE SDRPR FROM Syn_Deal_Rights SDR   
			INNER JOIN Syn_Deal_Rights_Promoter SDRP ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code  
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code  
			   
			   /* Delete from Acq_Deal_Rights_Promoter */  
			DELETE SDRP FROM Syn_Deal_Rights SDR INNER JOIN Syn_Deal_Rights_Promoter SDRP 
			ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code  
				
		
			/* Delete from Syn_Deal_Rights */	
			DELETE FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @Syn_Deal_Code
			
			/******************************** Insert into Syn_Deal_Rights *****************************************/ 
			DECLARE @Syn_Deal_Rights_Code INT
			SET @Syn_Deal_Rights_Code = 0

			DECLARE @AT_Syn_Deal_Rights_Code INT, @Is_Exclusive CHAR(1), @Is_Title_Language_Right CHAR(1),@Is_Sub_License CHAR(1),@Sub_License_Code INT,
			@Is_Theatrical_Right CHAR(1), @Right_Type CHAR(1), @Original_Right_Type CHAR(1), @Is_Tentative CHAR(1),@Term VARCHAR(12), 
			@Right_Start_Date DATETIME, @Right_End_Date DATETIME, @Milestone_Type_Code INT, @Milestone_No_Of_Unit INT, @Milestone_Unit_Type INT, 
			@Is_ROFR CHAR(1), @ROFR_Date DATETIME, @Restriction_Remarks NVARCHAR(MAX), @Effective_Start_Date DATETIME, @Actual_Right_Start_Date DATETIME, 
			@Actual_Right_End_Date DATETIME, @Inserted_By INT ,@Inserted_On DATETIME, @Last_Updated_Time DATETIME, @Last_Action_By INT, @Is_Pushback CHAR(1),
			@Syn_Deal_Rights_Old_Code INT = 0,@ROFR_Code INT,@Promoter_Flag CHAR(1)

			DECLARE rights_cursor CURSOR FOR 
			SELECT AT_Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
				Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
				Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
				Inserted_By, Inserted_On, GETDATE(), @User_Code, ISNULL(Is_Pushback,'N'), Syn_Deal_Rights_Code, ROFR_Code, Promoter_Flag
			FROM AT_Syn_Deal_Rights WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code

			OPEN rights_cursor

			FETCH NEXT FROM rights_cursor 
			INTO @AT_Syn_Deal_Rights_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, 
				@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, 
				@Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
				@Actual_Right_Start_Date, @Actual_Right_End_Date, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 
				@Is_Pushback, @Syn_Deal_Rights_Old_Code, @ROFR_Code,@Promoter_Flag
			WHILE @@FETCH_STATUS = 0
			BEGIN
				
				If(IsNull(@Syn_Deal_Rights_Old_Code, 0) = 0)
				Begin
					INSERT INTO Syn_Deal_Rights 
					(
						Syn_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, 
						Is_Theatrical_Right, Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, 
						Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, 
						Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, 
						Is_Pushback, Right_Status, ROFR_Code, Promoter_Flag
					)
					VALUES
					(
						@Syn_Deal_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, 
						@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, 
						@Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
						@Actual_Right_Start_Date, @Actual_Right_End_Date, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 
						@Is_Pushback, 'C', @ROFR_Code, @Promoter_Flag
					)

					SELECT @Syn_Deal_Rights_Code = IDENT_CURRENT('Syn_Deal_Rights')

				End
				Else
				Begin
					Set IDENTITY_INSERT [Syn_Deal_Rights] On
					
					INSERT INTO Syn_Deal_Rights 
					(
						Syn_Deal_Rights_Code, Syn_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, 
						Is_Theatrical_Right, Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, 
						Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, 
						Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, 
						Is_Pushback, Right_Status, Promoter_Flag
					)
					VALUES
					(
						@Syn_Deal_Rights_Old_Code, @Syn_Deal_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, 
						@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, 
						@Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
						@Actual_Right_Start_Date, @Actual_Right_End_Date, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 
						@Is_Pushback, 'C' ,@Promoter_Flag
					)
					
					Set IDENTITY_INSERT [Syn_Deal_Rights] Off
					
					SELECT @Syn_Deal_Rights_Code = @Syn_Deal_Rights_Old_Code
				End

				

				/**************** Insert into Syn_Deal_Rights_Title ****************/ 

				INSERT INTO Syn_Deal_Rights_Title (Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
				SELECT @Syn_Deal_Rights_Code, AtADRT.Title_Code, AtADRT.Episode_From, AtADRT.Episode_To
				From AT_Syn_Deal_Rights_Title AtADRT WHERE AtADRT.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code

				/**************** Insert into Syn_Deal_Rights_Title_Eps ****************/ 

			
				INSERT INTO Syn_Deal_Rights_Title_Eps (Syn_Deal_Rights_Title_Code, EPS_No)
				SELECT ADRT.Syn_Deal_Rights_Title_Code, AtADRTE.EPS_No
				FROM AT_Syn_Deal_Rights_Title_EPS AtADRTE
					INNER JOIN AT_Syn_Deal_Rights_Title AtADRT ON AtADRTE.AT_Syn_Deal_Rights_Title_Code = AtADRT.AT_Syn_Deal_Rights_Title_Code
					INNER JOIN Syn_Deal_Rights_Title ADRT ON 
						CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)
						=
						CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)
						WHERE AtADRT.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code

				/**************** Insert into Syn_Deal_Rights_Platform ****************/

				INSERT INTO Syn_Deal_Rights_Platform (Syn_Deal_Rights_Code, Platform_Code)	
				SELECT @Syn_Deal_Rights_Code, AtADRP.Platform_Code
				From AT_Syn_Deal_Rights_Platform AtADRP WHERE AtADRP.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code


				/**************** Insert into Syn_Deal_Rights_Territory ****************/ 

				INSERT INTO Syn_Deal_Rights_Territory (Syn_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)	
				SELECT @Syn_Deal_Rights_Code, AtADRT.Territory_Code, AtADRT.Territory_Type, AtADRT.Country_Code
				From AT_Syn_Deal_Rights_Territory AtADRT WHERE AtADRT.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code

				/**************** Insert into Syn_Deal_Rights_Subtitling ****************/ 

				INSERT INTO Syn_Deal_Rights_Subtitling (Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
				SELECT @Syn_Deal_Rights_Code, AtADRS.Language_Code, AtADRS.Language_Group_Code, AtADRS.Language_Type
				From AT_Syn_Deal_Rights_Subtitling AtADRS WHERE AtADRS.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code

				/**************** Insert into Syn_Deal_Rights_Dubbing ****************/ 
			
				INSERT INTO Syn_Deal_Rights_Dubbing (Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
				SELECT @Syn_Deal_Rights_Code, AtADRD.Language_Code, AtADRD.Language_Group_Code, AtADRD.Language_Type
				From AT_Syn_Deal_Rights_Dubbing AtADRD WHERE AtADRD.AT_Syn_Deal_Rights_Code	= @AT_Syn_Deal_Rights_Code
				/**************** Insert into Syn_Deal_Rights_Holdback ****************/ 
				INSERT INTO Syn_Deal_Rights_Holdback (Syn_Deal_Rights_Code, 
					Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
					Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Original_Language)
				SELECT @Syn_Deal_Rights_Code, 
					AtADRH.Holdback_Type, AtADRH.HB_Run_After_Release_No, AtADRH.HB_Run_After_Release_Units, 
					AtADRH.Holdback_On_Platform_Code, AtADRH.Holdback_Release_Date, AtADRH.Holdback_Comment, AtADRH.Is_Original_Language
				FROM AT_Syn_Deal_Rights_Holdback AtADRH WHERE AtADRH.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Holdback_Dubbing ********/ 

				INSERT INTO Syn_Deal_Rights_Holdback_Dubbing ( Syn_Deal_Rights_Holdback_Code, Language_Code)
				SELECT ADRH.Syn_Deal_Rights_Holdback_Code, AtADRHD.Language_Code
				FROM AT_Syn_Deal_Rights_Holdback_Dubbing AtADRHD
					INNER JOIN AT_Syn_Deal_Rights_Holdback AtADRH ON AtADRHD.AT_Syn_Deal_Rights_Holdback_Code = AtADRH.AT_Syn_Deal_Rights_Holdback_Code
					INNER JOIN Syn_Deal_Rights_Holdback ADRH ON
						CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Original_Language, '') 
						=
						CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Original_Language, '') 
						WHERE AtADRH.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Holdback_Platform ********/ 

				INSERT INTO Syn_Deal_Rights_Holdback_Platform (Syn_Deal_Rights_Holdback_Code, Platform_Code)
				SELECT ADRH.Syn_Deal_Rights_Holdback_Code, AtADRHP.Platform_Code
				FROM AT_Syn_Deal_Rights_Holdback_Platform AtADRHP
					INNER JOIN AT_Syn_Deal_Rights_Holdback AtADRH ON AtADRHP.AT_Syn_Deal_Rights_Holdback_Code = AtADRH.AT_Syn_Deal_Rights_Holdback_Code
					INNER JOIN Syn_Deal_Rights_Holdback ADRH ON
						CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Original_Language, '') 
						=
						CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Original_Language, '') 
						WHERE AtADRH.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Holdback_Subtitling ********/ 

				INSERT INTO Syn_Deal_Rights_Holdback_Subtitling (Syn_Deal_Rights_Holdback_Code, Language_Code)
				SELECT ADRH.Syn_Deal_Rights_Holdback_Code, AtADRHS.Language_Code
				FROM AT_Syn_Deal_Rights_Holdback_Subtitling AtADRHS
					INNER JOIN AT_Syn_Deal_Rights_Holdback AtADRH ON AtADRHS.AT_Syn_Deal_Rights_Holdback_Code = AtADRH.AT_Syn_Deal_Rights_Holdback_Code
					INNER JOIN Syn_Deal_Rights_Holdback ADRH ON
						CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Original_Language, '') 
						=
						CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Original_Language, '') 
						WHERE AtADRH.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Holdback_Territory ********/ 

			
				INSERT INTO Syn_Deal_Rights_Holdback_Territory (
					Syn_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
				SELECT
					ADRH.Syn_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code
				FROM AT_Syn_Deal_Rights_Holdback_Territory AtADRHT
					INNER JOIN AT_Syn_Deal_Rights_Holdback AtADRH ON AtADRHT.AT_Syn_Deal_Rights_Holdback_Code = AtADRH.AT_Syn_Deal_Rights_Holdback_Code
					INNER JOIN Syn_Deal_Rights_Holdback ADRH ON 
						CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Original_Language, '') 
						=
						CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
						ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Original_Language, '') 
						WHERE AtADRH.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/**************** Insert into Syn_Deal_Rights_Blackout ****************/ 
			
				INSERT INTO Syn_Deal_Rights_Blackout (
					Syn_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
				SELECT 
					@Syn_Deal_Rights_Code, AtADRB.Start_Date, AtADRB.End_Date, AtADRB.Inserted_By, AtADRB.Inserted_On, GETDATE(), @User_Code
				FROM AT_Syn_Deal_Rights_Blackout AtADRB WHERE AtADRB.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Blackout_Dubbing ********/ 

				INSERT INTO Syn_Deal_Rights_Blackout_Dubbing (Syn_Deal_Rights_Blackout_Code, Language_Code)
				SELECT ADRB.Syn_Deal_Rights_Blackout_Code, AtADRBD.Language_Code
				FROM AT_Syn_Deal_Rights_Blackout_Dubbing AtADRBD
					INNER JOIN AT_Syn_Deal_Rights_Blackout AtADRB ON AtADRBD.AT_Syn_Deal_Rights_Blackout_Code = AtADRB.AT_Syn_Deal_Rights_Blackout_Code
					INNER JOIN Syn_Deal_Rights_Blackout ADRB ON 
						CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR) 
						=
						CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)
						WHERE AtADRB.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Blackout_Platform ********/ 

			

				INSERT INTO Syn_Deal_Rights_Blackout_Platform (Syn_Deal_Rights_Blackout_Code, Platform_Code)
				SELECT ADRB.Syn_Deal_Rights_Blackout_Code, AtADRBP.Platform_Code
				FROM AT_Syn_Deal_Rights_Blackout_Platform AtADRBP
					INNER JOIN AT_Syn_Deal_Rights_Blackout AtADRB ON AtADRBP.AT_Syn_Deal_Rights_Blackout_Code = AtADRB.AT_Syn_Deal_Rights_Blackout_Code
					INNER JOIN Syn_Deal_Rights_Blackout ADRB ON 
						CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)
						=
						CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR) 
						WHERE AtADRB.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Blackout_Subtitling ********/ 

			
				INSERT INTO Syn_Deal_Rights_Blackout_Subtitling(Syn_Deal_Rights_Blackout_Code, Language_Code)
				SELECT ADRB.Syn_Deal_Rights_Blackout_Code, AtADRBS.Language_Code
				FROM AT_Syn_Deal_Rights_Blackout_Subtitling AtADRBS
					INNER JOIN AT_Syn_Deal_Rights_Blackout AtADRB ON AtADRBS.AT_Syn_Deal_Rights_Blackout_Code = AtADRB.AT_Syn_Deal_Rights_Blackout_Code
					INNER JOIN Syn_Deal_Rights_Blackout ADRB ON
						CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR) 
						=
						CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR) 
						WHERE AtADRB.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/******** Insert into Syn_Deal_Rights_Blackout_Territory ********/ 

			
				INSERT INTO Syn_Deal_Rights_Blackout_Territory(Syn_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)
				SELECT ADRB.Syn_Deal_Rights_Blackout_Code, AtADRBT.Country_Code, AtADRBT.Territory_Code, AtADRBT.Territory_Type
				FROM AT_Syn_Deal_Rights_Blackout_Territory AtADRBT
					INNER JOIN AT_Syn_Deal_Rights_Blackout AtADRB ON AtADRBT.AT_Syn_Deal_Rights_Blackout_Code = AtADRB.AT_Syn_Deal_Rights_Blackout_Code
					INNER JOIN Syn_Deal_Rights_Blackout ADRB ON
						CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR) 
						=
						CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)
						WHERE AtADRB.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code And ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				/**************** Insert into Syn_Deal_Rights_Promoter ****************/   
     
				INSERT INTO Syn_Deal_Rights_Promoter (  
				Syn_Deal_Rights_Code,  Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Syn_Deal_Rights_Code, AtSDRP.Inserted_By, AtSDRP.Inserted_On, GETDATE(), @User_Code  
				FROM AT_Syn_Deal_Rights_Promoter AtSDRP WHERE AtSDRP.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code  

				/******** Insert into Syn_Deal_Rights_Promoter_Group ********/   

     
		 INSERT INTO Syn_Deal_Rights_Promoter_Group( Syn_Deal_Rights_Promoter_Code, Promoter_Group_Code)
                      SELECT SDRPNew.Syn_Deal_Rights_Promoter_Code, SDRPG.Promoter_Group_Code
                      FROM (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From AT_Syn_Deal_Rights_Promoter
						Where AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code
					  ) SDRP
                      INNER JOIN AT_Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.AT_Syn_Deal_Rights_Promoter_Code = SDRP.AT_Syn_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter
						Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					  ) As SDRPNew On SDRP.RowId = SDRPNew.RowId

					  /******** Insert into Syn_Deal_Rights_Promoter_Remarks ********/   
  
				 INSERT INTO Syn_Deal_Rights_Promoter_Remarks( Syn_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
                      SELECT SDRPNew.Syn_Deal_Rights_Promoter_Code, SDRPR.Promoter_Remarks_Code
                      FROM (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From AT_Syn_Deal_Rights_Promoter
						Where AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code
					  ) SDRP
                      INNER JOIN AT_Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.AT_Syn_Deal_Rights_Promoter_Code = SDRP.AT_Syn_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter
						Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					  ) As SDRPNew On SDRP.RowId = SDRPNew.RowId

				FETCH NEXT FROM rights_cursor 
				INTO @AT_Syn_Deal_Rights_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, 
				@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, 
				@Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
				@Actual_Right_Start_Date, @Actual_Right_End_Date, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 
				@Is_Pushback, @Syn_Deal_Rights_Old_Code, @ROFR_Code , @Promoter_Flag
			END

			CLOSE rights_cursor;
			DEALLOCATE rights_cursor;
			
			/******************************** Delete from Syn_Deal_Ancillary *****************************************/ 
			/*** Delete from Syn_Deal_Ancillary_Platform_Medium ***/
			DELETE SDAPM FROM Syn_Deal_Ancillary SDA 
				INNER JOIN Syn_Deal_Ancillary_Platform SDAP ON SDAP.Syn_Deal_Ancillary_Code = SDA.Syn_Deal_Ancillary_Code AND SDA.Syn_Deal_Code= @Syn_Deal_Code 
				INNER JOIN Syn_Deal_Ancillary_Platform_Medium SDAPM ON SDAPM.Syn_Deal_Ancillary_Platform_Code = SDAP.Syn_Deal_Ancillary_Platform_Code

			/** Delete from Syn_Deal_Ancillary_Platform **/
			DELETE SDAP FROM Syn_Deal_Ancillary SDA INNER JOIN Syn_Deal_Ancillary_Platform SDAP
				ON SDAP.Syn_Deal_Ancillary_Code = SDA.Syn_Deal_Ancillary_Code AND SDA.Syn_Deal_Code= @Syn_Deal_Code 

			/** Delete from Syn_Deal_Ancillary_Title **/
			DELETE SDAT FROM Syn_Deal_Ancillary SDA INNER JOIN Syn_Deal_Ancillary_Title SDAT
				ON SDAT.Syn_Deal_Ancillary_Code = SDA.Syn_Deal_Ancillary_Code AND SDA.Syn_Deal_Code= @Syn_Deal_Code 

			/* Delete from Syn_Deal_Ancillary */
			DELETE FROM Syn_Deal_Ancillary WHERE Syn_Deal_Code= @Syn_Deal_Code
			
			/********************************Cursor Ancillary *********************************************************/
			PRINT 'ancillary'
			DECLARE @Syn_Deal_Ancillary_Code INT = 0
			DECLARE @AT_Syn_Deal_Ancillary_Code INT,@Ancillary_Type_code INT, @Duration numeric, @Day numeric, @A_Remarks NVARCHAR(2000), @Group_No INT
			DECLARE ancillary_cursor CURSOR
			FOR SELECT AT_Syn_Deal_Ancillary_Code, Ancillary_Type_code, Duration, Day, Remarks, Group_No
				FROM AT_Syn_Deal_Ancillary WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code
			OPEN ancillary_cursor

			FETCH NEXT FROM ancillary_cursor
			INTO @AT_Syn_Deal_Ancillary_Code,@Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					/******************************** Insert into AT_Syn_Deal_Ancillary *****************************************/ 
					INSERT INTO Syn_Deal_Ancillary VALUES(
						@Syn_Deal_Code, @Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No)

						SELECT @Syn_Deal_Ancillary_Code = IDENT_CURRENT('Syn_Deal_Ancillary')

					/**************** Insert into Syn_Deal_Ancillary_Platform ****************/ 

					INSERT INTO Syn_Deal_Ancillary_Platform (Syn_Deal_Ancillary_Code, Ancillary_Platform_code)
					SELECT @Syn_Deal_Ancillary_Code, AtADAP.Ancillary_Platform_code
					FROM AT_Syn_Deal_Ancillary_Platform AtADAP WHERE AtADAP.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code

					/******** Insert into Syn_Deal_Ancillary_Platform_Medium ********/ 

			
					INSERT INTO Syn_Deal_Ancillary_Platform_Medium(Syn_Deal_Ancillary_Platform_Code, Ancillary_Platform_Medium_Code)
					SELECT ADAP.Syn_Deal_Ancillary_Platform_Code, AtADAPM.Ancillary_Platform_Medium_Code
					FROM AT_Syn_Deal_Ancillary_Platform_Medium AtADAPM
						INNER JOIN AT_Syn_Deal_Ancillary_Platform AtADAP ON AtADAPM.AT_Syn_Deal_Ancillary_Platform_Code = AtADAP.AT_Syn_Deal_Ancillary_Platform_Code
						INNER JOIN Syn_Deal_Ancillary_Platform ADAP ON ADAP.Ancillary_Platform_code = AtADAP.Ancillary_Platform_code
						WHERE AtADAP.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code

					/**************** Insert into Syn_Deal_Ancillary_Title ****************/ 

					INSERT INTO Syn_Deal_Ancillary_Title (Syn_Deal_Ancillary_Code, Title_Code, Episode_From, Episode_To)
					SELECT @Syn_Deal_Ancillary_Code, AtADAT.Title_Code, AtADAT.Episode_From, AtADAT.Episode_To
					FROM AT_Syn_Deal_Ancillary_Title AtADAT WHERE AtADAT.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code

					FETCH NEXT FROM ancillary_cursor
					INTO @AT_Syn_Deal_Ancillary_Code,@Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No

				END
			CLOSE ancillary_cursor
			DEALLOCATE ancillary_cursor

					/******************************** Delete from Syn_Deal_Run *****************************************/ 
			/* Delete from Syn_Deal_Run_Platform */
			DELETE ADRP FROM Syn_Deal_Run SDR INNER JOIN Syn_Deal_Run_Platform ADRP
				ON ADRP.Syn_Deal_Run_Code = SDR.Syn_Deal_Run_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/* Delete from Syn_Deal_Run_Repeat_On_Day */
			DELETE SDRRD FROM Syn_Deal_Run SDR INNER JOIN Syn_Deal_Run_Repeat_On_Day SDRRD
				ON SDRRD.Syn_Deal_Run_Code = SDR.Syn_Deal_Run_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code


			/* Delete from Syn_Deal_Run_Yearwise_Run */	
			DELETE SDRYR FROM Syn_Deal_Run SDR INNER JOIN Syn_Deal_Run_Yearwise_Run SDRYR
				ON SDRYR.Syn_Deal_Run_Code = SDR.Syn_Deal_Run_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/* Delete from Syn_Deal_Run */
			DELETE FROM Syn_Deal_Run WHERE Syn_Deal_Code = @Syn_Deal_Code

			--DECLARE run cursor
		   DECLARE @Syn_Deal_Run_Code INT = 0
		   DECLARE @AT_Syn_Deal_Run_Code INT, @Title_Code INT, @Episode_From INT, @Episode_To INT, @Run_Type CHAR(1), @No_Of_Runs INT, @Is_Yearwise_Definition CHAR(1),
		   @Is_Rule_Right CHAR(1), @Right_Rule_Code INT, @Repeat_Within_Days_Hrs CHAR(1), @No_Of_Days_Hrs INT, @SR_Inserted_By INT, @SR_Inserted_On DATETIME,
		   @SR_Last_action_By INT, @SR_Last_updated_Time DATETIME

			DECLARE run_cursor CURSOR FOR
			SELECT AT_Syn_Deal_Run_Code,Title_Code,Episode_From,Episode_To, Run_Type, No_Of_Runs, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
				Repeat_Within_Days_Hrs, No_Of_Days_Hrs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
			FROM AT_Syn_Deal_Run WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code

			OPEN run_cursor
			FETCH NEXT FROM run_cursor
			INTO  @AT_Syn_Deal_Run_Code , @Title_Code , @Episode_From , @Episode_To , @Run_Type , @No_Of_Runs, @Is_Yearwise_Definition,
		   @Is_Rule_Right , @Right_Rule_Code , @Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @SR_Inserted_By, @SR_Inserted_On,
		   @SR_Last_action_By, @SR_Last_updated_Time

				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					/******************************** Insert into Syn_Deal_Run *****************************************/ 
					INSERT INTO Syn_Deal_Run VALUES(
					@Syn_Deal_Code,@Title_Code, @Episode_From , @Episode_To , @Run_Type, @No_Of_Runs, @Is_Yearwise_Definition, @Is_Rule_Right, 
					@Repeat_Within_Days_Hrs, @Right_Rule_Code, @No_Of_Days_Hrs,@SR_Inserted_By,@SR_Inserted_On,@SR_Last_action_By,@SR_Last_updated_Time)

					SELECT @Syn_Deal_Run_Code = IDENT_CURRENT('Syn_Deal_Run')

					/**************** Insert into Syn_Deal_Run_Repeat_On_Day ****************/ 
			
					INSERT INTO Syn_Deal_Run_Repeat_On_Day (Syn_Deal_Run_Code, Day_Code)
					SELECT @Syn_Deal_Run_Code, AtADRRD.Day_Code
					FROM AT_Syn_Deal_Run_Repeat_On_Day AtADRRD WHERE AtADRRD.AT_Syn_Deal_Run_Code = @AT_Syn_Deal_Run_Code

					
					/**************** Insert into Syn_Deal_Run_Platform ****************/ 

					INSERT INTO Syn_Deal_Run_Platform(Syn_Deal_Run_Code, Platform_Code)
					SELECT @Syn_Deal_Run_Code, AtADRT.Platform_Code
					FROM AT_Syn_Deal_Run_Platform AtADRT WHERE AtADRT.AT_Syn_Deal_Run_Code = @AT_Syn_Deal_Run_Code

					/**************** Insert into Syn_Deal_Run_Yearwise_Run ****************/ 

					INSERT INTO Syn_Deal_Run_Yearwise_Run ( 
						Syn_Deal_Run_Code, Start_Date, End_Date, No_Of_Runs,Year_No)
					SELECT 
						@Syn_Deal_Run_Code, AtADRYR.Start_Date, AtADRYR.End_Date, AtADRYR.No_Of_Runs, AtADRYR.Year_No
					FROM AT_Syn_Deal_Run_Yearwise_Run AtADRYR WHERE AtADRYR.AT_Syn_Deal_Run_Code = @AT_Syn_Deal_Run_Code

					

					FETCH NEXT FROM run_cursor
					INTO  @AT_Syn_Deal_Run_Code , @Title_Code , @Episode_From , @Episode_To , @Run_Type , @No_Of_Runs, @Is_Yearwise_Definition,
					@Is_Rule_Right , @Right_Rule_Code , @Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @SR_Inserted_By, @SR_Inserted_On,
					@SR_Last_action_By, @SR_Last_updated_Time
				END
			CLOSE run_cursor
			DEALLOCATE run_cursor


			/******************************** Delete from Syn_Deal_Revenue *****************************************/ 
			/** Delete from Syn_Deal_Revenue_Additional_Exp **/
			DELETE SDRAE FROM Syn_Deal_Revenue SDR INNER JOIN Syn_Deal_Revenue_Additional_Exp SDRAE
				ON SDRAE.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Revenue_Commission **/
			DELETE SDRC FROM Syn_Deal_Revenue SDR INNER JOIN Syn_Deal_Revenue_Commission SDRC
				ON SDRC.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/*** Delete from Syn_Deal_Revenue_Costtype_Episode ***/
			DELETE SDRCE FROM Syn_Deal_Revenue SDR 
				INNER JOIN Syn_Deal_Revenue_Costtype SDRC ON SDRC.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code
				INNER JOIN Syn_Deal_Revenue_Costtype_Episode SDRCE ON SDRCE.Syn_Deal_Revenue_Costtype_Code = SDRC.Syn_Deal_Revenue_Costtype_Code

			/** Delete from Syn_Deal_Revenue_Costtype **/
			DELETE SDRC FROM Syn_Deal_Revenue SDR INNER JOIN Syn_Deal_Revenue_Costtype SDRC 
				ON SDRC.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Revenue_Title **/
			DELETE SDRT FROM Syn_Deal_Revenue SDR INNER JOIN Syn_Deal_Revenue_Title SDRT
				ON SDRT.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/** Delete from Syn_Deal_Revenue_Variable_Cost **/
			DELETE SDRVC FROM Syn_Deal_Revenue SDR INNER JOIN Syn_Deal_Revenue_Variable_Cost SDRVC
				ON SDRVC.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code AND SDR.Syn_Deal_Code = @Syn_Deal_Code

			/* Delete from Syn_Deal_Revenue */
			DELETE FROM Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
			
			
			/********************************  Insert into AT_Syn_Deal_Revenue *********************************************************/
			INSERT INTO Syn_Deal_Revenue(
				Syn_Deal_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, 
				Catchup_Cost, Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, 
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
			SELECT 
				@Syn_Deal_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, 
				Catchup_Cost, Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, 
				Inserted_On, Inserted_By, GETDATE(), @User_Code
			FROM AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code
			
			/**************** Insert into Syn_Deal_Revenue_Additional_Exp ****************/
			INSERT INTO Syn_Deal_Revenue_Additional_Exp (
				Syn_Deal_Revenue_Code, Additional_Expense_Code, Amount, Min_Max, 
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
			SELECT 
				SDC.Syn_Deal_Revenue_Code, AtSDCAE.Additional_Expense_Code, AtSDCAE.Amount, AtSDCAE.Min_Max, 
				AtSDCAE.Inserted_On, AtSDCAE.Inserted_By, GETDATE(), @User_Code
			FROM AT_Syn_Deal_Revenue AtSDC
				INNER JOIN AT_Syn_Deal_Revenue_Additional_Exp AtSDCAE ON AtSDCAE.AT_Syn_Deal_Revenue_Code = AtSDC.AT_Syn_Deal_Revenue_Code AND AtSDC.AT_Syn_Deal_Code = @AT_Syn_Deal_Code
				INNER JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = @Syn_Deal_Code AND 
					CAST(ISNULL(SDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(SDC.Variable_Cost_Type, '') + '~' +
					ISNULL(SDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(SDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Inserted_By, '') AS VARCHAR) 
					=
					CAST(ISNULL(AtSDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(AtSDC.Variable_Cost_Type, '') + '~' +
					ISNULL(AtSDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(AtSDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Inserted_By, '') AS VARCHAR)
			
			/**************** Insert into Syn_Deal_Revenue_Commission ****************/
			INSERT INTO Syn_Deal_Revenue_Commission (
				Syn_Deal_Revenue_Code, Cost_Type_Code, Royalty_Commission_Code, 
				Vendor_Code, Entity_Code, Type, Commission_Type, Percentage, Amount)
			SELECT 
				SDC.Syn_Deal_Revenue_Code, AtSDCC.Cost_Type_Code, AtSDCC.Royalty_Commission_Code, 
				AtSDCC.Vendor_Code, AtSDCC.Entity_Code, AtSDCC.Type, AtSDCC.Commission_Type, AtSDCC.Percentage, AtSDCC.Amount
			FROM AT_Syn_Deal_Revenue AtSDC
				INNER JOIN AT_Syn_Deal_Revenue_Commission AtSDCC ON AtSDCC.AT_Syn_Deal_Revenue_Code = AtSDC.AT_Syn_Deal_Revenue_Code AND AtSDC.AT_Syn_Deal_Code = @AT_Syn_Deal_Code
				INNER JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = @Syn_Deal_Code AND 
					CAST(ISNULL(SDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(SDC.Variable_Cost_Type, '') + '~' +
					ISNULL(SDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(SDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Inserted_By, '') AS VARCHAR)
					=
					CAST(ISNULL(AtSDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(AtSDC.Variable_Cost_Type, '') + '~' +
					ISNULL(AtSDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(AtSDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Inserted_By, '') AS VARCHAR)
			
			/**************** Insert into Syn_Deal_Revenue_Title ****************/
			INSERT INTO Syn_Deal_Revenue_Title (Syn_Deal_Revenue_Code, Title_Code,Episode_From,Episode_To)
			SELECT SDC.Syn_Deal_Revenue_Code, AtSDCT.Title_Code,AtSDCT.Episode_From,AtSDCT.Episode_To
			FROM AT_Syn_Deal_Revenue AtSDC
				INNER JOIN AT_Syn_Deal_Revenue_Title AtSDCT ON AtSDCT.AT_Syn_Deal_Revenue_Code = AtSDC.AT_Syn_Deal_Revenue_Code AND AtSDC.AT_Syn_Deal_Code = @AT_Syn_Deal_Code
				INNER JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = @Syn_Deal_Code AND 
					CAST(ISNULL(SDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(SDC.Variable_Cost_Type, '') + '~' +
					ISNULL(SDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(SDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Inserted_By, '') AS VARCHAR)
					=
					CAST(ISNULL(AtSDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(AtSDC.Variable_Cost_Type, '') + '~' +
					ISNULL(AtSDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(AtSDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Inserted_By, '') AS VARCHAR)
			
			/**************** Insert into Syn_Deal_Revenue_Variable_Cost ****************/
			INSERT INTO Syn_Deal_Revenue_Variable_Cost (
				Syn_Deal_Revenue_Code, Entity_Code, Vendor_Code, Percentage, Amount, 
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
			SELECT 
				SDC.Syn_Deal_Revenue_Code, 
				AtSDCVC.Entity_Code, AtSDCVC.Vendor_Code, AtSDCVC.Percentage, AtSDCVC.Amount, 
				AtSDCVC.Inserted_On, AtSDCVC.Inserted_By, GETDATE(), @User_Code
			FROM AT_Syn_Deal_Revenue AtSDC
				INNER JOIN AT_Syn_Deal_Revenue_Variable_Cost AtSDCVC ON AtSDCVC.AT_Syn_Deal_Revenue_Code = AtSDC.AT_Syn_Deal_Revenue_Code AND AtSDC.AT_Syn_Deal_Code = @AT_Syn_Deal_Code
				INNER JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = @Syn_Deal_Code AND 
					CAST(ISNULL(SDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(SDC.Variable_Cost_Type, '') + '~' +
					ISNULL(SDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(SDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Inserted_By, '') AS VARCHAR)
					=
					CAST(ISNULL(AtSDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(AtSDC.Variable_Cost_Type, '') + '~' +
					ISNULL(AtSDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(AtSDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Inserted_By, '') AS VARCHAR)
			
			/**************** Insert into Syn_Deal_Revenue_Costtype ****************/
			INSERT INTO Syn_Deal_Revenue_Costtype (
				Syn_Deal_Revenue_Code, Cost_Type_Code, Amount, Consumed_Amount, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
			SELECT 
				SDC.Syn_Deal_Revenue_Code, 
				AtSDCC.Cost_Type_Code, AtSDCC.Amount, AtSDCC.Consumed_Amount, AtSDCC.Inserted_On, AtSDCC.Inserted_By, GETDATE(), @User_Code
			FROM AT_Syn_Deal_Revenue AtSDC
				INNER JOIN AT_Syn_Deal_Revenue_Costtype AtSDCC ON AtSDCC.AT_Syn_Deal_Revenue_Code = AtSDC.AT_Syn_Deal_Revenue_Code AND AtSDC.AT_Syn_Deal_Code = @AT_Syn_Deal_Code
				INNER JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = @Syn_Deal_Code AND 
					CAST(ISNULL(SDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(SDC.Variable_Cost_Type, '') + '~' +
					ISNULL(SDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(SDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Inserted_By, '') AS VARCHAR)
					=
					CAST(ISNULL(AtSDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(AtSDC.Variable_Cost_Type, '') + '~' +
					ISNULL(AtSDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(AtSDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Inserted_By, '') AS VARCHAR) 
			
			/******** Insert into Syn_Deal_Revenue_Costtype_Episode ********/
			INSERT INTO Syn_Deal_Revenue_Costtype_Episode (
				Syn_Deal_Revenue_Costtype_Code, Episode_From, Episode_To, Amount_Type, Amount, Percentage, Remarks)
			SELECT 
				SDCC.Syn_Deal_Revenue_Costtype_Code,
				AtSDCCE.Episode_From, AtSDCCE.Episode_To, AtSDCCE.Amount_Type, AtSDCCE.Amount, AtSDCCE.Percentage, AtSDCCE.Remarks
			FROM AT_Syn_Deal_Revenue AtSDC
				INNER JOIN AT_Syn_Deal_Revenue_Costtype AtSDCC ON AtSDCC.AT_Syn_Deal_Revenue_Code = AtSDC.AT_Syn_Deal_Revenue_Code AND AtSDC.AT_Syn_Deal_Code = @AT_Syn_Deal_Code
				INNER JOIN AT_Syn_Deal_Revenue_Costtype_Episode AtSDCCE ON AtSDCCE.AT_Syn_Deal_Revenue_Costtype_Code = AtSDCC.AT_Syn_Deal_Revenue_Costtype_Code
				INNER JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = @Syn_Deal_Code AND 
					CAST(ISNULL(SDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(SDC.Variable_Cost_Type, '') + '~' +
					ISNULL(SDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(SDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(SDC.Inserted_By, '') AS VARCHAR)
					=
					CAST(ISNULL(AtSDC.Currency_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Currency_Exchange_Rate, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Deal_Cost, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Deal_Cost_Per_Episode, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Cost_Center_Id, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Additional_Cost, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Catchup_Cost, 0) AS VARCHAR) + '~' + ISNULL(AtSDC.Variable_Cost_Type, '') + '~' +
					ISNULL(AtSDC.Variable_Cost_Sharing_Type, '') + '~' + CAST(ISNULL(AtSDC.Royalty_Recoupment_Code, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDC.Inserted_On, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDC.Inserted_By, '') AS VARCHAR)
				INNER JOIN Syn_Deal_Revenue_Costtype SDCC ON SDCC.Syn_Deal_Revenue_Code = SDC.Syn_Deal_Revenue_Code AND
					CAST(ISNULL(SDCC.Cost_Type_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(SDCC.Amount, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(SDCC.Consumed_Amount, 0) AS VARCHAR) + '~' + CAST(ISNULL(SDCC.Inserted_On, '') AS VARCHAR) + '~' +
					CAST(ISNULL(SDCC.Inserted_By, '') AS VARCHAR)
					=
					CAST(ISNULL(AtSDCC.Cost_Type_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDCC.Amount, 0) AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDCC.Consumed_Amount, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtSDCC.Inserted_On, '') AS VARCHAR) + '~' +
					CAST(ISNULL(AtSDCC.Inserted_By, '') AS VARCHAR)
			
			
			/********************************  Delete from Syn_Deal_Attachment *********************************************************/
			DELETE FROM Syn_Deal_Payment_Terms WHERE Syn_Deal_Code = @Syn_Deal_Code
			
			/********************************  Insert into Syn_Deal_Payment_Terms *********************************************************/
			INSERT INTO Syn_Deal_Payment_Terms
				(Syn_Deal_Code, Payment_Terms_Code, Days_After, Percentage, Due_Date, Cost_Type_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
			SELECT @Syn_Deal_Code, Payment_Terms_Code, Days_After, Percentage, Due_Date, Cost_Type_Code, Inserted_On, Inserted_By, GETDATE(), @User_Code
				FROM AT_Syn_Deal_Payment_Terms WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code
			
			
			/********************************  Delete from Syn_Deal_Attachment *********************************************************/
			DELETE FROM Syn_Deal_Attachment WHERE Syn_Deal_Code = @Syn_Deal_Code
			
			/********************************  Insert into AT_Syn_Deal_Attachment *********************************************************/
			INSERT INTO Syn_Deal_Attachment 
				(Syn_Deal_Code, Title_Code,Episode_From,Episode_To, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code)
			SELECT @Syn_Deal_Code, Title_Code,Episode_From,Episode_To, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code
				FROM AT_Syn_Deal_Attachment WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code
			
			
			/********************************  Delete from Syn_Deal_Material *********************************************************/
			DELETE FROM Syn_Deal_Material WHERE Syn_Deal_Code = @Syn_Deal_Code
			
			/********************************  Insert into Syn_Deal_Material *********************************************************/
			INSERT INTO Syn_Deal_Material (
				Syn_Deal_Code, Title_Code,Episode_From,Episode_To,
				Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By)
			SELECT @Syn_Deal_Code, Title_Code,Episode_From,Episode_To, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, GETDATE(), @User_Code
				FROM AT_Syn_Deal_Material WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code				
		
			/********************************Call Procedure  USP_Syn_Acq_Mapping********************************/
				CREATE TABLE #Temp(Result VARCHAR(10))
				INSERT INTO #Temp
				EXEC USP_Syn_Acq_Mapping @Syn_Deal_Code,'N'
				DROP TABLE #Temp
			/************************************************************************************************/
		COMMIT

	SELECT 'S' Flag, 'Success' Msg
		UPDATE
			DP
		SET 
			DP.Record_Status = 'D',
			DP.Porcess_End = GETDATE(),
			DP.Version_No = SD.Version
		FROM
			Syn_Deal AS SD INNER JOIN Deal_Process AS DP ON SD.Syn_Deal_Code = DP.Deal_Code
		WHERE 
			DP.Deal_Code = @Syn_Deal_Code AND DP.Record_Status  = 'W' AND DP.Module_Code = 35
		
	END TRY
	BEGIN CATCH
	
		ROLLBACK
		SELECT 'E' Flag, ERROR_MESSAGE() as Msg
		UPDATE Deal_Process Set Record_Status  = 'E', Porcess_End = GETDATE(), Error_Messages = ERROR_MESSAGE() WHERE Deal_Code = @Syn_Deal_Code And Record_Status  = 'W' AND Module_Code = 35
		INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
		SELECT GETDATE(),null,null,'USP_RollBack_Syn_Deal','Syn_Deal_Code : '+CAST(@Syn_Deal_Code AS VARCHAR)+' '+'in error state','NA',ERROR_MESSAGE(),'DB' 
		FROM Deal_Process Where Deal_Code = @Syn_Deal_Code And Record_Status  = 'W'  AND Module_Code = 35
		
		DECLARE  @sql NVARCHAR(MAX), @DB_Name VARCHAR(1000);
		SELECT @sql = CAST(@Syn_Deal_Code AS VARCHAR) +' '+'Records are in pending state for SynDeal' +' '+ ERROR_MESSAGE()
		SELECT @DB_Name = DB_NAME()
		EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_RollBack_Syn_Deal','AN','VN',@sql ,'DB','IP','FR','TI'
	END CATCH

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
END