
ALTER PROCEDURE [dbo].[USP_RollBack_Acq_Deal]
	@Acq_Deal_Code INT,  
	@User_Code INT ,
	@Is_Edit_WO_Approval CHAR(1)='N'
AS  
-- =============================================  
-- Author:  Khan Faisal  
-- Create date: 10 Oct, 2014  
-- Description: Will restore Acquisition deal to its last approved state  
-- Rollback BVTransaction Pavitar 20141127  
-- Last update by : Akshay Rane
-- Last Change : Added One column in AT_Acq_Deal_Cost_Costtype_Episode (Per_Eps_Amount)
-- =============================================  
BEGIN  
	SET NOCOUNT ON   
	
	--DECLARE
	--@Acq_Deal_Code INT = 17611,  
	--@User_Code INT = 143,
	--@Is_Edit_WO_Approval CHAR(1)='N'

	DECLARE @Parameter_Name VARCHAR(500)
	SELECT @Parameter_Name=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Edit_WO_Approval_Tabs'

	IF(OBJECT_ID('TEMPDB..#Edit_WO_Approval') IS NOT NULL)
		DROP TABLE #Edit_WO_Approval

	IF(OBJECT_ID('TEMPDB..#TitleContentCodes') IS NOT NULL)
		DROP TABLE #TitleContentCodes

	CREATE TABLE #Edit_WO_Approval(Tab_Name VARCHAR(10))

	INSERT INTO #Edit_WO_Approval(Tab_Name)	
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Parameter_Name,',') WHERE number!=''
 
	BEGIN TRY  
	BEGIN TRAN  
		/******************************** Holding identity of AT_Acq_Deal *****************************************/   
		DECLARE @AT_Acq_Deal_Code INT,@Version_Code INT
		SET @AT_Acq_Deal_Code = 0  
    
		SELECT TOP 1 @AT_Acq_Deal_Code = ISNULL(AT_Acq_Deal_Code, 0) FROM AT_Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY CAST(Version AS INT) DESC
		  
		IF(@Is_Edit_WO_Approval='N')
		BEGIN
		/******************************** UDdate Acq_Deal *****************************************/   
			UPDATE Acq_Deal  
			SET   
			Acq_Deal.Agreement_No = AtAD.Agreement_No,  Acq_Deal.Version = AtAD.Version,  Acq_Deal.Agreement_Date = AtAD.Agreement_Date,   
			Acq_Deal.Deal_Desc = AtAD.Deal_Desc, Acq_Deal.Deal_Type_Code = AtAD.Deal_Type_Code, Acq_Deal.Year_Type = AtAD.Year_Type,   
			Acq_Deal.Entity_Code = AtAD.Entity_Code, Acq_Deal.Is_Master_Deal = AtAD.Is_Master_Deal, Acq_Deal.Category_Code = AtAD.Category_Code,   
			Acq_Deal.Vendor_Code = AtAD.Vendor_Code, Acq_Deal.Vendor_Contacts_Code = AtAD.Vendor_Contacts_Code, Acq_Deal.Currency_Code = AtAD.Currency_Code,   
			Acq_Deal.Exchange_Rate = AtAD.Exchange_Rate, Acq_Deal.Ref_No = AtAD.Ref_No, Acq_Deal.Attach_Workflow = AtAD.Attach_Workflow,   
			Acq_Deal.Deal_Workflow_Status = AtAD.Deal_Workflow_Status, Acq_Deal.Parent_Deal_Code = AtAD.Parent_Deal_Code, Acq_Deal.Work_Flow_Code = AtAD.Work_Flow_Code,   
			Acq_Deal.Amendment_Date = AtAD.Amendment_Date, Acq_Deal.Is_Released = AtAD.Is_Released, Acq_Deal.Release_On = AtAD.Release_On, Acq_Deal.Release_By = AtAD.Release_By,   
			Acq_Deal.Is_Completed = AtAD.Is_Completed, Acq_Deal.Is_Active = AtAD.Is_Active, Acq_Deal.Content_Type = AtAD.Content_Type, Acq_Deal.Payment_Terms_Conditions = AtAD.Payment_Terms_Conditions,   
			Acq_Deal.Status = AtAD.Status, Acq_Deal.Is_Auto_Generated = AtAD.Is_Auto_Generated, Acq_Deal.Is_Migrated = AtAD.Is_Migrated, Acq_Deal.Cost_Center_Id = AtAD.Cost_Center_Id,   
			Acq_Deal.Master_Deal_Movie_Code_ToLink = AtAD.Master_Deal_Movie_Code_ToLink, Acq_Deal.BudgetWise_Costing_Applicable = AtAD.BudgetWise_Costing_Applicable,   
			Acq_Deal.Validate_CostWith_Budget = AtAD.Validate_CostWith_Budget, Acq_Deal.Deal_Tag_Code = AtAD.Deal_Tag_Code,   
			Acq_Deal.Business_Unit_Code = AtAD.Business_Unit_Code, Acq_Deal.Ref_BMS_Code = AtAD.Ref_BMS_Code,   
			Acq_Deal.Remarks = AtAD.Remarks, Acq_Deal.Rights_Remarks = AtAD.Rights_Remarks, Acq_Deal.Payment_Remarks = AtAD.Payment_Remarks,   
			Acq_Deal.Inserted_By = AtAD.Inserted_By, Acq_Deal.Inserted_On = AtAD.Inserted_On, Acq_Deal.Last_Updated_Time = GETDATE(),   
			Acq_Deal.Last_Action_By = @User_Code, Acq_Deal.Lock_Time = NULL,  
			Acq_Deal.All_Channel = AtAD.All_Channel,ACq_Deal.Role_Code = AtAD.Role_Code,  
			Acq_Deal.Channel_Cluster_Code = AtAd.Channel_Cluster_Code,
			Acq_Deal.Is_Auto_Push =  AtAD.Is_Auto_Push
			FROM AT_Acq_Deal AtAD   
			WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code AND Acq_Deal.Acq_Deal_Code = @Acq_Deal_Code  
     
			/******************************** Delete from Acq_Deal_Licensor *****************************************/   
			DELETE ADL FROM Acq_Deal_Licensor ADL WHERE ADL.Acq_Deal_Code = @Acq_Deal_Code  
  
			/******************************** Insert/Update Acq_Deal_Licensor *****************************************/   
			INSERT INTO Acq_Deal_Licensor(Acq_Deal_Code, Vendor_Code)  
			SELECT @Acq_Deal_Code, Vendor_Code  
			FROM AT_Acq_Deal_Licensor WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  

			SELECT DISTINCT TCM2.Title_Content_Code, COUNT(DISTINCT TCM2.Acq_Deal_Movie_Code) AS DealMovieCount INTO #TitleContentCodes FROM Acq_Deal_Movie ADM 
			INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code AND ADM.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Title_Content_Mapping TCM2 ON TCM2.Title_Content_Code = TCM.Title_Content_Code
			GROUP BY TCM2.Title_Content_Code
			
			/* Delete from Title_Content_Mapping */  	   
			DELETE TCM FROM Acq_Deal_Movie ADM 
			INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
			WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code  

			/* Delete from Acq_Deal_Movie */  
			DELETE ADM FROM Acq_Deal_Movie ADM WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code  
        
			/******************************** Insert/Update Acq_Deal_Movie *****************************************/   
     
			Set IDENTITY_INSERT Acq_Deal_Movie On  
  
			INSERT INTO Acq_Deal_Movie(  
			Acq_Deal_Movie_Code, Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Duration_Restriction)  
			SELECT Acq_Deal_Movie_Code, @Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, GETDATE(), @User_Code, Episode_End_To,Duration_Restriction  
			FROM AT_Acq_Deal_Movie WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code And Acq_Deal_Movie_Code Is Not Null  
     
			Set IDENTITY_INSERT Acq_Deal_Movie Off  
  
			INSERT INTO Acq_Deal_Movie(  
			Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To)  
			SELECT @Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, GETDATE(), @User_Code, Episode_End_To  
			FROM AT_Acq_Deal_Movie WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code And Acq_Deal_Movie_Code Is Null  
	

			DECLARE @tblErrorMessage AS TABLE(
				ErrorMessage NVARCHAR(MAX)
			)

			INSERT INTO @tblErrorMessage
			EXEC [dbo].[USP_Generate_Title_Content] @Acq_Deal_Code, '', @User_Code

			DECLARE @errMsg NVARCHAR(MAX) = ''
			SELECT TOP 1 @errMsg = ErrorMessage FROM @tblErrorMessage

			IF(ISNULL(@errMsg, '') <> '')
			BEGIN
				RAISERROR (@errMsg, -- Message text.
					16, -- Severity.
					1 -- State.
				);
			END
			

			DELETE TC FROM #TitleContentCodes TC WHERE DealMovieCount > 1 OR 
			Title_Content_Code IN (
				SELECT TCM.Title_Content_Code FROM Acq_Deal_Movie ADM 
				INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
				WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code 
			)

			DELETE FROM Content_Status_History WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes)
			DELETE FROM Title_Content_Version WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes)
			DELETE FROM Content_Channel_Run WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes) 
			DELETE FROM Title_Content WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes)

			/******************************** Delete from Acq_Deal_Rights *****************************************/   
     
			/* Delete from Acq_Deal_Rights_Title_Eps */  
			DELETE ADRHT FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Title_Eps ADRHT ON ADRHT.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code  
  
			/* Delete from Acq_Deal_Rights_Title */  
			DELETE ADRT FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Title ADRT   
			ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Platform */  
			DELETE ADRP FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Platform ADRP  
			ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
      
			/* Delete from Acq_Deal_Rights_Territory */  
			DELETE ADRT FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Territory ADRT  
			ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Subtitling */   
			DELETE ADRS FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Subtitling ADRS  
			ON ADRS.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Dubbing */   
			DELETE ADRD FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Dubbing ADRD  
			ON ADRD.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Dubbing */  
			DELETE ADRHD FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Dubbing ADRHD ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Platform */  
			DELETE ADRHP FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Subtitling */   
			DELETE ADRHS FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Subtitling ADRHS ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Territory */  
			DELETE ADRHT FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback */  
			DELETE ADRH FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Holdback ADRH  
			ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Dubbing */  
			DELETE ADRBD FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Dubbing ADRBD ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Platform */   
			DELETE ADRBP FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Platform ADRBP ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Subtitling */   
			DELETE ADRBS FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Subtitling ADRBS ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Territory */   
			DELETE ADRBT FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Territory ADRBT ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code     
  
			/* Delete from Acq_Deal_Rights_Blackout */  
			DELETE ADRB FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Blackout ADRB  
			ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  

			
			/* Delete from Acq_Deal_Rights_Promtoer_Group */   
			DELETE ADRPG FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code     
  

  	/* Delete from Acq_Deal_Rights_Promoter_Remarks */   
			DELETE ADRPR FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code  
			   
			   /* Delete from Acq_Deal_Rights_Promoter */  
			   		DELETE ADRP FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Promoter ADRP 
			ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  

				/******************************** Delete from Syn_Acq_Mapping *****************************************/   
				DELETE SAM FROM Syn_Acq_Mapping SAM WHERE SAM.Deal_Code = @Acq_Deal_Code AND SAM.Deal_Rights_Code IN 
				(SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code)  

			/* Delete from Acq_Deal_Rights */  
			DELETE ADR FROM Acq_Deal_Rights ADR WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code    
  
			print '@Acq_Deal_Code = '+ CAST(@Acq_Deal_Code AS VARCHAR(MAX)) +' @AT_Acq_Deal_Code = '+  CAST(@AT_Acq_Deal_Code AS VARCHAR(MAX))
			/******************************** Insert into Acq_Deal_Rights *****************************************/   
			DECLARE @Acq_Deal_Rights_Code INT  
			SET @Acq_Deal_Rights_Code = 0  
  
			DECLARE @AT_Acq_Deal_Rights_Code INT, @Is_Exclusive CHAR(1), @Is_Title_Language_Right CHAR(1), @Is_Sub_License CHAR(1), @Sub_License_Code INT,
			@Is_Theatrical_Right CHAR(1), @Right_Type CHAR(1), @Original_Right_Type CHAR(1), @Is_Tentative CHAR(1), @Term varchar(12), 
			@Right_Start_Date DATETIME, @Right_End_Date DATETIME, @Milestone_Type_Code INT, @Milestone_No_Of_Unit INT, @Milestone_Unit_Type INT, 
			@Is_ROFR CHAR(1), @ROFR_Date DATETIME, @Restriction_Remarks NVARCHAR(4000), @Effective_Start_Date DATETIME,  
			@Actual_Right_Start_Date DATETIME, @Actual_Right_End_Date DATETIME, @Acq_Deal_Rights_Old_Code INT, @Acq_Deal_Rights_New_Code INT, @ROFR_Code INT,
			@Inserted_By INT, @Inserted_On DATETIME, @Last_Updated_Time DATETIME, @Last_Action_By INT ,@Promoter_Flag CHAR(1)
			  
     
			DECLARE rights_cursor CURSOR FOR   
			SELECT AT_Acq_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
			Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
			Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
			Inserted_By, Inserted_On, GETDATE(), @User_Code, Acq_Deal_Rights_Code ,ROFR_Code,Promoter_Flag  
			FROM AT_Acq_Deal_Rights WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
     
			OPEN rights_cursor  
  
			FETCH NEXT FROM rights_cursor   
			INTO @AT_Acq_Deal_Rights_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, @Is_Theatrical_Right, 
			@Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, @Milestone_No_Of_Unit, 
			@Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, @Actual_Right_Start_Date, @Actual_Right_End_Date, 
			@Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, @Acq_Deal_Rights_Old_Code, @ROFR_Code,@Promoter_Flag 
     
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				If(IsNull(@Acq_Deal_Rights_Old_Code, 0) = 0)  
				Begin  
					INSERT INTO Acq_Deal_Rights
					(
						Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, 
						Is_Theatrical_Right, Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, 
						Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, 
						Actual_Right_Start_Date, Actual_Right_End_Date, ROFR_Code, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Is_Verified,Promoter_Flag, Right_Status
					)
					VALUES
					(
						@Acq_Deal_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, 
						@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, 
						@Milestone_Type_Code, @Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
						@Actual_Right_Start_Date, @Actual_Right_End_Date, @ROFR_Code, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 'Y',@Promoter_Flag, 'C'
					)  

					SELECT @Acq_Deal_Rights_Code = IDENT_CURRENT('Acq_Deal_Rights')  
				End  
				Else  
				Begin  
					Set IDENTITY_INSERT [Acq_Deal_Rights] ON  
					INSERT INTO Acq_Deal_Rights
					(
						Acq_Deal_Rights_Code, Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code,   
						Is_Theatrical_Right, Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, 
						Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, 
						Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Is_Verified, ROFR_Code
						,Promoter_Flag
					)  
					VALUES
					(
						@Acq_Deal_Rights_Old_Code, @Acq_Deal_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code,   
						@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, 
						@Milestone_Type_Code, @Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
						@Actual_Right_Start_Date, @Actual_Right_End_Date, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 'Y', @ROFR_Code
						,@Promoter_Flag
					)  

					Set IDENTITY_INSERT [Acq_Deal_Rights] OFF  
					SELECT @Acq_Deal_Rights_Code = @Acq_Deal_Rights_Old_Code  
				End  

				print '@Acq_Deal_Rights_Code = ' +cast( @Acq_Deal_Rights_Code as varchar(max)) + ' @AT_Acq_Deal_Rights_Code = ' +cast( @AT_Acq_Deal_Rights_Code as varchar(max)) + ' @Acq_Deal_Rights_Old_Code = ' +cast( @Acq_Deal_Rights_Old_Code as varchar(max))
				Update AT_Acq_Deal_Rights Set Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
				--Commented by akshay
				--Update Syn_Acq_Mapping Set Deal_Rights_Code = @Acq_Deal_Rights_Code Where Deal_Rights_Code = @Acq_Deal_Rights_Old_Code  

  				/******************************** Insert Syn_Acq_Mapping *****************************************/   
				Set IDENTITY_INSERT [Syn_Acq_Mapping] ON  
				PRINT 'IDENTITY_INSERT [Syn_Acq_Mapping] ON  '
				PRINT '@AT_Acq_Deal_Code = ' + CAST(@AT_Acq_Deal_Code AS NVARCHAR(MAX))


				DELETE FROM  
				 Syn_Acq_Mapping  
				WHERE Syn_Acq_Mapping_Code in ( 	
					SELECT  Syn_Acq_Mapping_Code
					FROM AT_Syn_Acq_Mapping  
					WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code 
					AND Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights WHERE  AT_Acq_Deal_Code = @AT_Acq_Deal_Code )
				)


				INSERT INTO Syn_Acq_Mapping( Syn_Acq_Mapping_Code,  Syn_Deal_Code,  Syn_Deal_Movie_Code,  Syn_Deal_Rights_Code,  Deal_Code,  Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date )
				SELECT  Syn_Acq_Mapping_Code,  Syn_Deal_Code,  Syn_Deal_Movie_Code,  Syn_Deal_Rights_Code,  @Acq_Deal_Code,  Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
				FROM AT_Syn_Acq_Mapping  
				WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code 
				AND Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights WHERE  AT_Acq_Deal_Code = @AT_Acq_Deal_Code )



				PRINT 'IDENTITY_INSERT [Syn_Acq_Mapping] OFF  '
				Set IDENTITY_INSERT [Syn_Acq_Mapping] OFF
				/**************** Insert into Acq_Deal_Rights_Title ****************/   
  
				INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Rights_Code, AtADRT.Title_Code, AtADRT.Episode_From, AtADRT.Episode_To  
				From AT_Acq_Deal_Rights_Title AtADRT WHERE AtADRT.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Title_Eps ****************/   

				INSERT INTO Acq_Deal_Rights_Title_Eps (Acq_Deal_Rights_Title_Code, EPS_No)  
				SELECT ADRT.Acq_Deal_Rights_Title_Code, AtADRTE.EPS_No  
				FROM AT_Acq_Deal_Rights_Title_EPS AtADRTE  
				INNER JOIN AT_Acq_Deal_Rights_Title AtADRT ON AtADRTE.AT_Acq_Deal_Rights_Title_Code = AtADRT.AT_Acq_Deal_Rights_Title_Code  
				INNER JOIN Acq_Deal_Rights_Title ADRT ON   
				CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)  
				=  
				CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)  
				WHERE AtADRT.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Platform ****************/  
  
				INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)   
				SELECT @Acq_Deal_Rights_Code, AtADRP.Platform_Code  
				From AT_Acq_Deal_Rights_Platform AtADRP WHERE AtADRP.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
    
				/**************** Insert into Acq_Deal_Rights_Territory ****************/   
  
				INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)   
				SELECT @Acq_Deal_Rights_Code, AtADRT.Territory_Code, AtADRT.Territory_Type, AtADRT.Country_Code  
				From AT_Acq_Deal_Rights_Territory AtADRT WHERE AtADRT.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Subtitling ****************/   
  
				INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)   
				SELECT @Acq_Deal_Rights_Code, AtADRS.Language_Code, AtADRS.Language_Group_Code, AtADRS.Language_Type  
				From AT_Acq_Deal_Rights_Subtitling AtADRS WHERE AtADRS.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Dubbing ****************/   
     
				INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)   
				SELECT @Acq_Deal_Rights_Code, AtADRD.Language_Code, AtADRD.Language_Group_Code, AtADRD.Language_Type  
				From AT_Acq_Deal_Rights_Dubbing AtADRD WHERE AtADRD.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
      
  				/**************** Insert into Acq_Deal_Rights_Holdback ****************/   
  
				INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code,   
				Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units,   
				Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)  
				SELECT @Acq_Deal_Rights_Code,   
				AtADRH.Holdback_Type, AtADRH.HB_Run_After_Release_No, AtADRH.HB_Run_After_Release_Units,   
				AtADRH.Holdback_On_Platform_Code, AtADRH.Holdback_Release_Date, AtADRH.Holdback_Comment, AtADRH.Is_Title_Language_Right  
				FROM AT_Acq_Deal_Rights_Holdback AtADRH WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Dubbing ********/   
  
				INSERT INTO Acq_Deal_Rights_Holdback_Dubbing ( Acq_Deal_Rights_Holdback_Code, Language_Code)  
				SELECT ADRH.Acq_Deal_Rights_Holdback_Code, AtADRHD.Language_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Dubbing AtADRHD  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHD.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON  
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Platform ********/   
  
				INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)  
				SELECT ADRH.Acq_Deal_Rights_Holdback_Code, AtADRHP.Platform_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Platform AtADRHP  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHP.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON  
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Subtitling ********/   
  
				INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (Acq_Deal_Rights_Holdback_Code, Language_Code)  
				SELECT ADRH.Acq_Deal_Rights_Holdback_Code, AtADRHS.Language_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Subtitling AtADRHS  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHS.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON  
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Territory ********/   
       
				INSERT INTO Acq_Deal_Rights_Holdback_Territory (  
				Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)  
				SELECT  
				ADRH.Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Territory AtADRHT  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHT.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON   
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Blackout ****************/   
     
				INSERT INTO Acq_Deal_Rights_Blackout (  
				Acq_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Rights_Code, AtADRB.Start_Date, AtADRB.End_Date, AtADRB.Inserted_By, AtADRB.Inserted_On, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Rights_Blackout AtADRB WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Dubbing ********/   
  
				INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Code, Language_Code)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBD.Language_Code  
				FROM AT_Acq_Deal_Rights_Blackout_Dubbing AtADRBD  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBD.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON   
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Platform ********/   
  
				INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Code, Platform_Code)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBP.Platform_Code  
				FROM AT_Acq_Deal_Rights_Blackout_Platform AtADRBP  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBP.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON   
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)   
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Subtitling ********/  

				INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Code, Language_Code)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBS.Language_Code  
				FROM AT_Acq_Deal_Rights_Blackout_Subtitling AtADRBS  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBS.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON  
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)   
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Territory ********/      

				INSERT INTO Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBT.Country_Code, AtADRBT.Territory_Code, AtADRBT.Territory_Type  
				FROM AT_Acq_Deal_Rights_Blackout_Territory AtADRBT  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBT.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON  
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  


  /**************** Insert into Acq_Deal_Rights_Promoter ****************/   
     
				INSERT INTO Acq_Deal_Rights_Promoter (  
				Acq_Deal_Rights_Code,  Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Rights_Code, AtADRP.Inserted_By, AtADRP.Inserted_On, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Rights_Promoter AtADRP WHERE AtADRP.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  

					/******** Insert into Acq_Deal_Rights_Promoter_Group ********/   

     
		 INSERT INTO Acq_Deal_Rights_Promoter_Group( Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code)
                      SELECT ADRPNew.Acq_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code
                      FROM (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From AT_Acq_Deal_Rights_Promoter
						Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN AT_Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.AT_Acq_Deal_Rights_Promoter_Code = ADRP.AT_Acq_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

				/******** Insert into Acq_Deal_Rights_Promoter_Remarks ********/   
  
				 INSERT INTO Acq_Deal_Rights_Promoter_Remarks( Acq_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
                      SELECT ADRPNew.Acq_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code
                      FROM (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From AT_Acq_Deal_Rights_Promoter
						Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN AT_Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.AT_Acq_Deal_Rights_Promoter_Code = ADRP.AT_Acq_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

				FETCH NEXT FROM rights_cursor   
				INTO @AT_Acq_Deal_Rights_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, @Is_Theatrical_Right, 
				@Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, @Milestone_No_Of_Unit, 
				@Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, @Actual_Right_Start_Date, @Actual_Right_End_Date, 
				@Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, @Acq_Deal_Rights_Old_Code, @ROFR_Code,@Promoter_Flag  
		   END  
			CLOSE rights_cursor;  
			DEALLOCATE rights_cursor;  
	
			/******************************** Delete from Acq_Deal_Pushback *****************************************/   
			/* Delete from Acq_Deal_Pushback_Dubbing */  
			DELETE ADPD FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Dubbing ADPD  
			ON ADPD.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Platform */  
			DELETE ADPP FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Platform ADPP  
			ON ADPP.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Subtitling */  
			DELETE ADPS FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Subtitling ADPS  
			ON ADPS.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Territory */  
			DELETE ADPT FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Territory ADPT  
			ON ADPT.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Title */  
			DELETE ADPT FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Title ADPT  
			ON ADPT.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback */  
			DELETE FROM Acq_Deal_Pushback where Acq_Deal_Code = @Acq_Deal_Code  
  
			--Declare cursor for Pushback  
			Declare @AT_Acq_Deal_Pushback_Code INT, @P_Right_Type CHAR(1), @P_Is_Tentative CHAR(1), @P_Term varchar(12),@P_Right_Start_Date DATETIME,  
			@Acq_Deal_Pushback_Old_Code INT = 0,@P_Right_End_Date DATETIME, @P_Milestone_Type_Code INT, @P_Milestone_No_Of_Unit INT,  
			@P_Milestone_Unit_Type INT, @P_Is_Title_Language_Right CHAR(1),  
			@P_Remarks NVARCHAR(4000), @P_Inserted_By INT, @P_Inserted_On DATETIME, @P_Last_Updated_Time DATETIME, @P_Last_Action_By INT  
  
			DECLARE @Acq_Deal_Pushback_Code INT = 0  
			DECLARE pushback_cursor CURSOR FOR   
			SELECT AT_Acq_Deal_Pushback_Code,Acq_Deal_Pushback_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit,   
			Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, GETDATE(), @User_Code  
			FROM AT_Acq_Deal_Pushback WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN pushback_cursor  
  
			FETCH NEXT FROM pushback_cursor   
			INTO @AT_Acq_Deal_Pushback_Code,@Acq_Deal_Pushback_Old_Code, @P_Right_Type , @P_Is_Tentative , @P_Term ,@P_Right_Start_Date ,   
			@P_Right_End_Date, @P_Milestone_Type_Code,@P_Milestone_No_Of_Unit,@P_Milestone_Unit_Type, @P_Is_Title_Language_Right,@P_Remarks,  
			@P_Inserted_By,@P_Inserted_On,@P_Last_Updated_Time, @P_Last_Action_By  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Pushback *****************************************/   
				IF(IsNull(@Acq_Deal_Pushback_Old_Code, 0) = 0)  
				BEGIN       
					INSERT INTO Acq_Deal_Pushback(Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit,   
					Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
					VALUES(@Acq_Deal_Code, @P_Right_Type, @P_Is_Tentative, @P_Term, @P_Right_Start_Date, @P_Right_End_Date, @P_Milestone_Type_Code, @P_Milestone_No_Of_Unit,   
					@P_Milestone_Unit_Type, @P_Is_Title_Language_Right, @P_Remarks, @P_Inserted_By, @P_Inserted_On, @P_Last_Updated_Time, @P_Last_Action_By)        
					SELECT @Acq_Deal_Pushback_Code = IDENT_CURRENT('Acq_Deal_Pushback')  
					UPDATE AT_Acq_Deal_Pushback SET Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code WHERE AT_Acq_Deal_Pushback_Code  = @AT_Acq_Deal_Pushback_Code   
				END  
				ELSE  
				BEGIN
					SET IDENTITY_INSERT [Acq_Deal_Pushback] ON                  
					INSERT INTO Acq_Deal_Pushback(Acq_Deal_Pushback_Code, Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date,Right_End_Date,  
					Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Title_Language_Right, Remarks,  
					Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
					VALUES(  
					@Acq_Deal_Pushback_Old_Code,@Acq_Deal_Code, @P_Right_Type, @P_Is_Tentative, @P_Term, @P_Right_Start_Date, @P_Right_End_Date,  
					@P_Milestone_Type_Code, @P_Milestone_No_Of_Unit, @P_Milestone_Unit_Type, @P_Is_Title_Language_Right, @P_Remarks,  
					@P_Inserted_By, @P_Inserted_On, @P_Last_Updated_Time, @P_Last_Action_By)              
					SET IDENTITY_INSERT [Acq_Deal_Pushback] OFF  
					SELECT @Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Old_Code  
				END       
  
				/**************** Insert into Acq_Deal_Pushback_Dubbing ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Dubbing(  
				Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPD.Language_Type, ADPD.Language_Code, ADPD.Language_Group_Code  
				FROM AT_Acq_Deal_Pushback_Dubbing ADPD WHERE ADPD.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Platform ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Platform(  
				Acq_Deal_Pushback_Code, Platform_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPP.Platform_Code  
				FROM AT_Acq_Deal_Pushback_Platform ADPP WHERE ADPP.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Subtitling ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Subtitling(  
				Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPS.Language_Type, ADPS.Language_Code, ADPS.Language_Group_Code  
				FROM AT_Acq_Deal_Pushback_Subtitling ADPS WHERE ADPS.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Territory ****************/   
				INSERT INTO Acq_Deal_Pushback_Territory(  
				Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPT.Territory_Type, ADPT.Country_Code, ADPT.Territory_Code  
				FROM AT_Acq_Deal_Pushback_Territory ADPT WHERE ADPT.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Title ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Title(  
				Acq_Deal_Pushback_Code, Title_Code, Episode_From, Episode_To)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPT.Title_Code, ADPT.Episode_From, ADPT.Episode_To  
				FROM AT_Acq_Deal_Pushback_Title ADPT WHERE ADPT.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				FETCH NEXT FROM pushback_cursor   
				INTO @AT_Acq_Deal_Pushback_Code,@Acq_Deal_Pushback_Old_Code, @P_Right_Type , @P_Is_Tentative , @P_Term ,@P_Right_Start_Date ,  
				@P_Right_End_Date, @P_Milestone_Type_Code, @P_Milestone_No_Of_Unit,@P_Milestone_Unit_Type, @P_Is_Title_Language_Right,@P_Remarks,@P_Inserted_By,@P_Inserted_On,@P_Last_Updated_Time, @P_Last_Action_By  
			END  
			CLOSE pushback_cursor  
			DEALLOCATE pushback_cursor  
    
			/******************************** Delete from Acq_Deal_Ancillary *****************************************/  
			/* Delete from Acq_Deal_Ancillary_Platform_Medium */   
			DELETE ADAPM FROM Acq_Deal_Ancillary ADA   
			INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAp.Acq_Deal_Ancillary_Platform_Code  
  
			/* Delete from Acq_Deal_Ancillary_Platform */  
			DELETE ADAP FROM Acq_Deal_Ancillary ADA INNER JOIN Acq_Deal_Ancillary_Platform ADAP  
			ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Ancillary_Title */  
			DELETE ADAT FROM Acq_Deal_Ancillary ADA INNER JOIN Acq_Deal_Ancillary_Title ADAT  
			ON ADAT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Ancillary */  
			DELETE FROM Acq_Deal_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
			--Declare cursor form ancillary  
  
			DECLARE @Acq_Deal_Ancillary_Code INT = 0,@Acq_Deal_Ancillary_Old_Code INT = 0  
			DECLARE @AT_Acq_Deal_Ancillary_Code INT,@Ancillary_Type_code INT, @Duration numeric, @Day numeric, @A_Remarks NVARCHAR(4000), @Group_No INT, @Catch_Up_From CHAR(1)  
			DECLARE ancillary_cursor CURSOR  
			FOR SELECT DISTINCT AT_Acq_Deal_Ancillary_Code,Acq_Deal_Ancillary_Code, Ancillary_Type_code, Duration, Day, Remarks, Group_No, Catch_Up_From  
			FROM AT_Acq_Deal_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code      
  
			OPEN ancillary_cursor FETCH NEXT FROM ancillary_cursor  
			INTO @AT_Acq_Deal_Ancillary_Code,@Acq_Deal_Ancillary_Old_Code,@Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From     
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into AT_Acq_Deal_Ancillary *****************************************/   
				IF(ISNULL(@Acq_Deal_Ancillary_Old_Code, 0) = 0)  
				BEGIN       
					INSERT INTO Acq_Deal_Ancillary(Acq_Deal_Code, Ancillary_Type_code, Duration, [Day], Remarks, Group_No, Catch_Up_From)
					VALUES  (@Acq_Deal_Code, @Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From)  
					SELECT @Acq_Deal_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Ancillary')  
					UPDATE AT_Acq_Deal_Ancillary SET Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code   
					WHERE AT_Acq_Deal_Ancillary_Code  = @AT_Acq_Deal_Ancillary_Code AND AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Ancillary] ON            
					INSERT INTO Acq_Deal_Ancillary(Acq_Deal_Ancillary_Code,Acq_Deal_Code, Ancillary_Type_code, Duration, [Day], Remarks, Group_No, Catch_Up_From)  
					VALUES(@Acq_Deal_Ancillary_Old_Code,@Acq_Deal_Code, @Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From)  
					SET IDENTITY_INSERT [Acq_Deal_Ancillary] OFF        
					SELECT @Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Old_Code  
				END       
				/**************** Insert into Acq_Deal_Ancillary_Platform ****************/   
  
				INSERT INTO Acq_Deal_Ancillary_Platform (Acq_Deal_Ancillary_Code, Ancillary_Platform_code, Platform_Code)  
				SELECT @Acq_Deal_Ancillary_Code, AtADAP.Ancillary_Platform_code,  AtADAP.Platform_Code 
				FROM AT_Acq_Deal_Ancillary_Platform AtADAP WHERE AtADAP.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code  
  
				/******** Insert into Acq_Deal_Ancillary_Platform_Medium ********/   
     
				INSERT INTO Acq_Deal_Ancillary_Platform_Medium(Acq_Deal_Ancillary_Platform_Code, Ancillary_Platform_Medium_Code)  
				SELECT ADAP.Acq_Deal_Ancillary_Platform_Code, AtADAPM.Ancillary_Platform_Medium_Code  
				FROM AT_Acq_Deal_Ancillary_Platform_Medium AtADAPM  
				INNER JOIN AT_Acq_Deal_Ancillary_Platform AtADAP ON AtADAPM.AT_Acq_Deal_Ancillary_Platform_Code = AtADAP.AT_Acq_Deal_Ancillary_Platform_Code  
				INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Ancillary_Platform_code = AtADAP.Ancillary_Platform_code  
				WHERE AtADAP.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code  
				AND ADAP.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code
  
				/**************** Insert into Acq_Deal_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Ancillary_Title (Acq_Deal_Ancillary_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Ancillary_Code, AtADAT.Title_Code, AtADAT.Episode_From, AtADAT.Episode_To  
				FROM AT_Acq_Deal_Ancillary_Title AtADAT WHERE AtADAT.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code  
  
				FETCH NEXT FROM ancillary_cursor  
				INTO @AT_Acq_Deal_Ancillary_Code,@Acq_Deal_Ancillary_Old_Code,@Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From 
			END  
			CLOSE ancillary_cursor  
			DEALLOCATE ancillary_cursor  
	   END
		IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='RU'))
		BEGIN
			/******************************** Delete from Acq_Deal_Run *****************************************/   
			/* Delete from Acq_Deal_Run_Channel */  
			DELETE ADRC FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Channel ADRC  
			ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Repeat_On_Day */  
			DELETE ADRRD FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Repeat_On_Day ADRRD  
			ON ADRRD.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Title */   
			DELETE ADRT FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Title ADRT  
			ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Yearwise_Run_Week */   
			DELETE ADRYRW FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Yearwise_Run_Week ADRYRW  
			ON ADRYRW.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Yearwise_Run */   
			DELETE ADRYR FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR  
			ON ADRYR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Shows */  
			DELETE ADRS FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Shows ADRS  
			ON ADRS.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code   
			  
			--/* Delete from Content_Channel_Run */  
			DELETE CCR FROM Acq_Deal_Run ADR INNER JOIN Content_Channel_Run CCR  
			ON CCR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run */  
			DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
			--Declare run cursor  
			Declare @Acq_Deal_Run_Code INT = 0,@Acq_Deal_Run_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Run_Code INT, @Run_Type CHAR(1), @No_Of_Runs INT, @No_Of_Runs_Sched INT, @No_Of_AsRuns INT, @Is_Yearwise_Definition CHAR(1),  
			@Is_Rule_Right CHAR(1), @Right_Rule_Code INT, @Repeat_Within_Days_Hrs CHAR(1), @No_Of_Days_Hrs INT, @Is_Channel_Definition_Rights CHAR(1),  
			@Primary_Channel_Code INT, @Run_Definition_Type CHAR, @Run_Definition_Group_Code INT, @All_Channel varchar(1), @Prime_Start_Time time,@Prime_End_Time time,  
			@Off_Prime_Start_Time time, @Off_Prime_End_Time time, @Time_Lag_Simulcast time, @Prime_Run INT, @Off_Prime_Run INT, @Prime_Time_Provisional_Run_Count INT,  
			@Prime_Time_AsRun_Count INT,@Prime_Time_Balance_Count INT,@Off_Prime_Time_Provisional_Run_Count INT,@Off_Prime_Time_AsRun_Count INT,  
			@Off_Prime_Time_Balance_Count INT , @Syndication_Runs INT, @Inserted_Run_By INT,@Inserted_Run_On DATETIME,@Last_action_Run_By INT,@Last_updated_Run_Time DATETIME, @channel_Code Varchar(2), @Channel_Category_Code INT

			IF(@Is_Edit_WO_Approval='N')
			BEGIN
				SELECT TOP 1 @Version_Code = ISNULL(Acq_Deal_Tab_Version_Code, 0) FROM Acq_Deal_Tab_Version WHERE Acq_Deal_Code = @Acq_Deal_Code 
				ORDER BY Acq_Deal_Tab_Version_Code DESC
			END
			ELSE
			BEGIN
				SELECT @Version_Code = ISNULL(Acq_Deal_Tab_Version_Code, 0) FROM (SELECT row_number() OVER (ORDER BY Acq_Deal_Tab_Version_Code DESC) r, * FROM Acq_Deal_Tab_Version where Acq_Deal_Code = @Acq_Deal_Code) q
				WHERE r = 2
			END

			DECLARE run_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Run_Code,Acq_Deal_Run_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code,   
			Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights, Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,  
			All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,  
			Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count
			,Off_Prime_Time_Balance_Count ,Syndication_Runs ,Inserted_By ,Inserted_On ,Last_action_By ,Last_updated_Time, Channel_Type, Channel_Category_Code 
			FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  AND Acq_Deal_Tab_Version_Code=@Version_Code
  
			OPEN run_cursor  
			FETCH NEXT FROM run_cursor  
			INTO @AT_Acq_Deal_Run_Code,@Acq_Deal_Run_Old_Code, @Run_Type, @No_Of_Runs, @No_Of_Runs_Sched, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
			@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights, @Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
			@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
			@Prime_Time_Provisional_Run_Count,@Prime_Time_AsRun_Count,@Prime_Time_Balance_Count,@Off_Prime_Time_Provisional_Run_Count,@Off_Prime_Time_AsRun_Count
			,@Off_Prime_Time_Balance_Count, @Syndication_Runs,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Run *****************************************/   
				IF(IsNull(@Acq_Deal_Run_Old_Code, 0) = 0)  
				BEGIN       
					INSERT INTO Acq_Deal_Run (Acq_Deal_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code,   
					Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights,Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,  
					All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,  
					Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,
					Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count, Syndication_Runs,Inserted_By ,Inserted_On ,Last_action_By ,Last_updated_Time, Channel_Type, Channel_Category_Code )
					VALUES(@Acq_Deal_Code, @Run_Type, @No_Of_Runs, 0, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
					@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights,@Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
					@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
					0,@Prime_Time_AsRun_Count,@Prime_Run,0,
					@Off_Prime_Time_AsRun_Count,@Off_Prime_Run, @Syndication_Runs,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code)  
					SELECT @Acq_Deal_Run_Old_Code = IDENT_CURRENT('Acq_Deal_Run')  
					UPDATE AT_Acq_Deal_Run SET Acq_Deal_Run_Code = @Acq_Deal_Run_Code WHERE AT_Acq_Deal_Run_Code  = @AT_Acq_Deal_Run_Code AND Acq_Deal_Tab_Version_Code=@Version_Code   
				END  
				ELSE  
				BEGIN       
					SET IDENTITY_INSERT [Acq_Deal_Run] ON            
					INSERT INTO Acq_Deal_Run  
					(  
					Acq_Deal_Run_Code,Acq_Deal_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code,   
					Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights,Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,  
					All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,  
					Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,  
					Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count, Syndication_Runs, Inserted_By, Inserted_On ,Last_action_By ,Last_updated_Time, Channel_Type, Channel_Category_Code
					)  
					VALUES  
					(  
					@Acq_Deal_Run_Old_Code,@Acq_Deal_Code, @Run_Type, @No_Of_Runs, 0, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
					@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights,@Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
					@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
					0,@Prime_Time_AsRun_Count,@Prime_Run,0,@Off_Prime_Time_AsRun_Count,@Off_Prime_Run, @Syndication_Runs 
					,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code
					)  
					SET IDENTITY_INSERT [Acq_Deal_Run] OFF       
					SELECT @Acq_Deal_Run_Code = @Acq_Deal_Run_Old_Code  
				END     
				/**************** Insert into Acq_Deal_Run_Channel ****************/   
  
				INSERT INTO Acq_Deal_Run_Channel (  
				Acq_Deal_Run_Code, Channel_Code, Min_Runs, Max_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Do_Not_Consume_Rights,   
				Is_Primary, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time)  
				SELECT  
				@Acq_Deal_Run_Code, AtADRC.Channel_Code, AtADRC.Min_Runs, AtADRC.Max_Runs, 0, AtADRC.No_Of_AsRuns, AtADRC.Do_Not_Consume_Rights,   
				AtADRC.Is_Primary, AtADRC.Inserted_By, AtADRC.Inserted_On, @User_Code, GETDATE()  
				FROM AT_Acq_Deal_Run_Channel AtADRC WHERE AtADRC.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/**************** Insert into Acq_Deal_Run_Repeat_On_Day ****************/   
     
				INSERT INTO Acq_Deal_Run_Repeat_On_Day (Acq_Deal_Run_Code, Day_Code)  
				SELECT @Acq_Deal_Run_Code, AtADRRD.Day_Code  
				FROM AT_Acq_Deal_Run_Repeat_On_Day AtADRRD WHERE AtADRRD.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/**************** Insert into Acq_Deal_Run_Shows ****************/   
				INSERT INTO Acq_Deal_Run_Shows(Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,Acq_Deal_Movie_Code,Inserted_By,Inserted_On)  
				SELECT DISTINCT  @Acq_Deal_Run_Code,AtADRS.Data_For,AtADRS.Title_Code,AtADRS.Episode_From,AtADRS.Episode_To,ADM.Acq_Deal_Movie_Code,AtADRS.Inserted_By,AtADRS.Inserted_On  
				FROM AT_Acq_Deal_Run_Shows AtADRS   
				INNER JOIN Acq_Deal_Movie ADM ON  
				(AtADRS.Title_Code = ADM.Title_Code OR ISNULL(AtADRS.Title_Code,0) = 0)   
				AND (AtADRS.Episode_From = ADM.Episode_Starts_From OR ISNULL(AtADRS.Episode_From,0) = 0)   
				AND (AtADRS.Episode_To = ADM.Episode_End_To OR ISNULL(AtADRS.Episode_To,0) = 0)  
				WHERE AtADRS.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code   
				-- AND ADM.Acq_Deal_Code = @Acq_Deal_Code  
   
				/**************** Insert into Acq_Deal_Run_Title ****************/   
  
				INSERT INTO Acq_Deal_Run_Title (Acq_Deal_Run_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Run_Code, AtADRT.Title_Code, AtADRT.Episode_From, AtADRT.Episode_To  
				FROM AT_Acq_Deal_Run_Title AtADRT        
				WHERE AtADRT.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/**************** Insert into Acq_Deal_Run_Yearwise_Run ****************/   
  
				INSERT INTO Acq_Deal_Run_Yearwise_Run (   
				Acq_Deal_Run_Code, Start_Date, End_Date, No_Of_Runs, No_Of_Runs_Sched,   
				No_Of_AsRuns, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time,Year_No)  
				SELECT   
				@Acq_Deal_Run_Code, AtADRYR.Start_Date, AtADRYR.End_Date, AtADRYR.No_Of_Runs, 0,   
				AtADRYR.No_Of_AsRuns, AtADRYR.Inserted_By, AtADRYR.Inserted_On, @User_Code, GETDATE(), AtADRYR.Year_No  
				FROM AT_Acq_Deal_Run_Yearwise_Run AtADRYR WHERE AtADRYR.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/******** Insert into Acq_Deal_Run_Yearwise_Run_Week ********/   
				INSERT INTO Acq_Deal_Run_Yearwise_Run_Week (   
				Acq_Deal_Run_Yearwise_Run_Code, Acq_Deal_Run_Code, Start_Week_Date, End_Week_Date, Is_Preferred,   
				Inserted_By, Inserted_On, Last_action_By, Last_updated_Time)  
				SELECT   
				ADRYR.Acq_Deal_Run_Yearwise_Run_Code, @Acq_Deal_Run_Code,   
				AtADRYRW.Start_Week_Date, AtADRYRW.End_Week_Date, AtADRYRW.Is_Preferred,   
				AtADRYRW.Inserted_By, AtADRYRW.Inserted_On, @User_Code, GETDATE()  
				FROM AT_Acq_Deal_Run_Yearwise_Run AtADRYR INNER JOIN AT_Acq_Deal_Run_Yearwise_Run_Week AtADRYRW ON AtADRYRW.AT_Acq_Deal_Run_Yearwise_Run_Code = AtADRYR.AT_Acq_Deal_Run_Yearwise_Run_Code  
				INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON  
				CAST(ISNULL(ADRYR.Start_Date, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRYR.End_Date, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(ADRYR.No_Of_Runs, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRYR.No_Of_Runs_Sched, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(ADRYR.No_Of_AsRuns, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRYR.Inserted_By, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(ADRYR.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRYR.Start_Date, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRYR.End_Date, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(AtADRYR.No_Of_Runs, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRYR.No_Of_Runs_Sched, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(AtADRYR.No_Of_AsRuns, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRYR.Inserted_By, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(AtADRYR.Inserted_On, '') AS VARCHAR)  
				WHERE AtADRYR.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
			FETCH NEXT FROM run_cursor  
			INTO @AT_Acq_Deal_Run_Code,@Acq_Deal_Run_Old_Code, @Run_Type, @No_Of_Runs, @No_Of_Runs_Sched, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
			@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights, @Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
			@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
			@Prime_Time_Provisional_Run_Count,@Prime_Time_AsRun_Count,@Prime_Time_Balance_Count,@Off_Prime_Time_Provisional_Run_Count,@Off_Prime_Time_AsRun_Count
			,@Off_Prime_Time_Balance_Count, @Syndication_Runs,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code
			END  
			CLOSE run_cursor  
			DEALLOCATE run_cursor  
		END
		IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='CO'))
		BEGIN
			/******************************** Delete from Acq_Deal_Cost *****************************************/   
			/* Delete from Acq_Deal_Cost_Additional_Exp */  
			DELETE ADCAE FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Additional_Exp ADCAE  
			ON ADCAE.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost_Commission */  
			DELETE ADCC FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Commission ADCC  
			ON ADCC.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code   
  
			/* Delete from Acq_Deal_Cost_Costtype_Episode */  
			DELETE ADCCTE FROM Acq_Deal_Cost ADC   
			INNER JOIN Acq_Deal_Cost_Costtype ADCCT ON ADCCT.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Cost_Costtype_Episode ADCCTE ON ADCCTE.Acq_Deal_Cost_Costtype_Code = ADCCT.Acq_Deal_Cost_Costtype_Code  
  
			/* Delete from Acq_Deal_Cost_Costtype */  
			DELETE ADCCT FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Costtype ADCCT  
			ON ADCCT.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost_Title */  
			DELETE ADCT FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Title ADCT  
			ON ADCT.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost_Variable_Cost */  
			DELETE ADCVC FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Variable_Cost ADCVC  
			ON ADCVC.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost */  
			DELETE FROM Acq_Deal_Cost WHERE Acq_Deal_Code = @Acq_Deal_Code  
     
			--Declare cost cursor  
			Declare @Acq_Deal_Cost_Code INT = 0,@Acq_Deal_Cost_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Cost_Code INT, @Currency_Code INT, @Currency_Exchange_Rate decimal, @Deal_Cost decimal, @Deal_Cost_Per_Episode decimal,  
			@Cost_Center_Id INT,@Additional_Cost decimal, @Catchup_Cost decimal, @Variable_Cost_Type CHAR,@Variable_Cost_Sharing_Type CHAR, @Royalty_Recoupment_Code INT, @C_Inserted_On DATETIME,@C_Inserted_By INT,  
			@C_Last_Updated_Time DATETIME, @C_Last_Action_By INT,@Incentive CHAR,@C_Remarks NVARCHAR(4000)  
  
			
			DECLARE cost_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Cost_Code,Acq_Deal_Cost_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost,   
			Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time,Last_Action_By,Incentive,Remarks  
			FROM AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code AND Acq_Deal_Tab_Version_Code=@Version_Code
  
			OPEN cost_cursor  
			FETCH NEXT FROM cost_cursor  
			INTO @AT_Acq_Deal_Cost_Code,@Acq_Deal_Cost_Old_Code, @Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
			@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
			@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Cost *****************************************/   
				IF(IsNull(@Acq_Deal_Cost_Old_Code, 0) = 0)  
				BEGIN              
					INSERT INTO Acq_Deal_Cost(Acq_Deal_Code,Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id,  
					Additional_Cost, Catchup_Cost, Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By,  
					Last_Updated_Time, Last_Action_By, Incentive, Remarks)
					VALUES(@Acq_Deal_Code,@Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
					@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
					@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks)  
					SELECT @Acq_Deal_Cost_Code = IDENT_CURRENT('Acq_Deal_Cost')  
					UPDATE AT_Acq_Deal_Cost SET Acq_Deal_Cost_Code = @Acq_Deal_Cost_Code WHERE AT_Acq_Deal_Cost_Code  = @AT_Acq_Deal_Cost_Code  AND Acq_Deal_Tab_Version_Code=@Version_Code     
				END  
				ELSE  
					BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Cost] ON        
					INSERT INTO Acq_Deal_Cost (  
					Acq_Deal_Cost_Code ,Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate, Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,  
					Additional_Cost, Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,Inserted_On,Inserted_By,  
					Last_Updated_Time,Last_Action_By,Incentive,Remarks  
					)  
					VALUES  
					(  
					@Acq_Deal_Cost_Old_Code,@Acq_Deal_Code,@Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
					@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
					@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks  
					)  
					SET IDENTITY_INSERT [Acq_Deal_Cost] OFF       
					SELECT @Acq_Deal_Cost_Code = @Acq_Deal_Cost_Old_Code  
				END  
         
				/**************** Insert into Acq_Deal_Cost_Additional_Exp ****************/  
     
				INSERT INTO Acq_Deal_Cost_Additional_Exp (  
				Acq_Deal_Cost_Code, Additional_Expense_Code, Amount, Min_Max, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Cost_Code, AtADCAE.Additional_Expense_Code, AtADCAE.Amount, AtADCAE.Min_Max,   
				AtADCAE.Inserted_On, AtADCAE.Inserted_By, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Cost_Additional_Exp AtADCAE WHERE AtADCAE.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Commission ****************/   
  
				INSERT INTO Acq_Deal_Cost_Commission (  
				Acq_Deal_Cost_Code, Cost_Type_Code, Royalty_Commission_Code, Entity_Code, Vendor_Code, Type, Commission_Type, Percentage, Amount)  
				SELECT   
				@Acq_Deal_Cost_Code, AtADCC.Cost_Type_Code, AtADCC.Royalty_Commission_Code, AtADCC.Entity_Code,  
				AtADCC.Vendor_Code, AtADCC.Type, AtADCC.Commission_Type, AtADCC.Percentage, AtADCC.Amount  
				FROM AT_Acq_Deal_Cost_Commission AtADCC WHERE AtADCC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Title ****************/   
  
				INSERT INTO Acq_Deal_Cost_Title (Acq_Deal_Cost_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Cost_Code, AtADCT.Title_Code, AtADCT.Episode_From, AtADCT.Episode_To  
				FROM AT_Acq_Deal_Cost_Title AtADCT WHERE AtADCT.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Variable_Cost ****************/  
     
				INSERT INTO Acq_Deal_Cost_Variable_Cost (  
				Acq_Deal_Cost_Code, Entity_Code, Vendor_Code, Percentage, Amount,   
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Cost_Code, AtADCVC.Entity_Code, AtADCVC.Vendor_Code, AtADCVC.Percentage, AtADCVC.Amount,   
				AtADCVC.Inserted_On, AtADCVC.Inserted_By, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Cost_Variable_Cost AtADCVC WHERE AtADCVC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Costtype ****************/   
  
				INSERT INTO Acq_Deal_Cost_Costtype (  
				Acq_Deal_Cost_Code, Cost_Type_Code, Amount, Consumed_Amount, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Cost_Code,   
				AtADCC.Cost_Type_Code, AtADCC.Amount, AtADCC.Consumed_Amount, AtADCC.Inserted_On, AtADCC.Inserted_By, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Cost_Costtype AtADCC WHERE AtADCC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/******** Insert into Acq_Deal_Cost_Costtype_Episode ********/   
  
				INSERT INTO Acq_Deal_Cost_Costtype_Episode (  
				Acq_Deal_Cost_Costtype_Code, Episode_From, Episode_To, Amount_Type, Amount, Percentage, Remarks,Per_Eps_Amount)  
				SELECT   
				ADCC.Acq_Deal_Cost_Costtype_Code,  
				AtADCCE.Episode_From, AtADCCE.Episode_To, AtADCCE.Amount_Type, AtADCCE.Amount, AtADCCE.Percentage, AtADCCE.Remarks ,AtADCCE.Per_Eps_Amount 
				FROM AT_Acq_Deal_Cost_Costtype_Episode AtADCCE INNER JOIN AT_Acq_Deal_Cost_Costtype AtADCC ON AtADCCE.AT_Acq_Deal_Cost_Costtype_Code = AtADCC.AT_Acq_Deal_Cost_Costtype_Code  
				AND AtADCC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
				INNER JOIN Acq_Deal_Cost_Costtype ADCC ON ADCC.Acq_Deal_Cost_Code = @Acq_Deal_Cost_Code AND  
				CAST(ISNULL(ADCC.Cost_Type_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(ADCC.Amount, 0) AS VARCHAR) + '~' +  
				CAST(ISNULL(ADCC.Consumed_Amount, 0) AS VARCHAR) + '~' + CAST(ISNULL(ADCC.Inserted_On, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADCC.Inserted_By, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADCC.Cost_Type_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADCC.Amount, 0) AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADCC.Consumed_Amount, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtADCC.Inserted_On, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADCC.Inserted_By, '') AS VARCHAR)  
  
				FETCH NEXT FROM cost_cursor  
				INTO @AT_Acq_Deal_Cost_Code,@Acq_Deal_Cost_Old_Code, @Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
				@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
				@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks  
			END  
			CLOSE cost_cursor  
			DEALLOCATE cost_cursor
	   END
		IF(@Is_Edit_WO_Approval='N')
		BEGIN
			/******************************** Delete from Acq_Deal_Sport *****************************************/   
			/* Delete from Acq_Deal_Sport_Broadcast */  
			DELETE ADSB FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Broadcast ADSB  
			ON ADSB.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport_Platform */  
			DELETE ADSP FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Platform ADSP  
			ON ADSP.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport_Title */  
			DELETE ADST FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Title ADST  
			ON ADST.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport_Language*/  
			DELETE ADSL FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Language ADSL  
			ON ADSL.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport */  
			DELETE FROM Acq_Deal_Sport WHERE Acq_Deal_Code = @Acq_Deal_Code  
			--Declare sport cursor  
			Declare @Acq_Deal_Sport_Code INT = 0,@Acq_Deal_Sport_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Code INT, @Content_Delivery varchar, @Obligation_Broadcast varchar, @Deferred_Live varchar, @Deferred_Live_Duration varchar,  
			@Tape_Delayed varchar, @Tape_Delayed_Duration varchar, @Standalone_Transmission varchar,@Standalone_Substantial varchar, @Simulcast_Transmission varchar,  
			@Simulcast_Substantial varchar, @File_Name varchar, @Sys_File_Name varchar,@Remarks NVARCHAR(4000), @S_Inserted_On DATETIME, @S_Inserted_By INT,   
			@S_Last_Updated_Time DATETIME,@S_Last_Action_By INT,@MBO_Note NVARCHAR(4000)
  
			DECLARE sport_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Code,Acq_Deal_Sport_Code , Content_Delivery, Obligation_Broadcast, Deferred_Live, Deferred_Live_Duration,Tape_Delayed, Tape_Delayed_Duration,  
			Standalone_Transmission,Standalone_Substantial, Simulcast_Transmission, Simulcast_Substantial,[File_Name],Sys_File_Name,Remarks, Inserted_On, Inserted_By, Last_Updated_Time,Last_Action_By,MBO_Note  
			FROM AT_Acq_Deal_Sport WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_cursor  
			FETCH NEXT FROM sport_cursor  
			INTO @AT_Acq_Deal_Sport_Code,@Acq_Deal_Sport_Old_Code  , @Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, @Tape_Delayed_Duration,  
			@Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,@Remarks, @S_Inserted_On,  
			@S_Inserted_By,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Cost *****************************************/   
				IF(IsNull(@Acq_Deal_Sport_Old_Code, 0) = 0)  
				BEGIN                 
					INSERT INTO Acq_Deal_Sport (Acq_Deal_Code,Content_Delivery, Obligation_Broadcast, Deferred_Live, Deferred_Live_Duration, Tape_Delayed,
					Tape_Delayed_Duration, Standalone_Transmission, Standalone_Substantial, Simulcast_Transmission, Simulcast_Substantial, [File_Name], Sys_File_Name,
					Remarks, Inserted_By, Inserted_On,Last_Updated_Time,Last_Action_By, MBO_Note)
					VALUES(@Acq_Deal_Code,@Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, 
					@Tape_Delayed_Duration,  @Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,
					@Remarks, @S_Inserted_By,  @S_Inserted_On,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note)
					SELECT @Acq_Deal_Sport_Code = IDENT_CURRENT('Acq_Deal_Sport')  
  
					UPDATE AT_Acq_Deal_Sport SET Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code WHERE AT_Acq_Deal_Sport_Code  = @AT_Acq_Deal_Sport_Code   
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport] ON         
					INSERT INTO Acq_Deal_Sport   
					(  
					Acq_Deal_Sport_Code,Acq_Deal_Code,Content_Delivery, Obligation_Broadcast, Deferred_Live , Deferred_Live_Duration,Tape_Delayed,   
					Tape_Delayed_Duration,Standalone_Transmission ,Standalone_Substantial, Simulcast_Transmission,  
					Simulcast_Substantial , [File_Name], Sys_File_Name,Remarks,Inserted_By,  
					Inserted_On,Last_Updated_Time,Last_Action_By,MBO_Note  
					)  
					VALUES(  
					@Acq_Deal_Sport_Old_Code,@Acq_Deal_Code,@Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, @Tape_Delayed_Duration,  
					@Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,@Remarks, @S_Inserted_By,  
					@S_Inserted_On,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note)  
					SET IDENTITY_INSERT [Acq_Deal_Sport] OFF  
					SELECT @Acq_Deal_Sport_Code = @Acq_Deal_Sport_Old_Code  
				END  
				/**************** Insert into Acq_Deal_Sport_Broadcast ****************/   
  
				INSERT INTO Acq_Deal_Sport_Broadcast(  
				Acq_Deal_Sport_Code,Broadcast_Mode_Code,[Type])  
				SELECT   
				@Acq_Deal_Sport_Code,ADSB.Broadcast_Mode_Code,ADSB.[Type]  
				FROM AT_Acq_Deal_Sport_Broadcast ADSB WHERE ADSB.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				/**************** Insert into Acq_Deal_Sport_Platform ****************/   
  
				INSERT INTO Acq_Deal_Sport_Platform(  
				Acq_Deal_Sport_Code,Platform_Code,[Type])  
				SELECT   
				@Acq_Deal_Sport_Code,ADSP.Platform_Code,ADSP.[Type]  
				FROM AT_Acq_Deal_Sport_Platform ADSP WHERE ADSP.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				/**************** Insert into Acq_Deal_Sport_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Title(  
				Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To  
				FROM AT_Acq_Deal_Sport_Title ADST WHERE ADST.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				/**************** Insert into Acq_Deal_Sport_Language ****************/   
  
				INSERT INTO Acq_Deal_Sport_Language(  
				Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag)  
				SELECT   
				@Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag  
				FROM AT_Acq_Deal_Sport_Language ADST WHERE ADST.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				FETCH NEXT FROM sport_cursor  
				INTO @AT_Acq_Deal_Sport_Code,@Acq_Deal_Sport_Old_Code , @Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, @Tape_Delayed_Duration,  
				@Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,@Remarks, @S_Inserted_On,  
				@S_Inserted_By,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note  
			END  
			CLOSE sport_cursor  
			DEALLOCATE sport_cursor  
			/******************************** Delete from Acq_Deal_Sport_Ancillary *****************************************/        
			/* Delete from Acq_Deal_Sport_Ancillary_Broadcast */  
			DELETE ADSAB FROM Acq_Deal_Sport_Ancillary ADSA INNER JOIN Acq_Deal_Sport_Ancillary_Broadcast ADSAB  
			ON ADSAB.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code AND ADSA.Acq_Deal_Code = @Acq_Deal_Code    

			/* Delete from Acq_Deal_Sport_Ancillary_Source */  
			DELETE ADSAS FROM Acq_Deal_Sport_Ancillary ADSA INNER JOIN Acq_Deal_Sport_Ancillary_Source ADSAS  
			ON ADSAS.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code AND ADSA.Acq_Deal_Code = @Acq_Deal_Code    

			/* Delete from Acq_Deal_Sport_Ancillary_Title */  
			DELETE ADSAT FROM Acq_Deal_Sport_Ancillary ADSA INNER JOIN Acq_Deal_Sport_Ancillary_Title ADSAT  
			ON ADSAT.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code AND ADSA.Acq_Deal_Code = @Acq_Deal_Code    

			/* Delete from Acq_Deal_Sport_Ancillary */  
			DELETE FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code         

			--Declare sport ancillary cursor  
			Declare @Acq_Deal_Sport_Ancillary_Code INT = 0,@Acq_Deal_Sport_Ancillary_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Ancillary_Code INT,@Ancillary_For CHAR, @Sport_Ancillary_Type_Code INT,@SA_Obligation_Broadcast CHAR,@Broadcast_Window INT,  
			@Broadcast_Periodicity_Code INT,@Sport_Ancillary_Periodicity_Code INT,@SA_Duration time,@No_Of_Promos INT,@SA_Prime_Start_Time time,@SA_Prime_End_Time time,  
			@Prime_Durartion time,@Prime_No_of_Promos INT, @SA_Off_Prime_Start_Time time,@SA_Off_Prime_End_Time time,@Off_Prime_Durartion time,@Off_Prime_No_of_Promos INT,  
			@SA_Remarks NVARCHAR(4000)  
			DECLARE sport_anci_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Ancillary_Code,Acq_Deal_Sport_Ancillary_Code,Ancillary_For, Sport_Ancillary_Type_Code,Obligation_Broadcast,Broadcast_Window,Broadcast_Periodicity_Code,  
			Sport_Ancillary_Periodicity_Code,Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos, Off_Prime_Start_Time,  
			Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks  
			FROM AT_Acq_Deal_Sport_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_anci_cursor  
			FETCH NEXT FROM sport_anci_cursor  
			INTO @AT_Acq_Deal_Sport_Ancillary_Code,@Acq_Deal_Sport_Ancillary_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,@Broadcast_Periodicity_Code,  
			@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos ,@SA_Prime_Start_Time ,@SA_Prime_End_Time ,@Prime_Durartion ,@Prime_No_of_Promos ,  
			@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks    
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Sport_Ancillary *****************************************/   
				IF(IsNull(@Acq_Deal_Sport_Ancillary_Old_Code, 0) = 0)  
				BEGIN                 
					INSERT INTO Acq_Deal_Sport_Ancillary(Acq_Deal_Code,Ancillary_For, Sport_Ancillary_Type_Code, Obligation_Broadcast, Broadcast_Window,  
					Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code, Duration, No_Of_Promos,  
					Prime_Start_Time, Prime_End_Time, Prime_Durartion, Prime_No_of_Promos, 
					Off_Prime_Start_Time, Off_Prime_End_Time, Off_Prime_Durartion, Off_Prime_No_of_Promos, Remarks)
					VALUES  
					(@Acq_Deal_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,  
					@Broadcast_Periodicity_Code,@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos,  
					@SA_Prime_Start_Time ,@SA_Prime_End_Time,@Prime_Durartion ,@Prime_No_of_Promos ,  
					@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks)  
					SELECT @Acq_Deal_Sport_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Sport_Ancillary')  
					UPDATE AT_Acq_Deal_Sport_Ancillary SET Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code WHERE AT_Acq_Deal_Sport_Ancillary_Code  = @AT_Acq_Deal_Sport_Ancillary_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Ancillary] ON                  
					INSERT INTO Acq_Deal_Sport_Ancillary (Acq_Deal_Code,Ancillary_For, Sport_Ancillary_Type_Code ,Obligation_Broadcast ,Broadcast_Window ,  
					Broadcast_Periodicity_Code,Sport_Ancillary_Periodicity_Code ,Duration ,No_Of_Promos,  
					Prime_Start_Time ,Prime_End_Time,Prime_Durartion ,Prime_No_of_Promos ,  
					Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks)  
					VALUES  
					(@Acq_Deal_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,  
					@Broadcast_Periodicity_Code,@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos,  
					@SA_Prime_Start_Time ,@SA_Prime_End_Time,@Prime_Durartion ,@Prime_No_of_Promos ,  
					@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks)  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Ancillary] OFF  
					SELECT @Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Old_Code  
				END  
				/**************** Insert into Acq_Deal_Sport_Ancillary_Broadcast ****************/   
  
				INSERT INTO Acq_Deal_Sport_Ancillary_Broadcast(  
				Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code)  
				SELECT   
				@Acq_Deal_Sport_Ancillary_Code,ADSAB.Sport_Ancillary_Broadcast_Code  
				FROM AT_Acq_Deal_Sport_Ancillary_Broadcast ADSAB WHERE ADSAB.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Ancillary_Source ****************/   
  
				INSERT INTO Acq_Deal_Sport_Ancillary_Source(  
				Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code)  
				SELECT   
				@Acq_Deal_Sport_Ancillary_Code,ADSAS.Sport_Ancillary_Source_Code  
				FROM AT_Acq_Deal_Sport_Ancillary_Source ADSAS WHERE ADSAS.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Ancillary_Title(  
				Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Ancillary_Code,ADSAT.Title_Code,ADSAT.Episode_From,ADSAT.Episode_To  
				FROM AT_Acq_Deal_Sport_Ancillary_Title ADSAT WHERE ADSAT.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code  

				FETCH NEXT FROM sport_anci_cursor  
				INTO @AT_Acq_Deal_Sport_Ancillary_Code,@Acq_Deal_Sport_Ancillary_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,@Broadcast_Periodicity_Code,  
				@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos ,@SA_Prime_Start_Time ,@SA_Prime_End_Time ,@Prime_Durartion ,@Prime_No_of_Promos ,  
				@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks  
			END  
			CLOSE sport_anci_cursor  
			DEALLOCATE sport_anci_cursor  
  
			/******************************** Delete from Acq_Deal_Sport_Monetisation_Ancillary *****************************************/   
     
			/* Delete from Acq_Deal_Sport_Monetisation_Ancillary_Type */  
			DELETE ADSMAT FROM Acq_Deal_Sport_Monetisation_Ancillary ADSMA INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary_Type ADSMAT  
			ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Sport_Monetisation_Ancillary_Type */  
			DELETE ADSMAT FROM Acq_Deal_Sport_Monetisation_Ancillary ADSMA INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMAT  
			ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Sport_Monetisation_Ancillary */  
			DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
  
			--Declare sport ancillary monetisation cursor  
			Declare @Acq_Deal_Sport_Monetisation_Ancillary_Code INT = 0,@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code INT,@Appoint_Title_Sponsor CHAR, @Appoint_Broadcast_Sponsor CHAR, @SM_Remarks NVARCHAR(4000)
  
			DECLARE sport_mone_anci_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Appoint_Title_Sponsor, Appoint_Broadcast_Sponsor, Remarks  
			FROM AT_Acq_Deal_Sport_Monetisation_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_mone_anci_cursor  
			FETCH NEXT FROM sport_mone_anci_cursor  
			INTO @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN       
				/******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary *****************************************/   
				IF(ISNULL(@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code, 0) = 0)  
				BEGIN   
					INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary(Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks)
					VALUES(@Acq_Deal_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks)  
        
					SELECT @Acq_Deal_Sport_Monetisation_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Sport_Monetisation_Ancillary')               
        
					UPDATE AT_Acq_Deal_Sport_Monetisation_Ancillary SET Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code   
					WHERE AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Monetisation_Ancillary] ON                  
					INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary(
					Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks)  
					VALUES(@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code,@Acq_Deal_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks)  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Monetisation_Ancillary] OFF  
        
					SELECT @Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Old_Code  
				END     
  
				/**************** Insert into Acq_Deal_Sport_Monetisation_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary_Title(  
				Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Title_Code,ADSMAT.Episode_From,ADSMAT.Episode_To  
				FROM AT_Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMAT WHERE ADSMAT.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Monetisation_Ancillary_Type ****************/   
  
				INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary_Type(  
				Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights)  
				SELECT   
				@Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Monetisation_Type_Code,ADSMAT.Monetisation_Rights  
				FROM AT_Acq_Deal_Sport_Monetisation_Ancillary_Type ADSMAT WHERE ADSMAT.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  

				FETCH NEXT FROM sport_mone_anci_cursor  
				INTO @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks  
			END  
			CLOSE sport_mone_anci_cursor  
			DEALLOCATE sport_mone_anci_cursor  
  
			/******************************** Delete from Acq_Deal_Sport_Sales_Ancillary *****************************************/   
			/* Delete from Acq_Deal_Sport_Sales_Ancillary_Sponsor */  
			DELETE ADSSAS FROM Acq_Deal_Sport_Sales_Ancillary ADSSA INNER JOIN Acq_Deal_Sport_Sales_Ancillary_Sponsor ADSSAS  
			ON ADSSAS.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code   
			/* Delete from Acq_Deal_Sport_Sales_Ancillary_Title */  
			DELETE ADSSAT FROM Acq_Deal_Sport_Sales_Ancillary ADSSA INNER JOIN Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT  
			ON ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code    
			/* Delete from Acq_Deal_Sport_Sales_Ancillary */  
			DELETE FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code    
			--Declare sport ancillary Sales cursor  
			Declare @Acq_Deal_Sport_Sales_Ancillary_Code INT = 0,@Acq_Deal_Sport_Sales_Ancillary_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Sales_Ancillary_Code INT,@FRO_Given_Title_Sponsor CHAR,@FRO_Given_Official_Sponsor CHAR,@Title_FRO_No_of_Days INT,  
			@Title_FRO_Validity INT,@Price_Protection_Title_Sponsor CHAR,@Price_Protection_Official_Sponsor CHAR,@Last_Matching_Rights_Title_Sponsor CHAR,  
			@Last_Matching_Rights_Official_Sponsor CHAR,@Title_Last_Matching_Rights_Validity INT,@SS_Remarks NVARCHAR(4000),@Official_FRO_No_of_Days INT,  
			@Official_FRO_Validity INT,@Official_Last_Matching_Rights_Validity INT  
			DECLARE sport_sales_anci_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Sales_Ancillary_Code,Acq_Deal_Sport_Sales_Ancillary_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,  
			Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,  
			Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity  
			FROM AT_Acq_Deal_Sport_Sales_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_sales_anci_cursor  
			FETCH NEXT FROM sport_sales_anci_cursor  
			INTO @AT_Acq_Deal_Sport_Sales_Ancillary_Code,@Acq_Deal_Sport_Sales_Ancillary_Old_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,@Title_FRO_No_of_Days,@Title_FRO_Validity ,  
			@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,@Last_Matching_Rights_Title_Sponsor,@Last_Matching_Rights_Official_Sponsor,  
			@Title_Last_Matching_Rights_Validity,@SS_Remarks,@Official_FRO_No_of_Days,@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN       
				/******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary *****************************************/   
				IF(ISNULL(@Acq_Deal_Sport_Sales_Ancillary_Old_Code, 0) = 0)  
				BEGIN                 
					INSERT INTO Acq_Deal_Sport_Sales_Ancillary (
					Acq_Deal_Code, FRO_Given_Title_Sponsor, FRO_Given_Official_Sponsor, Title_FRO_No_of_Days, Title_FRO_Validity,  
					Price_Protection_Title_Sponsor, Price_Protection_Official_Sponsor, Last_Matching_Rights_Title_Sponsor,  
					Last_Matching_Rights_Official_Sponsor, Title_Last_Matching_Rights_Validity, Remarks, Official_FRO_No_of_Days,  
					Official_FRO_Validity, Official_Last_Matching_Rights_Validity)
					VALUES(@Acq_Deal_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,@Title_FRO_No_of_Days,@Title_FRO_Validity ,  
					@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,@Last_Matching_Rights_Title_Sponsor,  
					@Last_Matching_Rights_Official_Sponsor,@Title_Last_Matching_Rights_Validity,@SS_Remarks,@Official_FRO_No_of_Days,  
					@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity)  

					SELECT @Acq_Deal_Sport_Sales_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Sport_Sales_Ancillary')  
  
					UPDATE AT_Acq_Deal_Sport_Sales_Ancillary SET Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code   
					WHERE AT_Acq_Deal_Sport_Sales_Ancillary_Code  = @AT_Acq_Deal_Sport_Sales_Ancillary_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Sales_Ancillary] ON  
					INSERT INTO Acq_Deal_Sport_Sales_Ancillary(
					Acq_Deal_Sport_Sales_Ancillary_Code ,Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,  
					Title_FRO_Validity ,Price_Protection_Title_Sponsor,Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,  
					Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,Remarks,Official_FRO_No_of_Days,  
					Official_FRO_Validity,Official_Last_Matching_Rights_Validity)  
					VALUES(@Acq_Deal_Sport_Sales_Ancillary_Old_Code,@Acq_Deal_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,  
					@Title_FRO_No_of_Days,@Title_FRO_Validity ,@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,  
					@Last_Matching_Rights_Title_Sponsor,@Last_Matching_Rights_Official_Sponsor,@Title_Last_Matching_Rights_Validity,  
					@SS_Remarks,@Official_FRO_No_of_Days,@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity)  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Sales_Ancillary] OFF  
					SELECT @Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Old_Code  
				END       
  
				/**************** Insert into Acq_Deal_Sport_Sales_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Sales_Ancillary_Title(  
				Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAT.Title_Code,ADSSAT.Episode_From,ADSSAT.Episode_To  
				FROM AT_Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT WHERE ADSSAT.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Sales_Ancillary_Sponsor ****************/   
  
				INSERT INTO Acq_Deal_Sport_Sales_Ancillary_Sponsor(Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type)  
				SELECT @Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAS.Sponsor_Code,ADSSAS.Sponsor_Type  
				FROM AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor ADSSAS 
				WHERE ADSSAS.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code  
  
  
				FETCH NEXT FROM sport_sales_anci_cursor  
				INTO @AT_Acq_Deal_Sport_Sales_Ancillary_Code,@Acq_Deal_Sport_Sales_Ancillary_Old_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,@Title_FRO_No_of_Days,@Title_FRO_Validity ,  
				@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,@Last_Matching_Rights_Title_Sponsor,@Last_Matching_Rights_Official_Sponsor,  
				@Title_Last_Matching_Rights_Validity,@SS_Remarks,@Official_FRO_No_of_Days,@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity  
			END  
			CLOSE sport_sales_anci_cursor  
			DEALLOCATE sport_sales_anci_cursor  
  
			/******************************** Delete from Acq_Deal_Payment_Terms *****************************************/  
			DELETE FROM Acq_Deal_Payment_Terms WHERE Acq_Deal_Code = @Acq_Deal_Code  
			/******************************** Insert into Acq_Deal_Payment_Terms *****************************************/     
			INSERT INTO Acq_Deal_Payment_Terms  
			(  
				Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, [Percentage], Amount, Due_Date, Inserted_On,   
				Inserted_By, Last_Updated_Time, Last_Action_By  
			)  
			SELECT  
				@Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, [Percentage], Amount, Due_Date,   
				Inserted_On, Inserted_By, GETDATE(), @User_Code  
			FROM AT_Acq_Deal_Payment_Terms WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Payment_Terms_Code,0) = 0  
     
			SET IDENTITY_INSERT [Acq_Deal_Payment_Terms] ON                     
			INSERT INTO Acq_Deal_Payment_Terms (
			Acq_Deal_Payment_Terms_Code,Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date,   
			Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
			SELECT Acq_Deal_Payment_Terms_Code,@Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date, Inserted_On, Inserted_By, GETDATE(), @User_Code  
			FROM AT_Acq_Deal_Payment_Terms WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code     
			AND ISNULL(Acq_Deal_Payment_Terms_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Payment_Terms] OFF     
     
			/******************************** Delete from  Acq_Deal_Attachment *****************************************/   
			DELETE FROM Acq_Deal_Attachment WHERE Acq_Deal_Code = @Acq_Deal_Code  
			DECLARE @Acq_Deal_Attachment_Code INT = 0  
			/******************************** Insert into Acq_Deal_Attachment *****************************************/   
			INSERT INTO Acq_Deal_Attachment(
			Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To)  
			SELECT @Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Attachment WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Attachment_Code,0) = 0  
  
			SET IDENTITY_INSERT [Acq_Deal_Attachment] ON                     
			INSERT INTO Acq_Deal_Attachment(
			Acq_Deal_Attachment_Code,Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code,   
			Episode_From, Episode_To)  
			SELECT Acq_Deal_Attachment_Code,@Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name,   
			Document_Type_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Attachment WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code    
			AND ISNULL(Acq_Deal_Attachment_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Attachment] OFF   
     
			/******************************** Delete from Acq_Deal_Material *****************************************/   
			DELETE FROM Acq_Deal_Material WHERE Acq_Deal_Code = @Acq_Deal_Code  
			/******************************** Insert into Acq_Deal_Material *****************************************/         
			INSERT INTO Acq_Deal_Material(  
			Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time,   
			Last_Updated_Time, Last_Action_By, Episode_From, Episode_To)  
			SELECT @Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time,   
			GETDATE(), @User_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Material WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Material_Code,0) = 0  
  
			SET IDENTITY_INSERT [Acq_Deal_Material] ON                     
			INSERT INTO Acq_Deal_Material(  
			Acq_Deal_Material_Code,Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time,   
			Last_Updated_Time, Last_Action_By, Episode_From, Episode_To)  
			SELECT Acq_Deal_Material_Code,@Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On,   
			Inserted_By, Lock_Time, GETDATE(), @User_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Material WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code      
			AND ISNULL(Acq_Deal_Material_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Material] OFF      
 
			/******************************** Delete from Acq_Deal_Budget *****************************************/   
			DELETE FROM Acq_Deal_Budget WHERE Acq_Deal_Code = @Acq_Deal_Code  
     
			/******************************** Insert into Acq_Deal_Budget *****************************************/   
			INSERT INTO Acq_Deal_Budget(
			Acq_Deal_Code, Title_Code, Episode_From, Episode_To,SAP_WBS_Code)  
			SELECT @Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code  
			FROM AT_Acq_Deal_Budget WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Budget_Code,0) = 0  
  
			SET IDENTITY_INSERT [Acq_Deal_Budget] ON                     
			INSERT INTO Acq_Deal_Budget(
			Acq_Deal_Budget_Code,Acq_Deal_Code, Title_Code, Episode_From, Episode_To,SAP_WBS_Code)  
			SELECT Acq_Deal_Budget_Code,@Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code  
			FROM AT_Acq_Deal_Budget WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Budget_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Budget] OFF      
			/***********************************************************************************************/  
			--Drop Table #TempRights  
		END

		COMMIT 
		  
		SELECT 'S' Flag, 'Success' Msg ,0
		UPDATE
			DP
		SET 
			DP.Record_Status = 'D',
			DP.Porcess_End = GETDATE() ,
			DP.Version_No = AD.Version
		FROM
			Acq_Deal AS AD INNER JOIN Deal_Process AS DP ON AD.Acq_Deal_Code = DP.Deal_Code
		WHERE 
			DP.Deal_Code = @Acq_Deal_Code And DP.Record_Status  = 'W' AND DP.Module_Code = 30

	END TRY  
	BEGIN CATCH  
		ROLLBACK  

		SELECT 'E' Flag, ERROR_MESSAGE() as Msg,ERROR_LINE() AS ErrorLine  
		Update Deal_Process Set Record_Status  = 'E', Porcess_End = GETDATE(), Error_Messages = ERROR_MESSAGE() WHERE Deal_Code = @Acq_Deal_Code And Record_Status  = 'W'  AND Module_Code = 30
	END CATCH
END
