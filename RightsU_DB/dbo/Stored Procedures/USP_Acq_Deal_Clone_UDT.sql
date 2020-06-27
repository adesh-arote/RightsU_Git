CREATE PROCEDURE [dbo].[USP_Acq_Deal_Clone_UDT] 
(
	@New_Acq_Deal_Code      INT, 
	@Previous_Acq_Deal_Code INT, 
	@User_Code              INT, 
	@Deal_Rights_Title DEAL_RIGHTS_TITLE READONLY 
)
AS 
  -- ============================================= 
  -- Author:    Rajesh Godse 
  -- Create date: 09 April 2015 
  -- Description:  This USP used to clone remaining deal tables 
  -- ============================================= 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET NOCOUNT ON; 

      --DECLARE 
      --@New_Acq_Deal_Code int, 
      --@Previous_Acq_Deal_Code int, 
      --@Deal_Rights_Title Deal_Rights_Title 
      --SELECT @New_Acq_Deal_Code = 5189 , @Previous_Acq_Deal_Code = 2011 
      --INSERT INTO @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To) 
      --VALUES(2025, 901, 1, 1), (2026, 902, 1, 1) 
      BEGIN TRY 
          BEGIN TRAN 

          --SELECT  ADM.Title_Code, CADM.Episode_Starts_From, CADM.Episode_End_To ,DRT.Title_Code as NewTitle_Code,
          --    DRT.Episode_From as Old_Episode_From,DRT.Episode_To as Old_Episode_To  
          --    INTO #tempTitle 
          --FROM  @Deal_Rights_Title DRT INNER JOIN Acq_Deal_Movie ADM ON DRT.Deal_Rights_Code = ADM.Acq_Deal_Movie_Code
          --    INNER JOIN Acq_Deal_Movie CADM ON CADM.Title_Code = DRT.Title_Code  
          --    --AND CADM.Episode_Starts_From = DRT.Episode_From AND CADM.Episode_End_To = DRT.Episode_To 
          --WHERE ADM.Acq_Deal_Code = @Previous_Acq_Deal_Code AND CADM.Acq_Deal_Code = @New_Acq_Deal_Code 
			SELECT PADM.title_code, 
                 DRT.episode_from         AS Episode_Starts_From, 
                 DRT.episode_to           AS Episode_End_To, 
                 DRT.title_code           AS NewTitle_Code, 
                 PADM.episode_starts_from AS Old_Episode_From, 
                 PADM.episode_end_to      AS Old_Episode_To 
			  INTO   #temptitle 
			  FROM   @Deal_Rights_Title DRT 
                 INNER JOIN acq_deal_movie PADM 
                         ON DRT.deal_rights_code = PADM.acq_deal_movie_code 
                            AND PADM.acq_deal_code = @Previous_Acq_Deal_Code 

			DECLARE @New_Acq_Deal_Rights_Code          INT = 0, 
                  @Acq_Deal_Rights_Code              INT = 0, 
                  @Acq_deal_Rights_Promoter_code     INT =0, 
                  @New_Acq_Deal_Rights_Promoter_Code INT = 0, 
                  @Group_Codes                       INT =0, 
                  @Remarks_Codes                     INT = 0 

			--Declare cursor for Rights 
			--=================================RIGHTS_CURSOR START========================================
			DECLARE rights_cursor CURSOR FOR 
			SELECT acq_deal_rights_code  FROM   acq_deal_rights  WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN rights_cursor 
			FETCH next FROM rights_cursor INTO @Acq_Deal_Rights_Code 

			WHILE @@FETCH_STATUS = 0 
            BEGIN 
                IF( (SELECT Count(*) 
                     FROM   acq_deal_rights_title ADRT 
                            INNER JOIN #temptitle DRT 
                                    ON ADRT.title_code = DRT.title_code 
                     WHERE  ADRT.acq_deal_rights_code = @Acq_Deal_Rights_Code) > 
                    0 
                  ) 
                  BEGIN 
                      PRINT 'Code is coming here' 

                      INSERT INTO acq_deal_rights 
                                  (acq_deal_code, 
                                   is_exclusive, 
                                   is_title_language_right, 
                                   is_sub_license, 
                                   sub_license_code, 
                                   is_theatrical_right, 
                                   right_type, 
                                   original_right_type, 
                                   is_tentative, 
                                   term, 
                                   right_start_date, 
                                   right_end_date, 
                                   milestone_type_code, 
                                   milestone_no_of_unit, 
                                   milestone_unit_type, 
                                   is_rofr, 
                                   rofr_date, 
                                   restriction_remarks, 
                                   effective_start_date, 
                                   actual_right_start_date, 
                                   actual_right_end_date, 
                                   inserted_by, 
                                   inserted_on, 
                                   is_verified,
								   Promoter_Flag) 
                      SELECT @New_Acq_Deal_Code, 
                             is_exclusive, 
                             is_title_language_right, 
                             is_sub_license, 
                             sub_license_code, 
                             is_theatrical_right, 
                             right_type, 
                             original_right_type, 
                             is_tentative, 
                             term, 
                             right_start_date, 
                             right_end_date, 
                             milestone_type_code, 
                             milestone_no_of_unit, 
                             milestone_unit_type, 
                             is_rofr, 
                             rofr_date, 
                             restriction_remarks, 
                             effective_start_date, 
                             actual_right_start_date, 
                             actual_right_end_date, 
                             @User_Code, 
                             Getdate(), 
                             'N',
							 Promoter_Flag
                      FROM   acq_deal_rights 
                      WHERE  acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      --VALUES(@CurrIdent_AT_Acq_Deal, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, @Is_Theatrical_Right,
                      --@Right_Type,@Is_Tentative,@Term,@Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, @Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date,
                      --@Restriction_Remarks,@Effective_Start_Date,@Actual_Right_Start_Date,@Actual_Right_End_Date,@Inserted_By,@Inserted_On,@Last_Updated_Time,@Last_Action_By)
                      SELECT @New_Acq_Deal_Rights_Code = 
                             Ident_current('Acq_Deal_Rights') 

                      /**************** Insert into AT_Acq_Deal_Rights_Title ****************/ 
                      INSERT INTO acq_deal_rights_title 
                                  (acq_deal_rights_code, 
                                   title_code, 
                                   episode_from, 
                                   episode_to) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             DRT.newtitle_code, 
                             DRT.episode_starts_from, 
                             DRT.episode_end_to 
                      FROM   acq_deal_rights_title ADRT 
                             INNER JOIN #temptitle DRT 
                                     ON ADRT.title_code = DRT.title_code 
                                        AND ADRT.episode_from = 
                                            DRT.old_episode_from 
                                        AND ADRT.episode_to = DRT.old_episode_to 
                      WHERE  ADRT.acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Title_Eps ****************/
                      INSERT INTO acq_deal_rights_title_eps 
                                  (acq_deal_rights_title_code, 
                                   eps_no) 
                      SELECT AtADRT.acq_deal_rights_title_code, 
                             ADRTE.eps_no 
                      FROM   acq_deal_rights_title_eps ADRTE 
                             INNER JOIN acq_deal_rights_title ADRT 
                                     ON ADRTE.acq_deal_rights_title_code = 
                                        ADRT.acq_deal_rights_title_code 
                             INNER JOIN #temptitle DRT 
                                     ON ADRT.title_code = DRT.title_code 
                                        AND ADRT.episode_from = 
                                            DRT.old_episode_from 
                                        AND ADRT.episode_to = DRT.old_episode_to 
                             INNER JOIN acq_deal_rights_title AtADRT 
                                     ON Cast(Isnull(AtADRT.title_code, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRT.episode_from, '') 
                                        AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRT.episode_to, '') AS 
                                        VARCHAR) = 
                                        Cast(Isnull(ADRT.title_code, '' 
                                        ) AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(ADRT.episode_from, '' 
                                        ) AS 
                                        VARCHAR 
                                        ) 
                                        + '~' 
                                        + Cast(Isnull(ADRT.episode_to, '') 
                                        AS 
                                        VARCHAR 
                                        ) 
                      WHERE  ADRT.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRT.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Platform ****************/
                      INSERT INTO acq_deal_rights_platform 
                                  (acq_deal_rights_code, 
                                   platform_code) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             ADRP.platform_code 
                      FROM   acq_deal_rights_platform ADRP 
                      WHERE  acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Territory ****************/
                      INSERT INTO acq_deal_rights_territory 
                                  (acq_deal_rights_code, 
                                   territory_code, 
                                   territory_type, 
                                   country_code) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             ADRT.territory_code, 
                             ADRT.territory_type, 
                             ADRT.country_code 
                      FROM   acq_deal_rights_territory ADRT 
                      WHERE  acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Subtitling ****************/
                      INSERT INTO acq_deal_rights_subtitling 
                                  (acq_deal_rights_code, 
                                   language_code, 
                                   language_group_code, 
                                   language_type) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             ADRS.language_code, 
                             ADRS.language_group_code, 
                             ADRS.language_type 
                      FROM   acq_deal_rights_subtitling ADRS 
                      WHERE  acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Dubbing ****************/
                      INSERT INTO acq_deal_rights_dubbing 
                                  (acq_deal_rights_code, 
                                   language_code, 
                                   language_group_code, 
                                   language_type) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             ADRD.language_code, 
                             ADRD.language_group_code, 
                             ADRD.language_type 
                      FROM   acq_deal_rights_dubbing ADRD 
                      WHERE  acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Holdback ****************/
                      INSERT INTO acq_deal_rights_holdback 
                                  (acq_deal_rights_code, 
                                   holdback_type, 
                                   hb_run_after_release_no, 
                                   hb_run_after_release_units, 
                                   holdback_on_platform_code, 
                                   holdback_release_date, 
                                   holdback_comment, 
                                   is_title_language_right) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             ADRH.holdback_type, 
                             ADRH.hb_run_after_release_no, 
                             ADRH.hb_run_after_release_units, 
                             ADRH.holdback_on_platform_code, 
                             ADRH.holdback_release_date, 
                             ADRH.holdback_comment, 
                             ADRH.is_title_language_right 
                      FROM   acq_deal_rights_holdback ADRH 
                      WHERE  acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Holdback_Dubbing ********/ 
                      INSERT INTO acq_deal_rights_holdback_dubbing 
                                  (acq_deal_rights_holdback_code, 
                                   language_code) 
                      SELECT AtADRH.acq_deal_rights_holdback_code, 
                             ADRHD.language_code 
                      FROM   acq_deal_rights_holdback_dubbing ADRHD 
                             INNER JOIN acq_deal_rights_holdback ADRH 
                                     ON ADRHD.acq_deal_rights_holdback_code = 
                                        ADRH.acq_deal_rights_holdback_code 
                             INNER JOIN acq_deal_rights_holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.hb_run_after_release_no, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.hb_run_after_release_units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.holdback_on_platform_code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.holdback_release_date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_type, '') + '~' 
                             + Isnull(AtADRH.is_title_language_right, '') = 
                             Cast(Isnull(ADRH.hb_run_after_release_no, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.hb_run_after_release_units, 
                             '') 
                             + '~' + Isnull(ADRH.holdback_comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.holdback_on_platform_code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.holdback_release_date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.holdback_type, '') + '~' 
                             + Isnull(ADRH.is_title_language_right, '') 
                      WHERE  ADRH.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRH.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Holdback_Platform ********/ 
                      INSERT INTO acq_deal_rights_holdback_platform 
                                  (acq_deal_rights_holdback_code, 
                                   platform_code) 
                      SELECT AtADRH.acq_deal_rights_holdback_code, 
                             ADRHP.platform_code 
                      FROM   acq_deal_rights_holdback_platform ADRHP 
                             INNER JOIN acq_deal_rights_holdback ADRH 
                                     ON ADRHP.acq_deal_rights_holdback_code = 
                                        ADRH.acq_deal_rights_holdback_code 
                             INNER JOIN acq_deal_rights_holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.hb_run_after_release_no, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.hb_run_after_release_units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.holdback_on_platform_code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.holdback_release_date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_type, '') + '~' 
                             + Isnull(AtADRH.is_title_language_right, '') = 
                             Cast(Isnull(ADRH.hb_run_after_release_no, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.hb_run_after_release_units, 
                             '') 
                             + '~' + Isnull(ADRH.holdback_comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.holdback_on_platform_code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.holdback_release_date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.holdback_type, '') + '~' 
                             + Isnull(ADRH.is_title_language_right, '') 
                      WHERE  ADRH.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRH.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Holdback_Subtitling ********/ 
                      INSERT INTO acq_deal_rights_holdback_subtitling 
                                  (acq_deal_rights_holdback_code, 
                                   language_code) 
                      SELECT AtADRH.acq_deal_rights_holdback_code, 
                             ADRHS.language_code 
                      FROM   acq_deal_rights_holdback_subtitling ADRHS 
                             INNER JOIN acq_deal_rights_holdback ADRH 
                                     ON ADRHS.acq_deal_rights_holdback_code = 
                                        ADRH.acq_deal_rights_holdback_code 
                             INNER JOIN acq_deal_rights_holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.hb_run_after_release_no, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.hb_run_after_release_units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.holdback_on_platform_code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.holdback_release_date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_type, '') + '~' 
                             + Isnull(AtADRH.is_title_language_right, '') = 
                             Cast(Isnull(ADRH.hb_run_after_release_no, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.hb_run_after_release_units, 
                             '') 
                             + '~' + Isnull(ADRH.holdback_comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.holdback_on_platform_code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.holdback_release_date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.holdback_type, '') + '~' 
                             + Isnull(ADRH.is_title_language_right, '') 
                      WHERE  ADRH.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRH.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Holdback_Territory ********/ 
                      INSERT INTO acq_deal_rights_holdback_territory 
                                  (acq_deal_rights_holdback_code, 
                                   territory_type, 
                                   country_code, 
                                   territory_code) 
                      SELECT AtADRH.acq_deal_rights_holdback_code, 
                             territory_type, 
                             country_code, 
                             territory_code 
                      FROM   acq_deal_rights_holdback_territory ADRHT 
                             INNER JOIN acq_deal_rights_holdback ADRH 
                                     ON ADRHT.acq_deal_rights_holdback_code = 
                                        ADRH.acq_deal_rights_holdback_code 
                             INNER JOIN acq_deal_rights_holdback AtADRH 
                                     ON 
                             Cast(Isnull(AtADRH.hb_run_after_release_no, '' 
                             ) AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Isnull(AtADRH.hb_run_after_release_units, '' 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_comment, '') + 
                             '~' 
                             + Cast(Isnull(AtADRH.holdback_on_platform_code, '' 
                             ) 
                             AS 
                             VARCHAR 
                             ) 
                             + '~' 
                             + Cast(Isnull(AtADRH.holdback_release_date, '') AS 
                             VARCHAR 
                             ) 
                             + '~' + Isnull(AtADRH.holdback_type, '') + '~' 
                             + Isnull(AtADRH.is_title_language_right, '') = 
                             Cast(Isnull(ADRH.hb_run_after_release_no, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Isnull(ADRH.hb_run_after_release_units, 
                             '') 
                             + '~' + Isnull(ADRH.holdback_comment, '') 
                             + 
                             '~' 
                             + Cast(Isnull(ADRH.holdback_on_platform_code, 
                             '') 
                             AS 
                             VARCHAR) 
                             + '~' 
                             + Cast(Isnull(ADRH.holdback_release_date, '') 
                             AS 
                             VARCHAR) 
                             + '~' + Isnull(ADRH.holdback_type, '') + '~' 
                             + Isnull(ADRH.is_title_language_right, '') 
                      WHERE  ADRH.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRH.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /**************** Insert into AT_Acq_Deal_Rights_Blackout ****************/
                      INSERT INTO acq_deal_rights_blackout 
                                  (acq_deal_rights_code, 
                                   start_date, 
                                   end_date, 
                                   inserted_by, 
                                   inserted_on) 
                      SELECT @New_Acq_Deal_Rights_Code, 
                             ADRB.start_date, 
                             ADRB.end_date, 
                             @User_Code, 
                             Getdate() 
                      FROM   acq_deal_rights_blackout ADRB 
                      WHERE  ADRB.acq_deal_rights_code = @Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Blackout_Dubbing ********/ 
                      INSERT INTO acq_deal_rights_blackout_dubbing 
                                  (acq_deal_rights_blackout_code, 
                                   language_code) 
                      SELECT AtADRB.acq_deal_rights_blackout_code, 
                             ADRBD.language_code 
                      FROM   acq_deal_rights_blackout_dubbing ADRBD 
                             INNER JOIN acq_deal_rights_blackout ADRB 
                                     ON ADRBD.acq_deal_rights_blackout_code = 
                                        ADRB.acq_deal_rights_blackout_code 
                             INNER JOIN acq_deal_rights_blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.start_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.end_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.inserted_by, '') AS 
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
                      WHERE  ADRB.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRB.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Blackout_Platform ********/ 
                      INSERT INTO acq_deal_rights_blackout_platform 
                                  (acq_deal_rights_blackout_code, 
                                   platform_code) 
                      SELECT AtADRB.acq_deal_rights_blackout_code, 
                             ADRBP.platform_code 
                      FROM   acq_deal_rights_blackout_platform ADRBP 
                             INNER JOIN acq_deal_rights_blackout ADRB 
                                     ON ADRBP.acq_deal_rights_blackout_code = 
                                        ADRB.acq_deal_rights_blackout_code 
                             INNER JOIN acq_deal_rights_blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.start_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.end_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.inserted_by, '') AS 
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
                      WHERE  ADRB.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRB.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Blackout_Subtitling ********/ 
                      INSERT INTO acq_deal_rights_blackout_subtitling 
                                  (acq_deal_rights_blackout_code, 
                                   language_code) 
                      SELECT AtADRB.acq_deal_rights_blackout_code, 
                             ADRBS.language_code 
                      FROM   acq_deal_rights_blackout_subtitling ADRBS 
                             INNER JOIN acq_deal_rights_blackout ADRB 
                                     ON ADRBS.acq_deal_rights_blackout_code = 
                                        ADRB.acq_deal_rights_blackout_code 
                             INNER JOIN acq_deal_rights_blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.start_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.end_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.inserted_by, '') AS 
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
                      WHERE  ADRB.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRB.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

                      /******** Insert into AT_Acq_Deal_Rights_Blackout_Territory ********/ 
                      INSERT INTO acq_deal_rights_blackout_territory 
                                  (acq_deal_rights_blackout_code, 
                                   country_code, 
                                   territory_code, 
                                   territory_type) 
                      SELECT AtADRB.acq_deal_rights_blackout_code, 
                             ADRBT.country_code, 
                             ADRBT.territory_code, 
                             ADRBT.territory_type 
                      FROM   acq_deal_rights_blackout_territory ADRBT 
                             INNER JOIN acq_deal_rights_blackout ADRB 
                                     ON ADRBT.acq_deal_rights_blackout_code = 
                                        ADRB.acq_deal_rights_blackout_code 
                             INNER JOIN acq_deal_rights_blackout AtADRB 
                                     ON Cast(Isnull(AtADRB.start_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.end_date, '') AS 
                                        VARCHAR) 
                                        + '~' 
                                        + Cast(Isnull(AtADRB.inserted_by, '') AS 
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
                      WHERE  ADRB.acq_deal_rights_code = @Acq_Deal_Rights_Code 
                             AND AtADRB.acq_deal_rights_code = 
                                 @New_Acq_Deal_Rights_Code 

					/**************** Insert into AT_Acq_Deal_Rights_Promoter ****************/ 
                      INSERT INTO Acq_Deal_Rights_Promoter(Acq_Deal_Rights_Code, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
                      SELECT @New_Acq_Deal_Rights_Code, @User_Code, GETDATE(), GETDATE(), @User_Code
                      FROM Acq_Deal_Rights_Promoter ADRP WHERE ADRP.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					
					--Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * FROM Acq_Deal_Rights_Promoter

					/******** Insert into Acq_Deal_Rights_Promoter_Group ********/ 
                      INSERT INTO Acq_Deal_Rights_Promoter_Group( Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code)
                      SELECT ADRPNew.Acq_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code
                      FROM (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

					  --Inner Join Acq_Deal_Rights_Promoter ADRPOLD On Row_Number() over(order by ADRP.Acq_Deal_Rights_Promoter_Code Asc)
					
					/******** Insert into AT_Acq_Deal_Rights_Promoter_Remarks ********/ 
                      INSERT INTO Acq_Deal_Rights_Promoter_Remarks(Acq_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
                      SELECT ADRPNew.Acq_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code 
					  FROM (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId


                      --FROM Acq_Deal_Rights_Promoter ADRP 
                      --INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code


--                      DECLARE c_Promoter CURSOR FOR 
--                        SELECT acq_deal_rights_promoter_code 
--                        FROM   acq_deal_rights_promoter ADRP 
--                        WHERE  ADRP.acq_deal_rights_code = @Acq_Deal_Rights_Code 

--                      OPEN c_Promoter 

--                      FETCH next FROM c_Promoter INTO 
--                      @Acq_deal_Rights_Promoter_code 

--                      WHILE( @@FETCH_STATUS = 0 ) 
--                        BEGIN 
--                            INSERT INTO acq_deal_rights_promoter 
--                            VALUES     (@New_Acq_Deal_Rights_Code, 
--                                        Getdate(), 
--                                        @User_Code, 
--                                        Getdate(), 
--                                        @User_Code) 

--                            SELECT @New_Acq_Deal_Rights_Promoter_Code = 
--                                   Ident_current('Acq_Deal_Rights_Promoter') 

                            
--                          INSERT into acq_deal_rights_Promoter_group (Acq_Deal_Rights_Promoter_Code,Promoter_Group_Code)
--		 SELECT @New_Acq_Deal_Rights_Promoter_Code,Promoter_Group_Code FROM Acq_Deal_Rights_Promoter_Group  WHERE Acq_Deal_Rights_Promoter_Code = @Acq_deal_Rights_Promoter_code


--		   INSERT INTO acq_deal_rights_Promoter_Remarks (Acq_Deal_Rights_Promoter_Code,Promoter_Remarks_Code)
--		 select @New_Acq_Deal_Rights_Promoter_Code,Promoter_Remarks_Code from Acq_Deal_Rights_Promoter_Remarks where Acq_Deal_Rights_Promoter_Code = @Acq_deal_Rights_Promoter_code

--FETCH next FROM c_Promoter INTO 
--@Acq_deal_Rights_Promoter_code 
--END 

--CLOSE c_Promoter 

--DEALLOCATE c_Promoter 
END 

FETCH next FROM rights_cursor INTO @Acq_Deal_Rights_Code 
END 

			CLOSE rights_cursor; 
			DEALLOCATE rights_cursor; 
			--=================================RIGHTS_CURSOR END========================================
			--=================================PUSHBACK_CURSOR START========================================
			DECLARE @New_Acq_Deal_Pushback_Code INT = 0, @Acq_Deal_Pushback_Code     INT = 0

			DECLARE pushback_cursor CURSOR FOR 
			SELECT acq_deal_pushback_code FROM   acq_deal_pushback WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN pushback_cursor 
			FETCH next FROM pushback_cursor INTO @Acq_Deal_Pushback_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   #temptitle tt 
			INNER JOIN acq_deal_pushback_title ADPT 
			ON ADPT.title_code = tt.title_code 
			WHERE  ADPT.acq_deal_pushback_code = @Acq_Deal_Pushback_Code) 
			> 0 
			) 
			BEGIN 
			/******************************** Insert into AT_Acq_Deal_Pushback *****************************************/
			INSERT INTO acq_deal_pushback 
			(acq_deal_code, 
			right_type, 
			is_tentative, 
			term, 
			right_start_date, 
			right_end_date, 
			milestone_type_code, 
			milestone_no_of_unit, 
			milestone_unit_type, 
			is_title_language_right, 
			remarks, 
			inserted_by, 
			inserted_on) 
			SELECT @New_Acq_Deal_Code, 
			right_type, 
			is_tentative, 
			term, 
			right_start_date, 
			right_end_date, 
			milestone_type_code, 
			milestone_no_of_unit, 
			milestone_unit_type, 
			is_title_language_right, 
			remarks, 
			@User_Code, 
			Getdate() 
			FROM   acq_deal_pushback 
			WHERE  acq_deal_pushback_code = @Acq_Deal_Pushback_Code 

			SELECT @New_Acq_Deal_Pushback_Code = 
			Ident_current('Acq_Deal_Pushback' 
			) 

			/**************** Insert into AT_Acq_Deal_Pushback_Dubbing ****************/ 
			INSERT INTO acq_deal_pushback_dubbing 
			(acq_deal_pushback_code, 
			language_type, 
			language_code, 
			language_group_code) 
			SELECT @New_Acq_Deal_Pushback_Code, 
			ADPD.language_type, 
			ADPD.language_code, 
			ADPD.language_group_code 
			FROM   acq_deal_pushback_dubbing ADPD 
			WHERE  ADPD.acq_deal_pushback_code = @Acq_Deal_Pushback_Code 

			/**************** Insert into AT_Acq_Deal_Pushback_Platform ****************/ 
			INSERT INTO acq_deal_pushback_platform 
			(acq_deal_pushback_code, 
			platform_code) 
			SELECT @New_Acq_Deal_Pushback_Code, 
			ADPP.platform_code 
			FROM   acq_deal_pushback_platform ADPP 
			WHERE  ADPP.acq_deal_pushback_code = @Acq_Deal_Pushback_Code 

			/**************** Insert into AT_Acq_Deal_Pushback_Subtitling ****************/ 
			INSERT INTO acq_deal_pushback_subtitling 
			(acq_deal_pushback_code, 
			language_type, 
			language_code, 
			language_group_code) 
			SELECT @New_Acq_Deal_Pushback_Code, 
			ADPS.language_type, 
			ADPS.language_code, 
			ADPS.language_group_code 
			FROM   acq_deal_pushback_subtitling ADPS 
			WHERE  ADPS.acq_deal_pushback_code = @Acq_Deal_Pushback_Code 

			/**************** Insert into AT_Acq_Deal_Pushback_Territory ****************/ 
			INSERT INTO acq_deal_pushback_territory 
			(acq_deal_pushback_code, 
			territory_type, 
			country_code, 
			territory_code) 
			SELECT @New_Acq_Deal_Pushback_Code, 
			ADPT.territory_type, 
			ADPT.country_code, 
			ADPT.territory_code 
			FROM   acq_deal_pushback_territory ADPT 
			WHERE  ADPT.acq_deal_pushback_code = @Acq_Deal_Pushback_Code 

			/**************** Insert into AT_Acq_Deal_Pushback_Title ****************/ 
			INSERT INTO acq_deal_pushback_title 
			(acq_deal_pushback_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Pushback_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   #temptitle tt 
			INNER JOIN acq_deal_pushback_title ADPT 
			ON ADPT.title_code = tt.title_code 
			AND ADPT.episode_from = 
			tt.old_episode_from 
			AND ADPT.episode_to = tt.old_episode_to 
			WHERE  ADPT.acq_deal_pushback_code = @Acq_Deal_Pushback_Code 
			END 
			FETCH next FROM pushback_cursor INTO @Acq_Deal_Pushback_Code 
			END 

			CLOSE pushback_cursor 
			DEALLOCATE pushback_cursor 
			--=================================PUSHBACK_CURSOR END========================================
			--=================================ANCILLARY_CURSOR START========================================
			DECLARE @New_Acq_Deal_Ancillary_Code INT = 0, @Acq_Deal_Ancillary_Code     INT = 0 
			DECLARE ancillary_cursor CURSOR FOR 
			SELECT acq_deal_ancillary_code FROM   acq_deal_ancillary WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN ancillary_cursor 
			FETCH next FROM ancillary_cursor INTO @Acq_Deal_Ancillary_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_ancillary_title ADAT 
			INNER JOIN #temptitle tt 
			ON ADAT.title_code = tt.title_code 
			WHERE  ADAT.acq_deal_ancillary_code = 
			@Acq_Deal_Ancillary_Code) > 
			0 ) 
			BEGIN 
			/******************************** Insert into AT_Acq_Deal_Ancillary *****************************************/
			INSERT INTO acq_deal_ancillary 
			(acq_deal_code, 
			ancillary_type_code, 
			duration, 
			[day], 
			remarks, 
			group_no,
			Catch_Up_From) 
			SELECT @New_Acq_Deal_Code, 
			ancillary_type_code, 
			duration, 
			[day], 
			remarks, 
			group_no,
			Catch_Up_From
			FROM   acq_deal_ancillary 
			WHERE  acq_deal_ancillary_code = @Acq_Deal_Ancillary_Code 

			--VALUES( 
			--@CurrIdent_AT_Acq_Deal, @Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No) 
			SELECT @New_Acq_Deal_Ancillary_Code = 
			Ident_current('Acq_Deal_Ancillary') 

			/**************** Insert into AT_Acq_Deal_Ancillary_Platform ****************/ 
			INSERT INTO acq_deal_ancillary_platform 
			(acq_deal_ancillary_code, 
			ancillary_platform_code) 
			SELECT @New_Acq_Deal_Ancillary_Code, 
			ADAP.ancillary_platform_code 
			FROM   acq_deal_ancillary_platform ADAP 
			WHERE  ADAP.acq_deal_ancillary_code = 
			@Acq_Deal_Ancillary_Code 

			/******** Insert into AT_Acq_Deal_Ancillary_Platform_Medium ********/ 
			INSERT INTO acq_deal_ancillary_platform_medium 
			(acq_deal_ancillary_platform_code, 
			ancillary_platform_medium_code) 
			SELECT AtADAP.acq_deal_ancillary_platform_code, 
			ADAPM.ancillary_platform_medium_code 
			FROM   acq_deal_ancillary_platform_medium ADAPM 
			INNER JOIN acq_deal_ancillary_platform ADAP 
			ON ADAPM.acq_deal_ancillary_platform_code = 
			ADAP.acq_deal_ancillary_platform_code 
			INNER JOIN acq_deal_ancillary_platform AtADAP 
			ON AtADAP.ancillary_platform_code = 
			ADAP.ancillary_platform_code 
			WHERE  ADAP.acq_deal_ancillary_code = 
			@Acq_Deal_Ancillary_Code 
			AND AtADAP.acq_deal_ancillary_code = 
			@New_Acq_Deal_Ancillary_Code 

			/**************** Insert into AT_Acq_Deal_Ancillary_Title ****************/ 
			INSERT INTO acq_deal_ancillary_title 
			(acq_deal_ancillary_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Ancillary_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_ancillary_title ADAT 
			INNER JOIN #temptitle tt 
			ON ADAT.title_code = tt.title_code 
			AND ADAT.episode_from = 
			tt.old_episode_from 
			AND ADAT.episode_to = tt.old_episode_to 
			WHERE  ADAT.acq_deal_ancillary_code = 
			@Acq_Deal_Ancillary_Code 
			END 

			FETCH next FROM ancillary_cursor INTO @Acq_Deal_Ancillary_Code 
			END 

			CLOSE ancillary_cursor 
			DEALLOCATE ancillary_cursor 
			--=================================ANCILLARY_CURSOR END========================================
			--=================================RUN_CURSOR START========================================
			DECLARE @New_Acq_Deal_Run_Code INT = 0, @Acq_Deal_Run_Code     INT 
			DECLARE run_cursor CURSOR FOR 
			SELECT acq_deal_run_code FROM   acq_deal_run WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN run_cursor 
			FETCH next FROM run_cursor INTO @Acq_Deal_Run_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_run_title ADRT 
			INNER JOIN #temptitle tt 
			ON ADRT.title_code = tt.title_code 
			WHERE  ADRT.acq_deal_run_code = @Acq_Deal_Run_Code) > 0 ) 
			BEGIN 
			/******************************** Insert into AT_Acq_Deal_Run *****************************************/
			INSERT INTO acq_deal_run 
			(acq_deal_code, 
			run_type, 
			no_of_runs, 
			no_of_runs_sched, 
			no_of_asruns, 
			is_yearwise_definition, 
			is_rule_right, 
			right_rule_code, 
			repeat_within_days_hrs, 
			no_of_days_hrs, 
			is_channel_definition_rights, 
			primary_channel_code, 
			run_definition_type, 
			run_definition_group_code, 
			all_channel, 
			prime_start_time, 
			prime_end_time, 
			off_prime_start_time, 
			off_prime_end_time, 
			time_lag_simulcast, 
			prime_run, 
			off_prime_run, 
			prime_time_provisional_run_count, 
			prime_time_asrun_count, 
			prime_time_balance_count, 
			off_prime_time_provisional_run_count, 
			off_prime_time_asrun_count, 
			off_prime_time_balance_count, 
			inserted_on, 
			inserted_by,Channel_Type, Channel_Category_Code) 
			SELECT @New_Acq_Deal_Code, 
			run_type, 
			no_of_runs, 
			0, 
			0, 
			is_yearwise_definition, 
			is_rule_right, 
			right_rule_code, 
			repeat_within_days_hrs, 
			no_of_days_hrs, 
			is_channel_definition_rights, 
			primary_channel_code, 
			run_definition_type, 
			run_definition_group_code, 
			all_channel, 
			prime_start_time, 
			prime_end_time, 
			off_prime_start_time, 
			off_prime_end_time, 
			time_lag_simulcast, 
			prime_run, 
			off_prime_run, 
			0 AS Prime_Time_Provisional_Run_Count, 
			0 AS Prime_Time_AsRun_Count, 
			0 AS Prime_Time_Balance_Count, 
			0 AS Off_Prime_Time_Provisional_Run_Count, 
			0 AS Off_Prime_Time_AsRun_Count, 
			0 AS Off_Prime_Time_Balance_Count, 
			Getdate(), 
			@User_Code,
			Channel_Type,
			Channel_Category_Code
			FROM   acq_deal_run 
			WHERE  acq_deal_run_code = @Acq_Deal_Run_Code 

			SELECT @New_Acq_Deal_Run_Code = Ident_current('Acq_Deal_Run' 
					) 

			/**************** Insert into AT_Acq_Deal_Run_Title ****************/ 
			INSERT INTO acq_deal_run_title 
			(acq_deal_run_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Run_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_run_title ADRT 
			INNER JOIN #temptitle tt 
			ON ADRT.title_code = tt.title_code 
			AND ADRT.episode_from = 
			tt.old_episode_from 
			AND ADRT.episode_to = tt.old_episode_to 
			WHERE  ADRT.acq_deal_run_code = @Acq_Deal_Run_Code 

			--Print 'ad 2.1' 
			/**************** Insert into AT_Acq_Deal_Run_Channel ****************/ 
			INSERT INTO acq_deal_run_channel 
			(acq_deal_run_code, 
			channel_code, 
			min_runs, 
			max_runs, 
			no_of_runs_sched, 
			no_of_asruns, 
			do_not_consume_rights, 
			is_primary, 
			inserted_by, 
			inserted_on) 
			SELECT @New_Acq_Deal_Run_Code, 
			ADRC.channel_code, 
			ADRC.min_runs, 
			ADRC.max_runs, 
			0, 
			0, 
			ADRC.do_not_consume_rights, 
			ADRC.is_primary, 
			@User_Code, 
			Getdate() 
			FROM   acq_deal_run_channel ADRC 
			WHERE  ADRC.acq_deal_run_code = @Acq_Deal_Run_Code 

			/**************** Insert into AT_Acq_Deal_Run_Repeat_On_Day ****************/ 
			INSERT INTO acq_deal_run_repeat_on_day 
			(acq_deal_run_code, 
			day_code) 
			SELECT @New_Acq_Deal_Run_Code, 
			ADRRD.day_code 
			FROM   acq_deal_run_repeat_on_day ADRRD 
			WHERE  ADRRD.acq_deal_run_code = @Acq_Deal_Run_Code 

			/**************** Insert into AT_Acq_Deal_Run_Yearwise_Run ****************/ 
			--Print 'ad 2.2' 
			INSERT INTO acq_deal_run_yearwise_run 
			(acq_deal_run_code, 
			start_date, 
			end_date, 
			no_of_runs, 
			no_of_runs_sched, 
			no_of_asruns, 
			inserted_by, 
			inserted_on, 
			year_no) 
			SELECT @New_Acq_Deal_Run_Code, 
			ADRYR.start_date, 
			ADRYR.end_date, 
			ADRYR.no_of_runs, 
			0, 
			0, 
			@User_Code, 
			Getdate(), 
			ADRYR.year_no 
			FROM   acq_deal_run_yearwise_run ADRYR 
			WHERE  ADRYR.acq_deal_run_code = @Acq_Deal_Run_Code 

			/******** Insert into AT_Acq_Deal_Run_Yearwise_Run_Week ********/ 
			INSERT INTO acq_deal_run_yearwise_run_week 
			(acq_deal_run_yearwise_run_code, 
			acq_deal_run_code, 
			start_week_date, 
			end_week_date, 
			is_preferred, 
			inserted_by, 
			inserted_on) 
			SELECT AtADRYR.acq_deal_run_yearwise_run_code, 
			@New_Acq_Deal_Run_Code, 
			ADRYRW.start_week_date, 
			ADRYRW.end_week_date, 
			ADRYRW.is_preferred, 
			@User_Code, 
			Getdate() 
			FROM   acq_deal_run_yearwise_run ADRYR 
			INNER JOIN acq_deal_run_yearwise_run_week ADRYRW 
			ON ADRYRW.acq_deal_run_yearwise_run_code = 
			ADRYR.acq_deal_run_yearwise_run_code 
			INNER JOIN acq_deal_run_yearwise_run AtADRYR 
			ON Cast(Isnull(AtADRYR.start_date, '') AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.end_date, '') AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.no_of_runs, '') AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.no_of_runs_sched, '' 
			) AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.no_of_asruns, '') AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.inserted_by, '') AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.inserted_on, '') AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.last_action_by, '') 
			AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADRYR.last_updated_time, 
			'') 
			AS 
			VARCHAR) 
			= 
			Cast(Isnull(ADRYR.start_date, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADRYR.end_date, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADRYR.no_of_runs, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADRYR.no_of_runs_sched, 
			'') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADRYR.no_of_asruns, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADRYR.inserted_by, '') AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(ADRYR.inserted_on, '') AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(ADRYR.last_action_by, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADRYR.last_updated_time, 
			'' 
			) AS 
			VARCHAR) 
			WHERE  ADRYR.acq_deal_run_code = @Acq_Deal_Run_Code 
			AND AtADRYR.acq_deal_run_code = 
			@New_Acq_Deal_Run_Code 
			END 

			--Print 'ad 2.3' 
			FETCH next FROM run_cursor INTO @Acq_Deal_Run_Code 
			END 

			CLOSE run_cursor 
			DEALLOCATE run_cursor 
			--=================================RUN_CURSOR END========================================
			--=================================CUR_COST START========================================
			DECLARE @Acq_Deal_Cost_Code     INT = 0, @New_Acq_Deal_Cost_Code INT = 0 
			DECLARE cur_cost CURSOR FOR 
			SELECT acq_deal_cost_code FROM   acq_deal_cost WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN cur_cost 
			FETCH next FROM cur_cost INTO @Acq_Deal_Cost_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_cost_title ADCT 
			INNER JOIN #temptitle tt 
			ON ADCT.title_code = tt.title_code 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code) > 0 ) 
			BEGIN 
			/******************************** Insert into Acq_Deal_Cost *****************************************/
			INSERT INTO acq_deal_cost 
			(acq_deal_code, 
			currency_code, 
			currency_exchange_rate, 
			deal_cost, 
			deal_cost_per_episode, 
			cost_center_id, 
			additional_cost, 
			catchup_cost, 
			variable_cost_type, 
			variable_cost_sharing_type, 
			royalty_recoupment_code, 
			inserted_on, 
			inserted_by) 
			SELECT @New_Acq_Deal_Code, 
			currency_code, 
			currency_exchange_rate, 
			deal_cost, 
			deal_cost_per_episode, 
			cost_center_id, 
			additional_cost, 
			catchup_cost, 
			variable_cost_type, 
			variable_cost_sharing_type, 
			royalty_recoupment_code, 
			Getdate(), 
			@User_Code 
			FROM   acq_deal_cost 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code 

			SELECT @New_Acq_Deal_Cost_Code = 
			Ident_current('Acq_Deal_Cost') 

			/**************** Insert into AT_Acq_Deal_Cost_Additional_Exp ****************/ 
			INSERT INTO acq_deal_cost_additional_exp 
			(acq_deal_cost_code, 
			additional_expense_code, 
			amount, 
			min_max, 
			inserted_on, 
			inserted_by) 
			SELECT @New_Acq_Deal_Cost_Code, 
			ADCAE.additional_expense_code, 
			ADCAE.amount, 
			ADCAE.min_max, 
			Getdate(), 
			@User_Code 
			FROM   acq_deal_cost_additional_exp ADCAE 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code 

			INSERT INTO acq_deal_cost_commission 
			(acq_deal_cost_code, 
			cost_type_code, 
			royalty_commission_code, 
			entity_code, 
			vendor_code, 
			type, 
			commission_type, 
			percentage, 
			amount) 
			SELECT @New_Acq_Deal_Cost_Code, 
			ADCC.cost_type_code, 
			ADCC.royalty_commission_code, 
			ADCC.entity_code, 
			ADCC.vendor_code, 
			ADCC.type, 
			ADCC.commission_type, 
			ADCC.percentage, 
			ADCC.amount 
			FROM   acq_deal_cost_commission ADCC 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code 

			INSERT INTO acq_deal_cost_title 
			(acq_deal_cost_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Cost_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_cost_title ADCT 
			INNER JOIN #temptitle tt 
			ON ADCT.title_code = tt.title_code 
			AND ADCT.episode_from = 
			tt.old_episode_from 
			AND ADCT.episode_to = tt.old_episode_to 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code 

			INSERT INTO acq_deal_cost_variable_cost 
			(acq_deal_cost_code, 
			entity_code, 
			vendor_code, 
			percentage, 
			amount, 
			inserted_on, 
			inserted_by) 
			SELECT @New_Acq_Deal_Cost_Code, 
			ADCVC.entity_code, 
			ADCVC.vendor_code, 
			ADCVC.percentage, 
			ADCVC.amount, 
			Getdate(), 
			@User_Code 
			FROM   acq_deal_cost_variable_cost ADCVC 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code 

			INSERT INTO acq_deal_cost_costtype 
			(acq_deal_cost_code, 
			cost_type_code, 
			amount, 
			consumed_amount, 
			inserted_on, 
			inserted_by) 
			SELECT @New_Acq_Deal_Cost_Code, 
			ADCC.cost_type_code, 
			ADCC.amount, 
			ADCC.consumed_amount, 
			Getdate(), 
			@User_Code 
			FROM   acq_deal_cost_costtype ADCC 
			WHERE  acq_deal_cost_code = @Acq_Deal_Cost_Code 

			INSERT INTO acq_deal_cost_costtype_episode 
			(acq_deal_cost_costtype_code, 
			episode_from, 
			episode_to, 
			amount_type, 
			amount, 
			percentage, 
			remarks) 
			SELECT AtADCC.acq_deal_cost_costtype_code, 
			ADCCE.episode_from, 
			ADCCE.episode_to, 
			ADCCE.amount_type, 
			ADCCE.amount, 
			ADCCE.percentage, 
			ADCCE.remarks 
			FROM   acq_deal_cost_costtype ADCC 
			INNER JOIN acq_deal_cost_costtype_episode ADCCE 
			ON ADCCE.acq_deal_cost_costtype_code = 
			ADCC.acq_deal_cost_costtype_code 
			INNER JOIN acq_deal_cost_costtype AtADCC 
			ON AtADCC.acq_deal_cost_code = 
			@New_Acq_Deal_Cost_Code 
			AND 
			Cast(Isnull(AtADCC.cost_type_code, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(AtADCC.amount, 0) AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADCC.consumed_amount, 
			0) 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(AtADCC.inserted_on, '') 
			AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADCC.inserted_by, '') 
			AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADCC.last_updated_time, '' 
			) AS 
			VARCHAR 
			) 
			+ '~' 
			+ Cast(Isnull(AtADCC.last_action_by, '') 
			AS 
			VARCHAR) 
			= 
			Cast(Isnull(ADCC.cost_type_code, '') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADCC.amount, 0) AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADCC.consumed_amount, 0) 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADCC.inserted_on, '') AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADCC.inserted_by, '') AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADCC.last_updated_time, 
			'') 
			AS 
			VARCHAR) 
			+ '~' 
			+ Cast(Isnull(ADCC.last_action_by, '') 
			AS 
			VARCHAR) 
			WHERE  ADCC.acq_deal_cost_code = @Acq_Deal_Cost_Code 
			END 

			FETCH next FROM cur_cost INTO @Acq_Deal_Cost_Code 
			END 

			CLOSE cur_cost 
			DEALLOCATE cur_cost 
			--=================================CUR_COST END========================================
			--=================================CUR_SPORT START========================================
			DECLARE @Acq_Deal_Sport_Code     INT = 0, @New_Acq_Deal_Sport_Code INT = 0 
			DECLARE cur_sport CURSOR FOR 
			SELECT acq_deal_sport_code FROM   acq_deal_sport WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN cur_sport 
			FETCH next FROM cur_sport INTO @Acq_Deal_Sport_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_sport_title ADST 
			INNER JOIN #temptitle tt 
			ON ADST.title_code = tt.title_code 
			WHERE  acq_deal_sport_code = @Acq_Deal_Sport_Code) > 0 ) 
			BEGIN 
			INSERT INTO acq_deal_sport 
			(acq_deal_code, 
			content_delivery, 
			obligation_broadcast, 
			deferred_live, 
			deferred_live_duration, 
			tape_delayed, 
			tape_delayed_duration, 
			standalone_transmission, 
			standalone_substantial, 
			simulcast_transmission, 
			simulcast_substantial, 
			[file_name], 
			sys_file_name, 
			remarks, 
			inserted_by, 
			inserted_on, 
			mbo_note) 
			SELECT @New_Acq_Deal_Code, 
			content_delivery, 
			obligation_broadcast, 
			deferred_live, 
			deferred_live_duration, 
			tape_delayed, 
			tape_delayed_duration, 
			standalone_transmission, 
			standalone_substantial, 
			simulcast_transmission, 
			simulcast_substantial, 
			[file_name], 
			sys_file_name, 
			remarks, 
			@User_Code, 
			Getdate(), 
			mbo_note 
			FROM   acq_deal_sport 
			WHERE  acq_deal_sport_code = @Acq_Deal_Sport_Code 

			SELECT @New_Acq_Deal_Sport_Code = 
			Ident_current('Acq_Deal_Sport' 
			) 

			/**************** Insert into AT_Acq_Deal_Sport_Broadcast ****************/ 
			INSERT INTO acq_deal_sport_broadcast 
			(acq_deal_sport_code, 
			broadcast_mode_code, 
			[type]) 
			SELECT @New_Acq_Deal_Sport_Code, 
			ADSB.broadcast_mode_code, 
			ADSB.[type] 
			FROM   acq_deal_sport_broadcast ADSB 
			WHERE  acq_deal_sport_code = @Acq_Deal_Sport_Code 

			/**************** Insert into AT_Acq_Deal_Sport_Platform ****************/ 
			INSERT INTO acq_deal_sport_platform 
			(acq_deal_sport_code, 
			platform_code, 
			[type]) 
			SELECT @New_Acq_Deal_Sport_Code, 
			ADSP.platform_code, 
			ADSP.[type] 
			FROM   acq_deal_sport_platform ADSP 
			WHERE  acq_deal_sport_code = @Acq_Deal_Sport_Code 

			/**************** Insert into AT_Acq_Deal_Sport_Title ****************/ 
			INSERT INTO acq_deal_sport_title 
			(acq_deal_sport_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Sport_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_sport_title ADST 
			INNER JOIN #temptitle tt 
			ON ADST.title_code = tt.title_code 
			AND ADST.episode_from = 
			tt.old_episode_from 
			AND ADST.episode_to = tt.old_episode_to 
			WHERE  acq_deal_sport_code = @Acq_Deal_Sport_Code 

			/**************** Insert into AT_Acq_Deal_Sport_Language ****************/ 
			INSERT INTO acq_deal_sport_language 
			(acq_deal_sport_code, 
			language_type, 
			language_code, 
			language_group_code, 
			flag) 
			SELECT @New_Acq_Deal_Sport_Code, 
			language_type, 
			language_code, 
			language_group_code, 
			flag 
			FROM   acq_deal_sport_language 
			WHERE  acq_deal_sport_code = @Acq_Deal_Sport_Code 
			END 

			FETCH next FROM cur_sport INTO @Acq_Deal_Sport_Code 
			END 

			CLOSE cur_sport 
			DEALLOCATE cur_sport 
			--=================================CUR_SPORT END========================================
			--=================================CUR_SPORT_ANCILLARY START========================================
			DECLARE @Acq_Deal_Sport_Ancillary_Code     INT = 0, @New_Acq_Deal_Sport_Ancillary_Code INT = 0 
			DECLARE cur_sport_ancillary CURSOR FOR 
			SELECT acq_deal_sport_ancillary_code FROM   acq_deal_sport_ancillary WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN cur_sport_ancillary 
			FETCH next FROM cur_sport_ancillary INTO @Acq_Deal_Sport_Ancillary_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_sport_ancillary_title ADSAT 
			INNER JOIN #temptitle tt 
			ON ADSAT.title_code = tt.title_code 
			WHERE  acq_deal_sport_ancillary_code = 
			@Acq_Deal_Sport_Ancillary_Code 
			) 
			> 0 
			) 
			BEGIN 
			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary *****************************************/
			INSERT INTO acq_deal_sport_ancillary 
			(acq_deal_code, 
			ancillary_for, 
			sport_ancillary_type_code, 
			obligation_broadcast, 
			broadcast_window, 
			broadcast_periodicity_code, 
			sport_ancillary_periodicity_code, 
			duration, 
			no_of_promos, 
			prime_start_time, 
			prime_end_time, 
			prime_durartion, 
			prime_no_of_promos, 
			off_prime_start_time, 
			off_prime_end_time, 
			off_prime_durartion, 
			off_prime_no_of_promos, 
			remarks) 
			SELECT @New_Acq_Deal_Code, 
			ancillary_for, 
			sport_ancillary_type_code, 
			obligation_broadcast, 
			broadcast_window, 
			broadcast_periodicity_code, 
			sport_ancillary_periodicity_code, 
			duration, 
			no_of_promos, 
			prime_start_time, 
			prime_end_time, 
			prime_durartion, 
			prime_no_of_promos, 
			off_prime_start_time, 
			off_prime_end_time, 
			off_prime_durartion, 
			off_prime_no_of_promos, 
			remarks 
			FROM   acq_deal_sport_ancillary 
			WHERE  acq_deal_sport_ancillary_code = 
			@Acq_Deal_Sport_Ancillary_Code 

			SELECT @New_Acq_Deal_Sport_Ancillary_Code = 
			Ident_current('Acq_Deal_Sport_Ancillary') 

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Broadcast *****************************************/
			INSERT INTO acq_deal_sport_ancillary_broadcast 
			(acq_deal_sport_ancillary_code, 
			sport_ancillary_broadcast_code) 
			SELECT @New_Acq_Deal_Sport_Ancillary_Code, 
			sport_ancillary_broadcast_code 
			FROM   acq_deal_sport_ancillary_broadcast 
			WHERE  acq_deal_sport_ancillary_code = 
			@Acq_Deal_Sport_Ancillary_Code 

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Source *****************************************/
			INSERT INTO acq_deal_sport_ancillary_source 
			(acq_deal_sport_ancillary_code, 
			sport_ancillary_source_code) 
			SELECT @New_Acq_Deal_Sport_Ancillary_Code, 
			sport_ancillary_source_code 
			FROM   acq_deal_sport_ancillary_source 
			WHERE  acq_deal_sport_ancillary_code = 
			@Acq_Deal_Sport_Ancillary_Code 

			/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Title *****************************************/
			INSERT INTO acq_deal_sport_ancillary_title 
			(acq_deal_sport_ancillary_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Sport_Ancillary_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_sport_ancillary_title ADSAT 
			INNER JOIN #temptitle tt 
			ON ADSAT.title_code = tt.title_code 
			--AND ADSAT.Episode_From = tt.Old_Episode_From AND ADSAT.Episode_To = tt.Old_Episode_To 
			WHERE  acq_deal_sport_ancillary_code = 
			@Acq_Deal_Sport_Ancillary_Code 
			END 

			FETCH next FROM cur_sport_ancillary INTO 
			@Acq_Deal_Sport_Ancillary_Code 
			END 

			CLOSE cur_sport_ancillary 
			DEALLOCATE cur_sport_ancillary 
			--=================================CUR_SPORT_ANCILLARY END========================================
			--=================================CUR_SPORT_MINETISATION_ANCILLARY START========================================
			DECLARE @Acq_Deal_Sport_Monetisation_Ancillary_Code     INT = 0, @New_Acq_Deal_Sport_Monetisation_Ancillary_Code INT = 0 
			DECLARE cur_sport_minetisation_ancillary CURSOR FOR 
			SELECT acq_deal_sport_monetisation_ancillary_code FROM   acq_deal_sport_monetisation_ancillary WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN cur_sport_minetisation_ancillary 
			FETCH next FROM cur_sport_minetisation_ancillary INTO @Acq_Deal_Sport_Monetisation_Ancillary_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_sport_monetisation_ancillary_title ADSMA 
			INNER JOIN #temptitle tt 
			ON ADSMA.title_code = tt.title_code 
			WHERE  acq_deal_sport_monetisation_ancillary_code = 
			@Acq_Deal_Sport_Monetisation_Ancillary_Code) > 0 ) 
			BEGIN 
			/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary *****************************************/
			INSERT INTO acq_deal_sport_monetisation_ancillary 
			(acq_deal_code, 
			appoint_title_sponsor, 
			appoint_broadcast_sponsor, 
			remarks) 
			SELECT @New_Acq_Deal_Code, 
			appoint_title_sponsor, 
			appoint_broadcast_sponsor, 
			remarks 
			FROM   acq_deal_sport_monetisation_ancillary 
			WHERE  acq_deal_sport_monetisation_ancillary_code = 
			@Acq_Deal_Sport_Monetisation_Ancillary_Code 

			SELECT @New_Acq_Deal_Sport_Monetisation_Ancillary_Code = 
			Ident_current( 
			'Acq_Deal_Sport_Monetisation_Ancillary') 

			/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary_Title *****************************************/
			INSERT INTO acq_deal_sport_monetisation_ancillary_title 
			(acq_deal_sport_monetisation_ancillary_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Sport_Monetisation_Ancillary_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_sport_monetisation_ancillary_title ADSMA 
			INNER JOIN #temptitle tt 
			ON ADSMA.title_code = tt.title_code 
			--AND ADSMA.Episode_From = tt.Old_Episode_From AND ADSMA.Episode_To = tt.Old_Episode_To 
			WHERE  acq_deal_sport_monetisation_ancillary_code = 
			@Acq_Deal_Sport_Monetisation_Ancillary_Code 

			/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary_Type *****************************************/
			INSERT INTO acq_deal_sport_monetisation_ancillary_type 
			(acq_deal_sport_monetisation_ancillary_code, 
			monetisation_type_code, 
			monetisation_rights) 
			SELECT @New_Acq_Deal_Sport_Monetisation_Ancillary_Code, 
			monetisation_type_code, 
			monetisation_rights 
			FROM   acq_deal_sport_monetisation_ancillary_type 
			WHERE  acq_deal_sport_monetisation_ancillary_code = 
			@Acq_Deal_Sport_Monetisation_Ancillary_Code 
			END 

			FETCH next FROM cur_sport_minetisation_ancillary INTO 
			@Acq_Deal_Sport_Monetisation_Ancillary_Code 
			END 

			CLOSE cur_sport_minetisation_ancillary 
			DEALLOCATE cur_sport_minetisation_ancillary 
			--=================================CUR_SPORT_MINETISATION_ANCILLARY END========================================
			--=================================CUR_SPORT_SALE_ANCILLARY START========================================
			DECLARE @Acq_Deal_Sport_Sales_Ancillary_Code     INT = 0, @New_Acq_Deal_Sport_Sales_Ancillary_Code INT = 0 
			DECLARE cur_sport_sale_ancillary CURSOR FOR 
			SELECT acq_deal_sport_sales_ancillary_code FROM   acq_deal_sport_sales_ancillary WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			OPEN cur_sport_sale_ancillary 
			FETCH next FROM cur_sport_sale_ancillary INTO @Acq_Deal_Sport_Sales_Ancillary_Code 

			WHILE @@FETCH_STATUS = 0 
			BEGIN 
			IF( (SELECT Count(*) 
			FROM   acq_deal_sport_sales_ancillary_title ADSSAT 
			INNER JOIN #temptitle tt 
			ON ADSSAT.title_code = tt.title_code 
			WHERE  ADSSAT.acq_deal_sport_sales_ancillary_code = 
			@Acq_Deal_Sport_Sales_Ancillary_Code) > 0 ) 
			BEGIN 
			/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary *****************************************/
			INSERT INTO acq_deal_sport_sales_ancillary 
			(acq_deal_code, 
			fro_given_title_sponsor, 
			fro_given_official_sponsor, 
			title_fro_no_of_days, 
			title_fro_validity, 
			price_protection_title_sponsor, 
			price_protection_official_sponsor, 
			last_matching_rights_title_sponsor, 
			last_matching_rights_official_sponsor, 
			title_last_matching_rights_validity, 
			remarks, 
			official_fro_no_of_days, 
			official_fro_validity, 
			official_last_matching_rights_validity) 
			SELECT @New_Acq_Deal_Code, 
			fro_given_title_sponsor, 
			fro_given_official_sponsor, 
			title_fro_no_of_days, 
			title_fro_validity, 
			price_protection_title_sponsor, 
			price_protection_official_sponsor, 
			last_matching_rights_title_sponsor, 
			last_matching_rights_official_sponsor, 
			title_last_matching_rights_validity, 
			remarks, 
			official_fro_no_of_days, 
			official_fro_validity, 
			official_last_matching_rights_validity 
			FROM   acq_deal_sport_sales_ancillary 
			WHERE  acq_deal_sport_sales_ancillary_code = 
			@Acq_Deal_Sport_Sales_Ancillary_Code 

			SELECT @New_Acq_Deal_Sport_Sales_Ancillary_Code = 
			Ident_current('Acq_Deal_Sport_Sales_Ancillary' 
			) 

			/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary_Title *****************************************/
			INSERT INTO acq_deal_sport_sales_ancillary_title 
			(acq_deal_sport_sales_ancillary_code, 
			title_code, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Sport_Sales_Ancillary_Code, 
			tt.newtitle_code, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_sport_sales_ancillary_title ADSSAT 
			INNER JOIN #temptitle tt 
			ON ADSSAT.title_code = tt.title_code 
			--AND ADSSAT.Episode_From = tt.Old_Episode_From AND ADSSAT.Episode_To = tt.Old_Episode_To 
			WHERE  ADSSAT.acq_deal_sport_sales_ancillary_code = 
			@Acq_Deal_Sport_Sales_Ancillary_Code 

			/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor *****************************************/
			INSERT INTO acq_deal_sport_sales_ancillary_sponsor 
			(acq_deal_sport_sales_ancillary_code, 
			sponsor_code, 
			sponsor_type) 
			SELECT @New_Acq_Deal_Sport_Sales_Ancillary_Code, 
			ADSSAS.sponsor_code, 
			ADSSAS.sponsor_type 
			FROM   acq_deal_sport_sales_ancillary_sponsor ADSSAS 
			WHERE  ADSSAS.acq_deal_sport_sales_ancillary_code = 
			@Acq_Deal_Sport_Sales_Ancillary_Code 
			END 

			FETCH next FROM cur_sport_sale_ancillary INTO 
			@Acq_Deal_Sport_Sales_Ancillary_Code 
			END 

			CLOSE cur_sport_sale_ancillary 
			DEALLOCATE cur_sport_sale_ancillary 
			--=================================CUR_SPORT_SALE_ANCILLARY END========================================

			/******************************** Insert into Acq_Deal_Payment_Terms *****************************************/
			INSERT INTO acq_deal_payment_terms 
			(acq_deal_code, 
			cost_type_code, 
			payment_term_code, 
			days_after, 
			percentage, 
			amount, 
			due_date, 
			inserted_on, 
			inserted_by) 
			SELECT @New_Acq_Deal_Code, 
			cost_type_code, 
			payment_term_code, 
			days_after, 
			percentage, 
			amount, 
			due_date, 
			Getdate(), 
			@User_Code 
			FROM   acq_deal_payment_terms 
			WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			--/******************************** Insert into Acq_Deal_Attachment *****************************************/ 
			--INSERT INTO Acq_Deal_Attachment  
			--  (Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To)
			--SELECT @New_Acq_Deal_Code, tt.NewTitle_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, tt.Episode_Starts_From, tt.Episode_End_To
			--  FROM Acq_Deal_Attachment ADA  
			--  INNER JOIN #tempTitle tt ON ADA.Title_Code = tt.Title_Code 
			--  AND ADA.Episode_From = tt.Old_Episode_From AND ADA.Episode_To = tt.Old_Episode_To 
			--   WHERE Acq_Deal_Code =  @Previous_Acq_Deal_Code 
			--INSERT INTO Acq_Deal_Attachment  
			--  (Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To)
			--SELECT @New_Acq_Deal_Code, NULL, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, NULL, NULL
			--  FROM Acq_Deal_Attachment ADA  
			--  WHERE Acq_Deal_Code =  @Previous_Acq_Deal_Code AND ADA.Title_Code IS NULL AND ADA.Episode_From IS NULL AND ADA.Episode_To IS NULL

			/******************************** Insert into AT_Acq_Deal_Material *****************************************/
			INSERT INTO acq_deal_material 
			(acq_deal_code, 
			title_code, 
			material_medium_code, 
			material_type_code, 
			quantity, 
			inserted_on, 
			inserted_by, 
			lock_time, 
			episode_from, 
			episode_to) 
			SELECT @New_Acq_Deal_Code, 
			tt.newtitle_code, 
			material_medium_code, 
			material_type_code, 
			quantity, 
			Getdate(), 
			@User_Code, 
			lock_time, 
			tt.episode_starts_from, 
			tt.episode_end_to 
			FROM   acq_deal_material ADM 
			INNER JOIN #temptitle tt 
			ON ADM.title_code = tt.title_code 
			AND ADM.episode_from = tt.old_episode_from 
			AND ADM.episode_to = tt.old_episode_to 
			WHERE  acq_deal_code = @Previous_Acq_Deal_Code 

			/******************************** Insert into Acq_Deal_Budget *****************************************/
			--INSERT INTO Acq_Deal_Budget ( 
			--  Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code) 
			--SELECT @New_Acq_Deal_Code, tt.NewTitle_Code,tt.Episode_Starts_From, tt.Episode_End_To, ADB.SAP_WBS_Code
			--  FROM Acq_Deal_Budget ADB INNER JOIN #tempTitle tt ON ADB.Title_Code = tt.Title_Code 
			--  AND ADB.Episode_From = tt.Old_Episode_From AND ADB.Episode_To = tt.Old_Episode_To 
			--  WHERE Acq_Deal_Code = @Previous_Acq_Deal_Code 
		COMMIT 
	--drop table #tempTitle 
	SELECT 'Success' AS Result 
	END TRY 
	BEGIN CATCH 
	ROLLBACK 
		SELECT Error_message() 
	SELECT 'ERROR' AS Result 
	END CATCH 
END