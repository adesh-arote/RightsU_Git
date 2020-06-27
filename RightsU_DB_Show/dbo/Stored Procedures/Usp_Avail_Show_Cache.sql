CREATE PROCEDURE [dbo].[Usp_Avail_Show_Cache]
	@Record_Code INT = 49,
	@Record_Type Char(1) = 'A'
AS
Begin
-- =============================================
-- Author:		ADESH AROTE
-- Create DATE: 19-Feb-2016
-- Description:	Cache Acquisition on deal approval for availability
-- =============================================
	Create Table #Process_Rights(
		Acq_Deal_Code Int,
		Acq_Deal_Rights_Code Int,
		Sub_License_Code Int,
		Actual_Right_Start_Date DateTime,
		Actual_Right_End_Date DateTime,
		Is_Title_Language_Right Char(1), 
		Is_Exclusive Char(1), 
		Is_Theatrical_Right Char(1)
	)

	If(@Record_Type = 'A')
	Begin

		Insert InTo #Process_Rights(Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
									Is_Exclusive, Is_Theatrical_Right)
		Select ad.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code,adr.Sub_License_Code,ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,adr.Is_Title_Language_Right
			, adr.Is_Exclusive, adr.Is_Theatrical_Right
			From Acq_Deal_Rights adr
			INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code=adr.Acq_Deal_Code
			where ad.Is_Master_Deal='Y'
			AND IsNull(adr.Is_Tentative, 'N')='N'
			AND adr.Is_Sub_License='Y'
			AND adr.Actual_Right_Start_Date Is Not Null --AND adr.Actual_Right_End_Date is not null
			AND adr.Acq_Deal_Code = @Record_Code --And Acq_Deal_Rights_Code = 778
			AND IsNull(adr.Is_Theatrical_Right, 'N') = 'N'
			AND (adr.Actual_Right_End_Date is null Or adr.Actual_Right_End_Date > GetDate())
	End
	Else
	Begin
	
		Insert InTo #Process_Rights(Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
									Is_Exclusive, Is_Theatrical_Right)
		Select ad.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code,adr.Sub_License_Code,ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,adr.Is_Title_Language_Right
			, adr.Is_Exclusive, adr.Is_Theatrical_Right
			From Acq_Deal_Rights adr
			INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code=adr.Acq_Deal_Code
			Where ad.Is_Master_Deal='Y'
			AND IsNull(adr.Is_Tentative, 'N')='N'
			AND adr.Is_Sub_License='Y'
			AND adr.Actual_Right_Start_Date Is Not Null
			AND IsNull(adr.Is_Theatrical_Right, 'N') = 'N'
			AND (adr.Actual_Right_End_Date is null Or adr.Actual_Right_End_Date > GetDate())
			AND ADR.Acq_Deal_Rights_Code In (
				Select Deal_Rights_Code From Avail_Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @Record_Code
				Union
				Select Deal_Rights_Code From Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @Record_Code 
			)
	End

	Declare @Theatrical_Code Int = 0, @India_Code Int = 0, @Acq_Deal_Code INT = 0
	Select @Theatrical_Code = Cast(Parameter_Value As Int) From System_Parameter_New where Parameter_Name='THEATRICAL_PLATFORM_CODE'
	Select @India_Code = Cast(Parameter_Value As Int) From System_Parameter_New where Parameter_Name='INDIA_COUNTRY_CODE'

	Declare @Acq_Deal_Rights_Code Int = 0, @Sub_License_Code Int = 0, 
			@Actual_Right_Start_Date DateTime, @Actual_Right_End_Date DateTime,
			@Is_Title_Language_Right Char(1) = '',
			@Is_Exclusive Char(1) = '', @Is_Theatrical_Right Char(1)
	
	
	Create Table #Temp_Session_Raw(
		Avail_Acq_Show_Code numeric(38, 0),
		Avail_Raw_Code numeric(38, 0),
		Acq_Deal_Code int,
		Acq_Deal_Rights_Code int,
		Avail_Dates_Code numeric(38, 0),
		Is_Exclusive bit,
		Episode_From int,
		Episode_To int,
		Is_Title_Lang Char(1),
		Sub_Languages_Code numeric(38, 0),
		Dub_Languages_Code numeric(38, 0),
		Is_Same Char(1)
	)
	
	Create Table #Temp_Session_Raw_Lang(
		Avail_Acq_Show_Code numeric(38, 0),
		Avail_Raw_Code numeric(38, 0),
		Acq_Deal_Code int,
		Acq_Deal_Rights_Code int,
		Avail_Dates_Code numeric(38, 0),
		Is_Exclusive bit,
		Episode_From int,
		Episode_To int,
		Language_Codes Varchar(Max),
		Rec_Type Char(1),
		Avail_Languages_Code numeric(38, 0)
	)
	Delete From Avail_Acq_Show_Details Where Avail_Raw_Code In (
		Select Avail_Raw_Code From Avail_Raw Where Acq_Deal_Rights_Code In (
			Select Acq_Deal_Rights_Code From #Process_Rights
		)
	)
	Declare CUR_Rights Cursor For
			Select Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
				   Is_Exclusive, Is_Theatrical_Right
			From #Process_Rights
	Open CUR_Rights
	Fetch From CUR_Rights InTo @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	While(@@FETCH_STATUS = 0)
	Begin
		
		If OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL
		Begin
			Drop TABLE #TMP_ACQ_DETAILS
		End

		If OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL
		Begin
			Drop TABLE #TMP_Acq_SUBTITLING
		End

		If OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL
		Begin
			Drop TABLE #TMP_Acq_DUBBING
		End

		Select Distinct Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Acq_Contry From (
			Select Acq_Deal_Rights_Code, Territory_Code, Country_Code, Territory_Type 
			From Acq_Deal_Rights_Territory  
			Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) As srter
		Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code
		
		Print 'AD 0 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Select distinct ADR.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adrp.Platform_Code, con.Country_Code, 
						@Is_Theatrical_Right Is_Theatrical_Right, 0 Avail_Acq_Show_Code, 'N' Is_Syn
		InTo #TMP_ACQ_DETAILS
		From (
			Select @Acq_Deal_Rights_Code Acq_Deal_Rights_Code
		) As adr
		INNER JOIN Acq_Deal_Rights_Title adrt on adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Platform adrp on adrp.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN #Acq_Contry con On 1 = 1

		Alter Table #TMP_ACQ_DETAILS Add Syn_Rights_Codes Varchar(2000)

		Print 'AD 1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Drop Table #Acq_Contry
			
		If(@Is_Theatrical_Right = 'N')
		Begin
			
			--Insert InTo #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Is_Theatrical_Right, Avail_Acq_Show_Code, Is_Syn)
			--Select adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Episode_From, adr.Episode_To, adr.Platform_Code, c.Country_Code, 'Y', 0, 'N'
			--From #TMP_ACQ_DETAILS adr
			--Inner Join Country c On adr.Country_Code = c.Parent_Country_Code And adr.Country_Code = @India_Code
			--And Platform_Code = @Theatrical_Code

			Print 'AD 2.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Delete From #TMP_ACQ_DETAILS Where Platform_Code = @Theatrical_Code And Country_Code = @India_Code

			Print 'AD 2.2 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
		End

		--CREATE NONCLUSTERED INDEX IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code ON #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code)

		--------- CHECK INTERNATIONAL AVAILABILITY

		Update t Set t.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Show a On t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code And t.Is_Theatrical_Right = 'N'

		Print 'AD 3 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
		Insert InTo Avail_Acq_Show(Title_Code, Platform_Code, Country_Code)
		Select Title_Code, Platform_Code, Country_Code From #TMP_ACQ_DETAILS Where IsNull(Avail_Acq_Show_Code, 0) = 0 And Is_Theatrical_Right = 'N'

		Print 'AD 4 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Update t Set t.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Show a On t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Show_Code, 0) = 0 And t.Is_Theatrical_Right = 'N'

		Print 'AD 5 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
		
		--Delete From #TMP_ACQ_DETAILS Where Avail_Acq_Show_Code <> 13636

		---------- End

		Select Distinct CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code End Language_Code, Acq_Deal_Rights_Code InTo #Acq_Sub
		FROM(
			Select Distinct Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Subtitling
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		Print 'AD 9 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Select ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Episode_From, adr.Episode_To, adr.Platform_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Show_Code, Is_Theatrical_Right, 'N' Is_Syn
		InTo #TMP_Acq_SUBTITLING
		From #TMP_ACQ_DETAILS ADR --WITH (INDEX(IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code)) 
		INNER JOIN #Acq_Sub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And ADR.Is_Theatrical_Right = 'N'
		
		Alter Table #TMP_Acq_SUBTITLING Add Syn_Rights_Codes Varchar(2000)

		Print 'AD 10 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_Title_Code ON #TMP_Acq_SUBTITLING(Title_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_Platform_Code ON #TMP_Acq_SUBTITLING(Platform_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_Country_Code ON #TMP_Acq_SUBTITLING(Country_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_Language_Code ON #TMP_Acq_SUBTITLING(Language_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Combine ON #TMP_Acq_SUBTITLING(Title_Code, Platform_Code, Country_Code, Language_Code)

		Print 'AD 11 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Drop Table #Acq_Sub
		
		Select Distinct CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code End Language_Code, Acq_Deal_Rights_Code InTo #Acq_Dub
		FROM(
			Select Distinct Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Dubbing
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		Print 'AD 12 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Select ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Episode_From, adr.Episode_To, adr.Platform_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Show_Code, Is_Theatrical_Right, 'N' Is_Syn
		InTo #TMP_Acq_DUBBING
		FROM #TMP_ACQ_DETAILS ADR --WITH (INDEX(IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code)) 
		INNER JOIN #Acq_Dub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And ADR.Is_Theatrical_Right = 'N'
		
		Alter Table #TMP_Acq_DUBBING Add Syn_Rights_Codes Varchar(2000)

		Print 'AD 13 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Title_Code ON #TMP_Acq_DUBBING(Title_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Platform_Code ON #TMP_Acq_DUBBING(Platform_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Country_Code ON #TMP_Acq_DUBBING(Country_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Language_Code ON #TMP_Acq_DUBBING(Language_Code)
		--CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_DUB_Combine ON #TMP_Acq_DUBBING(Title_Code, Platform_Code, Country_Code, Language_Code)

		Print 'AD 14 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
		Drop Table #Acq_Dub

		Declare @Is_Exclusive_Bit bit = Case When @Is_Exclusive = 'N' Then 0 Else 1 End
		
		If(@Is_Exclusive = 'N')------------ CATCHE THE RECORDS WHICH ARE ACQUIRED EXCLUSIVE NO
		Begin
		
			Declare @Avial_Dates_Code Int = 0
			Select @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) From [dbo].[Avail_Dates] Where [Start_Date] = @Actual_Right_Start_Date And IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
			if(@Avial_Dates_Code Is Null or @Avial_Dates_Code = 0)
			Begin
				Insert InTo [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
				Select @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
			End

			Truncate Table #Temp_Session_Raw
			Truncate Table #Temp_Session_Raw_Lang

			Insert InTo #Temp_Session_Raw_Lang(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Language_Codes, Rec_Type)
			Select Distinct Avail_Acq_Show_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Episode_From, Episode_To, Lang, Rec_Type From (
				Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, '' Lang, 'T' Rec_Type From #TMP_ACQ_DETAILS 
				Where Is_Theatrical_Right = 'N' And @Is_Title_Language_Right = 'Y'
				Union
				Select Avail_Acq_Show_Code, Episode_From, Episode_To, STUFF
				(
					(
						SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT Distinct Language_Code From #TMP_Acq_SUBTITLING subIn
							Where subIn.Episode_From = sub.Episode_From And subIn.Episode_To = sub.Episode_To
								  And subIn.Avail_Acq_Show_Code = sub.Avail_Acq_Show_Code
						) As a
						FOR XML PATH('')
					), 1, 1, ''
				)
				, 'S' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To From #TMP_Acq_SUBTITLING Where Is_Theatrical_Right = 'N') sub
				Union
				Select Avail_Acq_Show_Code, Episode_From, Episode_To, STUFF
				(
					(
						SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT Distinct Language_Code From #TMP_Acq_DUBBING dubIn
							Where dubIn.Episode_From = dub.Episode_From And dubIn.Episode_To = dub.Episode_To
								  And dubIn.Avail_Acq_Show_Code = dub.Avail_Acq_Show_Code
						) As a
						FOR XML PATH('')
					), 1, 1, ''
				)
				, 'D' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To From #TMP_Acq_DUBBING Where Is_Theatrical_Right = 'N') dub
			) As a
			Insert InTo #Temp_Session_Raw(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Is_Same)
			Select Distinct Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 'N' From #Temp_Session_Raw_Lang
				
			Print 'AD 14.2 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			--Update #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' Where IsNull(Language_Codes, '') <> ''

			Insert InTo Avail_Languages(Language_Codes)
			Select Distinct Language_Codes From #Temp_Session_Raw_Lang Where Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  Not In (
				Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  From Avail_Languages a
			) And Language_Codes <> ''
			
			Update temp set temp.Avail_Languages_Code = al.Avail_Languages_Code From #Temp_Session_Raw_Lang temp 
			Inner Join Avail_Languages al On temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 
			
			Print 'AD 14.3 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update t1 Set t1.Is_Title_Lang = 1
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code And
			t1.Avail_Dates_Code = t2.Avail_Dates_Code And
			t1.Is_Exclusive = t2.Is_Exclusive And
			t1.Episode_From = t2.Episode_From And 
			t1.Episode_To = t2.Episode_To And
			t2.Rec_Type = 'T'

			Print 'AD 14.4 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code And
			t1.Avail_Dates_Code = t2.Avail_Dates_Code And
			t1.Is_Exclusive = t2.Is_Exclusive And
			t1.Episode_From = t2.Episode_From And 
			t1.Episode_To = t2.Episode_To And
			t2.Rec_Type = 'S'

			Print 'AD 14.5 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code And
			t1.Avail_Dates_Code = t2.Avail_Dates_Code And
			t1.Is_Exclusive = t2.Is_Exclusive And
			t1.Episode_From = t2.Episode_From And 
			t1.Episode_To = t2.Episode_To And
			t2.Rec_Type = 'D'

			Print 'AD 14.6 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Truncate Table #Temp_Session_Raw_Lang

			Select Distinct traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To 
			InTo #Temp_Session_Raw_Distinct
			From #Temp_Session_Raw traw

			MERGE INTO Avail_Raw AS araw
			Using #Temp_Session_Raw_Distinct AS traw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code And
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
			traw.Avail_Dates_Code = araw.Avail_Dates_Code And
			traw.Is_Exclusive = araw.Is_Exclusive And
			traw.Episode_From = araw.Episode_From And
			traw.Episode_To = araw.Episode_To
			WHEN NOT MATCHED THEN
				INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To, 0)
			;

			Drop Table #Temp_Session_Raw_Distinct
				
			Print 'AD 14.7 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
			Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
			Inner Join Avail_Raw araw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code And
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
			traw.Avail_Dates_Code = araw.Avail_Dates_Code And
			traw.Is_Exclusive = araw.Is_Exclusive And
			traw.Episode_From = araw.Episode_From And
			traw.Episode_To = araw.Episode_To
			
			Print 'AD 14.8 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
	
			Insert InTo Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			Select Avail_Acq_Show_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw
			
			Truncate Table #Temp_Session_Raw

		End
		Else
		Begin
	
			Begin ------------ GENERATE SYNDICATION DATA FOR CURRENT COMBINATION

				Select Distinct srter.Syn_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Syn_Territory 
				From (
					Select sdrtr.Syn_Deal_Rights_Code, sdrtr.Territory_Code, sdrtr.Country_Code, sdrtr.Territory_Type 
					From Syn_Deal_Rights_Territory sdrtr
					Where sdrtr.Syn_Deal_Rights_Code In (
						Select samIn.Syn_Deal_Rights_Code From Syn_Acq_Mapping samIn Where samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) As srter
				Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code

				Print 'AD 15 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Select Distinct srsub.Syn_Deal_Rights_Code, Case When srsub.Language_Type = 'G' Then lgd.Language_Code Else srsub.Language_Code End Language_Code InTo #Syn_Subtitling
				From (
					Select sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					From Syn_Deal_Rights_Subtitling sdrs
					Where sdrs.Syn_Deal_Rights_Code In (
						Select samIn.Syn_Deal_Rights_Code From Syn_Acq_Mapping samIn Where samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) As srsub
				Left Join Language_Group_Details lgd On srsub.Language_Group_Code = lgd.Language_Group_Code

				Print 'AD 16 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
		
				Select Distinct srsub.Syn_Deal_Rights_Code, Case When srsub.Language_Type = 'G' Then lgd.Language_Code Else srsub.Language_Code End Language_Code InTo #Syn_Dubbing
				From (
					Select sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					From Syn_Deal_Rights_Dubbing sdrs
					Where sdrs.Syn_Deal_Rights_Code In (
						Select samIn.Syn_Deal_Rights_Code From Syn_Acq_Mapping samIn Where samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) As srsub
				Left Join Language_Group_Details lgd On srsub.Language_Group_Code = lgd.Language_Group_Code

				Print 'AD 17 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Select Distinct sdr.Syn_Deal_Rights_Code, sdr.Is_Exclusive, sdr.Is_Title_Language_Right, sdr.Is_Theatrical_Right, sdr.Actual_Right_Start_Date, 
								sdr.Actual_Right_End_Date, sdrt.Title_Code, sdrt.Episode_From, sdrt.Episode_To, sdrp.Platform_Code, synter.Country_Code 
				InTo #Syn_Data
				From Syn_Deal_Rights sdr 
				Inner Join Syn_Acq_Mapping sam On sam.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code And Deal_Rights_Code = @Acq_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_Platform sdrp On sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				Inner Join #Syn_Territory synter On sdr.Syn_Deal_Rights_Code = synter.Syn_Deal_Rights_Code
				Where Actual_Right_Start_Date Is Not Null
				And sdrt.Title_Code In (
					Select adr.Title_Code From #TMP_ACQ_DETAILS adr Where adr.Platform_Code = sdrp.Platform_Code And adr.Country_Code = synter.Country_Code
					And (
						(adr.Episode_From Between sdrt.Episode_From And sdrt.Episode_To)
						Or
						(adr.Episode_To Between sdrt.Episode_From And sdrt.Episode_To)
						Or
						(sdrt.Episode_From Between adr.Episode_From And adr.Episode_To)
						Or
						(sdrt.Episode_To Between adr.Episode_From And adr.Episode_To)
					)
				)
				Print 'AD 18 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				--Select * From #TMP_ACQ_DETAILS
				--Select * From #Syn_Data

				Drop Table #Syn_Territory

				--Drop INDEX Syn_Title_Avail_Data.IX_Syn_Title_Avail_Data_INDEX
				--Drop INDEX Syn_Sub_Avail_Data.IX_Syn_Sub_Avail_Data_INDEX
				--Drop INDEX Syn_Dub_Avail_Data.IX_Syn_Dub_Avail_Data_INDEX

				--Insert InTo #Syn_Title_Avail_Data(Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date,
				--								 Actual_Right_End_Date, Title_Code, Platform_Code, Country_Code)
				--Select Distinct Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date,
				--Actual_Right_End_Date, Title_Code, Platform_Code, Country_Code 
				--From #Syn_Data Where Is_Title_Language_Right = 'Y'

				Create table #Syn_Title_Avail_Data
				(
					Syn_Deal_Rights_Code Int,
					Is_Exclusive CHAR(1), 
					Is_Title_Language_Right CHAR(1),  
					Is_Theatrical_Right CHAR(1), 
					Actual_Right_Start_Date DATETIME,
					Actual_Right_End_Date DATETIME, 
					Title_Code INT, 
					Episode_From INT,
					Episode_To INT,
					Platform_Code INT, 
					Country_Code INT
				)

				INSERT INTO #Syn_Title_Avail_Data(Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date, Actual_Right_End_Date, 
					Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code)
				Select Distinct Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code
				From #Syn_Data Where Is_Title_Language_Right = 'Y'
		
				Print 'AD 19 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				--Select * From Syn_Title_Avail_Data

				--Insert InTo Syn_Sub_Avail_Data(Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
				--							   Actual_Right_End_Date, Title_Code, Platform_Code, Country_Code, Subtitling_Code)
				Select Distinct syn.Syn_Deal_Rights_Code, Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, sdrs.Language_Code
				InTo #Syn_Sub_Avail_Data
				From #Syn_Data syn
				Inner Join #Syn_Subtitling sdrs On syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code
		
				--Alter Table #Syn_Sub_Avail_Data Add IntCode Int Identity(1,1)

				--Print 'AD 20 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Drop Table #Syn_Subtitling

				----Insert InTo Syn_Dub_Avail_Data(Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
				----							   Actual_Right_End_Date, Title_Code, Platform_Code, Country_Code, Dubbing_Code)
				Select Distinct syn.Syn_Deal_Rights_Code, Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, sdrd.Language_Code
				InTo #Syn_Dub_Avail_Data
				From #Syn_Data syn
				Inner Join #Syn_Dubbing sdrd On syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
		
				Print 'AD 21 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Drop Table #Syn_Dubbing
				Drop Table #Syn_Data

			End ------------ End
		
			Update tmp Set Is_Syn = 'Y', 
						   tmp.Syn_Rights_Codes = STUFF
							(
								(
									Select Distinct ',' + CAST(Syn_Deal_Rights_Code as Varchar) From #Syn_Title_Avail_Data b
									Where tmp.Title_Code = b.Title_Code 
										And tmp.Country_Code = b.Country_Code 
										And tmp.Platform_Code = b.Platform_Code
										And (
											(b.Episode_From Between tmp.Episode_From And tmp.Episode_To)
											Or
											(b.Episode_To Between tmp.Episode_From And tmp.Episode_To)
											Or
											(tmp.Episode_From Between b.Episode_From And b.Episode_To)
											Or
											(tmp.Episode_To Between b.Episode_From And b.Episode_To)
										)
									FOR XML PATH('')
								), 1, 1, ''
							)
			From #TMP_ACQ_DETAILS tmp
			Inner Join #Syn_Title_Avail_Data syn On syn.Title_Code = tmp.Title_Code And 
					   syn.Platform_Code = tmp.Platform_Code And
					   syn.Country_Code = tmp.Country_Code And (
							(syn.Episode_From Between tmp.Episode_From And tmp.Episode_To)
							Or
							(syn.Episode_To Between tmp.Episode_From And tmp.Episode_To)
							Or
							(tmp.Episode_From Between syn.Episode_From And syn.Episode_To)
							Or
							(tmp.Episode_To Between syn.Episode_From And syn.Episode_To)
						)   
		
			Print 'AD 22 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Print 'AD 22.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)


			Update tmp Set Is_Syn = 'Y',
						   tmp.Syn_Rights_Codes = STUFF(
								(
									Select Distinct ',' + CAST(Syn_Deal_Rights_Code as Varchar) From #Syn_Sub_Avail_Data b
									Where tmp.Title_Code = b.Title_Code 
										And (
											(b.Episode_From Between tmp.Episode_From And tmp.Episode_To)
											Or
											(b.Episode_To Between tmp.Episode_From And tmp.Episode_To)
											Or
											(tmp.Episode_From Between b.Episode_From And b.Episode_To)
											Or
											(tmp.Episode_To Between b.Episode_From And b.Episode_To)
										)
										And tmp.Country_Code = b.Country_Code 
										And tmp.Platform_Code = b.Platform_Code
										And b.Language_Code = tmp.Language_Code
									FOR XML PATH('')
								), 1, 1, ''
							)
			From #TMP_Acq_SUBTITLING tmp
			Inner Join #Syn_Sub_Avail_Data syn On syn.Title_Code = tmp.Title_Code And (
							(syn.Episode_From Between tmp.Episode_From And tmp.Episode_To)
							Or
							(syn.Episode_To Between tmp.Episode_From And tmp.Episode_To)
							Or
							(tmp.Episode_From Between syn.Episode_From And syn.Episode_To)
							Or
							(tmp.Episode_To Between syn.Episode_From And syn.Episode_To)
						) And 
					   syn.Platform_Code = tmp.Platform_Code And
					   syn.Country_Code = tmp.Country_Code And 
					   syn.Language_Code = tmp.Language_Code

			Print 'AD 23 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
			
			Print 'AD 23.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update tmp Set Is_Syn = 'Y',
						   Syn_Rights_Codes = STUFF
							(
								(
									Select Distinct ',' + CAST(Syn_Deal_Rights_Code as Varchar) From #Syn_Dub_Avail_Data b
									Where tmp.Title_Code = b.Title_Code 
										 And (
											(b.Episode_From Between tmp.Episode_From And tmp.Episode_To)
											Or
											(b.Episode_To Between tmp.Episode_From And tmp.Episode_To)
											Or
											(tmp.Episode_From Between b.Episode_From And b.Episode_To)
											Or
											(tmp.Episode_To Between b.Episode_From And b.Episode_To)
										)
										And tmp.Country_Code = b.Country_Code 
										And tmp.Platform_Code = b.Platform_Code
										And b.Language_Code = tmp.Language_Code
									FOR XML PATH('')
								), 1, 1, ''
							)
			From #TMP_Acq_DUBBING tmp
			Inner Join #Syn_Dub_Avail_Data syn On syn.Title_Code = tmp.Title_Code And (
							(syn.Episode_From Between tmp.Episode_From And tmp.Episode_To)
							Or
							(syn.Episode_To Between tmp.Episode_From And tmp.Episode_To)
							Or
							(tmp.Episode_From Between syn.Episode_From And syn.Episode_To)
							Or
							(tmp.Episode_To Between syn.Episode_From And syn.Episode_To)
						) And 
					   syn.Platform_Code = tmp.Platform_Code And
					   syn.Country_Code = tmp.Country_Code And 
					   syn.Language_Code = tmp.Language_Code

			Print 'AD 24 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
			
			Print 'AD 24.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Create Table #Temp_Batch
			(
				Syn_Rights_Codes varchar(2000),
				Rec_Type char(1)
			)

			Insert InTo #Temp_Batch
			Select Distinct Syn_Rights_Codes, 'T' From #TMP_ACQ_DETAILS Where Is_Syn = 'Y'
			
			Insert InTo #Temp_Batch
			Select Distinct Syn_Rights_Codes, 'S' From #TMP_Acq_SUBTITLING Where Is_Syn = 'Y'
			
			Insert InTo #Temp_Batch
			Select Distinct Syn_Rights_Codes, 'D' From #TMP_Acq_DUBBING Where Is_Syn = 'Y'

			Print 'AD 25 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Drop Table #Syn_Title_Avail_Data
			Drop Table #Syn_Sub_Avail_Data
			Drop Table #Syn_Dub_Avail_Data
			If(IsNull(@Actual_Right_End_Date, '31Dec9999') > GetDate()) ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED
			Begin ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED

				--Declare @Avial_Dates_Code Int = 0
				Select @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) From [dbo].[Avail_Dates] Where [Start_Date] = @Actual_Right_Start_Date And IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')

				if(@Avial_Dates_Code Is Null or @Avial_Dates_Code = 0)
				Begin
					Insert InTo [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
					Select @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
				End
				
				Truncate Table #Temp_Session_Raw
				Truncate Table #Temp_Session_Raw_Lang
				
				Print 'AD 25.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Insert InTo #Temp_Session_Raw_Lang(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Language_Codes, Rec_Type)
				Select Distinct Avail_Acq_Show_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Episode_From, Episode_To, Lang, Rec_Type From (
					Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, '' Lang, 'T' Rec_Type From #TMP_ACQ_DETAILS 
					Where Is_Theatrical_Right = 'N' And Is_Syn <> 'Y' AND @Is_Title_Language_Right = 'Y'
					Union
					Select Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					(
						(
							SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code From #TMP_Acq_SUBTITLING subIn
								Where subIn.Episode_From = sub.Episode_From And subIn.Episode_To = sub.Episode_To
									  And subIn.Is_Theatrical_Right = sub.Is_Theatrical_Right And subIn.Is_Syn = sub.Is_Syn
									  And subIn.Avail_Acq_Show_Code = sub.Avail_Acq_Show_Code
							) As a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'S' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Theatrical_Right, Is_Syn From #TMP_Acq_SUBTITLING Where Is_Theatrical_Right = 'N' And Is_Syn <> 'Y') sub
					Union
					Select Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					(
						(
							SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code From #TMP_Acq_DUBBING dubIn
								Where dubIn.Episode_From = dub.Episode_From And dubIn.Episode_To = dub.Episode_To
									  And dubIn.Is_Theatrical_Right = dub.Is_Theatrical_Right And dubIn.Is_Syn = dub.Is_Syn
									  And dubIn.Avail_Acq_Show_Code = dub.Avail_Acq_Show_Code
							) As a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'D' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Theatrical_Right, Is_Syn From #TMP_Acq_DUBBING Where Is_Theatrical_Right = 'N' And Is_Syn <> 'Y') dub
				) As a
				
				
				Insert InTo #Temp_Session_Raw(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Is_Same)
				Select Distinct Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 'N' From #Temp_Session_Raw_Lang
				
				Print 'AD 25.2 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				--Update #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' Where IsNull(Language_Codes, '') <> ''

				Insert InTo Avail_Languages(Language_Codes)
				Select Distinct Language_Codes  From #Temp_Session_Raw_Lang Where Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  Not In (
					Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  From Avail_Languages a
				) And Language_Codes <> ''

				Update temp set temp.Avail_Languages_Code  = al.Avail_Languages_Code From #Temp_Session_Raw_Lang temp 
				Inner Join Avail_Languages al On temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

				Print 'AD 25.3 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Update t1 Set t1.Is_Title_Lang = 1
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code And
				t1.Avail_Dates_Code = t2.Avail_Dates_Code And
				t1.Is_Exclusive = t2.Is_Exclusive And
				t1.Episode_From = t2.Episode_From And 
				t1.Episode_To = t2.Episode_To And
				t2.Rec_Type = 'T'

				Print 'AD 25.4 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code And
				t1.Avail_Dates_Code = t2.Avail_Dates_Code And
				t1.Is_Exclusive = t2.Is_Exclusive And
				t1.Episode_From = t2.Episode_From And 
				t1.Episode_To = t2.Episode_To And
				t2.Rec_Type = 'S'

				Print 'AD 25.5 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code And
				t1.Avail_Dates_Code = t2.Avail_Dates_Code And
				t1.Is_Exclusive = t2.Is_Exclusive And
				t1.Episode_From = t2.Episode_From And 
				t1.Episode_To = t2.Episode_To And
				t2.Rec_Type = 'D'

				Print 'AD 25.6 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Truncate Table #Temp_Session_Raw_Lang

				Select Distinct traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To 
				InTo #Temp_Session_Raw_Dist
				From #Temp_Session_Raw traw

				MERGE INTO Avail_Raw AS araw
				Using #Temp_Session_Raw_Dist AS traw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code And
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
				traw.Avail_Dates_Code = araw.Avail_Dates_Code And
				traw.Is_Exclusive = araw.Is_Exclusive And
				traw.Episode_From = araw.Episode_From And
				traw.Episode_To = araw.Episode_To
				WHEN NOT MATCHED THEN
					INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To, 0)
				;

				Drop Table #Temp_Session_Raw_Dist
				
				Print 'AD 25.7 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
				Inner Join Avail_Raw araw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code And
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
				traw.Avail_Dates_Code = araw.Avail_Dates_Code And
				traw.Is_Exclusive = araw.Is_Exclusive And
				traw.Episode_From = araw.Episode_From And
				traw.Episode_To = araw.Episode_To
			
				Print 'AD 25.8 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Insert InTo Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
				Select Avail_Acq_Show_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw
				Truncate Table #Temp_Session_Raw

			End

			Print 'adesh 321'

			Create Table #Syn_Rights(
				IntCode Int Identity(1, 1),
				Title_Code Int,
				Episode_From Int,
				Episode_To Int,
				Start_DT DateTime,
				End_DT DateTime,
				Is_Exclusive Char(1)
			)

			Create Table #Temp_Syndication_Main
			(
				IntCode Int Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive Char(1)
			)

			Create Table #Temp_Syndication_NE
			(
				IntCode Int Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive Char(1),
				Group_Code DateTime
			)

			Create Table #Temp_Syndication
			(
				IntCode Int Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive Char(1)
			)

			Create Table #Temp_Avail_Dates
			(
				IntCode Int Identity,
				Episode_From Int,
				Episode_To Int,
				AvailStartDate DateTime,
				AvailEndDate DateTime,
				Is_Exclusive Char(1),
				Avial_Dates_Code Int
			)

			Begin ------------- EXECUTION FOR SYNDICATION AVAILABLE RECORDS

				--Select * From #Temp_Batch
				
				Declare @Syn_Rights_Codes Varchar(2000) = ''
				Declare Cur_Batch Cursor For Select Distinct Syn_Rights_Codes From #Temp_Batch
				Open Cur_Batch
				Fetch Next From Cur_Batch InTo @Syn_Rights_Codes
				While (@@FETCH_STATUS = 0)
				Begin
					PRINT 'Testing 1'
					Truncate Table #Syn_Rights

					Insert InTo #Syn_Rights(Title_Code, Episode_From, Episode_To, Start_DT, End_DT, Is_Exclusive)
					Select Title_Code, Episode_From, Episode_To, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive
					From Syn_Deal_Rights sdr
					Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					Where sdr.Syn_Deal_Rights_Code In 
					(
						Select number From DBO.fn_Split_withdelemiter(@Syn_Rights_Codes, ',')
					) Order BY Actual_Right_Start_Date ASC

					Select * InTo #Temp_Episode From (
						Select Distinct Title_Code, Episode_From, Episode_To From #TMP_ACQ_DETAILS Where Syn_Rights_Codes = @Syn_Rights_Codes
						Union
						Select Distinct Title_Code, Episode_From, Episode_To From #TMP_Acq_SUBTITLING Where Syn_Rights_Codes = @Syn_Rights_Codes
						Union
						Select Distinct Title_Code, Episode_From, Episode_To From #TMP_Acq_DUBBING Where Syn_Rights_Codes = @Syn_Rights_Codes
					) As a

					--Select 'ad', * From #Syn_Rights

					Declare @Process_Title_Code Int = 0, @Episode_From Int = 0, @Episode_To Int = 0
					Declare Cur_Process_Title Cursor For Select Distinct Title_Code, Episode_From, Episode_To From #Temp_Episode
					Open Cur_Process_Title
					Fetch Next From Cur_Process_Title InTo @Process_Title_Code, @Episode_From, @Episode_To
					While (@@FETCH_STATUS = 0)
					Begin
	
						Create Table #Eps_Nos(
							Eps_Nos Int
						)

						Insert InTo #Eps_Nos Values(@Episode_From)

						Insert InTo #Eps_Nos
						Select Eps_No From (
							Select Case When Episode_From - 1 < @Episode_From Then 0 Else Episode_From - 1 End Eps_No From #Syn_Rights
							Where Title_Code = @Process_Title_Code And (
								  Episode_From Between @Episode_From And @Episode_To Or
								  Episode_To Between @Episode_From And @Episode_To
							)
							Union
							Select Case When Episode_To > @Episode_To Then 0 Else Episode_To End Eps_No From #Syn_Rights
							Where Title_Code = @Process_Title_Code And (
								  Episode_From Between @Episode_From And @Episode_To Or
								  Episode_To Between @Episode_From And @Episode_To
							)
						) As a Order By Eps_No

						Insert InTo #Eps_Nos Values(@Episode_To)
						
						Delete From #Eps_Nos Where Eps_Nos = 0

						Alter Table #Eps_Nos Add IntCode Int Identity(1,1)
						
						--Create Table #Eps_Nos(
						--	IntCode Int Identity(1, 1),
						--	Eps_Nos Int
						--)
						
						--Create Table #Temp_Eps_Nos(
						--	Eps_Nos Int
						--)

						--Insert InTo #Temp_Eps_Nos Values(@Episode_From)

						--Insert InTo #Temp_Eps_Nos
						--Select Eps_No From (
						--	Select Case When Episode_From - 1 < @Episode_From Then 0 Else Episode_From - 1 End Eps_No From #Syn_Rights
						--	Where Title_Code = @Process_Title_Code And (
						--		  Episode_From Between @Episode_From And @Episode_To Or
						--		  Episode_To Between @Episode_From And @Episode_To
						--	)
						--	Union
						--	Select Case When Episode_To > @Episode_To Then 0 Else Episode_To End Eps_No From #Syn_Rights
						--	Where Title_Code = @Process_Title_Code And (
						--		  Episode_From Between @Episode_From And @Episode_To Or
						--		  Episode_To Between @Episode_From And @Episode_To
						--	)
						--) As a Order By Eps_No

						--Insert InTo #Temp_Eps_Nos Values(@Episode_To)
						
						--Insert InTo #Eps_Nos(Eps_Nos)
						--Select Distinct Eps_Nos From #Temp_Eps_Nos Where Eps_Nos > 0 Order By Eps_Nos

						Declare @IntCode Int, @Cur_Episode_From Int, @Cur_Episode_To Int, @Cur_Start_DT DateTime, @Cur_End_DT DateTime,
								@Prev_Episode_From Int = @Episode_From

						--Declare Cur_Process_Eps Cursor For 
						--	Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
						--		Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
						--		LEAD(Eps_Nos) OVER (ORDER BY IntCode ASC) Eps_To,
						--		LAG(Eps_Nos) OVER (ORDER BY IntCode ASC) LagValue 
						--		From #Eps_Nos
						--	) As a Where IsNull(Eps_To, 0) > 0 And Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						--Select * From #Temp_Eps_Nos

						--Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
						--	Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
						--	LEAD(Eps_Nos) OVER (ORDER BY IntCode ASC) Eps_To,
						--	LAG(Eps_Nos) OVER (ORDER BY IntCode ASC) LagValue 
						--	From #Eps_Nos
						--) As a Where IsNull(Eps_To, 0) > 0 And Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						--Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
						--	Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
						--	(Select lead.Eps_Nos From #Eps_Nos lead Where lead.IntCode = (tmp.IntCode + 1)) Eps_To,
						--	(Select lag.Eps_Nos From #Eps_Nos lag Where lag.IntCode = (tmp.IntCode - 1)) LagValue
						--	From #Eps_Nos tmp
						--) As a Where IsNull(Eps_To, 0) > 0 And Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						--Select Case When t1.Eps_Nos = @Episode_From Then t1.Eps_Nos Else t1.Eps_Nos + 1 End Eps_From, t2.Eps_Nos Eps_To 
						--From #Eps_Nos t1 
						--Inner Join #Eps_Nos t2 On t1.IntCode = (t2.IntCode - 1)

						--Select Case When t1.Eps_Nos = @Episode_From Then t1.Eps_Nos Else t1.Eps_Nos + 1 End Eps_From, t2.Eps_Nos Eps_To 
						--From #Eps_Nos t1 
						--Left Join #Eps_Nos t2 On t1.IntCode = (t2.IntCode - 1)

						Declare Cur_Process_Eps Cursor For 
							Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
								Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
								(Select lead.Eps_Nos From #Eps_Nos lead Where lead.IntCode = (tmp.IntCode + 1)) Eps_To,
								(Select lag.Eps_Nos From #Eps_Nos lag Where lag.IntCode = (tmp.IntCode - 1)) LagValue
								From #Eps_Nos tmp
							) As a Where IsNull(Eps_To, 0) > 0 And Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						Open Cur_Process_Eps
						Fetch Next From Cur_Process_Eps InTo @Cur_Episode_From, @Cur_Episode_To
						While (@@FETCH_STATUS = 0)
						Begin

							Truncate Table #Temp_Syndication_Main
							Truncate Table #Temp_Syndication_NE
							Truncate Table #Temp_Syndication
							--Truncate Table #Temp_Avail_Dates

							Insert InTo #Temp_Syndication_Main
							Select Start_DT, End_DT, Is_Exclusive From #Syn_Rights
							Where Title_Code = @Process_Title_Code And @Cur_Episode_From Between Episode_From And Episode_To

							Insert InTo #Temp_Syndication_NE(Start_Date, End_Date, Is_Exclusive)
							Select Start_Date, End_Date, Is_Exclusive From #Temp_Syndication_Main Where Is_Exclusive = 'N' Order By Start_Date ASC
	
							Update t2 Set t2.Group_Code = (
								Select Min(t1.Start_Date) From #Temp_Syndication_NE t1 
								Where 
								t1.Start_Date Between t2.Start_Date And t2.End_Date Or
								t1.End_Date Between t2.Start_Date And t2.End_Date Or 
								t2.Start_Date Between t1.Start_Date And t1.End_Date Or
								t2.End_Date Between t1.Start_Date And t1.End_Date
							) From #Temp_Syndication_NE t2

							Insert InTo #Temp_Syndication
							Select * From (
								Select Start_Date, End_Date, Is_Exclusive From #Temp_Syndication_Main Where Is_Exclusive = 'Y'
								Union 
								Select Min(Start_Date) Start_Date, Max(End_Date) End_Date, 'N' From #Temp_Syndication_NE Group By Group_Code
							) As a Order By Start_Date ASC

							If((Select count(*) from #Temp_Syndication)=0)
							Begin
								Insert InTo #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive, Avial_Dates_Code)
								Select @Cur_Episode_From, @Cur_Episode_To, @Actual_Right_Start_Date, @Actual_Right_End_Date, 'Y', @Avial_Dates_Code
							End
							Else
							Begin
								Insert InTo #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive)
								Select @Cur_Episode_From, @Cur_Episode_To, *, 'Y' From (
									Select 
										Case When t2.Start_Date Is Null Then @Actual_Right_Start_Date Else DateAdd(d, 1, t2.End_Date) End AvailStartDate,
										DateAdd(d, -1, t1.Start_Date) AvailEndDate
									From #Temp_Syndication t1 Left Join #Temp_Syndication t2 On t1.IntCode = (t2.IntCode + 1) 
								) as a Where datediff(d, AvailStartDate, AvailEndDate) >= 0

								Declare @MaxEndDate DateTime = Null
								Select Top 1 @MaxEndDate = End_Date From #Temp_Syndication Order By [Start_Date] Desc
								If((datediff(d, @MaxEndDate, @Actual_Right_End_Date)  < 0 Or @MaxEndDate Is Not Null) And (@MaxEndDate <> isnull(@Actual_Right_End_Date,'')))
								Begin
									Insert InTo #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive)
									Select @Cur_Episode_From, @Cur_Episode_To, DATEADD(d, 1, @MaxEndDate), @Actual_Right_End_Date, 'Y'
								End
		
								Insert InTo #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate,Is_Exclusive)
								Select @Cur_Episode_From, @Cur_Episode_To, Start_Date, End_Date, 'N' From #Temp_Syndication Where Is_Exclusive = 'N'
							End

							Fetch Next From Cur_Process_Eps InTo @Cur_Episode_From, @Cur_Episode_To
						End
						Close Cur_Process_Eps
						Deallocate Cur_Process_Eps

						Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code From #Temp_Avail_Dates tad
						Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date And IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

						Insert InTo Avail_Dates
						Select Distinct AvailStartDate, AvailEndDate From #Temp_Avail_Dates Where IsNull(Avial_Dates_Code, 0) = 0
						AND (AvailEndDate is null Or AvailEndDate > GetDate())
						
						Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code From #Temp_Avail_Dates tad
						Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date And IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

						Delete From #Temp_Avail_Dates Where Avial_Dates_Code Is Null

						Truncate Table #Temp_Session_Raw
						Insert InTo #Temp_Session_Raw(Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To)
						Select @Acq_Deal_Code, @Acq_Deal_Rights_Code, a.Avial_Dates_Code, Case When a.Is_Exclusive = 'N' Then 0 Else 1 End, a.Episode_From, a.Episode_To 
						From #Temp_Avail_Dates a Where a.Avial_Dates_Code Not In (
							Select Avial_Dates_Code From #Temp_Session_Raw tsr Where a.Episode_From = tsr.Episode_From And a.Episode_To = tsr.Episode_To
						)

						Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
						Inner Join Avail_Raw araw On 
						traw.Acq_Deal_Code = araw.Acq_Deal_Code And
						traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
						traw.Avail_Dates_Code = araw.Avail_Dates_Code And
						traw.Is_Exclusive = araw.Is_Exclusive And
						traw.Episode_From = araw.Episode_From And
						traw.Episode_To = araw.Episode_To
						
						Insert InTo Avail_Raw 
						Select Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 0 From #Temp_Session_Raw 
						Where IsNull(Avail_Raw_Code, 0) = 0

						Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
						Inner Join Avail_Raw araw On 
						traw.Acq_Deal_Code = araw.Acq_Deal_Code And
						traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
						traw.Avail_Dates_Code = araw.Avail_Dates_Code And
						traw.Is_Exclusive = araw.Is_Exclusive And
						traw.Episode_From = araw.Episode_From And
						traw.Episode_To = araw.Episode_To And 
						IsNull(traw.Avail_Raw_Code, 0) = 0
						
						Create Table #Temp_Batch_N(
							Avail_Acq_Show_Code Numeric(38,0), 
							Avail_Raw_Code Numeric(38,0), 
							Is_Title_Language bit, 
							Sub_Language_Codes Varchar(Max), 
							Dub_Language_Codes Varchar(Max),
							Sub_Avail_Lang_Code Numeric(38, 0), 
							Dub_Avail_Lang_Code Numeric(38, 0)
						)

						--Select * From #Temp_Avail_Dates
						If Exists(Select Top 1 * From #Temp_Avail_Dates)
						Begin

							Declare @Is_Tit_Language bit = 0, @Sub_Lang Varchar(Max) = '', @Dub_Lung Varchar(Max) = ''

							If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes And Rec_Type = 'T')
							Begin

								If(@Is_Title_Language_Right = 'Y')
								Begin
									--------------- INTERNATIONAL
			
									--Insert InTo Avail_Acq_Show_Det(Avail_Acq_Show_Code, Avail_Raw_Code)
									Insert InTo #Temp_Batch_N(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language)
									Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, 1
									From #TMP_ACQ_DETAILS t 
									Inner Join #Temp_Session_Raw as a On 1 = 1
									Where t.Is_Syn = 'Y' And Is_Theatrical_Right = 'N' And t.Syn_Rights_Codes = @Syn_Rights_Codes 
										  And t.Title_Code = @Process_Title_Code And t.Episode_From = @Episode_From And t.Episode_To = @Episode_To
										  --And t.Avail_Acq_Show_Code = 1010659
				--return
									Print 'AD 32 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

									--------------- End
								End
							End
					
							If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes And Rec_Type = 'S')
							Begin
								--------------- INTERNATIONAL

								--Insert InTo Avail_Acq_Show_Lang(Avail_Acq_Show_Code, Avail_Raw_Code, Language_Code)
								Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									   t.Language_Code InTo #Temp_Sub_New
								From #TMP_Acq_SUBTITLING t
								Inner Join #Temp_Session_Raw as a On 1 = 1
								Where t.Is_Syn = 'Y' And t.Is_Theatrical_Right = 'N' And t.Syn_Rights_Codes = @Syn_Rights_Codes 
									  And t.Title_Code = @Process_Title_Code And t.Episode_From = @Episode_From And t.Episode_To = @Episode_To

								MERGE INTO #Temp_Batch_N AS tb
								Using (
									Select *, 
									STUFF(
										(
											SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
												SELECT Distinct Language_Code From #Temp_Sub_New subIn
												Where subIn.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code And subIn.Avail_Raw_Code = a.Avail_Raw_Code
											) As a
											FOR XML PATH('')
										), 1, 1, ''
									) As Sub_Lang
									From(
										Select Distinct tsn.Avail_Acq_Show_Code, tsn.Avail_Raw_Code From #Temp_Sub_New tsn
									) As a
								) As temp On tb.Avail_Acq_Show_Code = temp.Avail_Acq_Show_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code
								When MATCHED THEN
									UPDATE SET tb.Sub_Language_Codes = temp.Sub_Lang
								When NOT MATCHED THEN
									INSERT VALUES (temp.Avail_Acq_Show_Code, temp.Avail_Raw_Code, 0, temp.Sub_Lang, Null, Null, Null)
								;

								Drop Table #Temp_Sub_New

								Print 'AD 34 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

								--------------- END
						
							End
					
							If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes And Rec_Type = 'D')
							Begin
						
								-------------- INTERNATIONAL

								--Insert InTo Avail_Acq_Show_Dub(Avail_Acq_Show_Code, Avail_Raw_Code, Language_Code)
								--Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, t.Language_Code
								--From #TMP_Acq_DUBBING t 
								--Inner Join #Temp_Session_Raw as a On 1 = 1
								--Where t.Is_Syn = 'Y' And Is_Theatrical_Right = 'N' And t.Syn_Rights_Codes = @Syn_Rights_Codes 
								--	  And t.Title_Code = @Process_Title_Code And t.Episode_From = @Episode_From And t.Episode_To = @Episode_To

								Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									   t.Language_Code InTo #Temp_Dub_New
								From #TMP_Acq_DUBBING t
								Inner Join #Temp_Session_Raw as a On 1 = 1
								Where t.Is_Syn = 'Y' And t.Is_Theatrical_Right = 'N' And t.Syn_Rights_Codes = @Syn_Rights_Codes 
									  And t.Title_Code = @Process_Title_Code And t.Episode_From = @Episode_From And t.Episode_To = @Episode_To

								MERGE INTO #Temp_Batch_N AS tb
								Using (
									Select *, 
									STUFF(
										(
											SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
												SELECT Distinct Language_Code From #Temp_Dub_New subIn
												Where --subIn.Episode_From = a.Episode_From And subIn.Episode_To = a.Episode_To AND
												subIn.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code And subIn.Avail_Raw_Code = a.Avail_Raw_Code
											) As a
											FOR XML PATH('')
										), 1, 1, ''
									) As Dub_Lang
									From(
										Select Distinct tsn.Avail_Acq_Show_Code, tsn.Avail_Raw_Code From #Temp_Dub_New tsn
									) As a
								) As temp On tb.Avail_Acq_Show_Code = temp.Avail_Acq_Show_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code
								When MATCHED THEN
									UPDATE SET tb.Dub_Language_Codes = temp.Dub_Lang
								When NOT MATCHED THEN
									INSERT VALUES (temp.Avail_Acq_Show_Code, temp.Avail_Raw_Code, 0, Null, temp.Dub_Lang, Null, Null)
								;

								Drop Table #Temp_Dub_New
								Print 'AD 36 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

								-------------- End
		
							End

							Update #Temp_Batch_N Set Sub_Language_Codes = ',' + Sub_Language_Codes + ',' Where IsNull(Sub_Language_Codes, '') <> ''
							Update #Temp_Batch_N Set Dub_Language_Codes = ',' + Dub_Language_Codes + ',' Where IsNull(Dub_Language_Codes, '') <> ''

							Insert InTo Avail_Languages(Language_Codes)
							Select Distinct Sub_Language_Codes From #Temp_Batch_N Where Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS Not In (
								Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS From Avail_Languages a
							) And IsNull(Sub_Language_Codes, '') <> ''

							Update temp set temp.Sub_Avail_Lang_Code = al.Avail_Languages_Code From #Temp_Batch_N temp 
							Inner Join Avail_Languages al On temp.Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

							
							Insert InTo Avail_Languages(Language_Codes)
							Select Distinct Dub_Language_Codes From #Temp_Batch_N Where Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  Not In (
								Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  From Avail_Languages a
							) And IsNull(Dub_Language_Codes, '') <> ''

							Update temp set temp.Dub_Avail_Lang_Code = al.Avail_Languages_Code From #Temp_Batch_N temp 
							Inner Join Avail_Languages al On temp.Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

							--Select * From #Temp_Batch_N

							Insert InTo Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
							Select Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Avail_Lang_Code, Dub_Avail_Lang_Code From #Temp_Batch_N

						End
						Print 'ad142'
						Drop Table #Temp_Batch_N
						Drop Table #Eps_Nos
						--Drop Table #Temp_Eps_Nos
						Print 'ad143'
						Truncate Table #Temp_Syndication
						Truncate Table #Temp_Syndication_Main
						Truncate Table #Temp_Syndication_NE
						Truncate Table #Temp_Avail_Dates

						Fetch Next From Cur_Process_Title InTo @Process_Title_Code, @Episode_From, @Episode_To
					End
					Close Cur_Process_Title
					Deallocate Cur_Process_Title

					Drop Table #Temp_Episode

					Fetch Next From Cur_Batch InTo @Syn_Rights_Codes
				End
				Close Cur_Batch
				Deallocate Cur_Batch

			End

			Print 'AD 38 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
			
			Drop Table #Temp_Syndication
			Drop Table #Temp_Syndication_Main
			Drop Table #Temp_Syndication_NE
			Drop Table #Temp_Avail_Dates
			Drop Table #Temp_Batch
			Drop Table #TMP_ACQ_DETAILS
			Drop Table #TMP_Acq_SUBTITLING
			Drop Table #TMP_Acq_DUBBING

			Drop Table #Syn_Rights
			--Drop Table #Eps_Nos

		End
		
		Truncate Table #Temp_Session_Raw
		Truncate Table #Temp_Session_Raw_Lang

		Fetch From CUR_Rights InTo @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	End
	Close CUR_Rights
	Deallocate CUR_Rights

	Drop Table #Temp_Session_Raw
	Drop Table #Temp_Session_Raw_Lang
	Drop Table #Process_Rights

	If(@Record_Type = 'S')
	Begin

		Delete From Avail_Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @Record_Code

		Insert InTo Avail_Syn_Acq_Mapping(Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
		Select Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
		From Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @Record_Code

	End

End




