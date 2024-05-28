
CREATE VIEW [dbo].[VW_BMS_Schedule_Acq_Rights_Data]
AS 
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <10 Aug 2016>
-- DescriptiON:    <RU BV Schedule Integration>
-- =============================================
	SELECT  AD.Agreement_No
		,T.Title_Name AS Title_Name		
		,CONVERT(DATETIME, MIN(ccr.Rights_Start_Date),101) AS Actual_Right_Start_Date		
		,CONVERT(DATETIME, MAX(ccr.Rights_End_Date),101) AS  Actual_Right_End_Date
		,CONVERT(DATETIME, ADRB.[Start_Date] ,101) AS  Blackout_Start_Date
		,CONVERT(DATETIME, ADRB.[End_Date] ,101) AS  Blackout_End_Date								
		,T.Title_Code
		,AD.Agreement_Date
		,ADR.Is_Exclusive
		,T.Deal_Type_Code
		,AD.Entity_Code
		,AD.Status
		,ADR.Acq_Deal_Rights_Code
		,AD.Acq_Deal_Code
		,TC.Title_Content_Code
		,ADM.Acq_Deal_Movie_Code
		,ccr.Acq_Deal_Run_Code
		--,ccr.Is_Yearwise_Definition
		,ccr.Run_Type
		--,ccr.Run_Definition_Type
		,ccr.Defined_Runs As No_Of_Runs
		,ccr.Schedule_Runs As No_Of_Runs_Sched
		,ccr.AsRun_Runs As  No_Of_ASRuns
		,ccr.Channel_Code
		--,ccr.Min_Runs AS ChannelWise_NoOfRuns
		--,DMRRC.No_Of_Runs_Sched  [ChannelWise_NoOfRuns_Schedule]		
		--,DMRRC.Do_Not_Consume_Rights AS Do_Not_Consume_Rights
		,TC.Episode_No 
		--,0 AS No_Of_Runs_Sched_Content
		,ISNULL(ccr.Right_Rule_Code,0) AS Right_Rule_Code
		,ADR.right_type AS Right_Type
		,AD.Deal_Workflow_Status AS [Deal_Workflow_Status]
		,ccr.Content_Channel_Run_Code
	FROM Content_Channel_Run ccr
	Inner Join Title_Content tc On ccr.Title_Content_Code = tc.Title_Content_Code
	Inner Join Title t On tc.Title_Code = t.Title_Code
	Inner Join Acq_Deal ad On ccr.Acq_Deal_Code = ad.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	Inner Join Acq_Deal_Rights_Title adrt On adrt.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And adrt.Title_Code = ccr.Title_Code
											 And IsNull(tc.Episode_No, 1) Between IsNull(adrt.Episode_From, 1) And IsNull(adrt.Episode_To, 1)
	Left Join Acq_Deal_Rights_Blackout adrb On adr.Acq_Deal_Rights_Code = adrb.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code And adrt.Title_Code = ccr.Title_Code 
											 AND IsNull(adrt.Episode_From, 1) = IsNull(adm.Episode_Starts_From, 1)
											 AND IsNull(adrt.Episode_To, 1) = IsNull(adm.Episode_End_To, 1)
	Where ADR.Acq_Deal_Rights_Code In (
		Select adrp.Acq_Deal_Rights_Code From Acq_Deal_Rights_Platform adrp 
		Inner Join Platform Plt ON ADRP.Platform_Code = Plt.Platform_Code AND ISNULL(Plt.Applicable_For_Asrun_Schedule,'N') = 'Y'
	) AND ISNULL(ccr.Is_Archive,'N') = 'N'
--AND ADR.Acq_Deal_Rights_Code In ( --Consider only for India Rights
--	Select adrp.Acq_Deal_Rights_Code From Acq_Deal_Rights_Platform adrp 
--	Inner Join Platform Plt ON ADRP.Platform_Code = Plt.Platform_Code AND ISNULL(Plt.Applicable_For_Asrun_Schedule,'N') = 'Y'
--)
	Group By AD.Agreement_No
			,T.Title_Name
			,CONVERT(DATETIME, ADRB.[Start_Date], 101)
			,CONVERT(DATETIME, ADRB.[End_Date], 101)
			,T.Title_Code
			,AD.Agreement_Date
			,ADR.Is_Exclusive
			,T.Deal_Type_Code
			,AD.Entity_Code
			,AD.Status
			,ADR.Acq_Deal_Rights_Code
			,AD.Acq_Deal_Code
			,TC.Title_Content_Code
			,ADM.Acq_Deal_Movie_Code
			,ccr.Acq_Deal_Run_Code
			--,ccr.Is_Yearwise_Definition
			,ccr.Run_Type
			--,ccr.Run_Definition_Type
			,ccr.Defined_Runs
			,ccr.Schedule_Runs
			,ccr.AsRun_Runs
			,ccr.Channel_Code
			--,ccr.Min_Runs AS ChannelWise_NoOfRuns
			--,DMRRC.No_Of_Runs_Sched  [ChannelWise_NoOfRuns_Schedule]		
			--,DMRRC.Do_Not_Consume_Rights AS Do_Not_Consume_Rights
			,TC.Episode_No 
			--,0 AS No_Of_Runs_Sched_Content
			,ISNULL(ccr.Right_Rule_Code,0)
			,ADR.right_type
			,AD.Deal_Workflow_Status
			,ccr.Content_Channel_Run_Code


--INNER JOIN  Acq_Deal_Rights_Title ADRT1 ON ADRT1.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And ADRT1.Title_Code = ADM.Title_Code
--INNER JOIN  Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
--INNER JOIN  Platform Plt ON ADRP.Platform_Code = Plt.Platform_Code AND ISNULL(Plt.Applicable_For_Asrun_Schedule,'N') = 'Y'
--LEFT OUTER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code
--INNER JOIN Acq_Deal_Movie_Content_Mapping DMC ON ADM.Acq_Deal_Movie_Code   = DMC.Acq_Deal_Movie_Code
--INNER JOIN Title_Content TC ON TC.Title_Content_Code = DMC.Title_Content_Code
--LEFT OUTER JOIN Acq_Deal_Run DMR ON AD.Acq_Deal_Code = DMR.Acq_Deal_Code 
--LEFT OUTER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = DMR.Acq_Deal_Run_Code And ADRT.Title_Code = ADM.Title_Code
--LEFT OUTER JOIN Acq_Deal_Run_Channel DMRRC ON DMR.Acq_Deal_Run_Code = DMRRC.Acq_Deal_Run_Code 
--INNER JOIN  dbo.Title AS T ON T.title_code = ADRT.Title_Code 
--WHERE 1=1 AND AD.is_active = 'Y'
----AND AD.Acq_Deal_Code=1063
--GROUP BY Ad.Agreement_No
--	,T.Title_Name
--	,ADR.Right_Type
--	,ADR.Actual_Right_Start_Date
--	,ADR.Actual_Right_End_Date		  
--	,ADRB.[Start_Date]
--	,ADRB.End_Date
--	,T.title_code			
--	,AD.Agreement_Date		
--	,ADR.Is_Exclusive
--	,T.Deal_Type_Code
--	,AD.Entity_Code 
--	,AD.[Status]
--	,ADR.Acq_Deal_Rights_Code
--	,AD.Acq_Deal_Code
--	,TC.Title_Content_Code
--	,AD.Acq_Deal_Code
--	,ADM.Acq_Deal_Movie_Code
--	,DMR.Acq_Deal_Run_Code
--	,DMR.Is_Yearwise_DefinitiON
--	,DMR.Run_Type
--	,DMR.Run_DefinitiON_Type
--	,DMR.No_Of_Runs
--	,DMR.No_Of_Runs_Sched
--	,DMR.No_Of_ASRuns
--	,DMRRC.Channel_Code
--	,DMRRC.Min_Runs
--	,DMRRC.no_of_runs_sched
--	,DMRRC.No_Of_ASRuns
--	,DMRRC.Do_Not_Consume_Rights 
--	,TC.Episode_No
--	,DMR.Right_Rule_Code
--	,AD.Deal_Workflow_Status

