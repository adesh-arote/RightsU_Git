CREATE PROCEDURE [dbo].[Usp_Avail_Cache]
	@Record_Code INT = 264,
	@Record_Type Char(1) = 'A'
AS
Begin
-- =============================================
-- Author:		Reshma Kunjal / ADESH AROTE
-- Create DATE: 07-April-2015
-- Description:	Cache Acquisition on deal approval for availability
-- Last Updated By : Reshma Kunjal (From Print 'AD 1 ') -- 02-May-2016
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
	
	Create Table #Temp_Session_Raw(
		Avail_Acq_Code numeric(38, 0),
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
		Is_Theatrical_Right Char(1)
	)
	
	Create Table #Temp_Session_Raw_Lang(
		Avail_Acq_Code numeric(38, 0),
		Avail_Raw_Code numeric(38, 0),
		Acq_Deal_Code int,
		Acq_Deal_Rights_Code int,
		Avail_Dates_Code numeric(38, 0),
		Is_Exclusive bit,
		Episode_From int,
		Episode_To int,
		Language_Codes Varchar(Max),
		Rec_Type Char(1),
		Avail_Languages_Code numeric(38, 0),
		Is_Theatrical_Right Char(1)
	)
	
	Create Table #Temp_Batch_N(
		Avail_Acq_Code Numeric(38,0), 
		Avail_Raw_Code Numeric(38,0), 
		Is_Title_Language bit, 
		Sub_Language_Codes Varchar(Max), 
		Dub_Language_Codes Varchar(Max),
		Sub_Avail_Lang_Code Numeric(38, 0), 
		Dub_Avail_Lang_Code Numeric(38, 0),
		Is_Theatrical_Right char(1)
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
			AND adr.Acq_Deal_Code = @Record_Code
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
	
	Delete From Avail_Acq_Details Where Avail_Raw_Code In (
		Select Avail_Raw_Code From Avail_Raw Where Acq_Deal_Rights_Code In(
			Select Acq_Deal_Rights_Code From #Process_Rights
		)
	)

	Delete From Avail_Acq_Theatrical_Details Where Avail_Raw_Code In (
		Select Avail_Raw_Code From Avail_Raw Where Acq_Deal_Rights_Code In (
			Select Acq_Deal_Rights_Code From #Process_Rights
		)
	)

	Declare CUR_Rights Cursor For
		Select Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
			   Is_Exclusive, Is_Theatrical_Right
		From #Process_Rights --And Acq_Deal_Rights_Code = 778
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

		--Insert InTo #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Is_Theatrical_Right)
		Select distinct ADR.Acq_Deal_Rights_Code, adrt.Title_Code, adrp.Platform_Code, con.Country_Code, @Is_Theatrical_Right Is_Theatrical_Right, 0 Avail_Acq_Code, 'N' Is_Syn
		InTo #TMP_ACQ_DETAILS
		From (
			Select @Acq_Deal_Rights_Code Acq_Deal_Rights_Code
		) As adr
		INNER JOIN Acq_Deal_Rights_Title adrt WITH (INDEX(IX_Acq_Deal_Rights_Title)) on adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Platform adrp WITH (INDEX(IX_Acq_Deal_Rights_Platform)) on adrp.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN #Acq_Contry con On 1 = 1

		Alter Table #TMP_ACQ_DETAILS Add Syn_Rights_Codes Varchar(2000)

		Print 'AD 1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Drop Table #Acq_Contry
			
		If(@Is_Theatrical_Right = 'N')
		Begin
			
			--Below query Commented By Reshma
			--Encountered Error : Attempt to fetch logical page (1:340272) in database 2 failed. It belongs to allocation unit 3026423061692153856 not to 3026418977488633856.
						
			--Insert InTo #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Is_Theatrical_Right, Avail_Acq_Code, Is_Syn)
			--Select adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, c.Country_Code, 'Y', 0, 'N'
			--From #TMP_ACQ_DETAILS adr
			--Inner Join Country c On adr.Country_Code = c.Parent_Country_Code And adr.Country_Code = @India_Code
			--And Platform_Code = @Theatrical_Code
			
			--Below query Added By Reshma till Print 'AD 2.1 '
			SELECT adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, c.Country_Code, 'Y' as Is_Theatrical_Right, 0 as Avail_Acq_Code, 'N' as Is_Syn
			INTO #TMP_ACQ_DETAILS_V1
			From #TMP_ACQ_DETAILS adr
			Inner Join Country c On adr.Country_Code = c.Parent_Country_Code And adr.Country_Code = @India_Code
			And Platform_Code = @Theatrical_Code

			Insert InTo #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Is_Theatrical_Right, Avail_Acq_Code, Is_Syn)
			Select adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, adr.Country_Code, Is_Theatrical_Right, Avail_Acq_Code, Is_Syn
			From #TMP_ACQ_DETAILS_V1 adr

			DROP TABLE #TMP_ACQ_DETAILS_V1

			Print 'AD 2.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Delete From #TMP_ACQ_DETAILS Where Platform_Code = @Theatrical_Code And Country_Code = @India_Code

			Print 'AD 2.2 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
		End

		CREATE NONCLUSTERED INDEX IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code ON #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code)

		--------- CHECK INTERNATIONAL AVAILABILITY

		Update t Set t.Avail_Acq_Code = a.Avail_Acq_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq a On t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code And t.Is_Theatrical_Right = 'N'

		Print 'AD 3 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Insert InTo Avail_Acq(Title_Code, Platform_Code, Country_Code)
		Select Title_Code, Platform_Code, Country_Code From #TMP_ACQ_DETAILS Where IsNull(Avail_Acq_Code, 0) = 0 And Is_Theatrical_Right = 'N'

		Print 'AD 4 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Update t Set t.Avail_Acq_Code = a.Avail_Acq_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq a On t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Code, 0) = 0 And t.Is_Theatrical_Right = 'N'

		Print 'AD 5 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		---------- End

		--------- CHECK THEATRICAL AVAILABILITY

		Update t Set t.Avail_Acq_Code = a.Avail_Acq_Theatrical_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Theatrical a On t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code And t.Is_Theatrical_Right = 'Y'

		Print 'AD 6 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Insert InTo Avail_Acq_Theatrical(Title_Code, Platform_Code, Country_Code)
		Select Title_Code, Platform_Code, Country_Code From #TMP_ACQ_DETAILS Where IsNull(Avail_Acq_Code, 0) = 0 And Is_Theatrical_Right = 'Y'

		Print 'AD 7 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Update t Set t.Avail_Acq_Code = a.Avail_Acq_Theatrical_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Theatrical a On t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Code, 0) = 0 And t.Is_Theatrical_Right = 'Y'

		Print 'AD 8 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		----------- End

		Select Distinct CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code End Language_Code, Acq_Deal_Rights_Code InTo #Acq_Sub
		FROM(
			Select Distinct Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Subtitling
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		Print 'AD 9 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Select ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Code, Is_Theatrical_Right, 'N' Is_Syn
		InTo #TMP_Acq_SUBTITLING
		From #TMP_ACQ_DETAILS ADR WITH (INDEX(IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code)) 
		INNER JOIN #Acq_Sub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And ADR.Is_Theatrical_Right = 'N'
		
		Alter Table #TMP_Acq_SUBTITLING Add Syn_Rights_Codes Varchar(2000)

		Print 'AD 10 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Drop Table #Acq_Sub
		
		Select Distinct CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code End Language_Code, Acq_Deal_Rights_Code InTo #Acq_Dub
		FROM(
			Select Distinct Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Dubbing
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		Print 'AD 12 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Select ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Code, Is_Theatrical_Right, 'N' Is_Syn
		InTo #TMP_Acq_DUBBING
		FROM #TMP_ACQ_DETAILS ADR WITH (INDEX(IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code)) 
		INNER JOIN #Acq_Dub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And ADR.Is_Theatrical_Right = 'N'
		
		Alter Table #TMP_Acq_DUBBING Add Syn_Rights_Codes Varchar(2000)

		Print 'AD 13 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		--Select Getdate()

		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Title_Code ON #TMP_Acq_DUBBING(Title_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Platform_Code ON #TMP_Acq_DUBBING(Platform_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Country_Code ON #TMP_Acq_DUBBING(Country_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Language_Code ON #TMP_Acq_DUBBING(Language_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_DUB_Combine ON #TMP_Acq_DUBBING(Title_Code, Platform_Code, Country_Code, Language_Code)

		Print 'AD 14 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

		Drop Table #Acq_Dub

		Declare @Is_Exclusive_Bit bit = Case When @Is_Exclusive = 'N' Then 0 Else 1 End, @Avial_Dates_Code Int = 0

		If(@Is_Exclusive = 'N')------------ CATCHE THE RECORDS WHICH ARE ACQUIRED EXCLUSIVE NO
		Begin

			Select @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) From [dbo].[Avail_Dates] Where [Start_Date] = @Actual_Right_Start_Date And IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
			if(@Avial_Dates_Code Is Null or @Avial_Dates_Code = 0)
			Begin
				Insert InTo [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
				Select @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
			End

			Truncate Table #Temp_Session_Raw
			Truncate Table #Temp_Session_Raw_Lang

			Insert InTo #Temp_Session_Raw_Lang(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Language_Codes, Rec_Type, Is_Theatrical_Right)
			Select Distinct Avail_Acq_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Lang, Rec_Type, Is_Theatrical_Right From (
				Select Distinct Avail_Acq_Code, '' Lang, 'T' Rec_Type, Is_Theatrical_Right From #TMP_ACQ_DETAILS 
				Where @Is_Title_Language_Right = 'Y'
				Union
				Select Avail_Acq_Code, ',' + STUFF
				(
					(
						SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT Distinct Language_Code From #TMP_Acq_SUBTITLING subIn
							Where subIn.Avail_Acq_Code = sub.Avail_Acq_Code
								  And subIn.Is_Theatrical_Right = sub.Is_Theatrical_Right
						) As a
						FOR XML PATH('')
					), 1, 1, ''
				) + ','
				, 'S', Is_Theatrical_Right From (Select Distinct Avail_Acq_Code, Is_Theatrical_Right From #TMP_Acq_SUBTITLING) sub
				Union
				Select Avail_Acq_Code, ',' + STUFF
				(
					(
						SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT Distinct Language_Code From #TMP_Acq_DUBBING dubIn
							Where dubIn.Avail_Acq_Code = dub.Avail_Acq_Code
								  And dubIn.Is_Theatrical_Right = dub.Is_Theatrical_Right
						) As a
						FOR XML PATH('')
					), 1, 1, ''
				) + ','
				, 'D', Is_Theatrical_Right From (Select Distinct Avail_Acq_Code, Is_Theatrical_Right From #TMP_Acq_DUBBING) dub
			) As a
			
			Print 'AD 14.2 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Insert InTo #Temp_Session_Raw(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right)
			Select Distinct Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right From #Temp_Session_Raw_Lang
			
			Insert InTo Avail_Languages(Language_Codes)
			Select Distinct Language_Codes From #Temp_Session_Raw_Lang Where Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  Not In (
				Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  From Avail_Languages a
			) And Language_Codes <> ''

			Update temp set temp.Avail_Languages_Code = al.Avail_Languages_Code From #Temp_Session_Raw_Lang temp 
			Inner Join Avail_Languages al On temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  
			
			Print 'AD 14.3 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update t1 Set t1.Is_Title_Lang = 1
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Code = t2.Avail_Acq_Code And
			t1.Avail_Dates_Code = t2.Avail_Dates_Code And
			t1.Is_Exclusive = t2.Is_Exclusive And
			t1.Is_Theatrical_Right = t2.Is_Theatrical_Right And
			t2.Rec_Type = 'T'

			Print 'AD 14.4 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Code = t2.Avail_Acq_Code And
			t1.Avail_Dates_Code = t2.Avail_Dates_Code And
			t1.Is_Exclusive = t2.Is_Exclusive And
			t1.Is_Theatrical_Right = t2.Is_Theatrical_Right And
			t2.Rec_Type = 'S'

			Print 'AD 14.5 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Code = t2.Avail_Acq_Code And
			t1.Avail_Dates_Code = t2.Avail_Dates_Code And
			t1.Is_Exclusive = t2.Is_Exclusive And
			t1.Is_Theatrical_Right = t2.Is_Theatrical_Right And
			t2.Rec_Type = 'D'

			Print 'AD 14.6 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			Truncate Table #Temp_Session_Raw_Lang

			Select Distinct traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive
			InTo #Temp_Session_Raw_Distinct
			From #Temp_Session_Raw traw

			MERGE INTO Avail_Raw AS araw
			Using #Temp_Session_Raw_Distinct AS traw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code And
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
			traw.Avail_Dates_Code = araw.Avail_Dates_Code And
			traw.Is_Exclusive = araw.Is_Exclusive
			WHEN NOT MATCHED THEN
				INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive)
			;

			Drop Table #Temp_Session_Raw_Distinct
				
			Print 'AD 14.7 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
			Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
			Inner Join Avail_Raw araw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code And
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
			traw.Avail_Dates_Code = araw.Avail_Dates_Code And
			traw.Is_Exclusive = araw.Is_Exclusive
			
			Print 'AD 14.8 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
	
			Insert InTo Avail_Acq_Details(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			Select Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw Where Is_Theatrical_Right = 'N'
			
			Print 'AD 14.9 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
	
			Insert InTo Avail_Acq_Theatrical_Details(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			Select Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw Where Is_Theatrical_Right = 'Y'
			
			Print 'AD 14.10 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
	
			Truncate Table #Temp_Session_Raw

		End
		Else
		Begin
	
			Create table #Syn_Title_Avail_Data
			(
				Syn_Deal_Rights_Code Int,
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT
			)

			Create table #Syn_Sub_Avail_Data
			(
				Syn_Deal_Rights_Code Int,
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code Int
			)
				
			Create table #Syn_Dub_Avail_Data
			(
				Syn_Deal_Rights_Code Int,
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code Int
			)
			
			Create table #Syn_Title_Avail_Data_SDRC
			(
				Syn_Deal_Rights_Codes Varchar(2000),
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT
			)

			Create table #Syn_Sub_Avail_Data_SDRC
			(
				Syn_Deal_Rights_Codes Varchar(2000),
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code Int
			)
				
			Create table #Syn_Dub_Avail_Data_SDRC
			(
				Syn_Deal_Rights_Codes Varchar(2000),
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code Int
			)

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
								sdr.Actual_Right_End_Date, sdrt.Title_Code, sdrp.Platform_Code, synter.Country_Code 
				InTo #Syn_Data
				From Syn_Deal_Rights sdr 
				Inner Join Syn_Acq_Mapping sam On sam.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code And Deal_Rights_Code = @Acq_Deal_Rights_Code And sdr.Actual_Right_Start_Date Is Not Null And ISNULL(sdr.Actual_Right_End_Date,'31-DEC-9999') >= Cast(GetDate() As Date)
				Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_Platform sdrp On sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				Inner Join #Syn_Territory synter On sdr.Syn_Deal_Rights_Code = synter.Syn_Deal_Rights_Code
				Inner Join #TMP_ACQ_DETAILS adr On sdrt.Title_Code = adr.Title_Code And adr.Platform_Code = sdrp.Platform_Code And adr.Country_Code = synter.Country_Code
				--Where Actual_Right_Start_Date Is Not Null --And Is_Title_Language_Right = 'Y' --And Is_Theatrical_Right = 'N'
				--And sdrt.Title_Code In (
				--	Select adr.Title_Code From #TMP_ACQ_DETAILS adr Where adr.Platform_Code = sdrp.Platform_Code And adr.Country_Code = synter.Country_Code
				--)

				Print 'AD 18 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Drop Table #Syn_Territory

				INSERT INTO #Syn_Title_Avail_Data(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code)
				Select Distinct Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code 
				From #Syn_Data Where Is_Title_Language_Right = 'Y'
		
				Print 'AD 19 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Insert InTo #Syn_Sub_Avail_Data(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Language_Code)
				Select Distinct syn.Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, sdrs.Language_Code
				From #Syn_Data syn
				Inner Join #Syn_Subtitling sdrs On syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code

				Drop Table #Syn_Subtitling

				Insert InTo #Syn_Dub_Avail_Data(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Language_Code)
				Select Distinct syn.Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, sdrd.Language_Code
				From #Syn_Data syn
				Inner Join #Syn_Dubbing sdrd On syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code

				Print 'AD 21 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Drop Table #Syn_Dubbing
				Drop Table #Syn_Data

			End ------------ End
		
			Insert InTo #Syn_Title_Avail_Data_SDRC(Syn_Deal_Rights_Codes, Title_Code, Platform_Code, Country_Code)
			Select STUFF
			(
				(
					Select Distinct ',' + CAST(Syn_Deal_Rights_Code as Varchar) From #Syn_Title_Avail_Data b
					Where tmp.Title_Code = b.Title_Code 
						And tmp.Country_Code = b.Country_Code 
						And tmp.Platform_Code = b.Platform_Code
					FOR XML PATH('')
				), 1, 1, ''
			) SCodes, Title_Code, Platform_Code, Country_Code 
			From (
				Select Distinct Title_Code, Platform_Code, Country_Code From #Syn_Title_Avail_Data
			) As tmp
			
			Insert InTo #Syn_Sub_Avail_Data_SDRC(Syn_Deal_Rights_Codes, Title_Code, Platform_Code, Country_Code, Language_Code)
			Select STUFF
			(
				(
					Select Distinct ',' + CAST(Syn_Deal_Rights_Code as Varchar) From #Syn_Sub_Avail_Data b
					Where tmp.Title_Code = b.Title_Code 
						And tmp.Country_Code = b.Country_Code 
						And tmp.Platform_Code = b.Platform_Code
						And b.Language_Code = tmp.Language_Code
					FOR XML PATH('')
				), 1, 1, ''
			) SCodes, Title_Code, Platform_Code, Country_Code, Language_Code
			From (
				Select Distinct Title_Code, Platform_Code, Country_Code, Language_Code From #Syn_Sub_Avail_Data
			) As tmp
			
			Insert InTo #Syn_Dub_Avail_Data_SDRC(Syn_Deal_Rights_Codes, Title_Code, Platform_Code, Country_Code, Language_Code)
			Select STUFF
			(
				(
					Select Distinct ',' + CAST(Syn_Deal_Rights_Code as Varchar) From #Syn_Dub_Avail_Data b
					Where tmp.Title_Code = b.Title_Code 
						And tmp.Country_Code = b.Country_Code 
						And tmp.Platform_Code = b.Platform_Code
						And b.Language_Code = tmp.Language_Code
					FOR XML PATH('')
				), 1, 1, ''
			) SCodes, Title_Code, Platform_Code, Country_Code, Language_Code
			From (
				Select Distinct Title_Code, Platform_Code, Country_Code, Language_Code From #Syn_Dub_Avail_Data
			) As tmp
			
			Drop Table #Syn_Title_Avail_Data
			Drop Table #Syn_Sub_Avail_Data
			Drop Table #Syn_Dub_Avail_Data

			Update tmp Set Is_Syn = 'Y', Syn_Rights_Codes = Syn_Deal_Rights_Codes
			From #TMP_ACQ_DETAILS tmp
			Inner Join #Syn_Title_Avail_Data_SDRC syn On syn.Title_Code = tmp.Title_Code And 
					   syn.Platform_Code = tmp.Platform_Code And
					   syn.Country_Code = tmp.Country_Code
					   --And syn.Is_Title_Language_Right = 'Y'
					   
			Print 'AD 22 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

			--Select * From #Syn_Sub_Avail_Data_SDRC

			Update tmp Set Is_Syn = 'Y', Syn_Rights_Codes = Syn_Deal_Rights_Codes
			From #TMP_Acq_SUBTITLING tmp
			Inner Join #Syn_Sub_Avail_Data_SDRC syn On syn.Title_Code = tmp.Title_Code And 
					   syn.Platform_Code = tmp.Platform_Code And
					   syn.Country_Code = tmp.Country_Code And 
					   syn.Language_Code = tmp.Language_Code

			Print 'AD 23 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
			
			Update tmp Set Is_Syn = 'Y', Syn_Rights_Codes = Syn_Deal_Rights_Codes
			From #TMP_Acq_DUBBING tmp
			Inner Join #Syn_Dub_Avail_Data_SDRC syn On syn.Title_Code = tmp.Title_Code And 
					   syn.Platform_Code = tmp.Platform_Code And
					   syn.Country_Code = tmp.Country_Code And 
					   syn.Language_Code = tmp.Language_Code

			Drop Table #Syn_Title_Avail_Data_SDRC
			Drop Table #Syn_Sub_Avail_Data_SDRC
			Drop Table #Syn_Dub_Avail_Data_SDRC

			Print 'AD 24 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
			
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

			If(IsNull(@Actual_Right_End_Date, '31Dec9999') > GetDate()) ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED
			Begin
			
				Select @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) From [dbo].[Avail_Dates] Where [Start_Date] = @Actual_Right_Start_Date And IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
				if(@Avial_Dates_Code Is Null or @Avial_Dates_Code = 0)
				Begin
					Insert InTo [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
					Select @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
				End

				Truncate Table #Temp_Session_Raw
				Truncate Table #Temp_Session_Raw_Lang
				
				Print 'AD 25.1 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Insert InTo #Temp_Session_Raw_Lang(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Language_Codes, Rec_Type, Is_Theatrical_Right)
				Select Distinct Avail_Acq_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Lang, Rec_Type, Is_Theatrical_Right From (
					Select Distinct Avail_Acq_Code, '' Lang, 'T' Rec_Type, Is_Theatrical_Right From #TMP_ACQ_DETAILS 
					Where @Is_Title_Language_Right = 'Y' And Is_Syn <> 'Y'
					Union
					Select Avail_Acq_Code, ',' + STUFF
					(
						(
							SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code From #TMP_Acq_SUBTITLING subIn
								Where subIn.Avail_Acq_Code = sub.Avail_Acq_Code
									  And subIn.Is_Theatrical_Right = sub.Is_Theatrical_Right
									  And subIn.Is_Syn <> 'Y'
							) As a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'S', Is_Theatrical_Right From (Select Distinct Avail_Acq_Code, Is_Theatrical_Right From #TMP_Acq_SUBTITLING Where Is_Syn <> 'Y') sub
					Union
					Select Avail_Acq_Code, ',' + STUFF
					(
						(
							SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code From #TMP_Acq_DUBBING dubIn
								Where dubIn.Avail_Acq_Code = dub.Avail_Acq_Code
									  And dubIn.Is_Theatrical_Right = dub.Is_Theatrical_Right
									  And dubIn.Is_Syn <> 'Y'
							) As a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'D', Is_Theatrical_Right From (Select Distinct Avail_Acq_Code, Is_Theatrical_Right From #TMP_Acq_DUBBING Where Is_Syn <> 'Y') dub
				) As a
				
				Insert InTo #Temp_Session_Raw(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right)
				Select Distinct Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right From #Temp_Session_Raw_Lang
			
				Print 'AD 25.2 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				--Update #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' Where IsNull(Language_Codes, '') <> ''
				
				Insert InTo Avail_Languages(Language_Codes)
				Select Distinct Language_Codes From #Temp_Session_Raw_Lang Where Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS Not In (
					Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS From Avail_Languages a
				) And Language_Codes <> ''

				print 'ad 25.2.1'

				Update temp set temp.Avail_Languages_Code  = al.Avail_Languages_Code From #Temp_Session_Raw_Lang temp 
				Inner Join Avail_Languages al On temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS= al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

				Print 'AD 25.3 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Update t1 Set t1.Is_Title_Lang = 1
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Code = t2.Avail_Acq_Code And
				t1.Avail_Dates_Code = t2.Avail_Dates_Code And
				t1.Is_Exclusive = t2.Is_Exclusive And
				t1.Is_Theatrical_Right = t2.Is_Theatrical_Right And
				t2.Rec_Type = 'T'

				Print 'AD 25.4 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Code = t2.Avail_Acq_Code And
				t1.Avail_Dates_Code = t2.Avail_Dates_Code And
				t1.Is_Exclusive = t2.Is_Exclusive And
				t1.Is_Theatrical_Right = t2.Is_Theatrical_Right And
				t2.Rec_Type = 'S'


				Print 'AD 25.5 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Code = t2.Avail_Acq_Code And
				t1.Avail_Dates_Code = t2.Avail_Dates_Code And
				t1.Is_Exclusive = t2.Is_Exclusive And
				t1.Is_Theatrical_Right = t2.Is_Theatrical_Right And
				t2.Rec_Type = 'D'

				Print 'AD 25.6 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

				Truncate Table #Temp_Session_Raw_Lang
				
				Delete From #Temp_Session_Raw Where Avail_Dates_Code = 0

				Select Distinct traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive
				InTo #Temp_Session_Raw_Dist
				From #Temp_Session_Raw traw

				MERGE INTO Avail_Raw AS araw
				Using #Temp_Session_Raw_Dist AS traw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code And
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
				traw.Avail_Dates_Code = araw.Avail_Dates_Code And
				traw.Is_Exclusive = araw.Is_Exclusive
				WHEN NOT MATCHED THEN
					INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive)
				;

				Drop Table #Temp_Session_Raw_Dist
				
				Print 'AD 25.7 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
				Inner Join Avail_Raw araw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code And
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
				traw.Avail_Dates_Code = araw.Avail_Dates_Code And
				traw.Is_Exclusive = araw.Is_Exclusive
			
				Print 'AD 25.8 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Insert InTo Avail_Acq_Details(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
				Select Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw Where Is_Theatrical_Right = 'N'
			

				Print 'AD 25.9 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
				
				Insert InTo Avail_Acq_Theatrical_Details(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
				Select Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw Where Is_Theatrical_Right = 'Y'
			
				Print 'AD 26 ' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
	
				--Select * From #Temp_Session_Raw Where Avail_Acq_Code = 954581

				Truncate Table #Temp_Session_Raw
				--return
			End

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
				AvailStartDate DateTime,
				AvailEndDate DateTime,
				Is_Exclusive Char(1),
				Avial_Dates_Code Int
			)

			Begin ------------- EXECUTION FOR SYNDICATION AVAILABLE RECORDS

				Declare @Syn_Rights_Codes Varchar(2000) = ''
				Declare Cur_Batch Cursor For Select Distinct Syn_Rights_Codes From #Temp_Batch
				Open Cur_Batch
				Fetch Next From Cur_Batch InTo @Syn_Rights_Codes
				While (@@FETCH_STATUS = 0)
				Begin
					
					Truncate Table #Temp_Batch_N
					Truncate Table #Temp_Syndication
					Truncate Table #Temp_Syndication_Main
					Truncate Table #Temp_Syndication_NE
					Truncate Table #Temp_Avail_Dates
					
					Insert InTo #Temp_Syndication_Main
					Select Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive
					From Syn_Deal_Rights sdr
					Inner Join DBO.fn_Split_withdelemiter(@Syn_Rights_Codes, ',') d On sdr.Syn_Deal_Rights_Code = d.number
					--Where Syn_Deal_Rights_Code In 
					--(
					--	Select number From DBO.fn_Split_withdelemiter(@Syn_Rights_Codes, ',')
					--) 
					Order BY Actual_Right_Start_Date ASC
										
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
						Insert InTo #Temp_Avail_Dates
						Select @Actual_Right_Start_Date, @Actual_Right_End_Date, 'Y', 0 
					End
					Else
					Begin
						Insert InTo #Temp_Avail_Dates
						Select *, 'Y', 0 From (
							Select 
								Case When t2.Start_Date Is Null Then @Actual_Right_Start_Date Else DateAdd(d, 1, t2.End_Date) End AvailStartDate,
								DateAdd(d, -1, t1.Start_Date) AvailEndDate
							From #Temp_Syndication t1 Left Join #Temp_Syndication t2 On t1.IntCode = (t2.IntCode + 1) 
						) as a Where datediff(d, AvailStartDate, AvailEndDate) >= 0

						Declare @MaxEndDate DateTime = Null
						Select Top 1 @MaxEndDate = End_Date From #Temp_Syndication Order By [Start_Date] Desc
						If((datediff(d, @MaxEndDate, @Actual_Right_End_Date)  < 0 Or @MaxEndDate Is Not Null) And (@MaxEndDate <> isnull(@Actual_Right_End_Date,'')))
						Begin
							Insert InTo #Temp_Avail_Dates
							Select DATEADD(d, 1, @MaxEndDate), @Actual_Right_End_Date, 'Y', 0
						End
		
						Insert InTo #Temp_Avail_Dates
						Select Start_Date, End_Date, 'N', 0 From #Temp_Syndication Where Is_Exclusive = 'N'
					End
					
					Print 'AD 31 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)
			
					Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code From #Temp_Avail_Dates tad
					Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date And IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

					Insert InTo Avail_Dates
					Select Distinct AvailStartDate, AvailEndDate From #Temp_Avail_Dates Where IsNull(Avial_Dates_Code, 0) = 0
					AND (AvailEndDate is null Or AvailEndDate > GetDate())
					
					Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code From #Temp_Avail_Dates tad
					Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date And IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

					Delete From #Temp_Avail_Dates Where Avial_Dates_Code Is Null

					Truncate Table #Temp_Session_Raw

					Insert InTo #Temp_Session_Raw(Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive)
					Select @Acq_Deal_Code, @Acq_Deal_Rights_Code, a.Avial_Dates_Code, Case When a.Is_Exclusive = 'N' Then 0 Else 1 End 
					From #Temp_Avail_Dates a

					Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
					Inner Join Avail_Raw araw On 
					traw.Acq_Deal_Code = araw.Acq_Deal_Code And
					traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
					traw.Avail_Dates_Code = araw.Avail_Dates_Code And
					traw.Is_Exclusive = araw.Is_Exclusive
						
					Delete From #Temp_Session_Raw Where Avail_Dates_Code = 0

					Insert InTo Avail_Raw
					Select Distinct Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive From #Temp_Session_Raw 
					Where IsNull(Avail_Raw_Code, 0) = 0

					Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
					Inner Join Avail_Raw araw On 
					traw.Acq_Deal_Code = araw.Acq_Deal_Code And
					traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code And
					traw.Avail_Dates_Code = araw.Avail_Dates_Code And
					traw.Is_Exclusive = araw.Is_Exclusive And 
					IsNull(traw.Avail_Raw_Code, 0) = 0

					--Select * From #Temp_Avail_Dates
					Truncate Table #Temp_Batch_N
					If Exists(Select Top 1 * From #Temp_Avail_Dates)
					Begin

						Declare @Is_Tit_Language bit = 0, @Sub_Lang Varchar(Max) = '', @Dub_Lung Varchar(Max) = ''

						If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes And Rec_Type = 'T')
						Begin

							If(@Is_Title_Language_Right = 'Y')
							Begin
								--------------- INTERNATIONAL
			
								Insert InTo #Temp_Batch_N(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Is_Theatrical_Right)
								Select t.Avail_Acq_Code, a.Avail_Raw_Code, 1, t.Is_Theatrical_Right
								From #TMP_ACQ_DETAILS t 
								Inner Join #Temp_Session_Raw as a On 1 = 1
								Where t.Is_Syn = 'Y' And t.Syn_Rights_Codes = @Syn_Rights_Codes 

								Print 'AD 32 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

								--------------- End
							End
						End
					
						If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes And Rec_Type = 'S')
						Begin
							--------------- INTERNATIONAL

							Select t.Avail_Acq_Code, a.Avail_Raw_Code, 
									t.Language_Code, t.Is_Theatrical_Right InTo #Temp_Sub_New
							From #TMP_Acq_SUBTITLING t
							Inner Join #Temp_Session_Raw as a On 1 = 1
							Where t.Is_Syn = 'Y' And t.Syn_Rights_Codes = @Syn_Rights_Codes

							print '32.1'
							MERGE INTO #Temp_Batch_N AS tb
							Using (
								Select *, 
								STUFF(
									(
										SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
											SELECT Distinct Language_Code From #Temp_Sub_New subIn
											Where subIn.Avail_Acq_Code = a.Avail_Acq_Code And subIn.Avail_Raw_Code = a.Avail_Raw_Code
												  And subIn.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  = a.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  
										) As a
										FOR XML PATH('')
									), 1, 1, ''
								) As Sub_Lang
								From(
									Select Distinct tsn.Avail_Acq_Code, tsn.Avail_Raw_Code, tsn.Is_Theatrical_Right From #Temp_Sub_New tsn
								) As a
							) As temp On tb.Avail_Acq_Code = temp.Avail_Acq_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code AND tb.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  = temp.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  
							When MATCHED THEN
								UPDATE SET tb.Sub_Language_Codes = temp.Sub_Lang
							When NOT MATCHED THEN
								INSERT VALUES (temp.Avail_Acq_Code, temp.Avail_Raw_Code, 0, temp.Sub_Lang, Null, Null, Null, temp.Is_Theatrical_Right)
							;

							Drop Table #Temp_Sub_New

							Print 'AD 34 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

							--------------- END
						
						End
					
						If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes And Rec_Type = 'D')
						Begin
						
							Select t.Avail_Acq_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									t.Language_Code, t.Is_Theatrical_Right InTo #Temp_Dub_New
							From #TMP_Acq_DUBBING t
							Inner Join #Temp_Session_Raw as a On 1 = 1
							Where t.Is_Syn = 'Y' And t.Syn_Rights_Codes = @Syn_Rights_Codes 

							MERGE INTO #Temp_Batch_N AS tb
							Using (
								Select *, 
								STUFF(
									(
										SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
											SELECT Distinct Language_Code From #Temp_Dub_New subIn
											Where subIn.Avail_Acq_Code = a.Avail_Acq_Code And subIn.Avail_Raw_Code = a.Avail_Raw_Code
												  And subIn.Is_Theatrical_Right = a.Is_Theatrical_Right
										) As a
										FOR XML PATH('')
									), 1, 1, ''
								) As Dub_Lang
								From(
									Select Distinct tsn.Avail_Acq_Code, tsn.Avail_Raw_Code, tsn.Is_Theatrical_Right From #Temp_Dub_New tsn
								) As a
							) As temp On tb.Avail_Acq_Code = temp.Avail_Acq_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code
							When MATCHED THEN
								UPDATE SET tb.Dub_Language_Codes = temp.Dub_Lang
							When NOT MATCHED THEN
								INSERT VALUES (temp.Avail_Acq_Code, temp.Avail_Raw_Code, 0, Null, temp.Dub_Lang, Null, Null, temp.Is_Theatrical_Right)
							;

							Drop Table #Temp_Dub_New
							Print 'AD 36 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As Varchar(10)) + ' - ' + Convert(Varchar(100), Getdate(), 109)

							-------------- End
		
						End

						Update #Temp_Batch_N Set Sub_Language_Codes = ',' + Sub_Language_Codes + ',' Where IsNull(Sub_Language_Codes, '') <> ''
						Update #Temp_Batch_N Set Dub_Language_Codes = ',' + Dub_Language_Codes + ',' Where IsNull(Dub_Language_Codes, '') <> ''

						Insert InTo Avail_Languages(Language_Codes)
						Select Distinct Sub_Language_Codes From #Temp_Batch_N Where Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   Not In (
							Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   From Avail_Languages a
						) And IsNull(Sub_Language_Codes, '') <> ''

						Update temp set temp.Sub_Avail_Lang_Code = al.Avail_Languages_Code From #Temp_Batch_N temp 
						Inner Join Avail_Languages al On temp.Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

						Insert InTo Avail_Languages(Language_Codes)
						Select Distinct Dub_Language_Codes From #Temp_Batch_N Where Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   Not In (
							Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   From Avail_Languages a
						) And IsNull(Dub_Language_Codes, '') <> ''

						Update temp set temp.Dub_Avail_Lang_Code = al.Avail_Languages_Code From #Temp_Batch_N temp 
						Inner Join Avail_Languages al On temp.Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

						--Select * From #Temp_Batch_N

						Insert InTo Avail_Acq_Details(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
						Select Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Avail_Lang_Code, Dub_Avail_Lang_Code From #Temp_Batch_N Where Is_Theatrical_Right = 'N'

						Insert InTo Avail_Acq_Theatrical_Details(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
						Select Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Avail_Lang_Code, Dub_Avail_Lang_Code From #Temp_Batch_N Where Is_Theatrical_Right = 'Y'
						
						Truncate Table #Temp_Batch_N
						Truncate Table #Temp_Syndication
						Truncate Table #Temp_Syndication_Main
						Truncate Table #Temp_Syndication_NE
						Truncate Table #Temp_Avail_Dates
					End
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

		End
		
		Truncate Table #Temp_Batch_N
		Truncate Table #Temp_Session_Raw
		Truncate Table #Temp_Session_Raw_Lang
		Drop Table #TMP_ACQ_DETAILS
		Drop Table #TMP_Acq_SUBTITLING
		Drop Table #TMP_Acq_DUBBING

		--Return

		Fetch From CUR_Rights InTo @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	End
	Close CUR_Rights
	Deallocate CUR_Rights

	If(@Record_Type = 'S')
	Begin

		Delete From Avail_Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @Record_Code

		Insert InTo Avail_Syn_Acq_Mapping(Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
		Select Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
		From Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @Record_Code

	End
	
	Drop Table #Temp_Batch_N
	Drop Table #Temp_Session_Raw
	Drop Table #Temp_Session_Raw_Lang
	Drop Table #Process_Rights

End
