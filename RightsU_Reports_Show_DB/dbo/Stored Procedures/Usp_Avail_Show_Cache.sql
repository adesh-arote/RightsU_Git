
CREATE PROCEDURE [dbo].[Usp_Avail_Show_Cache]
	@RecORd_Code INT = 0,
	@RecORd_Type Char(1) = 'A'
AS
Begin
-- =============================================
-- AuthOR:		ADESH AROTE
-- Create DATE: 19-Feb-2016
-- Description:	Cache Acquisition on deal approval fOR availability
-- =============================================

	--BEGIN TRY
	--DECLARE
	--	@RecORd_Code INT = 21661,
	--	@RecORd_Type Char(1) = 'A'

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

	If(@RecORd_Type = 'A')
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
			AND adr.Acq_Deal_Code = @RecORd_Code --AND Acq_Deal_Rights_Code = 778
			AND IsNull(adr.Is_Theatrical_Right, 'N') = 'N'
			AND (adr.Actual_Right_End_Date is null OR adr.Actual_Right_End_Date > GetDate())
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
			AND (adr.Actual_Right_End_Date is null OR adr.Actual_Right_End_Date > GetDate())
			AND ADR.Acq_Deal_Rights_Code In (
				Select Deal_Rights_Code From Avail_Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @RecORd_Code
				Union
				Select Deal_Rights_Code From Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @RecORd_Code 
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
		Language_Codes VARCHAR(Max),
		Rec_Type Char(1),
		Avail_Languages_Code numeric(38, 0)
	)

	Delete From Avail_Acq_Show_Details Where Avail_Raw_Code In (
		Select Avail_Raw_Code From Avail_Raw Where Acq_Deal_Rights_Code In (
			Select Acq_Deal_Rights_Code From #Process_Rights
		)
	)

	Declare CUR_Rights CursOR FOR
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

		CREATE TABLE #TMP_Acq_SUBTITLING
		(
			Acq_Deal_Rights_Code INT, 
			Title_Code INT, 
			Episode_From INT, 
			Episode_To INT, 
			PlatfORm_Code INT, 
			Country_Code INT, 
			Language_Code INT,
			Avail_Acq_Show_Code INT,
			Is_Syn CHAR(1),
			Syn_Rights_Codes VARCHAR(2000)
		)
			
		CREATE TABLE #TMP_Acq_DUBBING
		(
			Acq_Deal_Rights_Code INT, 
			Title_Code INT, 
			Episode_From INT, 
			Episode_To INT, 
			PlatfORm_Code INT, 
			Country_Code INT, 
			Language_Code INT,
			Avail_Acq_Show_Code INT,
			Is_Syn CHAR(1),
			Syn_Rights_Codes VARCHAR(2000)
		)

		Select Distinct Case When srter.TerritORy_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Acq_Contry From (
			Select Acq_Deal_Rights_Code, TerritORy_Code, Country_Code, TerritORy_Type 
			From Acq_Deal_Rights_TerritORy  
			Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) As srter
		LEFT JOIN TerritORy_Details td On srter.TerritORy_Code = td.TerritORy_Code
		
		Print 'AD 0 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		SELECT DISTINCT ADR.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adrp.PlatfORm_Code, con.Country_Code, 
						@Is_Theatrical_Right Is_Theatrical_Right, 0 Avail_Acq_Show_Code, 'N' Is_Syn
		INTO #TMP_ACQ_DETAILS
		FROM (
			SELECT @Acq_Deal_Rights_Code Acq_Deal_Rights_Code
		) AS adr
		INNER JOIN Acq_Deal_Rights_Title adrt on adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_PlatfORm adrp on adrp.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN #Acq_Contry con On 1 = 1

		Alter Table #TMP_ACQ_DETAILS Add Syn_Rights_Codes VARCHAR(2000)

		Print 'AD 1 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Drop Table #Acq_Contry
			
		If(@Is_Theatrical_Right = 'N')
		Begin
			
			Print 'AD 2.1 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			Delete From #TMP_ACQ_DETAILS Where PlatfORm_Code = @Theatrical_Code AND Country_Code = @India_Code

			Print 'AD 2.2 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		End

		--------- CHECK INTERNATIONAL AVAILABILITY

		Update t Set t.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Show a On t.Title_Code = a.Title_Code AND t.PlatfORm_Code = a.PlatfORm_Code 
			AND t.Country_Code = a.Country_Code AND t.Is_Theatrical_Right = 'N'

		Print 'AD 3 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Insert InTo Avail_Acq_Show(Title_Code, PlatfORm_Code, Country_Code)
		Select Title_Code, PlatfORm_Code, Country_Code From #TMP_ACQ_DETAILS Where IsNull(Avail_Acq_Show_Code, 0) = 0 AND Is_Theatrical_Right = 'N'

		Print 'AD 4 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Update t Set t.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code From #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Show a On t.Title_Code = a.Title_Code AND t.PlatfORm_Code = a.PlatfORm_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Show_Code, 0) = 0 AND t.Is_Theatrical_Right = 'N'

		Print 'AD 5 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		
		---------- End

		Select Distinct CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code End Language_Code, Acq_Deal_Rights_Code InTo #Acq_Sub
		FROM(
			Select Distinct Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Subtitling
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		Print 'AD 9 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		
		Print 'AD 10 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Print 'AD 11 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Select Distinct CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code End Language_Code, Acq_Deal_Rights_Code InTo #Acq_Dub
		FROM(
			Select Distinct Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Dubbing
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		Print 'AD 12 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Print 'AD 13 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		Print 'AD 14 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		
		Declare @Is_Exclusive_Bit bit = Case When @Is_Exclusive = 'N' Then 0 Else 1 End
		
		Declare @Avial_Dates_Code Int = 0

		If(@Is_Exclusive = 'N')------------ CATCHE THE RECORDS WHICH ARE ACQUIRED EXCLUSIVE NO
		Begin
			
			TRUNCATE TABLE #TMP_Acq_SUBTITLING
			TRUNCATE TABLE #TMP_ACQ_DETAILS

			INSERT INTO #TMP_Acq_SUBTITLING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn)
			Select ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Episode_From, adr.Episode_To, adr.PlatfORm_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Show_Code, 'N' Is_Syn
			From #TMP_ACQ_DETAILS ADR
			INNER JOIN #Acq_Sub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Is_Theatrical_Right = 'N'
		
			INSERT INTO #TMP_Acq_DUBBING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn)
			Select ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Episode_From, adr.Episode_To, adr.PlatfORm_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Show_Code, 'N' Is_Syn
			FROM #TMP_ACQ_DETAILS ADR
			INNER JOIN #Acq_Dub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Is_Theatrical_Right = 'N'
		
			Select @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) From [dbo].[Avail_Dates] Where [Start_Date] = @Actual_Right_Start_Date AND IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
			if(@Avial_Dates_Code Is Null OR @Avial_Dates_Code = 0)
			Begin
				Insert InTo [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
				Select @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
			End

			Truncate Table #Temp_Session_Raw
			Truncate Table #Temp_Session_Raw_Lang

			Insert InTo #Temp_Session_Raw_Lang(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Language_Codes, Rec_Type)
			Select Distinct Avail_Acq_Show_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Episode_From, Episode_To, Lang, Rec_Type From (
				Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, '' Lang, 'T' Rec_Type From #TMP_ACQ_DETAILS 
				Where Is_Theatrical_Right = 'N' AND @Is_Title_Language_Right = 'Y'
				Union
				Select Avail_Acq_Show_Code, Episode_From, Episode_To, STUFF
				(
					(
						SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT Distinct Language_Code From #TMP_Acq_SUBTITLING subIn
							Where subIn.Episode_From = sub.Episode_From AND subIn.Episode_To = sub.Episode_To
								  AND subIn.Avail_Acq_Show_Code = sub.Avail_Acq_Show_Code
						) As a
						FOR XML PATH('')
					), 1, 1, ''
				)
				, 'S' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To From #TMP_Acq_SUBTITLING) sub
				Union
				Select Avail_Acq_Show_Code, Episode_From, Episode_To, STUFF
				(
					(
						SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT Distinct Language_Code From #TMP_Acq_DUBBING dubIn
							Where dubIn.Episode_From = dub.Episode_From AND dubIn.Episode_To = dub.Episode_To
								  AND dubIn.Avail_Acq_Show_Code = dub.Avail_Acq_Show_Code
						) As a
						FOR XML PATH('')
					), 1, 1, ''
				)
				, 'D' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To From #TMP_Acq_DUBBING) dub
			) As a

			Insert InTo #Temp_Session_Raw(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Is_Same)
			Select Distinct Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 'N' From #Temp_Session_Raw_Lang
				
			Print 'AD 14.2 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			--Update #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' Where IsNull(Language_Codes, '') <> ''

			Insert InTo Avail_Languages(Language_Codes)
			Select Distinct Language_Codes From #Temp_Session_Raw_Lang Where Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  Not In (
				Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  From Avail_Languages a
			) AND Language_Codes <> ''

			Update temp set temp.Avail_Languages_Code = al.Avail_Languages_Code From #Temp_Session_Raw_Lang temp 
			Inner Join Avail_Languages al On temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

			Print 'AD 14.3 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			Update t1 Set t1.Is_Title_Lang = 1
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
			t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
			t1.Is_Exclusive = t2.Is_Exclusive AND
			t1.Episode_From = t2.Episode_From AND 
			t1.Episode_To = t2.Episode_To AND
			t2.Rec_Type = 'T'

			Print 'AD 14.4 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
			t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
			t1.Is_Exclusive = t2.Is_Exclusive AND
			t1.Episode_From = t2.Episode_From AND 
			t1.Episode_To = t2.Episode_To AND
			t2.Rec_Type = 'S'

			Print 'AD 14.5 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
			From #Temp_Session_Raw t1
			Inner Join #Temp_Session_Raw_Lang t2 On
			t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
			t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
			t1.Is_Exclusive = t2.Is_Exclusive AND
			t1.Episode_From = t2.Episode_From AND 
			t1.Episode_To = t2.Episode_To AND
			t2.Rec_Type = 'D'

			Print 'AD 14.6 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			Truncate Table #Temp_Session_Raw_Lang

			Select Distinct traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To 
			InTo #Temp_Session_Raw_Distinct
			From #Temp_Session_Raw traw

			MERGE INTO Avail_Raw AS araw
			Using #Temp_Session_Raw_Distinct AS traw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
			traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
			traw.Is_Exclusive = araw.Is_Exclusive AND
			traw.Episode_From = araw.Episode_From AND
			traw.Episode_To = araw.Episode_To
			WHEN NOT MATCHED THEN
				INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To, 0)
			;

			Drop Table #Temp_Session_Raw_Distinct
				
			Print 'AD 14.7 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
			Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
			Inner Join Avail_Raw araw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
			traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
			traw.Is_Exclusive = araw.Is_Exclusive AND
			traw.Episode_From = araw.Episode_From AND
			traw.Episode_To = araw.Episode_To
			
			Print 'AD 14.8 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
	
			Insert InTo Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			Select Avail_Acq_Show_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code From #Temp_Session_Raw

			Truncate Table #Temp_Session_Raw

		End
		Else
		Begin
	
			Begin ------------ GENERATE SYNDICATION DATA FOR CURRENT COMBINATION

				Select Distinct srter.Syn_Deal_Rights_Code, Case When srter.TerritORy_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Syn_TerritORy 
				From (
					Select sdrtr.Syn_Deal_Rights_Code, sdrtr.TerritORy_Code, sdrtr.Country_Code, sdrtr.TerritORy_Type 
					From Syn_Deal_Rights_TerritORy sdrtr
					Where sdrtr.Syn_Deal_Rights_Code In (
						Select samIn.Syn_Deal_Rights_Code From Syn_Acq_Mapping samIn Where samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) As srter
				Left Join TerritORy_Details td On srter.TerritORy_Code = td.TerritORy_Code

				Print 'AD 15 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Select Distinct srsub.Syn_Deal_Rights_Code, Case When srsub.Language_Type = 'G' Then lgd.Language_Code Else srsub.Language_Code End Language_Code InTo #Syn_Subtitling
				From (
					Select sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					From Syn_Deal_Rights_Subtitling sdrs
					Where sdrs.Syn_Deal_Rights_Code In (
						Select samIn.Syn_Deal_Rights_Code From Syn_Acq_Mapping samIn Where samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) As srsub
				Left Join Language_Group_Details lgd On srsub.Language_Group_Code = lgd.Language_Group_Code

				Print 'AD 16 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		
				Select Distinct srsub.Syn_Deal_Rights_Code, Case When srsub.Language_Type = 'G' Then lgd.Language_Code Else srsub.Language_Code End Language_Code InTo #Syn_Dubbing
				From (
					Select sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					From Syn_Deal_Rights_Dubbing sdrs
					Where sdrs.Syn_Deal_Rights_Code In (
						Select samIn.Syn_Deal_Rights_Code From Syn_Acq_Mapping samIn Where samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) As srsub
				Left Join Language_Group_Details lgd On srsub.Language_Group_Code = lgd.Language_Group_Code

				Print 'AD 17 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Select Distinct sdr.Syn_Deal_Rights_Code, sdr.Is_Exclusive, sdr.Is_Title_Language_Right, sdr.Is_Theatrical_Right, sdr.Actual_Right_Start_Date, 
								sdr.Actual_Right_End_Date, sdrt.Title_Code, sdrt.Episode_From, sdrt.Episode_To, sdrp.PlatfORm_Code, synter.Country_Code 
				InTo #Syn_Data
				From Syn_Deal_Rights sdr 
				Inner Join Syn_Acq_Mapping sam On sam.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code AND Deal_Rights_Code = @Acq_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_PlatfORm sdrp On sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				Inner Join #Syn_TerritORy synter On sdr.Syn_Deal_Rights_Code = synter.Syn_Deal_Rights_Code
				Where Actual_Right_Start_Date Is Not Null
				AND sdrt.Title_Code In (
					Select adr.Title_Code From #TMP_ACQ_DETAILS adr Where adr.PlatfORm_Code = sdrp.PlatfORm_Code AND adr.Country_Code = synter.Country_Code
					AND (
						(adr.Episode_From BETWEEN sdrt.Episode_From AND sdrt.Episode_To) OR
						(adr.Episode_To BETWEEN sdrt.Episode_From AND sdrt.Episode_To) OR
						(sdrt.Episode_From BETWEEN adr.Episode_From AND adr.Episode_To) OR
						(sdrt.Episode_To BETWEEN adr.Episode_From AND adr.Episode_To)
					)
				)

				Print 'AD 18 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Drop Table #Syn_TerritORy

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
					PlatfORm_Code INT, 
					Country_Code INT
				)

				INSERT INTO #Syn_Title_Avail_Data(Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date, Actual_Right_End_Date, 
					Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code)
				Select Distinct Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code
				From #Syn_Data Where Is_Title_Language_Right = 'Y'
		
				Print 'AD 19 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				/*

				Select Distinct syn.Syn_Deal_Rights_Code, Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, sdrs.Language_Code
				InTo #Syn_Sub_Avail_Data
				From #Syn_Data syn
				Inner Join #Syn_Subtitling sdrs On syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code
		
				Select Distinct syn.Syn_Deal_Rights_Code, Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, sdrd.Language_Code
				InTo #Syn_Dub_Avail_Data
				From #Syn_Data syn
				Inner Join #Syn_Dubbing sdrd On syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
				
				*/

				Print 'AD 21 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			End ------------ End
			
			SELECT * INTO #TEMPAcqDetNew
			FROM #TMP_ACQ_DETAILS a WHERE a.Title_Code NOT IN (
				SELECT Title_Code FROM #Syn_Data s 
				WHERE a.PlatfORm_Code = s.PlatfORm_Code AND a.Country_Code = s.Country_Code AND (
					(s.Episode_From BETWEEN a.Episode_From AND a.Episode_To) OR
					(s.Episode_To BETWEEN a.Episode_From AND a.Episode_To) OR
					(a.Episode_From BETWEEN s.Episode_From AND s.Episode_To) OR
					(a.Episode_To BETWEEN s.Episode_From AND s.Episode_To)
				)
			)

			INSERT INTO #TMP_Acq_SUBTITLING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn)
			SELECT temp.Acq_Deal_Rights_Code, temp.Title_Code, temp.Episode_From, temp.Episode_To, temp.PlatfORm_Code, temp.Country_Code, sub.Language_Code, Avail_Acq_Show_Code, 'N' Is_Syn
			FROM #TEMPAcqDetNew temp
			INNER JOIN #Acq_Sub sub ON sub.Acq_Deal_Rights_Code = temp.Acq_Deal_Rights_Code AND temp.Is_Theatrical_Right = 'N'

			INSERT INTO #TMP_Acq_DUBBING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn)
			SELECT temp.Acq_Deal_Rights_Code, temp.Title_Code, temp.Episode_From, temp.Episode_To, temp.PlatfORm_Code, temp.Country_Code, sub.Language_Code, Avail_Acq_Show_Code, 'N' Is_Syn
			FROM #TEMPAcqDetNew temp
			INNER JOIN #Acq_Dub sub ON sub.Acq_Deal_Rights_Code = temp.Acq_Deal_Rights_Code AND temp.Is_Theatrical_Right = 'N'

			IF EXISTS(SELECT TOP 1 * FROM #Syn_Data)
			BEGIN
			
				CREATE TABLE #TempLangData
				(
					Episode_From INT,
					Episode_To INT,
					Language_Code INT,
					Syn_Deal_Rights_Code INT
				)

				Print 'AD 22 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				DECLARE @TitCode INT, @CntryCode INT, @PlatCode INT, @AvailShowCode INT, @Counter INT = 0, @EpsFrm INT, @EpsTo INT
				DECLARE CURAvailSyns CURSOR FOR 
							SELECT DISTINCT Title_Code, Country_Code, PlatfORm_Code, Avail_Acq_Show_Code, Episode_From, Episode_To 
							FROM #TMP_ACQ_DETAILS 
							WHERE Is_Theatrical_Right = 'N' AND Avail_Acq_Show_Code NOT IN (
								SELECT Avail_Acq_Show_Code FROM #TEMPAcqDetNew
							)
				OPEN CURAvailSyns
				FETCH NEXT FROM CURAvailSyns INTO @TitCode, @CntryCode, @PlatCode, @AvailShowCode, @EpsFrm, @EpsTo
				WHILE(@@FETCH_STATUS = 0)
				BEGIN

					SET @Counter = @Counter + 1
					PRINT 'AD CNT -- ' + Cast(@Counter As VARCHAR(10))

					BEGIN ------------- TITLE LANGUAGE START

						UPDATE tmp SET Is_Syn = 'Y', tmp.Syn_Rights_Codes = STUFF(
							(
								SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code as VARCHAR) FROM #Syn_Title_Avail_Data b
								WHERE @TitCode = b.Title_Code 
									AND @CntryCode = b.Country_Code 
									AND @PlatCode = b.PlatfORm_Code
									AND (
										(b.Episode_From BETWEEN @EpsFrm AND @EpsTo) OR
										(b.Episode_To BETWEEN @EpsFrm AND @EpsTo) OR
										(@EpsFrm BETWEEN b.Episode_From AND b.Episode_To) OR
										(@EpsTo BETWEEN b.Episode_From AND b.Episode_To)
									)
								FOR XML PATH('')
							), 1, 1, ''
						)
						FROM #TMP_ACQ_DETAILS tmp
						WHERE tmp.Avail_Acq_Show_Code = @AvailShowCode

					END --------------- TITLE LANGUAGE END

					BEGIN ------------- SUB LANGUAGE START

						TRUNCATE TABLE #TempLangData

						INSERT INTO #TempLangData(Episode_From, Episode_To, Syn_Deal_Rights_Code, Language_Code)
						SELECT syn.Episode_From, syn.Episode_To, syn.Syn_Deal_Rights_Code, Language_Code FROM (
							Select DISTINCT Episode_From, Episode_To, Syn_Deal_Rights_Code
							From #Syn_Data b
							Where b.Title_Code = @TitCode
							AND b.Country_Code = @CntryCode
							AND b.PlatfORm_Code = @PlatCode
						) AS syn
						INNER JOIN #Syn_Subtitling sdrs ON syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code

						--SELECT COUNT(*) FROM #TempLangData

						INSERT INTO #TMP_Acq_SUBTITLING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn, 
														Syn_Rights_Codes)
						SELECT Acq_Deal_Rights_Code, @TitCode, @EpsFrm, @EpsTo, @PlatCode, @CntryCode, Language_Code, @AvailShowCode, 'N',
							   STUFF(
							   		(
							   			Select Distinct ',' + CAST(Syn_Deal_Rights_Code as VARCHAR) From #TempLangData b
							   			Where (
							   					(b.Episode_From BETWEEN @EpsFrm AND @EpsTo) OR
							   					(b.Episode_To BETWEEN @EpsFrm AND @EpsTo) OR
							   					(@EpsFrm BETWEEN b.Episode_From AND b.Episode_To) OR
							   					(@EpsTo BETWEEN b.Episode_From AND b.Episode_To)
							   				)
							   				AND b.Language_Code = tmp.Language_Code
							   			FOR XML PATH('')
							   		), 1, 1, ''
							   )
						From #Acq_Sub tmp

					END --------------- SUB LANGUAGE END

					BEGIN ------------- DUB LANGUAGE START

						TRUNCATE TABLE #TempLangData
						
						INSERT INTO #TempLangData(Episode_From, Episode_To, Syn_Deal_Rights_Code, Language_Code)
						SELECT syn.Episode_From, syn.Episode_To, syn.Syn_Deal_Rights_Code, Language_Code FROM (
							Select DISTINCT Episode_From, Episode_To, Syn_Deal_Rights_Code
							From #Syn_Data b
							Where b.Title_Code = @TitCode
							AND b.Country_Code = @CntryCode
							AND b.PlatfORm_Code = @PlatCode
						) AS syn
						INNER JOIN #Syn_Dubbing sdrd ON syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code

						INSERT INTO #TMP_Acq_DUBBING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn, 
														Syn_Rights_Codes)
						SELECT Acq_Deal_Rights_Code, @TitCode, @EpsFrm, @EpsTo, @PlatCode, @CntryCode, Language_Code, @AvailShowCode, 'N',
							   STUFF(
							   		(
							   			Select Distinct ',' + CAST(Syn_Deal_Rights_Code as VARCHAR) From #TempLangData b
							   			Where (
							   					(b.Episode_From BETWEEN @EpsFrm AND @EpsTo) OR
							   					(b.Episode_To BETWEEN @EpsFrm AND @EpsTo) OR
							   					(@EpsFrm BETWEEN b.Episode_From AND b.Episode_To) OR
							   					(@EpsTo BETWEEN b.Episode_From AND b.Episode_To)
							   				)
							   				AND b.Language_Code = tmp.Language_Code
							   			FOR XML PATH('')
							   		), 1, 1, ''
							   )
						From #Acq_Dub tmp

					END --------------- DUB LANGUAGE END

					FETCH NEXT FROM CURAvailSyns INTO @TitCode, @CntryCode, @PlatCode, @AvailShowCode, @EpsFrm, @EpsTo
				END
				CLOSE CURAvailSyns
				DEALLOCATE CURAvailSyns

				DROP TABLE #TempLangData

				Print 'AD 22.1 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			END
			
			UPDATE #TMP_Acq_SUBTITLING SET Is_Syn = 'Y' WHERE ISNULL(Syn_Rights_Codes, '') <> ''
			UPDATE #TMP_Acq_DUBBING SET Is_Syn = 'Y' WHERE ISNULL(Syn_Rights_Codes, '') <> ''


			Print 'AD 23 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
			Print 'AD 23.1 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			Print 'AD 24 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
			Print 'AD 24.1 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
			Create Table #Temp_Batch
			(
				Syn_Rights_Codes VARCHAR(2000),
				Rec_Type char(1)
			)

			Insert InTo #Temp_Batch
			Select Distinct Syn_Rights_Codes, 'T' From #TMP_ACQ_DETAILS Where Is_Syn = 'Y'
			
			Insert InTo #Temp_Batch
			Select Distinct Syn_Rights_Codes, 'S' From #TMP_Acq_SUBTITLING Where Is_Syn = 'Y'
			
			Insert InTo #Temp_Batch
			Select Distinct Syn_Rights_Codes, 'D' From #TMP_Acq_DUBBING Where Is_Syn = 'Y'

			Print 'AD 25 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			If(IsNull(@Actual_Right_End_Date, '31Dec9999') > GetDate()) ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED
			Begin ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED

				SET @Avial_Dates_Code = 0

				Select @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) From [dbo].[Avail_Dates] 
				Where [Start_Date] = @Actual_Right_Start_Date AND IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')

				if(@Avial_Dates_Code Is Null OR @Avial_Dates_Code = 0)
				Begin
					Insert InTo [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
					Select @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
				End
				
				Truncate Table #Temp_Session_Raw
				Truncate Table #Temp_Session_Raw_Lang
				
				Print 'AD 25.1 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Insert InTo #Temp_Session_Raw_Lang(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Language_Codes, Rec_Type)
				Select Distinct Avail_Acq_Show_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Episode_From, Episode_To, Lang, Rec_Type From (
					Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, '' Lang, 'T' Rec_Type From #TMP_ACQ_DETAILS 
					Where Is_Theatrical_Right = 'N' AND Is_Syn <> 'Y' AND @Is_Title_Language_Right = 'Y'
					Union
					Select Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					(
						(
							SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code From #TMP_Acq_SUBTITLING subIn
								Where subIn.Episode_From = sub.Episode_From AND subIn.Episode_To = sub.Episode_To
									  AND subIn.Is_Syn = sub.Is_Syn
									  AND subIn.Avail_Acq_Show_Code = sub.Avail_Acq_Show_Code
							) As a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'S' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Syn From #TMP_Acq_SUBTITLING Where Is_Syn <> 'Y') sub
					Union
					Select Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					(
						(
							SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code From #TMP_Acq_DUBBING dubIn
								Where dubIn.Episode_From = dub.Episode_From AND dubIn.Episode_To = dub.Episode_To
									  AND dubIn.Is_Syn = dub.Is_Syn
									  AND dubIn.Avail_Acq_Show_Code = dub.Avail_Acq_Show_Code
							) As a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'D' From (Select Distinct Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Syn From #TMP_Acq_DUBBING Where Is_Syn <> 'Y') dub
				) As a
				
				
				Insert InTo #Temp_Session_Raw(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Is_Same)
				Select Distinct Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 'N' From #Temp_Session_Raw_Lang
				
				Print 'AD 25.2 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				--Update #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' Where IsNull(Language_Codes, '') <> ''

				Insert InTo Avail_Languages(Language_Codes)
				Select Distinct Language_Codes From #Temp_Session_Raw_Lang Where Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS Not In (
					Select a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS From Avail_Languages a
				) AND Language_Codes <> ''

				Update temp set temp.Avail_Languages_Code = al.Avail_Languages_Code From #Temp_Session_Raw_Lang temp 
				Inner Join Avail_Languages al On temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

				Print 'AD 25.3 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Update t1 Set t1.Is_Title_Lang = 1
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Episode_From = t2.Episode_From AND 
				t1.Episode_To = t2.Episode_To AND
				t2.Rec_Type = 'T'

				Print 'AD 25.4 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Episode_From = t2.Episode_From AND 
				t1.Episode_To = t2.Episode_To AND
				t2.Rec_Type = 'S'

				Print 'AD 25.5 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
				From #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Episode_From = t2.Episode_From AND 
				t1.Episode_To = t2.Episode_To AND
				t2.Rec_Type = 'D'

				Print 'AD 25.6 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				Truncate Table #Temp_Session_Raw_Lang

				Select Distinct traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To 
				InTo #Temp_Session_Raw_Dist
				From #Temp_Session_Raw traw

				MERGE INTO Avail_Raw AS araw
				Using #Temp_Session_Raw_Dist AS traw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
				traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
				traw.Is_Exclusive = araw.Is_Exclusive AND
				traw.Episode_From = araw.Episode_From AND
				traw.Episode_To = araw.Episode_To
				WHEN NOT MATCHED THEN
					INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To, 0)
				;

				Drop Table #Temp_Session_Raw_Dist
				
				Print 'AD 25.7 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
				Inner Join Avail_Raw araw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
				traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
				traw.Is_Exclusive = araw.Is_Exclusive AND
				traw.Episode_From = araw.Episode_From AND
				traw.Episode_To = araw.Episode_To
			
				Print 'AD 25.8 ' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

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

				Declare @Syn_Rights_Codes VARCHAR(2000) = ''
				Declare Cur_Batch CursOR FOR Select Distinct Syn_Rights_Codes From #Temp_Batch WHERE ISNULL(Syn_Rights_Codes, '') <> ''
				Open Cur_Batch
				Fetch Next From Cur_Batch InTo @Syn_Rights_Codes
				While (@@FETCH_STATUS = 0)
				Begin
					PRINT 'Testing 1 - ' + @Syn_Rights_Codes
					Truncate Table #Syn_Rights

					Insert InTo #Syn_Rights(Title_Code, Episode_From, Episode_To, Start_DT, End_DT, Is_Exclusive)
					Select Title_Code, Episode_From, Episode_To, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive
					From Syn_Deal_Rights sdr
					Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					Where sdr.Syn_Deal_Rights_Code In 
					(
						Select number From DBO.fn_Split_withdelemiter(@Syn_Rights_Codes, ',')
					) ORder BY Actual_Right_Start_Date ASC

					Select * InTo #Temp_Episode From (
						Select Distinct Title_Code, Episode_From, Episode_To From #TMP_ACQ_DETAILS Where Syn_Rights_Codes = @Syn_Rights_Codes
						Union
						Select Distinct Title_Code, Episode_From, Episode_To From #TMP_Acq_SUBTITLING Where Syn_Rights_Codes = @Syn_Rights_Codes
						Union
						Select Distinct Title_Code, Episode_From, Episode_To From #TMP_Acq_DUBBING Where Syn_Rights_Codes = @Syn_Rights_Codes
					) As a

					--Select 'ad', * From #Syn_Rights

					Declare @Process_Title_Code Int = 0, @Episode_From Int = 0, @Episode_To Int = 0
					Declare Cur_Process_Title CursOR FOR Select Distinct Title_Code, Episode_From, Episode_To From #Temp_Episode
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
							Where Title_Code = @Process_Title_Code AND (
								  Episode_From BETWEEN @Episode_From AND @Episode_To OR
								  Episode_To BETWEEN @Episode_From AND @Episode_To
							)
							Union
							Select Case When Episode_To > @Episode_To Then 0 Else Episode_To End Eps_No From #Syn_Rights
							Where Title_Code = @Process_Title_Code AND (
								  Episode_From BETWEEN @Episode_From AND @Episode_To OR
								  Episode_To BETWEEN @Episode_From AND @Episode_To
							)
						) As a ORder By Eps_No

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
						--	Where Title_Code = @Process_Title_Code AND (
						--		  Episode_From BETWEEN @Episode_From AND @Episode_To OR
						--		  Episode_To BETWEEN @Episode_From AND @Episode_To
						--	)
						--	Union
						--	Select Case When Episode_To > @Episode_To Then 0 Else Episode_To End Eps_No From #Syn_Rights
						--	Where Title_Code = @Process_Title_Code AND (
						--		  Episode_From BETWEEN @Episode_From AND @Episode_To OR
						--		  Episode_To BETWEEN @Episode_From AND @Episode_To
						--	)
						--) As a ORder By Eps_No

						--Insert InTo #Temp_Eps_Nos Values(@Episode_To)
						
						--Insert InTo #Eps_Nos(Eps_Nos)
						--Select Distinct Eps_Nos From #Temp_Eps_Nos Where Eps_Nos > 0 ORder By Eps_Nos

						Declare @IntCode Int, @Cur_Episode_From Int, @Cur_Episode_To Int, @Cur_Start_DT DateTime, @Cur_End_DT DateTime,
								@Prev_Episode_From Int = @Episode_From

						--Declare Cur_Process_Eps CursOR FOR 
						--	Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
						--		Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
						--		LEAD(Eps_Nos) OVER (ORDER BY IntCode ASC) Eps_To,
						--		LAG(Eps_Nos) OVER (ORDER BY IntCode ASC) LagValue 
						--		From #Eps_Nos
						--	) As a Where IsNull(Eps_To, 0) > 0 AND Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						--Select * From #Temp_Eps_Nos

						--Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
						--	Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
						--	LEAD(Eps_Nos) OVER (ORDER BY IntCode ASC) Eps_To,
						--	LAG(Eps_Nos) OVER (ORDER BY IntCode ASC) LagValue 
						--	From #Eps_Nos
						--) As a Where IsNull(Eps_To, 0) > 0 AND Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						--Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
						--	Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
						--	(Select lead.Eps_Nos From #Eps_Nos lead Where lead.IntCode = (tmp.IntCode + 1)) Eps_To,
						--	(Select lag.Eps_Nos From #Eps_Nos lag Where lag.IntCode = (tmp.IntCode - 1)) LagValue
						--	From #Eps_Nos tmp
						--) As a Where IsNull(Eps_To, 0) > 0 AND Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

						--Select Case When t1.Eps_Nos = @Episode_From Then t1.Eps_Nos Else t1.Eps_Nos + 1 End Eps_From, t2.Eps_Nos Eps_To 
						--From #Eps_Nos t1 
						--Inner Join #Eps_Nos t2 On t1.IntCode = (t2.IntCode - 1)

						--Select Case When t1.Eps_Nos = @Episode_From Then t1.Eps_Nos Else t1.Eps_Nos + 1 End Eps_From, t2.Eps_Nos Eps_To 
						--From #Eps_Nos t1 
						--Left Join #Eps_Nos t2 On t1.IntCode = (t2.IntCode - 1)

						Declare Cur_Process_Eps CursOR FOR 
							Select Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End, Eps_To From (
								Select Case When Eps_Nos = @Episode_From Then Eps_Nos Else Eps_Nos + 1 End Eps_From, 
								(Select lead.Eps_Nos From #Eps_Nos lead Where lead.IntCode = (tmp.IntCode + 1)) Eps_To,
								(Select lag.Eps_Nos From #Eps_Nos lag Where lag.IntCode = (tmp.IntCode - 1)) LagValue
								From #Eps_Nos tmp
							) As a Where IsNull(Eps_To, 0) > 0 AND Case When Eps_From = IsNull(LagValue, 0) Then Eps_From + 1 Else Eps_From End <= Eps_To

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
							Where Title_Code = @Process_Title_Code AND @Cur_Episode_From BETWEEN Episode_From AND Episode_To

							Insert InTo #Temp_Syndication_NE(Start_Date, End_Date, Is_Exclusive)
							Select Start_Date, End_Date, Is_Exclusive From #Temp_Syndication_Main Where Is_Exclusive = 'N' ORder By Start_Date ASC
	
							Update t2 Set t2.Group_Code = (
								Select Min(t1.Start_Date) From #Temp_Syndication_NE t1 
								Where 
								t1.Start_Date BETWEEN t2.Start_Date AND t2.End_Date OR
								t1.End_Date BETWEEN t2.Start_Date AND t2.End_Date OR 
								t2.Start_Date BETWEEN t1.Start_Date AND t1.End_Date OR
								t2.End_Date BETWEEN t1.Start_Date AND t1.End_Date
							) From #Temp_Syndication_NE t2

							Insert InTo #Temp_Syndication
							Select * From (
								Select Start_Date, End_Date, Is_Exclusive From #Temp_Syndication_Main Where Is_Exclusive = 'Y'
								Union 
								Select Min(Start_Date) Start_Date, Max(End_Date) End_Date, 'N' From #Temp_Syndication_NE Group By Group_Code
							) As a ORder By Start_Date ASC

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
								Select Top 1 @MaxEndDate = End_Date From #Temp_Syndication ORder By [Start_Date] Desc
								If((datediff(d, @MaxEndDate, @Actual_Right_End_Date)  < 0 OR @MaxEndDate Is Not Null) AND (@MaxEndDate <> isnull(@Actual_Right_End_Date,'')))
								Begin
									Insert InTo #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive)
									Select @Cur_Episode_From, @Cur_Episode_To, DATEADD(d, 1, @MaxEndDate), @Actual_Right_End_Date, 'Y'
								End
		
								Insert InTo #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate,Is_Exclusive)
								Select @Cur_Episode_From, @Cur_Episode_To, Start_Date, End_Date, 'N' From #Temp_Syndication Where Is_Exclusive = 'N'
							End
							
							Delete From #Temp_Avail_Dates Where AvailStartDate > AvailEndDate
							
							Fetch Next From Cur_Process_Eps InTo @Cur_Episode_From, @Cur_Episode_To
						End
						Close Cur_Process_Eps
						Deallocate Cur_Process_Eps

						Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code From #Temp_Avail_Dates tad
						Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date AND IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

						Insert InTo Avail_Dates
						Select Distinct AvailStartDate, AvailEndDate From #Temp_Avail_Dates Where IsNull(Avial_Dates_Code, 0) = 0
						AND (AvailEndDate is null OR AvailEndDate > GetDate())
						
						Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code From #Temp_Avail_Dates tad
						Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date AND IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

						Delete From #Temp_Avail_Dates Where Avial_Dates_Code Is Null

						Truncate Table #Temp_Session_Raw
						Insert InTo #Temp_Session_Raw(Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To)
						Select @Acq_Deal_Code, @Acq_Deal_Rights_Code, a.Avial_Dates_Code, Case When a.Is_Exclusive = 'N' Then 0 Else 1 End, a.Episode_From, a.Episode_To 
						From #Temp_Avail_Dates a Where a.Avial_Dates_Code Not In (
							Select Avial_Dates_Code From #Temp_Session_Raw tsr Where a.Episode_From = tsr.Episode_From AND a.Episode_To = tsr.Episode_To
						)

						Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
						Inner Join Avail_Raw araw On 
						traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
						traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
						traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
						traw.Is_Exclusive = araw.Is_Exclusive AND
						traw.Episode_From = araw.Episode_From AND
						traw.Episode_To = araw.Episode_To
						
						Insert InTo Avail_Raw 
						Select Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 0 From #Temp_Session_Raw 
						Where IsNull(Avail_Raw_Code, 0) = 0

						Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code From #Temp_Session_Raw traw
						Inner Join Avail_Raw araw On 
						traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
						traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
						traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
						traw.Is_Exclusive = araw.Is_Exclusive AND
						traw.Episode_From = araw.Episode_From AND
						traw.Episode_To = araw.Episode_To AND 
						IsNull(traw.Avail_Raw_Code, 0) = 0
						
						Create Table #Temp_Batch_N(
							Avail_Acq_Show_Code Numeric(38,0), 
							Avail_Raw_Code Numeric(38,0), 
							Is_Title_Language bit, 
							Sub_Language_Codes VARCHAR(Max), 
							Dub_Language_Codes VARCHAR(Max),
							Sub_Avail_Lang_Code Numeric(38, 0), 
							Dub_Avail_Lang_Code Numeric(38, 0)
						)

						--Select * From #Temp_Avail_Dates
						If Exists(Select Top 1 * From #Temp_Avail_Dates)
						Begin

							Declare @Is_Tit_Language bit = 0, @Sub_Lang VARCHAR(Max) = '', @Dub_Lung VARCHAR(Max) = ''

							If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'T')
							Begin

								If(@Is_Title_Language_Right = 'Y')
								Begin
									--------------- INTERNATIONAL
			
									--Insert InTo Avail_Acq_Show_Det(Avail_Acq_Show_Code, Avail_Raw_Code)
									Insert InTo #Temp_Batch_N(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language)
									Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, 1
									From #TMP_ACQ_DETAILS t 
									Inner Join #Temp_Session_Raw as a On 1 = 1
									Where t.Is_Syn = 'Y' AND Is_Theatrical_Right = 'N' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
										  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To
										  --AND t.Avail_Acq_Show_Code = 1010659
				--return
									Print 'AD 32 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

									--------------- End
								End
							End
					
							If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'S')
							Begin
								--------------- INTERNATIONAL

								--Insert InTo Avail_Acq_Show_Lang(Avail_Acq_Show_Code, Avail_Raw_Code, Language_Code)
								Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									   t.Language_Code InTo #Temp_Sub_New
								From #TMP_Acq_SUBTITLING t
								Inner Join #Temp_Session_Raw as a On 1 = 1
								Where t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
									  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To

								MERGE INTO #Temp_Batch_N AS tb
								Using (
									Select *, 
									STUFF(
										(
											SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
												SELECT Distinct Language_Code From #Temp_Sub_New subIn
												Where subIn.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code AND subIn.Avail_Raw_Code = a.Avail_Raw_Code
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

								Print 'AD 34 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

								--------------- END
						
							End
					
							If Exists(Select Top 1 * From #Temp_Batch Where Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'D')
							Begin
						
								-------------- INTERNATIONAL

								--Insert InTo Avail_Acq_Show_Dub(Avail_Acq_Show_Code, Avail_Raw_Code, Language_Code)
								--Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, t.Language_Code
								--From #TMP_Acq_DUBBING t 
								--Inner Join #Temp_Session_Raw as a On 1 = 1
								--Where t.Is_Syn = 'Y' AND Is_Theatrical_Right = 'N' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
								--	  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To

								Select t.Avail_Acq_Show_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									   t.Language_Code InTo #Temp_Dub_New
								From #TMP_Acq_DUBBING t
								Inner Join #Temp_Session_Raw as a On 1 = 1
								Where t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
									  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To

								MERGE INTO #Temp_Batch_N AS tb
								Using (
									Select *, 
									STUFF(
										(
											SELECT Distinct ',' + CAST(Language_Code AS VARCHAR) FROM (
												SELECT Distinct Language_Code From #Temp_Dub_New subIn
												Where --subIn.Episode_From = a.Episode_From AND subIn.Episode_To = a.Episode_To AND
												subIn.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code AND subIn.Avail_Raw_Code = a.Avail_Raw_Code
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
								Print 'AD 36 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

								-------------- End
		
							End

							Update #Temp_Batch_N Set Sub_Language_Codes = ',' + Sub_Language_Codes + ',' Where IsNull(Sub_Language_Codes, '') <> ''
							Update #Temp_Batch_N Set Dub_Language_Codes = ',' + Dub_Language_Codes + ',' Where IsNull(Dub_Language_Codes, '') <> ''

							Insert InTo Avail_Languages(Language_Codes)
							Select Distinct Sub_Language_Codes From #Temp_Batch_N Where Sub_Language_Codes Not In (
								Select a.Language_Codes From Avail_Languages a
							) AND IsNull(Sub_Language_Codes, '') <> ''

							Update temp set temp.Sub_Avail_Lang_Code = al.Avail_Languages_Code From #Temp_Batch_N temp 
							Inner Join Avail_Languages al On temp.Sub_Language_Codes = al.Language_Codes

							
							Insert InTo Avail_Languages(Language_Codes)
							Select Distinct Dub_Language_Codes From #Temp_Batch_N Where Dub_Language_Codes Not In (
								Select a.Language_Codes From Avail_Languages a
							) AND IsNull(Dub_Language_Codes, '') <> ''

							Update temp set temp.Dub_Avail_Lang_Code = al.Avail_Languages_Code From #Temp_Batch_N temp 
							Inner Join Avail_Languages al On temp.Dub_Language_Codes = al.Language_Codes

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

			Print 'AD 38 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code As VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
			IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
			IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
			IF OBJECT_ID('tempdb..#TEMPAcqDetNew') IS NOT NULL DROP TABLE #TEMPAcqDetNew
			IF OBJECT_ID('tempdb..#Syn_Subtitling') IS NOT NULL DROP TABLE #Syn_Subtitling
			IF OBJECT_ID('tempdb..#Syn_Dubbing') IS NOT NULL DROP TABLE #Syn_Dubbing
			IF OBJECT_ID('tempdb..#Syn_Data') IS NOT NULL DROP TABLE #Syn_Data
			IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data
			--DROP TABLE #Syn_Sub_Avail_Data
			--DROP TABLE #Syn_Dub_Avail_Data

			IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL Drop Table #Temp_Syndication
			IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL Drop Table #Temp_Syndication_Main
			IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL Drop Table #Temp_Syndication_NE
			IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL Drop Table #Temp_Avail_Dates
			IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL Drop Table #Temp_Batch
			IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL Drop Table #TMP_ACQ_DETAILS
			IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL Drop Table #TMP_Acq_SUBTITLING
			IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL Drop Table #TMP_Acq_DUBBING
			IF OBJECT_ID('tempdb..#Syn_Rights') IS NOT NULL Drop Table #Syn_Rights
			--Drop Table #Eps_Nos

		End
		
		IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
		IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
		IF OBJECT_ID('tempdb..#TEMPAcqDetNew') IS NOT NULL DROP TABLE #TEMPAcqDetNew
		IF OBJECT_ID('tempdb..#Syn_Subtitling') IS NOT NULL DROP TABLE #Syn_Subtitling
		IF OBJECT_ID('tempdb..#Syn_Dubbing') IS NOT NULL DROP TABLE #Syn_Dubbing
		IF OBJECT_ID('tempdb..#Syn_Data') IS NOT NULL DROP TABLE #Syn_Data
		IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data
		--DROP TABLE #Syn_Sub_Avail_Data
		--DROP TABLE #Syn_Dub_Avail_Data

		IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL Drop Table #Temp_Syndication
		IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL Drop Table #Temp_Syndication_Main
		IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL Drop Table #Temp_Syndication_NE
		IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL Drop Table #Temp_Avail_Dates
		IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL Drop Table #Temp_Batch
		IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL Drop Table #TMP_ACQ_DETAILS
		IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL Drop Table #TMP_Acq_SUBTITLING
		IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL Drop Table #TMP_Acq_DUBBING
		IF OBJECT_ID('tempdb..#Syn_Rights') IS NOT NULL Drop Table #Syn_Rights
		--Drop Table #Eps_Nos
		--DROP TABLE #Temp_Session_Raw
		--DROP Table #Process_Rights
		--DROP Table #Temp_Session_Raw_Lang

		Truncate Table #Temp_Session_Raw
		Truncate Table #Temp_Session_Raw_Lang

		Fetch From CUR_Rights InTo @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	End
	Close CUR_Rights
	Deallocate CUR_Rights

	Drop Table #Temp_Session_Raw
	Drop Table #Temp_Session_Raw_Lang
	Drop Table #Process_Rights

	If(@RecORd_Type = 'S')
	Begin

		PRINT 'AD SYN 1'

		Delete From Avail_Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @RecORd_Code
		
		PRINT 'AD SYN 2'

		Insert InTo Avail_Syn_Acq_Mapping(Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
		Select Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
		From Syn_Acq_Mapping Where Syn_Deal_Rights_Code = @RecORd_Code

		PRINT 'AD SYN 3'

	End

	--END TRY  
	--BEGIN CATCH

	--	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;

	--END CATCH
End

