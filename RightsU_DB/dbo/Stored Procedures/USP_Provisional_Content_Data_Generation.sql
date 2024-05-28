CREATE PROCEDURE [dbo].[USP_Provisional_Content_Data_Generation] 
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Provisional_Content_Data_Generation]', 'Step 1', 0, 'Started Procedure', 0, ''
	-- =============================================
	-- Author:		Anchal Sikarwar
	-- Create date: 05 Apr, 2017
	-- Description:	
	-- =============================================
	--Update  Process_Provisional_Deal SET Record_Status='D' where Record_Status='W'
		SET NOCOUNT ON;	
		DECLARE @Deal_Code INT = 0, @Is_Error CHAR(1), @Error_Desc VARCHAR(MAX)
		IF NOT EXISTS(SELECT TOP 1 Process_Provisional_Deal_Code FROM  Process_Provisional_Deal (NOLOCK) WHERE --Acq_Deal_Code=13565 AND 
		Record_Status = 'W')
		BEGIN
			BEGIN TRY	
			BEGIN TRAN	
				DECLARE CUS_Deal_Process CURSOR FOR
				SELECT Provisional_Deal_Code FROM  Process_Provisional_Deal (NOLOCK) WHERE Record_Status = 'P' --AND Acq_Deal_Code=13565 
				ORDER BY Process_Provisional_Deal_Code ASC
				OPEN CUS_Deal_Process
				FETCH NEXT FROM CUS_Deal_Process INTO @Deal_Code
				WHILE(@@FETCH_STATUS = 0)
				BEGIN
				UPDATE Process_Provisional_Deal SET Record_Status = 'W',Process_Start = GETDATE() where Provisional_Deal_Code = @Deal_Code
					/********************************DELETE Temp Table if Exists ****************/
					BEGIN
						IF OBJECT_ID('tempdb..#TempData') IS NOT NULL
						BEGIN
							DROP TABLE #TempData
						END
						IF OBJECT_ID('tempdb..#TempData_New') IS NOT NULL
						BEGIN
							DROP TABLE #TempData_New
						END
						IF OBJECT_ID('tempdb..#Temp_Content_Channel_Run') IS NOT NULL
						BEGIN
							DROP TABLE #Temp_Content_Channel_Run
						END
						IF OBJECT_ID('tempdb..#TempDummy') IS NOT NULL
						BEGIN
							DROP TABLE #TempDummy
						END
					END
						/********************************Delcare Variables****************/

					/*Run USP_Provisional_Title_Content_Generation to generate Title Content Data*/
					EXEC [USP_Provisional_Title_Content_Generation] @Deal_Code,143

					SELECT T.N AS Row_Num INTO #TempDummy
					FROM (
						SELECT TOP(5000) ROW_NUMBER() OVER(ORDER BY 1/0)
						FROM sys.all_objects AS o1, sys.all_objects AS o2
					) AS T(N)
				
					SELECT  No_Of_Runs AS 'Total_Runs',	CAST(temp.Row_Num AS VARCHAR) AS Episode_Number, 1 [Min_Plays], 1 [Max_Plays],
					* 
					INTO #TempData 
					FROM 
					(
						SELECT DISTINCT PD.Provisional_Deal_Code, PDRun.Provisional_Deal_Run_Code, T.Title_Code, CH.Channel_Code, 
						PD.Right_Start_Date [Start_Date],
						PD.Right_End_Date AS [End_Date], 
						RR.Right_Rule_Code, T.Duration_In_Min, T.Title_Name, PD.Deal_Type_Code, PDT.Episode_From, PDT.Episode_To, 
						CASE WHEN ISNULL(PDRun.Right_Rule_Code,'0') != '0' THEN 'Y' ELSE  'N' END Is_Rule_Right,
						PDRun.No_Of_Runs,
						PDRC.Right_Start_Date,
						PDRC.Right_End_Date,
						PDT.Provisional_Deal_Title_Code, 
						PDT.Prime_Start_Time, PDT.Prime_End_Time, PDT.Off_Prime_Start_Time, PDT.Off_Prime_End_Time,
						PDRun.Prime_Runs AS 'Prime_Run',
						PDRun.Off_Prime_Runs AS 'Off_Prime_Run',
						PDRun.Simulcast_Time_lag AS 'Time_lag'
						FROM Provisional_Deal PD  (NOLOCK)
						INNER JOIN Provisional_Deal_Title PDT (NOLOCK) ON PDT.Provisional_Deal_Code = PD.Provisional_Deal_Code
						INNER JOIN Title_Content_Mapping TCM (NOLOCK) ON TCM.Provisional_Deal_Title_Code = PDT.Provisional_Deal_Title_Code
						INNER JOIN Title T (NOLOCK) ON PDT.Title_Code = T.Title_Code
						INNER JOIN Language Lang (NOLOCK) ON T.Title_Language_Code = Lang.Language_Code
						INNER JOIN Provisional_Deal_Run PDRun (NOLOCK) ON PDT.Provisional_Deal_Title_Code = PDRun.Provisional_Deal_Title_Code --AND ADRun.Is_Channel_Definition_Rights = 'Y'
						INNER JOIN Provisional_Deal_Run_Channel PDRC (NOLOCK) ON PDRun.Provisional_Deal_Run_Code = PDRC.Provisional_Deal_Run_Code
						INNER JOIN Channel CH (NOLOCK) ON PDRC.Channel_Code = CH.Channel_Code
						LEFT JOIN Right_Rule RR (NOLOCK) ON PDRun.Right_Rule_Code = RR.Right_Rule_Code
						WHERE 1=1 AND 
						PD.Provisional_Deal_Code = @Deal_Code
						 --PD.Provisional_Deal_Code = 2088

						AND PD.Right_Start_Date IS NOT NULL
					) AS TBL
					INNER JOIN #TempDummy temp   ON temp.Row_Num between TBL.Episode_From AND TBL.Episode_To OR temp.Row_Num=1
				
					DROP TABLE #TempDummy

					UPDATE #TempData SET Start_Date = (SELECT Min(Start_Date) FROM #TempData), End_Date = (SELECT Max(End_Date) FROM #TempData)

					SELECT DISTINCT TD.Provisional_Deal_Code, TD.Provisional_Deal_Run_Code, TC.Title_Content_Code, TD.Title_Code, TD.Channel_Code, TD.Right_Start_Date
					,TD.Right_End_Date, TD.Right_Rule_Code, TD.Total_Runs AS Defined_Runs, TD.Prime_Start_Time, TD.Prime_End_Time, TD.Off_Prime_Start_Time, 
					TD.Off_Prime_End_Time, TD.Prime_Run,TD.Off_Prime_Run, TD.Time_lag, GETDATE() AS Inserted_On, 'P' AS Record_Status
					INTO #TempData_New
					from #TempData TD
					INNER JOIN Title_Content_Mapping TCM (NOLOCK) ON TCM.Provisional_Deal_Title_Code=TD.Provisional_Deal_Title_Code
					INNER JOIN Title_Content TC (NOLOCK) ON  TC.Title_Content_Code = TCM.Title_Content_Code AND TC.Episode_No=TD.Episode_Number

					UPDATE CCR SET CCR.Defined_Runs=ISNULL(TDN.Defined_Runs,0), CCR.Updated_On=GETDATE(), CCR.Prime_Runs=ISNULL(TDN.Prime_Run,0), 
					CCR.OffPrime_Runs=ISNULL(TDN.Off_Prime_Run,0), CCR.Is_Archive='N', CCR.Right_Rule_Code = TDN.Right_Rule_Code,
					CCR.Time_Lag_Simulcast = TDN.Time_lag
					--select 'Mached',CCR.Defined_Runs,TDN.Defined_Runs,*
					FROM Content_Channel_Run CCR 
					INNER JOIN #TempData_New TDN 
					ON TDN.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND TDN.Provisional_Deal_Run_Code = CCR.Provisional_Deal_Run_Code 
					AND TDN.Title_Content_Code = CCR.Title_Content_Code 
					AND TDN.Right_Start_Date = CCR.Rights_Start_Date AND TDN.Right_End_Date = CCR.Rights_End_Date AND TDN.Channel_Code = CCR.Channel_Code
					AND (ISNULL(CCR.Defined_Runs,0) != ISNULL(TDN.Defined_Runs,0) OR ISNULL(CCR.Prime_Runs,0) != ISNULL(TDN.Prime_Run,0) OR ISNULL(CCR.OffPrime_Runs,0) != ISNULL(TDN.Off_Prime_Run,0)
					OR ISNULL(CCR.Right_Rule_Code,0) != ISNULL(TDN.Right_Rule_Code,0) OR CCR.Time_Lag_Simulcast != TDN.Time_lag)


					SELECT * 
					INTO #Temp_Content_Channel_Run
					FROM Content_Channel_Run CCR (NOLOCK) WHERE CCR.Provisional_Deal_Code = @Deal_Code --Provisional_Deal_Code=2083--@Deal_Code

					IF EXISTS(select * from #Temp_Content_Channel_Run)
					DELETE TN FROM #TempData_New TN
					INNER JOIN #Temp_Content_Channel_Run TCR 
					ON TCR.Provisional_Deal_Code = TN.Provisional_Deal_Code AND TCR.Provisional_Deal_Run_Code = TN.Provisional_Deal_Run_Code 
					AND TCR.Title_Content_Code = TN.Title_Content_Code AND TCR.Rights_Start_Date = TN.Right_Start_Date AND TCR.Rights_End_Date = TN.Right_End_Date 
					AND TCR.Channel_Code = TN.Channel_Code AND ISNULL(TCR.Defined_Runs,0) = ISNULL(TN.Defined_Runs,0) AND ISNULL(TCR.Prime_Runs,0) = ISNULL(TN.Prime_Run,0) 
					AND ISNULL(TCR.OffPrime_Runs,0) = ISNULL(TN.Off_Prime_Run,0) AND TCR.Time_Lag_Simulcast = TN.Time_lag
					AND ISNULL(TCR.Right_Rule_Code,0) = ISNULL(TN.Right_Rule_Code,0)


					UPDATE CCR SET CCR.Is_Archive='Y' FROM Content_Channel_Run CCR  
					LEFT JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code
					LEFT JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Run_Code = CCR.Provisional_Deal_Run_Code
					LEFT JOIN Provisional_Deal_Title PDT ON PDT.Provisional_Deal_Code=PD.Provisional_Deal_Code
					LEFT JOIN Provisional_Deal_Run_Channel PDRC ON PDRC.Provisional_Deal_Run_Code = PDR.Provisional_Deal_Run_Code
					where  CCR.Provisional_Deal_Code=@Deal_Code AND (PDRC.Provisional_Deal_Run_Channel_Code IS NULL OR PDR.Provisional_Deal_Run_Code IS NULL
					OR PDT.Provisional_Deal_Title_Code IS NULL)

					INSERT INTO Content_Channel_Run(Provisional_Deal_Code, Provisional_Deal_Run_Code, Title_Content_Code, Title_Code, Channel_Code, 
					Rights_Start_Date, Rights_End_Date, Right_Rule_Code, Defined_Runs, Prime_Start_Time, Prime_End_Time, OffPrime_Start_Time, 
					OffPrime_End_Time, Prime_Runs, OffPrime_Runs, Inserted_On, Record_Status, Is_Archive, Deal_Type, Time_Lag_Simulcast)	
					SELECT DISTINCT  Provisional_Deal_Code, Provisional_Deal_Run_Code, Title_Content_Code, Title_Code, Channel_Code, 
					Right_Start_Date, Right_End_Date, Right_Rule_Code, ISNULL(Defined_Runs,0), Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time,
					Off_Prime_End_Time,	ISNULL(Prime_Run,0), ISNULL(Off_Prime_Run,0), Inserted_On, Record_Status, 'N', 'P', Time_lag FROM #TempData_New

					UPDATE Process_Provisional_Deal SET Record_Status = 'D',Process_End = GETDATE() where Provisional_Deal_Code = @Deal_Code
				
					FETCH NEXT FROM CUS_Deal_Process INTO @Deal_Code
				END--While loop
				CLOSE CUS_Deal_Process
				DEALLOCATE CUS_Deal_Process
				COMMIT
			END TRY			
			BEGIN CATCH	
				PRINT 'Catch Block in USP_Content_Channel_Run_Data_Generation'
				DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT
				SELECT @ErMessage = 'Error in USP_Content_Channel_Run_Data_Generation : - ' +  ERROR_MESSAGE()+',@ErSeverity  ='+ ERROR_SEVERITY()+',@ErState ='+ ERROR_STATE()
				+ ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)  + ' ;ERROR_Line: '  
									+ CAST(ERROR_Line() AS VARCHAR)+' Deal_Code: '  + CAST(@Deal_Code AS VARCHAR)
				RAISERROR (@ErMessage,@ErSeverity,@ErState)	
				ROLLBACK
			END CATCH
		END

		IF OBJECT_ID('tempdb..#Temp_Content_Channel_Run') IS NOT NULL DROP TABLE #Temp_Content_Channel_Run
		IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
		IF OBJECT_ID('tempdb..#TempData_New') IS NOT NULL DROP TABLE #TempData_New
		IF OBJECT_ID('tempdb..#TempDummy') IS NOT NULL DROP TABLE #TempDummy
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Provisional_Content_Data_Generation]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END