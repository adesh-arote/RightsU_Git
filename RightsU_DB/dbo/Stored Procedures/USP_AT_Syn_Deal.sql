
CREATE PROCEDURE [dbo].[USP_AT_Syn_Deal]
	@Syn_Deal_Code INT, @Is_Error Varchar(1) Output
AS
-- =============================================
-- Author:		Khan Faisal
-- Create date: 07 Oct, 2014
-- Description:	Archieve a syndication deal
/*
	exec [USP_AT_Syn_Deal] 0
*/
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_AT_Syn_Deal]', 'Step 1', 0, 'Started Procedure', 0, ''
		
		SET NOCOUNT ON;
		BEGIN TRY
		--BEGIN TRANSACTION;
			
				/********************************  Insert into Syn Avail Table******************************************/					
				--IF((SELECT COUNT(Record_Code) FROM Module_Status_History WHERE Record_Code = @Syn_Deal_Code AND Module_Code = 35  AND [Status] = 'AM') > 0)
				--BEGIN
				--	--EXEC [dbo].[USP_Avail_Syn_Cache]  @Syn_Deal_Code ,'Y'
				--	INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend)
				--	VALUES(@Syn_Deal_Code, 'S', 'P', GETDATE(), 'Y')
				--END
				--ELSE	
				--BEGIN
				--	--EXEC [dbo].[USP_Avail_Syn_Cache] @Syn_Deal_Code,'N'
				--	INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend)
				--	VALUES(@Syn_Deal_Code, 'S', 'P', GETDATE(), 'N')
				--END

				/********************************  Insert into Syn_Rights_Title_Eps**************************************/					
				--EXEC USP_Generate_Syn_Rights_Title_Eps @Syn_Deal_Code			
			
				/********************************  Insert into AT_Syn_Deal **********************************************/
				INSERT INTO AT_Syn_Deal (
					Syn_Deal_Code, Deal_Type_Code, Other_Deal, Agreement_No, Version, Agreement_Date, Deal_Description, Status, Total_Sale, Year_Type, 
					Customer_Type, Vendor_Code, Vendor_Contact_Code, Sales_Agent_Code, Sales_Agent_Contact_Code, Entity_Code, Currency_Code, Exchange_Rate, 
					Ref_No, Attach_Workflow, Deal_Workflow_Status, Work_Flow_Code, Is_Completed, Category_Code, Parent_AT_Syn_Deal_Code, Is_Migrated, 
					Payment_Terms_Conditions, Deal_Tag_Code, Ref_BMS_Code, Remarks, Rights_Remarks, Payment_Remarks, 
					Is_Active, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By, Business_Unit_Code, Deal_Complete_Flag, Deal_Segment_Code, Revenue_Vertical_Code, Material_Remarks )
				SELECT 
					Syn_Deal_Code, Deal_Type_Code, Other_Deal, Agreement_No, Version, Agreement_Date, Deal_Description, Status, Total_Sale, Year_Type, 
					Customer_Type, Vendor_Code, Vendor_Contact_Code, Sales_Agent_Code, Sales_Agent_Contact_Code, Entity_Code, Currency_Code, Exchange_Rate, 
					Ref_No, Attach_Workflow, Deal_Workflow_Status, Work_Flow_Code, Is_Completed, Category_Code, Parent_Syn_Deal_Code, Is_Migrated, 
					Payment_Terms_Conditions, Deal_Tag_Code, Ref_BMS_Code, Remarks, Rights_Remarks, Payment_Remarks, 
					Is_Active, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By, Business_Unit_Code, Deal_Complete_Flag, Deal_Segment_Code, Revenue_Vertical_Code, Material_Remarks
				FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Syn_Deal_Code
			
				/********************************  Holding identity of AT_Syn_Deal **************************************/
				DECLARE @CurrIdent_AT_Syn_Deal INT
				SET @CurrIdent_AT_Syn_Deal = 0
				SELECT @CurrIdent_AT_Syn_Deal = IDENT_CURRENT('AT_Syn_Deal')
			
				/********************************  Insert into AT_Syn_Deal_Movie ****************************************/
				INSERT INTO AT_Syn_Deal_Movie(
					AT_Syn_Deal_Code,Syn_Deal_Movie_Code, Title_Code, No_Of_Episode,Episode_From,Episode_End_To,
					Is_Closed, Syn_Title_Type, Remark)
				SELECT 
					@CurrIdent_AT_Syn_Deal,Syn_Deal_Movie_Code, Title_Code, No_Of_Episode,Episode_From,Episode_End_To,
					Is_Closed, Syn_Title_Type, Remark
				FROM Syn_Deal_Movie (NOLOCK) 
				WHERE Syn_Deal_Code = @Syn_Deal_Code			
				print 'Right Start'
				/********************************  Insert into AT_Syn_Deal_Rights ***************************************/
				INSERT INTO AT_Syn_Deal_Rights(
					AT_Syn_Deal_Code,Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
					Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
					Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
					Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By,Is_Pushback,ROFR_Code, CoExclusive_Remarks)
				SELECT 
					@CurrIdent_AT_Syn_Deal, Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
					Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
					Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
					Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, ISNULL(Is_Pushback,'N'), ROFR_Code, CoExclusive_Remarks
				From Syn_Deal_Rights (NOLOCK)
				WHERE Syn_Deal_Code = @Syn_Deal_Code


						
				/**************** Insert into AT_Syn_Deal_Rights_Title ****************/
			--	Select * from AT_Syn_Deal_Rights ASDR WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
			 
				print 'Right Title'
				INSERT INTO AT_Syn_Deal_Rights_Title (
					AT_Syn_Deal_Rights_Code,Syn_Deal_Rights_Title_Code, Title_Code, Episode_From, Episode_To)				
				SELECT 
					ASDR.AT_Syn_Deal_Rights_Code,SDRT.Syn_Deal_Rights_Title_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To
				FROM Syn_Deal_Rights_Title SDRT (NOLOCK)
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRT.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
							
				--/**************** Insert into AT_Syn_Deal_Rights_Title_Eps ****************/ 
				--print ' Right Title EPS'
				INSERT INTO AT_Syn_Deal_Rights_Title_Eps (
				AT_Syn_Deal_Rights_Title_Code,Syn_Deal_Rights_Title_EPS_Code, EPS_No)
				SELECT
					ASDRT.Syn_Deal_Rights_Title_Code,SDRTE.Syn_Deal_Rights_Title_EPS_Code, SDRTE.EPS_No
				FROM Syn_Deal_Rights_Title_EPS SDRTE (NOLOCK)			
				INNER JOIN 	AT_Syn_Deal_Rights_Title ASDRT (NOLOCK) ON SDRTE.Syn_Deal_Rights_Title_Code = ASDRT.Syn_Deal_Rights_Title_Code
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.Syn_Deal_Rights_Code=ASDRT.AT_Syn_Deal_Rights_Code 
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
						
				--/**************** Insert into AT_Syn_Deal_Rights_Platform ****************/ 
				--print ' Right PLatform'
				INSERT INTO AT_Syn_Deal_Rights_Platform (
					AT_Syn_Deal_Rights_Code,Syn_Deal_Rights_Platform_Code, Platform_Code)	
				SELECT 
					ASDR.AT_Syn_Deal_Rights_Code,SDRP.Syn_Deal_Rights_Code, SDRP.Platform_Code
				FROM Syn_Deal_Rights_Platform SDRP (NOLOCK)
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRP.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
			
				------------------Check and Do Mass Territory Update-------------------------
			
				DECLARE @Syn_Deal_Rights_Code INT = 0,@Territory_Code INT = 0
			
				DECLARE rights_Territory_Cursor CURSOR FOR
				Select distinct sdr.Syn_Deal_Rights_Code,sdrt.Territory_Code from Syn_Deal_Rights sdr (NOLOCK)
				INNER JOIN Syn_Deal_Rights_Territory sdrt (NOLOCK) ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				Where sdrt.Territory_Type = 'G' AND sdr.Syn_Deal_Code = @Syn_Deal_Code
			
				OPEN rights_Territory_Cursor

				FETCH NEXT FROM rights_Territory_Cursor INTO @Syn_Deal_Rights_Code,@Territory_Code

				WHILE @@FETCH_STATUS = 0
				BEGIN
				
				
						INSERT INTO Syn_Deal_Rights_Territory(Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
						Select @Syn_Deal_Rights_Code,'G', Country_Code,Territory_Code 
						FROM Territory_Details (NOLOCK) where Territory_Code = @Territory_Code AND Country_Code not in 
						(Select Country_Code from Syn_Deal_Rights_Territory (NOLOCK)
						Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and Territory_Code = @Territory_Code)
				
					FETCH NEXT FROM rights_Territory_Cursor INTO @Syn_Deal_Rights_Code,@Territory_Code
				END

				CLOSE rights_Territory_Cursor;
				DEALLOCATE rights_Territory_Cursor;
						
				--/**************** Insert into AT_Syn_Deal_Rights_Territory ****************/
				--print ' Right Territory'
				INSERT INTO AT_Syn_Deal_Rights_Territory (AT_Syn_Deal_Rights_Code,Syn_Deal_Rights_Territory_Code, Territory_Code, Territory_Type, Country_Code)	
				SELECT 
					ASDR.AT_Syn_Deal_Rights_Code,SDRT.Syn_Deal_Rights_Territory_Code, SDRT.Territory_Code, SDRT .Territory_Type, SDRT.Country_Code
				FROM Syn_Deal_Rights_Territory SDRT (NOLOCK)
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRT.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal

				/**************** Insert into AT_Syn_Deal_Rights_Subtitling ****************/
				print ' Right Subtitling'
				INSERT INTO AT_Syn_Deal_Rights_Subtitling (
					AT_Syn_Deal_Rights_Code,Syn_Deal_Rights_Subtitling_Code, Language_Code, Language_Group_Code, Language_Type)	
				SELECT 
					ASDR.AT_Syn_Deal_Rights_Code,SDRS.Syn_Deal_Rights_Subtitling_Code, SDRS.Language_Code, SDRS.Language_Group_Code, SDRS.Language_Type
				FROM Syn_Deal_Rights_Subtitling SDRS (NOLOCK)			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRS.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
						
				/**************** Insert into AT_Syn_Deal_Rights_Dubbing ****************/
				print ' Right Dubbing '
				INSERT INTO AT_Syn_Deal_Rights_Dubbing (AT_Syn_Deal_Rights_Code,Syn_Deal_Rights_Dubbing_Code, Language_Code, Language_Group_Code, Language_Type)	
				SELECT 
					ASDR.AT_Syn_Deal_Rights_Code,SDRD.Syn_Deal_Rights_Dubbing_Code, SDRD.Language_Code, SDRD.Language_Group_Code, SDRD.Language_Type
				FROM Syn_Deal_Rights_Dubbing SDRD (NOLOCK)	
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRD.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
						
				/**************** Insert into AT_Syn_Deal_Rights_Holdback ****************/
				print ' Right Holdback '
				INSERT INTO AT_Syn_Deal_Rights_Holdback (
					AT_Syn_Deal_Rights_Code, Syn_Deal_Rights_Holdback_Code,
					Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
					Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Original_Language)
				SELECT 
					ASDR.AT_Syn_Deal_Rights_Code,SDRH.Syn_Deal_Rights_Holdback_Code, 
					SDRH.Holdback_Type, SDRH.HB_Run_After_Release_No, SDRH.HB_Run_After_Release_Units, 
					SDRH.Holdback_On_Platform_Code, SDRH .Holdback_Release_Date, SDRH.Holdback_Comment, SDRH.Is_Original_Language
				FROM Syn_Deal_Rights_Holdback SDRH (NOLOCK)
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRH.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal			
						
				/******** Insert into AT_Syn_Deal_Rights_Holdback_Platform ********/
				print ' Right Holdback Platform'
				INSERT INTO AT_Syn_Deal_Rights_Holdback_Platform (
						AT_Syn_Deal_Rights_Holdback_Code,Syn_Deal_Rights_Holdback_Platform_Code, Platform_Code)
				SELECT
					ASDRH.AT_Syn_Deal_Rights_Holdback_Code,SDRHP.Syn_Deal_Rights_Holdback_Platform_Code, SDRHP.Platform_Code
				FROM Syn_Deal_Rights_Holdback_Platform SDRHP (NOLOCK) 
				INNER JOIN AT_Syn_Deal_Rights_Holdback ASDRH (NOLOCK) ON ASDRH.Syn_Deal_Rights_Holdback_Code=SDRHP.Syn_Deal_Rights_Holdback_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRH.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	
						
				/******** Insert into AT_Syn_Deal_Rights_Holdback_Dubbing ********/
				print ' Right Holdback Dubbing'
				INSERT INTO AT_Syn_Deal_Rights_Holdback_Dubbing (
					AT_Syn_Deal_Rights_Holdback_Code,Syn_Deal_Rights_Holdback_Dubbing_Code, Language_Code)
				SELECT
					ASDRH.AT_Syn_Deal_Rights_Holdback_Code,SDRHD.Syn_Deal_Rights_Holdback_Dubbing_Code, SDRHD.Language_Code
				FROM Syn_Deal_Rights_Holdback_Dubbing SDRHD (NOLOCK)			
				INNER JOIN AT_Syn_Deal_Rights_Holdback ASDRH (NOLOCK) ON ASDRH.Syn_Deal_Rights_Holdback_Code=SDRHD.Syn_Deal_Rights_Holdback_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRH.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	
							
				/******** Insert into AT_Syn_Deal_Rights_Holdback_Subtitling ********/
				print ' Right Holdback SubTitle'
				INSERT INTO AT_Syn_Deal_Rights_Holdback_Subtitling (
					AT_Syn_Deal_Rights_Holdback_Code,Syn_Deal_Rights_Holdback_Subtitling_Code, Language_Code)
				SELECT
					ASDRH.AT_Syn_Deal_Rights_Holdback_Code,SDRHS.Syn_Deal_Rights_Holdback_Subtitling_Code, SDRHS.Language_Code
				FROM Syn_Deal_Rights_Holdback_Subtitling SDRHS (NOLOCK)		
				INNER JOIN AT_Syn_Deal_Rights_Holdback ASDRH (NOLOCK) ON ASDRH.Syn_Deal_Rights_Holdback_Code=SDRHS.Syn_Deal_Rights_Holdback_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRH.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal		
							
				/******** Insert into AT_Syn_Deal_Rights_Holdback_Territory ********/
				print ' Right Holdback Territory'
				INSERT INTO AT_Syn_Deal_Rights_Holdback_Territory (
					AT_Syn_Deal_Rights_Holdback_Code,Syn_Deal_Rights_Holdback_Territory_Code, Territory_Type, Country_Code, Territory_Code)
				SELECT
					ASDRH.AT_Syn_Deal_Rights_Holdback_Code,SDRHT.Syn_Deal_Rights_Holdback_Territory_Code, Territory_Type, Country_Code, Territory_Code
				FROM Syn_Deal_Rights_Holdback_Territory SDRHT (NOLOCK) 
				INNER JOIN AT_Syn_Deal_Rights_Holdback ASDRH (NOLOCK) ON ASDRH.Syn_Deal_Rights_Holdback_Code=SDRHT.Syn_Deal_Rights_Holdback_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRH.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal								
						
				/**************** Insert into AT_Syn_Deal_Rights_Blackout ****************/
				print ' Right Blackout'
				INSERT INTO AT_Syn_Deal_Rights_Blackout (
					AT_Syn_Deal_Rights_Code, Syn_Deal_Rights_Blackout_Code,
					[Start_Date], End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
				SELECT
					ASDR.AT_Syn_Deal_Rights_Code,SDRB.Syn_Deal_Rights_Blackout_Code, 
					SDRB.[Start_Date], SDRB.End_Date, SDRB.Inserted_By, SDRB.Inserted_On, SDRB.Last_Updated_Time, SDRB.Last_Action_By
				FROM Syn_Deal_Rights_Blackout SDRB (NOLOCK)			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON SDRB.Syn_Deal_Rights_Code=ASDR.Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal							
						
				/******** Insert into AT_Syn_Deal_Rights_Blackout_Platform ********/
				print ' Right Blackout Platform '
				INSERT INTO AT_Syn_Deal_Rights_Blackout_Platform (
					AT_Syn_Deal_Rights_Blackout_Code,Syn_Deal_Rights_Blackout_Platform_Code, Platform_Code)
				SELECT
					ASDRB.AT_Syn_Deal_Rights_Blackout_Code,SDRBP.Syn_Deal_Rights_Blackout_Platform_Code, SDRBP.Platform_Code
				FROM Syn_Deal_Rights_Blackout_Platform SDRBP (NOLOCK)
				INNER JOIN AT_Syn_Deal_Rights_BlackOut ASDRB (NOLOCK) ON ASDRB.Syn_Deal_Rights_BlackOut_Code=SDRBP.Syn_Deal_Rights_BlackOut_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRB.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal														
							
				/******** Insert into AT_Syn_Deal_Rights_Blackout_Dubbing ********/			
				print ' Right Blackout Dubbing '
				INSERT INTO AT_Syn_Deal_Rights_Blackout_Dubbing (
						AT_Syn_Deal_Rights_Blackout_Code,Syn_Deal_Rights_Blackout_Dubbing_Code, Language_Code)
				SELECT
					ASDRB.AT_Syn_Deal_Rights_Blackout_Code,SDRBD.Syn_Deal_Rights_Blackout_Dubbing_Code, SDRBD .Language_Code
				FROM Syn_Deal_Rights_Blackout_Dubbing SDRBD  (NOLOCK)
				INNER JOIN AT_Syn_Deal_Rights_BlackOut ASDRB (NOLOCK) ON ASDRB.Syn_Deal_Rights_BlackOut_Code=SDRBD.Syn_Deal_Rights_BlackOut_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRB.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal																				
						
				/******** Insert into AT_Syn_Deal_Rights_Blackout_Subtitling ********/			
				print ' Right Blackout SubTitle '
				INSERT INTO AT_Syn_Deal_Rights_Blackout_Subtitling(
					AT_Syn_Deal_Rights_Blackout_Code,Syn_Deal_Rights_Blackout_Subtitling_Code, Language_Code)
				SELECT
					ASDRB.AT_Syn_Deal_Rights_Blackout_Code,SDRBS.Syn_Deal_Rights_Blackout_Subtitling_Code, SDRBS.Language_Code
				FROM Syn_Deal_Rights_Blackout_Subtitling SDRBS (NOLOCK) 			
				INNER JOIN AT_Syn_Deal_Rights_BlackOut ASDRB (NOLOCK) ON ASDRB.Syn_Deal_Rights_BlackOut_Code=SDRBS.Syn_Deal_Rights_BlackOut_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRB.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal			
			
				/******** Insert into AT_Syn_Deal_Rights_Blackout_Territory ********/			
				print ' Right Blackout Territory'
				INSERT INTO AT_Syn_Deal_Rights_Blackout_Territory(
						AT_Syn_Deal_Rights_Blackout_Code,Syn_Deal_Rights_Blackout_Territory_Code, Country_Code, Territory_Code, Territory_Type)
				SELECT
					ASDRB.AT_Syn_Deal_Rights_Blackout_Code,SDRBT.Syn_Deal_Rights_Blackout_Territory_Code, SDRBT.Country_Code, SDRBT.Territory_Code, SDRBT.Territory_Type
				FROM Syn_Deal_Rights_Blackout_Territory SDRBT (NOLOCK)			
				INNER JOIN AT_Syn_Deal_Rights_BlackOut ASDRB (NOLOCK) ON ASDRB.Syn_Deal_Rights_BlackOut_Code=SDRBT.Syn_Deal_Rights_BlackOut_Code			
				INNER JOIN AT_Syn_Deal_Rights ASDR (NOLOCK) ON ASDR.AT_Syn_Deal_Rights_Code=ASDRB.AT_Syn_Deal_Rights_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal			
			
				/*********** END Right Section **************************************/			
			
				/**********************Insert into AT_Syn_Deal_Ancillary **********/
				print 'Ancillary'
				INSERT INTO AT_Syn_Deal_Ancillary (
						AT_Syn_Deal_Code,Syn_Deal_Ancillary_Code, Ancillary_Type_code, Duration, [Day], Remarks, Group_No)
				SELECT 
					@CurrIdent_AT_Syn_Deal,Syn_Deal_Ancillary_Code, Ancillary_Type_code, Duration, [Day], Remarks, Group_No 
				FROM Syn_Deal_Ancillary SDA	(NOLOCK)		
				WHERE Syn_Deal_Code = @Syn_Deal_Code	
				
				/**************** Insert into AT_Syn_Deal_Ancillary_Title ****************/
				print 'Ancillary Title'
				INSERT INTO AT_Syn_Deal_Ancillary_Title (
						AT_Syn_Deal_Ancillary_Code,Syn_Deal_Ancillary_Title_Code, Title_Code, Episode_From, Episode_To)
				SELECT 
					ASDA.AT_Syn_Deal_Ancillary_Code,SDAT.Syn_Deal_Ancillary_Title_Code,
					SDAT.Title_Code, SDAT.Episode_From, SDAT.Episode_To
				FROM Syn_Deal_Ancillary_Title  SDAT (NOLOCK)
				INNER JOIN AT_Syn_Deal_Ancillary ASDA (NOLOCK) ON SDAT.Syn_Deal_Ancillary_Code=ASDA.Syn_Deal_Ancillary_Code
				WHERE ASDA.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
				
				/**************** Insert into AT_Syn_Deal_Ancillary_Platform ****************/			
				print 'Ancillary Platform'
				INSERT INTO AT_Syn_Deal_Ancillary_Platform (
					AT_Syn_Deal_Ancillary_Code,Syn_Deal_Ancillary_Platform_Code, Ancillary_Platform_code)
				SELECT 
					ASDA.AT_Syn_Deal_Ancillary_Code,SDAP.Syn_Deal_Ancillary_Platform_Code,SDAP.Ancillary_Platform_code
				FROM Syn_Deal_Ancillary_Platform SDAP (NOLOCK)
				INNER JOIN AT_Syn_Deal_Ancillary ASDA (NOLOCK) ON SDAP.Syn_Deal_Ancillary_Code=ASDA.Syn_Deal_Ancillary_Code
				WHERE ASDA.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal

				/******** Insert into AT_Syn_Deal_Ancillary_Platform_Medium ********/
				print 'Ancillary Platform Medium'
				INSERT INTO AT_Syn_Deal_Ancillary_Platform_Medium(
					AT_Syn_Deal_Ancillary_Platform_Code,Syn_Deal_Ancillary_Platform_Medium_Code, Ancillary_Platform_Medium_Code)
				SELECT 
					ASDAP.AT_Syn_Deal_Ancillary_Platform_Code,SDAPM.Syn_Deal_Ancillary_Platform_Medium_Code, SDAPM.Ancillary_Platform_Medium_Code
				FROM Syn_Deal_Ancillary_Platform_Medium SDAPM (NOLOCK)
				INNER JOIN AT_Syn_Deal_Ancillary_Platform ASDAP (NOLOCK) ON  SDAPM.Syn_Deal_Ancillary_Platform_Code=ASDAP.Syn_Deal_Ancillary_Platform_Code
				INNER JOIN AT_Syn_Deal_Ancillary ASDA (NOLOCK) ON ASDA.AT_Syn_Deal_Ancillary_Code=ASDAP.AT_Syn_Deal_Ancillary_Code
				WHERE ASDA.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	

			
				/******************************** Insert into AT_Syn_Deal_Supplementary *****************************************/ 
				INSERT INTO AT_Syn_Deal_Supplementary (AT_Syn_Deal_Code, Title_code, Episode_From, Episode_To, Remarks, Syn_Deal_Supplementary_Code)
				SELECT @CurrIdent_AT_Syn_Deal, Title_code, Episode_From, Episode_To, Remarks, Syn_Deal_Supplementary_Code
				FROM Syn_Deal_Supplementary (NOLOCK) WHERE Syn_Deal_Code = @Syn_Deal_Code
			
				/******************************** Insert into AT_Syn_Deal_Supplementary_Details *****************************************/ 

				INSERT INTO AT_Syn_Deal_Supplementary_Detail (AT_Syn_Deal_Supplementary_Code, Supplementary_Tab_Code, Supplementary_Config_Code, 
					Supplementary_Data_Code, User_Value, Row_Num, Syn_Deal_Supplementary_Detail_Code)
				SELECT AtADA.AT_Syn_Deal_Supplementary_Code, ADAP.Supplementary_Tab_Code, ADAP.Supplementary_Config_Code, 
					ADAP.Supplementary_Data_Code, ADAP.User_Value, ADAP.Row_Num, ADAP.Syn_Deal_Supplementary_Detail_Code
				FROM Syn_Deal_Supplementary ADA (NOLOCK)
					INNER JOIN Syn_Deal_Supplementary_Detail ADAP (NOLOCK) ON ADAP.Syn_Deal_Supplementary_Code = ADA.Syn_Deal_Supplementary_Code AND ADA.Syn_Deal_Code = @Syn_Deal_Code
					INNER JOIN AT_Syn_Deal_Supplementary AtADA (NOLOCK) ON AtADA.AT_Syn_Deal_Code = @CurrIdent_AT_Syn_Deal AND AtADA.Syn_Deal_Supplementary_Code = ADA.Syn_Deal_Supplementary_Code

				/******************************** Insert into AT_Syn_Deal_Run *****************************************/ 

				INSERT INTO AT_Syn_Deal_Run(
					AT_Syn_Deal_Code, Run_Type,Title_Code,Episode_From,Episode_To, No_Of_Runs,Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
					Repeat_Within_Days_Hrs, No_Of_Days_Hrs,Syn_Deal_Run_Code,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time)
				SELECT @CurrIdent_AT_Syn_Deal, Run_Type,Title_Code,Episode_From,Episode_To, No_Of_Runs, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
					Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Syn_Deal_Run_Code,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
				FROM Syn_Deal_Run WHERE Syn_Deal_Code = @Syn_Deal_Code
			
				/******************************** Insert into AT_Syn_Deal_Run_Repeat_On_Day *****************************************/ 

				INSERT INTO AT_Syn_Deal_Run_Repeat_On_Day (AT_Syn_Deal_Run_Code, Day_Code, Syn_Deal_Run_Repeat_On_Day_Code)
				SELECT AtADR.AT_Syn_Deal_Run_Code, ADRRD.Day_Code , ADRRD.Syn_Deal_Run_Repeat_On_Day_Code
				FROM Syn_Deal_Run ADR (NOLOCK)
					INNER JOIN Syn_Deal_Run_Repeat_On_Day ADRRD (NOLOCK) ON ADRRD.Syn_Deal_Run_Code = ADR.Syn_Deal_Run_Code AND ADR.Syn_Deal_Code = @Syn_Deal_Code
					INNER JOIN AT_Syn_Deal_Run AtADR (NOLOCK) ON AtADR.AT_Syn_Deal_Code = @CurrIdent_AT_Syn_Deal AND AtADR.Syn_Deal_Run_Code = ADR.Syn_Deal_Run_Code

				/******************************** Insert into AT_Syn_Deal_Run_Yearwise_Run *****************************************/ 

				INSERT INTO AT_Syn_Deal_Run_Yearwise_Run ( 
					AT_Syn_Deal_Run_Code, Start_Date, End_Date, No_Of_Runs, Year_No,Syn_Deal_Run_Yearwise_Run_Code)
				SELECT 
					AtADR.AT_Syn_Deal_Run_Code, ADRYR.Start_Date, ADRYR.End_Date, ADRYR.No_Of_Runs, ADRYR.Year_No,ADRYR.Syn_Deal_Run_Yearwise_Run_Code
				FROM Syn_Deal_Run ADR (NOLOCK)
					INNER JOIN Syn_Deal_Run_Yearwise_Run ADRYR (NOLOCK) ON ADRYR.Syn_Deal_Run_Code = ADR.Syn_Deal_Run_Code AND ADR.Syn_Deal_Code = @Syn_Deal_Code
					INNER JOIN AT_Syn_Deal_Run AtADR (NOLOCK) ON AtADR.AT_Syn_Deal_Code = @CurrIdent_AT_Syn_Deal AND AtADR.Syn_Deal_Run_Code = ADR.Syn_Deal_Run_Code

				/**************** Insert into AT_Syn_Deal_Run_Platform ****************/
				INSERT INTO AT_Syn_Deal_Run_Platform (
					AT_Syn_Deal_Run_Code,Platform_Code, Syn_Deal_Run_Platform_Code)
				SELECT 
					ASDA.AT_Syn_Deal_Run_Code,SDAP.Platform_Code,SDAP.Syn_Deal_Run_Platform_Code
				FROM Syn_Deal_Run_Platform SDAP (NOLOCK)
				INNER JOIN AT_Syn_Deal_Run ASDA (NOLOCK) ON SDAP.Syn_Deal_Run_Code=ASDA.Syn_Deal_Run_Code
				WHERE ASDA.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
			
			
			
				/********************************  Insert into AT_Syn_Deal_Revenue ********************/
				print 'Revenue'
				INSERT INTO AT_Syn_Deal_Revenue(
						AT_Syn_Deal_Code,Syn_Deal_Revenue_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost, 
						Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
				SELECT 
					@CurrIdent_AT_Syn_Deal,Syn_Deal_Revenue_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost, 
					Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By
				FROM Syn_Deal_Revenue (NOLOCK)
				WHERE Syn_Deal_Code=@Syn_Deal_Code

				/**************** Insert into AT_Syn_Deal_Revenue_Title ****************/			
				print 'Revenue Title'
				INSERT INTO AT_Syn_Deal_Revenue_Title (
					AT_Syn_Deal_Revenue_Code,Syn_Deal_Revenue_Title_Code,Title_Code, Episode_From, Episode_To)
				SELECT 
					ASDR.AT_Syn_Deal_Revenue_Code,SDCT.Syn_Deal_Revenue_Title_Code, SDCT.Title_Code, SDCT.Episode_From, SDCT.Episode_To
				FROM Syn_Deal_Revenue_Title SDCT (NOLOCK) 
				INNER JOIN AT_Syn_Deal_Revenue ASDR (NOLOCK) ON SDCT.Syn_Deal_Revenue_Code=ASDR.Syn_Deal_Revenue_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
				
				/**************** Insert into AT_Syn_Deal_Revenue_Additional_Exp ****************/
				print 'Revenue Additional Exp'
				INSERT INTO AT_Syn_Deal_Revenue_Additional_Exp (
						AT_Syn_Deal_Revenue_Code,Syn_Deal_Revenue_Additional_Exp_Code , Additional_Expense_Code, Amount, Min_Max, 
						Inserted_On, Inserted_By,Last_Updated_Time, Last_Action_By)
					SELECT 
						ASDR.AT_Syn_Deal_Revenue_Code,SDCAE.Syn_Deal_Revenue_Additional_Exp_Code, SDCAE.Additional_Expense_Code, SDCAE.Amount, SDCAE.Min_Max, 
						SDCAE.Inserted_On, SDCAE.Inserted_By, SDCAE.Last_Updated_Time, SDCAE.Last_Action_By
					FROM Syn_Deal_Revenue_Additional_Exp SDCAE (NOLOCK)
					INNER JOIN AT_Syn_Deal_Revenue ASDR (NOLOCK) ON SDCAE.Syn_Deal_Revenue_Code=ASDR.Syn_Deal_Revenue_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal
				
				/**************** Insert into AT_Syn_Deal_Revenue_Commission ****************/
				print 'Revenue Commission '
				INSERT INTO AT_Syn_Deal_Revenue_Commission (
					AT_Syn_Deal_Revenue_Code,Syn_Deal_Revenue_Commission_Code , Cost_Type_Code, Royalty_Commission_Code, Entity_Code,
					Vendor_Code, Type, Commission_Type, Percentage, Amount)
				SELECT 
					ASDR.AT_Syn_Deal_Revenue_Code,SDCC.Syn_Deal_Revenue_Commission_Code, SDCC.Cost_Type_Code, SDCC.Royalty_Commission_Code, SDCC.Entity_Code,
					SDCC.Vendor_Code, SDCC.[Type], SDCC.Commission_Type, SDCC.Percentage, SDCC.Amount
				FROM Syn_Deal_Revenue_Commission SDCC (NOLOCK)
				INNER JOIN AT_Syn_Deal_Revenue ASDR (NOLOCK) ON SDCC.Syn_Deal_Revenue_Code=ASDR.Syn_Deal_Revenue_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	
			
				/**************** Insert into AT_Syn_Deal_Revenue_Variable_Cost ****************/
				print 'Revenue Variable Cost'
				INSERT INTO AT_Syn_Deal_Revenue_Variable_Cost (
					AT_Syn_Deal_Revenue_Code,Syn_Deal_Revenue_Variable_Cost_Code , Entity_Code, Vendor_Code, Percentage, Amount, 
					Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
				SELECT 
					ASDR.AT_Syn_Deal_Revenue_Code,SDCVC.Syn_Deal_Revenue_Variable_Cost_Code, SDCVC.Entity_Code, SDCVC.Vendor_Code, SDCVC.Percentage, SDCVC.Amount, 
					SDCVC.Inserted_On, SDCVC.Inserted_By, SDCVC.Last_Updated_Time, SDCVC.Last_Action_By
				FROM Syn_Deal_Revenue_Variable_Cost SDCVC (NOLOCK)
				INNER JOIN AT_Syn_Deal_Revenue ASDR (NOLOCK) ON SDCVC.Syn_Deal_Revenue_Code=ASDR.Syn_Deal_Revenue_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	
				
				/**************** Insert into AT_Syn_Deal_Revenue_Costtype ****************/
				print 'Revenue Variable Costtype'
				INSERT INTO AT_Syn_Deal_Revenue_Costtype(AT_Syn_Deal_Revenue_Code,Syn_Deal_Revenue_Costtype_Code, Cost_Type_Code, Amount, Consumed_Amount, 
							Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
				SELECT ASDR.AT_Syn_Deal_Revenue_Code,SDCC.Syn_Deal_Revenue_Costtype_Code, SDCC.Cost_Type_Code, SDCC.Amount, SDCC.Consumed_Amount, 
						SDCC.Inserted_On, SDCC.Inserted_By, SDCC.Last_Updated_Time, SDCC.Last_Action_By
				FROM Syn_Deal_Revenue_Costtype SDCC (NOLOCK)
				INNER JOIN AT_Syn_Deal_Revenue ASDR (NOLOCK) ON SDCC.Syn_Deal_Revenue_Code=ASDR.Syn_Deal_Revenue_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	

				/******** Insert into AT_Syn_Deal_Revenue_Costtype_Episode ********/
				INSERT INTO AT_Syn_Deal_Revenue_Costtype_Episode (
					AT_Syn_Deal_Revenue_Costtype_Code, Episode_From, 
					Episode_To, Amount_Type, Amount, Percentage, Remarks)
				SELECT 
					ASDRCT.AT_Syn_Deal_Revenue_Costtype_Code,SDCCE.Episode_From, 
					SDCCE.Episode_To, SDCCE.Amount_Type, SDCCE.Amount, SDCCE.Percentage, SDCCE.Remarks
				FROM Syn_Deal_Revenue_Costtype_Episode  SDCCE (NOLOCK)		
				INNER JOIN AT_Syn_Deal_Revenue_Costtype ASDRCT (NOLOCK) ON ASDRCT.Syn_Deal_Revenue_Costtype_Code=SDCCE.Syn_Deal_Revenue_Costtype_Code
				INNER JOIN AT_Syn_Deal_Revenue ASDR (NOLOCK) ON ASDRCT.AT_Syn_Deal_Revenue_Code=ASDR.AT_Syn_Deal_Revenue_Code
				WHERE ASDR.AT_Syn_Deal_Code=@CurrIdent_AT_Syn_Deal	

				/********************************  Insert into AT_Syn_Deal_Payment_Terms ***************/
				INSERT INTO AT_Syn_Deal_Payment_Terms(
					AT_Syn_Deal_Code,Syn_Deal_Payment_Terms_Code, Payment_Terms_Code, Days_After, Percentage, Due_Date, Cost_Type_Code,
					Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
				SELECT
					 @CurrIdent_AT_Syn_Deal,Syn_Deal_Payment_Terms_Code, Payment_Terms_Code, Days_After, Percentage, Due_Date, Cost_Type_Code
					 ,Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By
				FROM Syn_Deal_Payment_Terms (NOLOCK)
				WHERE Syn_Deal_Code = @Syn_Deal_Code
			
				/********************************  Insert into AT_Syn_Deal_Attachment *******************/
				INSERT INTO AT_Syn_Deal_Attachment 
					(AT_Syn_Deal_Code,Syn_Deal_Attachment_Code, Title_Code,Episode_From,Episode_To, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code)
				SELECT @CurrIdent_AT_Syn_Deal,Syn_Deal_Attachment_Code, Title_Code,Episode_From,Episode_To, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code
				FROM Syn_Deal_Attachment (NOLOCK)
				WHERE Syn_Deal_Code = @Syn_Deal_Code
			
				/********************************  Insert into AT_Syn_Deal_Material *********************/
				INSERT INTO AT_Syn_Deal_Material (
					AT_Syn_Deal_Code,Syn_Deal_Material_Code ,Title_Code,Episode_From,Episode_To, Material_Medium_Code
				   ,Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By)
				SELECT @CurrIdent_AT_Syn_Deal,Syn_Deal_Material_Code,Title_Code,Episode_From,Episode_To, Material_Medium_Code
					   ,Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By
				FROM Syn_Deal_Material (NOLOCK)
				WHERE Syn_Deal_Code = @Syn_Deal_Code

				/******************************** Insert into AT_Syn_Deal_Digital *****************************************/ 
				INSERT INTO AT_Syn_Deal_Digital(AT_Syn_Deal_Code, Title_code, Episode_From, Episode_To, Remarks, Syn_Deal_Digital_Code)
				SELECT @CurrIdent_AT_Syn_Deal, Title_code, Episode_From, Episode_To, Remarks, Syn_Deal_Digital_Code
				FROM Syn_Deal_Digital (NOLOCK) WHERE Syn_Deal_Code = @Syn_Deal_Code
			
				/******************************** Insert into AT_Syn_Deal_Digital_Details *****************************************/ 

				INSERT INTO AT_Syn_Deal_Digital_Detail (AT_Syn_Deal_Digital_Code, Digital_Tab_Code, Digital_Config_Code, 
					Digital_Data_Code, User_Value, Row_Num, Syn_Deal_Digital_Detail_Code)
				SELECT AtADA.AT_Syn_Deal_Digital_Code, ADAP.Digital_Tab_Code, ADAP.Digital_Config_Code, 
					ADAP.Digital_Data_Code, ADAP.User_Value, ADAP.Row_Num, ADAP.Syn_Deal_Digital_Detail_Code
				FROM Syn_Deal_Digital ADA (NOLOCK)
					INNER JOIN Syn_Deal_Digital_Detail ADAP (NOLOCK) ON ADAP.Syn_Deal_Digital_Code = ADA.Syn_Deal_Digital_Code AND ADA.Syn_Deal_Code = @Syn_Deal_Code
					INNER JOIN AT_Syn_Deal_Digital AtADA (NOLOCK) ON AtADA.AT_Syn_Deal_Code = @CurrIdent_AT_Syn_Deal AND AtADA.Syn_Deal_Digital_Code = ADA.Syn_Deal_Digital_Code
			
			--COMMIT TRANSACTION;		
		END TRY
		BEGIN CATCH			
			--ROLLBACK TRANSACTION;
			SET @Is_Error = 'Y'
			DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
			SELECT    @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();    
			RAISERROR 
			(		
				   @ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
			);
			SELECT @ErrorMessage,@ErrorSeverity
		END CATCH
	
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USP_AT_Syn_Deal]', 'Step 2', 0, 'Procedure Execution Completed ', 0, ''
END