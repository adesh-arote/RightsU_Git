CREATE PROCEDURE  [dbo].[USP_Syn_Deal_Right_Clone] 
(
	 @New_Syn_Deal_Code INT,  
	 @Syn_Deal_Rights_Code INT,  
	 @Syn_Deal_Rights_Title_Code INT,  
	 @Title_Code INT,  
	 @Is_Program CHAR(1) = 'N'  
)
AS
-- =============================================
-- Author:	AKkshay Rane
-- Create DATE: 22-Jul-2019
-- Description:	Syndication deal Clone
-- =============================================
BEGIN	
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Deal_Right_Clone]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON;
		DECLARE @New_Syn_Deal_Rights_Code INT = 0
		PRINT '--=================================RIGHTS_CURSOR START========================================'
				--=================================RIGHTS_CURSOR START========================================

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
									  ,Promoter_Flag
									  ,CoExclusive_Remarks)   							   
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
								 ,CoExclusive_Remarks
						  FROM   Syn_Deal_Rights  (NOLOCK)
						  WHERE  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

						  SELECT @New_Syn_Deal_Rights_Code = 
								 IDENT_CURRENT('Syn_Deal_Rights') 

						  PRINT'/**************** Insert into AT_Syn_Deal_Rights_Title ****************/'
						IF(@Is_Program  <> 'Y')
						BEGIN
							  INSERT INTO Syn_Deal_Rights_Title (Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To) 
							  SELECT @New_Syn_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To 
							  FROM   Syn_Deal_Rights_Title ADRT (NOLOCK) 
									 --INNER JOIN #temptitle DRT ON ADRT.Title_Code = DRT.Title_Code AND ADRT.episode_from = DRT.Old_Episode_From  AND ADRT.Episode_To = DRT.Old_Episode_To 
							  WHERE  ADRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  AND Title_Code = @Title_Code

							  DELETE FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and Title_Code = @Title_Code
						END
						ELSE IF (@Is_Program  = 'Y')
						BEGIN
							  INSERT INTO Syn_Deal_Rights_Title (Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To) 
							  SELECT @New_Syn_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To 
							  FROM   Syn_Deal_Rights_Title ADRT  (NOLOCK)
									 --INNER JOIN #temptitle DRT ON ADRT.Title_Code = DRT.Title_Code AND ADRT.episode_from = DRT.Old_Episode_From  AND ADRT.Episode_To = DRT.Old_Episode_To 
							  WHERE ADRT.Syn_Deal_Rights_Title_Code = @Syn_Deal_Rights_Title_Code and Title_Code = @Title_Code

							  DELETE FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Title_Code = @Syn_Deal_Rights_Title_Code and Title_Code = @Title_Code
						END

						 PRINT'/**************** Insert into AT_Syn_Deal_Rights_Title_EPS ****************/'
                    
							IF(@Is_Program  <> 'Y')
							BEGIN
								INSERT INTO Syn_Deal_Rights_Title_EPS (Syn_Deal_Rights_Title_Code, EPS_No) 
								SELECT AtADRT.Syn_Deal_Rights_Title_Code, ADRTE.EPS_No 
								FROM   Syn_Deal_Rights_Title_EPS ADRTE  (NOLOCK)
									 INNER JOIN Syn_Deal_Rights_Title ADRT (NOLOCK) ON ADRTE.Syn_Deal_Rights_Title_Code =  ADRT.Syn_Deal_Rights_Title_Code 
									 --INNER JOIN #temptitle DRT ON ADRT.Title_Code = DRT.Title_Code  AND ADRT.Episode_From =  DRT.Old_Episode_From  AND ADRT.Episode_To = DRT.Old_Episode_To 
									 INNER JOIN Syn_Deal_Rights_Title AtADRT 
											  (NOLOCK) ON Cast(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) 
												+ '~' + Cast(ISNULL(AtADRT.Episode_From, '') AS  VARCHAR) + '~' + Cast(ISNULL(AtADRT.Episode_To, '') AS VARCHAR) = 
												Cast(ISNULL(ADRT.Title_Code, '' ) AS VARCHAR) + '~' + Cast(ISNULL(ADRT.Episode_From, '' ) AS VARCHAR ) + '~' + Cast(ISNULL(ADRT.Episode_To, '') AS VARCHAR ) 
								WHERE  ADRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtADRT.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code 
							END
							ELSE IF (@Is_Program  = 'Y')
							BEGIN
								INSERT INTO Syn_Deal_Rights_Title_EPS (Syn_Deal_Rights_Title_Code, EPS_No) 
								SELECT AtADRT.Syn_Deal_Rights_Title_Code, ADRTE.EPS_No 
								FROM   Syn_Deal_Rights_Title_EPS ADRTE  (NOLOCK)
									 INNER JOIN Syn_Deal_Rights_Title ADRT (NOLOCK) ON ADRTE.Syn_Deal_Rights_Title_Code =  ADRT.Syn_Deal_Rights_Title_Code 
									 --INNER JOIN #temptitle DRT ON ADRT.Title_Code = DRT.Title_Code  AND ADRT.Episode_From =  DRT.Old_Episode_From  AND ADRT.Episode_To = DRT.Old_Episode_To 
									 INNER JOIN Syn_Deal_Rights_Title AtADRT 
											 (NOLOCK) ON Cast(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) 
												+ '~' + Cast(ISNULL(AtADRT.Episode_From, '') AS  VARCHAR) + '~' + Cast(ISNULL(AtADRT.Episode_To, '') AS VARCHAR) = 
												Cast(ISNULL(ADRT.Title_Code, '' ) AS VARCHAR) + '~' + Cast(ISNULL(ADRT.Episode_From, '' ) AS VARCHAR ) + '~' + Cast(ISNULL(ADRT.Episode_To, '') AS VARCHAR ) 
								WHERE ADRT.Syn_Deal_Rights_Title_Code = @Syn_Deal_Rights_Title_Code AND AtADRT.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code
							END
						  PRINT'/**************** Insert into AT_Syn_Deal_Rights_Platform ****************/'
						  INSERT INTO Syn_Deal_Rights_Platform 
									  (Syn_Deal_Rights_Code, 
									   Platform_Code) 
						  SELECT @New_Syn_Deal_Rights_Code,
								 ADRP.Platform_Code 
						  FROM   Syn_Deal_Rights_Platform ADRP  (NOLOCK)
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
						  FROM   Syn_Deal_Rights_Territory ADRT  (NOLOCK)
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
						  FROM   Syn_Deal_Rights_Subtitling ADRS  (NOLOCK)
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
						  FROM   Syn_Deal_Rights_Dubbing ADRD  (NOLOCK)
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
								 ADRB.Inserted_By,
								 ADRB.Inserted_On
								 --@User_Code, 
								 --Getdate() 
						  FROM   Syn_Deal_Rights_Blackout ADRB  (NOLOCK)
						  WHERE  ADRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

						  PRINT'/******** Insert into AT_Syn_Deal_Rights_Blackout_Dubbing ********/'
						  INSERT INTO Syn_Deal_Rights_Blackout_Dubbing 
									  (Syn_Deal_Rights_Blackout_Code, 
									   Language_Code) 
						  SELECT AtADRB.Syn_Deal_Rights_Blackout_Code, 
								 ADRBD.Language_Code 
						  FROM   Syn_Deal_Rights_Blackout_Dubbing ADRBD  (NOLOCK)
								 INNER JOIN Syn_Deal_Rights_Blackout ADRB 
										  (NOLOCK) ON ADRBD.Syn_Deal_Rights_Blackout_Code = 
											ADRB.Syn_Deal_Rights_Blackout_Code 
								 INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
										 (NOLOCK) ON Cast(Isnull(AtADRB.start_date, '') AS 
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
						  FROM   Syn_Deal_Rights_Blackout_Platform ADRBP  (NOLOCK)
								 INNER JOIN Syn_Deal_Rights_Blackout ADRB 
										 (NOLOCK) ON ADRBP.Syn_Deal_Rights_Blackout_Code = 
											ADRB.Syn_Deal_Rights_Blackout_Code 
								 INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
										 (NOLOCK) ON Cast(Isnull(AtADRB.Start_Date, '') AS 
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
						  FROM   Syn_Deal_Rights_Blackout_Subtitling ADRBS  (NOLOCK)
								 INNER JOIN Syn_Deal_Rights_Blackout ADRB 
										 (NOLOCK) ON ADRBS.Syn_Deal_Rights_Blackout_Code = 
											ADRB.Syn_Deal_Rights_Blackout_Code 
								 INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
										 (NOLOCK) ON Cast(Isnull(AtADRB.Start_Date, '') AS 
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
						  FROM   Syn_Deal_Rights_Blackout_Territory ADRBT  (NOLOCK)
								 INNER JOIN Syn_Deal_Rights_Blackout ADRB 
										 (NOLOCK) ON ADRBT.Syn_Deal_Rights_Blackout_Code = 
											ADRB.Syn_Deal_Rights_Blackout_Code 
								 INNER JOIN Syn_Deal_Rights_Blackout AtADRB 
										 (NOLOCK) ON Cast(Isnull(AtADRB.Start_Date, '') AS 
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
						  SELECT @New_Syn_Deal_Rights_Code, ADRP.Inserted_By, ADRP.Inserted_On,ADRP.Last_Updated_Time, ADRP.Last_Action_By
						  --@User_Code, GETDATE(), GETDATE(), @User_Code
						  FROM Syn_Deal_Rights_Promoter ADRP (NOLOCK) WHERE ADRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					
						--Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * FROM Acq_Deal_Rights_Promoter

						PRINT'/******** Insert into Syn_Deal_Rights_Promoter_Group ********/'
						  INSERT INTO Syn_Deal_Rights_Promoter_Group( Syn_Deal_Rights_Promoter_Code, Promoter_Group_Code)
						  SELECT ADRPNew.Syn_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code
						  FROM (
							Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter (NOLOCK)
							Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						  ) ADRP
						  INNER JOIN Syn_Deal_Rights_Promoter_Group ADRPG (NOLOCK) ON ADRPG.Syn_Deal_Rights_Promoter_Code = ADRP.Syn_Deal_Rights_Promoter_Code
						  INNER JOIN (
							Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter (NOLOCK)
							Where Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code
						  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

						  --Inner Join Acq_Deal_Rights_Promoter ADRPOLD On Row_Number() over(order by ADRP.Acq_Deal_Rights_Promoter_Code Asc)
					
						PRINT'/******** Insert into AT_Acq_Deal_Rights_Promoter_Remarks ********/' 
						  INSERT INTO Syn_Deal_Rights_Promoter_Remarks(Syn_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
						  SELECT ADRPNew.Syn_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code 
						  FROM (
							Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter (NOLOCK)
							Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						  ) ADRP
						  INNER JOIN Syn_Deal_Rights_Promoter_Remarks ADRPR (NOLOCK) ON ADRPR.Syn_Deal_Rights_Promoter_Code = ADRP.Syn_Deal_Rights_Promoter_Code
						  INNER JOIN (
							Select Row_Number() over(order by Syn_Deal_Rights_Promoter_Code Asc) RowId, * From Syn_Deal_Rights_Promoter (NOLOCK)
							Where Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code
						  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId
 
				END 
				SELECT CAST(@New_Syn_Deal_Rights_Code AS NVARCHAR(MAX))  AS Syn_Deal_Rights_Code
				PRINT'--=================================RIGHTS_CURSOR END========================================'

				IF OBJECT_ID('tempdb..#temptitle') IS NOT NULL DROP TABLE #temptitle
			 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Deal_Right_Clone]', 'Step 2', 0, ' Procedure Excuting Copmpleted', 0, '' 
END