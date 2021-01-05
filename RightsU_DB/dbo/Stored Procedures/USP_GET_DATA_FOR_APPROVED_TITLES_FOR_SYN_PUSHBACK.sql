CREATE Procedure [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK]
	@Title_Codes Varchar(1000),
	@Platform_Codes Varchar(1000),
	@Platform_Type Varchar(10),   ----- PL / TPL / ''
	@Region_Type Varchar(10),	----- T / C / THC / THT
	@Subtitling_Type Varchar(10),	------ SL / SG / ''
	@Dubbing_Type Varchar(10),	------ DL / DG / ''
	@Syn_Deal_Code Int
As
-- =============================================
-- Author:		Rajesh Godse
-- Create date:	21 September 2014
-- Description:	Get Distinct DATA of Exclusive Titles that are approved
-- =============================================
Begin
		Declare @SubTitle_Lang_Code Varchar(MAX),@Dubb_Lang_Code Varchar(MAX),@Parent_Country_Code Int,@Is_Domestic_Territory CHAR(1)
		Set @SubTitle_Lang_Code =''
		Set @Dubb_Lang_Code =''
		Set @Parent_Country_Code=0
		Set @Is_Domestic_Territory= 'N'  -- Y If (Theatrical + India) Else 'N'
		Set NOCOUNT ON;
		Set FMTONLY OFF;
-- =============================================Delete Temp Tables =============================================

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
	Declare @Selected_Deal_Type_Code Int ,@Deal_Type_Condition Varchar(MAX) = ''
	Declare @TitCnt Int = 0
	Select Top 1 @Selected_Deal_Type_Code = Deal_Type_Code From Syn_Deal Where Syn_Deal_Code = @Syn_Deal_Code
	Select @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	If(@Deal_Type_Condition = 'DEAL_PROGRAM')
	Begin
		INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
		Select Title_Code, Episode_FROM, Episode_End_To From Syn_Deal_Movie 
		Where Syn_Deal_Movie_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Syn_Deal_Code = @Syn_Deal_Code
	End
	Else
	Begin
		INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
		Select Title_Code, Episode_FROM, Episode_End_To From Syn_Deal_Movie 
		Where Title_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Syn_Deal_Code = @Syn_Deal_Code
	End
		
	Declare @Required_Codes Varchar(max) = '' ,@Total_Title_Count  Int = 0
	Select @Total_Title_Count += (Episode_To - Episode_FROM) + 1 From @Deal_Rights_Title
	--Here PL Means 'Platform' 
	-- Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
	If(@Platform_Type = 'PL' Or @Platform_Type = 'TPL')
	Begin
			
		Select @TitCnt = Count(Distinct Title_Code) From @Deal_Rights_Title

		Select Distinct adrt.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To 
		InTo #AcquiredTitles 
		From Acq_Deal_Rights_Title adrt
		Inner Join Acq_Deal_Rights adr ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code 
			--And ADR.Is_Theatrical_Right = Case When @Region_Type = 'TPL' Then 'Y' Else 'N' End
		Inner Join Acq_Deal ad ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
			And IsNull(AD.Deal_Workflow_Status,'')='A' And ADR.Is_Sub_License='Y'
			And IsNull(ADR.Is_Tentative, 'N')='N' And ADR.Actual_Right_Start_Date IS NOT NULL
			AND ADR.Is_Exclusive = 'Y'
		Inner Join @Deal_Rights_Title drt ON drt.Title_Code = adrt.Title_Code And 
		(
			drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
			drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
			adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
			adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
		)
		WHERE
		 AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
			
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
					Inner Join Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code					
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
					Inner Join Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
					Inner Join Platform P ON adrp.Platform_Code = P.Platform_Code And Applicable_For_Demestic_Territory = 'Y'
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

		Select Distinct adrt.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To,adr.Is_Theatrical_Right 
		InTo #AcquiredTitlesNew
		From Acq_Deal_Rights_Title adrt
		Inner Join Acq_Deal_Rights adr ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		Inner Join Acq_Deal ad ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
					And IsNull(AD.Deal_Workflow_Status,'')='A' And ADR.Is_Sub_License='Y'
					And IsNull(ADR.Is_Tentative, 'N')='N' And ADR.Actual_Right_Start_Date IS NOT NULL
					AND ADR.Is_Exclusive = 'Y'
					And ((@Region_Type Not In ('THC', 'THT') And ADR.Is_Theatrical_Right = 'N') Or @Region_Type In ('THC', 'THT'))
		Inner Join @Deal_Rights_Title drt ON drt.Title_Code = adrt.Title_Code And 
		(
			drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
			drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
			adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
			adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
		)
		WHERE
		 AD.Deal_Workflow_Status NOT IN ('AR', 'WA')

		Select @Total_Title_Count = Count(Distinct Title_Code) From #AcquiredTitlesNew

		If(@TitCnt = @Total_Title_Count)
		Begin

			Select @PlatformCnt = Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat Where IsNull(number, '') Not In ('', '0')

			--Select Acq_Deal_Rights_Code, Platform_Code, 0 As Rights_Cnt InTo #Rights_Platform From dbo.Acq_Deal_Rights_Platform Where 
			--	Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code From #AcquiredTitlesNew)
			--	And Platform_Code In(Select Number From dbo.fn_Split_withdelemiter(@Platform_Codes,','))
			--Group By Acq_Deal_Rights_Code, Platform_Code

			Select DISTINCT adrp.Acq_Deal_Rights_Code, Platform_Code, atn.Title_Code, atn.Episode_From, atn.Episode_To, 0 As Rights_Cnt 
			InTo #Rights_Platform
			From dbo.Acq_Deal_Rights_Platform adrp
			Inner Join #AcquiredTitlesNew atn On atn.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
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

				Select Acq_Deal_Rights_Code, Case When arter.Territory_Type = 'G' Then td.Country_Code Else arter.Country_Code End Country_Code
				InTo #Rights_Country
				From (
					Select * From Acq_Deal_Rights_Territory Where Acq_Deal_Rights_Code In (
						Select rc.Acq_Deal_Rights_Code From #Rights_Platform rc
					)
				) arter
				Left Join Territory_Details td On arter.Territory_Code = td.Territory_Code
				
				If(@Region_Type = 'THC' Or @Region_Type = 'THT')
				Begin
					Delete From #Rights_Country Where Country_Code Not In (
						Select Country_Code From Country Where Is_Theatrical_Territory = 'Y' Or Is_Domestic_Territory = 'Y'
					)
					
					Insert InTo #Rights_Country
					Select rc.Acq_Deal_Rights_Code, c.Country_Code From #Rights_Country rc 
					Inner Join Country c On rc.Country_Code = c.Parent_Country_Code And c.Is_Theatrical_Territory = 'Y' And c.Is_Active = 'Y' 
					
					Delete From #Rights_Country Where Country_Code In (
						Select Country_Code From Country Where Is_Domestic_Territory = 'Y' --Or Is_Domestic_Territory = 'N'
					)
				End
				
				If(@Is_Theatrical = 'Y')	-- And @Total_Platform_Cnt > 1
				Begin
					Delete From #Rights_Country Where Country_Code In (
						Select Country_Code From Country Where Is_Domestic_Territory = 'Y'
					)
				End

				Declare @Platform_Cnt Int = 0, @Country_Cnt Int = 0, @Title_Cnt Int = 0

				Select @Title_Cnt = Count(*) From (
					Select Distinct Title_Code, Episode_From, Episode_To From #AcquiredTitlesNew
				) As a

				Select @Platform_Cnt = Count(Distinct Platform_Code) From #Rights_Platform
				
				--Select * From #Rights_Country

				-------------------- Check for common countries in title

				Select Distinct rcon.Acq_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rcon.Country_Code, 0 As Country_Cnt InTo #Rights_Title_Country 
				From #Rights_Country rcon
				Inner Join #AcquiredTitlesNew rtit On rcon.Acq_Deal_Rights_Code = rtit.Acq_Deal_Rights_Code

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

				Select Distinct Acq_Deal_Rights_Code, Country_Code InTo #Rights_Country_New From #Rights_Title_Country
				Drop Table #Rights_Title_Country

				-------------------- Check for common countries in Platform

				Select Distinct rcon.Acq_Deal_Rights_Code, rp.Platform_Code, rcon.Country_Code, 0 As Country_Cnt InTo #Rights_Platform_Country 
				From #Rights_Country_New rcon
				Inner Join #Rights_Platform rp On rcon.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
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

				Select Distinct Acq_Deal_Rights_Code, Country_Code InTo #Rights_Country_Final From #Rights_Platform_Country
				Drop Table #Rights_Platform_Country

				If Exists(Select Top 1 * From #Rights_Country_Final)
				Begin
				
					Select @Country_Cnt = Count(Distinct Country_Code) From #Rights_Country_Final

					--------------------- Subtitling
					Set @SubTitle_Lang_Code = '0'
					If(@Subtitling_Type In ('SL', 'SG'))
					Begin

						Select Acq_Deal_Rights_Code, Case When ars.Language_Type = 'G' Then lgd.Language_Code Else ars.Language_Code End Language_Code
						InTo #Rights_Subtitling
						From (
							Select * From Acq_Deal_Rights_Subtitling Where Acq_Deal_Rights_Code In (
								Select rp.Acq_Deal_Rights_Code From #Rights_Platform rp
							)
						) ars
						Left Join Language_Group_Details lgd On ars.Language_Group_Code = lgd.Language_Group_Code
						
						--Select * From #Rights_Subtitling

						---------------------- Check subtitling for Title

						Select Distinct rsub.Acq_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rsub.Language_Code, 0 As Title_Cnt 
						InTo #Rights_Title_Subtitling
						From #Rights_Subtitling rsub
						Inner Join #AcquiredTitlesNew rtit On rsub.Acq_Deal_Rights_Code = rtit.Acq_Deal_Rights_Code

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
						
						Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Title_Subtitling_New From #Rights_Title_Subtitling
						Drop Table #Rights_Title_Subtitling

						-------------------- Check Subtitling for Platform

						Select Distinct rsub.Acq_Deal_Rights_Code, rp.Platform_Code, rsub.Language_Code, 0 As Platform_Cnt InTo #Rights_Platform_Subtitling 
						From #Rights_Title_Subtitling_New rsub
						Inner Join #Rights_Platform rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						Drop Table #Rights_Title_Subtitling_New

						Update u1 Set u1.Platform_Cnt = u2.cnt From #Rights_Platform_Subtitling u1 
						Inner Join(
							Select Count(*) cnt, a.Language_Code From (
								Select Distinct ups.Language_Code, ups.Platform_Code From #Rights_Platform_Subtitling ups
							) a Group By a.Language_Code
						) u2 On u1.Language_Code = u2.Language_Code
				
						--Select * From #Rights_Platform_Subtitling

						Delete From #Rights_Platform_Subtitling Where Platform_Cnt <> @Platform_Cnt

						--Select * From #Rights_Platform_Subtitling
				
						-------------------- End
						
						--Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Platform_Subtitling_New From #Rights_Platform_Subtitling
						--Drop Table #Rights_Platform_Subtitling

						---------------------- Check subtitling for Country
						
						--Select Distinct rsub.Acq_Deal_Rights_Code, rp.Country_Code, rsub.Language_Code, 0 As Country_Cnt InTo #Rights_Country_Subtitling 
						--From #Rights_Platform_Subtitling_New rsub
						--Inner Join #Rights_Country_Final rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						--Drop Table #Rights_Platform_Subtitling_New

						--Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Country_Subtitling u1 
						--Inner Join(
						--	Select Count(*) cnt, a.Language_Code From (
						--		Select Distinct ucs.Country_Code, ucs.Language_Code From #Rights_Country_Subtitling ucs
						--	) a Group By a.Language_Code
						--) u2 On u1.Language_Code = u2.Language_Code
				
						--Delete From #Rights_Country_Subtitling Where Country_Cnt <> @Country_Cnt
				
						---------------------- End
						
						--Select Distinct Language_Code InTo #Rights_Subs From #Rights_Country_Subtitling
						--Drop Table #Rights_Country_Subtitling
						Select Distinct Language_Code InTo #Rights_Subs From #Rights_Platform_Subtitling
						Drop Table #Rights_Platform_Subtitling

						If(@Subtitling_Type = 'SG')
						Begin

							Select @SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(td1.Language_Group_Code As Varchar(10)) From (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Where Language_Code In (
									Select Language_Code From #Rights_Subs
								) Group By Language_Group_Code
							) As td1
							Inner Join (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Group By Language_Group_Code
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

						Select Acq_Deal_Rights_Code, Case When ard.Language_Type = 'G' Then lgd.Language_Code Else ard.Language_Code End Language_Code, 0 As Platform_Cnt, 0 As Country_Cnt
						InTo #Rights_Dubbing
						From (
							Select * From Acq_Deal_Rights_Dubbing Where Acq_Deal_Rights_Code In (
								Select rp.Acq_Deal_Rights_Code From #Rights_Platform rp
							)
						) ard
						Left Join Language_Group_Details lgd On ard.Language_Group_Code = lgd.Language_Group_Code
						
						--Select * From #Rights_Dubbing
						
						---------------------- Check Dubbing for Title

						Select Distinct rsub.Acq_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rsub.Language_Code, 0 As Title_Cnt 
						InTo #Rights_Title_Dubbing
						From #Rights_Dubbing rsub
						Inner Join #AcquiredTitlesNew rtit On rsub.Acq_Deal_Rights_Code = rtit.Acq_Deal_Rights_Code

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
						
						Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Title_Dubbing_New From #Rights_Title_Dubbing
						Drop Table #Rights_Title_Dubbing

						-------------------- Check for common countries in Platform

						Select Distinct rsub.Acq_Deal_Rights_Code, rp.Platform_Code, rsub.Language_Code, 0 As Platform_Cnt InTo #Rights_Platform_Dubbing 
						From #Rights_Title_Dubbing_New rsub
						Inner Join #Rights_Platform rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
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
						
						--Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Platform_Dubbing_New From #Rights_Platform_Dubbing
						--Drop Table #Rights_Platform_Dubbing

						---------------------- Check Dubbing for Country
						
						--Select Distinct rsub.Acq_Deal_Rights_Code, rp.Country_Code, rsub.Language_Code, 0 As Country_Cnt InTo #Rights_Country_Dubbing 
						--From #Rights_Platform_Dubbing_New rsub
						--Inner Join #Rights_Country_Final rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						--Drop Table #Rights_Platform_Dubbing_New

						--Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Country_Dubbing u1 
						--Inner Join(
						--	Select Count(*) cnt, a.Language_Code From (
						--		Select Distinct rcd.Language_Code, rcd.Country_Code From #Rights_Country_Dubbing rcd
						--	) a Group By a.Language_Code
						--) u2 On u1.Language_Code = u2.Language_Code
				
						--Delete From #Rights_Country_Dubbing Where Country_Cnt <> @Country_Cnt

						--Select * From #Rights_Country_Dubbing
				
						---------------------- End
						
						--Select Distinct Language_Code InTo #Rights_Dubs From #Rights_Country_Dubbing
						--Drop Table #Rights_Country_Dubbing
						Select Distinct Language_Code InTo #Rights_Dubs From #Rights_Platform_Dubbing
						Drop Table #Rights_Platform_Dubbing

						
						--Select * From #Rights_Dubs

						If(@Dubbing_Type = 'DG')
						Begin

							Select @Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(td1.Language_Group_Code As Varchar(10)) From (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Where Language_Code In (
									Select Language_Code From #Rights_Dubs
								) Group By Language_Group_Code
							) As td1
							Inner Join (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Group By Language_Group_Code
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
							Select Territory_Code, Count(Country_Code) As CountryCnt From Territory_Details Where Country_Code In (
								Select Distinct Country_Code From #Rights_Country_Final
							) Group By Territory_Code
						) As td1
						Inner Join (
							Select Territory_Code, Count(Country_Code) As CountryCnt From Territory_Details Group By Territory_Code
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

			--Select Distinct ADR.Acq_Deal_Rights_Code, ADR.Title_Code, ADR.Episode_FROM, ADR.Episode_To, ADRP.Platform_Code, 
			--CASE WHEN @Region_Type <> 'T' And @Region_Type <> 'THT' 
			--		THEN  ADRTr.Country_Code
			--		Else CASE WHEN IsNull(ADRTr.Territory_Code,0) = 0 And @Is_Domestic_Territory ='Y' THEN  ADRTr.Country_Code Else ADRTr.Territory_Code  End
			--End As Territory_Code, ADRTr.Territory_Type InTo #Temp_Tit_Right
			--From #AcquiredTitlesNew ADR
			--Inner Join dbo.Acq_Deal_Rights_Platform ADRP WITH (INDEX(IX_Acq_Deal_Rights_Platform_Platform)) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			--Inner Join dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat ON plat.number = ADRP.Platform_Code
			--Inner Join Acq_Deal_Rights_Territory ADRTr ON ADR.Acq_Deal_Rights_Code=ADRTr.Acq_Deal_Rights_Code				
			--And (((Territory_Type=@Territory_Type And @Territory_Type = 'G') Or (@Territory_Type = 'I')) Or @Is_Domestic_Territory = 'Y')				
			
			--Declare @InValidComb Char(1) = 'N'
			----If(@Is_Domestic_Territory = 'Y') --Check India is avail Or not
			----Begin
			----	If((Select  Count(T.Territory_Code) From #Temp_Tit_Right T Where t.Territory_Code in(Select Country_Code From Country C Where C.Is_Domestic_Territory = 'Y')) <= 0)
			----	Begin						
			----		Set @InValidComb = 'Y'
			----	End
			----End

			--If(@InValidComb = 'N')
			--Begin

			--	Delete From #Temp_Tit_Right 
			--	Where Platform_Code Not IN 
			--	(
			--		Select Platform_Code
			--		From #Temp_Tit_Right
			--		Group By Platform_Code
			--		Having Count(Distinct Cast(Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) = @Total_Title_Count
			--	)
			
			--	Select 
			--		@PlatformCnt = Count(Distinct Platform_Code) 
			--	From #Temp_Tit_Right
			
			--	Delete From #Temp_Tit_Right 
			--	Where Territory_Code Not IN 
			--	(
			--		Select Territory_Code
			--		From #Temp_Tit_Right
			--		Group By Territory_Code
			--		Having Count(Distinct Cast(Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) = @Total_Title_Count And
			--			   Count(Distinct Platform_Code) = @PlatformCnt
			--	)
			
			--	Select @CountryCnt = Count(Distinct Territory_Code) From #Temp_Tit_Right
			--	Set @Required_Codes = '0'
			--	If(@CountryCnt > 0)
			--	Begin
			--			If(@Region_Type = 'THC' And @Is_Domestic_Territory = 'Y')
			--			Begin
			--				Select @Required_Codes = @Required_Codes + ',' + Cast(C.Country_Code As Varchar(10))
			--				From Country C Where  1 =1
			--				And Is_Theatrical_Territory = 'Y' And IsNull(C.Parent_Country_Code,0) > 0
			--			End
			--			Else If(@Region_Type = 'THT' And @Is_Domestic_Territory = 'Y')
			--			Begin
			--				Select @Required_Codes = @Required_Codes + ',' + Cast(T.Territory_Code As Varchar(10)) 							
			--				From Territory T Where  1 =1 
			--				And Is_Thetrical = 'Y' And Is_Active = 'Y'
			--			End
			--			Else
			--			Begin											
			--				Select 
			--					@Required_Codes = @Required_Codes + +',' + Cast(Territory_Code As Varchar(10)) From 
			--					(
			--						Select Distinct Territory_Code 
			--						From #Temp_Tit_Right T							
			--						Group By Title_Code, Episode_FROM, Episode_To, Territory_Code
			--					) As a
			--			End
			--	End	
				
			--	Set @SubTitle_Lang_Code = '0'
			--	Set @Dubb_Lang_Code = '0'

			--	If(@Required_Codes<>'0')
			--	Begin 				
			--		Select Distinct 
			--			 (Cast(ADR.Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) As Title_Code_With_Episode, 
			--			ADR.Platform_Code, ADR.Territory_Code,
			--			Case When ADRS.Language_Type = 'G' Then lgd.Language_Code Else ADRS.Language_Code End Language_Code
			--			--ADRS.Language_Code
			--		InTo #Temp_SUbTit
			--		From dbo.Acq_Deal_Rights_Subtitling ADRS
			--		Inner Join #Temp_Tit_Right ADR ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code
			--		Left Join Language_Group_Details lgd On ADRS.Language_Group_Code = lgd.Language_Group_Code

			--		Select Distinct 
			--			(Cast(ADR.Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) As Title_Code_With_Episode, 
			--			ADR.Platform_Code, ADR.Territory_Code,
			--			Case When ADRD.Language_Type = 'G' Then lgd.Language_Code Else ADRD.Language_Code End Language_Code
			--			--, ADRD.Language_Code
			--		InTo #Temp_Dubbing
			--		From dbo.Acq_Deal_Rights_Dubbing ADRD
			--		Inner Join #Temp_Tit_Right ADR ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code
			--		Left Join Language_Group_Details lgd On ADRD.Language_Group_Code = lgd.Language_Group_Code

			--		Select 
			--			@SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(Language_Code As Varchar(10))
			--		From #Temp_SUbTit ADR
			--		Group By Language_Code
			--		Having Count(Distinct Title_Code_With_Episode) = @Total_Title_Count And
			--			   Count(Distinct Platform_Code) = @PlatformCnt 							

			--		Select 
			--			@Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(Language_Code As Varchar(10))
			--		From #Temp_Dubbing ADR
			--		Group By Language_Code
			--		Having Count(Distinct Title_Code_With_Episode) = @Total_Title_Count And
			--			   Count(Distinct Platform_Code) = @PlatformCnt 
			--	End
			--End
			--Drop Table #Temp_Tit_Right
			--If OBJECT_ID('tempdb..#Temp_SUbTit') IS NOT NULL
			--	Drop Table #Temp_SUbTit
			--If OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL
			--Drop Table #Temp_Dubbing

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
End