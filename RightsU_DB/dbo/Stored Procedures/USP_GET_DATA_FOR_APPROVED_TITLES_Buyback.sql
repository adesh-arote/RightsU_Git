CREATE Procedure [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES_Buyback]
	@Title_Codes Varchar(1000),
	@Platform_Codes Varchar(MAX),
	@Platform_Type Varchar(10),   ----- PL / TPL / ''
	@Region_Type Varchar(10),	----- T / C / THC / THT
	@Subtitling_Type Varchar(10),	------ SL / SG / ''
	@Dubbing_Type Varchar(10),	------ DL / DG / ''
	@Syn_Deal_Code Int
As
BEGIN
-- =============================================
-- Author:		Rahul Kembhavi
-- Create date:	18 Aug 2022
-- Description:	Get Distinct DATA of Titles that are approved 
-- =============================================
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USP_GET_DATA_FOR_APPROVED_TITLES_Buyback]', 'Step 1', 0, 'Started Procedure', 0, ''
			Declare @SubTitle_Lang_Code Varchar(MAX),@Dubb_Lang_Code Varchar(MAX),@Parent_Country_Code Int,@Is_Domestic_Territory CHAR(1)
			Set @SubTitle_Lang_Code =''
			Set @Dubb_Lang_Code =''
			Set @Parent_Country_Code=0
			Set @Is_Domestic_Territory= 'N'  -- Y If (Theatrical + India) Else 'N'
			Set NOCOUNT ON;
			Set FMTONLY OFF;
	-- =============================================Delete Temp Tables =============================================

	--DECLARE
	--@Title_Codes Varchar(1000) = '42787',
	--	@Platform_Codes Varchar(MAX) = '252,253,254,255',
	--	@Platform_Type Varchar(10) = '',   ----- PL / TPL / ''
	--	@Region_Type Varchar(10) = 'T',	----- T / C / THC / THT
	--	@Subtitling_Type Varchar(10) = 'SL',	------ SL / SG / ''
	--	@Dubbing_Type Varchar(10) = 'DL',	------ DL / DG / ''
	--	@Syn_Deal_Code Int = 5806

		If OBJECT_ID('tempdb..#Deal_Rights_Lang') IS NOT NULL
		Begin
			Drop Table #Deal_Rights_Lang   
		End
	-- =============================================CREATE Temp Tables =============================================
			Declare @Deal_Rights_Title  Table 
			(
				Title_Code Int,
				Episode_FROM Int,
				Episode_To Int
			)
	-- ============================================= -- ============================================= 
		Declare @Selected_Deal_Type_Code Int ,@Deal_Type_Condition Varchar(MAX) = '', @Is_Acq_CoExclusive CHAR(1) = 'N', @Tentative VARCHAR(100) = 'N'
		Declare @TitCnt Int = 0
		Select Top 1 @Selected_Deal_Type_Code = Deal_Type_Code From Syn_Deal (NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code
		Select @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)
		Select @Is_Acq_CoExclusive = Parameter_Value From System_Parameter_New Where Parameter_Name = 'Is_Acq_CoExclusive'

		IF(@Is_Acq_CoExclusive = 'Y')
			SELECT @Tentative = 'N,Y'

		If(@Deal_Type_Condition = 'DEAL_PROGRAM')
		Begin
			INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
			Select Title_Code, Episode_FROM, Episode_End_To From Syn_Deal_Movie (NOLOCK)
			Where Syn_Deal_Movie_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Syn_Deal_Code = @Syn_Deal_Code
		End
		Else
		Begin
			INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
			Select Title_Code, Episode_FROM, Episode_End_To From Syn_Deal_Movie  (NOLOCK)
			Where Title_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Syn_Deal_Code = @Syn_Deal_Code
		End
		
		Declare @Required_Codes Varchar(max) = '' ,@Total_Title_Count  Int = 0
		Select @Total_Title_Count += (Episode_To - Episode_FROM) + 1 From @Deal_Rights_Title
		--Here PL Means 'Platform' 
		-- Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
		If(@Platform_Type = 'PL' Or @Platform_Type = 'TPL')
		Begin
			
			Select @TitCnt = Count(Distinct Title_Code) From @Deal_Rights_Title

			Select Distinct adrt.Syn_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To 
			InTo #AcquiredTitles 
			From Syn_Deal_Rights_Title adrt (NOLOCK)
			Inner Join Syn_Deal_Rights adr (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code 
				--And ADR.Is_Theatrical_Right = Case When @Region_Type = 'TPL' Then 'Y' Else 'N' End
			Inner Join Syn_Deal ad (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code
				And IsNull(AD.Deal_Workflow_Status,'')='A' And ADR.Is_Sub_License='Y'
				--And IsNull(ADR.Is_Tentative, 'N')='N'
				And IsNull(ADR.Is_Tentative, 'N') IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Tentative,','))
				And ADR.Actual_Right_Start_Date IS NOT NULL
			Inner Join @Deal_Rights_Title drt ON drt.Title_Code = adrt.Title_Code And 
			(
				drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
				drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
				adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
				adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
			)
			where
			 ad.Deal_Workflow_Status NOT IN ('AR', 'WA')
			
			Select @Total_Title_Count = Count(Distinct Title_Code) From #AcquiredTitles

			If(@TitCnt = @Total_Title_Count)
			Begin
				Select 
					@Total_Title_Count = Count(*) 
				From
				(
					Select Title_Code, Episode_FROM, Episode_To From #AcquiredTitles Group By Title_Code, Episode_FROM, Episode_To
				) As a

				--Select @Total_Title_Count
				Select @Required_Codes = ''
				If(@Platform_Type = 'PL')
				Begin
					Select 
						@Required_Codes = @Required_Codes + Platform_Code + ','
					From 
					(
						Select Distinct Cast(adr.Title_Code As Varchar) + '-' + Cast(adr.Episode_FROM As Varchar) + '-' + Cast(adr.Episode_To As Varchar) As Title_Code_With_Episode,
						IsNull(Cast(adrp.Platform_Code As Varchar), '') As Platform_Code 
						From #AcquiredTitles adr 
						Inner Join Acq_Deal_Rights_Platform adrp (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code					
					)  As TEMP
					Group By TEMP.Platform_Code
					Having Count( Distinct TEMP.Title_Code_With_Episode) = @Total_Title_Count
				End
				Else If(@Platform_Type = 'TPL')
				Begin
					Select 
						@Required_Codes = @Required_Codes + Platform_Code + ','
					From 
					(
						Select Distinct 
						Cast(adr.Title_Code As Varchar) + '-' + Cast(adr.Episode_FROM As Varchar) + '-' + Cast(adr.Episode_To As Varchar) As Title_Code_With_Episode,
						IsNull(Cast(adrp.Platform_Code As Varchar), '') As Platform_Code 
						From #AcquiredTitles adr 
						Inner Join Acq_Deal_Rights_Platform adrp (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
						Inner Join Platform P (NOLOCK) ON adrp.Platform_Code = P.Platform_Code And Applicable_For_Demestic_Territory = 'Y'
					)  As TEMP
					Group By TEMP.Platform_Code
					Having Count( Distinct TEMP.Title_Code_With_Episode) = @Total_Title_Count
				End
				Set @Required_Codes = Substring(@Required_Codes, 0, Len(@Required_Codes))
			End
			Else
			Begin
				Set @Required_Codes = ''
			End			
			Drop Table #AcquiredTitles			
		End
		Else
		Begin
			Declare @PlatformCnt Int = 0--, @CountryCnt Int = 0			
			Select @TitCnt = Count(Distinct Title_Code) From @Deal_Rights_Title

			Select Distinct adrt.Syn_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To,adr.Is_Theatrical_Right 
			InTo #AcquiredTitlesNew
			From Syn_Deal_Rights_Title adrt (NOLOCK)
			Inner Join Syn_Deal_Rights adr (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
			Inner Join Syn_Deal ad  (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code
						And IsNull(AD.Deal_Workflow_Status,'')='A' 
						--And ADR.Is_Sub_License='Y'
					--	And IsNull(ADR.Is_Tentative, 'N')='N' 
						And IsNull(ADR.Is_Tentative, 'N') IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Tentative,','))
						And ADR.Actual_Right_Start_Date IS NOT NULL
						And ((@Region_Type Not In ('THC', 'THT') And ADR.Is_Theatrical_Right = 'N') Or @Region_Type In ('THC', 'THT'))
			Inner Join @Deal_Rights_Title drt  ON drt.Title_Code = adrt.Title_Code And 
			(
				drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
				drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
				adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
				adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
			)
			where 
			 AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 

			Select @Total_Title_Count = Count(Distinct Title_Code) From #AcquiredTitlesNew

			If(@TitCnt = @Total_Title_Count)
			Begin

				Select @PlatformCnt = Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat Where IsNull(number, '') Not In ('', '0')

				--Select Acq_Deal_Rights_Code, Platform_Code, 0 As Rights_Cnt InTo #Rights_Platform From dbo.Acq_Deal_Rights_Platform Where 
				--	Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code From #AcquiredTitlesNew)
				--	And Platform_Code In(Select Number From dbo.fn_Split_withdelemiter(@Platform_Codes,','))
				--Group By Acq_Deal_Rights_Code, Platform_Code

				Select DISTINCT adrp.Syn_Deal_Rights_Code, Platform_Code, atn.Title_Code, atn.Episode_From, atn.Episode_To, 0 As Rights_Cnt 
				InTo #Rights_Platform
				From dbo.Syn_Deal_Rights_Platform adrp (NOLOCK)
				Inner Join #AcquiredTitlesNew atn On atn.Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code
				And adrp.Platform_Code In(Select Number From dbo.fn_Split_withdelemiter(@Platform_Codes,','))
			
				Declare @Total_Platform_Cnt Int = 0, @Thetrical_Platform_Code Int = 0, @Is_Theatrical Char(1) = 'N'--, @Thetrical_Platform_Code Int = 0
				Select @Total_Platform_Cnt = Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat
			
				--Update u1 Set u1.Rights_Cnt = u2.cnt From #Rights_Platform u1 
				--Inner Join(
				--	Select Count(*) cnt, Acq_Deal_Rights_Code From #Rights_Platform Group By Acq_Deal_Rights_Code
				--) u2 On u1.Acq_Deal_Rights_Code = u2.Acq_Deal_Rights_Code

				Update u1 Set u1.Rights_Cnt = u2.cnt From #Rights_Platform u1 
				Inner Join(
					Select Count(*) cnt, Title_Code, Episode_From, Episode_To From (
						Select Platform_Code, Title_Code, Episode_From, Episode_To From #Rights_Platform Group By Title_Code, Episode_From, Episode_To
						,Platform_Code
						--, Acq_Deal_Rights_Code
					) As a Group By Title_Code, Episode_From, Episode_To
				) u2 On u1.Title_Code = u2.Title_Code And u1.Episode_From = u2.Episode_From And u1.Episode_To = u2.Episode_To
			
				Delete From #Rights_Platform Where Rights_Cnt <> @Total_Platform_Cnt

				If Exists(Select Top 1 * From #Rights_Platform)
				Begin

					Select @Thetrical_Platform_Code = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
					If((Select Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat Where IsNull(number, '0') = Cast(@Thetrical_Platform_Code As Varchar)) > 0)
					Begin
						Set @Is_Theatrical = 'Y'
					End

					Select Syn_Deal_Rights_Code, Case When arter.Territory_Type = 'G' Then td.Country_Code Else arter.Country_Code End Country_Code
					InTo #Rights_Country
					From (
						Select * From Syn_Deal_Rights_Territory (NOLOCK) Where Syn_Deal_Rights_Code In (
							Select rc.Syn_Deal_Rights_Code From #Rights_Platform rc
						)
					) arter
					Left Join Territory_Details td (NOLOCK) On arter.Territory_Code = td.Territory_Code
				
					If(@Region_Type = 'THC' Or @Region_Type = 'THT')
					Begin
						Delete From #Rights_Country Where Country_Code Not In (
							Select Country_Code From Country (NOLOCK) Where Is_Theatrical_Territory = 'Y' Or Is_Domestic_Territory = 'Y'
						)
					
						Insert InTo #Rights_Country
						Select rc.Syn_Deal_Rights_Code, c.Country_Code From #Rights_Country rc 
						Inner Join Country c (NOLOCK) On rc.Country_Code = c.Parent_Country_Code And c.Is_Theatrical_Territory = 'Y' And c.Is_Active = 'Y' 
					
						Delete From #Rights_Country Where Country_Code In (
							Select Country_Code  From Country (NOLOCK) Where Is_Domestic_Territory = 'Y' --Or Is_Domestic_Territory = 'N'
						)
					End
				
					If(@Is_Theatrical = 'Y')	-- And @Total_Platform_Cnt > 1
					Begin
						Delete From #Rights_Country Where Country_Code In (
							Select Country_Code  From Country (NOLOCK) Where Is_Domestic_Territory = 'Y'
						)
					End

					Declare @Platform_Cnt Int = 0, @Country_Cnt Int = 0, @Title_Cnt Int = 0

					Select @Title_Cnt = Count(*) From (
						Select Distinct Title_Code, Episode_From, Episode_To From #AcquiredTitlesNew
					) As a

					Select @Platform_Cnt = Count(Distinct Platform_Code) From #Rights_Platform
				
					--Select * From #Rights_Country

					-------------------- Check for common countries in title

					Select Distinct rcon.Syn_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rcon.Country_Code, 0 As Country_Cnt InTo #Rights_Title_Country 
					From #Rights_Country rcon
					Inner Join #AcquiredTitlesNew rtit On rcon.Syn_Deal_Rights_Code = rtit.Syn_Deal_Rights_Code

					Drop Table #Rights_Country

					Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Title_Country u1 
					Inner Join(
						Select Count(*) cnt, a.Country_Code From (
							Select Distinct utc.Country_Code, utc.Title_Code, utc.Episode_From, utc.Episode_To From #Rights_Title_Country utc
						) As a Group By a.Country_Code
					) u2 On u1.Country_Code = u2.Country_Code
								
					Delete From #Rights_Title_Country Where Country_Cnt <> @Title_Cnt
				
					--Select * From #Rights_Title_Country

					-------------------- End

					Select Distinct Syn_Deal_Rights_Code, Country_Code InTo #Rights_Country_New From #Rights_Title_Country
					Drop Table #Rights_Title_Country

					-------------------- Check for common countries in Platform

					Select Distinct rcon.Syn_Deal_Rights_Code, rp.Platform_Code, rcon.Country_Code, 0 As Country_Cnt InTo #Rights_Platform_Country 
					From #Rights_Country_New rcon
					Inner Join #Rights_Platform rp On rcon.Syn_Deal_Rights_Code = rp.Syn_Deal_Rights_Code
				
					Drop Table #Rights_Country_New

					Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Platform_Country u1 
					Inner Join(
						Select Count(*) cnt, a.Country_Code From (
							Select Distinct rpc.Country_Code, rpc.Platform_Code From #Rights_Platform_Country rpc
						) As a Group By a.Country_Code
					) u2 On u1.Country_Code = u2.Country_Code
				
					--Select @Platform_Cnt, * From #Rights_Platform_Country
					Delete From #Rights_Platform_Country Where Country_Cnt <> @Platform_Cnt
				

					-------------------- End

					Select Distinct Syn_Deal_Rights_Code, Country_Code InTo #Rights_Country_Final From #Rights_Platform_Country
					Drop Table #Rights_Platform_Country

					If Exists(Select Top 1 * From #Rights_Country_Final)
					Begin
				
						Select @Country_Cnt = Count(Distinct Country_Code) From #Rights_Country_Final

						--------------------- Subtitling
						Set @SubTitle_Lang_Code = '0'
						If(@Subtitling_Type In ('SL', 'SG'))
						Begin

							Select Syn_Deal_Rights_Code, Case When ars.Language_Type = 'G' Then lgd.Language_Code Else ars.Language_Code End Language_Code
							InTo #Rights_Subtitling
							From (
								Select * From Syn_Deal_Rights_Subtitling (NOLOCK) Where Syn_Deal_Rights_Code In (
									Select rp.Syn_Deal_Rights_Code From #Rights_Platform rp
								)
							) ars
							Left Join Language_Group_Details lgd (NOLOCK) On ars.Language_Group_Code = lgd.Language_Group_Code
						
							--Select * From #Rights_Subtitling

							---------------------- Check subtitling for Title

							Select Distinct rsub.Syn_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rsub.Language_Code, 0 As Title_Cnt 
							InTo #Rights_Title_Subtitling
							From #Rights_Subtitling rsub
							Inner Join #AcquiredTitlesNew rtit  On rsub.Syn_Deal_Rights_Code = rtit.Syn_Deal_Rights_Code

							Drop Table #Rights_Subtitling

							Update u1 Set u1.Title_Cnt = u2.cnt From #Rights_Title_Subtitling u1 
							Inner Join(
								Select Count(*) cnt, a.Language_Code From (
									Select Distinct utc.Language_Code, utc.Title_Code, utc.Episode_From, utc.Episode_To From #Rights_Title_Subtitling utc
								) As a Group By a.Language_Code
							) u2 On u1.Language_Code = u2.Language_Code
								
							Delete From #Rights_Title_Subtitling Where Title_Cnt <> @Title_Cnt
						
							--Select * From #Rights_Title_Subtitling

							---------------------- End
						
							Select Distinct Syn_Deal_Rights_Code, Language_Code InTo #Rights_Title_Subtitling_New From #Rights_Title_Subtitling
							Drop Table #Rights_Title_Subtitling

							-------------------- Check Subtitling for Platform

							Select Distinct rsub.Syn_Deal_Rights_Code, rp.Platform_Code, rsub.Language_Code, 0 As Platform_Cnt InTo #Rights_Platform_Subtitling 
							From #Rights_Title_Subtitling_New rsub
							Inner Join #Rights_Platform rp On rsub.Syn_Deal_Rights_Code = rp.Syn_Deal_Rights_Code
				
							Drop Table #Rights_Title_Subtitling_New

							Update u1 Set u1.Platform_Cnt = u2.cnt From #Rights_Platform_Subtitling u1 
							Inner Join(
								Select Count(*) cnt, a.Language_Code From (
									Select Distinct ups.Language_Code, ups.Platform_Code From #Rights_Platform_Subtitling ups
								) a Group By a.Language_Code
							) u2 On u1.Language_Code = u2.Language_Code
				
							--Select * From #Rights_Platform_Subtitling

							Delete From #Rights_Platform_Subtitling Where Platform_Cnt <> @Platform_Cnt

							Select Distinct Language_Code InTo #Rights_Subs From #Rights_Platform_Subtitling
							Drop Table #Rights_Platform_Subtitling

							If(@Subtitling_Type = 'SG')
							Begin

								Select @SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(td1.Language_Group_Code As Varchar(10)) From (
									Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details (NOLOCK) Where Language_Code In (
										Select Language_Code From #Rights_Subs
									) Group By Language_Group_Code
								) As td1
								Inner Join (
									Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details (NOLOCK) Group By Language_Group_Code
								) As td2 On td1.Language_Group_Code = td2.Language_Group_Code And td1.LanguageCnt = td2.LanguageCnt
						
							End
							Else
							Begin
								Select @SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(Language_Code As Varchar(10)) From #Rights_Subs
							End

						End

						-------------------- End

						-------------------- Dubbing
						Set @Dubb_Lang_Code = '0'
						If(@Dubbing_Type In ('DL', 'DG'))
						Begin

							Select Syn_Deal_Rights_Code, Case When ard.Language_Type = 'G' Then lgd.Language_Code Else ard.Language_Code End Language_Code, 0 As Platform_Cnt, 0 As Country_Cnt
							InTo #Rights_Dubbing
							From (
								Select * From Syn_Deal_Rights_Dubbing (NOLOCK) Where Syn_Deal_Rights_Code In (
									Select rp.Syn_Deal_Rights_Code From #Rights_Platform rp
								)
							) ard
							Left Join Language_Group_Details lgd On ard.Language_Group_Code = lgd.Language_Group_Code
						
							--Select * From #Rights_Dubbing
						
							---------------------- Check Dubbing for Title

							Select Distinct rsub.Syn_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rsub.Language_Code, 0 As Title_Cnt 
							InTo #Rights_Title_Dubbing
							From #Rights_Dubbing rsub
							Inner Join #AcquiredTitlesNew rtit On rsub.Syn_Deal_Rights_Code = rtit.Syn_Deal_Rights_Code

							Drop Table #Rights_Dubbing

							Update u1 Set u1.Title_Cnt = u2.cnt From #Rights_Title_Dubbing u1 
							Inner Join(
								Select Count(*) cnt, a.Language_Code From (
									Select Distinct utc.Language_Code, utc.Title_Code, utc.Episode_From, utc.Episode_To From #Rights_Title_Dubbing utc
								) As a Group By a.Language_Code
							) u2 On u1.Language_Code = u2.Language_Code
								
							Delete From #Rights_Title_Dubbing Where Title_Cnt <> @Title_Cnt
						
							--Select * From #Rights_Title_Dubbing

							---------------------- End
						
							Select Distinct Syn_Deal_Rights_Code, Language_Code InTo #Rights_Title_Dubbing_New From #Rights_Title_Dubbing
							Drop Table #Rights_Title_Dubbing

							-------------------- Check for common countries in Platform

							Select Distinct rsub.Syn_Deal_Rights_Code, rp.Platform_Code, rsub.Language_Code, 0 As Platform_Cnt InTo #Rights_Platform_Dubbing 
							From #Rights_Title_Dubbing_New rsub
							Inner Join #Rights_Platform rp On rsub.Syn_Deal_Rights_Code = rp.Syn_Deal_Rights_Code
				
							Drop Table #Rights_Title_Dubbing_New

							Update u1 Set u1.Platform_Cnt = u2.cnt From #Rights_Platform_Dubbing u1 
							Inner Join(
								Select Count(*) cnt, a.Language_Code From (
									Select Distinct upd.Language_Code, upd.Platform_Code From #Rights_Platform_Dubbing upd
								) a Group By a.Language_Code
							) u2 On u1.Language_Code = u2.Language_Code
				
							Delete From #Rights_Platform_Dubbing Where Platform_Cnt <> @Platform_Cnt

							--Select * From #Rights_Platform_Dubbing
				
							-------------------- End
						
							--Select Distinct Language_Code InTo #Rights_Dubs From #Rights_Country_Dubbing
							--Drop Table #Rights_Country_Dubbing
							Select Distinct Language_Code InTo #Rights_Dubs From #Rights_Platform_Dubbing
							Drop Table #Rights_Platform_Dubbing

						
							--Select * From #Rights_Dubs

							If(@Dubbing_Type = 'DG')
							Begin

								Select @Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(td1.Language_Group_Code As Varchar(10)) From (
									Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details (NOLOCK) Where Language_Code In (
										Select Language_Code From #Rights_Dubs
									) Group By Language_Group_Code
								) As td1
								Inner Join (
									Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details (NOLOCK) Group By Language_Group_Code
								) As td2 On td1.Language_Group_Code = td2.Language_Group_Code And td1.LanguageCnt = td2.LanguageCnt
						
							End
							Else
							Begin
								Select @Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(Language_Code As Varchar(10)) From #Rights_Dubs
							End

						End
						-------------------- End
					
						Set @Required_Codes = '0'

						If(@Region_Type = 'THT' Or @Region_Type = 'T')
						Begin

							Select @Required_Codes = @Required_Codes + ',' + Cast(td1.Territory_Code As Varchar(10)) From (
							--Select Cast(td1.Territory_Code As Varchar(10)) From (
								Select Territory_Code, Count(Country_Code) As CountryCnt From Territory_Details (NOLOCK) Where Country_Code In (
									Select Distinct Country_Code From #Rights_Country_Final
								) Group By Territory_Code
							) As td1
							Inner Join (
								Select Territory_Code, Count(Country_Code) As CountryCnt From Territory_Details (NOLOCK) Group By Territory_Code
							) As td2 On td1.Territory_Code = td2.Territory_Code And td1.CountryCnt = td2.CountryCnt
						
						End
						Else
						Begin
							Select @Required_Codes = @Required_Codes + ',' + Cast(Country_Code As Varchar(10)) From (
								Select Distinct Country_Code From #Rights_Country_Final
							) As con
						End

					End
				
					Drop Table #Rights_Platform
					Drop Table #Rights_Country_Final
					If OBJECT_ID('tempdb..#Rights_Subs') IS NOT NULL
						Drop Table #Rights_Subs
					If OBJECT_ID('tempdb..#Rights_Dubs') IS NOT NULL
					Drop Table #Rights_Dubs

				End
				If OBJECT_ID('tempdb..#AcquiredTitlesNew') IS NOT NULL
					Drop Table #AcquiredTitlesNew

			End
		End
		Select @Required_Codes As RequiredCodes,@SubTitle_Lang_Code As SubTitle_Lang_Code,@Dubb_Lang_Code As Dubb_Lang_Code

		IF OBJECT_ID('tempdb..#AcquiredTitles') IS NOT NULL DROP TABLE #AcquiredTitles
		IF OBJECT_ID('tempdb..#AcquiredTitlesNew') IS NOT NULL DROP TABLE #AcquiredTitlesNew
		IF OBJECT_ID('tempdb..#Deal_Rights_Lang') IS NOT NULL DROP TABLE #Deal_Rights_Lang
		IF OBJECT_ID('tempdb..#Rights_Country') IS NOT NULL DROP TABLE #Rights_Country
		IF OBJECT_ID('tempdb..#Rights_Country_Dubbing') IS NOT NULL DROP TABLE #Rights_Country_Dubbing
		IF OBJECT_ID('tempdb..#Rights_Country_Final') IS NOT NULL DROP TABLE #Rights_Country_Final
		IF OBJECT_ID('tempdb..#Rights_Country_New') IS NOT NULL DROP TABLE #Rights_Country_New
		IF OBJECT_ID('tempdb..#Rights_Country_Subtitling') IS NOT NULL DROP TABLE #Rights_Country_Subtitling
		IF OBJECT_ID('tempdb..#Rights_Dubbing') IS NOT NULL DROP TABLE #Rights_Dubbing
		IF OBJECT_ID('tempdb..#Rights_Dubs') IS NOT NULL DROP TABLE #Rights_Dubs
		IF OBJECT_ID('tempdb..#Rights_Platform') IS NOT NULL DROP TABLE #Rights_Platform
		IF OBJECT_ID('tempdb..#Rights_Platform_Country') IS NOT NULL DROP TABLE #Rights_Platform_Country
		IF OBJECT_ID('tempdb..#Rights_Platform_Dubbing') IS NOT NULL DROP TABLE #Rights_Platform_Dubbing
		IF OBJECT_ID('tempdb..#Rights_Platform_Dubbing_New') IS NOT NULL DROP TABLE #Rights_Platform_Dubbing_New
		IF OBJECT_ID('tempdb..#Rights_Platform_Subtitling') IS NOT NULL DROP TABLE #Rights_Platform_Subtitling
		IF OBJECT_ID('tempdb..#Rights_Platform_Subtitling_New') IS NOT NULL DROP TABLE #Rights_Platform_Subtitling_New
		IF OBJECT_ID('tempdb..#Rights_Subs') IS NOT NULL DROP TABLE #Rights_Subs
		IF OBJECT_ID('tempdb..#Rights_Subtitling') IS NOT NULL DROP TABLE #Rights_Subtitling
		IF OBJECT_ID('tempdb..#Rights_Title_Country') IS NOT NULL DROP TABLE #Rights_Title_Country
		IF OBJECT_ID('tempdb..#Rights_Title_Dubbing') IS NOT NULL DROP TABLE #Rights_Title_Dubbing
		IF OBJECT_ID('tempdb..#Rights_Title_Dubbing_New') IS NOT NULL DROP TABLE #Rights_Title_Dubbing_New
		IF OBJECT_ID('tempdb..#Rights_Title_Subtitling') IS NOT NULL DROP TABLE #Rights_Title_Subtitling
		IF OBJECT_ID('tempdb..#Rights_Title_Subtitling_New') IS NOT NULL DROP TABLE #Rights_Title_Subtitling_New
		IF OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL DROP TABLE #Temp_Dubbing
		IF OBJECT_ID('tempdb..#Temp_SUbTit') IS NOT NULL DROP TABLE #Temp_SUbTit
		IF OBJECT_ID('tempdb..#Temp_Tit_Right') IS NOT NULL DROP TABLE #Temp_Tit_Right
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GET_DATA_FOR_APPROVED_TITLES_Buyback]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End