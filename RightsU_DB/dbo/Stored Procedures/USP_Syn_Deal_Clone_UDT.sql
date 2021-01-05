CREATE PROCEDURE [dbo].[USP_Syn_Deal_Clone_UDT] 
(
	@New_Syn_Deal_Code      INT, 
	@Previous_Syn_Deal_Code INT, 
	@User_Code              INT, 
	@Deal_Rights_Title DEAL_RIGHTS_TITLE READONLY 
)
AS 
  -- ============================================= 
  -- Author:    Akshay Rane
  -- Create date: 01 April 2019 
  -- Description:  This USP used to clone remaining deal tables 
  -- ============================================= 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET NOCOUNT ON; 

   --   DECLARE 
   --   @New_Syn_Deal_Code      INT = 1565, 
   --   @Previous_Syn_Deal_Code INT = 1493, 
   --   @User_Code              INT = 247,
	  --@Deal_Rights_Title DEAL_RIGHTS_TITLE  
   --   INSERT INTO @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To) 
   --   VALUES(2674, 27766, 1, 1)--, (2026, 902, 1, 1) 

      BEGIN TRY 
          BEGIN TRAN 

          --SELECT  ADM.Title_Code, CADM.Episode_Starts_From, CADM.Episode_End_To ,DRT.Title_Code as NewTitle_Code,
          --    DRT.Episode_From as Old_Episode_From,DRT.Episode_To as Old_Episode_To  
          --    INTO #tempTitle 
          --FROM  @Deal_Rights_Title DRT INNER JOIN Acq_Deal_Movie ADM ON DRT.Deal_Rights_Code = ADM.Acq_Deal_Movie_Code
          --    INNER JOIN Acq_Deal_Movie CADM ON CADM.Title_Code = DRT.Title_Code  
          --    --AND CADM.Episode_Starts_From = DRT.Episode_From AND CADM.Episode_End_To = DRT.Episode_To 
          --WHERE ADM.Acq_Deal_Code = @Previous_Acq_Deal_Code AND CADM.Acq_Deal_Code = @New_Acq_Deal_Code 
			SELECT PSDM.Title_Code, 
                 DRT.Episode_From         AS Episode_Starts_From, 
                 DRT.Episode_To           AS Episode_End_To, 
                 DRT.Title_Code           AS NewTitle_Code, 
                 PSDM.Episode_From		  AS Old_Episode_From, 
                 PSDM.Episode_End_To      AS Old_Episode_To 
			  INTO   #temptitle 
			  FROM   @Deal_Rights_Title DRT 
                 INNER JOIN Syn_Deal_Movie PSDM  ON DRT.Deal_Rights_Code = PSDM.Syn_Deal_Movie_Code AND PSDM.Syn_Deal_Code = @Previous_Syn_Deal_Code 

			PRINT 'INSERTED FROM @Deal_Rights_Title INTO #temptitle '
			DECLARE @New_Syn_Deal_Rights_Code        INT = 0, 
                  @Syn_Deal_Rights_Code              INT = 0, 
                  @Syn_deal_Rights_Promoter_code     INT =0, 
                  @New_Syn_Deal_Rights_Promoter_Code INT = 0, 
                  @Group_Codes                       INT =0, 
                  @Remarks_Codes                     INT = 0 

			PRINT '--=================================RIGHTS_CURSOR START========================================'
			--=================================RIGHTS_CURSOR START========================================
			DECLARE rights_cursor CURSOR FOR 
			SELECT Syn_deal_rights_code  FROM   Syn_Deal_Rights  WHERE  Syn_Deal_Code = @Previous_Syn_Deal_Code 

			OPEN rights_cursor 
			FETCH NEXT FROM rights_cursor INTO @Syn_Deal_Rights_Code 

			WHILE @@FETCH_STATUS = 0 
            BEGIN 
                IF( (SELECT Count(*) FROM   Syn_Deal_Rights_Title SDRT INNER JOIN #temptitle DRT  ON SDRT.Title_Code = DRT.Title_Code 
                     WHERE  SDRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code) > 0 
                  ) 
                  BEGIN 
                      INSERT INTO Syn_Deal_Rights 
                                  (Syn_Deal_Code
								  ,Is_Exclusive
								  ,Is_Title_Language_Right
								  ,Is_Sub_License
								  ,Sub_License_Code
								  ,Is_Theatrical_Right
								  ,Right_Type
								  ,Is_Tentative
								  ,Term
								  ,Right_Start_Date
								  ,Right_End_Date
								  ,Milestone_Type_Code
								  ,Milestone_No_Of_Unit
								  ,Milestone_Unit_Type
								  ,Is_ROFR
								  ,ROFR_Date
								  ,Restriction_Remarks
								  ,Effective_Start_Date
								  ,Actual_Right_Start_Date
								  ,Actual_Right_End_Date
								  ,Is_Pushback
								  ,ROFR_Code
								  ,Inserted_By
								  ,Inserted_On
								  ,Last_Updated_Time
								  ,Last_Action_By
								  ,Right_Status
								  ,Is_Verified
								  ,Original_Right_Type
								  ,Promoter_Flag)   							   
                      SELECT  @New_Syn_Deal_Code
                             ,Is_Exclusive
							 ,Is_Title_Language_Right
							 ,Is_Sub_License
							 ,Sub_License_Code
							 ,Is_Theatrical_Right
							 ,Right_Type
							 ,Is_Tentative
							 ,Term
							 ,Right_Start_Date
							 ,Right_End_Date
							 ,Milestone_Type_Code
							 ,Milestone_No_Of_Unit
							 ,Milestone_Unit_Type
							 ,Is_ROFR
							 ,ROFR_Date
							 ,Restriction_Remarks
							 ,Effective_Start_Date
							 ,Actual_Right_Start_Date
							 ,Actual_Right_End_Date
							 ,Is_Pushback
							 ,ROFR_Code
							 ,Inserted_By
							 ,GETDATE()
							 ,Last_Updated_Time
							 ,Last_Action_By
							 ,'P'
							 ,'N'
							 ,Original_Right_Type
							 ,Promoter_Flag 
                      FROM   Syn_Deal_Rights 
                      WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                      SELECT @New_Syn_Deal_Rights_Code = 
                             Ident_current('Syn_Deal_Rights') 

                      PRINT'/**************** Insert into AT_Syn_Deal_Rights_Title ****************/'
                      INSERT INTO Syn_Deal_Rights_Title 
                                  (Syn_Deal_Rights_Code, 
                                   Title_Code, 
                                   Episode_From, 
                                   Episode_To) 
                      SELECT @New_Syn_Deal_Rights_Code, 
                             DRT.NewTitle_Code, 
                             DRT.Episode_Starts_From, 
                             DRT.Episode_End_To 
                      FROM   Syn_Deal_Rights_Title ADRT 
                             INNER JOIN #temptitle DRT 
                                     ON ADRT.Title_Code = DRT.Title_Code AND ADRT.episode_from = DRT.Old_Episode_From  AND ADRT.Episode_To = DRT.Old_Episode_To 
                      WHERE  ADRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                     PRINT'/**************** Insert into AT_Syn_Deal_Rights_Title_EPS ****************/'
                      INSERT INTO Syn_Deal_Rights_Title_EPS 
                                  (Syn_Deal_Rights_Title_Code, 
                                   EPS_No) 
                      SELECT AtADRT.Syn_Deal_Rights_Title_Code, 
                             ADRTE.EPS_No 
                      FROM   Syn_Deal_Rights_Title_EPS ADRTE 
                             INNER JOIN Syn_Deal_Rights_Title ADRT 
                                     ON ADRTE.Syn_Deal_Rights_Title_Code =  ADRT.Syn_Deal_Rights_Title_Code 
                             INNER JOIN #temptitle DRT 
                                     ON ADRT.Title_Code = DRT.Title_Code  AND ADRT.Episode_From =  DRT.Old_Episode_From  AND ADRT.Episode_To = DRT.Old_Episode_To 
                             INNER JOIN Syn_Deal_Rights_Title AtADRT 
                                     ON Cast(ISNULL(AtADRT.Title_Code, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(ISNULL(AtADRT.Episode_From, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(ISNULL(AtADRT.Episode_To, '') AS 
                                        VARCHAR) = 
                                        Cast(ISNULL(ADRT.Title_Code, '' 
                                        ) AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(ISNULL(ADRT.Episode_From, '' 
                                        ) AS 
                                        VARCHAR 
                                        ) 
                                        + '~' 
                                        + Cast(ISNULL(ADRT.Episode_To, '') 
                                        AS 
                                        VARCHAR 
                                        ) 
                      WHERE  ADRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtADRT.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code 

                      PRINT'/**************** Insert into AT_Syn_Deal_Rights_Platform ****************/'
                      INSERT INTO Syn_Deal_Rights_Platform 
                                  (Syn_Deal_Rights_Code, 
                                   Platform_Code) 
                      SELECT @New_Syn_Deal_Rights_Code,
                             ADRP.Platform_Code 
                      FROM   Syn_Deal_Rights_Platform ADRP 
                      WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                      PRINT'/**************** Insert into AT_Syn_Deal_Rights_Territory ****************/'
                      INSERT INTO Syn_Deal_Rights_Territory 
                                  (Syn_Deal_Rights_Code, 
                                   Territory_Code, 
                                   Territory_Type, 
                                   Country_Code) 
                      SELECT @New_Syn_Deal_Rights_Code, 
                             ADRT.Territory_Code, 
                             ADRT.Territory_Type, 
                             ADRT.Country_Code 
                      FROM   Syn_Deal_Rights_Territory ADRT 
                      WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                      PRINT'/**************** Insert into AT_Syn_Deal_Rights_Subtitling ****************/'
                      INSERT INTO Syn_Deal_Rights_Subtitling 
                                  (Syn_deal_rights_code, 
                                   Language_Code, 
                                   Language_Group_Code, 
                                   Language_Type) 
                      SELECT @New_Syn_Deal_Rights_Code, 
                             ADRS.Language_Code, 
                             ADRS.Language_Group_Code, 
                             ADRS.Language_Type 
                      FROM   Syn_Deal_Rights_Subtitling ADRS 
                      WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                      PRINT'/**************** Insert into AT_Syn_Deal_Rights_Dubbing ****************/'
                      INSERT INTO Syn_Deal_Rights_Dubbing 
                                  (Syn_Deal_Rights_Code, 
                                   Language_Code, 
                                   Language_Group_Code, 
                                   Language_Type) 
                      SELECT @New_Syn_Deal_Rights_Code, 
                             ADRD.Language_Code, 
                             ADRD.Language_Group_Code, 
                             ADRD.Language_Type 
                      FROM   Syn_Deal_Rights_Dubbing ADRD 
                      WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                     /* PRINT'/**************** Insert into AT_Syn_Deal_Rights_Holdback ****************/'
                      INSERT INTO Syn_Deal_Rights_Holdback 
                                  (Syn_Deal_Rights_Code, 
                                   Holdback_Type, 
                                   HB_Run_After_Release_No, 
                                   HB_Run_After_Release_Units, 
                                   Holdback_On_Platform_Code, 
                                   Holdback_Release_Date, 
                                   Holdback_Comment, 
                                   Is_Original_Language,
								   Acq_Deal_Rights_Holdback_Code) 
                      SELECT @New_Syn_Deal_Rights_Code, 
                             ADRH.Holdback_Type, 
                             ADRH.HB_Run_After_Release_No, 
                             ADRH.HB_Run_After_Release_Units, 
                             ADRH.Holdback_On_Platform_Code, 
                             ADRH.Holdback_Release_Date, 
                             ADRH.Holdback_Comment, 
                             ADRH.Is_Original_Language,
							 ADRH.Acq_Deal_Rights_Holdback_Code
                      FROM   Syn_Deal_Rights_Holdback ADRH 
                      WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Syn_Deal_Rights_Holdback_Dubbing ********/'
                      INSERT INTO Syn_Deal_Rights_Holdback_Dubbing 
                                  (Syn_Deal_Rights_Holdback_Code, 
                                   Language_Code) 
                      SELECT AtADRH.Syn_Deal_Rights_Holdback_Code, 
                             ADRHD.Language_Code 
                      FROM   Syn_Deal_Rights_Holdback_Dubbing ADRHD 
                             INNER JOIN Syn_Deal_Rights_Holdback ADRH 
                                     ON ADRHD.Syn_Deal_Rights_Holdback_Code = 
                                        ADRH.Syn_Deal_Rights_Holdback_Code 
                             INNER JOIN Syn_Deal_Rights_Holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.HB_Run_After_Release_No, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.HB_Run_After_Release_Units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.Holdback_On_Platform_Code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.Holdback_Release_Date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Type, '') + '~' 
                             + Isnull(AtADRH.Is_Original_Language, '') = 
                             Cast(Isnull(ADRH.HB_Run_After_Release_No, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.HB_Run_After_Release_Units, 
                             '') 
                             + '~' + Isnull(ADRH.Holdback_Comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.Holdback_On_Platform_Code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.Holdback_Release_Date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.Holdback_Type, '') + '~' 
                             + Isnull(ADRH.Is_Original_Language, '') 
                      WHERE  ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
                             AND AtADRH.Syn_Deal_Rights_Code = 
                                 @New_Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Syn_Deal_Rights_Holdback_Platform ********/'
                      INSERT INTO Syn_Deal_Rights_Holdback_Platform 
                                  (Syn_Deal_Rights_Holdback_Code, 
                                   Platform_Code) 
                      SELECT AtADRH.Syn_Deal_Rights_Holdback_Code, 
                             ADRHP.Platform_Code 
                      FROM   Syn_Deal_Rights_Holdback_Platform ADRHP 
                             INNER JOIN Syn_Deal_Rights_Holdback ADRH 
                                     ON ADRHP.Syn_Deal_Rights_Holdback_Code = 
                                        ADRH.Syn_Deal_Rights_Holdback_Code 
                             INNER JOIN Syn_Deal_Rights_Holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.HB_Run_After_Release_No, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.HB_Run_After_Release_Units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.Holdback_On_Platform_Code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.Holdback_Release_Date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Type, '') + '~' 
                             + Isnull(AtADRH.Is_Original_Language, '') = 
                             Cast(Isnull(ADRH.HB_Run_After_Release_No, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.HB_Run_After_Release_Units, 
                             '') 
                             + '~' + Isnull(ADRH.Holdback_Comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.Holdback_On_Platform_Code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.Holdback_Release_Date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.Holdback_Type, '') + '~' 
                             + Isnull(ADRH.Is_Original_Language, '') 
                      WHERE  ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
                             AND AtADRH.Syn_Deal_Rights_Code = 
                                 @New_Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Acq_Deal_Rights_Holdback_Subtitling ********/'
                      INSERT INTO Syn_Deal_Rights_Holdback_Subtitling 
                                  (Syn_Deal_Rights_Holdback_Code, 
                                   Language_Code) 
                      SELECT AtADRH.Syn_Deal_Rights_Holdback_Code, 
                             ADRHS.Language_Code 
                      FROM   Syn_Deal_Rights_Holdback_Subtitling ADRHS 
                             INNER JOIN Syn_Deal_Rights_Holdback ADRH 
                                     ON ADRHS.Syn_Deal_Rights_Holdback_Code = 
                                        ADRH.Syn_Deal_Rights_Holdback_Code 
                             INNER JOIN Syn_Deal_Rights_Holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.HB_Run_After_Release_No, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.HB_Run_After_Release_Units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.Holdback_On_Platform_Code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.Holdback_Release_Date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Type, '') + '~' 
                             + Isnull(AtADRH.Is_Original_Language, '') = 
                             Cast(Isnull(ADRH.HB_Run_After_Release_No, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.HB_Run_After_Release_Units, 
                             '') 
                             + '~' + Isnull(ADRH.Holdback_Comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.Holdback_On_Platform_Code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.Holdback_Release_Date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.Holdback_Type, '') + '~' 
                             + Isnull(ADRH.Is_Original_Language, '') 
                      WHERE  ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
                             AND AtADRH.Syn_Deal_Rights_Code = 
                                 @New_Syn_Deal_Rights_Code 

                     PRINT'/******** Insert into AT_Syn_Deal_Rights_Holdback_Territory ********/'
                      INSERT INTO Syn_Deal_Rights_Holdback_Territory 
                                  (Syn_Deal_Rights_Holdback_Code, 
                                   Territory_Type, 
                                   Country_Code, 
                                   Territory_Code) 
                      SELECT AtADRH.Syn_Deal_Rights_Holdback_Code, 
                             Territory_Type, 
                             Country_Code, 
                             Territory_Code 
                      FROM   Syn_Deal_Rights_Holdback_Territory ADRHT 
                             INNER JOIN Syn_Deal_Rights_Holdback ADRH 
                                     ON ADRHT.Syn_Deal_Rights_Holdback_Code = 
                                        ADRH.Syn_Deal_Rights_Holdback_Code 
                             INNER JOIN Syn_Deal_Rights_Holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.HB_Run_After_Release_No, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.HB_Run_After_Release_Units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.Holdback_On_Platform_Code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.Holdback_Release_Date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.Holdback_Type, '') + '~' 
                             + Isnull(AtADRH.Is_Original_Language, '') = 
                             Cast(Isnull(ADRH.HB_Run_After_Release_No, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.HB_Run_After_Release_Units, 
                             '') 
                             + '~' + Isnull(ADRH.Holdback_Comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.Holdback_On_Platform_Code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.Holdback_Release_Date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.Holdback_Type, '') + '~' 
                             + Isnull(ADRH.Is_Original_Language, '') 
                      WHERE  ADRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
                             AND AtADRH.Syn_Deal_Rights_Code = 
                                 @New_Syn_Deal_Rights_Code 
						*/
                      PRINT'/**************** Insert into AT_Syn_Deal_Rights_Blackout ****************/'
                      INSERT INTO Syn_Deal_Rights_Blackout 
                                  (Syn_Deal_Rights_Code, 
                                   Start_Date, 
                                   End_Date, 
                                   Inserted_By, 
                                   Inserted_On) 
                      SELECT @New_Syn_Deal_Rights_Code, 
                             ADRB.Start_Date, 
                             ADRB.End_Date, 
                             @User_Code, 
                             Getdate() 
                      FROM   Syn_Deal_Rights_Blackout ADRB 
                      WHERE  ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Syn_Deal_Rights_Blackout_Dubbing ********/'
                      INSERT INTO Syn_Deal_Rights_Blackout_Dubbing 
                                  (Syn_Deal_Rights_Blackout_Code, 
                                   Language_Code) 
                      SELECT AtADRB.Syn_Deal_Rights_Blackout_Code, 
                             ADRBD.Language_Code 
                      FROM   Syn_Deal_Rights_Blackout_Dubbing ADRBD 
                             INNER JOIN Syn_Deal_Rights_Blackout ADRB 
                                     ON ADRBD.Syn_Deal_Rights_Blackout_Code = 
                                        ADRB.Syn_Deal_Rights_Blackout_Code 
                             INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.start_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_By, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_On, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Last_Action_By, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Last_Updated_Time, 
                                        '' 
                                        ) AS 
                                        VARCHAR) 
                                        = 
                                        Cast(Isnull(ADRB.Start_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Inserted_By, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Inserted_On, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Last_Action_By, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Last_Updated_Time, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                      WHERE  ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  AND AtADRB.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Syn_Deal_Rights_Blackout_Platform ********/'
                      INSERT INTO Syn_Deal_Rights_Blackout_Platform 
                                  (Syn_Deal_Rights_Blackout_Code, 
                                   Platform_Code) 
                      SELECT AtADRB.Syn_Deal_Rights_Blackout_Code, 
                             ADRBP.Platform_Code 
                      FROM   Syn_Deal_Rights_Blackout_Platform ADRBP 
                             INNER JOIN Syn_Deal_Rights_Blackout ADRB 
                                     ON ADRBP.Syn_Deal_Rights_Blackout_Code = 
                                        ADRB.Syn_Deal_Rights_Blackout_Code 
                             INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.Start_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_By, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_On, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Last_Action_By, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Last_Updated_Time, 
                                        '' 
                                        ) AS 
                                        VARCHAR) 
                                        = 
                                        Cast(Isnull(ADRB.Start_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Inserted_By, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Inserted_On, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Last_Action_By, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Last_Updated_Time, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                      WHERE  ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
                             AND AtADRB.Syn_Deal_Rights_Code = 
                                 @New_Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Syn_Deal_Rights_Blackout_Subtitling ********/' 
                      INSERT INTO Syn_Deal_Rights_Blackout_Subtitling 
                                  (Syn_deal_rights_blackout_code, 
                                   language_code) 
                      SELECT AtADRB.Syn_Deal_Rights_Blackout_Code, 
                             ADRBS.Language_Code 
                      FROM   Syn_Deal_Rights_Blackout_Subtitling ADRBS 
                             INNER JOIN Syn_Deal_Rights_Blackout ADRB 
                                     ON ADRBS.Syn_Deal_Rights_Blackout_Code = 
                                        ADRB.Syn_Deal_Rights_Blackout_Code 
                             INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.Start_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_By, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_On, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Last_Action_By, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Last_Updated_Time, 
                                        '' 
                                        ) AS 
                                        VARCHAR) 
                                        = 
                                        Cast(Isnull(ADRB.Start_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Inserted_By, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Inserted_On, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Last_Action_By, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.Last_Updated_Time, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                      WHERE  ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
                             AND AtADRB.Syn_Deal_Rights_Code = 
                                 @New_Syn_Deal_Rights_Code 

                      PRINT'/******** Insert into AT_Syn_Deal_Rights_Blackout_Territory ********/' 
                      INSERT INTO Syn_Deal_Rights_Blackout_Territory 
                                  (Syn_Deal_Rights_Blackout_Code, 
                                   Country_Code, 
                                   Territory_Code, 
                                   Territory_Type) 
                      SELECT AtADRB.Syn_Deal_Rights_Blackout_Code, 
                             ADRBT.Country_Code, 
                             ADRBT.Territory_Code, 
                             ADRBT.Territory_Type 
                      FROM   Syn_Deal_Rights_Blackout_Territory ADRBT 
                             INNER JOIN Syn_Deal_Rights_Blackout ADRB 
                                     ON ADRBT.Syn_Deal_Rights_Blackout_Code = 
                                        ADRB.Syn_Deal_Rights_Blackout_Code 
                             INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.Start_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.End_Date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.Inserted_By, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.inserted_on, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.last_action_by, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.last_updated_time, 
                                        '' 
                                        ) AS 
                                        VARCHAR) 
                                        = 
                                        Cast(Isnull(ADRB.start_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.end_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.inserted_by, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.inserted_on, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.last_action_by, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRB.last_updated_time, 
                                        '') 
                                        AS 
                                        VARCHAR) 
                      WHERE  ADRB.Syn_deal_rights_code = @Syn_Deal_Rights_Code 
                             AND AtADRB.Syn_deal_rights_code = 
                                 @New_Syn_Deal_Rights_Code 

					PRINT'/**************** Insert into AT_Syn_Deal_Rights_Promoter ****************/'
                      INSERT INTO Syn_Deal_Rights_Promoter(Syn_Deal_Rights_Code, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
                      SELECT @New_Syn_Deal_Rights_Code, @User_Code, GETDATE(), GETDATE(), @User_Code
                      FROM Syn_Deal_Rights_Promoter ADRP WHERE ADRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					
					--Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * FROM Acq_Deal_Rights_Promoter

					PRINT'/******** Insert into Syn_Deal_Rights_Promoter_Group ********/'
                      INSERT INTO Syn_Deal_Rights_Promoter_Group( Syn_Deal_Rights_Promoter_Code, Promoter_Group_Code)
                      SELECT ADRPNew.Syn_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code
                      FROM (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter
						Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN Syn_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Syn_Deal_Rights_Promoter_Code = ADRP.Syn_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter
						Where Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

					  --Inner Join Acq_Deal_Rights_Promoter ADRPOLD On Row_Number() over(order by ADRP.Acq_Deal_Rights_Promoter_Code Asc)
					
					PRINT'/******** Insert into AT_Acq_Deal_Rights_Promoter_Remarks ********/' 
                      INSERT INTO Syn_Deal_Rights_Promoter_Remarks(Syn_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
                      SELECT ADRPNew.Syn_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code 
					  FROM (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter
						Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN Syn_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Syn_Deal_Rights_Promoter_Code = ADRP.Syn_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter
						Where Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId
 
			END 
			FETCH next FROM rights_cursor INTO @Syn_Deal_Rights_Code 
			END 
			CLOSE rights_cursor; 
			DEALLOCATE rights_cursor
			PRINT'--=================================RIGHTS_CURSOR END========================================'
			
	
			PRINT'--=================================RUN_CURSOR START========================================'
			DECLARE @New_Syn_Deal_Run_Code INT = 0, @Syn_Deal_Run_Code INT = 0
			DECLARE run_cursor CURSOR FOR 
			SELECT Syn_Deal_Run_Code FROM   Syn_Deal_Run WHERE  Syn_Deal_Code = @Previous_Syn_Deal_Code 

			OPEN run_cursor 
			FETCH next FROM run_cursor INTO @Syn_Deal_Run_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			--IF( (SELECT Count(*) FROM   Syn_deal_run_title ADRT INNER JOIN #temptitle tt ON ADRT.title_code = tt.title_code 
			--WHERE  ADRT.Syn_deal_run_code = @Syn_Deal_Run_Code) > 0 ) 
			--BEGIN 
			PRINT'/******************************** Insert into AT_Syn_Deal_Run *****************************************/'
			INSERT INTO Syn_Deal_Run 
			(
			Syn_Deal_Code
			,Title_Code
			,Episode_From
			,Episode_To
			,Run_Type
			,No_Of_Runs
			,Is_Yearwise_Definition
			,Is_Rule_Right
			,Repeat_Within_Days_Hrs
			,Right_Rule_Code
			,No_Of_Days_Hrs
			,Inserted_By 
			,Inserted_On
			,Last_action_By
			,Last_updated_Time
			) 
			SELECT @New_Syn_Deal_Code
			,Title_Code
			,Episode_From
			,Episode_To
			,Run_Type
			,No_Of_Runs
			,Is_Yearwise_Definition
			,Is_Rule_Right
			,Repeat_Within_Days_Hrs
			,Right_Rule_Code
			,No_Of_Days_Hrs
			,Inserted_By 
			,Inserted_On
			,Last_action_By
			,Last_updated_Time
			FROM   Syn_Deal_Run 
			WHERE  Syn_Deal_Run_Code = @Syn_Deal_Run_Code 

			SELECT @New_Syn_Deal_Run_Code = IDENT_CURRENT('Syn_Deal_Run') 

			PRINT'/**************** Insert into AT_Syn_Deal_Run_Repeat_On_Day ****************/' 
			INSERT INTO Syn_Deal_Run_Repeat_On_Day 
			(Syn_Deal_Run_Code, 
			Day_Code) 
			SELECT @New_Syn_Deal_Run_Code, 
			ADRRD.Day_Code 
			FROM   Syn_Deal_Run_Repeat_On_Day ADRRD 
			WHERE  ADRRD.Syn_Deal_Run_Code = @Syn_Deal_Run_Code 

			PRINT'/**************** Insert into AT_Syn_Deal_Run_Platform ****************/' 
			INSERT INTO Syn_Deal_Run_Platform
			(Syn_Deal_Run_Code, 
			Platform_Code) 
			SELECT @New_Syn_Deal_Run_Code, 
			ADRRD.Platform_Code 
			FROM   Syn_Deal_Run_Platform ADRRD 
			WHERE  ADRRD.Syn_Deal_Run_Code = @Syn_Deal_Run_Code 

			PRINT'/**************** Insert into AT_Syn_Deal_Run_Yearwise_Run ****************/'

			INSERT INTO Syn_Deal_Run_Yearwise_Run 
			(Syn_Deal_Run_Code, 
			Start_Date, 
			End_Date, 
			No_Of_Runs, 
			Year_No) 
			SELECT @New_Syn_Deal_Run_Code, 
			ADRYR.Start_Date, 
			ADRYR.End_Date, 
			ADRYR.No_Of_Runs, 
			ADRYR.Year_No 
			FROM   Syn_Deal_Run_Yearwise_Run ADRYR 
			WHERE  ADRYR.Syn_Deal_Run_Code = @Syn_Deal_Run_Code 
			PRINT'/**************** END ****************/'
			--END 

			FETCH next FROM run_cursor INTO @Syn_Deal_Run_Code 
			END 

			CLOSE run_cursor 
			DEALLOCATE run_cursor 
			PRINT'--=================================RUN_CURSOR END========================================'
			PRINT'--=================================REVENUE_CURSOR START========================================'
			/*
			select * from Syn_Deal_Revenue
			select * from Syn_Deal_Revenue_Additional_Exp
			select * from Syn_Deal_Revenue_Commission
			select * from Syn_Deal_Revenue_Costtype
			select * from Syn_Deal_Revenue_Costtype_Episode
			select * from Syn_Deal_Revenue_Platform
			select * from Syn_Deal_Revenue_Title
			select * from Syn_Deal_Revenue_Variable_Cost
			*/

			DECLARE @New_Syn_Deal_Revenue_Code INT = 0, @Syn_Deal_Revenue_Code INT = 0
			DECLARE revenue_cursor CURSOR FOR 
			SELECT Syn_Deal_Revenue_Code FROM Syn_Deal_Revenue WHERE  Syn_Deal_Code = @Previous_Syn_Deal_Code 

			OPEN revenue_cursor 
			FETCH next FROM revenue_cursor INTO @Syn_Deal_Revenue_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
				IF( (SELECT Count(*) FROM   Syn_Deal_Revenue_Title ADRT INNER JOIN #temptitle tt ON ADRT.Title_Code = tt.Title_Code 
				WHERE  ADRT.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code) > 0 ) 
				BEGIN 
					PRINT'/******************************** Insert into Syn_Deal_Revenue *****************************************/'
					INSERT INTO Syn_Deal_Revenue
					(
						Syn_Deal_Code
						,Currency_Code
						,Currency_Exchange_Rate
						,Deal_Cost
						,Deal_Cost_Per_Episode
						,Cost_Center_Id
						,Additional_Cost
						,Catchup_Cost
						,Variable_Cost_Type
						,Variable_Cost_Sharing_Type
						,Royalty_Recoupment_Code
						,Inserted_On
						,Inserted_By
					)
					SELECT @New_Syn_Deal_Code 
						,Currency_Code
						,Currency_Exchange_Rate
						,Deal_Cost
						,Deal_Cost_Per_Episode
						,Cost_Center_Id
						,Additional_Cost
						,Catchup_Cost
						,Variable_Cost_Type
						,Variable_Cost_Sharing_Type
						,Royalty_Recoupment_Code
						,GETDATE()
						,@User_Code
					FROM	Syn_Deal_Revenue
					WHERE	Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code
					SELECT @New_Syn_Deal_Revenue_Code = IDENT_CURRENT('Syn_Deal_Revenue') 
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Additional_Exp *****************************************/'
					INSERT INTO Syn_Deal_Revenue_Additional_Exp
					(
						Syn_Deal_Revenue_Code
						,Additional_Expense_Code
						,Amount
						,Min_Max
						,Inserted_On
						,Inserted_By
					)
					SELECT @New_Syn_Deal_Revenue_Code
						,Additional_Expense_Code
						,Amount
						,Min_Max
						,GETDATE()
						,@User_Code
					FROM Syn_Deal_Revenue_Additional_Exp SDRAE 
					WHERE  SDRAE.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Commission *****************************************/'
					INSERT INTO Syn_Deal_Revenue_Commission
					(
						Syn_Deal_Revenue_Code
						,Cost_Type_Code
						,Royalty_Commission_Code
						,Vendor_Code
						,Entity_Code
						,Type
						,Commission_Type
						,Percentage
						,Amount
					)
					SELECT @New_Syn_Deal_Revenue_Code
						,Cost_Type_Code
						,Royalty_Commission_Code
						,Vendor_Code
						,Entity_Code
						,Type
						,Commission_Type
						,Percentage
						,Amount
						FROM Syn_Deal_Revenue_Commission SDRC
						WHERE  SDRC.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Costtype *****************************************/'
					INSERT INTO Syn_Deal_Revenue_Costtype
					(
						Syn_Deal_Revenue_Code
						,Cost_Type_Code
						,Amount
						,Consumed_Amount
						,Inserted_On
						,Inserted_By
					)
					SELECT @New_Syn_Deal_Revenue_Code
						,Cost_Type_Code
						,Amount
						,Consumed_Amount
						,GETDATE()
						,@User_Code
					FROM Syn_Deal_Revenue_Costtype SDRP 
					WHERE  SDRP.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Costtype_Episode *****************************************/'
					--PENDING (NOT USED THIS TABLE ANYWHERE)
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Platform *****************************************/'
					INSERT INTO Syn_Deal_Revenue_Platform (
						Syn_Deal_Revenue_Code,
						Platform_Code
					)
					SELECT @New_Syn_Deal_Revenue_Code, Platform_Code FROM Syn_Deal_Revenue_Platform SDRP 
					WHERE  SDRP.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Title *****************************************/'
					INSERT INTO Syn_Deal_Revenue_Title
					(	
						 Syn_Deal_Revenue_Code
						,Title_Code
						,Episode_From
						,Episode_To
					)
					SELECT @New_Syn_Deal_Revenue_Code
						,ADRT.Title_Code
						,Episode_From
						,Episode_To
					FROM Syn_Deal_Revenue_Title ADRT
					INNER JOIN #temptitle tt 
					ON ADRT.Title_Code = tt.Title_Code AND ADRT.Episode_From = tt.Old_Episode_From AND ADRT.Episode_To = tt.Old_Episode_To 
					WHERE  ADRT.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code 
					PRINT'/******************************** Insert into Syn_Deal_Revenue_Variable_Cost *****************************************/'
					INSERT INTO Syn_Deal_Revenue_Variable_Cost (
						Syn_Deal_Revenue_Code
						,Entity_Code
						,Vendor_Code
						,Percentage
						,Amount
						,Inserted_On
						,Inserted_By
					)
					SELECT @New_Syn_Deal_Revenue_Code
						,Entity_Code
						,Vendor_Code
						,Percentage
						,Amount
						,GETDATE()
						,@User_Code
					FROM Syn_Deal_Revenue_Variable_Cost SDRP 
					WHERE  SDRP.Syn_Deal_Revenue_Code = @Syn_Deal_Revenue_Code
				/**************** END ****************/ 
				END
		
			FETCH next FROM revenue_cursor INTO @Syn_Deal_Revenue_Code 
			END 

			CLOSE revenue_cursor 
			DEALLOCATE revenue_cursor 

			PRINT'--=================================REVENUE_CURSOR END========================================'
			PRINT'/******************************** Insert into Syn_Deal_Payment_Terms *****************************************/'
			
			INSERT INTO Syn_Deal_Payment_Terms 
			(Syn_Deal_Code
			,Payment_Terms_Code
			,Days_After
			,Percentage
			,Due_Date
			,Cost_Type_Code
			,Inserted_On
			,Inserted_By
			,Amount
			) 
			SELECT @New_Syn_Deal_Code
			,Payment_Terms_Code
			,Days_After
			,Percentage
			,Due_Date
			,Cost_Type_Code
			,GETDATE()
			,@User_Code
			,Amount
			FROM   Syn_Deal_Payment_Terms 
			WHERE  Syn_Deal_Code = @Previous_Syn_Deal_Code 

			PRINT'/******************************** Insert into AT_Syn_Deal_Material *****************************************/'
			INSERT INTO Syn_Deal_Material 
			(Syn_Deal_Code, 
			Title_Code, 
			Material_Medium_Code, 
			Material_Type_Code, 
			Quantity, 
			Inserted_On, 
			Inserted_By, 
			Lock_Time, 
			Episode_From, 
			Episode_To) 
			SELECT @New_Syn_Deal_Code, 
			tt.NewTitle_Code, 
			Material_Medium_Code, 
			Material_Type_Code, 
			Quantity, 
			GETDATE(), 
			@User_Code, 
			Lock_Time, 
			tt.Episode_Starts_From, 
			tt.Episode_End_To 
			FROM   Syn_Deal_Material ADM 
			INNER JOIN #temptitle tt 
			ON ADM.Title_Code = tt.Title_Code 
			AND ADM.Episode_From = tt.Old_Episode_From 
			AND ADM.Episode_To = tt.Old_Episode_To 
			WHERE  Syn_Deal_Code = @Previous_Syn_Deal_Code 

		COMMIT 
	--drop table #tempTitle 
	SELECT 'Success' AS Result 
	END TRY 
	BEGIN CATCH 
	ROLLBACK 
		SELECT Error_message() 
	SELECT 'ERROR' AS Result 
	END CATCH 

	IF OBJECT_ID('tempdb..#tempTitle') IS NOT NULL DROP TABLE #tempTitle
END