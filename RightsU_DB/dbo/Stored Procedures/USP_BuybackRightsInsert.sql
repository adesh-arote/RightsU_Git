CREATE PROCEDURE [dbo].[USP_BuybackRightsInsert]
@Acq_Deal_Code INT,
@SynRightsCode NVARCHAR(MAX),
@UsersCode INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BuybackRightsInsert]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE 
	--@Acq_Deal_Code INT = 25811,
	--@SynRightsCode NVARCHAR(MAX) = '42749T9262',
	--@UsersCode INT = 136
		IF OBJECT_ID('tempdb..#tempSynRightsCode') IS NOT NULL DROP TABLE #tempSynRightsCode

		CREATE TABLE #tempSynRightsCode(
			Title_Rights_Code NVARCHAR(MAX)
		)
  
	
		INSERT INTO #tempSynRightsCode(Title_Rights_Code)
		select CAST(number AS NVARCHAR) from dbo.fn_Split_withdelemiter('' + ISNULL(@SynRightsCode, '') +'',',')

	
		DECLARE
		@Syn_Deal_Rights_Code NVARCHAR(MAX)

		DECLARE db_cursor CURSOR FOR SELECT Title_Rights_Code FROM #tempSynRightsCode
		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @Syn_Deal_Rights_Code 
	
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF OBJECT_ID('tempdb..#tempTitle_Rights_Code') IS NOT NULL DROP TABLE #tempTitle_Rights_Code

			CREATE TABLE #tempTitle_Rights_Code
			(
				Row_No INT IDENTITY(1,1),
				Title_Rights_Code INT
			)

			DECLARE
			@TitleCode INT,
			@RightsCode INT

			INSERT INTO #tempTitle_Rights_Code
			select CAST(number AS INT) from dbo.fn_Split_withdelemiter('' + ISNULL(@Syn_Deal_Rights_Code, '') +'','T')

		
			SET @TitleCode = (Select top 1 Title_Rights_Code from #tempTitle_Rights_Code WHERE Row_No = 1)
			SET @RightsCode = (Select top 1 Title_Rights_Code from #tempTitle_Rights_Code WHERE Row_No = 2)

			INSERT INTO Acq_Deal_Rights(Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, ROFR_Code, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Is_Verified, Original_Right_Type, Promoter_Flag, Right_Status, Is_Under_Production, Buyback_Syn_Rights_Code)
			SELECT @Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
			CASE WHEN Right_Type = 'U' THEN 'Y' ELSE Right_Type END, Is_Tentative,
			CASE WHEN Right_Type = 'U' THEN dbo.UFN_Calculate_Term(sdr.Actual_Right_Start_Date, sdr.Actual_Right_End_Date) ELSE Term END, Right_Start_Date, CASE WHEN Right_Type = 'U' THEN Actual_Right_End_Date ELSE Right_End_Date END, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, '', Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, ROFR_Code, Inserted_By, GETDATE(), GETDATE(), Last_Action_By, Is_Verified, 
			CASE WHEN Right_Type = 'U' THEN 'U' ELSE Original_Right_Type END, Promoter_Flag, 'P', NULL, @RightsCode				
			FROM Syn_Deal_Rights sdr (NOLOCK)
			INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
			where sdr.Syn_Deal_Rights_Code = @RightsCode AND sdrt.Title_Code = @TitleCode
		
			DECLARE @Acq_Deal_Rights_Code INT 

			SET @Acq_Deal_Rights_Code = IDENT_CURRENT('Acq_Deal_Rights')--(SELECT top 1 Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code AND Buyback_Syn_Rights_Code = @RightsCode)

		
			IF EXISTS(Select top 1 Syn_Deal_Rights_Dubbing_Code from [dbo].[Syn_Deal_Rights_Dubbing] WHERE Syn_Deal_Rights_Code = @RightsCode)
			BEGIN
				INSERT INTO Acq_Deal_Rights_Dubbing( Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code)
				SELECT @Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
				FROM Syn_Deal_Rights_Dubbing sdrd (NOLOCK)
				INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
				where sdrd.Syn_Deal_Rights_Code = @RightsCode AND sdrt.Title_Code = @TitleCode
			END
		
			INSERT INTO Acq_Deal_Rights_Platform(Acq_Deal_Rights_Code, Platform_Code)
			SELECT @Acq_Deal_Rights_Code , Platform_Code 
			FROM Syn_Deal_Rights_Platform sdrd (NOLOCK)
			INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
			where sdrd.Syn_Deal_Rights_Code = @RightsCode AND sdrt.Title_Code = @TitleCode 
		

			IF EXISTS(Select top 1 Syn_Deal_Rights_Subtitling_Code from [dbo].[Syn_Deal_Rights_Subtitling] WHERE Syn_Deal_Rights_Code = @RightsCode)
			BEGIN
				INSERT INTO Acq_Deal_Rights_Subtitling( Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code)
				SELECT @Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
				FROM Syn_Deal_Rights_Subtitling sdrd (NOLOCK)
				INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
				where sdrd.Syn_Deal_Rights_Code = @RightsCode AND sdrt.Title_Code = @TitleCode
			END

			INSERT INTO Acq_Deal_Rights_Territory(Acq_Deal_Rights_Code, Territory_Type, Country_Code, Territory_Code)
			SELECT @Acq_Deal_Rights_Code, Territory_Type, Country_Code, Territory_Code 
			FROM [Syn_Deal_Rights_Territory] sdrd (NOLOCK)
			INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
			where sdrd.Syn_Deal_Rights_Code = @RightsCode AND sdrt.Title_Code = @TitleCode

			INSERT INTO Acq_Deal_Rights_Title(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT @Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To 
			from Syn_Deal_Rights_Title sdrd (NOLOCK)
			where sdrd.Syn_Deal_Rights_Code = @RightsCode AND Title_Code = @TitleCode

			IF OBJECT_ID('tempdb..#tempTitle_Rights_Code') IS NOT NULL DROP TABLE #tempTitle_Rights_Code

			FETCH NEXT FROM db_cursor INTO @Syn_Deal_Rights_Code 
		END 
	
		CLOSE db_cursor  
		DEALLOCATE db_cursor 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BuybackRightsInsert]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END