ALTER PROC [dbo].[USP_Validate_Rights_Duplication_UDT_Syn]
AS
BEGIN 
	IF((SELECT COUNT(*) From Syn_Deal_Rights_Process_Validation WHERE STATUS = 'W') = 0)
	BEGIN
		SET NOCOUNT ON;
		DECLARE @IS_PUSH_BACK_SAME_DEAL CHAR(1) ='N', @Is_Autopush CHAR(1) = 'N'
		SELECT @IS_PUSH_BACK_SAME_DEAL  = Parameter_Value from System_Parameter_New WHERE Parameter_Name = 'VALIDATE_PUSHBACK_SAME_DEAL'
		

		DECLARE @Syn_Deal_Rights_Code INT
		Select Top 1 @Syn_Deal_Rights_Code = Syn_Deal_Rights_Code From Syn_Deal_Rights_Process_Validation Where Status = 'P' Order By Created_On ASC

		--Select @Is_Autopush = Is_Auto_Push from RightsU_Broadcast.dbo.Acq_Deal where Acq_Deal_Code IN (
		--Select SecondaryDataCode From AcqPreReqMappingData APRMD 
		--INNER JOIN  Syn_Deal_Rights SDR ON SDR.Syn_Deal_Code = APRMD.PrimaryDataCode AND SDR.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		--Where APRMD.PrimaryDataCode = SDR.Syn_Deal_Code AND APRMD.MappingFor = 'ACQDEAL'
		--) 

		UPDATE Syn_Deal_Rights_Process_Validation SET STATUS = 'W' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Status = 'P' 
		UPDATE Syn_Deal_Rights Set Right_Status = 'W' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		DELETE FROM Syn_Deal_Rights_Error_Details WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

		IF EXISTS (SELECT * FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Right_Type = 'M')
		BEGIN
			UPDATE Syn_Deal_Rights SET Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			UPDATE Syn_Deal_Rights_Process_Validation SET Status = 'D' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			RETURN;
		END

		BEGIN TRY
		
			Begin  /* Drop Temp Tables, if exists */
				If OBJECT_ID('tempdb..#Temp_Acq_Dubbing') Is Not Null
				Begin
					Drop Table #Temp_Acq_Dubbing
				End
				If OBJECT_ID('tempdb..#NA_Dubbing') Is Not Null
				Begin
					Drop Table #NA_Dubbing
				End
				If OBJECT_ID('tempdb..#ApprovedAcqData') Is Not Null
				Begin
					Drop Table #ApprovedAcqData
				End
				If OBJECT_ID('tempdb..#TempCombination') Is Not Null
				Begin
					Drop Table #TempCombination
				End
				If OBJECT_ID('tempdb..#TempCombination_Session') Is Not Null
				Begin
					Drop Table #TempCombination_Session
				End
				If OBJECT_ID('tempdb..#Temp_Tit_Right') Is Not Null
				Begin
					Drop Table #Temp_Tit_Right
				End
				If OBJECT_ID('tempdb..#Temp_Episode_No') Is Not Null
				Begin
					Drop Table #Temp_Episode_No
				End
				If OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') Is Not Null
				Begin
					Drop Table #Deal_Right_Title_WithEpsNo
				End
				If OBJECT_ID('tempdb..#Temp_Syn_Dup_Records') Is Not Null
				Begin
					Drop Table #Temp_Syn_Dup_Records
				End
				If OBJECT_ID('tempdb..#Temp_Exceptions') Is Not Null
				Begin
					Drop Table #Temp_Exceptions
				End
				If OBJECT_ID('tempdb..#Acq_Titles_With_Rights') Is Not Null
				Begin
					Drop Table #Acq_Titles_With_Rights
				End
				If OBJECT_ID('tempdb..#Acq_Titles') Is Not Null
				Begin
					Drop Table #Acq_Titles
				End
				If OBJECT_ID('tempdb..#Title_Not_Acquire') Is Not Null
				Begin
					Drop Table #Title_Not_Acquire
				End
				If OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') Is Not Null
				Begin
					Drop Table #Acq_Avail_Title_Eps
				End
				If OBJECT_ID('tempdb..#Temp_Country') Is Not Null
				Begin
					Drop Table #Temp_Country
				End
				If OBJECT_ID('tempdb..#Temp_Platforms') Is Not Null
				Begin
					Drop Table #Temp_Platforms
				End
				If OBJECT_ID('tempdb..#Acq_Country') Is Not Null
				Begin
					Drop Table #Acq_Country
				End
				If OBJECT_ID('tempdb..#Temp_Country') Is Not Null
				Begin
					Drop Table #Temp_Country
				End				
				If OBJECT_ID('tempdb..#Temp_Acq_Platform') Is Not Null
				Begin
					Drop Table #Temp_Acq_Platform
				End
				If OBJECT_ID('tempdb..#Temp_Acq_Country') Is Not Null
				Begin
					Drop Table #Temp_Acq_Country
				End
				If OBJECT_ID('tempdb..#NA_Country') Is Not Null
				Begin
					Drop Table #NA_Country
				End				
				If OBJECT_ID('tempdb..#Temp_Subtitling') Is Not Null
				Begin
					Drop Table #Temp_Subtitling
				End
				If OBJECT_ID('tempdb..#Temp_Acq_Subtitling') Is Not Null
				Begin
					Drop Table #Temp_Acq_Subtitling
				End
				If OBJECT_ID('tempdb..#Acq_Sub') Is Not Null
				Begin
					Drop Table #Acq_Sub
				End				
				If OBJECT_ID('tempdb..#NA_Subtitling') Is Not Null
				Begin
					Drop Table #NA_Subtitling
				End
				If OBJECT_ID('tempdb..#Temp_Dubbing') Is Not Null
				Begin
					Drop Table #Temp_Dubbing
				End
				If OBJECT_ID('tempdb..#Temp_NA_Title') Is Not Null
				Begin
					Drop Table #Temp_NA_Title
				End
				If OBJECT_ID('tempdb..#Acq_Dub') Is Not Null
				Begin
					Drop Table #Acq_Dub
				End
				If OBJECT_ID('tempdb..#Acq_Deal_Rights') Is Not Null
				Begin
					Drop Table #Acq_Deal_Rights
				End
				If OBJECT_ID('tempdb..#Min_Right_Start_Date') Is Not Null
				Begin
					Drop Table #Min_Right_Start_Date
				End
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Subtitling
				End
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Dubbing
				End
				
				If OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') Is Not Null
				Begin
					Drop Table #Syn_Rights_Code_Lang
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Title') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Title
				End	
				
				 If OBJECT_ID('tempdb..#Syn_Deal_Rights_Platform') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Platform 
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights
				End	
				 If OBJECT_ID('tempdb..#Syn_Deal_Rights_Territory') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Territory
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Subtitling
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Dubbing
				End	
				If OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') Is Not Null
				Begin
					Drop Table #Syn_Rights_Code_Lang
				End	
				If OBJECT_ID('tempdb..#Syn_RIGHTS_NEW') Is Not Null
				Begin
					Drop Table #Syn_RIGHTS_NEW
				End	

				IF OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL
					DROP TABLE #TempPromoter

				IF OBJECT_ID('TEMPDB..#Dup_Records_Language') IS NOT NULL
					DROP TABLE #Dup_Records_Language

				IF OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL
					DROP TABLE #TempPromoter

				IF OBJECT_ID('TEMPDB..#AcqPromoter') IS NOT NULL
					DROP TABLE #AcqPromoter

				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_TL') IS NOT NULL
					DROP TABLE #TempAcqPromoter_TL

				IF OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL
					DROP TABLE #TempPromoter_TL

				IF OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL
					DROP TABLE #NA_Promoter_TL

				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_Sub') IS NOT NULL
					DROP TABLE #TempAcqPromoter_Sub

				IF OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL
					DROP TABLE #TempPromoter_Sub

				IF OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL
					DROP TABLE #NA_Promoter_Sub

				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_Dub') IS NOT NULL
					DROP TABLE #TempAcqPromoter_Dub

				IF OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL
					DROP TABLE #TempPromoter_Dub

				IF OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL
					DROP TABLE #NA_Promoter_Dub
			End

			Begin /* Create Temp Tables*/
				CREATE Table #ApprovedAcqData
				(
					ID Int IDENTITY(1,1),
					Title_Code Int,	
					Episode_No Int,	
					Platform_Code Int,
					Right_Type  CHAR(1),
					Right_Start_Date DATETIME,
					Right_End_Date DATETIME,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description NVARCHAR(MAX)
				)

				CREATE Table #TempCombination
				(
					ID Int IDENTITY(1,1),
					Agreement_No Varchar(1000),
					Title_Code Int,	
					Episode_From Int,
					Episode_To Int,
					Platform_Code Int,
					Right_Type  CHAR(1),
					Right_Start_Date DATETIME,
					Right_End_Date DATETIME,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Promoter_Group_Code		INT,
					Promoter_Remarks_Code	INT,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description NVARCHAR(MAX),
					Sum_of Int,
					Partition_Of Int
				)

				CREATE Table #TempCombination_Session
				(
					ID Int IDENTITY(1,1),
					Agreement_No Varchar(1000),
					Title_Code Int,	
					Episode_From Int,
					Episode_To Int,
					Platform_Code Int,
					Right_Type  CHAR(1),
					Right_Start_Date DATETIME,
					Right_End_Date DATETIME,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Promoter_Group_Code		INT,
					Promoter_Remarks_Code	INT,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description NVARCHAR(MAX),
					Sum_of Int,
					Partition_Of Int,
					MessageUpadated CHAR(1) DEFAULT('N')
				)

				Create Table #Temp_Tit_Right
				(
					Agreement_No Varchar(1000),
					Acq_Deal_Rights_Code Int,
					Title_Code Int,
					Episode_From Int,
					Episode_To Int,
					Platform_Code Int, 
					Right_Type Char(1), 
					Actual_Right_Start_Date DateTime,
					Actual_Right_End_Date DateTime,
					Is_Title_Language_Right Char(1), 
					Country_Code Int, 
					Territory_Type Char(1), 
					Is_Exclusive Char(1),
					Subtitling_Cnt Int,
					Dubbing_Cnt Int,
					Sum_of Int,
					Partition_Of Int
				)

				CREATE Table #Temp_Episode_No
				(
					Episode_No Int
				)

				CREATE Table #Deal_Right_Title_WithEpsNo
				(
					Deal_Rights_Code Int,
					Title_Code Int,
					Episode_No Int,
				)

				CREATE Table #Dup_Records_Language
				(
					[id]						INT,
					[Title_Code]				INT,
					[Platform_Code]				INT,
					[Territory_Code]			INT,
					[Country_Code]				INT,
					[Right_Start_Date]			DATETIME,
					[Right_End_Date]			DATETIME,
					[Right_Type]				VARCHAR (50),
					[Territory_Type]			CHAR (1),
					[Is_Sub_License]			CHAR (1),
					[Is_Title_Language_Right]	CHAR (1),
					[Subtitling_Language]		INT,
					[Dubbing_Language]			INT,
					[Promoter_Group_Code]		INT,
					[Promoter_Remarks_Code]		INT,
					[Deal_Code]					INT,
					[Deal_Rights_Code]			INT,
					[Deal_Pushback_Code]		INT,
					[Agreement_No]				VARCHAR (MAX),
					[ErrorMSG]					VARCHAR (MAX),
					[Episode_From]				INT,
					[Episode_To]				INT,
					[IsPushback]				CHAR (1)      
				)

			End

			Declare @RC Int
			Declare @Deal_Rights_Title Deal_Rights_Title
			Declare @Deal_Rights_Platform Deal_Rights_Platform
			Declare @Deal_Rights_Territory Deal_Rights_Territory
			Declare @Deal_Rights_Subtitling Deal_Rights_Subtitling
			Declare @Deal_Rights_Dubbing Deal_Rights_Dubbing
			Declare @CallFrom char(2)='SR'
			Declare @Debug char(1)='T'
			Declare @Syn_Deal_Code Int = 0

			CREATE TABLE #TempPromoter(
				Promoter_Group_Code		INT,
				Promoter_Remarks_Code	INT,
				Promoter_Parent_Code    INT
			)

			Select @CallFrom = Case When IsNull(Is_Pushback, 'N') = 'N' Then 'SR' Else 'SP' End  From Syn_Deal_Rights  
			Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			Insert InTo @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
			Select  Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To
			From Syn_Deal_Rights_Title 
			Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code --And Title_Code = @Title_Code_Cur

			Insert InTo @Deal_Rights_Platform(Deal_Rights_Code,Platform_Code)
			Select  Syn_Deal_Rights_Code, Platform_Code
			From Syn_Deal_Rights_Platform
			Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code;

			Insert InTo @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
			Select Syn_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code
			From (
				Select Syn_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
				From Syn_Deal_Rights_Territory  
				Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code

			Insert InTo @Deal_Rights_Subtitling(Deal_Rights_Code, Subtitling_Code)
			Select Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				Select Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				From Syn_Deal_Rights_Subtitling
				Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			Insert InTo @Deal_Rights_Dubbing(Deal_Rights_Code, Dubbing_Code)
			Select Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				Select Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				From Syn_Deal_Rights_Dubbing
				Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			INSERT INTO #TempPromoter(Promoter_Group_Code, Promoter_Remarks_Code,  Promoter_Parent_Code)
			SELECT DISTINCT PG.PRomoter_Group_Code, SDRPR.Promoter_Remarks_Code, PG.Parent_Group_Code   FROM Syn_Deal_Rights_Promoter SDRP
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			inner  JOIN Promoter_Group PG ON PG.Parent_Group_Code = SDRPG.Promoter_Group_Code
			WHERE SDRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			UNION
			--INSERT INTO #TempPromoter(Promoter_Group_Code, Promoter_Remarks_Code)
			SELECT DISTINCT SDRPG.Promoter_Group_Code, SDRPR.Promoter_Remarks_Code, PG.Parent_Group_Code  FROM Syn_Deal_Rights_Promoter SDRP
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Promoter_Group PG ON PG.Promoter_Group_Code = SDRPG.Promoter_Group_Code
			WHERE SDRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			delete from #TempPromoter
			where Promoter_Parent_Code IN(select Promoter_Group_Code from #TempPromoter)

			Declare @Right_Start_Date DATETIME,
				@Right_End_Date DATETIME,
				@Right_Type CHAR(1),
				@Is_Exclusive CHAR(1),
				@Is_Title_Language_Right CHAR(1),
				@Is_Sub_License CHAR(1),
				@Is_Tentative CHAR(1),
				@Sub_License_Code Int,
				@Deal_Rights_Code Int,
				@Deal_Pushback_Code Int,
				@Deal_Code Int,
				@Title_Code Int,
				@Platform_Code Int,
				@Is_Theatrical_Right CHAR(1),
				@Is_Error Char(1) = 'N'

			-- Assign Values To Local Variable 
			Select 
				@Deal_Code=dr.Syn_Deal_Code,
				@Deal_Rights_Code = Syn_Deal_Rights_Code, 
				@Deal_Pushback_Code = Case When @CallFrom = 'SP' Then dr.Syn_Deal_Rights_Code Else 0 End,
				@Right_Start_Date=dr.Right_Start_Date,
				@Right_End_Date=dr.Right_End_Date,
				@Right_Type=dr.Right_Type,
				@Is_Exclusive=dr.Is_Exclusive,
				@Is_Tentative=dr.Is_Tentative,
				@Is_Sub_License=dr.Is_Sub_License,
				@Sub_License_Code=dr.Sub_License_Code,
				@Is_Title_Language_Right=dr.Is_Title_Language_Right,	
				@Title_Code=0,
				@Platform_Code=0,
				@Is_Theatrical_Right=IsNull(dr.Is_Theatrical_Right,'N')
			From Syn_Deal_Rights dr Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			-- Start Abhay's code 
			Truncate Table #Temp_Episode_No
			Truncate Table #Deal_Right_Title_WithEpsNo

			Declare @StartNum Int, @EndNum Int
			Select @StartNum = MIN(Episode_FROM), @EndNum = MAX(Episode_To) From @Deal_Rights_Title;
			
			With gen As (
				Select @StartNum As num Union All
				Select num+1 From gen Where num + 1 <= @EndNum
			)

			Insert InTo #Temp_Episode_No
			Select * From gen
			Option (maxrecursion 10000)

			Insert InTo #Deal_Right_Title_WithEpsNo(Deal_Rights_Code, Title_Code, Episode_No)
			Select Deal_Rights_Code,Title_Code, Episode_No 
			From (
				Select Distinct t.Deal_Rights_Code,t.Title_Code, a.Episode_No 
				From #Temp_Episode_No A 
				Cross Apply @Deal_Rights_Title T 
				Where A.Episode_No Between T.Episode_FROM And T.Episode_To
			) As B 
			-- End Abhay's code
		
			Declare @Count_SubTitle Int = 0, @Count_Dub Int = 0
			Delete From @Deal_Rights_Subtitling Where Subtitling_Code = 0
			Delete From @Deal_Rights_Dubbing Where Dubbing_Code = 0

			If((Select COUNT(IsNull(Subtitling_Code,0)) From @Deal_Rights_Subtitling)>0)
			Begin
				Set @Count_SubTitle = 1
			End
			If((Select COUNT(IsNull(Dubbing_Code,0)) From @Deal_Rights_Dubbing)>0)
			Begin
				Set @Count_Dub = 1
			End
		
			Select ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,
					Is_Exclusive, ADR.Acq_Deal_Code, AD.Agreement_No,
					(Select Count(*) From Acq_Deal_Rights_Subtitling a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) SubCnt, 
					(Select Count(*) From Acq_Deal_Rights_Dubbing a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) DubCnt,
				   	Sum(                        
						Case 
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							When (@Right_Start_Date < ADR.Actual_Right_Start_Date) And (@Right_End_Date > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date))
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							Else 0 
						End
					)Sum_of,
					Sum(
						Case 
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
							When (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							When (@Right_Start_Date < ADR.Actual_Right_Start_Date) And (@Right_End_Date > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							Else 0 
						End
					)
					OVER(
						PARTITION BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code
					) Partition_Of
					InTo #Acq_Deal_Rights
			From Acq_Deal_Rights ADR
			Inner Join Acq_Deal AD On ADR.Acq_Deal_Code = ad.Acq_Deal_Code And IsNull(AD.Deal_Workflow_Status,'') = 'A'
			Where 
			ADR.Acq_Deal_Code Is Not Null
			And ADR.Is_Sub_License='Y'
			And ADR.Is_Tentative='N'
			And
			(
				(
					ADR.Right_Type ='Y' AND
					(
						(CONVERT(DATETIME, @Right_Start_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And Convert(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, @Right_End_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And CONVERT(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_Start_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_End_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103))
					)
				)OR(ADR.Right_Type ='U'  OR ADR.Right_Type ='M')
			) AND (    
				(ADR.Is_Title_Language_Right = @Is_Title_Language_Right) OR 
				(@Is_Title_Language_Right <> 'Y' And ADR.Is_Title_Language_Right = 'Y') OR 
				(@Is_Title_Language_Right = 'Y' And ADR.Is_Title_Language_Right = 'N')
			) AND (
				(@Is_Exclusive = 'Y' And IsNull(ADR.Is_exclusive,'')='Y') OR @Is_Exclusive = 'N'
			) 
			GROUP BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code, AD.Agreement_No
			Begin ----------------- CHECK TITLE WITH EPISODE EXISTS OR NOT

				Select Distinct ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADR.SubCnt, ADR.DubCnt,
								ADR.Sum_of, ADR.Partition_Of
				InTo #Acq_Titles_With_Rights
				From #Acq_Deal_Rights ADR
				Inner Join dbo.Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
				Inner Join @Deal_Rights_Title drt On ADRT.Title_Code = drt.Title_Code And (
					(drt.Episode_From Between ADRT.Episode_From And ADRT.Episode_To)
					Or
					(drt.Episode_To Between ADRT.Episode_From And ADRT.Episode_To)
					Or
					(ADRT.Episode_From Between drt.Episode_From And drt.Episode_To)
					Or
					(ADRT.Episode_To Between drt.Episode_From And drt.Episode_To)
				)
				Select Distinct Title_Code, Episode_From, Episode_To InTo #Acq_Titles From #Acq_Titles_With_Rights

				Select Title_Code, Episode_No InTo #Acq_Avail_Title_Eps
				From (
					Select Distinct t.Title_Code, a.Episode_No 
					From #Temp_Episode_No A 
					Cross Apply #Acq_Titles T 
					Where A.Episode_No Between T.Episode_FROM And T.Episode_To
				) As B 

				Select ROW_NUMBER() Over(Order By Title_Code, Episode_No Asc) RowId, * InTo #Title_Not_Acquire From #Deal_Right_Title_WithEpsNo deps
				Where deps.Episode_No Not In (
					Select Episode_No From #Acq_Avail_Title_Eps aeps Where deps.Title_Code = aeps.Title_Code
				)

				Drop Table #Acq_Avail_Title_Eps
				
				Create Table #Temp_NA_Title(
					Title_Code Int,
					Episode_From Int,
					Episode_To Int,
					Status Char(1)
				)

				Declare @Cur_Title_code Int = 0, @Cur_Episode_No Int = 0, @Prev_Title_Code Int = 0, @Prev_Episode_No Int
				Declare CUS_EPS Cursor For 
					Select Title_code, Episode_No From #Title_Not_Acquire Order By Title_code Asc, Episode_No  Asc
				Open CUS_EPS
				Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
				While(@@FETCH_STATUS = 0)
				Begin
	
					If(@Cur_Title_code <> @Prev_Title_Code)
					Begin

						If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
						Begin
							Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
						End

						Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
						Select @Cur_Title_code, @Cur_Episode_No, 'U'
						Set @Prev_Title_Code = @Cur_Title_code
					End
					Else If(@Cur_Title_code = @Prev_Title_Code And @Cur_Episode_No <> (@Prev_Episode_No + 1))
					Begin
						If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Cur_Title_code)
						Begin
							Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Cur_Title_code
						End
		
						Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
						Select @Cur_Title_code, @Cur_Episode_No, 'U'
					End
	
					Set @Prev_Episode_No = @Cur_Episode_No

					Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
				End
				Close CUS_EPS
				Deallocate CUS_EPS

				Drop Table #Title_Not_Acquire

				If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
				Begin
					Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
				End

				If Exists(Select Top 1 * From #Temp_NA_Title)
				Begin
					Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
																Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name, Subtitling_Language, 
																Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On,IsPushback)
					Select @Syn_Deal_Rights_Code, t.Title_Name, 'NA', Null, Null, 
							'NA', 'NA', 'NA', 'NA', 'NA', 
							'NA', 'NA', 'Title not acquired', Episode_From, Episode_To, GETDATE(), Null
					From #Temp_NA_Title tnt
					Inner Join Title t On tnt.Title_Code = t.Title_Code

					Drop Table #Temp_NA_Title

					Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					Set @Is_Error = 'Y'
				End
				--Else
				--Begin
				--	Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				--End

			End ------------------------------ END

			Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
				InTo #Temp_Platforms
				From #Acq_Titles DRT
				Inner Join @Deal_Rights_Platform DRP On 1 = 1

				Drop Table #Acq_Titles

				Select art.*, adrp.Platform_Code InTo #Temp_Acq_Platform From #Acq_Titles_With_Rights art
				Inner Join Acq_Deal_Rights_Platform adrp On adrp.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
				Inner Join @Deal_Rights_Platform drp On adrp.Platform_Code = drp.Platform_Code

				Drop Table #Acq_Titles_With_Rights

				Delete From #Temp_Acq_Platform Where Platform_Code Not In (Select Platform_Code From #Temp_Platforms)

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms
				From #Temp_Platforms DRT
				Where DRT.Platform_Code Not In (
					Select ap.Platform_Code From #Temp_Acq_Platform ap
					Where DRT.Title_Code = ap.Title_Code And DRT.Episode_From = ap.Episode_From And DRT.Episode_To = ap.Episode_To
				)

				Delete From #Temp_Platforms Where #Temp_Platforms.Platform_Code In (
					Select np.Platform_Code From #NA_Platforms np
					Where np.Title_Code = #Temp_Platforms.Title_Code And np.Episode_From = #Temp_Platforms.Episode_From And np.Episode_To = #Temp_Platforms.Episode_To
				)

				Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, 0, '', 
					   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Platform not acquired', @Is_Title_Language_Right 
				From #NA_Platforms np

				Drop Table #NA_Platforms

			End ------------------------------ END
						
			Begin ----------------- CHECK COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
			
				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country
				From #Temp_Platforms tp
				Inner Join @Deal_Rights_Territory TC On 1 = 1

				Drop Table #Temp_Platforms

				Declare @Thetrical_Platform_Code Int = 0, @Domestic_Country Int = 0
				Select @Thetrical_Platform_Code = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
				Select @Domestic_Country = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'INDIA_COUNTRY_CODE'

				If Exists(Select Top 1 * From #Temp_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country)
				Begin
				
					Insert InTo #Temp_Country
					Select tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code
					From (
						Select * From #Temp_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
					) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

					Delete From #Temp_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country

				End
		

				Select Acq_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Acq_Country
				From (
					Select Acq_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
					From Acq_Deal_Rights_Territory  
					Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
				) srter
				Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code


				Select tap.*, adc.Country_Code InTo #Temp_Acq_Country From #Temp_Acq_Platform tap
				Inner Join #Acq_Country adc On tap.Acq_Deal_Rights_Code = adc.Acq_Deal_Rights_Code

				Drop Table #Acq_Country
				Drop Table #Temp_Acq_Platform

				If Exists(Select Top 1 * From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country)
				Begin
				
					Insert InTo #Temp_Acq_Country(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Sum_of, partition_of)
					Select tp.Acq_Deal_Rights_Code, tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code,tp.Sum_of, tp.partition_of
					From (
						Select * From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
					) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

					Delete From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country

				End
			
				Delete From #Temp_Acq_Country Where Country_Code Not In (Select Country_Code From #Temp_Country)

				Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NA_Country
				From #Temp_Country DRC
				Where DRC.Country_Code Not In (
					Select ac.Country_Code From #Temp_Acq_Country ac
					Where DRC.Title_Code = ac.Title_Code And DRC.Episode_From = ac.Episode_From And DRC.Episode_To = ac.Episode_To And DRC.Platform_Code = ac.Platform_Code
				)

				Delete From #Temp_Country Where #Temp_Country.Country_Code In (
					Select np.Country_Code From #NA_Country np
					Where np.Title_Code = #Temp_Country.Title_Code And np.Episode_From = #Temp_Country.Episode_From 
						  And np.Episode_To = #Temp_Country.Episode_To And np.Platform_Code = #Temp_Country.Platform_Code
				)
			
				Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Region not acquired', @Is_Title_Language_Right 
				From #NA_Country np

				Drop Table #NA_Country

				If(@Is_Title_Language_Right = 'Y')
				Begin
					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														 Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, 0, 0,
						'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Country T
				End

				
				INSERT INTO #TempCombination
				(
					Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
					Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
					Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
				)
				SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
					ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
					0, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
				FROM #Temp_Acq_Country ac 
				Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
				Where ADR.Is_Title_Language_Right = 'Y'
			End ------------------------------ END

			Begin ----------------- CHECK SUBTITLING And COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Subtitling_Code
				InTo #Temp_Subtitling
				From #Temp_Country tp
				Inner Join @Deal_Rights_Subtitling ts On 1 = 1

				If Exists(Select Top 1 * From @Deal_Rights_Subtitling)
				Begin

					Select Acq_Deal_Rights_Code, Case When sub.Language_Type = 'G' Then lgd.Language_Code Else sub.Language_Code End Language_Code 
					InTo #Acq_Sub From (
						Select Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
						From Acq_Deal_Rights_Subtitling adrs 
						Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					)As sub
					Left Join Language_Group_Details lgd On sub.Language_Group_Code = lgd.Language_Group_Code 

					Delete From #Acq_Sub Where Language_Code Not In (Select Subtitling_Code From @Deal_Rights_Subtitling)

					Select tac.*, adrs.Language_Code InTo #Temp_Acq_Subtitling From #Temp_Acq_Country tac
					Inner Join #Acq_Sub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 

					Drop Table #Acq_Sub
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Subtitling_Code InTo #NA_Subtitling
					From #Temp_Subtitling DRC
					Where DRC.Subtitling_Code Not In (
						Select asub.Language_Code From #Temp_Acq_Subtitling asub
						Where DRC.Title_Code = asub.Title_Code And DRC.Episode_From = asub.Episode_From And DRC.Episode_To = asub.Episode_To 
						And DRC.Platform_Code = asub.Platform_Code And DRC.Country_Code = asub.Country_Code
					)
					
					Delete From #Temp_Subtitling Where #Temp_Subtitling.Subtitling_Code In (
						Select asub.Subtitling_Code From #NA_Subtitling asub
						Where #Temp_Subtitling.Title_Code = asub.Title_Code And #Temp_Subtitling.Episode_From = asub.Episode_From And #Temp_Subtitling.Episode_To = asub.Episode_To 
						And #Temp_Subtitling.Platform_Code = asub.Platform_Code And #Temp_Subtitling.Country_Code = asub.Country_Code
					)

					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
					From #NA_Subtitling nsub
					
					Drop Table #NA_Subtitling

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														 Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, Subtitling_Code, 0,
						'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Subtitling T

					INSERT INTO #TempCombination
					(
						Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
						Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
						Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
					)
					SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
						ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
						Language_Code, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
					FROM #Temp_Acq_Subtitling ac 
					Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
				End
				Else
				Begin
					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
					From #Temp_Subtitling nsub

				End
			End ------------------------------ END
				
			Begin ----------------- CHECK DUBBING And COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT

				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Dubbing_Code
				InTo #Temp_Dubbing
				From #Temp_Country tp
				Inner Join @Deal_Rights_Dubbing ts On 1 = 1

				If Exists(Select Top 1 * From @Deal_Rights_Dubbing)
				Begin

					Select Acq_Deal_Rights_Code, Case When dub.Language_Type = 'G' Then lgd.Language_Code Else dub.Language_Code End Language_Code InTo #Acq_Dub
					From (
						Select Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
						From Acq_Deal_Rights_Dubbing
						Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					)As dub
					Left Join Language_Group_Details lgd On dub.Language_Group_Code = lgd.Language_Group_Code 
					
					Delete From #Acq_Dub Where Language_Code Not In (Select Dubbing_Code From @Deal_Rights_Dubbing)

					Select tac.*, adrs.Language_Code InTo #Temp_Acq_Dubbing From #Temp_Acq_Country tac
					Inner Join #Acq_Dub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 

					Drop Table #Acq_Dub
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Dubbing_Code InTo #NA_Dubbing
					From #Temp_Dubbing DRC
					Where DRC.Dubbing_Code Not In (
						Select adub.Language_Code From #Temp_Acq_Dubbing adub
						Where DRC.Title_Code = adub.Title_Code And DRC.Episode_From = adub.Episode_From And DRC.Episode_To = adub.Episode_To 
						And DRC.Platform_Code = adub.Platform_Code And DRC.Country_Code = adub.Country_Code
					)

					Delete From #Temp_Dubbing Where #Temp_Dubbing.Dubbing_Code In (
						Select adub.Dubbing_Code From #NA_Dubbing adub
						Where #Temp_Dubbing.Title_Code = adub.Title_Code And #Temp_Dubbing.Episode_From = adub.Episode_From And #Temp_Dubbing.Episode_To = adub.Episode_To 
						And #Temp_Dubbing.Platform_Code = adub.Platform_Code And #Temp_Dubbing.Country_Code = adub.Country_Code
					)
					
					
					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
					From #NA_Dubbing nsub
					
					Drop Table #NA_Dubbing

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														 Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, 0, Dubbing_Code,
						'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Dubbing T

					INSERT INTO #TempCombination
					(
						Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
						Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
						Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
					)
					SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
						ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
						0, ac.Language_Code, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
					FROM #Temp_Acq_Dubbing ac 
					Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
				End
				Else
				Begin
				
					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
					From #Temp_Dubbing nsub

				End
			End ------------------------------ END
			
			IF(OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL)
			BEGIN /*Check Promoter with Subtitle / Dubbing, Country, Platform, Title and Episode*/
				IF EXISTS (SELECT TOP 1 * FROM #TempPromoter)
				BEGIN

					
					select a.Acq_Deal_Rights_Code, a.Promoter_Group_Code, a.Promoter_Remarks_Code, a.Is_Title_Language_Right, a.SelectedInSyn
					into #AcqPromoter from (
					SELECT ADRP.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code, PG.Promoter_Group_Code AS Promoter_Group_Code, ADRPR.Promoter_Remarks_Code AS Promoter_Remarks_Code, 
					ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
					FROM Acq_Deal_Rights ADR
					INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Promoter_Group PG ON PG.Parent_Group_Code = ADRPG.Promoter_Group_Code 
					WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					UNION
					SELECT ADRP.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code, ADRPG.Promoter_Group_Code AS Promoter_Group_Code, ADRPR.Promoter_Remarks_Code  AS Promoter_Remarks_Code, 
					ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
					FROM Acq_Deal_Rights ADR
					INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					) as a

					--SELECT ADRP.Acq_Deal_Rights_Code, PG.Promoter_Group_Code, ADRPR.Promoter_Remarks_Code, 
					--ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
					--INTO #AcqPromoter FROM Acq_Deal_Rights ADR
					--INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
					--INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					--INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					--INNER JOIN Promoter_Group PG ON PG.Parent_Group_Code = ADRPG.Promoter_Group_Code 
					--WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code from #Acq_Deal_Rights)

					UPDATE AP SET AP.SelectedInSyn = 'Y' FROM #AcqPromoter AP
					INNER JOIN #TempPromoter SP ON AP.Promoter_Group_Code = SP.Promoter_Group_Code AND AP.Promoter_Remarks_Code = SP.Promoter_Remarks_Code

					DELETE FROM #AcqPromoter WHERE SelectedInSyn <> 'Y'

					/* Start Validation For Promoter with Title Language*/
					IF(@Is_Title_Language_Right = 'Y')
					BEGIN
						SELECT TAC.*, AP.Is_Title_Language_Right, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code 
						INTO #TempAcqPromoter_TL FROM #Temp_Acq_Country TAC
						INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAC.Acq_Deal_Rights_Code --AND AP.Is_Title_Language_Right = 'Y'

						SELECT DISTINCT TC.Title_Code, TC.Episode_From, TC.Episode_To, TC.Platform_Code, TC.Country_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
						INTO #TempPromoter_TL FROM #Temp_Country TC
						INNER JOIN #TempPromoter TP ON 1 = 1


						IF(OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL)
						BEGIN
							SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code,
							TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_TL
							FROM #TempPromoter_TL TP WHERE
							CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
								SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR)
							FROM #TempAcqPromoter_TL TAP
							WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From 
								AND TAP.Episode_To = TP.Episode_To AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code --AND TAP.Is_Title_Language_Right = 'Y'
							)
						END
						
						IF(OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL)
						BEGIN
							INSERT INTO #Dup_Records_Language(
								Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
								Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code
							)
							SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
								0, 0, Promoter_Group_Code, Promoter_Remarks_Code
							FROM #NA_Promoter_TL NPT
						END
					
					END
					/* End Validation For Promoter with Title Language*/
					IF(OBJECT_ID('TEMPDB..#Temp_Subtitling') IS NOT NULL AND OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL) 
					BEGIN 
						/* Start Validation For Promoter with SubTitling*/
						SELECT TAS.*, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code INTO #TempAcqPromoter_Sub
						FROM #Temp_Acq_Subtitling TAS
						INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAS.Acq_Deal_Rights_Code 

						SELECT DISTINCT TS.Title_Code, TS.Episode_From, TS.Episode_To, TS.Platform_Code, TS.Country_Code, TS.Subtitling_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
						INTO #TempPromoter_Sub FROM #Temp_Subtitling TS
						INNER JOIN #TempPromoter TP ON 1 = 1


						IF(OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL)
						BEGIN
							SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code, TP.Subtitling_Code, 
							TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_Sub 
							FROM #TempPromoter_Sub TP WHERE 
							CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
								SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR) 
								FROM #TempAcqPromoter_Sub TAP 
								WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From AND TAP.Episode_To = TP.Episode_To 
								AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code AND TAP.Language_Code = TP.Subtitling_Code
							)
							
							IF(OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL)
							BEGIN
								Insert InTo #Dup_Records_Language(
									Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
									Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code
								)
								Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
									Subtitling_Code, 0, Promoter_Group_Code, Promoter_Remarks_Code
								From #NA_Promoter_Sub NPS
							END
						END
							
					END /* End Validation For Promoter with SubTitling*/
					IF(OBJECT_ID('TEMPDB..#Temp_Dubbing') IS NOT NULL AND OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL) 
					BEGIN 
						/* Start Validation For Promoter with Dubbing*/
						SELECT TAD.*, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code INTO #TempAcqPromoter_Dub
						FROM #Temp_Acq_Dubbing TAD
						INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAD.Acq_Deal_Rights_Code

						SELECT DISTINCT TD.Title_Code, TD.Episode_From, TD.Episode_To, TD.Platform_Code, TD.Country_Code, TD.Dubbing_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
						INTO #TempPromoter_Dub FROM #Temp_Dubbing TD
						INNER JOIN #TempPromoter TP ON 1 = 1

						IF(OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL)
						BEGIN
							SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code, TP.Dubbing_Code,  
							TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_Dub 
							FROM #TempPromoter_Dub TP WHERE 
							CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
								SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR) FROM #TempAcqPromoter_Dub TAP 
								WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From AND TAP.Episode_To = TP.Episode_To 
								AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code AND TAP.Language_Code = TP.Dubbing_Code
							)
							IF(OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL)
							BEGIN
							
								Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
									Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code)
								Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
									0, Dubbing_Code, Promoter_Group_Code, Promoter_Remarks_Code
								From #NA_Promoter_Dub NPD

								--DELETE TP FROM #TempPromoter_Dub TP
								--INNER JOIN #NA_Promoter_Dub NTP ON NTP.Title_Code = TP.Title_Code AND NTP.Episode_From = TP.Episode_From AND NTP.Episode_To = TP.Episode_To 
								--AND NTP.Platform_Code = TP.Platform_Code AND NTP.Country_Code = TP.Country_Code AND NTP.Dubbing_Code = TP.Dubbing_Code
								--AND NTP.Promoter_Group_Code = TP.Promoter_Group_Code AND NTP.Promoter_Remarks_Code = TP.Promoter_Remarks_Code
							END
						END
						
					END
					/* End Validation For Promoter with Dubbing*/
				END
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Country') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Country
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Acq_Subtitling
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Acq_Dubbing
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Subtitling') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Subtitling
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Dubbing') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Dubbing
			END
			
			IF(OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter
			END
			IF(OBJECT_ID('TEMPDB..#AcqPromoter') IS NOT NULL)
			BEGIN
				DROP TABLE #AcqPromoter
			END
			IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_TL') IS NOT NULL)
			BEGIN
				DROP TABLE #TempAcqPromoter_TL
			END
			IF(OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter_TL
			END
			IF(OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL)
			BEGIN
				DROP TABLE #NA_Promoter_TL
			END
			IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_Sub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempAcqPromoter_Sub
			END
			IF(OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter_Sub
			END
			IF(OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL)
			BEGIN
				DROP TABLE #NA_Promoter_Sub
			END
			IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_Dub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempAcqPromoter_Dub
			END
			IF(OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter_Dub
			END
			IF(OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL)
			BEGIN
				DROP TABLE #NA_Promoter_Dub
			END

			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Country') IS NOT NULL)
			BEGIN
				Drop Table #Temp_Acq_Country
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Episode_No') IS NOT NULL)
			BEGIN
				Drop Table #Temp_Episode_No
			END
			IF(OBJECT_ID('TEMPDB..#Deal_Right_Title_WithEpsNo') IS NOT NULL)
			BEGIN
				Drop Table #Deal_Right_Title_WithEpsNo
			END
			IF(OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL)
			BEGIN
				Drop Table #Acq_Deal_Rights
			END

			UPDATE b SET b.Sum_of = (
				SELECT SUM(c.Sum_of) FROM(
					SELECT DISTINCT a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code, 
					a.Dubbing_Language_Code, a.Promoter_Group_Code, a.Promoter_Remarks_Code, a.Sum_of FROM #TempCombination AS a
				) AS c WHERE c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To AND
				c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code And c.Subtitling_Language_Code = b.Subtitling_Language_Code AND 
				c.Dubbing_Language_Code = b.Dubbing_Language_Code AND ISNULL(c.Promoter_Group_Code,0) = ISNULL(b.Promoter_Group_Code,0) AND
				ISNULL(c.Promoter_Remarks_Code,0) = ISNULL(b.Promoter_Remarks_Code,0)
							 
			) From #TempCombination b			

			CREATE TABLE #Min_Right_Start_Date
			(
				Title_Code INT,
				Min_Start_Date DateTime
			)
			
			INSERT INTO #Min_Right_Start_Date
			SELECT T1.Title_Code,MIN(T1.Right_Start_Date) FROM  #TempCombination T1
			GROUP BY T1.Title_Code
			
			IF(@Right_Type ='U' AND EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='U') AND NOT EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='Y'))
			BEGIN				
				DELETE T1 				
				FROM #TempCombination T1 
				INNER JOIN #Min_Right_Start_Date MRSD ON T1.Title_Code = MRSD.Title_Code
				WHERE CONVERT(DATETIME, @Right_Start_Date, 103) < CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)				
			END

			UPDATE t2 Set t2.Is_Available = 'Y'
			FROM #TempCombination_Session t2 
			LEFT join #Min_Right_Start_Date MRSD on T2.Title_Code = MRSD.Title_Code
			Inner Join #TempCombination t1 On 
			T1.Title_Code = T2.Title_Code And 
			T1.Episode_From = T2.Episode_From And 
			T1.Episode_To = T2.Episode_To And 
			T1.Platform_Code = T2.Platform_Code And 
			T1.Country_Code= T2.Country_Code And 
			T1.Subtitling_Language_Code = T2.Subtitling_Language_Code And 
			T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
			AND
			ISNULL(T1.Promoter_Group_Code,'') = ISNULL(T2.Promoter_Group_Code,'') And 
			ISNULL(T1.Promoter_Remarks_Code,'') = ISNULL(T2.Promoter_Remarks_Code,'')
			And 
			(
				(
					(t1.sum_of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End)) OR
					(
						(T1.Right_Type = 'U' OR T2.Right_Type = 'U') AND
						(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, IsNull(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103))
					)
				)OR
				(t1.Partition_Of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End))
			)AND 
			(
				((T1.Right_Type <> 'Y'  AND T1.Right_Type <> 'M') AND T2.Right_Type = 'U') OR
				((T1.Right_Type = 'Y' OR T1.Right_Type = 'M') AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M')) OR
				(T1.Right_Type = 'U' AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M'))
			)
			DROP TABLE #Min_Right_Start_Date

			Update TCS Set TCS.Error_Description = (
				Case 
					When (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code
					) = 0 Then 'TITLE_MISMATCH' Else '' 
				End + 
				Case 
					When (
						Select Count(*) From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
					) = 0 Then 'PLATFORM_MISMATCH' Else '' 
				End +
				Case 
					When (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code 
						AND TC.Platform_Code = TCS.Platform_Code AND TC.Country_Code = TCS.Country_Code
					) = 0 Then 'COUNTRY_MISMATCH' Else '' 
				End +
				Case 
					When TCS.Is_Title_Language_Right = 'Y' AND TCS.Subtitling_Language_Code = 0 AND TCS.Dubbing_Language_Code = 0 AND (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 And 0 = TCS.Dubbing_Language_Code 
						And TCS.Is_Title_Language_Right = TC.Is_Title_Language_Right
					) = 0 Then 'TITLE_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When TCS.Dubbing_Language_Code > 0 AND (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 
						And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code
					) = 0 Then 'DUBBING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When TCS.Subtitling_Language_Code > 0 And (Select Count(*) Title_Code From #TempCombination TC 
								Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
									  And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
									  And 0 = TCS.Dubbing_Language_Code) = 0 
					Then 'SUBTITLING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When (Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
						And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code And (
							( 
								(TCS.sum_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))OR
								(
									(TCS.Right_Type = 'U' OR TC.Right_Type = 'U') AND
									(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, ISNULL(TCS.Right_Start_Date,'') , 103))
								)
							)OR
							(TCS.partition_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))           
						)
					) = 0 Then 'RIGHT_PERIOD' Else '' 
				End
			) FROM #TempCombination_Session TCS
			Where Is_Available='N'
			
			--Select Error_Description, * From #TempCombination_Session Where Title_Code = 5159 And Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired') Where Is_Available='N'
			
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCH', 'Title not acquired') Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'COUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Region not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'SUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'DUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = ' Rights period mismatch' Where Is_Available='N' And Error_Description = ''

			Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			)
			Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					--Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, 'Rights Period Mismatch', Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
					Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, Error_Description, Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
			From #TempCombination_Session nsub Where Is_Available='N'


			Declare @Deal_Type_Code Int = 0, @Deal_Type Varchar(20) = '', @Syn_Error CHAR(1) = 'N'
			Select @Deal_Type_Code = Deal_Type_Code From Syn_Deal Where Syn_Deal_Code = @Deal_Code
			Select @Deal_Type = [dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code)
			
			--IF(ISNULL(@Is_Autopush, 'N') = 'Y')
			--BEGIN
			--	EXEC  [dbo].[USP_Syn_Autopush_Rights_Validation] @Syn_Deal_Rights_Code, @Syn_Error OUTPUT
			--END
			
			--SELECT @Syn_Error 

			If Exists(Select Top 1 * From #Dup_Records_Language)
			Begin

				Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															Promoter_Group_Name,
															Promoter_Remark_DESC,
															ErrorMsg, Episode_From, Episode_To, Inserted_On, IsPushback)
				Select @Syn_Deal_Rights_Code, Title_Name, abcd.Platform_Hiearachy Platform_Name, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
					CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
					CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
					CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
					Country_Name,
					CASE WHEN IsNull(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
					CASE WHEN IsNull(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
					Agreement_No, Promoter_Group_Name, Promoter_Remark_Desc, 
					IsNull(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, Getdate(), 'N'
				From(
					Select *,
					STUFF
					(
						(
						Select ', ' + C.Country_Name From Country C 
						Where c.Country_Code In(
							Select Distinct Country_Code From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						) --And C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
						FOR XML PATH('')), 1, 1, ''
					) as Country_Name,
					STUFF
					(
						(
						Select ',' + CAST(P.Platform_Code as Varchar) 
						From Platform p Where p.Platform_Code In
						(
							Select Distinct Platform_Code From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Platform_Code,
					STUFF
					(
						(
						Select ', ' + l.Language_Name From Language l 
						Where l.Language_Code In(
							Select Distinct Subtitling_Language From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Subtitling_Language,
					STUFF
					(
						(
						Select ', ' + l.Language_Name From Language l 
						Where l.Language_Code In(
							Select Distinct Dubbing_Language From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Dubbing_Language,
					STUFF
					(
						(
						Select ', ' + t.Agreement_No From (
							Select Distinct Agreement_No From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						) As t
						FOR XML PATH('')), 1, 1, ''
					) as Agreement_No
					From (
						Select T.Title_Code,
							DBO.UFN_GetTitleNameInFormat(@Deal_Type, T.Title_Name, Episode_From, Episode_To) AS Title_Name,
							ADR.Right_Start_Date, ADR.Right_End_Date,
							Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To,
							PG.Hierarchy_Name AS Promoter_Group_Name , PR.Promoter_Remark_Desc
						from (
							Select Distinct Title_Code, Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, ErrorMSG, Right_Type, Promoter_Group_Code, Promoter_Remarks_Code
							From #Dup_Records_Language
						) ADR
						INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
						LEFT JOIN Promoter_Remarks PR ON PR.Promoter_Remarks_Code = ADR.Promoter_Remarks_Code
						LEFT JOIN Promoter_Group PG ON PG.Promoter_Group_Code = ADR.Promoter_Group_Code
					) as a
				) as MainOutput
				Cross Apply
				(
					Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
				) as abcd

				Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				Set @Is_Error = 'Y'
			End
			--Else If(@Is_Error = 'N')
			--Begin
			--	UPDATE Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			--End
			
			IF(@Syn_Error = 'Y' OR @Is_Error = 'Y')
			BEGIN
				Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			END
			--ELSE
			--BEGIN
			--	Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			--END

			Drop Table #TempCombination
			Drop Table #TempCombination_Session
			
			Begin  ------------------------ SYNDICATION DUPLICATION VALIDATION

	
				Create Table #Syn_Deal_Rights_Subtitling
				(
					Syn_Deal_Rights_Code int 
					,Language_Type varchar(100)
					,Language_Group_Code int 
					,Language_Code int
				)
			
				Create Table #Syn_Deal_Rights_Dubbing
				(
					Syn_Deal_Rights_Code int 
					,Language_Type varchar(100)
					,Language_Group_Code int 
					,Language_Code int
				)

				Create Table #Syn_Rights_Code_Lang
				(
					Deal_Rights_Code int
				)

				Select SDR.Syn_Deal_Rights_Code, SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Right_Type, SDR.Is_Title_Language_Right, SDR.Syn_Deal_Code,
						(Select Count(*) From Syn_Deal_Rights_Subtitling a Where a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Sub_Cnt,
						(Select Count(*) From Syn_Deal_Rights_Dubbing a Where a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Dub_Cnt, 
						Is_Sub_License, Is_Exclusive, Is_Pushback
						InTo #Syn_Deal_Rights
				From Syn_Deal_Rights SDR
				Where 
				(
					(
						SDR.Right_Type ='Y'
						And
						(
							(
								CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) And Convert(DATETIME, SDR.Actual_Right_End_Date, 103)
							)
							Or
							(
								CONVERT(DATETIME, @Right_End_Date, 103)   BETWEEN 
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) And CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103)
							)
							Or
							(
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) BETWEEN
								CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)
							)
							And
							(
								CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103) BETWEEN 
								CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)
							)
						)
					)
					Or
					(
						(SDR.Right_Type ='U'  And @Right_Type='U')	
						Or
						(
							(SDR.Right_Type ='U' And @Right_Type='Y')
							And
							(					
								CONVERT(DATETIME, @Right_End_Date, 103) >= CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103)				
							)
						)
						Or
						(
							(SDR.Right_Type ='Y'  And @Right_Type='U')					
							And
							(
								CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN 
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) And Convert(DATETIME, SDR.Actual_Right_End_Date, 103)
							)
						)
					)	
				)
				And
				(
					(
						@CallFrom = 'SP' AND (
							IsNull(Is_Pushback, 'N') = 'N' OR (SDR.Syn_Deal_Code = @Deal_Code And @IS_PUSH_BACK_SAME_DEAL = 'Y')
						)
					)
					Or
					(
						(@CallFrom = 'SR')
						And 
						(
							(ISNULL(Is_Exclusive,'N') = 'Y' And @Is_Exclusive ='N')
							Or ((ISNULL(Is_Exclusive,'N') = 'N' Or ISNULL(Is_Exclusive,'N') = 'Y') And @Is_Exclusive ='Y')
							Or SDR.Syn_Deal_Code = @Deal_Code
						)
					)
				)
				And SDR.Syn_Deal_Rights_Code <> @Deal_Rights_Code

				Begin ----------------- CHECK FOR TITLES

					Select SDR.Syn_Deal_Rights_Code
							,SDRT.Title_Code
							,SDRT.Episode_From
							,SDRT.Episode_To 
					InTo #Syn_Deal_Rights_Title 
					From #Syn_Deal_Rights SDR 
					Inner Join Syn_Deal_Rights_Title SDRT on SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
					Where Title_Code in (
						Select Title_Code From @Deal_Rights_Title inTitle
						Where 
							(inTitle.Episode_From Between SDRT.Episode_From And SDRT.Episode_To) 
						Or	(inTitle.Episode_To Between SDRT.Episode_From And SDRT.Episode_To) 
						Or	(SDRT.Episode_From Between inTitle.Episode_From And inTitle.Episode_To) 
						Or  (SDRT.Episode_To Between inTitle.Episode_From And inTitle.Episode_To)
					)

					Delete From #Syn_Deal_Rights Where Syn_Deal_Rights_Code Not In (
						Select Syn_Deal_Rights_Code From #Syn_Deal_Rights_Title
					)
				END ----------------- END

				Begin ----------------- CHECK FOR PLATFORMS
				
					Select DISTINCT SDR.Syn_Deal_Rights_Code 
							,SDRP.Platform_Code 
							into #Syn_Deal_Rights_Platform 
					From #Syn_Deal_Rights_Title SDR 
					Inner Join Syn_Deal_Rights_Platform SDRP on SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					Where Platform_Code in (Select Platform_Code From @Deal_Rights_Platform)

					
					Delete From #Syn_Deal_Rights_Title Where Syn_Deal_Rights_Code not in (
						Select Syn_Deal_Rights_Code From #Syn_Deal_Rights_Platform
					)

					Delete From #Syn_Deal_Rights Where Syn_Deal_Rights_Code not in (
						Select Syn_Deal_Rights_Code From #Syn_Deal_Rights_Title
					)

				End ----------------- END
				
				Begin ----------------- CHECK FOR COUNTRY
				
					select a.Syn_Deal_Rights_Code, a.Country_Code into #Syn_Deal_Rights_Territory 
					From (
						Select SDR.Syn_Deal_Rights_Code, Case When SDRT.Territory_Type = 'I' Then SDRT.Country_Code Else TD.Country_Code End Country_Code
						from #Syn_Deal_Rights SDR 
						Inner Join Syn_Deal_Rights_Territory SDRT on SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
						Left Join Territory_Details TD On SDRT.Territory_Code = TD.Territory_Code
					) As a	
					Inner Join @Deal_Rights_Territory DRT On a.Country_Code = DRT.Country_Code
					
					delete from #Syn_Deal_Rights_Platform where Syn_Deal_Rights_Code not in (
						select Syn_Deal_Rights_Code from #Syn_Deal_Rights_Territory
					)
					delete from #Syn_Deal_Rights_Title where Syn_Deal_Rights_Code not in (
						select Syn_Deal_Rights_Code from #Syn_Deal_Rights_Platform
					)

					delete from #Syn_Deal_Rights where Syn_Deal_Rights_Code not in (
						select Syn_Deal_Rights_Code from #Syn_Deal_Rights_Title
					)
		
				End ----------------- END
				
				Begin ----------------- CHECK FOR SUBTITLING
				
					IF((SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling)>0)
					BEGIN

						insert into #Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code,Language_Type, Language_Group_Code,Language_Code)
						Select Syn_Deal_Rights_Code, a.Language_Type, a.Language_Group_Code, Language_Code From (
							select SDR.Syn_Deal_Rights_Code,SDRS.Language_Type,SDRS.Language_Group_Code,
								   Case When SDRS.Language_Type = 'L' Then SDRS.Language_Code  Else LGD.Language_Code End Language_Code
							From #Syn_Deal_Rights SDR 
							Inner Join Syn_Deal_Rights_Subtitling SDRS on SDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
							Left Join Language_Group_Details LGD On SDRS.Language_Group_Code = LGD.Language_Group_Code
						) as a
						Inner Join @Deal_Rights_Subtitling DRS ON DRS.Subtitling_Code=a.Language_Code

					END
					
				End ----------------- END
		
				Begin ----------------- CHECK FOR DUBBING
				
					IF((SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing)>0)
					BEGIN
						insert into #Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code,Language_Type ,Language_Group_Code,Language_Code)
						Select Syn_Deal_Rights_Code,a.Language_Type, a.Language_Group_Code, Language_Code 
						From (
							select SDR.Syn_Deal_Rights_Code,SDRD.Language_Type,SDRD.Language_Group_Code, 
								   Case When SDRD.Language_Type = 'L' Then SDRD.Language_Code Else LGD.Language_Code End Language_Code
							From #Syn_Deal_Rights SDR
							Inner Join Syn_Deal_Rights_Dubbing SDRD on SDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
							Left Join Language_Group_Details LGD On SDRD.Language_Group_Code = LGD.Language_Group_Code
						) as a
						Inner Join @Deal_Rights_Dubbing DRD ON DRD.Dubbing_Code=a.Language_Code

					END

				End ----------------- END

				IF(
					(SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling) = 0 AND 
					(SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing) = 0
				)
				BEGIN
					DELETE  FROM #Syn_Deal_Rights WHERE Is_Title_Language_Right = 'N'
				END
				ELSE 
				BEGIN
					INSERT INTO #Syn_Rights_Code_Lang
					SELECT Distinct R.Syn_Deal_Rights_Code FROM #Syn_Deal_Rights R
					WHERE (R.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y')
				
					INSERT INTO #Syn_Rights_Code_Lang
					SELECT Distinct Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Subtitling 
					where (ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0)
				
					INSERT INTO #Syn_Rights_Code_Lang	
					SELECT Distinct Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Dubbing 
					where (ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0)

					DELETE FROM #Syn_Deal_Rights
					WHERE Syn_Deal_Rights_Code NOT IN(SELECT Deal_Rights_Code FROM #Syn_Rights_Code_Lang)
			
				END
				
				delete from #Syn_Deal_Rights_Title where Syn_Deal_Rights_Code not in (
					select Syn_Deal_Rights_Code from #Syn_Deal_Rights
				)
				delete from #Syn_Deal_Rights_Territory where Syn_Deal_Rights_Code not in (
					select Syn_Deal_Rights_Code from #Syn_Deal_Rights
				)
				delete from #Syn_Deal_Rights_Platform where Syn_Deal_Rights_Code not in (
					select Syn_Deal_Rights_Code from #Syn_Deal_Rights
				)
		
				SELECT SDR.*, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To, SDRP.Platform_Code
				INTO #Syn_Rights_New
				FROM #Syn_Deal_Rights SDR
				INNER JOIN #Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
				INNER JOIN #Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
				
				If Exists(Select Top 1 * From #Syn_Rights_New)
				Begin
					Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															ErrorMsg, Episode_From, Episode_To, Inserted_On, 
															IsPushback)
					Select @Syn_Deal_Rights_Code, Title_Name, abcd.Platform_Hiearachy Platform_Name, Actual_Right_Start_Date, Actual_Right_End_Date,
						CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
						CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
						CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
						Country_Name,
						CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
						CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
						Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, GetDate(), 
						Case When ISNULL(Is_Pushback,'N') = 'N' Then 'Rights' Else 'Pushback' End As Is_Pushback
					From(
						Select *,
						STUFF
						(
							(
							Select ', ' + C.Country_Name From Country C 
							Where c.Country_Code In(
								Select t.Country_Code From #Syn_Deal_Rights_Territory t 
								Where t.Syn_Deal_Rights_Code In (
									Select adrn.Syn_Deal_Rights_Code From #Syn_Rights_New adrn Where 
										a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
										and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
										and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
										and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Country_Name,
						STUFF
						(
							(
							Select ',' + CAST(P.Platform_Code as Varchar) 
							From Platform p Where p.Platform_Code In
							(
								Select adrn.Platform_Code 
								FROM #Syn_Rights_New adrn 
								WHERE a.Title_Code = adrn.Title_Code
								AND adrn.Platform_Code = p.Platform_Code
								AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
								and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
								and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
								and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Platform_Code,
						STUFF
						(
							(
							Select ', ' + l.Language_Name From Language l 
							Where l.Language_Code In(
								Select t.Language_Code From #Syn_Deal_Rights_Subtitling t 
								Where t.Syn_Deal_Rights_Code In (
									Select adrn.Syn_Deal_Rights_Code From #Syn_Rights_New adrn 
									Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
										and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
										and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
										and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Subtitling_Language,
						STUFF
						(
							(
							Select ', ' + l.Language_Name From Language l 
							Where l.Language_Code In(
								Select t.Language_Code From #Syn_Deal_Rights_Dubbing t Where t.Syn_Deal_Rights_Code In (
									Select adrn.Syn_Deal_Rights_Code From #Syn_Rights_New adrn 
									Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
										and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
										and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
										and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Dubbing_Language,
						STUFF
						(
							(
							Select ', ' + t.Agreement_No From Syn_Deal t
							Where t.Syn_Deal_Code In (
								Select adrn.Syn_Deal_Code From #Syn_Rights_New adrn
								Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date
									AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
									And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
									and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
									and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
									and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Agreement_No
						From (
							Select T.Title_Code,
								DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
								ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
								Is_Sub_License, Is_Title_Language_Right, 
								Case 
									WHEN @Deal_Code <> ADR.Syn_Deal_Code THEN  'Combination already Syndicated'
									ELSE 'Combination conflicts with other Rights'
								END AS ErrorMSG, 
								Right_Type, Episode_From, Episode_To, Is_Pushback
							from #Syn_Rights_New ADR
							INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
							Group By T.Title_Code, T.Title_Name, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, Right_Type, Episode_From, Episode_To, Deal_Type_Code, ADR.Syn_Deal_Code, Is_Pushback
						) as a
					) as MainOutput
					Cross Apply
					(
						SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
					) as abcd

					Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					SET @Is_Error = 'Y'
				End
				--Else If(@Is_Error = 'N')
				--Begin
				--	Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				--End

				/*Checking of error in two procedures*/
				IF(@Syn_Error = 'Y' OR @Is_Error = 'Y')
				BEGIN
				Print 'Rights Status = Error'
					Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				END
				ELSE
				BEGIN
				Print 'Rights Status = Correct'
					Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				END
				/*END*/
				--Select Cast('ad' As Int)

				Drop Table #Syn_Rights_New
				Drop Table #Syn_Deal_Rights
				Drop Table #Syn_Deal_Rights_Title
				Drop Table #Syn_Deal_Rights_Platform
				Drop Table #Syn_Deal_Rights_Territory
				Drop Table #Syn_Deal_Rights_Subtitling
				Drop Table #Syn_Deal_Rights_Dubbing
				Drop Table #Syn_Rights_Code_Lang

			End  ------------------------ End


		End Try
		Begin Catch
			Delete From Syn_Deal_Rights_Error_Details Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
														Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name, Subtitling_Language, 
														Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On,IsPushback)
			Select @Syn_Deal_Rights_Code, 'ERROR IN SYN RIGHTS VALIDATION PROCESS', 'ERROR IN SYN RIGHTS VALIDATION PROCESS', Null, Null, 
					Null, Null, Null, 'ERROR IN SYN RIGHTS VALIDATION PROCESS', 'ERROR IN SYN RIGHTS VALIDATION PROCESS', 
					ERROR_MESSAGE(), ERROR_MESSAGE(), 'ERROR IN SYN RIGHTS VALIDATION PROCESS PLEASE CONTACT ADMINISTRATOR', Null, Null, GETDATE(),''

			Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			Declare @UTO_Email_Id Varchar(1000) = ''
			Select @UTO_Email_Id = Parameter_Value From System_Parameter_New Where Parameter_Name = 'UTO_Email_Id'

			DECLARE @DatabaseEmail_Profile varchar(200), @EmailBody NVARCHAR(max) = ''
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
				
		
			Set @EmailBody = 'Hello RightsU Team <br/><br/>There is an error occured while validating a syndication rights. Syndication Right Code is - ' + Cast(@Syn_Deal_Rights_Code as Varchar(100)) +
							 '<br/><br/>Below is error description - </br>'

			SELECT @EmailBody = @EmailBody + ERROR_MESSAGE()

			--EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile
			--,@Recipients =  @UTO_Email_Id
			--,@Copy_recipients = ''
			--,@subject = 'RightsU Error On Syndication Rights Validation'
			--,@body = @EmailBody, @body_format = 'HTML';

		End Catch

		Update Syn_Deal_Rights_Process_Validation Set Status = 'D' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
	End
End