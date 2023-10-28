CREATE PROC [dbo].[USP_Get_Termination_Title_Data]
(
	@Deal_Code INT,
	@Type CHAR(1) -- 'A' for Acquisition, 'S' for Syndication
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Termination_Title_Data]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE @Deal_Code INT = 8328,
		--@Type CHAR(1) = 'A' -- 'A' for Acquisition, 'S' for Syndication
	
		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''

		IF(OBJECT_ID('TEMPDB..#Title_Data') IS NOT NULL)
			DROP TABLE #Title_Data 

		CREATE TABLE #Title_Data
		(
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Episode_Range VARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Right_Start_Date DATETIME,
			Right_End_Date DATETIME,
			Schedule_Episode_No int,
			Schedule_End_Date datetime,
			Syndication_Episode_No int,
			Syndication_End_Date datetime,
			Termination_Eps_No int,
			Termination_Date datetime
		)

			--SELECT DISTINCT 
			--	SAM.Deal_Rights_Code, SAM.Syn_Deal_Code, SAM.Syn_Deal_Rights_Code
			--FROM 
			--Acq_Deal_Rights ADR
			--INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 
			--	AND ADR.Acq_Deal_Code = @Deal_Code AND (ADRT.Title_Code = @Title_Code Or @Title_Code = 0)
			--INNER JOIN Syn_Acq_Mapping SAM ON SAM.Deal_Code = @Deal_Code AND SAM.Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			--WHERE (@Episode_No < ADRT.Episode_To OR ISNULL(ADR.Actual_Right_End_Date, '9999-12-31') > @Termination_Date) AND (
			--	ADR.Right_Type IN ('U', 'Y') OR (ADR.Right_Type = 'M' AND ADR.Actual_Right_End_Date IS NOT NULL)
			--)
	
		IF(@Type = 'A')
			SELECT @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @Deal_Code
		ELSE IF(@Type = 'S')
			SELECT @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Deal_Code

		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)
	
		IF(@Type = 'A')
		BEGIN
			IF(@Deal_Type_Condition = 'DEAL_MOVIE')
			BEGIN
				DECLARE @Schedule_Item_Log_Date DATETIME, @Syn_End_Date DATETIME
			
				--SELECT 
				--	@Schedule_Item_Log_Date = Max(BVST.Schedule_Item_Log_Date)
				--FROM Acq_Deal_Movie ADM
				--INNER JOIN BV_Schedule_Transaction BVST ON ADM.Acq_Deal_Movie_Code = BVST.Deal_Movie_Code 
				--WHERE ADM.Acq_Deal_Code = @Deal_Code

				SELECT @Schedule_Item_Log_Date = Max(BVST.Schedule_Item_Log_Date) FROM Content_Channel_Run CCR (NOLOCK)
				INNER JOIN BV_Schedule_Transaction BVST (NOLOCK) ON CCR.Content_Channel_Run_Code = BVST.Content_Channel_Run_Code 
				WHERE CCR.Acq_Deal_Code = @Deal_Code

				SELECT Top 1 @Syn_End_Date = ISNULL(Actual_Right_End_Date,'31Dec9999') 
				FROM Syn_Deal_Rights (NOLOCK) 
				WHERE Syn_Deal_Rights_Code IN 
				(
					SELECT SAM.Syn_Deal_Rights_Code From Syn_Acq_Mapping SAM (NOLOCK) WHERE SAM.Deal_Code = @Deal_Code
				) Order By ISNULL(Actual_Right_End_Date,'31Dec9999') Desc

				--SELECT * 
				----INTO #temp 
				--FROM Acq_Deal_Termination_Details ADTD
				--WHERE ADTD.Acq_Deal_Code = @Deal_Code
				--ORDER BY ADTD.Created_Date DESC


				INSERT INTO #Title_Data(Title_Code, Title_Name, Episode_Range, Episode_From, Episode_To, Right_Start_Date, Right_End_Date,Schedule_Episode_No,Schedule_End_Date,
				Syndication_Episode_No,Syndication_End_Date,Termination_Eps_No,Termination_Date)
				SELECT 
					Title_Code, Title_Name, Episode_Range, 0, 0, Acq_Start_Date, Acq_End_Date,'', @Schedule_Item_Log_Date, '',
					CASE When @Syn_End_Date > Acq_End_Date Then Acq_End_Date Else @Syn_End_Date End Syn_End_Date, Termination_Episode_No,Termination_Date
				FROM 
				(
					SELECT 
						0 AS Title_Code, 'All Titles' AS Title_Name, '' AS Episode_Range,
						MIN(ADR.Actual_Right_Start_Date) Acq_Start_Date, MAX(ISNULL(ADR.Actual_Right_End_Date, '31Dec9999')) Acq_End_Date, 
						ADTD.Termination_Episode_No,
						ADTD.Termination_Date
					FROM Acq_Deal_Rights ADR (NOLOCK) 
					LEFT JOIN 
					(
						SELECT TOP 1 A.Acq_Deal_Code,A.Termination_Date,A.Termination_Episode_No,A.Created_Date,A.Title_Code
						FROM Acq_Deal_Termination_Details A (NOLOCK) 
						WHERE  A.Acq_Deal_Code = @Deal_Code
						ORDER BY A.Created_Date DESC
					) ADTD ON ADR.Acq_Deal_Code = ADTD.Acq_Deal_Code
					WHERE ADR.Acq_Deal_Code  = @Deal_Code AND (ADR.Right_Type IN ('Y', 'U') OR (ADR.Right_Type = 'M' AND ADR.Actual_Right_End_Date IS NOT NULL))
					GROUP BY ADTD.Termination_Episode_No,ADTD.Termination_Date
				) As a
			END
			ELSE
			BEGIN

		
				SELECT 
					ROW_NUMBER() OVER(PARTITION BY ADTD.Acq_Deal_Code,ADTD.Title_Code ORDER BY ADTD.Created_Date desc) as RowNum,
					ADTD.Termination_Episode_No,ADTD.Termination_Date,ADTD.Acq_Deal_Code,ADTD.Title_Code
				INTO 
					#temp_termination_Entry
				FROM Acq_Deal_Termination_Details ADTD (NOLOCK)
				WHERE ADTD.Acq_Deal_Code = @Deal_Code

				INSERT INTO #Title_Data(Title_Code, Title_Name, Episode_Range, Episode_From, Episode_To, Right_Start_Date, Right_End_Date,Schedule_Episode_No,Schedule_End_Date,
				Syndication_Episode_No,Syndication_End_Date,Termination_Eps_No,Termination_Date)
				SELECT a.Title_Code, a.Title_Name, a.Episode_Range, a.Episode_From, a.Episode_To, a.Actual_Right_Start_Date, a.Actual_Right_End_Date,
					   b.Eps_No, b.Schedule_Date,c.Syn_Eps_No,c.Syn_End_Date,a.Termination_Episode_No,a.Termination_Date
					   --Case When c.Syn_Eps_No > a.Episode_To  Then a.Episode_To Else c.Syn_Eps_No End Syn_Eps_No  ,
					   --Case When c.Syn_End_Date > a.Actual_Right_End_Date Then a.Actual_Right_End_Date Else c.Syn_End_Date End Syn_End_Date 
				FROM 
				(
					SELECT 
						T.Title_Code, T.Title_Name,
						DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, '', ADRT.Episode_From, ADRT.Episode_To) AS Episode_Range,
						ADRT.Episode_From, ADRT.Episode_To,
						MIN(ADR.Actual_Right_Start_Date) Actual_Right_Start_Date, 
						MAX(ISNULL(ADR.Actual_Right_End_Date, '9999-12-31 00:00:00.000')) Actual_Right_End_Date,
						TTE.Termination_Episode_No,TTE.Termination_Date
					FROM 
						Acq_Deal_Rights ADR (NOLOCK) 
						INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
						LEFT JOIN #temp_termination_Entry TTE ON ADR.Acq_Deal_Code = TTE.Acq_Deal_Code AND ADRT.Title_Code = TTE.Title_Code AND TTE.RowNum = 1
						INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
					WHERE 
						ADR.Acq_Deal_Code  = @Deal_Code AND (ADR.Right_Type IN ('Y', 'U') OR (ADR.Right_Type = 'M' AND ADR.Actual_Right_End_Date IS NOT NULL))
						--AND TTE.RowNum = 1
					GROUP BY 
						T.Title_Code, T.Title_Name, DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, '', ADRT.Episode_From, ADRT.Episode_To),
						ADRT.Episode_From, ADRT.Episode_To,TTE.Termination_Episode_No,TTE.Termination_Date
				) AS a
				LEFT JOIN
				(
					--SELECT 
					--	BVST.Title_Code, Max(BVST.Program_Episode_Number) AS Eps_No, Max(BVST.Schedule_Item_Log_Date) AS Schedule_Date 
					--FROM 
					--	BV_Schedule_Transaction BVST Where BVST.Deal_Movie_Code In (
					--	Select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @Deal_Code
					--) Group By BVST.Title_Code
					SELECT 
						BVST.Title_Code, Max(BVST.Program_Episode_Number) AS Eps_No, Max(BVST.Schedule_Item_Log_Date) AS Schedule_Date 
					FROM 
						BV_Schedule_Transaction BVST (NOLOCK) Where BVST.Content_Channel_Run_Code In (
						Select Content_Channel_Run_Code From Content_Channel_Run (NOLOCK) Where Acq_Deal_Code = @Deal_Code
					) Group By BVST.Title_Code

				) b ON a.Title_Code = b.Title_Code
				Left Join 
				(
					SELECT MAX(SDRT.Episode_To) Syn_Eps_No,ISNULL(MAX(SDR.Actual_Right_End_Date),'9999-12-31 00:00:00.000') Syn_End_Date, SDRT.Title_Code
					FROM Syn_Deal_Rights  SDR (NOLOCK)
					INNER JOIN Syn_Deal_Rights_Title SDRT (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Rights_Code In 
							(
								SELECT SAM.SYN_DEAL_RIGHTS_CODE 
								FROM SYN_ACQ_MAPPING SAM (NOLOCK) WHERE SAM.DEAL_CODE = @DEAL_CODE
							) Group By SDRT.Title_Code
				) c on a.Title_Code = c.Title_Code


				Update tmp
				Set tmp.Syndication_Episode_No = (Case When a.Syn_Eps_No > tmp.Syndication_Episode_No Then tmp.Syndication_Episode_No Else a.Syn_Eps_No End),
					tmp.Syndication_End_Date = (Case When a.Syn_End_Date > tmp.Syndication_End_Date Then tmp.Syndication_End_Date Else a.Syn_End_Date End)
				From #Title_Data tmp
				Inner Join (
					Select Title_Code, Max(Syndication_Episode_No) As Syn_Eps_No, Max(Syndication_End_Date) As Syn_End_Date From #Title_Data Group By Title_Code
				) as a On a.Title_Code = tmp.Title_Code
			
			END
		END
		ELSE IF(@Type = 'S')
		BEGIN
			IF(@Deal_Type_Condition = 'DEAL_MOVIE')
			BEGIN
				INSERT INTO #Title_Data(Title_Code, Title_Name, Episode_Range, Episode_From, Episode_To, Right_Start_Date, Right_End_Date)
				SELECT 0 AS Title_Code, 'All Titles' AS Title_Name, '' AS Episode_Range,
				0Episode_From, 0 AS Episode_To,
				MIN(ADR.Actual_Right_Start_Date), MAX(ISNULL(ADR.Actual_Right_End_Date, '9999-12-31 00:00:00.000'))
				FROM Syn_Deal_Rights ADR (NOLOCK) 
				WHERE ADR.Syn_Deal_Code  = @Deal_Code AND (ADR.Right_Type IN ('Y', 'U') OR (ADR.Right_Type = 'M' AND ADR.Actual_Right_End_Date IS NOT NULL))
			END
			ELSE
			BEGIN
				INSERT INTO #Title_Data(Title_Code, Title_Name, Episode_Range, Episode_From, Episode_To, Right_Start_Date, Right_End_Date)
				SELECT 
				T.Title_Code, T.Title_Name,
				DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, '', ADRT.Episode_From, ADRT.Episode_To) AS Episode_Range,
				ADRT.Episode_From, ADRT.Episode_To,
				MIN(ADR.Actual_Right_Start_Date), MAX(ISNULL(ADR.Actual_Right_End_Date, '9999-12-31 00:00:00.000'))
				FROM Syn_Deal_Rights ADR (NOLOCK)
				INNER JOIN Syn_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
				WHERE ADR.Syn_Deal_Code  = @Deal_Code AND (ADR.Right_Type IN ('Y', 'U') OR (ADR.Right_Type = 'M' AND ADR.Actual_Right_End_Date IS NOT NULL))
				GROUP BY T.Title_Code, T.Title_Name, DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, '', ADRT.Episode_From, ADRT.Episode_To),
				ADRT.Episode_From, ADRT.Episode_To
			END
		END

		SELECT
			Title_Code, Title_Name, Episode_Range, Episode_From, Episode_To, Right_Start_Date, Right_End_Date,
			Syndication_Episode_No,Syndication_End_Date,Schedule_Episode_No,Schedule_End_Date,Termination_Eps_No,Termination_Date
		FROM 
			#Title_Data

		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		IF OBJECT_ID('tempdb..#temp_termination_Entry') IS NOT NULL DROP TABLE #temp_termination_Entry
		IF OBJECT_ID('tempdb..#Title_Data') IS NOT NULL DROP TABLE #Title_Data
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Termination_Title_Data]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END