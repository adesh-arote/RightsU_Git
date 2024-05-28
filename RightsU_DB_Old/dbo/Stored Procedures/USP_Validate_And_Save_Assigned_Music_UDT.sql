ALTER PROCEDURE USP_Validate_And_Save_Assigned_Music_UDT
(
	@Deal_Type_Code INT,
	@Login_User_Code INT,
	@Link_Show VARCHAR(1),
	@Action VARCHAR(1), -- 'S' For Save, 'D' For Delete
	@AssignMusic Assign_Music READONLY
)
AS
BEGIN
	--SET FMTONLY OFF
	--DECLARE 
	--@Deal_Type_Code INT = 5,
	--@Login_User_Code INT = 143,
	--@Link_Show VARCHAR(1) = 'Y',
	--@Action VARCHAR(1) = 'S', -- 'S' For Save, 'D' For Delete
	--@AssignMusic Assign_Music

	--INSERT INTO @AssignMusic([Deal_Movie_Code], [Music_Code], Episode_No, No_Of_Play) values
	--(13041, 1058, 1, 10), (13041, 1058, 2, 10),
	--(13042, 1058, 15, 10), (13041, 1058, 15, 10),
	--(13043, 1058, 35, 10), (13043, 1058, 36, 10),
	--(13064, 1058, 45, 10), (13064, 1058, 46, 10),
	--(13065, 1058, 52, 5), (13065, 1058, 53, 5),
	--(13066, 1058, 57, 5), (13066, 1058, 58, 3)

	--INSERT INTO @AssignMusic([Deal_Movie_Code], [Music_Code], Episode_No, No_Of_Play) values
	--(13041, 1058, 1, 3), (13041, 1058, 2, 3),
	--(13041, 1122, 1, 3), (13041, 1122, 2, 3),
	--(13041, 1128, 1, 3), (13041, 1128, 2, 3),
	--(13041, 1132, 1, 3), (13041, 1132, 2, 3)

	--INSERT INTO @AssignMusic([Deal_Movie_Code], [Music_Code], Episode_No, No_Of_Play)
	--SELECT Link_Acq_Deal_Movie_Code, Acq_Deal_Movie_Music_Code, Episode_No, No_Of_Play FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (1182)
	--DELETE FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (1182)
	
	DECLARE @Deal_Type_Condition VARCHAR(MAX) = '', @isError CHAR(1) = 'N'
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)

	IF(OBJECT_ID('TEMPDB..#Temp_Combination') IS NOT NULL)
		DROP TABLE #Temp_Combination

	IF(OBJECT_ID('TEMPDB..#Temp_Music') IS NOT NULL)
		DROP TABLE #Temp_Music

	IF(OBJECT_ID('TEMPDB..#Temp_Deal_Movie') IS NOT NULL)
		DROP TABLE #Temp_Deal_Movie

	IF(OBJECT_ID('TEMPDB..#Temp_Run_Music') IS NOT NULL)
		DROP TABLE #Temp_Run_Music

	IF(OBJECT_ID('TEMPDB..#Temp_Run_Channel_All') IS NOT NULL)
		DROP TABLE #Temp_Run_Channel_All

	IF(OBJECT_ID('TEMPDB..#Temp_Link_Used') IS NOT NULL)
		DROP TABLE #Temp_Link_Used

	IF(OBJECT_ID('TEMPDB..#Temp_Run_Channel_Remaining') IS NOT NULL)
		DROP TABLE #Temp_Run_Channel_Remaining

	IF(OBJECT_ID('TEMPDB..#Temp_Link_Run_Channel') IS NOT NULL)
		DROP TABLE #Temp_Link_Run_Channel

	IF(OBJECT_ID('TEMPDB..#Temp_LinkedShow_Channel') IS NOT NULL)
		DROP TABLE #Temp_LinkedShow_Channel

	IF(OBJECT_ID('TEMPDB..#Temp_Play_ChannelWise') IS NOT NULL)
		DROP TABLE #Temp_Play_ChannelWise

	IF(OBJECT_ID('TEMPDB..#Temp_Error') IS NOT NULL)
		DROP TABLE #Temp_Error

	CREATE TABLE #Temp_Music
	(
		Deal_Movie_Code INT,
		Music_Code INT,
		Process_Done CHAR(1)
	)

	CREATE TABLE #Temp_Run_Channel_All
	(
		Deal_Movie_Code INT,
		Channel_Code INT,
		Episode_No INT,
		No_Of_Play INT
	)

	CREATE TABLE #Temp_Play_ChannelWise
	(
		Deal_Movie_Code INT,
		Run_Code INT,
		Channel_Code INT,
		Run_Def_Type VARCHAR(10),
		Total_Run INT,
		No_Of_Play INT
	)

	CREATE TABLE #Temp_Run_Channel_Remaining
	(
		Deal_Movie_Code INT,
		Channel_Code INT,
		Episode_No INT,
		No_Of_Play INT
	)

	CREATE TABLE #Temp_Link_Used
	(
		Deal_Movie_Code INT,
		Channel_Code INT,
	)

	CREATE TABLE #Temp_Deal_Movie
	(
		Deal_Movie_Code INT,
		Process_Done CHAR(1)
	)

	CREATE TABLE #Temp_Run_Music
	(
		Run_Code INT,
		Run_Type CHAR(1),
		Total_Runs INT,
		Run_Definition_Type VARCHAR(10),
		Channel_Code INT,
		Min_Runs INT,
		Max_Runs INT,
		Data_For CHAR(1),
		Title_Code_Linked_Show INT,
		Deal_Movie_Code_Linked_Show INT,
	)

	CREATE TABLE #Temp_Link_Run_Channel
	(
		Channel_Code INT,
	)

	CREATE TABLE #Temp_LinkedShow_Channel
	(
		Channel_Code INT,
	)
	
	CREATE TABLE #Temp_Error
	(
		Deal_Movie_Code INT,
		Music_Code INT,
		Episode_No INT,
		Is_Warning VARCHAR(1),
		Err_Message NVARCHAR(MAX),
	)


	SELECT Deal_Movie_Code, Music_Code, Episode_No, No_Of_Play INTO #Temp_Combination 
	FROM @AssignMusic

	IF(@Action = 'D')
	BEGIN
		IF(@Deal_Type_Condition = 'DEAL_MUSIC')
		BEGIN
			
			IF EXISTS (SELECT * FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code IN (SELECT DISTINCT Music_Code FROM #Temp_Combination))
			BEGIN
				INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Is_Warning,Err_Message)
				SELECT DISTINCT ADMM.Acq_Deal_Movie_Code, ADMM.Music_Title_Code, 'N', 
				'This music title has been linked with ' + AD_L.Agreement_No + ' - ' +
				DBO.UFN_GetTitleNameInFormat(DBO.UFN_GetDealTypeCondition(AD_L.Deal_Type_Code), ISNULL(T.Title_Name, ''), ADM_L.Episode_Starts_From, ADM_L.Episode_End_To) 
				--'This music title has been linked with ''' + AD_L.Agreement_No + ' - ' +  ISNULL(T.Title_Name, '') + '''  For ' +
				--STUFF
				--(
				--	(
				--		SELECT ', Episodes-' + CAST(ADMML_I.Episode_No AS VARCHAR)
				--		FROM Acq_Deal_Movie_Music_Link ADMML_I WHERE ADMML_I.Link_Acq_Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code 
				--			AND ADMML.Acq_Deal_Movie_Music_Code = TC.Music_Code
				--		ORDER BY ADMML.Episode_No
				--		FOR XML PATH('')
				--	), 1, 1, ''
				--) AS Err_Message
				FROM Acq_Deal_Movie_Music ADMM
				INNER JOIN #Temp_Combination TC ON TC.Music_Code = ADMM.Acq_Deal_Movie_Music_Code
				INNER JOIN Acq_Deal_Movie_Music_Link ADMML ON ADMML.Acq_Deal_Movie_Music_Code = TC.Music_Code
				-- Links Join
				INNER JOIN Acq_Deal_Movie ADM_L ON ADM_L.Acq_Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code
				INNER JOIN Acq_Deal AD_L ON AD_L.Acq_Deal_Code = ADM_L.Acq_Deal_Code
				INNER JOIN Title T ON T.Title_Code = ADM_L.Title_Code
				WHERE  AD_L.Deal_Workflow_Status NOT IN ('AR', 'WA')
				SET @isError = 'Y'
			END

			IF(@isError = 'N')
				DELETE FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Music_Code IN (SELECT DISTINCT Music_Code FROM #Temp_Combination)
		END
		ELSE
		BEGIN
			DELETE FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Link_Code IN (SELECT DISTINCT Music_Code FROM #Temp_Combination)
		END
	END
	ELSE
	BEGIN
		IF( @Link_Show = 'Y' OR @Deal_Type_Condition <> 'DEAL_MUSIC')
		BEGIN
			IF EXISTS(
				SELECT ADMML.* FROM Acq_Deal_Movie_Music_Link ADMML
				INNER JOIN #Temp_Combination TC ON TC.Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code 
					AND TC.Music_Code = ADMML.Acq_Deal_Movie_Music_Code AND TC.Episode_No = ADMML.Episode_No
			)
			BEGIN
				INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Episode_No, Is_Warning ,Err_Message)
				SELECT ADMML.Link_Acq_Deal_Movie_Code, ADMML.Acq_Deal_Movie_Music_Code, ADMML.Episode_No, 'N', 'Duplicate Record' FROM Acq_Deal_Movie_Music_Link ADMML
				INNER JOIN #Temp_Combination TC ON TC.Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code 
					AND TC.Music_Code = ADMML.Acq_Deal_Movie_Music_Code AND TC.Episode_No = ADMML.Episode_No

				SET @isError = 'Y'
			END

			IF(@isError = 'N')
			BEGIN
				PRINT 'INSERT DATA IN Acq_Deal_Movie_Music_Link TABLE'
				INSERT INTO Acq_Deal_Movie_Music_Link(Acq_Deal_Movie_Music_Code, Link_Acq_Deal_Movie_Code, Title_Code, Episode_No, No_Of_Play, Is_Active,
					Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By)
				SELECT DISTINCT TC.Music_Code, TC.Deal_Movie_Code, ADM.Title_Code , TC.Episode_No, TC.No_Of_Play, 'Y' AS Is_Active, 
				@Login_User_Code AS Inserted_By, GETDATE() AS Inserted_On, GETDATE() AS Last_UpDated_Time, @Login_User_Code AS Last_Action_By
				FROM #Temp_Combination TC
				INNER JOIN Acq_Deal_Movie ADM ON TC.Deal_Movie_Code = adm.Acq_Deal_Movie_Code

				INSERT INTO #Temp_Deal_Movie(Deal_Movie_Code, Process_Done)
				SELECT DISTINCT Deal_Movie_Code, 'N' FROM #Temp_Combination
				INSERT INTO #Temp_Music(Deal_Movie_Code, Music_Code, Process_Done)
				SELECT DISTINCT ADMM.Acq_Deal_Movie_Code, ADMM.Acq_Deal_Movie_Music_Code, 'N' FROM Acq_Deal_Movie_Music ADMM
				WHERE ADMM.Acq_Deal_Movie_Music_Code IN (SELECT DISTINCT Music_Code FROM #Temp_Combination)

				--- 'terminated' word has been used below in query for hide Title_Name
				INSERT INTO #Temp_Error(Deal_Movie_Code, Is_Warning ,Err_Message)
				SELECT Deal_Movie_Code, Is_Warning, Err_Message FROM (
					SELECT DISTINCT TDM.Deal_Movie_Code, 'Y' AS Is_Warning, 'Deal ' + AD.Agreement_No + ' is terminated' AS Err_Message,
					ROW_NUMBER() OVER(PARTITION BY ADM.Acq_Deal_Code ORDER BY ADM.Acq_Deal_Code) AS Dup_Row_No
					FROM #Temp_Deal_Movie TDM 
					INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TDM.Deal_Movie_Code
					INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
					AND AD.[Status] = 'T' 
				) AS TMP WHERE Dup_Row_No = 1

				DECLARE @dealMovieCode_MusicLibrary INT = 0, @musicCode INT = 0, @dealMovieCode_Link INT = 0,
				@Total_No_Of_Play INT = 0, @Total_No_Of_Run INT = 0
				SELECT TOP 1 @dealMovieCode_MusicLibrary = Deal_Movie_Code, @musicCode = Music_Code FROM #Temp_Music WHERE ISNULL(Process_Done, 'N') = 'N'
				WHILE(@dealMovieCode_MusicLibrary > 0)
				BEGIN
					--- Starts Warning related coding here --

					DELETE FROM #Temp_Run_Music
				
					INSERT INTO #Temp_Run_Music(Run_Code, Run_Type, Run_Definition_Type, Total_Runs, Channel_Code, Min_Runs, Max_Runs
						, Data_For, Title_Code_Linked_Show, Deal_Movie_Code_Linked_Show
						)
					SELECT DISTINCT ADR.Acq_Deal_Run_Code, ADR.Run_Type, ADR.Run_Definition_Type, ADR.No_Of_Runs, ADRC.Channel_Code, ADRC.Min_Runs, ADRC.Max_Runs
						, ISNULL(ADRS.Data_For, '') AS Data_For, ADRS.Title_Code, ADRS.Acq_Deal_Movie_Code
					FROM Acq_Deal_Movie ADM 
					INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @dealMovieCode_MusicLibrary
					INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
						AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To
					INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
					LEFT JOIN Acq_Deal_Run_Shows ADRS ON ADRS.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

					IF EXISTS (SELECT * FROM #Temp_Run_Music)
					BEGIN
					
						SELECT @Total_No_Of_Play = ISNULL(SUM(No_Of_Play), 0) FROM Acq_Deal_Movie_Music_Link WHERE Acq_Deal_Movie_Music_Code = @musicCode 

						IF NOT EXISTS (SELECT * FROM #Temp_Run_Music WHERE Run_Type = 'U')
						BEGIN
							SET @Total_No_Of_Run = 0
							--- Limited Run, Shared or NA 
							SELECT @Total_No_Of_Run = @Total_No_Of_Run + SUM(Total_Run) FROM (
								SELECT DISTINCT Run_Code, ISNULL(Total_Runs, 0) AS Total_Run FROM #Temp_Run_Music WHERE Run_Definition_Type IN ('N', 'S')
							) AS A 

							--- Limited Run, Channel Wise, Channel Wise Shared (Min / Max) or All
							SELECT @Total_No_Of_Run = @Total_No_Of_Run + SUM(Min_Runs) FROM (
								SELECT DISTINCT Run_Code, ISNULL(Min_Runs, 1) AS Min_Runs FROM #Temp_Run_Music WHERE Run_Definition_Type IN ('C', 'CS', 'A')
							) AS A

							IF(@Total_No_Of_Run < @Total_No_Of_Play)
							BEGIN
								PRINT 'WARNING - 01'
								INSERT INTO #Temp_Error(Music_Code, Is_Warning ,Err_Message)
								VALUES(@musicCode, 'Y', 'Total no of play ( ' + CAST(@Total_No_Of_Play AS VARCHAR) + ' ) cannot be greater than no of runs( ' + 
									CAST(@Total_No_Of_Run AS VARCHAR) + ' )'
								) 
							END
						END
					
						DELETE FROM #Temp_Run_Channel_All
						INSERT INTO #Temp_Run_Channel_All(Deal_Movie_Code, Episode_No, Channel_Code, No_Of_Play)
						SELECT DISTINCT  ADMML.Link_Acq_Deal_Movie_Code, ADMML.Episode_No, ADRC.Channel_Code, ADMML.No_Of_Play FROM Acq_Deal_Movie_Music_Link ADMML
						INNER JOIN #Temp_Deal_Movie TDM ON TDM.Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code 
							AND ADMML.Acq_Deal_Movie_Music_Code = @musicCode
						INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code
						INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code 
						INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
							AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To
						INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
						INNER JOIN #Temp_Run_Music TRM ON TRM.Channel_Code = ADRC.Channel_Code

						DELETE FROM #Temp_Link_Used
						INSERT INTO #Temp_Link_Used(Deal_Movie_Code, Channel_Code)
						SELECT DISTINCT TDM_2.Deal_Movie_Code, ADRC_2.Channel_Code FROM #Temp_Deal_Movie TDM_2 
						INNER JOIN Acq_Deal_Movie ADM_2 ON ADM_2.Acq_Deal_Movie_Code = TDM_2.Deal_Movie_Code
						INNER JOIN Acq_Deal_Run ADR_2 ON ADR_2.Acq_Deal_Code = ADM_2.Acq_Deal_Code
						INNER JOIN Acq_Deal_Run_Title ADRT_2 ON ADRT_2.Acq_Deal_Run_Code = ADR_2.Acq_Deal_Run_Code
							AND ADRT_2.Episode_From = ADM_2.Episode_Starts_From AND ADRT_2.Episode_To = ADM_2.Episode_End_To
						INNER JOIN Acq_Deal_Run_Channel ADRC_2 ON ADRC_2.Acq_Deal_Run_Code = ADR_2.Acq_Deal_Run_Code

						DELETE FROM #Temp_Run_Channel_Remaining
						INSERT INTO #Temp_Run_Channel_Remaining(Deal_Movie_Code, Episode_No, Channel_Code, No_Of_Play)
						SELECT Deal_Movie_Code, Episode_No, Channel_Code, No_Of_Play FROM #Temp_Run_Channel_All TRC
						WHERE TRC.Deal_Movie_Code NOT IN (
							SELECT DISTINCT TL.Deal_Movie_Code FROM #Temp_Link_Used TL WHERE TL.Channel_Code IN (
								SELECT DISTINCT TRM.Channel_Code FROM #Temp_Run_Music TRM WHERE 
									--TRM.Run_Type = 'U' AND TRM.Run_Definition_Type IN ('N', 'S')) OR 
									(TRM.Run_Type = 'C' AND TRM.Run_Definition_Type IN ('C','CS', 'A')) 
							)
						)				

						SET @Total_No_Of_Run = 0
						--- Limited Run, Shared or NA 
						SELECT @Total_No_Of_Run = @Total_No_Of_Run + SUM(Total_Run) FROM (
							SELECT DISTINCT Run_Code, ISNULL(Total_Runs, 0) AS Total_Run FROM #Temp_Run_Music TRM
							INNER JOIN #Temp_Run_Channel_Remaining TRC ON TRC.Channel_Code = TRM.Channel_Code
							WHERE TRM.Run_Definition_Type IN ('N', 'S')
						) AS A 

						SELECT @Total_No_Of_Play = ISNULL(SUM(No_Of_Play), 0) FROM (
								SELECT DISTINCT Deal_Movie_Code, Episode_No, No_Of_Play FROM #Temp_Run_Channel_Remaining
						) AS A 

						DELETE FROM #Temp_Play_ChannelWise
						INSERT INTO #Temp_Play_ChannelWise(Deal_Movie_Code, No_Of_Play, Total_Run)
						SELECT A.Deal_Movie_Code, A.Total_No_Of_Play, B.Total_Run FROM (
							SELECT Deal_Movie_Code, SUM(No_Of_Play) AS Total_No_Of_Play FROM (
								SELECT DISTINCT Deal_Movie_Code, Episode_No, No_Of_Play FROM #Temp_Run_Channel_Remaining TRC
							) AS A_I GROUP BY Deal_Movie_Code
						) AS A 
						INNER JOIN (
							SELECT Deal_Movie_Code, SUM(Total_Runs) AS Total_Run FROM  (
								SELECT DISTINCT Deal_Movie_Code, Run_Code, Total_Runs FROM #Temp_Run_Channel_Remaining TRC
								INNER JOIN #Temp_Run_Music TRM ON TRM.Channel_Code = TRC.Channel_Code
							) AS B_I GROUP BY Deal_Movie_Code
						) AS B ON B.Deal_Movie_Code = A.Deal_Movie_Code

						PRINT 'WARNING - 02'
						INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Is_Warning ,Err_Message)	
						SELECT TPC.Deal_Movie_Code, @musicCode, 'Y', 
							'Total no of play ( ' + CAST(TPC.No_Of_Play AS VARCHAR) + ' ) cannot be greater than no of runs( ' + CAST(TPC.Total_Run AS VARCHAR) + 
							' ) for channels ' +  STUFF(
								(
									SELECT DISTINCT ', ' + ISNULL(C.Channel_Name, '') 
									FROM #Temp_Run_Channel_Remaining TRC
									INNER JOIN #Temp_Run_Music TRM ON TRC.Channel_Code = TRM.Channel_Code and TRM.Run_Type != 'U'
									INNER JOIN Channel C ON C.Channel_Code = TRC.Channel_Code
									WHERE TRC.Deal_Movie_Code = TPC.Deal_Movie_Code
									FOR XML PATH('')
								), 1, 1, ''
						) as Err_Message
						FROM #Temp_Play_ChannelWise TPC WHERE Total_Run < No_Of_Play AND Total_Run IS NOT NULL

						DELETE FROM #Temp_Run_Channel_Remaining
						INSERT INTO #Temp_Run_Channel_Remaining(Deal_Movie_Code, Episode_No, Channel_Code, No_Of_Play)
						SELECT Deal_Movie_Code, Episode_No, Channel_Code, No_Of_Play FROM #Temp_Run_Channel_All TRC
						--WHERE TRC.Deal_Movie_Code NOT IN (
						--	SELECT DISTINCT TL.Deal_Movie_Code FROM #Temp_Link_Used TL WHERE TL.Channel_Code IN (
						--		SELECT DISTINCT TRM.Channel_Code FROM #Temp_Run_Music TRM WHERE 
						--			(TRM.Run_Type = 'U' AND TRM.Run_Definition_Type IN ('N', 'S')) OR
						--			(TRM.Run_Type = 'C' AND TRM.Run_Definition_Type IN ('N')) 
						--	)
						--)

						DELETE FROM #Temp_Play_ChannelWise
						
						;WITH Warning_Channel AS 
						(
							SELECT Channel_Code, ISNULL(SUM(No_Of_Play), 0) AS Total_No_Of_Play FROM #Temp_Run_Channel_Remaining
							GROUP BY Channel_Code
						)

						INSERT INTO #Temp_Play_ChannelWise(Deal_Movie_Code, Run_Code, Channel_Code, Run_Def_Type, Total_Run, No_Of_Play)
						SELECT DISTINCT TRC.Deal_Movie_Code, TRM.Run_Code, WC.Channel_Code, TRM.Run_Definition_Type,
						CASE WHEN TRM.Run_Definition_Type IN ('C', 'CS', 'A') THEN TRM.Min_Runs 
							ELSE TRM.Total_Runs END AS Total_Run, wc.Total_No_Of_Play 
						FROM Warning_Channel WC
						INNER JOIN #Temp_Run_Music TRM ON TRM.Channel_Code = WC.Channel_Code AND Run_Type = 'C' AND (
							(TRM.Min_Runs < WC.Total_No_Of_Play AND TRM.Run_Definition_Type IN ('C', 'CS', 'A')) OR
							(TRM.Total_Runs < WC.Total_No_Of_Play AND TRM.Run_Definition_Type NOT IN ('C', 'CS', 'A'))
						)
						INNER JOIN #Temp_Run_Channel_Remaining TRC ON TRC.Channel_Code = WC.Channel_Code
						
						PRINT 'WARNING - 03'
						INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Is_Warning ,Err_Message)
						SELECT S1.Deal_Movie_Code, @musicCode, 'Y', 
						CASE 
							WHEN S1.No_Of_Play > S2.Total_Run THEN 
								'Total no of play ( ' + CAST(S1.No_Of_Play AS VARCHAR) + ' ) cannot be greater than no of runs( ' + CAST(S2.Total_Run AS VARCHAR) + ' ) for channels '
							WHEN S3.Channel_Count > 1 THEN 'Channel wise sharing for channels ' END	+  STUFF(
							(
								SELECT ', ' + ISNULL(C.Channel_Name, '')  + 
								CASE WHEN S1.No_Of_Play <= S2.Total_Run AND S3.Channel_Count > 1 THEN ' ( ' + CAST(TPC.Total_Run AS VARCHAR) + ' )' ELSE '' END
								FROM #Temp_Play_ChannelWise TPC
								INNER JOIN Channel C ON C.Channel_Code = TPC.Channel_Code
								WHERE TPC.Deal_Movie_Code = S1.Deal_Movie_Code
								FOR XML PATH('')
							), 1, 1, ''
						) AS Err_Message
						FROM (
							SELECT DISTINCT Deal_Movie_Code, No_Of_Play FROM #Temp_Play_ChannelWise
						) AS S1
						INNER JOIN (
							SELECT S1_I.Deal_Movie_Code, SUM(S1_I.Total_Run) AS Total_Run FROM
							(
								SELECT Deal_Movie_Code, Run_Code, Total_Run FROM #Temp_Play_ChannelWise
								WHERE Run_Def_Type IN ('C', 'CS', 'A')
								UNION 
								SELECT DISTINCT Deal_Movie_Code, Run_Code, Total_Run FROM #Temp_Play_ChannelWise
								WHERE Run_Def_Type NOT IN ('C', 'CS', 'A')
							) AS S1_I
							GROUP BY S1_I.Deal_Movie_Code

						) AS S2 ON S1.Deal_Movie_Code = S2.Deal_Movie_Code
						INNER JOIN (
							SELECT DISTINCT Deal_Movie_Code, COUNT(DISTINCT TPC.Channel_Code) AS Channel_Count FROM #Temp_Play_ChannelWise TPC 
							GROUP BY Deal_Movie_Code
						) AS S3 ON S1.Deal_Movie_Code = S3.Deal_Movie_Code

						WHERE S1.No_Of_Play > S2.Total_Run OR S3.Channel_Count > 1 

						SELECT TOP 1 @dealMovieCode_Link = Deal_Movie_Code FROM #Temp_Deal_Movie WHERE ISNULL(Process_Done, 'N') = 'N'
						WHILE(@dealMovieCode_Link > 0)
						BEGIN

							DELETE FROM #Temp_Link_Run_Channel
							INSERT INTO #Temp_Link_Run_Channel(Channel_Code)
							SELECT DISTINCT ADRC.Channel_Code
							FROM Acq_Deal_Movie ADM 
							INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @dealMovieCode_Link
							INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
								AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To
							INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
							LEFT JOIN Acq_Deal_Run_Shows ADRS ON ADRS.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

							IF EXISTS (SELECT * FROM #Temp_Link_Run_Channel )
							BEGIN
								IF EXISTS (SELECT * FROM #Temp_Link_Run_Channel TRDM WHERE TRDM.Channel_Code NOT IN (
												SELECT DISTINCT Channel_Code FROM #Temp_Run_Music))
								BEGIN
									PRINT 'WARNING - 04'
									INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Is_Warning ,Err_Message)
									SELECT @dealMovieCode_Link, @musicCode, 'Y', 'Channels ' +  STUFF(
										(
											SELECT DISTINCT ', ' + ISNULL(C.Channel_Name, '') 
											FROM #Temp_Link_Run_Channel TRDM
											INNER JOIN Channel C ON C.Channel_Code = TRDM.Channel_Code
											WHERE TRDM.Channel_Code NOT IN (
												SELECT DISTINCT Channel_Code FROM #Temp_Run_Music
											)
											FOR XML PATH('')
										), 1, 1, ''
									)
									+ ' does not exist in music library''s run defination' AS Err_Message
								END

								INSERT INTO #Temp_LinkedShow_Channel(Channel_Code)
								SELECT DISTINCT TRC.Channel_Code FROM Acq_Deal_Movie ADM
								INNER JOIN #Temp_Run_Music TRM ON 
									(TRM.Data_For = 'E' AND TRM.Deal_Movie_Code_Linked_Show = ADM.Acq_Deal_Movie_Code) OR
									(TRM.Data_For = 'P' AND TRM.Title_Code_Linked_Show = ADM.Title_Code) OR
									(TRM.Data_For = 'A')
								INNER JOIN #Temp_Link_Run_Channel TRC ON TRC.Channel_Code = TRM.Channel_Code
								WHERE ADM.Acq_Deal_Movie_Code = @dealMovieCode_Link

								IF EXISTS (SELECT * FROM #Temp_Link_Run_Channel TRDM WHERE TRDM.Channel_Code NOT IN (
												SELECT DISTINCT Channel_Code FROM #Temp_LinkedShow_Channel))
								BEGIN
									PRINT 'WARNING - 05'
									INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Is_Warning ,Err_Message)
									SELECT @dealMovieCode_Link, @musicCode, 'Y', 'Show has not been linked with music library''s run defination for channels ' +  STUFF(
										(
											SELECT DISTINCT ', ' + ISNULL(C.Channel_Name, '') 
											FROM #Temp_Link_Run_Channel TRDM
											INNER JOIN Channel C ON C.Channel_Code = TRDM.Channel_Code
											WHERE TRDM.Channel_Code NOT IN (
												SELECT DISTINCT Channel_Code FROM #Temp_LinkedShow_Channel
											)
											FOR XML PATH('')
										), 1, 1, ''
									)
									+ '' AS Err_Message
								END

							END
							ELSE
							BEGIN
								PRINT 'WARNING - 06'
								INSERT INTO #Temp_Error(Deal_Movie_Code, Is_Warning ,Err_Message)
								VALUES(@dealMovieCode_Link, 'Y', 'Run definition is not added for title')
							END

							--- Fetch Next Row --
							UPDATE #Temp_Deal_Movie SET Process_Done = 'Y' WHERE Deal_Movie_Code = @dealMovieCode_Link
							SET @dealMovieCode_Link = 0
							SELECT TOP 1 @dealMovieCode_Link = Deal_Movie_Code FROM #Temp_Deal_Movie WHERE ISNULL(Process_Done, 'N') = 'N'
						END

					END
					ELSE
					BEGIN
						PRINT 'WARNING - 07'
						INSERT INTO #Temp_Error(Music_Code, Is_Warning ,Err_Message)
						VALUES(@musicCode, 'Y', 'Run Definition is not added for Music Library')
					END
					--- Ends Warning related coding here --

					--- Fetch Next Row --
					UPDATE #Temp_Music SET Process_Done = 'Y' WHERE Deal_Movie_Code = @dealMovieCode_MusicLibrary
					SELECT @dealMovieCode_MusicLibrary = 0, @musicCode = 0
					SELECT TOP 1 @dealMovieCode_MusicLibrary = Deal_Movie_Code, @musicCode = Music_Code FROM #Temp_Music WHERE ISNULL(Process_Done, 'N') = 'N'
				END
			END
		END
		ELSE
		BEGIN
			PRINT 'INSERT DATA IN Acq_Deal_Movie_Music TABLE'
			DECLARE @Deal_Movie_Code INT = 0, @totalNoOfSong INT = 0
			SELECT TOP 1 @Deal_Movie_Code = Deal_Movie_Code FROM #Temp_Combination
			SELECT TOP 1 @totalNoOfSong = Episode_Starts_From FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code = @Deal_Movie_Code

			DECLARE @recCount INT = 0;
			IF EXISTS(
				SELECT ADMM.* FROM Acq_Deal_Movie_Music ADMM
				INNER JOIN #Temp_Combination TC ON TC.Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code AND TC.Music_Code = ADMM.Music_Title_Code
			)
			BEGIN
				INSERT INTO #Temp_Error(Deal_Movie_Code, Music_Code, Is_Warning, Err_Message)
				SELECT DISTINCT ADMM.Acq_Deal_Movie_Code, ADMM.Music_Title_Code, 'N', 'Duplicate Record'
				FROM Acq_Deal_Movie_Music ADMM
				INNER JOIN #Temp_Combination TC ON TC.Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code AND TC.Music_Code = ADMM.Music_Title_Code

				SET @isError = 'Y'
			END
		
			SELECT @recCount = COUNT(*) FROM (
				SELECT Deal_Movie_Code, Music_Code FROM #Temp_Combination
				UNION 
				SELECT DISTINCT Acq_Deal_Movie_Code, Music_Title_Code FROM Acq_Deal_Movie_Music WHERE Acq_Deal_Movie_Code = @Deal_Movie_Code
			) AS TMP

			IF(@recCount > @totalNoOfSong AND @totalNoOfSong > 0)
			BEGIN
				INSERT INTO #Temp_Error(Deal_Movie_Code, Is_Warning, Err_Message)
				VALUES(@Deal_Movie_Code, 'N', 'Can not assign more than ' + CAST(@totalNoOfSong AS VARCHAR) + ' song(s)')

				SET @isError = 'Y'
			END

			IF(@isError = 'N')
			BEGIN
				PRINT 'All Ok, Inserting Data...'
				INSERT INTO Acq_Deal_Movie_Music(Acq_Deal_Movie_Code, Music_Title_Code, Is_Active, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By)
				SELECT Deal_Movie_Code, Music_Code, 'Y' AS Is_Active, @Login_User_Code AS Inserted_By, GETDATE() AS Inserted_On, 
				GETDATE() AS Last_UpDated_Time, @Login_User_Code AS Last_Action_By
				FROM #Temp_Combination
			END
		END
	END

	IF(OBJECT_ID('TEMPDB..#Temp_ErrorDetails') IS NOT NULL)
		DROP TABLE #Temp_ErrorDetails

	CREATE TABLE #Temp_ErrorDetails
	(
		Deal_Movie_Code INT,
		Music_Code INT,
		Agreement_No VARCHAR(MAX),
		Music_Library VARCHAR(MAX),
		Music_Title NVARCHAR(MAX),
		Movie_Album NVARCHAR(MAX),
		Title_Name NVARCHAR(MAX),
		Deal_Type VARCHAR(MAX),
		Episodes NVARCHAR(MAX),
		Is_Warning VARCHAR(1),
		Err_Message NVARCHAR(MAX)
	)

	IF(@Deal_Type_Condition = 'DEAL_MUSIC' AND @Link_Show = 'N')
	BEGIN
		PRINT 'Deal Type : Music, Called For : Assign Music'
		INSERT INTO #Temp_ErrorDetails(Music_Library, Music_Title, Movie_Album, Is_Warning, Err_Message)
		select DISTINCT DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Music_Library,
		ISNULL(MT.Music_Title_Name, '') AS Music_Title, MT.Movie_Album, TE.Is_Warning, TE.Err_Message
		FROM #Temp_Error TE
		LEFT JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TE.Deal_Movie_Code
		LEFT JOIN Title T ON T.Title_Code = ADM.Title_Code
		LEFT JOIN Music_Title MT ON TE.Music_Code = MT.Music_Title_Code
	END
	ELSE IF(@Deal_Type_Condition = 'DEAL_MUSIC' AND @Link_Show = 'Y')
	BEGIN
		PRINT 'Deal Type : Music, Called For : Link Show'
		INSERT INTO #Temp_ErrorDetails(Deal_Movie_Code, Music_Code, Music_Library, Music_Title, Agreement_No, Deal_Type, Title_Name, Is_Warning, Err_Message)
		SELECT DISTINCT TE.Deal_Movie_Code, TE.Music_Code,
		DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T_L.Title_Name, ADM_L.Episode_Starts_From, ADM_L.Episode_End_To) AS Music_Library,
		ISNULL(MT.Music_Title_Name, '') AS Music_Title, 
		CASE WHEN AD.Agreement_No IS NOT NULL THEN AD.Agreement_No ELSE AD_L.Agreement_No END AS Agreement_No, 
		CASE WHEN DT.Deal_Type_Name IS NOT NULL THEN DT.Deal_Type_Name ELSE DT_L.Deal_Type_Name END AS Deal_Type_Name, 
		DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name,
		TE.Is_Warning, TE.Err_Message
		FROM #Temp_Error TE
		LEFT JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TE.Deal_Movie_Code
		LEFT JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		LEFT JOIN Deal_Type DT ON DT.Deal_Type_Code = AD.Deal_Type_Code
		LEFT JOIN Title T ON T.Title_Code = ADM.Title_Code
		--- START Join For Music
		LEFT JOIN Acq_Deal_Movie_Music ADMM ON ADMM.Acq_Deal_Movie_Music_Code = TE.Music_Code
		LEFT JOIN Acq_Deal_Movie ADM_L ON ADM_L.Acq_Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code
		LEFT JOIN Acq_Deal AD_L ON AD_L.Acq_Deal_Code = ADM_L.Acq_Deal_Code
		LEFT JOIN Deal_Type DT_L ON DT_L.Deal_Type_Code = AD_L.Deal_Type_Code
		LEFT JOIN Title T_L ON T_L.Title_Code = ADM_L.Title_Code
		LEFT JOIN Music_Title MT ON MT.Music_Title_Code = ADMM.Music_Title_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD_L.Deal_Workflow_Status NOT IN ('AR', 'WA')
	END
	ELSE
	BEGIN
		PRINT 'Deal Type : Non-Music, Called For : Assign Music'

		DECLARE  @Deal_Type_Condition_Music VARCHAR(MAX) = ''
		SELECT TOP 1 @Deal_Type_Condition_Music = dbo.UFN_GetDealTypeCondition(Parameter_Value) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Music'

		INSERT INTO #Temp_ErrorDetails(Deal_Movie_Code, Music_Code, Title_Name, Agreement_No, Deal_Type, Music_Library, Music_Title, Movie_Album, Is_Warning, Err_Message)
		SELECT DISTINCT TE.Deal_Movie_Code, TE.Music_Code,
		DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name,
		CASE WHEN AD_L.Agreement_No IS NOT NULL THEN AD_L.Agreement_No ELSE AD.Agreement_No END AS Agreement_No, 
		CASE WHEN DT_L.Deal_Type_Name IS NOT NULL THEN DT_L.Deal_Type_Name ELSE DT.Deal_Type_Name END AS Deal_Type_Name, 
		DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition_Music, T_L.Title_Name, ADM_L.Episode_Starts_From, ADM_L.Episode_End_To) AS Music_Library,
		ISNULL(MT.Music_Title_Name, '') AS Music_Title, MT.Movie_Album, te.Is_Warning, TE.Err_Message
		FROM #Temp_Error TE
		LEFT JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TE.Deal_Movie_Code
		LEFT JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		LEFT JOIN Deal_Type DT ON DT.Deal_Type_Code = AD.Deal_Type_Code
		LEFT JOIN Title T ON T.Title_Code = ADM.Title_Code
		--- START Join For Music
		LEFT JOIN Acq_Deal_Movie_Music ADMM ON ADMM.Acq_Deal_Movie_Music_Code = TE.Music_Code
		LEFT JOIN Acq_Deal_Movie ADM_L ON ADM_L.Acq_Deal_Movie_Code = ADMM.Acq_Deal_Movie_Code
		LEFT JOIN Acq_Deal AD_L ON AD_L.Acq_Deal_Code = ADM_L.Acq_Deal_Code
		LEFT JOIN Deal_Type DT_L ON DT_L.Deal_Type_Code = AD_L.Deal_Type_Code
		LEFT JOIN Title T_L ON T_L.Title_Code = ADM_L.Title_Code
		LEFT JOIN Music_Title MT ON MT.Music_Title_Code = ADMM.Music_Title_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD_L.Deal_Workflow_Status NOT IN ('AR', 'WA')
	END
	
	UPDATE ED SET ED.Episodes = STUFF
		(
			(
				SELECT ', Episodes-' + CAST(E.Episode_No AS VARCHAR)
				FROM #Temp_Error E
				WHERE E.Deal_Movie_Code = ED.Deal_Movie_Code AND E.Music_Code = ED.Music_Code
				ORDER BY E.Episode_No
				FOR XML PATH('')
			), 1, 1, ''
		)
	FROM #Temp_ErrorDetails ED WHERE ED.Deal_Movie_Code IS NOT NULL AND ED.Music_Code IS NOT NULL AND Is_Warning = 'N'

	SELECT ISNULL(Agreement_No, 'NA') AS Agreement_No, ISNULL(Music_Library, 'NA') AS Music_Library, ISNULL(Music_Title, 'NA') AS Music_Title, 
	ISNULL(Movie_Album, 'NA') AS Movie_Album, 
	CASE WHEN CHARINDEX('terminated', ISNULL(Err_Message, '')) > 0 THEN 'NA' ELSE ISNULL(Title_Name, 'NA') END AS Title_Name, ISNULL(Deal_Type, 'NA') AS Deal_Type, 
	ISNULL(Episodes, 'NA') AS Episodes, ISNULL(Is_Warning, 'NA') AS Is_Warning, ISNULL(Err_Message, 'NA') AS Err_Message	FROM #Temp_ErrorDetails
	ORDER BY Is_Warning 
END
