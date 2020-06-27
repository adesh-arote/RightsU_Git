CREATE PROCEDURE [dbo].[USP_Acq_Termination_UDT] 
	@Termination_Deals Termination_Deals  READONLY,
	@Login_User_Code INT,
	@Syn_Error_Body VARCHAR(MAX),
	@Is_Validate_Error CHAR(1)
AS
---- =============================================
---- Author:		Abhaysingh N. Rajpurohit
---- Create date:	09 November 2015
---- Description:	This USP used to clone remaining deal tables
---- =============================================
---- Modification
---- =============================================
---- Task id         |     Updated By            |     Updated On       |    Description
---- 4215				 Navin Sapalya				   01 Dec 2015         Modified if condition for termination date less than Rights start date
---- =============================================

BEGIN
	/*

	Condition-1 :	If Movie Termination Date is < Acq Rights Start Date    
						Rights have one Title	=  Delete the Rights
						Rights have more than one Title	=  Remove the Title Rights

	Condition-2 :	If Movie Termination Date is between Acq Rights Period  
						Rights have one Title	=  Update the Rights End Date
						Rights have more than one Title	=  Create another Rights for that Title with Updated Rights end date and remove that title from original right

	Condition-3 :	If Movie Closed Date is > Acq Rights End Date 
						Remove Title Whose Episode From greater then Termination Episode No.

	*/

	--DECLARE
	--@Termination_Deals Termination_Deals,
	--@Login_User_Code INT = 143,
	--@Syn_Error_Body VARCHAR(MAX) = '',
	--@Is_Validate_Error CHAR(1) = 'N'

	--INSERT INTO @Termination_Deals(Deal_Code, Title_Code, Termination_Episode_No, Termination_Date)
	--SELECT 12365 AS Deal_Code, 20554 AS Title_Code, 0 AS Episode_No, NULL AS Termination_Date
	--UNION
	--SELECT 2847 AS Deal_Code, 12891 AS Title_Code, 55 AS Episode_No, '2016-11-30 00:00:00.000' AS Termination_Date

	IF(OBJECT_ID('TEMPDB..#Termination_Deals_Status') IS NOT NULL)
		DROP TABLE #Termination_Deals_Status
	IF(OBJECT_ID('TEMPDB..#RunDef') IS NOT NULL)
		DROP TABLE #RunDef
	IF(OBJECT_ID('TEMPDB..#Linked_Episodes') IS NOT NULL)
		DROP TABLE #Linked_Episodes
	IF(OBJECT_ID('TEMPDB..#Termination_Syn_Mail_Data') IS NOT NULL)
		DROP TABLE #Termination_Syn_Mail_Data

	CREATE TABLE #Termination_Deals_Status
	(
		Deal_Code INT,
		Title_Code INT,
		Episode_No INT,
		Termination_Date DATETIME,
		Is_Error CHAR(1),
		Error_Details NVARCHAR(MAX)
	)

	CREATE TABLE #Linked_Episodes
	(
		Deal_Code INT,
		Title_Code INT,
		Episode_No INT
	)

	CREATE TABLE #Termination_Syn_Mail_Data
	(
		Syn_Deal_Code INT,
		Agreement_No VARCHAR(100),
		Licensee NVARCHAR(200),
		Title_Code INT,
		Title_Name  NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT,
		Right_Start_Date DATETIME,
		Right_End_Date DATETIME,
		Entered_Eps_No INT,
		Entered_Termination_Date DATETIME
	)

	DECLARE @isError VARCHAR(1) = 'N'

	INSERT INTO #Termination_Deals_Status(Deal_Code, Title_Code, Episode_No, Termination_Date)
	SELECT ISNULL(Deal_Code,0) AS Deal_Code, ISNULL(Title_Code, 0) AS Title_Code, ISNULL(Termination_Episode_No, 0) AS Termination_Episode_No, Termination_Date 
	FROM @Termination_Deals
	
	INSERT INTO #Linked_Episodes(Deal_Code, Title_Code, Episode_No)
	SELECT DISTINCT ADM.Acq_Deal_Code, ADMML.Title_Code, ADMML.Episode_No  FROM Acq_Deal_Movie ADM
	INNER JOIN #Termination_Deals_Status TDS ON ADM.Title_Code = TDS.Title_Code
	INNER JOIN Acq_Deal_Movie_Music_Link ADMML ON ADM.Acq_Deal_Movie_Code = ADMML.Link_Acq_Deal_Movie_Code
		AND ADMML.Episode_No > TDS.Episode_No
	WHERE TDS.Deal_Code > 0 AND TDS.Title_Code > 0 AND TDS.Episode_No > 0 AND ADM.Acq_Deal_Code = TDS.Deal_Code AND 
	(TDS.Episode_No BETWEEN ADM.Episode_Starts_From AND ADM.Episode_End_To)
	
	IF EXISTS (SELECT * FROM #Linked_Episodes)
	BEGIN
		SET @isError = 'Y'
		UPDATE TDS 
		SET Is_Error = 'Y', Error_Details = A.Err_Message
		FROM #Termination_Deals_Status TDS
		INNER JOIN (
			SELECT DISTINCT Deal_Code, Title_Code,
			STUFF
			(
				(
					SELECT ', Episode-' + CAST(LE_I.Episode_No AS VARCHAR) FROM #Linked_Episodes LE_I
					WHERE LE_I.Deal_Code = LE.Deal_Code AND LE_I.Title_Code = LE.Title_Code
					ORDER BY LE_I.Episode_No
					FOR XML PATH('')
				), 1, 1, ''
			) + ' are already linked with music title' AS Err_Message
			FROM #Linked_Episodes LE
			GROUP BY Deal_Code, Title_Code
		) AS A ON A.Deal_Code = TDS.Deal_Code AND A.Title_Code = TDS.Title_Code
	END

	IF(@isError != 'Y')
	BEGIN
		IF (@Is_Validate_Error = 'Y')
		BEGIN
			DECLARE @dealCode INT = 0, @titleCode INT = 0, @episodeNo INT = 0, @terminationDate DATETIME = ''
			DECLARE @isProgram CHAR(1) = 'N', @mailBody NVARCHAR(MAX) = ''

			DECLARE cursorSynData CURSOR FOR
			SELECT DISTINCT Deal_Code, ISNULL(Title_Code, 0) AS Title_Code, Episode_No, Termination_Date FROM #Termination_Deals_Status
			OPEN cursorSynData
			FETCH NEXT FROM cursorSynData INTO @dealCode, @titleCode, @episodeNo, @terminationDate
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF NOT EXISTS (
					SELECT * FROM Acq_Deal_Termination_Details WHERE Acq_Deal_Code = @dealCode AND ISNULL(Title_Code, 0) = @titleCode AND
					(
						(@episodeNo = Termination_Episode_No AND Termination_Episode_No > 0 AND @episodeNo > 0) OR
						(@terminationDate = Termination_Date AND Termination_Date IS NOT NULL AND @terminationDate IS NOT NULL)
					)
				)
				BEGIN
					PRINT 'Fetching Syndication Data'
					DECLARE @minEpsFrom INT = 0, @maxEpsTo INT = 0, @minStartDate DATETIME = NULL , @maxEndDate DATETIME = NULL

					IF(@titleCode > 0)
					BEGIN

						PRINT 'Non-Movie Deal'
						SET @isProgram = 'Y'
						SELECT @minEpsFrom = MIN(SDRT.Episode_From), @maxEpsTo = MAX(SDRT.Episode_To), 
						@minStartDate = MIN(SDR.Actual_Right_Start_Date), @maxEndDate = MAX(ISNULL(SDR.Actual_Right_End_Date, '31Dec9999'))
						FROM Syn_Deal_Rights SDR
						INNER JOIN Syn_Acq_Mapping SAM ON SAM.Deal_Code = @dealCode AND SDR.Syn_Deal_Rights_Code = SAM.Syn_Deal_Rights_Code 
						INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDRT.Title_Code = @titleCode
					END
					ELSE
					BEGIN
						PRINT 'Movie Deal, Deal_Code : ' +  CAST(@dealCode AS VARCHAR)
						SELECT @minStartDate = MIN(SDR.Actual_Right_Start_Date), @maxEndDate = MAX(ISNULL(SDR.Actual_Right_End_Date, '31Dec9999'))
						FROM Syn_Deal_Rights SDR
						INNER JOIN Syn_Acq_Mapping SAM ON SAM.Deal_Code = @dealCode AND SDR.Syn_Deal_Rights_Code = SAM.Syn_Deal_Rights_Code 
					END

					IF(@isError != 'Y')
					BEGIN
						IF(
							(@episodeNo < @maxEpsTo AND ISNULL(@episodeNo, 0) > 0 AND @minEpsFrom > 0 AND @maxEpsTo > 0) OR
							(@terminationDate < @maxEndDate AND @terminationDate IS NOT NULL)
						)
						BEGIN
							PRINT 'Condition Got Satisfied'
							INSERT INTO #Termination_Syn_Mail_Data(Syn_Deal_Code, Agreement_No, Licensee, Title_Code, Title_Name,
							Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Entered_Eps_No,	Entered_Termination_Date)

							SELECT DISTINCT SD.Syn_Deal_Code, SD.Agreement_No, E.[Entity_Name], SDRT.Title_Code, T.Title_Name,
							SDRT.Episode_From, SDRT.Episode_To, SDR.Actual_Right_Start_Date, Actual_Right_End_Date,
							@episodeNo AS Entered_Eps_No, @terminationDate AS Entered_Termination_Date
							FROM Syn_Deal SD
							INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
							INNER JOIN Syn_Acq_Mapping SAM ON SAM.Deal_Code = @dealCode AND SDR.Syn_Deal_Rights_Code = SAM.Syn_Deal_Rights_Code 
							INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND (
								(SDRT.Title_Code = @titleCode AND @titleCode > 0) OR 
								(SDRT.Title_Code IN (SELECT Title_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Code = @dealCode) AND @titleCode = 0)
								)
							INNER JOIN Entity E ON E.Entity_Code = SD.Entity_Code
							INNER JOIN Title T ON T.Title_Code =SDRT.Title_Code
							WHERE (ISNULL(@episodeNo, 0) > 0 AND SDRT.Episode_To > ISNULL(@episodeNo, 0)) OR 
							(@terminationDate < ISNULL(SDR.Actual_Right_End_Date, '31Dec9999') AND @terminationDate IS NOT NULL)
						END
					END
				END
				FETCH NEXT FROM cursorSynData INTO @dealCode, @titleCode, @episodeNo, @terminationDate
			END
			CLOSE cursorSynData
			DEALLOCATE cursorSynData

			INSERT INTO dbo.Acq_Deal_Termination_Details(Acq_Deal_Code,Title_Code,Termination_Date,Termination_Episode_No,Users_Code,Created_Date)
			SELECT Tds.Deal_Code, CASE WHEN Tds.Title_Code > 0 THEN Tds.Title_Code ELSE NULL END, Tds.Termination_Date, tds.Episode_No, @Login_User_Code, GETDATE() 
			FROM #Termination_Deals_Status Tds

			UPDATE #Termination_Deals_Status
			SET Is_Error = 'Y', Error_Details = 'Syndication mail sent'

			IF EXISTS (SELECT * FROM #Termination_Syn_Mail_Data)
			BEGIN
				DECLARE @trTable NVARCHAR(MAX) = ''

				IF(@isProgram = 'Y')
				BEGIN
					SET @trTable = '<tr>      
						<td align="center" width="10%" class="tblHead"><b>Agreement_No<b></td>    
						<td align="center" width="15%" class="tblHead"><b>Licensee<b></td>      
						<td align="center" width="15%" class="tblHead"><b>Title<b></td>      
						<td align="center" width="10%" class="tblHead clsEpisode"><b>Episode Start<b></td>      
						<td align="center" width="10%" class="tblHead clsEpisode"><b>Episode End<b></td>      
						<td align="center" width="10%" class="tblHead"><b>Right Start Date<b></td>
						<td align="center" width="10%" class="tblHead"><b>Right End Date<b></td>
						<td align="center" width="10%" class="tblHead clsEpisode"><b>Termination Episode No.<b></td>
						<td align="center" width="10%" class="tblHead"><b>Termination Date<b></td>
					</tr>'
				END
				ELSE
				BEGIN
					SET @trTable = '<tr>      
						<td align="center" width="20%" class="tblHead"><b>Agreement_No<b></td>    
						<td align="center" width="20%" class="tblHead"><b>Licensee<b></td>      
						<td align="center" width="15%" class="tblHead"><b>Title<b></td>      
						<td align="center" width="15%" class="tblHead"><b>Right Start Date<b></td>
						<td align="center" width="15%" class="tblHead"><b>Right End Date<b></td>
						<td align="center" width="15%" class="tblHead"><b>Termination Date<b></td>
					</tr>'
				END

				DECLARE @preDealCode INT = 0, @preTitleCode INT = 0

				DECLARE @synDealCode_Html INT = 0, @agreementNo_Html VARCHAR(100) = '', @licensee_Html NVARCHAR(200) = '', @titleCode_Html INT = 0, 
				@titleName_Html NVARCHAR(100), @epsFrom_Html INT = 0, @epsTo_Html INT = 0, @rightStartDate_Html DATETIME, @rightEndDate_Html DATETIME,
				@enteredEpsNo_Html INT, @enteredTermDate_Html DATETIME

				DECLARE cursorGenHtml CURSOR FOR
				SELECT Syn_Deal_Code, Agreement_No, Licensee, Title_Code, Title_Name,
						Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Entered_Eps_No,	Entered_Termination_Date 
						FROM #Termination_Syn_Mail_Data
						ORDER BY Syn_Deal_Code, Title_Code
				OPEN cursorGenHtml
				FETCH NEXT FROM cursorGenHtml INTO @synDealCode_Html, @agreementNo_Html, @licensee_Html, @titleCode_Html, @titleName_Html, 
				@epsFrom_Html, @epsTo_Html, @rightStartDate_Html, @rightEndDate_Html, @enteredEpsNo_Html, @enteredTermDate_Html
				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @isPreTitle CHAR(1) = 'Y'
					DECLARE @rowSpanCount INT = 0
					SET @trTable = @trTable + '<tr>'
					IF(@preDealCode != @synDealCode_Html)
					BEGIN
						SET @preDealCode = @synDealCode_Html
						SET @preTitleCode = 0
						SET @rowSpanCount = 0

						SELECT @rowSpanCount = COUNT(*) FROM #Termination_Syn_Mail_Data WHERE Syn_Deal_Code = @synDealCode_Html
						SET @trTable = @trTable + '<td align="center" rowspan="' + CAST(@rowSpanCount AS VARCHAR) + '" class="tblData">' + @agreementNo_Html + '</td>    
						<td align="center" rowspan="' + CAST(@rowSpanCount AS VARCHAR) + '" class="tblData">' + @licensee_Html + '</td>'
					END

					IF(@preTitleCode != @titleCode_Html)
					BEGIN
						SET @preTitleCode = @titleCode_Html
						SET @isPreTitle = 'N'
						SET @rowSpanCount = 0

						SELECT @rowSpanCount = COUNT(*) FROM #Termination_Syn_Mail_Data WHERE Syn_Deal_Code = @synDealCode_Html AND Title_Code = @titleCode_Html
						SET @trTable = @trTable + '<td align="center" rowspan="' + CAST(@rowSpanCount AS VARCHAR) + '" class="tblData">' + @titleName_Html + '</td>'
					END

					IF(@isProgram = 'Y')
					BEGIN
						SET @trTable = @trTable + '<td align="center" class="tblData">' + ISNULL(CAST(@epsFrom_Html AS VARCHAR), '') + '</td>    
						<td align="center" class="tblData">' + ISNULL(CAST(@epsTo_Html AS VARCHAR), '') + '</td>'
					END

					SET @trTable = @trTable + '<td align="center" class="tblData">' 
					+ CASE WHEN @rightStartDate_Html IS NULL THEN '' ELSE CONVERT(VARCHAR(11), @rightStartDate_Html, 113) END + '</td>    
						<td align="center" class="tblData">' 
						+ CASE WHEN @rightEndDate_Html IS NULL THEN '' ELSE CONVERT(VARCHAR(11), @rightEndDate_Html, 113) END + '</td>'

					IF(@isPreTitle = 'N')
					BEGIN
						IF(@isProgram = 'Y')
							SET @trTable = @trTable + '<td align="center" rowspan="' + CAST(@rowSpanCount AS VARCHAR) + '" class="tblData">' 
							+ ISNULL(CAST(@enteredEpsNo_Html AS VARCHAR), '') + '</td>'

						SET @trTable = @trTable + '<td align="center" rowspan="' + CAST(@rowSpanCount AS VARCHAR) + '" class="tblData">' 
						+ CASE WHEN @enteredTermDate_Html IS NULL THEN '' ELSE CONVERT(VARCHAR(11), @enteredTermDate_Html, 113) END + '</td>'
					END
					SET @trTable = @trTable + '</tr>'

					FETCH NEXT FROM cursorGenHtml INTO @synDealCode_Html, @agreementNo_Html, @licensee_Html, @titleCode_Html, @titleName_Html, 
					@epsFrom_Html, @epsTo_Html, @rightStartDate_Html, @rightEndDate_Html, @enteredEpsNo_Html, @enteredTermDate_Html
				END
				CLOSE cursorGenHtml
				DEALLOCATE cursorGenHtml

				SELECT TOP 1 @mailBody = Template_Desc FROM Email_Template WHERE Template_For = 'TERM'
				SET @mailBody = REPLACE(@mailBody, '{TABLE_DATA}', @trTable)
		
				DECLARE @sendMailToCreater CHAR(1) = 'N'
				SELECT TOP 1 @sendMailToCreater = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Send_Mail_To_Creater_Termination'
				IF(@sendMailToCreater = 'Y')
				BEGIN
					DECLARE @ccMailId VARCHAR(100) = ''
					SELECT TOP 1 @ccMailId = Email_Id FROM Users WHERE Users_Code = @Login_User_Code

					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name='rightsu_uto', @recipients='abhay@uto.in', @copy_recipients = @ccMailId,
					@subject='Test Mail', @body_format = 'HTML', @body=@mailBody
				END
				ELSE
				BEGIN
					EXEC msdb.dbo.sp_send_dbmail @profile_name='rightsu_uto',@recipients='abhay@uto.in', 
					@subject='Test Mail',@body_format = 'HTML' ,@body=@mailBody
				END
			END
		END
	
		DECLARE @Deal_Code INT, @Title_Code INT, @Episode_No INT, @Termination_Date DATETIME

		IF NOT EXISTS (SELECT * FROM #Termination_Deals_Status WHERE Is_Error = 'Y')
		BEGIN
			DECLARE @lastDealCode INT = 0
			DECLARE cursorTermination_Deals CURSOR FOR
			SELECT Deal_Code, Title_Code, Episode_No, Termination_Date  FROM #Termination_Deals_Status ORDER BY Deal_Code

			OPEN cursorTermination_Deals
			FETCH NEXT FROM cursorTermination_Deals INTO @Deal_Code, @Title_Code, @Episode_No, @Termination_Date
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT '@Deal_Code : ' + CAST(@Deal_Code AS VARCHAR)
				PRINT '@Title_Code : ' + CAST(@Title_Code AS VARCHAR)
				PRINT '@Episode_No : ' + CAST(@Episode_No AS VARCHAR)
				PRINT '@Termination_Date : ' + CAST(@Termination_Date AS VARCHAR)

				DECLARE @Acq_Deal_Rights_Code INT, @Right_Start_Date DATETIME, @Right_End_Date DATETIME, @Right_Type varchar(2), @ADRun_Code VARCHAR(MAX) = ''
				DECLARE @New_Acq_Deal_Rights_Code INT
		
				DECLARE cursorRights CURSOR FOR
				SELECT ADR.Acq_Deal_Rights_Code, ADR.Actual_Right_Start_Date, ISNULL(ADR.Actual_Right_End_Date, '9999-12-31'), ADR.Right_Type FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
					AND ADR.Acq_Deal_Code = @Deal_Code AND (ADRT.Title_Code = @Title_Code Or @Title_Code = 0)
				WHERE (Right_Type IN ('Y', 'U') OR (Right_Type = 'M' AND ADR.Actual_Right_End_Date IS NOT NULL)) 
					AND ((@Episode_No < ADRT.Episode_To AND @Episode_No > 0) OR  @Termination_Date < ISNULL(ADR.Actual_Right_End_Date, '9999-12-31'))

				OPEN cursorRights
				FETCH NEXT FROM cursorRights INTO @Acq_Deal_Rights_Code, @Right_Start_Date, @Right_End_Date, @Right_Type
				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @titleCount INT = 0, @minEpisodeFrom INT = 0, @maxEpisodeTo INT = 0
				
					SELECT @titleCount = COUNT( DISTINCT Title_Code) FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
					AND Title_Code <> @Title_Code

					SELECT @minEpisodeFrom  = MIN(Episode_From) FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
					AND (Title_Code = @Title_Code OR @Title_Code = 0)

					SELECT @maxEpisodeTo  = MAX(Episode_To) FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
					AND (Title_Code = @Title_Code OR @Title_Code = 0)

					PRINT '@Acq_Deal_Rights_Code : ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR)
					PRINT '@titleCount : ' + CAST(@titleCount AS VARCHAR)
					PRINT '@minEpisodeFrom : ' + CAST(@minEpisodeFrom AS VARCHAR)
					PRINT '@@maxEpisodeTo : ' + CAST(@maxEpisodeTo AS VARCHAR)
					PRINT '@Right_Start_Date : ' + CAST(@Right_Start_Date AS VARCHAR)
					PRINT '@Right_End_Date : ' + CAST(@Right_End_Date AS VARCHAR)

					IF(	
						(@Termination_Date < @Right_Start_Date AND @Termination_Date IS NOT NULL) OR 
						(@minEpisodeFrom > @Episode_No AND @Episode_No > 0)
					)
					BEGIN
						IF(@Title_Code = 0 OR @titleCount = 0)
						BEGIN
							PRINT 'Condition A(1) :-
									Delete this Rights because,
									1. We are termination All titles (when @Title_Code = 0) or 
									2. This Rights contains only one title (when @titleCount = 0) which we are terminating'
						
							--Holdback
							DELETE FROM Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN
							(
								SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							)
							DELETE FROM Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN
							(
								SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							) 
							DELETE FROM Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN
							(
								SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							)
							DELETE FROM Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN
							(
								SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							) 
							DELETE FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

							--Blackout
							DELETE FROM Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN
							(
								SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							) 
							DELETE FROM Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN
							(
								SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							) 
							DELETE FROM Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN
							(
								SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout 	WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							)
							DELETE FROM Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN
							(
								SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							) 
							DELETE FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
	
							--Rights
							DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							DELETE FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							DELETE FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							DELETE FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							DELETE FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							DELETE FROM Acq_Deal_Rights  WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

							--- Complete Rights ---

						END
						ELSE
						BEGIN
							PRINT 'Condition A(2) :-
								Delete current title from this rights because,
								1. This Rights contains more then one title (when @titleCount > 0)'
						
							DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code 
						END
					END
					ELSE IF(
						(@Termination_Date >= @Right_Start_Date AND @Termination_Date <= @Right_End_Date) OR 
						(@minEpisodeFrom < @Episode_No AND  @maxEpisodeTo > @Episode_No AND @Episode_No > 0)
					)
					BEGIN
						IF(@Termination_Date IS NULL OR (@Termination_Date >= @Right_End_Date AND @Termination_Date IS NOT NULL))
						BEGIN
							PRINT 'Condition B(1) :-
										Change Only Episode No,'
							UPDATE Acq_Deal_Rights_Title SET Episode_To = @Episode_No
							Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
							AND Title_Code = @Title_Code AND @Episode_No BETWEEN Episode_From AND Episode_To

							DELETE ADRTE FROM Acq_Deal_Rights_Title_EPS ADRTE 
							INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code AND
							ADRT.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND ADRTE.EPS_No > @Episode_No
							AND ADRT.Title_Code = @Title_Code AND @Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To
						END
						ELSE
						BEGIN
							IF(@Title_Code = 0 OR @titleCount = 0)
							BEGIN
								PRINT 'Condition B(2) :-
										Change Rights End Date,
										1. We are termination All titles (when @Title_Code = 0) or 
										2. This Rights contains only one title (when @titleCount = 0) which we are terminating'

								IF(@Right_Type = 'M')
								BEGIN
									UPDATE Acq_Deal_Rights SET Actual_Right_End_Date = @Termination_Date, 
									Milestone_No_Of_Unit = CAST(CAST([dbo].[UFN_Calculate_Term](Actual_Right_Start_Date,@Termination_Date) as float) as int), Right_Type ='M'
									WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								END
								ELSE
								BEGIN
									UPDATE Acq_Deal_Rights SET Right_End_Date = @Termination_Date, Actual_Right_End_Date = @Termination_Date, 
									Term = [dbo].[UFN_Calculate_Term](Right_Start_Date,@Termination_Date), Right_Type ='Y'
									WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								END

								UPDATE Acq_Deal_Rights_Title SET Episode_To = @Episode_No
								Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
								AND @Episode_No BETWEEN Episode_From AND Episode_To AND @Episode_No > 0

								DELETE ADRTE FROM Acq_Deal_Rights_Title_EPS ADRTE 
								INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code AND
								ADRT.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND ADRTE.EPS_No > @Episode_No
								AND @Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To AND @Episode_No > 0
							END
							ELSE
							BEGIN
								PRINT 'Condition B(3) :-
										Added New Rights for Current Title'
						
								PRINT 'Inserting in Acq_Deal_Rights'
								INSERT INTO Acq_Deal_Rights(Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
									Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
									ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
									Last_Updated_Time, Last_Action_By)
								Select @Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
									'Y', Is_Tentative, Term, Right_Start_Date, @Termination_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
									ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, @Termination_Date, Inserted_By, Inserted_On, 
									Last_Updated_Time, Last_Action_By
								FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights'
				
								SELECT @New_Acq_Deal_Rights_Code = IDENT_CURRENT('Acq_Deal_Rights')

								/**************** Insert into Acq_Deal_Rights_Title ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Title'
								INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
								SELECT @New_Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, 
								CASE WHEN @Episode_No < ADRT.Episode_To AND @Episode_No > 0 THEN @Episode_No ELSE ADRT.Episode_To END AS Episode_To
								FROM Acq_Deal_Rights_Title ADRT 
								Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code AND (
									Episode_To < @Episode_No OR
									(@Episode_No BETWEEN Episode_From AND Episode_To) OR 
									@Episode_No = 0
								)
								PRINT 'Inserted in Acq_Deal_Rights_Title'
								/**************** Insert into Acq_Deal_Rights_Title_Eps ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Title_Eps'
								INSERT INTO Acq_Deal_Rights_Title_Eps (Acq_Deal_Rights_Title_Code, EPS_No)
								SELECT 
									AtADRT.Acq_Deal_Rights_Title_Code, ADRTE.EPS_No
									FROM Acq_Deal_Rights_Title_EPS ADRTE 
									INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code
									INNER JOIN Acq_Deal_Rights_Title AtADRT On 
										CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)
										=
										CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)
										WHERE ADRT.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRT.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
										AND ADRTE.EPS_No <= @Episode_No
								PRINT 'Inserted in Acq_Deal_Rights_Title_Eps'
								/**************** Insert into Acq_Deal_Rights_Platform ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Platform'
								INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)	
								SELECT @New_Acq_Deal_Rights_Code, ADRP.Platform_Code
								FROM Acq_Deal_Rights_Platform ADRP Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Platform'
								/**************** Insert into Acq_Deal_Rights_Territory ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Territory'
								INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)	
								SELECT @New_Acq_Deal_Rights_Code, ADRT.Territory_Code, ADRT.Territory_Type, ADRT.Country_Code
								FROM Acq_Deal_Rights_Territory ADRT Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Territory'
								/**************** Insert into Acq_Deal_Rights_Subtitling ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Subtitling'
								INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
								SELECT @New_Acq_Deal_Rights_Code, ADRS.Language_Code, ADRS.Language_Group_Code, ADRS.Language_Type
								FROM Acq_Deal_Rights_Subtitling ADRS Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Subtitling'
								/**************** Insert into Acq_Deal_Rights_Dubbing ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Dubbing'
								INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
								SELECT @New_Acq_Deal_Rights_Code, ADRD.Language_Code, ADRD.Language_Group_Code, ADRD.Language_Type
								FROM Acq_Deal_Rights_Dubbing ADRD Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Dubbing'
								/**************** Insert into Acq_Deal_Rights_Holdback ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Holdback'
								INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code, 
									Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
									Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)
								SELECT @New_Acq_Deal_Rights_Code, 
									ADRH.Holdback_Type, ADRH.HB_Run_After_Release_No, ADRH.HB_Run_After_Release_Units, 
									ADRH.Holdback_On_Platform_Code, ADRH.Holdback_Release_Date, ADRH.Holdback_Comment, ADRH.Is_Title_Language_Right
								FROM Acq_Deal_Rights_Holdback ADRH Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Holdback'
								/******** Insert into Acq_Deal_Rights_Holdback_Dubbing ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Holdback_Dubbing'
								INSERT INTO Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Code, Language_Code)
								SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHD.Language_Code
								FROM Acq_Deal_Rights_Holdback_Dubbing ADRHD INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
									INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
										CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
										=
										CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
										WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Holdback_Dubbing'
								/******** Insert into Acq_Deal_Rights_Holdback_Platform ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Holdback_Platform'
								INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)
								SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHP.Platform_Code
								FROM Acq_Deal_Rights_Holdback_Platform ADRHP INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
									INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON 
										CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
										=
										CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '') 
										WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Holdback_Platform'
								/******** Insert into Acq_Deal_Rights_Holdback_Subtitling ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Holdback_Platform'
								INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (Acq_Deal_Rights_Holdback_Code, Language_Code)
								SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHS.Language_Code
								FROM Acq_Deal_Rights_Holdback_Subtitling ADRHS INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
									INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
										CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
										=
										CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
										WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserting in Acq_Deal_Rights_Holdback_Subtitling'
								/******** Insert into Acq_Deal_Rights_Holdback_Territory ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Holdback_Territory'
								INSERT INTO Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
								SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code
								FROM Acq_Deal_Rights_Holdback_Territory ADRHT INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
									INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
										CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
										=
										CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
										ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '') 
										WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Holdback_Platform'
								/**************** Insert into Acq_Deal_Rights_Blackout ****************/ 
								PRINT 'Inserting in Acq_Deal_Rights_Blackout'
								INSERT INTO Acq_Deal_Rights_Blackout (Acq_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
								SELECT @New_Acq_Deal_Rights_Code, ADRB.Start_Date, ADRB.End_Date, ADRB.Inserted_By, ADRB.Inserted_On, ADRB.Last_Updated_Time, ADRB.Last_Action_By
								FROM Acq_Deal_Rights_Blackout ADRB WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Blackout'
								/******** Insert into Acq_Deal_Rights_Blackout_Dubbing ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Blackout_Dubbing'
								INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Code, Language_Code)
								SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBD.Language_Code
								FROM Acq_Deal_Rights_Blackout_Dubbing ADRBD 
									INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
									INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
										CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
										=
										CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR)
										WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Blackout_Dubbing'
								/******** Insert into Acq_Deal_Rights_Blackout_Platform ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Blackout_Platform'
								INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Code, Platform_Code)
								SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBP.Platform_Code
								FROM Acq_Deal_Rights_Blackout_Platform ADRBP INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
									INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON 
										CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
										=
										CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
										WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Blackout_Platform'
								/******** Insert into Acq_Deal_Rights_Blackout_Subtitling ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Blackout_Subtitling'
								INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Code, Language_Code)
								SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBS.Language_Code
								FROM Acq_Deal_Rights_Blackout_Subtitling ADRBS INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
									INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON 
										CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
										=
										CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
										WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Blackout_Subtitling'
								/******** Insert into Acq_Deal_Rights_Blackout_Territory ********/ 
								PRINT 'Inserting in Acq_Deal_Rights_Blackout_Territory'
								INSERT INTO Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)
								SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBT.Country_Code, ADRBT.Territory_Code, ADRBT.Territory_Type
								FROM Acq_Deal_Rights_Blackout_Territory ADRBT INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
									INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
										CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
										=
										CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
										CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
										CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
										WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code
								PRINT 'Inserted in Acq_Deal_Rights_Blackout_Territory'
								/******** Delete Title From Old Acq_Deal_Rights_Title********/ 

								DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code 
						
							END
						END
					END
					--- *** Delete/ Update Run Definition for Title ***

					---* If Run Def is added for that title whose Episode_From is greater then Termination_Episode No.
					IF (@Title_Code > 0)
					BEGIN
						SET @ADRun_Code = ''
						SELECT @ADRun_Code = @ADRun_Code + CAST(ADR.Acq_Deal_Run_Code AS VARCHAR) + ',' FROM Acq_Deal_Run ADR
						INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
						WHERE ADR.Acq_Deal_Code = @Deal_Code AND ADRT.Title_Code = @Title_Code AND ADRT.Episode_From > @Episode_No AND @Episode_No > 0
					
						PRINT '@Title_Code > 0 @ADRun_Code : ' + @ADRun_Code
						DELETE FROM Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADRun_Code, ','))
						DELETE FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADRun_Code, ','))
						DELETE FROM Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADRun_Code, ','))
						DELETE FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADRun_Code, ','))
						DELETE FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADRun_Code, ','))
						DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADRun_Code, ','))
					END

					IF(OBJECT_ID('TEMPDB..#TEMP_Run_Def') IS NOT NULL)
					DROP TABLE #TEMP_Run_Def

					SELECT DISTINCT ADRun.Acq_Deal_Run_Code, ISNULL(No_Of_Runs, 0) AS No_Of_Runs, ISNULL(Is_Yearwise_Definition, 'N') AS Is_Year_Based, 
					isnull(Is_Channel_Definition_Rights, 'N') AS Is_Channel_Defined, Run_Definition_Type, 'N' AS Process_Done INTO #TEMP_Run_Def FROM Acq_Deal_Run ADRun
					INNER JOIN Acq_Deal_Run_Title ADRunT ON ADRun.Acq_Deal_Run_Code = ADRunT.Acq_Deal_Run_Code AND (ADRunT.Title_Code = @Title_Code OR @Title_Code = 0)
					WHERE ADRun.Acq_Deal_Code =@Deal_Code

					DECLARE @Acq_Deal_Run_Code INT = 0, @No_Of_Run_Old INT = 0, @No_Of_Run_New INT = 0, @isYearBased CHAR(1), @isChannelDefined CHAR(1), 
							@runDefinitionType CHAR(1)

					SELECT TOP 1 @Acq_Deal_Run_Code = Acq_Deal_Run_Code, @No_Of_Run_Old = No_Of_Runs, @isYearBased = Is_Year_Based, 
					@isChannelDefined = Is_Channel_Defined, @runDefinitionType = Run_Definition_Type
					FROM #TEMP_Run_Def WHERE Process_Done = 'N'

					WHILE(@Acq_Deal_Run_Code > 0)
					BEGIN
						IF(@Termination_Date IS NULL OR (@Termination_Date >= @Right_End_Date AND @Termination_Date IS NOT NULL))
						BEGIN
							PRINT '@Termination_Date IS NULL, 
							Change only Episode_To in Acq_Deal_Run_Title'
							UPDATE ADRT SET ADRT.Episode_To =  @Episode_No FROM Acq_Deal_Run ADR
							INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
							WHERE ADR.Acq_Deal_Run_Code = @Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code 
							AND (@Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To) AND @Episode_No > 0
						END
						ELSE
						BEGIN
							IF(@isYearBased = 'Y' AND @isYearBased <> '')
							BEGIN
								PRINT 'YearBased Run, 
								Change only Episode_To in Acq_Deal_Run_Title'
								DECLARE @ADR_Run_Year_Codes VARCHAR(MAX) = ''
								SELECT @ADR_Run_Year_Codes = @ADR_Run_Year_Codes + CAST(ADRY.Acq_Deal_Run_Yearwise_Run_Code AS VARCHAR) + ','
								FROM Acq_Deal_Run_Yearwise_Run ADRY where ADRY.Acq_Deal_Run_Code = @Acq_Deal_Run_Code
								AND ADRY.Start_Date > @Termination_Date

								PRINT '@ADR_Run_Year_Codes : ' + @ADR_Run_Year_Codes

								DELETE FROM Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Yearwise_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADR_Run_Year_Codes, ','))
								DELETE FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Yearwise_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@ADR_Run_Year_Codes, ','))

								IF NOT EXISTS (SELECT * FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code)
								BEGIN
									PRINT '0 Record found in Acq_Deal_Run_Yearwise_Run'
									DELETE FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
									DELETE FROM Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
									DELETE FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
									DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
								END
								ELSE
								BEGIN
									PRINT 'Manage Run Properly'
									UPDATE ADRT SET ADRT.Episode_To =  @Episode_No FROM Acq_Deal_Run ADR
									INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
									WHERE ADR.Acq_Deal_Run_Code = @Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code 
									AND (@Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To) AND @Episode_No > 0

									UPDATE Acq_Deal_Run_Yearwise_Run SET End_Date = @Termination_Date WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
									AND @Termination_Date BETWEEN Start_Date AND End_Date

									SELECT @No_Of_Run_New = SUM(ISNULL(No_Of_Runs, 0)) FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

									IF(@No_Of_Run_New <> @No_Of_Run_Old)
									BEGIN
										DECLARE @changePercentage DECIMAL
										DECLARE @totalRunConsumed INT = 0, @totalRemainingRuns INT = 0
										DECLARE @primeTotalRun INT, @offPrimeTotalRun INT, @primeConsumedRun INT, @offPrimeConsumedRun INT
										DECLARE @sumOfMin INT = 0, @sumOfMax INT  = 0
										DECLARE @Is_Prime_OffPrime_Defined CHAR(1) = 'N'

										IF(@isChannelDefined <> '' AND @isChannelDefined = 'Y')
										BEGIN

											DECLARE @channelCode INT = 0
											IF(@runDefinitionType IN ('C', 'CS', 'N'))
											BEGIN
												SELECT @totalRunConsumed = 0, @totalRemainingRuns = 0
												SELECT @totalRunConsumed = SUM(ISNULL(No_Of_Runs_Sched, 0)) FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

												SET @changePercentage = ((@No_Of_Run_New * 100) / @No_Of_Run_Old)

												IF EXISTS (
													SELECT * FROM Acq_Deal_Run_Channel WHERE ISNULL(No_Of_Runs_Sched, 0) > ((Min_Runs * @changePercentage) / 100)
													AND Acq_Deal_Run_Code  = @Acq_Deal_Run_Code
												)
												BEGIN
													SET @totalRemainingRuns = (@No_Of_Run_New - (@primeConsumedRun + @offPrimeConsumedRun))
													SET @changePercentage = ((@totalRemainingRuns * 100) / @No_Of_Run_Old)

													UPDATE Acq_Deal_Run_Channel SET 
													Min_Runs = CAST(ROUND(((ISNULL(Min_Runs, 0) * @changePercentage) / 100) + ISNULL(No_Of_Runs_Sched, 0), 0) AS INT)
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code

													SET @changePercentage = ((@No_Of_Run_New * 100) / @No_Of_Run_Old)
													--- This should be update on flat percentage
													UPDATE Acq_Deal_Run_Channel SET 
													Max_Runs = CAST(ROUND(((ISNULL(Max_Runs, 0) * @changePercentage) / 100), 0) AS INT)
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code AND Max_Runs IS NOT NULL

												END
												ELSE
												BEGIN
													PRINT 'Update On flat Percentage' 
													UPDATE Acq_Deal_Run_Channel SET 
													Min_Runs = CAST(ROUND(((ISNULL(Min_Runs, 0) * @changePercentage) / 100), 0) AS INT)
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code

													UPDATE Acq_Deal_Run_Channel SET 
													Max_Runs = CAST(ROUND(((ISNULL(Max_Runs, 0) * @changePercentage) / 100), 0) AS INT)
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code AND Max_Runs IS NOT NULL
												END

												SELECT @sumOfMin = SUM(ISNULL(Min_Runs, 0)), @sumOfMax = SUM(ISNULL(MAX_Runs, 0)) 
												FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code 
										
												SET @channelCode = 0

												IF(@sumOfMin > @sumOfMax)
												BEGIN
													SELECT @channelCode = MAX(Acq_Deal_Run_Channel_Code) FROM Acq_Deal_Run_Channel 
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code AND  ISNULL(Max_Runs, 0) > 0

													UPDATE Acq_Deal_Run_Channel SET Max_Runs = ISNULL(Max_Runs, 0) + (@sumOfMin - @sumOfMax) 
													WHERE Acq_Deal_Run_Channel_Code  = @channelCode
												END
												ELSE IF(@sumOfMin < @sumOfMax)
												BEGIN
													SELECT @channelCode = MAX(Acq_Deal_Run_Channel_Code) FROM Acq_Deal_Run_Channel 
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code AND ISNULL(Min_Runs, 0) > 0

													UPDATE Acq_Deal_Run_Channel SET Min_Runs = ISNULL(Min_Runs, 0) + (@sumOfMax - @sumOfMin) 
													WHERE Acq_Deal_Run_Channel_Code  = @channelCode
												END
											END
										END

										IF(@runDefinitionType = 'A')
										BEGIN
											PRINT 'Incase of 1 Run Per Channel'
											UPDATE Acq_Deal_Run_Yearwise_Run SET 
											No_Of_Runs = CAST(ROUND((ISNULL(No_Of_Runs, 0) + (@No_Of_Run_Old - @No_Of_Run_New)), 0) AS INT)
											WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
											AND @Termination_Date BETWEEN Start_Date AND End_Date
										END
										ELSE
										BEGIN
											UPDATE Acq_Deal_Run SET No_Of_Runs = @No_Of_Run_New WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

											SELECT @totalRunConsumed = 0, @totalRemainingRuns = 0
											SELECT @primeTotalRun = ISNULL(Prime_Run, 0), @offPrimeTotalRun = ISNULL(Off_Prime_Run,0),
											@primeConsumedRun = ISNULL(Prime_Time_Provisional_Run_Count, 0), 
											@offPrimeConsumedRun = ISNULL(Off_Prime_Time_Provisional_Run_Count, 0)
											FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

											IF(@primeTotalRun > 0 OR @offPrimeTotalRun > 0)
												SET @Is_Prime_OffPrime_Defined = 'Y'


											IF(@Is_Prime_OffPrime_Defined = 'Y')
											BEGIN
												SET @changePercentage = ((@No_Of_Run_New * 100) / @No_Of_Run_Old)

												IF(	(@primeConsumedRun > ((@primeTotalRun * @changePercentage) / 100)) OR 
													(@offPrimeConsumedRun > ((@offPrimeTotalRun * @changePercentage) / 100))
												)
												BEGIN
													SET @totalRemainingRuns = (@No_Of_Run_New - (@primeConsumedRun + @offPrimeConsumedRun))
													SET @changePercentage = ((@totalRemainingRuns * 100) / @No_Of_Run_Old)

													UPDATE Acq_Deal_Run SET 
													Prime_Run =  CAST(ROUND(((Prime_Run * @changePercentage) / 100) + @primeConsumedRun, 0) AS INT),
													Off_Prime_Run = CAST(ROUND(((Off_Prime_Run * @changePercentage) / 100) + @primeConsumedRun, 0) AS INT)
													WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
												END
												ELSE
												BEGIN
													UPDATE Acq_Deal_Run SET 
													Prime_Run =  CAST(ROUND(((Prime_Run * @changePercentage) / 100), 0) AS INT),
													Off_Prime_Run = CAST(ROUND(((Off_Prime_Run * @changePercentage) / 100), 0) AS INT)
													WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
												END
											END

											DECLARE @sumOfRuns_Run INT = 0, @sumOfRuns_YWR INT = 0, @sumOfRuns_Channel INT = 0,  @maxRun INT = 0

											IF(@Is_Prime_OffPrime_Defined = 'Y')
												SELECT @sumOfRuns_Run = (ISNULL(Prime_Run, 0) + ISNULL(Off_Prime_Run,0)) FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
											ELSE
												SELECT @sumOfRuns_Run = No_Of_Runs FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

											SELECT @sumOfRuns_YWR = SUM(ISNULL(No_Of_Runs,0)) FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
											SELECT @sumOfRuns_Channel = SUM(ISNULL(Min_Runs,0)) FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

											SET @maxRun = @sumOfRuns_Run

											IF(@maxRun < @sumOfRuns_YWR)
												SET @maxRun = @sumOfRuns_YWR

											IF(@maxRun < @sumOfRuns_Channel)
												SET @maxRun = @sumOfRuns_Channel

											IF(@maxRun > @sumOfRuns_Run)
											BEGIN
												UPDATE Acq_Deal_Run SET 
												No_Of_Runs = No_Of_Runs + (@maxRun - @sumOfRuns_Run)
												WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

												IF(@Is_Prime_OffPrime_Defined = 'Y')
												BEGIN
													IF(
														(SELECT TOP 1 (ISNULL(Prime_Run, 0) + ISNULL(Off_Prime_Run, 0)) 
														FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code) < @maxRun
													)
													BEGIN
														IF(@primeTotalRun > @offPrimeTotalRun)
														BEGIN
															UPDATE Acq_Deal_Run SET Prime_Run = Prime_Run + (@maxRun - @sumOfRuns_Run)
															WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
														END
														ELSE
														BEGIN
															UPDATE Acq_Deal_Run SET Off_Prime_Run = Off_Prime_Run + (@maxRun - @sumOfRuns_Run)
															WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
														END
													END
												END
											END

											IF(@maxRun > @sumOfRuns_YWR)
											BEGIN
										
												SELECT @channelCode = MAX(Acq_Deal_Run_Yearwise_Run_Code) FROM Acq_Deal_Run_Yearwise_Run 
												WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code

												UPDATE Acq_Deal_Run_Yearwise_Run SET 
												No_Of_Runs = No_Of_Runs + (@maxRun - @sumOfRuns_YWR)
												WHERE Acq_Deal_Run_Yearwise_Run_Code = @channelCode
											END

											IF(@maxRun > @sumOfRuns_Channel)
											BEGIN
												SELECT TOP 1 @channelCode = Acq_Deal_Run_Channel_Code FROM Acq_Deal_Run_Channel 
												WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
												ORDER BY Min_Runs DESC

												UPDATE Acq_Deal_Run_Channel SET 
												Min_Runs = Min_Runs + (@maxRun - @sumOfRuns_Channel)
												WHERE Acq_Deal_Run_Channel_Code = @channelCode

												SELECT @sumOfMin = SUM(ISNULL(Min_Runs, 0)), @sumOfMax = SUM(ISNULL(MAX_Runs, 0)) 
												FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code 
										
												SET @channelCode = 0

												IF(@sumOfMin > @sumOfMax)
												BEGIN
													SELECT TOP 1 @channelCode = Acq_Deal_Run_Channel_Code FROM Acq_Deal_Run_Channel 
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code AND ISNULL(Max_Runs, 0) > 0
													ORDER BY ISNULL(Max_Runs, 0) DESC

													UPDATE Acq_Deal_Run_Channel SET Max_Runs = ISNULL(Max_Runs, 0) + (@sumOfMin - @sumOfMax) 
													WHERE Acq_Deal_Run_Channel_Code  = @channelCode
												END
												ELSE IF(@sumOfMin < @sumOfMax)
												BEGIN
													SELECT TOP 1 @channelCode = Acq_Deal_Run_Channel_Code FROM Acq_Deal_Run_Channel 
													WHERE Acq_Deal_Run_Code  = @Acq_Deal_Run_Code AND ISNULL(Min_Runs, 0) > 0
													ORDER BY ISNULL(Min_Runs, 0) DESC

													UPDATE Acq_Deal_Run_Channel SET Min_Runs = ISNULL(Min_Runs, 0) + (@sumOfMax - @sumOfMin) 
													WHERE Acq_Deal_Run_Channel_Code  = @channelCode
												END
											END

											IF(@Is_Prime_OffPrime_Defined = 'Y')
											BEGIN
												UPDATE Acq_Deal_Run SET 
												Prime_Time_Balance_Count = Prime_Run - @primeConsumedRun ,
												oFF_Prime_Time_Balance_Count = Off_Prime_Run - @offPrimeConsumedRun
												WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
											END
										END
									END
								END
							END
						END

						----- Loop Syntax ----
						UPDATE #TEMP_Run_Def SET Process_Done = 'Y' WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code
						SELECT @Acq_Deal_Run_Code = 0, @No_Of_Run_Old =0, @isYearBased = '', @isChannelDefined= '', @runDefinitionType = ''

						SELECT TOP 1 @Acq_Deal_Run_Code = Acq_Deal_Run_Code, @No_Of_Run_Old = No_Of_Runs, @isYearBased = Is_Year_Based, 
						@isChannelDefined = Is_Channel_Defined, @runDefinitionType = Run_Definition_Type
						FROM #TEMP_Run_Def WHERE Process_Done = 'N'
					END
				
					FETCH NEXT FROM cursorRights INTO @Acq_Deal_Rights_Code, @Right_Start_Date, @Right_End_Date, @Right_Type
				END
				CLOSE cursorRights
				DEALLOCATE cursorRights

			
				IF(@Title_Code <> 0)
				BEGIN
					DELETE FROM Acq_Deal_Movie WHERE Acq_Deal_Code = @Deal_Code AND Title_Code = @Title_Code AND Episode_Starts_From > @Episode_No AND @Episode_No > 0

					UPDATE Acq_Deal_Movie SET Episode_End_To = @Episode_No WHERE Acq_Deal_Code = @Deal_Code AND Title_Code = @Title_Code 
					AND ( @Episode_No BETWEEN Episode_Starts_From AND Episode_End_To) AND @Episode_No > 0
				END

				IF(@lastDealCode != @Deal_Code OR @lastDealCode = 0)
				BEGIN
					IF(@lastDealCode <> 0)
					BEGIN

						UPDATE Acq_Deal SET Deal_Workflow_Status = 'N', [Status] = 'T', [Version] = RIGHT( '000' + CAST(Cast([Version] AS INT) + 1 AS VARCHAR), 4),
						Last_Action_By = @Login_User_Code, Last_Updated_Time=GETDATE() 
						WHERE Acq_Deal_Code = @Deal_Code

						-- Send @lastDealCode for Approval
						EXEC USP_Assign_Workflow @lastDealCode, 30, @Login_User_Code
					END

					SET @lastDealCode = @Deal_Code
				END

				IF(OBJECT_ID('TEMPDB..#RunDef') IS NOT NULL)
					DROP TABLE #RunDef

				IF(OBJECT_ID('TEMPDB..#RunDef_Delete') IS NOT NULL)
					DROP TABLE #RunDef_Delete

				SELECT DISTINCT ADRun.Acq_Deal_Run_Code INTO #RunDef FROM Acq_Deal_Run ADRun
				INNER JOIN Acq_Deal_Run_Title ADRunT ON ADRun.Acq_Deal_Run_Code = ADRunT.Acq_Deal_Run_Code 
				AND ADRun.Acq_Deal_Code = @Deal_Code
				INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = ADRun.Acq_Deal_Code
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND 
					ADRunT.Title_Code = ADRT.Title_Code AND ADRunT.Episode_From = ADRT.Episode_From  AND ADRunT.Episode_To = ADRT.Episode_To
				INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code AND
					ADRP.Platform_Code IN (SELECT DISTINCT Platform_Code FROM [Platform] WHERE Is_No_Of_Run = 'Y')

				SELECT Acq_Deal_Run_Code INTO #RunDef_Delete 
				FROM Acq_Deal_Run WHERE Acq_Deal_Code = @Deal_Code AND Acq_Deal_Run_Code NOT IN (SELECT Acq_Deal_Run_Code from #RunDef)
			
				DELETE FROM Acq_Deal_Run_Shows
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

				DELETE FROM Acq_Deal_Run_Yearwise_Run
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

				DELETE FROM Acq_Deal_Run_Yearwise_Run_Week
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

				DELETE FROM Acq_Deal_Run_Repeat_On_Day
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

				DELETE FROM Acq_Deal_Run_Channel
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

				DELETE FROM Acq_Deal_Run_Title
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

				DELETE FROM Acq_Deal_Run
				WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code from #RunDef_Delete)

			
				FETCH NEXT FROM cursorTermination_Deals INTO @Deal_Code, @Title_Code, @Episode_No, @Termination_Date
			END
			CLOSE cursorTermination_Deals;
			DEALLOCATE cursorTermination_Deals;

			UPDATE Acq_Deal SET Deal_Workflow_Status = 'N', [Status] = 'T', [Version] = RIGHT( '000' + CAST(Cast([Version] AS INT) + 1 AS VARCHAR), 4),
			Last_Action_By = @Login_User_Code, Last_Updated_Time=GETDATE() 
			WHERE Acq_Deal_Code = @lastDealCode

			EXEC USP_Assign_Workflow @lastDealCode, 30, @Login_User_Code
		END
	END

	SELECT Tds.Deal_Code, Tds.Title_Code, Tds.Episode_No, Tds.Termination_Date, Tds.Is_Error, Tds.Error_Details 
	FROM #Termination_Deals_Status Tds 
	
END

