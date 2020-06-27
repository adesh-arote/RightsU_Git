CREATE PROCEDURE USPArchiveUnArchive
--DECLARE 
@UserCode INT,
@Acq_Deal_Code INT=2036,
@ArchiveUnArchive CHAR(1)='A'
AS
BEGIN 
 BEGIN TRY
   
IF(@ArchiveUnArchive='A')
    BEGIN
        /******************************** Insert into AR_Acq_Deal, Delete from Acq_Deal*****************************************/ 
       INSERT INTO AR_Acq_Deal (Acq_Deal_Code,Agreement_No,Version,Agreement_Date,Deal_Desc,Deal_Type_Code,Year_Type,Entity_Code,Is_Master_Deal,Category_Code,Vendor_Code,Vendor_Contacts_Code,Currency_Code,Exchange_Rate,Ref_No,Attach_Workflow,Deal_Workflow_Status,Parent_Deal_Code,Work_Flow_Code,Amendment_Date,Is_Released,Release_On,Release_By,Is_Completed,Is_Active,Content_Type,Payment_Terms_Conditions,Status,
       Is_Auto_Generated,Is_Migrated,Cost_Center_Id,Master_Deal_Movie_Code_ToLink,BudgetWise_Costing_Applicable,Validate_CostWith_Budget,Deal_Tag_Code,Business_Unit_Code,Ref_BMS_Code,Remarks,Rights_Remarks,Payment_Remarks,Deal_Complete_Flag,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,Lock_Time,All_Channel,Role_Code,Channel_Cluster_Code,Is_Auto_Push) 
       SELECT Acq_Deal_Code,Agreement_No,Version,Agreement_Date,Deal_Desc,Deal_Type_Code,Year_Type,Entity_Code,Is_Master_Deal,Category_Code,Vendor_Code,Vendor_Contacts_Code,Currency_Code,Exchange_Rate,Ref_No,Attach_Workflow,Deal_Workflow_Status,Parent_Deal_Code,Work_Flow_Code,Amendment_Date,Is_Released,Release_On,Release_By,Is_Completed,Is_Active,Content_Type,Payment_Terms_Conditions,Status,
       Is_Auto_Generated,Is_Migrated,Cost_Center_Id,Master_Deal_Movie_Code_ToLink,BudgetWise_Costing_Applicable,Validate_CostWith_Budget,Deal_Tag_Code,Business_Unit_Code,Ref_BMS_Code,Remarks,Rights_Remarks,Payment_Remarks,Deal_Complete_Flag,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,Lock_Time,All_Channel,Role_Code,Channel_Cluster_Code,Is_Auto_Push 
       FROM Acq_Deal where Acq_Deal_Code=@Acq_Deal_Code 
        
       /******************************** Insert into AR_Acq_Deal_Ancillary, Delete from Acq_Deal_Ancillary*****************************************/ 
       INSERT INTO AR_Acq_Deal_Ancillary(Acq_Deal_Ancillary_Code,Acq_Deal_Code,Ancillary_Type_code,Duration,Day,Remarks,Group_No,Catch_Up_From) 
       SELECT Acq_Deal_Ancillary_Code,Acq_Deal_Code,Ancillary_Type_code,Duration,Day,Remarks,Group_No,Catch_Up_From 
	   FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code 
    
       /******************************** Insert into AR_Acq_Deal_Movie, Delete from Acq_Deal_Movie*****************************************/ 
          
       INSERT INTO AR_Acq_Deal_Movie(
    		Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
    		Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction)
    	SELECT Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
    		Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction
    	FROM Acq_Deal_Movie WHERE Acq_Deal_Code = @Acq_Deal_Code
    
    	 /******************************** Insert into AR_Acq_Deal_Rights, Delete from Acq_Deal_Rights*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Rights (Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
    		Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
    		Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date,
    		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag)
    	SELECT Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
    		Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
    		Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
    		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag
    	FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code
    	
		    		-------------------Insert for AR_Acq_Deal_Rights_Title ---------------------	
    	INSERT INTO AR_Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To,Acq_Deal_Rights_Title_Code)
    	SELECT Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To,Acq_Deal_Rights_Title_Code
    	FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	
    		-------------------Insert for AR_Acq_Deal_Rights_Title_Eps ---------------------	 
    	INSERT INTO AR_Acq_Deal_Rights_Title_EPS (
    		Acq_Deal_Rights_Title_EPS_Code,Acq_Deal_Rights_Title_Code, EPS_No)
    	SELECT	Acq_Deal_Rights_Title_EPS_Code,Acq_Deal_Rights_Title_Code, EPS_No
    	FROM Acq_Deal_Rights_Title_EPS WHERE Acq_Deal_Rights_Title_Code IN (SELECT Acq_Deal_Rights_Title_Code FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    
    	-------------------Insert for  AR_Acq_Deal_Rights_Platform -------------------
    	INSERT INTO AR_Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code,Acq_Deal_Rights_Platform_Code)	
    	SELECT Acq_Deal_Rights_Code, Platform_Code,Acq_Deal_Rights_Platform_Code
    	FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	
    	
    		-------------------Insert for AR_Acq_Deal_Rights_Territory ----------------------
    	INSERT INTO AR_Acq_Deal_Rights_Territory (Acq_Deal_Rights_Territory_Code, Acq_Deal_Rights_Code, Territory_Type, Country_Code , Territory_Code)	
    	SELECT Acq_Deal_Rights_Territory_Code, Acq_Deal_Rights_Code, Territory_Type, Country_Code , Territory_Code
    	FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	
		
    		--------------------Insert for AR_Acq_Deal_Rights_Subtitling ----------------------
    	INSERT INTO AR_Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type ,Acq_Deal_Rights_Subtitling_Code)	
    	SELECT Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type ,Acq_Deal_Rights_Subtitling_Code
    	FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	
    		--------------------Insert for  AR_Acq_Deal_Rights_Dubbing -------------------------
    		INSERT INTO AR_Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Dubbing_Code,Acq_Deal_Rights_Code, Language_Type, Language_Code ,Language_Group_Code)	
    	SELECT Acq_Deal_Rights_Dubbing_Code,Acq_Deal_Rights_Code, Language_Type, Language_Code ,Language_Group_Code
    	FROM Acq_Deal_Rights_Dubbing  WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    		
    		--------------------Insert for AR_Acq_Deal_Rights_Error_Details -------------------------
    		INSERT INTO AR_Acq_Deal_Rights_Error_Details(Acq_Deal_Rights_Error_Details_Code,Acq_Deal_Rights_Code,Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To,Is_Updated,Inserted_On)
    		SELECT Acq_Deal_Rights_Error_Details_Code,Acq_Deal_Rights_Code,Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To,Is_Updated,Inserted_On
    		FROM Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    
    		--------------------Insert for AR_Acq_Deal_Rights_Holdback -------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Holdback(Acq_Deal_Rights_Holdback_Code,Acq_Deal_Rights_Code,Holdback_Type,HB_Run_After_Release_No,HB_Run_After_Release_Units,Holdback_On_Platform_Code,Holdback_Release_Date,Holdback_Comment,Is_Title_Language_Right)
    	SELECT Acq_Deal_Rights_Holdback_Code,Acq_Deal_Rights_Code,Holdback_Type,HB_Run_After_Release_No,HB_Run_After_Release_Units,Holdback_On_Platform_Code,Holdback_Release_Date,Holdback_Comment,Is_Title_Language_Right
    	FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    		
    		---------------------Insert for AR_Acq_Deal_Rights_Holdback_Dubbing ------------------
    	INSERT INTO AR_Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Dubbing_Code,Acq_Deal_Rights_Holdback_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Holdback_Dubbing_Code,Acq_Deal_Rights_Holdback_Code,Language_Code 
    	FROM Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    		
    		
    		---------------------Insert for  AR_Acq_Deal_Rights_Holdback_Platform ------------------
    	INSERT INTO AR_Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Platform_Code,Acq_Deal_Rights_Holdback_Code,Platform_Code)
    	SELECT Acq_Deal_Rights_Holdback_Platform_Code,Acq_Deal_Rights_Holdback_Code,Platform_Code 
    	FROM Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    
    	   ---------------------Insert for AR_Acq_Deal_Rights_Holdback_Subtitling ----------------------
    	INSERT INTO AR_Acq_Deal_Rights_Holdback_Subtitling(Acq_Deal_Rights_Holdback_Subtitling_Code,Acq_Deal_Rights_Holdback_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Holdback_Subtitling_Code,Acq_Deal_Rights_Holdback_Code,Language_Code
    	FROM Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	
    	----------------------Insert for AR_Acq_Deal_Rights_Holdback_Territory -----------------------
    	INSERT INTO AR_Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Territory_Code,Acq_Deal_Rights_Holdback_Code,Territory_Type,Country_Code,Territory_Code)
    	SELECT Acq_Deal_Rights_Holdback_Territory_Code,Acq_Deal_Rights_Holdback_Code,Territory_Type,Country_Code,Territory_Code
    	FROM Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    
    	----------------------Insert for AR_Acq_Deal_Rights_Blackout ----------------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Blackout(Acq_Deal_Rights_Blackout_Code,Acq_Deal_Rights_Code,Start_Date,End_Date,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Rights_Blackout_Code,Acq_Deal_Rights_Code,Start_Date,End_Date,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By 
    	FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	----------------------Insert for AR_Acq_Deal_Rights_Blackout_Subtitling ----------------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Subtitling_Code,Acq_Deal_Rights_Blackout_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Blackout_Subtitling_Code,Acq_Deal_Rights_Blackout_Code,Language_Code 
    	FROM Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    
    			-----------------------Insert for AR_Acq_Deal_Rights_Blackout_Dubbing --------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Dubbing_Code,Acq_Deal_Rights_Blackout_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Blackout_Dubbing_Code,Acq_Deal_Rights_Blackout_Code,Language_Code 
    	FROM Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    
    	------------------------Insert for AR_Acq_Deal_Rights_Blackout_Platform ------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Platform_Code,Acq_Deal_Rights_Blackout_Code,Platform_Code)
    	SELECT Acq_Deal_Rights_Blackout_Platform_Code,Acq_Deal_Rights_Blackout_Code,Platform_Code 
    	FROM Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	
    	--------------------------Insert for AR_Acq_Deal_Rights_Blackout_Territory ------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Territory_Code,Acq_Deal_Rights_Blackout_Code,Territory_Type,Country_Code,Territory_Code)
    	SELECT Acq_Deal_Rights_Blackout_Territory_Code,Acq_Deal_Rights_Blackout_Code,Territory_Type,Country_Code,Territory_Code 
    	FROM Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    
    		----------------------Insert for AR_Acq_Deal_Rights_Promoter ----------------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Promoter (Acq_Deal_Rights_Promoter_Code,Acq_Deal_Rights_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Rights_Promoter_Code,Acq_Deal_Rights_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By 
    	FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
       		-----------------------Insert for AR_Acq_Deal_Rights_Promoter_Group --------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Promoter_Group (Acq_Deal_Rights_Promoter_Group_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Group_Code)
    	SELECT Acq_Deal_Rights_Promoter_Group_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Group_Code 
    	FROM Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	
    		-----------------------Insert for AR_Acq_Deal_Rights_Promoter_Remarks --------------------------
    	INSERT INTO AR_Acq_Deal_Rights_Promoter_Remarks (Acq_Deal_Rights_Promoter_Remarks_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Remarks_Code)
    	SELECT Acq_Deal_Rights_Promoter_Remarks_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Remarks_Code 
    	FROM Acq_Deal_Rights_Promoter_Remarks WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    
    		---------------------------Insert for AR_Acq_Deal_Pushback ------------------------------------------
    	INSERT INTO AR_Acq_Deal_Pushback(Acq_Deal_Pushback_Code, Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_Title_Language_Right,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Pushback_Code, Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_Title_Language_Right,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By
    	FROM Acq_Deal_Pushback WHERE Acq_Deal_Code=@Acq_Deal_Code
    		
				---------------------------Insert for AR_Acq_Deal_Pushback_Dubbing -----------------------------------
    	INSERT INTO AR_Acq_Deal_Pushback_Dubbing(Acq_Deal_Pushback_Dubbing_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code)
        SELECT Acq_Deal_Pushback_Dubbing_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code
        FROM Acq_Deal_Pushback_Dubbing WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    
    	
    	---------------------------Insert for AR_Acq_Deal_Pushback_Platform ----------------------------------
    	INSERT INTO AR_Acq_Deal_Pushback_Platform(Acq_Deal_Pushback_Platform_Code,Acq_Deal_Pushback_Code,Platform_Code)
    	SELECT Acq_Deal_Pushback_Platform_Code,Acq_Deal_Pushback_Code,Platform_Code FROM Acq_Deal_Pushback_Platform
    	WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    
    	
    	----------------------------Insert for AR_Acq_Deal_Pushback_Subtitling --------------------------------
    	INSERT INTO AR_Acq_Deal_Pushback_Subtitling(Acq_Deal_Pushback_Subtitling_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code)
    	SELECT Acq_Deal_Pushback_Subtitling_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code 
    	FROM Acq_Deal_Pushback_Subtitling WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    
    	-----------------------------Insert for AR_Acq_Deal_Pushback_Territory ---------------------------------
    	INSERT INTO AR_Acq_Deal_Pushback_Territory(Acq_Deal_Pushback_Territory_Code,Acq_Deal_Pushback_Code,Territory_Type,Country_Code,Territory_Code)
    	SELECT  Acq_Deal_Pushback_Territory_Code,Acq_Deal_Pushback_Code,Territory_Type,Country_Code,Territory_Code
    	FROM Acq_Deal_Pushback_Territory WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    
    	------------------------------Insert for AR_Acq_Deal_Pushback_Title -------------------------------------
    	INSERT INTO AR_Acq_Deal_Pushback_Title(Acq_Deal_Pushback_Title_Code,Acq_Deal_Pushback_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Pushback_Title_Code,Acq_Deal_Pushback_Code,Title_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Pushback_Title WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    		
        /******************************** Insert into AR_Acq_Deal_Ancillary_Platform, Delete from Acq_Deal_Ancillary_Platform*****************************************/  
       INSERT INTO AR_Acq_Deal_Ancillary_Platform(Acq_Deal_Ancillary_Platform_Code,Acq_Deal_Ancillary_Code,Ancillary_Platform_code,Platform_Code) 
       SELECT Acq_Deal_Ancillary_Platform_Code,Acq_Deal_Ancillary_Code,Ancillary_Platform_code,Platform_Code from Acq_Deal_Ancillary_Platform 
       where Acq_Deal_Ancillary_Code IN(SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )
      
    
        /******************************** Insert into AR_Acq_Deal_Ancillary_Platform_Medium, Delete from Acq_Deal_Ancillary_Platform_Medium*****************************************/ 
        INSERT INTO AR_Acq_Deal_Ancillary_Platform_Medium(Acq_Deal_Ancillary_Platform_Medium_Code,Acq_Deal_Ancillary_Platform_Code,Ancillary_Platform_Medium_Code) SELECT Acq_Deal_Ancillary_Platform_Medium_Code,Acq_Deal_Ancillary_Platform_Code,Ancillary_Platform_Medium_Code 
    	FROM Acq_Deal_Ancillary_Platform_Medium 
       where Acq_Deal_Ancillary_Platform_Code IN (Select Acq_Deal_Ancillary_Platform_Code FROM Acq_Deal_Ancillary_Platform WHERE Acq_Deal_Ancillary_Code IN(SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code))
        
    
       /******************************** Insert into AR_Acq_Deal_Ancillary_Title, Delete from Acq_Deal_Ancillary_Title*****************************************/ 
       INSERT INTO AR_Acq_Deal_Ancillary_Title(Acq_Deal_Ancillary_Title_Code,Acq_Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To)
        SELECT Acq_Deal_Ancillary_Title_Code,Acq_Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To 
    	FROM Acq_Deal_Ancillary_Title WHERE Acq_Deal_Ancillary_Code IN (SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )
    	
    	/******************************** Insert into AR_Acq_Deal_Attachment*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Attachment(Acq_Deal_Attachment_Code,Acq_Deal_Code,Title_Code,Attachment_Title,Attachment_File_Name,System_File_Name,Document_Type_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Attachment_Code,Acq_Deal_Code,Title_Code,Attachment_Title,Attachment_File_Name,System_File_Name,Document_Type_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Attachment WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
    	/******************************** Insert into AR_Acq_Deal_Budget*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Budget(Acq_Deal_Budget_Code,Acq_Deal_Code,Title_Code,Episode_From,Episode_To,SAP_WBS_Code)
    	SELECT Acq_Deal_Budget_Code,Acq_Deal_Code,Title_Code,Episode_From,Episode_To,SAP_WBS_Code
    	FROM Acq_Deal_Budget WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
    	/******************************** Insert into AR_Acq_Deal_Cost*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Cost(Acq_Deal_Cost_Code,Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate,Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,Additional_Cost,Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By,Incentive,Remarks)
    	SELECT Acq_Deal_Cost_Code,Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate,Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,Additional_Cost,Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By,Incentive,Remarks
    	FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code
    
	
    	/******************************** Insert into AR_Acq_Deal_Cost_Additional_Exp*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Cost_Additional_Exp(Acq_Deal_Cost_Additional_Exp_Code,Acq_Deal_Cost_Code,Additional_Expense_Code,Amount,Min_Max,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Cost_Additional_Exp_Code,Acq_Deal_Cost_Code,Additional_Expense_Code,Amount,Min_Max,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM Acq_Deal_Cost_Additional_Exp WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Cost_Commission*****************************************/ 
    	
    	INSERT INTO AR_Acq_Deal_Cost_Commission(Acq_Deal_Cost_Commission_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Royalty_Commission_Code,Vendor_Code,Entity_Code,Type,Commission_Type,Percentage,Amount)
    	SELECT Acq_Deal_Cost_Commission_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Royalty_Commission_Code,Vendor_Code,Entity_Code,Type,Commission_Type,Percentage,Amount
    	FROM Acq_Deal_Cost_Commission WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Cost_Costtype*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Cost_Costtype(Acq_Deal_Cost_Costtype_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Amount,Consumed_Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Cost_Costtype_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Amount,Consumed_Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	
    	/******************************** Insert into AR_Acq_Deal_Cost_Costtype_Episode*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Cost_Costtype_Episode(Acq_Deal_Cost_Costtype_Episode_Code,Acq_Deal_Cost_Costtype_Code,Episode_From,Episode_To,Amount_Type,Amount,Percentage,Remarks,Per_Eps_Amount)
    	SELECT Acq_Deal_Cost_Costtype_Episode_Code,Acq_Deal_Cost_Costtype_Code,Episode_From,Episode_To,Amount_Type,Amount,Percentage,Remarks,Per_Eps_Amount
    	FROM Acq_Deal_Cost_Costtype_Episode WHERE Acq_Deal_Cost_Costtype_Code IN (SELECT Acq_Deal_Cost_Costtype_Code FROM Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	
    	/******************************** Insert into AR_Acq_Deal_Cost_Title*****************************************/ 
    		INSERT INTO AR_Acq_Deal_Cost_Title(Acq_Deal_Cost_Title_Code,Acq_Deal_Cost_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Cost_Title_Code,Acq_Deal_Cost_Code,Title_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Cost_Title WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	
    	/******************************** Insert into AR_Acq_Deal_Cost_Variable_Cost*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Cost_Variable_Cost(Acq_Deal_Cost_Variable_Cost_Code,Acq_Deal_Cost_Code,Entity_Code,Vendor_Code,Percentage,Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Cost_Variable_Cost_Code,Acq_Deal_Cost_Code,Entity_Code,Vendor_Code,Percentage,Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM Acq_Deal_Cost_Variable_Cost WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	
    
    	/******************************** Insert into AR_Acq_Deal_RUN*****************************************/ 
    			INSERT INTO AR_Acq_Deal_Run(Acq_Deal_Run_Code,Acq_Deal_Code,Run_Type,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Is_Yearwise_Definition,Is_Rule_Right,Right_Rule_Code,Repeat_Within_Days_Hrs,No_Of_Days_Hrs,Is_Channel_Definition_Rights,Primary_Channel_Code,Run_Definition_Type,Run_Definition_Group_Code,All_Channel,Prime_Start_Time,Prime_End_Time,Off_Prime_Start_Time,Off_Prime_End_Time,Time_Lag_Simulcast,Prime_Run,Off_Prime_Run,Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Channel_Type,Channel_Category_Code)
    		SELECT Acq_Deal_Run_Code,Acq_Deal_Code,Run_Type,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Is_Yearwise_Definition,Is_Rule_Right,Right_Rule_Code,Repeat_Within_Days_Hrs,No_Of_Days_Hrs,Is_Channel_Definition_Rights,Primary_Channel_Code,Run_Definition_Type,Run_Definition_Group_Code,All_Channel,Prime_Start_Time,Prime_End_Time,Off_Prime_Start_Time,Off_Prime_End_Time,Time_Lag_Simulcast,Prime_Run,Off_Prime_Run,Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Channel_Type,Channel_Category_Code
    		FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code
    		
        /******************************** Insert into AR_Acq_Deal_RUN_Channel*****************************************/ 
        INSERT INTO  AR_Acq_Deal_Run_Channel(Acq_Deal_Run_Channel_Code,Acq_Deal_Run_Code,Channel_Code,Min_Runs,Max_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Do_Not_Consume_Rights,Is_Primary,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time)
        SELECT Acq_Deal_Run_Channel_Code,Acq_Deal_Run_Code,Channel_Code,Min_Runs,Max_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Do_Not_Consume_Rights,Is_Primary,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
        FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	/******************************** Insert into AR_Acq_Deal_Run_Repeat_On_Day*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Run_Repeat_On_Day(Acq_Deal_Run_Repeat_On_Day_Code,Acq_Deal_Run_Code,Day_Code)
    	SELECT Acq_Deal_Run_Repeat_On_Day_Code,Acq_Deal_Run_Code,Day_Code 
    	FROM Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	 
    	/******************************** Insert into AR_Acq_Deal_Run_Shows*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Run_Shows(Acq_Deal_Run_Shows_Code,Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,Acq_Deal_Movie_Code,Inserted_By,Inserted_On)
    	SELECT Acq_Deal_Run_Shows_Code,Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,Acq_Deal_Movie_Code,Inserted_By,Inserted_On
    	FROM Acq_Deal_Run_Shows WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	/******************************** Insert into AR_Acq_Deal_Run_Title*****************************************/ 
    	INSERT INTO AR_Acq_Deal_Run_Title(Acq_Deal_Run_Title_Code,Acq_Deal_Run_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Run_Title_Code,Acq_Deal_Run_Code,Title_Code,Episode_From,Episode_To 
    	FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	
    	/******************************** Insert into AR_Acq_Deal_Run_Yearwise_Run*****************************************/
    	INSERT INTO  AR_Acq_Deal_Run_Yearwise_Run(Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Year_No)
    	SELECT Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Year_No
    	FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	/******************************** Insert into AR_Acq_Deal_Run_Yearwise_Run_Week*****************************************/
    	INSERT INTO  AR_Acq_Deal_Run_Yearwise_Run_Week(Acq_Deal_Run_Yearwise_Run_Week_Code,Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Week_Date,End_Week_Date,Is_Preferred,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time)
    	SELECT Acq_Deal_Run_Yearwise_Run_Week_Code,Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Week_Date,End_Week_Date,Is_Preferred,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
    	FROM Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    
    	
    	/******************************** Insert into AR_Acq_Deal_Sport*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport(Acq_Deal_Sport_Code,Acq_Deal_Code,Content_Delivery,Obligation_Broadcast,Deferred_Live,Deferred_Live_Duration,Tape_Delayed,Tape_Delayed_Duration,Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial,File_Name,Sys_File_Name,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,MBO_Note)
    	SELECT Acq_Deal_Sport_Code,Acq_Deal_Code,Content_Delivery,Obligation_Broadcast,Deferred_Live,Deferred_Live_Duration,Tape_Delayed,Tape_Delayed_Duration,Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial,File_Name,Sys_File_Name,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,MBO_Note
    	FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Ancillary*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Ancillary(Acq_Deal_Sport_Ancillary_Code,Acq_Deal_Code,Ancillary_For,Sport_Ancillary_Type_Code,Obligation_Broadcast,Broadcast_Window,Broadcast_Periodicity_Code,Sport_Ancillary_Periodicity_Code,Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks)
    	SELECT Acq_Deal_Sport_Ancillary_Code,Acq_Deal_Code,Ancillary_For,Sport_Ancillary_Type_Code,Obligation_Broadcast,Broadcast_Window,Broadcast_Periodicity_Code,Sport_Ancillary_Periodicity_Code,Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks
    	FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Ancillary_Broadcast*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Ancillary_Broadcast(Acq_Deal_Sport_Ancillary_Broadcast_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code)
    	SELECT Acq_Deal_Sport_Ancillary_Broadcast_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code
    	FROM Acq_Deal_Sport_Ancillary_Broadcast WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    		
    	/******************************** Insert into AR_Acq_Deal_Sport_Ancillary_Source*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Ancillary_Source(Acq_Deal_Sport_Ancillary_Source_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code)
    	SELECT Acq_Deal_Sport_Ancillary_Source_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code
    	FROM Acq_Deal_Sport_Ancillary_Source WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Ancillary_Title*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Ancillary_Title(Acq_Deal_Sport_Ancillary_Title_Code,Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Ancillary_Title_Code,Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Sport_Ancillary_Title WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Broadcast*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Broadcast(Acq_Deal_Sport_Broadcast_Code,Acq_Deal_Sport_Code,Broadcast_Mode_Code,Type)
    	SELECT Acq_Deal_Sport_Broadcast_Code,Acq_Deal_Sport_Code,Broadcast_Mode_Code,Type
    	FROM Acq_Deal_Sport_Broadcast WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Language*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Language(Acq_Deal_Sport_Language_Code,Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag)
    	SELECT Acq_Deal_Sport_Language_Code,Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag
    	FROM Acq_Deal_Sport_Language WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
	--SP_HELP Title_Content_Mapping
	--SP_HELP Acq_Deal_Movie_Content_Mapping
	--SP_HELP Acq_Deal_Movie
    	/******************************** Insert into AR_Acq_Deal_Movie_Content_Mapping*****************************************/
    	INSERT INTO AR_Acq_Deal_Movie_Content_Mapping(Acq_Deal_Movie_Content_Mapping_Code,Acq_Deal_Movie_Code,Title_Content_Code)
    	SELECT Acq_Deal_Movie_Content_Mapping_Code,Acq_Deal_Movie_Code,Title_Content_Code
    	FROM Acq_Deal_Movie_Content_Mapping WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Movie_Music*****************************************/
    	INSERT INTO AR_Acq_Deal_Movie_Music(Acq_Deal_Movie_Music_Code,Acq_Deal_Movie_Code,Music_Title_Code,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time)
    	SELECT Acq_Deal_Movie_Music_Code,Acq_Deal_Movie_Code,Music_Title_Code,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time
    	FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	
    	/******************************** Insert into AR_Acq_Deal_Movie_Music_Link*****************************************/
    	INSERT INTO AR_Acq_Deal_Movie_Music_Link(Acq_Deal_Movie_Music_Link_Code,Acq_Deal_Movie_Music_Code,Link_Acq_Deal_Movie_Code,Title_Code,Episode_No,No_Of_Play,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time)
    	SELECT Acq_Deal_Movie_Music_Link_Code,Acq_Deal_Movie_Music_Code,Link_Acq_Deal_Movie_Code,Title_Code,Episode_No,No_Of_Play,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time
    	FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (SELECT Acq_Deal_Movie_Music_Code FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	/******************************** Insert into AR_Acq_Deal_Payment_Terms*****************************************/
    	INSERT INTO AR_Acq_Deal_Payment_Terms(Acq_Deal_Payment_Terms_Code,Acq_Deal_Code,Cost_Type_Code,Payment_Term_Code,Days_After,Percentage,Amount,Due_Date,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Payment_Terms_Code,Acq_Deal_Code,Cost_Type_Code,Payment_Term_Code,Days_After,Percentage,Amount,Due_Date,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM Acq_Deal_Payment_Terms WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
    	/******************************** Insert into AR_Acq_Deal_Promoter_Import_Data*****************************************/
    	-- Acq_Deal_Promoter_Import_Data is in RightsU_Plus_Testing and not Rihtsu_Plus so commented for now
    	--INSERT INTO AR_Acq_Deal_Promoter_Import_Data(Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid)
    	--SELECT Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid
    	--FROM Acq_Deal_Promoter_Import_Data WHERE Agreement_No 
    
    	/******************************** Insert into AR_Acq_Deal_Ancillary_Import_Data*****************************************/
    	-- Acq_Deal_Promoter_Import_Data is in RightsU_Plus_Testing and not Rihtsu_Plus so commented for now
    	--INSERT INTO AR_Acq_Deal_Promoter_Import_Data(Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid)
    	--SELECT Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid
    	--FROM Acq_Deal_Promoter_Import_Data WHERE Agreement_No 
    
    	/******************************** Insert into AR_Acq_Deal_Licensor*****************************************/
    	INSERT INTO AR_Acq_Deal_Licensor(Acq_Deal_Licensor_Code,Acq_Deal_Code,Vendor_Code)
    	SELECT Acq_Deal_Licensor_Code,Acq_Deal_Code,Vendor_Code
    	FROM Acq_Deal_Licensor WHERE Acq_Deal_Code=@Acq_Deal_Code
    	/******************************** Insert into AR_Acq_Deal_Mass_Territory_Update*****************************************/
    	INSERT INTO AR_Acq_Deal_Mass_Territory_Update(Acq_Deal_Mass_Update_Code,Acq_Deal_Code,Date,Status,Processed_Date,Can_Process,Created_By)
    	SELECT Acq_Deal_Mass_Update_Code,Acq_Deal_Code,Date,Status,Processed_Date,Can_Process,Created_By
    	FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code
    	/******************************** Insert into AR_Acq_Deal_Mass_Territory_Update_Details*****************************************/
    	INSERT INTO AR_Acq_Deal_Mass_Territory_Update_Details(Acq_Deal_Mass_Update_Det_Code,Acq_Deal_Mass_Update_Code,Territory_Code)
    	SELECT Acq_Deal_Mass_Update_Det_Code,Acq_Deal_Mass_Update_Code,Territory_Code
    	FROM Acq_Deal_Mass_Territory_Update_Details WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	/******************************** Insert into AR_Acq_Deal_Mass_Update_ErrorLog*****************************************/
    	INSERT INTO AR_Acq_Deal_Mass_Update_ErrorLog(Error_Log_Code,Error_Message,Acq_Deal_Mass_Update_Code,Error_Date)
    	SELECT Error_Log_Code,Error_Message,Acq_Deal_Mass_Update_Code,Error_Date 
    	FROM Acq_Deal_Mass_Update_ErrorLog WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	/******************************** Insert into AR_Acq_Deal_Material*****************************************/
    	INSERT INTO AR_Acq_Deal_Material(Acq_Deal_Material_Code,Acq_Deal_Code,Title_Code,Material_Medium_Code,Material_Type_Code,Quantity,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Episode_From,Episode_To)
    	SELECT Acq_Deal_Material_Code,Acq_Deal_Code,Title_Code,Material_Medium_Code,Material_Type_Code,Quantity,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Episode_From,Episode_To
    	FROM Acq_Deal_Material WHERE Acq_Deal_Code=@Acq_Deal_Code
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Monetisation_Ancillary*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Monetisation_Ancillary(Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks)
    	SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks
    	FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    
    	 /******************************** Insert into AR_Acq_Deal_Sport_Monetisation_Ancillary_Title*****************************************/
    	 INSERT INTO AR_Acq_Deal_Sport_Monetisation_Ancillary_Title(Acq_Deal_Sport_Monetisation_Ancillary_Title_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Monetisation_Ancillary_Title_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Sport_Monetisation_Ancillary_Title WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM AR_Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Monetisation_Ancillary_Type*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Monetisation_Ancillary_Type(Acq_Deal_Sport_Monetisation_Ancillary_Type_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights)
    	SELECT Acq_Deal_Sport_Monetisation_Ancillary_Type_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights
    	FROM Acq_Deal_Sport_Monetisation_Ancillary_Type WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM AR_Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into  AR_Acq_Deal_Sport_Platform*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Platform(Acq_Deal_Sport_Platform_Code,Acq_Deal_Sport_Code,Platform_Code,Type)
    	SELECT Acq_Deal_Sport_Platform_Code,Acq_Deal_Sport_Code,Platform_Code,Type
    	FROM Acq_Deal_Sport_Platform  WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Sales_Ancillary*****************************************/
    	 INSERT INTO AR_Acq_Deal_Sport_Sales_Ancillary(Acq_Deal_Sport_Sales_Ancillary_Code,Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity)
    	SELECT Acq_Deal_Sport_Sales_Ancillary_Code,Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity
    	FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Sales_Ancillary_Sponsor*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Sales_Ancillary_Sponsor(Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type)
    	SELECT Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type
    	FROM Acq_Deal_Sport_Sales_Ancillary_Sponsor WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Sales_Ancillary_Title*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Sales_Ancillary_Title(Acq_Deal_Sport_Sales_Ancillary_Title_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Sales_Ancillary_Title_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Sport_Sales_Ancillary_Title WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Sport_Title*****************************************/
    	INSERT INTO AR_Acq_Deal_Sport_Title(Acq_Deal_Sport_Title_Code,Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Title_Code,Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To
    	FROM Acq_Deal_Sport_Title WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    
    	/******************************** Insert into AR_Acq_Deal_Tab_Version*****************************************/
    	INSERT INTO AR_Acq_Deal_Tab_Version(Acq_Deal_Tab_Version_Code,Version,Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By)
    	SELECT Acq_Deal_Tab_Version_Code,Version,Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By
    	FROM Acq_Deal_Tab_Version WHERE Acq_Deal_Code =@Acq_Deal_Code
    
    	/******************************** Insert into  AR_Acq_Deal_Termination_Details*****************************************/
    	INSERT INTO AR_Acq_Deal_Termination_Details(Acq_Deal_Termination_Details_Code,Acq_Deal_Code,Title_Code,Termination_Episode_No,Termination_Date,Users_Code,Created_Date)
    	SELECT Acq_Deal_Termination_Details_Code,Acq_Deal_Code,Title_Code,Termination_Episode_No,Termination_Date,Users_Code,Created_Date
    	FROM Acq_Deal_Termination_Details WHERE Acq_Deal_Code =@Acq_Deal_Code
    	
    
     	DELETE FROM Acq_Deal_Rights_Title_EPS WHERE Acq_Deal_Rights_Title_Code IN (SELECT Acq_Deal_Rights_Title_Code FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)) 	
    	DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Rights_Dubbing  WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
		DELETE FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)    	
    	DELETE FROM Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
		DELETE FROM Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM Acq_Deal_Rights_Promoter_Remarks WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
		DELETE FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM Acq_Deal_Pushback_Dubbing WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Pushback_Platform	WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Pushback_Subtitling WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Pushback_Territory WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Pushback_Title WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Pushback WHERE Acq_Deal_Code=@Acq_Deal_Code
		DELETE FROM Acq_Deal_Ancillary_Platform_Medium WHERE Acq_Deal_Ancillary_Platform_Code IN (Select Acq_Deal_Ancillary_Platform_Code FROM Acq_Deal_Ancillary_Platform WHERE Acq_Deal_Ancillary_Code IN(SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code))
		DELETE FROM Acq_Deal_Ancillary_Platform WHERE Acq_Deal_Ancillary_Code IN (SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )    	
        DELETE FROM Acq_Deal_Ancillary_Title WHERE  Acq_Deal_Ancillary_Code IN (SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )
		DELETE FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code 
    	DELETE FROM Acq_Deal_Attachment WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM Acq_Deal_Budget WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
		DELETE FROM Acq_Deal_Cost_Costtype_Episode WHERE Acq_Deal_Cost_Costtype_Code IN (SELECT Acq_Deal_Cost_Costtype_Code FROM Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE 	FROM Acq_Deal_Cost_Additional_Exp WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE 	FROM Acq_Deal_Cost_Commission WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Cost_Title WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Cost_Variable_Cost WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code
		    	
    	DELETE FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE 	FROM Acq_Deal_Run_Shows WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
		DELETE FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code

		DELETE FROM Acq_Deal_Sport_Platform  WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Ancillary_Broadcast WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Ancillary_Source WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Ancillary_Title WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Broadcast WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Language  WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	    	
    	DELETE FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (SELECT Acq_Deal_Movie_Music_Code FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code))
		DELETE FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Payment_Terms WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM Acq_Deal_Licensor WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
    	DELETE FROM Acq_Deal_Mass_Territory_Update_Details WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
        DELETE FROM Acq_Deal_Mass_Update_ErrorLog WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code
	    
    	DELETE FROM Acq_Deal_Material WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
    	DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary_Title WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary_Type WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    	
    	
    	DELETE FROM Acq_Deal_Sport_Sales_Ancillary_Sponsor WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM Acq_Deal_Sport_Sales_Ancillary_Title WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM Acq_Deal_Sport_Title WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
		DELETE FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE  FROM Acq_Deal_Tab_Version WHERE Acq_Deal_Code =@Acq_Deal_Code
    	DELETE FROM Acq_Deal_Termination_Details WHERE Acq_Deal_Code =@Acq_Deal_Code
		DELETE FROM Acq_Deal_Movie_Content_Mapping WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
		
		DELETE FROM Title_Content_Mapping WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie  WHERE Acq_Deal_Code =@Acq_Deal_Code)
		DELETE FROM Acq_Deal_Movie  WHERE Acq_Deal_Code = @Acq_Deal_Code
    	DELETE FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code 
		DELETE FROM Acq_Deal where Acq_Deal_Code= @Acq_Deal_Code
    
    END
 ELSE 
    BEGIN
    
           /******************************** Insert into Acq_Deal, Delete from Acq_Deal*****************************************/ 
	 SET IDENTITY_INSERT Acq_Deal ON
       INSERT INTO Acq_Deal (Acq_Deal_Code,Agreement_No,Version,Agreement_Date,Deal_Desc,Deal_Type_Code,Year_Type,Entity_Code,Is_Master_Deal,Category_Code,Vendor_Code,Vendor_Contacts_Code,Currency_Code,Exchange_Rate,Ref_No,Attach_Workflow,Deal_Workflow_Status,Parent_Deal_Code,Work_Flow_Code,Amendment_Date,Is_Released,Release_On,Release_By,Is_Completed,Is_Active,Content_Type,Payment_Terms_Conditions,Status,
       Is_Auto_Generated,Is_Migrated,Cost_Center_Id,Master_Deal_Movie_Code_ToLink,BudgetWise_Costing_Applicable,Validate_CostWith_Budget,Deal_Tag_Code,Business_Unit_Code,Ref_BMS_Code,Remarks,Rights_Remarks,Payment_Remarks,Deal_Complete_Flag,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,Lock_Time,All_Channel,Role_Code,Channel_Cluster_Code,Is_Auto_Push) 
       SELECT Acq_Deal_Code,Agreement_No,Version,Agreement_Date,Deal_Desc,Deal_Type_Code,Year_Type,Entity_Code,Is_Master_Deal,Category_Code,Vendor_Code,Vendor_Contacts_Code,Currency_Code,Exchange_Rate,Ref_No,Attach_Workflow,Deal_Workflow_Status,Parent_Deal_Code,Work_Flow_Code,Amendment_Date,Is_Released,Release_On,Release_By,Is_Completed,Is_Active,Content_Type,Payment_Terms_Conditions,Status,
       Is_Auto_Generated,Is_Migrated,Cost_Center_Id,Master_Deal_Movie_Code_ToLink,BudgetWise_Costing_Applicable,Validate_CostWith_Budget,Deal_Tag_Code,Business_Unit_Code,Ref_BMS_Code,Remarks,Rights_Remarks,Payment_Remarks,Deal_Complete_Flag,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,Lock_Time,All_Channel,Role_Code,Channel_Cluster_Code,Is_Auto_Push 
       FROM AR_Acq_Deal where Acq_Deal_Code=@Acq_Deal_Code 
      SET IDENTITY_INSERT Acq_Deal OFF   

       /******************************** Insert into Acq_Deal_Ancillary, Delete from Acq_Deal_Ancillary*****************************************/ 
       SET IDENTITY_INSERT Acq_Deal_Ancillary ON
	   INSERT INTO Acq_Deal_Ancillary(Acq_Deal_Ancillary_Code,Acq_Deal_Code,Ancillary_Type_code,Duration,Day,Remarks,Group_No,Catch_Up_From) 
       SELECT Acq_Deal_Ancillary_Code,Acq_Deal_Code,Ancillary_Type_code,Duration,Day,Remarks,Group_No,Catch_Up_From 
       FROM AR_Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code
      SET IDENTITY_INSERT Acq_Deal_Ancillary OFF
    
       /******************************** Insert into Acq_Deal_Movie, Delete from Acq_Deal_Movie*****************************************/ 
       SET IDENTITY_INSERT Acq_Deal_Movie ON 
       INSERT INTO Acq_Deal_Movie(
    		Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
    		Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction)
    	SELECT Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
    		Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction
    	FROM AR_Acq_Deal_Movie WHERE Acq_Deal_Code = @Acq_Deal_Code
      SET IDENTITY_INSERT Acq_Deal_Movie OFF
    	
		 /******************************** Insert into Acq_Deal_Rights, Delete from Acq_Deal_Rights*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Rights ON 
		INSERT INTO Acq_Deal_Rights (Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
    		Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
    		Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date,
    		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag)
    	SELECT Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
    		Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
    		Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
    		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag
    	FROM AR_Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code
    	SET IDENTITY_INSERT Acq_Deal_Rights OFF 
    		
			-------------------Insert for Acq_Deal_Rights_Title ---------------------	
		SET IDENTITY_INSERT Acq_Deal_Rights_Title ON
    	INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To,Acq_Deal_Rights_Title_Code)
    	SELECT Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To,Acq_Deal_Rights_Title_Code
    	FROM AR_Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Rights_Title OFF

		-------------------Insert for Acq_Deal_Rights_Title_Eps ---------------------
		 --SP_HELP Acq_Deal_Rights_Title_EPS
		SET IDENTITY_INSERT Acq_Deal_Rights_Title_EPS ON         
         INSERT INTO Acq_Deal_Rights_Title_EPS (Acq_Deal_Rights_Title_Code,EPS_No,Acq_Deal_Rights_Title_EPS_Code)
         SELECT Acq_Deal_Rights_Title_Code,EPS_No,Acq_Deal_Rights_Title_EPS_Code 
       FROM AR_Acq_Deal_Rights_Title_EPS WHERE Acq_Deal_Rights_Title_Code IN (SELECT Acq_Deal_Rights_Title_Code FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code)) 	
         SET IDENTITY_INSERT Acq_Deal_Rights_Title_EPS OFF	
		 

    	-------------------Insert for Acq_Deal_Rights_Platform -------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Platform ON
    	INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code,Acq_Deal_Rights_Platform_Code)	
    	SELECT Acq_Deal_Rights_Code, Platform_Code,Acq_Deal_Rights_Platform_Code
    	FROM AR_Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Rights_Platform OFF

    		-------------------Insert for Acq_Deal_Rights_Territory ----------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Territory ON
    	INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Territory_Code, Acq_Deal_Rights_Code, Territory_Type, Country_Code , Territory_Code)	
    	SELECT Acq_Deal_Rights_Territory_Code, Acq_Deal_Rights_Code, Territory_Type, Country_Code , Territory_Code
    	FROM AR_Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Rights_Territory OFF

		--------------------Insert for Acq_Deal_Rights_Subtitling ----------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Subtitling ON    		
    	INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type ,Acq_Deal_Rights_Subtitling_Code)	
    	SELECT Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type ,Acq_Deal_Rights_Subtitling_Code
    	FROM AR_Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Rights_Subtitling OFF
				
				--------------------Insert for Acq_Deal_Rights_Dubbing -------------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Dubbing ON    
    		INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Dubbing_Code,Acq_Deal_Rights_Code, Language_Code, Language_Type ,Language_Group_Code)	
    	SELECT Acq_Deal_Rights_Dubbing_Code,Acq_Deal_Rights_Code, Language_Code, Language_Type ,Language_Group_Code
    	FROM AR_Acq_Deal_Rights_Dubbing  WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    		SET IDENTITY_INSERT Acq_Deal_Rights_Dubbing OFF

    		--------------------Insert for Acq_Deal_Rights_Error_Details -------------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Error_Details ON
    		INSERT INTO Acq_Deal_Rights_Error_Details(Acq_Deal_Rights_Error_Details_Code,Acq_Deal_Rights_Code,Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To,Is_Updated,Inserted_On)
    		SELECT Acq_Deal_Rights_Error_Details_Code,Acq_Deal_Rights_Code,Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To,Is_Updated,Inserted_On
    		FROM AR_Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
            SET IDENTITY_INSERT Acq_Deal_Rights_Error_Details OFF

    		--------------------Insert for Acq_Deal_Rights_Holdback -------------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Holdback ON
    	INSERT INTO Acq_Deal_Rights_Holdback(Acq_Deal_Rights_Holdback_Code,Acq_Deal_Rights_Code,Holdback_Type,HB_Run_After_Release_No,HB_Run_After_Release_Units,Holdback_On_Platform_Code,Holdback_Release_Date,Holdback_Comment,Is_Title_Language_Right)
    	SELECT Acq_Deal_Rights_Holdback_Code,Acq_Deal_Rights_Code,Holdback_Type,HB_Run_After_Release_No,HB_Run_After_Release_Units,Holdback_On_Platform_Code,Holdback_Release_Date,Holdback_Comment,Is_Title_Language_Right
    	FROM AR_Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    		SET IDENTITY_INSERT Acq_Deal_Rights_Holdback OFF

    		---------------------Insert for Acq_Deal_Rights_Holdback_Dubbing ------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Dubbing ON
    	INSERT INTO Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Dubbing_Code,Acq_Deal_Rights_Holdback_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Holdback_Dubbing_Code,Acq_Deal_Rights_Holdback_Code,Language_Code 
    	FROM AR_Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    		SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Dubbing OFF
    		
    		---------------------Insert for Acq_Deal_Rights_Holdback_Platform ------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Platform ON
    	INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Platform_Code,Acq_Deal_Rights_Holdback_Code,Platform_Code)
    	SELECT Acq_Deal_Rights_Holdback_Platform_Code,Acq_Deal_Rights_Holdback_Code,Platform_Code 
    	FROM AR_Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
          SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Platform OFF

    	   ---------------------Insert for Acq_Deal_Rights_Holdback_Subtitling ----------------------
       SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Subtitling ON
    	INSERT INTO Acq_Deal_Rights_Holdback_Subtitling(Acq_Deal_Rights_Holdback_Subtitling_Code,Acq_Deal_Rights_Holdback_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Holdback_Subtitling_Code,Acq_Deal_Rights_Holdback_Code,Language_Code
    	FROM AR_Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Subtitling OFF

    	----------------------Insert for Acq_Deal_Rights_Holdback_Territory -----------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Territory ON
    	INSERT INTO Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Territory_Code,Acq_Deal_Rights_Holdback_Code,Territory_Type,Country_Code,Territory_Code)
    	SELECT Acq_Deal_Rights_Holdback_Territory_Code,Acq_Deal_Rights_Holdback_Code,Territory_Type,Country_Code,Territory_Code
    	FROM AR_Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
        SET IDENTITY_INSERT Acq_Deal_Rights_Holdback_Territory OFF

    	----------------------Insert for Acq_Deal_Rights_Blackout ----------------------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Blackout ON
    	INSERT INTO Acq_Deal_Rights_Blackout(Acq_Deal_Rights_Blackout_Code,Acq_Deal_Rights_Code,Start_Date,End_Date,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Rights_Blackout_Code,Acq_Deal_Rights_Code,Start_Date,End_Date,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By 
    	FROM AR_Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
        SET IDENTITY_INSERT Acq_Deal_Rights_Blackout OFF

    	----------------------Insert for Acq_Deal_Rights_Blackout_Subtitling ----------------------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Subtitling ON
    	INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Subtitling_Code,Acq_Deal_Rights_Blackout_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Blackout_Subtitling_Code,Acq_Deal_Rights_Blackout_Code,Language_Code 
    	FROM AR_Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
        SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Subtitling OFF

    			-----------------------Insert for Acq_Deal_Rights_Blackout_Dubbing --------------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Dubbing ON
    	INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Dubbing_Code,Acq_Deal_Rights_Blackout_Code,Language_Code)
    	SELECT Acq_Deal_Rights_Blackout_Dubbing_Code,Acq_Deal_Rights_Blackout_Code,Language_Code 
    	FROM AR_Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
        SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Dubbing OFF

    	------------------------Insert for Acq_Deal_Rights_Blackout_Platform ------------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Platform ON
    	INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Platform_Code,Acq_Deal_Rights_Blackout_Code,Platform_Code)
    	SELECT Acq_Deal_Rights_Blackout_Platform_Code,Acq_Deal_Rights_Blackout_Code,Platform_Code 
    	FROM AR_Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Platform OFF

    	--------------------------Insert for Acq_Deal_Rights_Blackout_Territory ------------------------
		SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Territory ON
    	INSERT INTO Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Territory_Code,Acq_Deal_Rights_Blackout_Code,Territory_Type,Country_Code,Territory_Code)
    	SELECT Acq_Deal_Rights_Blackout_Territory_Code,Acq_Deal_Rights_Blackout_Code,Territory_Type,Country_Code,Territory_Code 
    	FROM AR_Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
        SET IDENTITY_INSERT Acq_Deal_Rights_Blackout_Territory OFF

    		----------------------Insert for Acq_Deal_Rights_Promoter ----------------------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Promoter ON
    	INSERT INTO Acq_Deal_Rights_Promoter (Acq_Deal_Rights_Promoter_Code,Acq_Deal_Rights_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Rights_Promoter_Code,Acq_Deal_Rights_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By 
    	FROM AR_Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
       SET IDENTITY_INSERT Acq_Deal_Rights_Promoter OFF
	    
       		-----------------------Insert for Acq_Deal_Rights_Promoter_Group --------------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Promoter_Group ON
    	INSERT INTO Acq_Deal_Rights_Promoter_Group (Acq_Deal_Rights_Promoter_Group_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Group_Code)
    	SELECT Acq_Deal_Rights_Promoter_Group_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Group_Code 
    	FROM AR_Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	SET IDENTITY_INSERT Acq_Deal_Rights_Promoter_Group OFF

    		-----------------------Insert for Acq_Deal_Rights_Promoter_Remarks --------------------------
			SET IDENTITY_INSERT Acq_Deal_Rights_Promoter_Remarks ON
    	INSERT INTO Acq_Deal_Rights_Promoter_Remarks (Acq_Deal_Rights_Promoter_Remarks_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Remarks_Code)
    	SELECT Acq_Deal_Rights_Promoter_Remarks_Code,Acq_Deal_Rights_Promoter_Code,Promoter_Remarks_Code 
    	FROM AR_Acq_Deal_Rights_Promoter_Remarks WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
         SET IDENTITY_INSERT Acq_Deal_Rights_Promoter_Remarks OFF

    		---------------------------Insert for Acq_Deal_Pushback ------------------------------------------
			SET IDENTITY_INSERT Acq_Deal_Pushback ON
    	INSERT INTO Acq_Deal_Pushback(Acq_Deal_Pushback_Code, Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_Title_Language_Right,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Pushback_Code, Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_Title_Language_Right,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By 
    	FROM AR_Acq_Deal_Pushback WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Pushback OFF
    		
    	---------------------------Insert for Acq_Deal_Pushback_Dubbing -----------------------------------
		SET IDENTITY_INSERT Acq_Deal_Pushback_Dubbing ON
    	INSERT INTO Acq_Deal_Pushback_Dubbing(Acq_Deal_Pushback_Dubbing_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code)
        SELECT Acq_Deal_Pushback_Dubbing_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code
        FROM AR_Acq_Deal_Pushback_Dubbing WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Pushback_Dubbing OFF	

    	---------------------------Insert for Acq_Deal_Pushback_Platform ----------------------------------
		SET IDENTITY_INSERT Acq_Deal_Pushback_Platform ON
    	INSERT INTO Acq_Deal_Pushback_Platform(Acq_Deal_Pushback_Platform_Code,Acq_Deal_Pushback_Code,Platform_Code)
    	SELECT Acq_Deal_Pushback_Platform_Code,Acq_Deal_Pushback_Code,Platform_Code FROM Acq_Deal_Pushback_Platform
    	WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Pushback_Platform OFF

    	----------------------------Insert for Acq_Deal_Pushback_Subtitling --------------------------------
		SET IDENTITY_INSERT Acq_Deal_Pushback_Subtitling ON
    	INSERT INTO Acq_Deal_Pushback_Subtitling(Acq_Deal_Pushback_Subtitling_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code)
    	SELECT Acq_Deal_Pushback_Subtitling_Code,Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code 
    	FROM AR_Acq_Deal_Pushback_Subtitling WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Pushback_Subtitling OFF

    	-----------------------------Insert for Acq_Deal_Pushback_Territory ---------------------------------
		SET IDENTITY_INSERT Acq_Deal_Pushback_Territory ON
    	INSERT INTO Acq_Deal_Pushback_Territory(Acq_Deal_Pushback_Territory_Code,Acq_Deal_Pushback_Code,Territory_Type,Country_Code,Territory_Code)
    	SELECT  Acq_Deal_Pushback_Territory_Code,Acq_Deal_Pushback_Code,Territory_Type,Country_Code,Territory_Code
    	FROM AR_Acq_Deal_Pushback_Territory WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Pushback_Territory OFF

    	------------------------------Insert for Acq_Deal_Pushback_Title -------------------------------------
		SET IDENTITY_INSERT Acq_Deal_Pushback_Title ON
    	INSERT INTO Acq_Deal_Pushback_Title(Acq_Deal_Pushback_Title_Code,Acq_Deal_Pushback_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Pushback_Title_Code,Acq_Deal_Pushback_Code,Title_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Pushback_Title WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Pushback_Title OFF	

        /******************************** Insert into Acq_Deal_Ancillary_Platform, Delete from Acq_Deal_Ancillary_Platform*****************************************/ 
		SET IDENTITY_INSERT Acq_Deal_Ancillary_Platform ON 
       INSERT INTO Acq_Deal_Ancillary_Platform(Acq_Deal_Ancillary_Platform_Code,Acq_Deal_Ancillary_Code,Ancillary_Platform_code,Platform_Code) 
       SELECT Acq_Deal_Ancillary_Platform_Code,Acq_Deal_Ancillary_Code,Ancillary_Platform_code,Platform_Code from Acq_Deal_Ancillary_Platform 
       where Acq_Deal_Ancillary_Code IN(SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )
       SET IDENTITY_INSERT Acq_Deal_Ancillary_Platform OFF
    
        /******************************** Insert into Acq_Deal_Ancillary_Platform_Medium, Delete from Acq_Deal_Ancillary_Platform_Medium*****************************************/ 
       SET IDENTITY_INSERT Acq_Deal_Ancillary_Platform_Medium ON
	    INSERT INTO Acq_Deal_Ancillary_Platform_Medium(Acq_Deal_Ancillary_Platform_Medium_Code,Acq_Deal_Ancillary_Platform_Code,Ancillary_Platform_Medium_Code) SELECT Acq_Deal_Ancillary_Platform_Medium_Code,Acq_Deal_Ancillary_Platform_Code,Ancillary_Platform_Medium_Code 
    	FROM Acq_Deal_Ancillary_Platform_Medium 
       where Acq_Deal_Ancillary_Platform_Code IN (Select Acq_Deal_Ancillary_Platform_Code FROM Acq_Deal_Ancillary_Platform WHERE Acq_Deal_Ancillary_Code IN(SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code))
        SET IDENTITY_INSERT Acq_Deal_Ancillary_Platform_Medium OFF

       /******************************** Insert into Acq_Deal_Ancillary_Title, Delete from Acq_Deal_Ancillary_Title*****************************************/ 
       SET IDENTITY_INSERT Acq_Deal_Ancillary_Title ON
	   INSERT INTO Acq_Deal_Ancillary_Title(Acq_Deal_Ancillary_Title_Code,Acq_Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To)
        SELECT Acq_Deal_Ancillary_Title_Code,Acq_Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To 
    	FROM AR_Acq_Deal_Ancillary_Title WHERE Acq_Deal_Ancillary_Code IN (SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )
    	SET IDENTITY_INSERT Acq_Deal_Ancillary_Title OFF

    	/******************************** Insert into Acq_Deal_Attachment*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Attachment ON
		INSERT INTO Acq_Deal_Attachment(Acq_Deal_Attachment_Code,Acq_Deal_Code,Title_Code,Attachment_Title,Attachment_File_Name,System_File_Name,Document_Type_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Attachment_Code,Acq_Deal_Code,Title_Code,Attachment_Title,Attachment_File_Name,System_File_Name,Document_Type_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Attachment WHERE Acq_Deal_Code=@Acq_Deal_Code
    	SET IDENTITY_INSERT Acq_Deal_Attachment OFF

    	/******************************** Insert into Acq_Deal_Budget*****************************************/
		SET IDENTITY_INSERT Acq_Deal_Budget ON 
    	INSERT INTO Acq_Deal_Budget(Acq_Deal_Budget_Code,Acq_Deal_Code,Title_Code,Episode_From,Episode_To,SAP_WBS_Code)
    	SELECT Acq_Deal_Budget_Code,Acq_Deal_Code,Title_Code,Episode_From,Episode_To,SAP_WBS_Code
    	FROM AR_Acq_Deal_Budget WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Budget OFF
    	
    	/******************************** Insert into Acq_Deal_Cost*****************************************/ 
		SET IDENTITY_INSERT Acq_Deal_Cost ON 
    	INSERT INTO Acq_Deal_Cost(Acq_Deal_Cost_Code,Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate,Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,Additional_Cost,Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By,Incentive,Remarks)
    	SELECT Acq_Deal_Cost_Code,Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate,Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,Additional_Cost,Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By,Incentive,Remarks
    	FROM AR_Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Cost OFF
    
    	/******************************** Insert into Acq_Deal_Cost_Additional_Exp*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Cost_Additional_Exp ON 
		INSERT INTO Acq_Deal_Cost_Additional_Exp(Acq_Deal_Cost_Additional_Exp_Code,Acq_Deal_Cost_Code,Additional_Expense_Code,Amount,Min_Max,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Cost_Additional_Exp_Code,Acq_Deal_Cost_Code,Additional_Expense_Code,Amount,Min_Max,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM AR_Acq_Deal_Cost_Additional_Exp WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Cost_Additional_Exp OFF
	 
    	/******************************** Insert into Acq_Deal_Cost_Commission*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Cost_Commission ON
    	INSERT INTO Acq_Deal_Cost_Commission(Acq_Deal_Cost_Commission_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Royalty_Commission_Code,Vendor_Code,Entity_Code,Type,Commission_Type,Percentage,Amount)
    	SELECT Acq_Deal_Cost_Commission_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Royalty_Commission_Code,Vendor_Code,Entity_Code,Type,Commission_Type,Percentage,Amount
    	FROM AR_Acq_Deal_Cost_Commission WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Cost_Commission OFF

    	/******************************** Insert into Acq_Deal_Cost_Costtype*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Cost_Costtype ON
		INSERT INTO Acq_Deal_Cost_Costtype(Acq_Deal_Cost_Costtype_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Amount,Consumed_Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Cost_Costtype_Code,Acq_Deal_Cost_Code,Cost_Type_Code,Amount,Consumed_Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM AR_Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Cost_Costtype OFF

    	/******************************** Insert into Acq_Deal_Cost_Costtype_Episode*****************************************/ 
        SET IDENTITY_INSERT Acq_Deal_Cost_Costtype_Episode ON
		INSERT INTO Acq_Deal_Cost_Costtype_Episode(Acq_Deal_Cost_Costtype_Episode_Code,Acq_Deal_Cost_Costtype_Code,Episode_From,Episode_To,Amount_Type,Amount,Percentage,Remarks)
    	SELECT Acq_Deal_Cost_Costtype_Episode_Code,Acq_Deal_Cost_Costtype_Code,Episode_From,Episode_To,Amount_Type,Amount,Percentage,Remarks
    	FROM AR_Acq_Deal_Cost_Costtype_Episode WHERE Acq_Deal_Cost_Costtype_Code IN (SELECT Acq_Deal_Cost_Costtype_Code FROM Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	SET IDENTITY_INSERT Acq_Deal_Cost_Costtype_Episode OFF

    	/******************************** Insert into Acq_Deal_Cost_Title*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Cost_Title ON
		INSERT INTO Acq_Deal_Cost_Title(Acq_Deal_Cost_Title_Code,Acq_Deal_Cost_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Cost_Title_Code,Acq_Deal_Cost_Code,Title_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Cost_Title WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Cost_Title OFF

    	/******************************** Insert into Acq_Deal_Cost_Variable_Cost*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Cost_Variable_Cost ON
		INSERT INTO Acq_Deal_Cost_Variable_Cost(Acq_Deal_Cost_Variable_Cost_Code,Acq_Deal_Cost_Code,Entity_Code,Vendor_Code,Percentage,Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Cost_Variable_Cost_Code,Acq_Deal_Cost_Code,Entity_Code,Vendor_Code,Percentage,Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM AR_Acq_Deal_Cost_Variable_Cost WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Cost_Variable_Cost OFF

    	/******************************** Insert into Acq_Deal_RUN*****************************************/ 
		SET IDENTITY_INSERT Acq_Deal_RUN ON
        INSERT INTO Acq_Deal_Run(Acq_Deal_Run_Code,Acq_Deal_Code,Run_Type,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Is_Yearwise_Definition,Is_Rule_Right,Right_Rule_Code,Repeat_Within_Days_Hrs,No_Of_Days_Hrs,Is_Channel_Definition_Rights,Primary_Channel_Code,Run_Definition_Type,Run_Definition_Group_Code,All_Channel,Prime_Start_Time,Prime_End_Time,Off_Prime_Start_Time,Off_Prime_End_Time,Time_Lag_Simulcast,Prime_Run,Off_Prime_Run,Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Channel_Type,Channel_Category_Code)
        SELECT Acq_Deal_Run_Code,Acq_Deal_Code,Run_Type,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Is_Yearwise_Definition,Is_Rule_Right,Right_Rule_Code,Repeat_Within_Days_Hrs,No_Of_Days_Hrs,Is_Channel_Definition_Rights,Primary_Channel_Code,Run_Definition_Type,Run_Definition_Group_Code,All_Channel,Prime_Start_Time,Prime_End_Time,Off_Prime_Start_Time,Off_Prime_End_Time,Time_Lag_Simulcast,Prime_Run,Off_Prime_Run,Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Channel_Type,Channel_Category_Code
        FROM AR_Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_RUN OFF
    		
        /******************************** Insert into Acq_Deal_RUN_Channel*****************************************/ 
        SET IDENTITY_INSERT Acq_Deal_Run_Channel ON
		INSERT INTO Acq_Deal_Run_Channel(Acq_Deal_Run_Channel_Code,Acq_Deal_Run_Code,Channel_Code,Min_Runs,Max_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Do_Not_Consume_Rights,Is_Primary,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time)
        SELECT Acq_Deal_Run_Channel_Code,Acq_Deal_Run_Code,Channel_Code,Min_Runs,Max_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Do_Not_Consume_Rights,Is_Primary,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
        FROM AR_Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
        SET IDENTITY_INSERT Acq_Deal_Run_Channel OFF

    	/******************************** Insert into Acq_Deal_Run_Repeat_On_Day*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Run_Repeat_On_Day ON
		INSERT INTO Acq_Deal_Run_Repeat_On_Day(Acq_Deal_Run_Repeat_On_Day_Code,Acq_Deal_Run_Code,Day_Code)
    	SELECT Acq_Deal_Run_Repeat_On_Day_Code,Acq_Deal_Run_Code,Day_Code 
    	FROM AR_Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
        SET IDENTITY_INSERT Acq_Deal_Run_Repeat_On_Day OFF
    	 
    	/******************************** Insert into Acq_Deal_Run_Shows*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Run_Shows ON
		INSERT INTO Acq_Deal_Run_Shows(Acq_Deal_Run_Shows_Code,Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,Acq_Deal_Movie_Code,Inserted_By,Inserted_On)
    	SELECT Acq_Deal_Run_Shows_Code,Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,Acq_Deal_Movie_Code,Inserted_By,Inserted_On
    	FROM AR_Acq_Deal_Run_Shows WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
         SET IDENTITY_INSERT Acq_Deal_Run_Shows OFF
		  
    	/******************************** Insert into Acq_Deal_Run_Title*****************************************/ 
    	SET IDENTITY_INSERT Acq_Deal_Run_Title ON
		INSERT INTO Acq_Deal_Run_Title(Acq_Deal_Run_Title_Code,Acq_Deal_Run_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Run_Title_Code,Acq_Deal_Run_Code,Title_Code,Episode_From,Episode_To 
    	FROM AR_Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	SET IDENTITY_INSERT Acq_Deal_Run_Title OFF	

    	/******************************** Insert into Acq_Deal_Run_Yearwise_Run*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Run_Yearwise_Run ON
		INSERT INTO Acq_Deal_Run_Yearwise_Run(Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Year_No)
    	SELECT Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,Year_No
    	FROM AR_Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
        SET IDENTITY_INSERT Acq_Deal_Run_Yearwise_Run OFF

    	/******************************** Insert into Acq_Deal_Run_Yearwise_Run_Week*****************************************/
    	 SET IDENTITY_INSERT Acq_Deal_Run_Yearwise_Run_Week ON
		INSERT INTO  Acq_Deal_Run_Yearwise_Run_Week(Acq_Deal_Run_Yearwise_Run_Week_Code,Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Week_Date,End_Week_Date,Is_Preferred,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time)
    	SELECT Acq_Deal_Run_Yearwise_Run_Week_Code,Acq_Deal_Run_Yearwise_Run_Code,Acq_Deal_Run_Code,Start_Week_Date,End_Week_Date,Is_Preferred,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
    	FROM AR_Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
        SET IDENTITY_INSERT Acq_Deal_Run_Yearwise_Run_Week OFF
    	
    	/******************************** Insert into Acq_Deal_Sport*****************************************/
		SET IDENTITY_INSERT Acq_Deal_Sport ON
    	INSERT INTO Acq_Deal_Sport(Acq_Deal_Sport_Code,Acq_Deal_Code,Content_Delivery,Obligation_Broadcast,Deferred_Live,Deferred_Live_Duration,Tape_Delayed,Tape_Delayed_Duration,Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial,File_Name,Sys_File_Name,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,MBO_Note)
    	SELECT Acq_Deal_Sport_Code,Acq_Deal_Code,Content_Delivery,Obligation_Broadcast,Deferred_Live,Deferred_Live_Duration,Tape_Delayed,Tape_Delayed_Duration,Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial,File_Name,Sys_File_Name,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By,MBO_Note
    	FROM AR_Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Sport OFF
    
    	/******************************** Insert into Acq_Deal_Sport_Ancillary*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary ON
		INSERT INTO Acq_Deal_Sport_Ancillary(Acq_Deal_Sport_Ancillary_Code,Acq_Deal_Code,Ancillary_For,Sport_Ancillary_Type_Code,Obligation_Broadcast,Broadcast_Window,Broadcast_Periodicity_Code,Sport_Ancillary_Periodicity_Code,Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks)
    	SELECT Acq_Deal_Sport_Ancillary_Code,Acq_Deal_Code,Ancillary_For,Sport_Ancillary_Type_Code,Obligation_Broadcast,Broadcast_Window,Broadcast_Periodicity_Code,Sport_Ancillary_Periodicity_Code,Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks
    	FROM AR_Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary OFF
    
    	/******************************** Insert into Acq_Deal_Sport_Ancillary_Broadcast*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary_Broadcast ON
		INSERT INTO Acq_Deal_Sport_Ancillary_Broadcast(Acq_Deal_Sport_Ancillary_Broadcast_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code)
    	SELECT Acq_Deal_Sport_Ancillary_Broadcast_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code
    	FROM AR_Acq_Deal_Sport_Ancillary_Broadcast WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary_Broadcast OFF
			
    	/******************************** Insert into Acq_Deal_Sport_Ancillary_Source*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary_Source ON
		INSERT INTO Acq_Deal_Sport_Ancillary_Source(Acq_Deal_Sport_Ancillary_Source_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code)
    	SELECT Acq_Deal_Sport_Ancillary_Source_Code,Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code
    	FROM AR_Acq_Deal_Sport_Ancillary_Source WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary_Source OFF

    	/******************************** Insert into Acq_Deal_Sport_Ancillary_Title*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary_Title ON
		INSERT INTO Acq_Deal_Sport_Ancillary_Title(Acq_Deal_Sport_Ancillary_Title_Code,Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Ancillary_Title_Code,Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Sport_Ancillary_Title WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Ancillary_Title OFF

    	/******************************** Insert into Acq_Deal_Sport_Broadcast*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Broadcast ON
		INSERT INTO Acq_Deal_Sport_Broadcast(Acq_Deal_Sport_Broadcast_Code,Acq_Deal_Sport_Code,Broadcast_Mode_Code,Type)
    	SELECT Acq_Deal_Sport_Broadcast_Code,Acq_Deal_Sport_Code,Broadcast_Mode_Code,Type
    	FROM AR_Acq_Deal_Sport_Broadcast WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Broadcast OFF

    	/******************************** Insert into Acq_Deal_Sport_Language*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Language ON
		INSERT INTO Acq_Deal_Sport_Language(Acq_Deal_Sport_Language_Code,Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag)
    	SELECT Acq_Deal_Sport_Language_Code,Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag
    	FROM AR_Acq_Deal_Sport_Language WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Language OFF

    	/******************************** Insert into Acq_Deal_Movie_Content_Mapping*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Movie_Content_Mapping ON
		INSERT INTO Acq_Deal_Movie_Content_Mapping(Acq_Deal_Movie_Content_Mapping_Code,Acq_Deal_Movie_Code,Title_Content_Code)
    	SELECT Acq_Deal_Movie_Content_Mapping_Code,Acq_Deal_Movie_Code,Title_Content_Code
    	FROM AR_Acq_Deal_Movie_Content_Mapping WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Movie_Content_Mapping OFF

    	/******************************** Insert into Acq_Deal_Movie_Music*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Movie_Music ON
		INSERT INTO Acq_Deal_Movie_Music(Acq_Deal_Movie_Music_Code,Acq_Deal_Movie_Code,Music_Title_Code,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time)
    	SELECT Acq_Deal_Movie_Music_Code,Acq_Deal_Movie_Code,Music_Title_Code,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time
    	FROM AR_Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Movie_Music OFF

    	/******************************** Insert into Acq_Deal_Movie_Music_Link*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Movie_Music_Link ON
		INSERT INTO Acq_Deal_Movie_Music_Link(Acq_Deal_Movie_Music_Link_Code,Acq_Deal_Movie_Music_Code,Link_Acq_Deal_Movie_Code,Title_Code,Episode_No,No_Of_Play,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time)
    	SELECT Acq_Deal_Movie_Music_Link_Code,Acq_Deal_Movie_Music_Code,Link_Acq_Deal_Movie_Code,Title_Code,Episode_No,No_Of_Play,Is_Active,Inserted_By,Inserted_On,Last_UpDated_Time,Last_Action_By,Lock_Time
    	FROM AR_Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (SELECT Acq_Deal_Movie_Music_Code FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	SET IDENTITY_INSERT Acq_Deal_Movie_Music_Link OFF

		/******************************** Insert into Acq_Deal_Payment_Terms*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Payment_Terms ON
		INSERT INTO Acq_Deal_Payment_Terms(Acq_Deal_Payment_Terms_Code,Acq_Deal_Code,Cost_Type_Code,Payment_Term_Code,Days_After,Percentage,Amount,Due_Date,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
    	SELECT Acq_Deal_Payment_Terms_Code,Acq_Deal_Code,Cost_Type_Code,Payment_Term_Code,Days_After,Percentage,Amount,Due_Date,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By
    	FROM AR_Acq_Deal_Payment_Terms WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Payment_Terms OFF
    	
    	/******************************** Insert into AR_Acq_Deal_Promoter_Import_Data*****************************************/
    	-- Acq_Deal_Promoter_Import_Data is in RightsU_Plus_Testing and not Rihtsu_Plus so commented for now
    	--INSERT INTO AR_Acq_Deal_Promoter_Import_Data(Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid)
    	--SELECT Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid
    	--FROM Acq_Deal_Promoter_Import_Data WHERE Agreement_No 
    
    	/******************************** Insert into AR_Acq_Deal_Ancillary_Import_Data*****************************************/
    	-- Acq_Deal_Promoter_Import_Data is in RightsU_Plus_Testing and not Rihtsu_Plus so commented for now
    	--INSERT INTO AR_Acq_Deal_Promoter_Import_Data(Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid)
    	--SELECT Acq_Deal_Promoter_Import_Data_Code,Agreement_No,Promoter_Group_Level_1,Promoter_Group_Level_2,Promoter_Remarks,ErrorMsg,Is_Valid
    	--FROM Acq_Deal_Promoter_Import_Data WHERE Agreement_No 
    
    	/******************************** Insert into Acq_Deal_Licensor*****************************************/
		SET IDENTITY_INSERT Acq_Deal_Licensor ON
    	INSERT INTO Acq_Deal_Licensor(Acq_Deal_Licensor_Code,Acq_Deal_Code,Vendor_Code)
    	SELECT Acq_Deal_Licensor_Code,Acq_Deal_Code,Vendor_Code
    	FROM AR_Acq_Deal_Licensor WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Licensor OFF

    	/******************************** Insert into Acq_Deal_Mass_Territory_Update*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Mass_Territory_Update ON
		INSERT INTO Acq_Deal_Mass_Territory_Update(Acq_Deal_Mass_Update_Code,Acq_Deal_Code,Date,Status,Processed_Date,Can_Process,Created_By)
    	SELECT Acq_Deal_Mass_Update_Code,Acq_Deal_Code,Date,Status,Processed_Date,Can_Process,Created_By
    	FROM AR_Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Mass_Territory_Update OFF

    	/******************************** Insert into Acq_Deal_Mass_Territory_Update_Details*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Mass_Territory_Update_Details ON
		INSERT INTO Acq_Deal_Mass_Territory_Update_Details(Acq_Deal_Mass_Update_Det_Code,Acq_Deal_Mass_Update_Code,Territory_Code)
    	SELECT Acq_Deal_Mass_Update_Det_Code,Acq_Deal_Mass_Update_Code,Territory_Code
    	FROM AR_Acq_Deal_Mass_Territory_Update_Details WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Mass_Territory_Update_Details OFF

		/******************************** Insert into Acq_Deal_Mass_Update_ErrorLog*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Mass_Update_ErrorLog ON
		INSERT INTO Acq_Deal_Mass_Update_ErrorLog(Error_Log_Code,Error_Message,Acq_Deal_Mass_Update_Code,Error_Date)
    	SELECT Error_Log_Code,Error_Message,Acq_Deal_Mass_Update_Code,Error_Date 
    	FROM AR_Acq_Deal_Mass_Update_ErrorLog WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	SET IDENTITY_INSERT Acq_Deal_Mass_Update_ErrorLog OFF

		/******************************** Insert into Acq_Deal_Material*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Material ON
		INSERT INTO Acq_Deal_Material(Acq_Deal_Material_Code,Acq_Deal_Code,Title_Code,Material_Medium_Code,Material_Type_Code,Quantity,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Episode_From,Episode_To)
    	SELECT Acq_Deal_Material_Code,Acq_Deal_Code,Title_Code,Material_Medium_Code,Material_Type_Code,Quantity,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Material WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Material OFF
    
    	/******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Monetisation_Ancillary ON
		INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary(Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks)
    	SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks
    	FROM AR_Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Sport_Monetisation_Ancillary OFF
    
    	 /******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary_Title*****************************************/
    	 SET IDENTITY_INSERT Acq_Deal_Sport_Monetisation_Ancillary_Title ON
		 INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary_Title(Acq_Deal_Sport_Monetisation_Ancillary_Title_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Monetisation_Ancillary_Title_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Sport_Monetisation_Ancillary_Title WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM AR_Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Monetisation_Ancillary_Title OFF

    	/******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary_Type*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Monetisation_Ancillary_Type ON
		INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary_Type(Acq_Deal_Sport_Monetisation_Ancillary_Type_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights)
    	SELECT Acq_Deal_Sport_Monetisation_Ancillary_Type_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights
    	FROM AR_Acq_Deal_Sport_Monetisation_Ancillary_Type WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM AR_Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
       SET IDENTITY_INSERT Acq_Deal_Sport_Monetisation_Ancillary_Type OFF
	  
    	/******************************** Insert into Acq_Deal_Sport_Platform*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Platform ON
		INSERT INTO Acq_Deal_Sport_Platform(Acq_Deal_Sport_Platform_Code,Acq_Deal_Sport_Code,Platform_Code,Type)
    	SELECT Acq_Deal_Sport_Platform_Code,Acq_Deal_Sport_Code,Platform_Code,Type
    	FROM AR_Acq_Deal_Sport_Platform  WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Platform OFF

    	/******************************** Insert into Acq_Deal_Sport_Sales_Ancillary*****************************************/
    	 SET IDENTITY_INSERT Acq_Deal_Sport_Sales_Ancillary ON
		 INSERT INTO Acq_Deal_Sport_Sales_Ancillary(Acq_Deal_Sport_Sales_Ancillary_Code,Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity)
    	SELECT Acq_Deal_Sport_Sales_Ancillary_Code,Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity
    	FROM AR_Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
		SET IDENTITY_INSERT Acq_Deal_Sport_Sales_Ancillary OFF
    
    	/******************************** Insert into Acq_Deal_Sport_Sales_Ancillary_Sponsor*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Sales_Ancillary_Sponsor ON
		INSERT INTO Acq_Deal_Sport_Sales_Ancillary_Sponsor(Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type)
    	SELECT Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type
    	FROM AR_Acq_Deal_Sport_Sales_Ancillary_Sponsor WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Sales_Ancillary_Sponsor OFF

    	/******************************** Insert into Acq_Deal_Sport_Sales_Ancillary_Title*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Sales_Ancillary_Title ON
		INSERT INTO Acq_Deal_Sport_Sales_Ancillary_Title(Acq_Deal_Sport_Sales_Ancillary_Title_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Sales_Ancillary_Title_Code,Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Sport_Sales_Ancillary_Title WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Sales_Ancillary_Title OFF
	 
    	/******************************** Insert into Acq_Deal_Sport_Title*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Sport_Title ON
		INSERT INTO Acq_Deal_Sport_Title(Acq_Deal_Sport_Title_Code,Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To)
    	SELECT Acq_Deal_Sport_Title_Code,Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To
    	FROM AR_Acq_Deal_Sport_Title WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
        SET IDENTITY_INSERT Acq_Deal_Sport_Title OFF

    	/******************************** Insert into Acq_Deal_Tab_Version*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Tab_Version ON
		INSERT INTO Acq_Deal_Tab_Version(Acq_Deal_Tab_Version_Code,Version,Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By)
    	SELECT Acq_Deal_Tab_Version_Code,Version,Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By
    	FROM AR_Acq_Deal_Tab_Version WHERE Acq_Deal_Code =@Acq_Deal_Code
        SET IDENTITY_INSERT Acq_Deal_Tab_Version OFF

    	/******************************** Insert into Acq_Deal_Termination_Details*****************************************/
    	SET IDENTITY_INSERT Acq_Deal_Termination_Details ON
		INSERT INTO Acq_Deal_Termination_Details(Acq_Deal_Termination_Details_Code,Acq_Deal_Code,Title_Code,Termination_Episode_No,Termination_Date,Users_Code,Created_Date)
    	SELECT Acq_Deal_Termination_Details_Code,Acq_Deal_Code,Title_Code,Termination_Episode_No,Termination_Date,Users_Code,Created_Date
    	FROM AR_Acq_Deal_Termination_Details WHERE Acq_Deal_Code =@Acq_Deal_Code
        SET IDENTITY_INSERT Acq_Deal_Termination_Details OFF
    
	
        --DELETE FROM AR_Acq_Deal_Rights_Title_EPS WHERE Acq_Deal_Rights_Title_Code IN (SELECT Acq_Deal_Rights_Title_Code FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)) 	
    	DELETE FROM AR_Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Rights_Dubbing  WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN (SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code))
		DELETE FROM AR_Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code =@Acq_Deal_Code)    	
    	DELETE FROM AR_Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN (SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
		DELETE FROM AR_Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Rights_Promoter_Remarks WHERE Acq_Deal_Rights_Promoter_Code IN (SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code))
		DELETE FROM AR_Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM AR_Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM AR_Acq_Deal_Pushback_Dubbing WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Pushback_Platform	WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Pushback_Subtitling WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Pushback_Territory WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Pushback_Title WHERE Acq_Deal_Pushback_Code IN (SELECT Acq_Deal_Pushback_Code FROM Acq_Deal_Pushback WHERE Acq_Deal_Code= @Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Pushback WHERE Acq_Deal_Code=@Acq_Deal_Code
		DELETE FROM AR_Acq_Deal_Ancillary_Platform_Medium WHERE Acq_Deal_Ancillary_Platform_Code IN (Select Acq_Deal_Ancillary_Platform_Code FROM Acq_Deal_Ancillary_Platform WHERE Acq_Deal_Ancillary_Code IN(SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code))
		DELETE FROM AR_Acq_Deal_Ancillary_Platform WHERE Acq_Deal_Ancillary_Code IN (SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )    	
        DELETE FROM AR_Acq_Deal_Ancillary_Title WHERE  Acq_Deal_Ancillary_Code IN (SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code )
		DELETE FROM AR_Acq_Deal_Ancillary where Acq_Deal_Code=@Acq_Deal_Code 
    	DELETE FROM AR_Acq_Deal_Attachment WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM AR_Acq_Deal_Budget WHERE Acq_Deal_Code=@Acq_Deal_Code
    				
		DELETE FROM AR_Acq_Deal_Cost_Costtype_Episode WHERE Acq_Deal_Cost_Costtype_Code IN (SELECT Acq_Deal_Cost_Costtype_Code FROM Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code))
    	DELETE FROM AR_Acq_Deal_Cost_Additional_Exp WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Cost_Commission WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Cost_Costtype WHERE Acq_Deal_Cost_Code IN (SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Cost_Title WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Cost_Variable_Cost WHERE Acq_Deal_Cost_Code IN(SELECT Acq_Deal_Cost_Code FROM Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM AR_Acq_Deal_Cost WHERE Acq_Deal_Code=@Acq_Deal_Code
		    		
    	DELETE FROM AR_Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM AR_Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM AR_Acq_Deal_Run_Shows WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM AR_Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
		DELETE FROM AR_Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM AR_Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Code IN(SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code) 
    	DELETE FROM AR_Acq_Deal_Run WHERE Acq_Deal_Code=@Acq_Deal_Code
					
		DELETE FROM AR_Acq_Deal_Sport_Platform  WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Ancillary_Broadcast WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Ancillary_Source WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Ancillary_Title WHERE Acq_Deal_Sport_Ancillary_Code IN (SELECT Acq_Deal_Sport_Ancillary_Code FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Broadcast WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Language  WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
    		    				
		DELETE FROM AR_Acq_Deal_Movie_Content_Mapping WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
    				
    	DELETE FROM AR_Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (SELECT Acq_Deal_Movie_Music_Code FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code))
		DELETE FROM AR_Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Payment_Terms WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM AR_Acq_Deal_Licensor WHERE Acq_Deal_Code=@Acq_Deal_Code
    				
    	DELETE FROM AR_Acq_Deal_Mass_Territory_Update_Details WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
        DELETE FROM AR_Acq_Deal_Mass_Update_ErrorLog WHERE Acq_Deal_Mass_Update_Code IN (SELECT Acq_Deal_Mass_Update_Code FROM Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM AR_Acq_Deal_Mass_Territory_Update WHERE Acq_Deal_Code=@Acq_Deal_Code
	    			
    	DELETE FROM AR_Acq_Deal_Material WHERE Acq_Deal_Code=@Acq_Deal_Code
    				
    	DELETE FROM AR_Acq_Deal_Sport_Monetisation_Ancillary_Title WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Monetisation_Ancillary_Type WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code IN (SELECT Acq_Deal_Sport_Monetisation_Ancillary_Code FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM AR_Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    				
    	DELETE FROM AR_Acq_Deal_Sport_Sales_Ancillary_Sponsor WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
    	DELETE FROM AR_Acq_Deal_Sport_Sales_Ancillary_Title WHERE Acq_Deal_Sport_Sales_Ancillary_Code IN (SELECT Acq_Deal_Sport_Sales_Ancillary_Code FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM AR_Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM AR_Acq_Deal_Sport_Title WHERE Acq_Deal_Sport_Code IN (SELECT Acq_Deal_Sport_Code FROM Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code)
		DELETE FROM AR_Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code=@Acq_Deal_Code
		DELETE FROM AR_Acq_Deal_Sport WHERE Acq_Deal_Code=@Acq_Deal_Code
    	DELETE FROM AR_Acq_Deal_Tab_Version WHERE Acq_Deal_Code =@Acq_Deal_Code
    	DELETE FROM AR_Acq_Deal_Termination_Details WHERE Acq_Deal_Code =@Acq_Deal_Code
		DELETE FROM AR_Acq_Deal_Movie  WHERE Acq_Deal_Code = @Acq_Deal_Code
    	DELETE FROM AR_Acq_Deal_Rights WHERE Acq_Deal_Code=@Acq_Deal_Code 
		DELETE FROM AR_Acq_Deal where Acq_Deal_Code=@Acq_Deal_Code


    END
	 
  END TRY
  BEGIN CATCH
    PRINT ERROR_MESSAGE() 
  END CATCH
END