CREATE VIEW [dbo].[vw_acquisition_deal_data_AsRunSchedule]      
AS 

SELECT  DISTINCT 
	pd.Acq_Deal_Code
	,pdt.Acq_Deal_Movie_Code
	,adr.Acq_Deal_Rights_Code
	,ccr.Acq_Deal_Run_Code
	,ccr.Channel_Code
	,ccr.Run_Type
	,ccr.Run_Def_Type AS run_definition_type
	,pdrun.Is_Yearwise_Definition
	,pdrun.No_Of_Runs 
	,pdrun.No_Of_Runs_Sched
	,pdrun.No_Of_AsRuns
	,ccr.Defined_Runs as ChannelWise_NoOfRuns
	,ccr.Schedule_Runs  [ChannelWise_NoOfRuns_Schedule]
	,ccr.AsRun_Runs as ChannelWise_no_of_AsRuns
	,adrrt.Title_Code
	,pd.Agreement_Date
	,CONVERT(DATETIME, MAX(adr.Actual_Right_End_Date), 101) AS  deal_right_end_date
	,CONVERT(DATETIME, MIN(adr.Actual_Right_Start_Date), 101) AS deal_right_start_date
	,adr.Right_Type
	,CONVERT(DATETIME, MIN(adrb.Start_Date), 101) AS deal_right_blackout_start_date
	,CONVERT(DATETIME, MAX(adrb.End_Date), 101) AS  deal_right_blackout_end_date
	,tc.Title_Content_Code
	,ISNULL(tcm.Deal_For, 'A') Deal_For
FROM 
	Acq_Deal pd
	INNER JOIN Acq_Deal_Rights adr ON pd.Acq_Deal_Code = adr.Acq_Deal_Code
	INNER JOIN Acq_Deal_Movie pdt ON pd.Acq_Deal_Code = pdt.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Title adrrt ON adrrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND adrrt.Title_Code = pdt.Title_Code
	LEFT OUTER  JOIN Acq_Deal_Rights_Blackout adrb ON adr.Acq_Deal_Rights_Code = adrb.Acq_Deal_Rights_Code
	INNER JOIN Title_Content_Mapping tcm ON pdt.Acq_Deal_Movie_Code = tcm.Acq_Deal_Movie_Code AND ISNULL(tcm.Deal_For, 'A') = 'A'
	INNER  JOIN Title_Content tc ON tc.Title_Content_Code = tcm.Title_Content_Code
	LEFT JOIN Content_Channel_Run ccr ON ccr.Title_Content_Code = tc.Title_Content_Code AND ccr.Acq_Deal_Code = pd.Acq_Deal_Code AND ccr.Title_Code = adrrt.Title_Code AND ISNULL(ccr.Deal_Type, 'A') = 'A'
	LEFT OUTER JOIN Acq_Deal_Run pdrun ON pd.Acq_Deal_Code = pdrun.Acq_Deal_Code 
WHERE 
	1=1 AND (pd.is_active = 'Y')
GROUP BY pd.Acq_Deal_Code
		,pdt.Acq_Deal_Movie_Code
		,adr.Acq_Deal_Rights_Code
		,ccr.Acq_Deal_Run_Code
		,ccr.Channel_Code
		,ccr.Run_Type
		,ccr.Run_Def_Type 
		,pdrun.Is_Yearwise_Definition
		,pdrun.No_Of_Runs 
		,pdrun.No_Of_Runs_Sched
		,pdrun.No_Of_AsRuns
		,ccr.Defined_Runs
		,ccr.Schedule_Runs
		,ccr.AsRun_Runs
		,adrrt.Title_Code
		,pd.Agreement_Date
		,adr.Actual_Right_End_Date
		,adr.Actual_Right_Start_Date
		,adr.Right_Type
		,adrb.Start_Date
		,adrb.End_Date
		,tc.Title_Content_Code
		,ISNULL(tcm.Deal_For, 'A')
UNION
SELECT  DISTINCT 
	pd.Provisional_Deal_Code
	,pdt.Provisional_Deal_Title_Code
	,0 AS Acq_Deal_Rights_Code
	,ccr.Provisional_Deal_Run_Code
	,ccr.Channel_Code
	,pdrun.Run_Type
	,ccr.Run_Def_Type
	,'Y' AS Is_Yearwise_Definition
	,pdrun.No_Of_Runs 
	,SUM(ccr.Schedule_Runs) No_Of_Runs_Sched 
	,SUM(ccr.AsRun_Runs) No_Of_AsRuns 
	,ccr.Defined_Runs as ChannelWise_NoOfRuns
	,ccr.Schedule_Runs  [ChannelWise_NoOfRuns_Schedule]
	,ccr.AsRun_Runs as ChannelWise_no_of_AsRuns
	,pdt.Title_Code
	,pd.Agreement_Date
	,CONVERT(DATETIME, MAX(pd.Right_End_Date), 101) AS  deal_right_end_date
	,CONVERT(DATETIME, MIN(pd.Right_Start_Date), 101) AS deal_right_start_date
	,'Y' AS Right_Type
	,NULL AS deal_right_blackout_start_date
	,NULL AS  deal_right_blackout_end_date
	,tc.Title_Content_Code
	,tcm.Deal_For
FROM 
	Provisional_Deal pd
	INNER JOIN Provisional_Deal_Title pdt ON pd.Provisional_Deal_Code = pdt.Provisional_Deal_Code
	INNER JOIN Title_Content_Mapping tcm ON pdt.Provisional_Deal_Title_Code = tcm.Provisional_Deal_Title_Code AND ISNULL(tcm.Deal_For, 'A') = 'P'
	INNER  JOIN Title_Content tc ON tc.Title_Content_Code = tcm.Title_Content_Code
	LEFT JOIN Content_Channel_Run ccr ON ccr.Title_Content_Code = tc.Title_Content_Code AND ccr.Provisional_Deal_Code = pd.Provisional_Deal_Code AND ccr.Title_Code = pdt.Title_Code AND ISNULL(ccr.Deal_Type, 'A') = 'P'
	LEFT OUTER JOIN Provisional_Deal_Run pdrun ON pdt.Provisional_Deal_Title_Code = pdrun.Provisional_Deal_Title_Code 
GROUP BY pd.Provisional_Deal_Code
	,pdt.Provisional_Deal_Title_Code
	,ccr.Provisional_Deal_Run_Code
	,ccr.Channel_Code
	,pdrun.Run_Type
	,ccr.Run_Def_Type
	,pdrun.No_Of_Runs 
	,ccr.Defined_Runs
	,ccr.Schedule_Runs
	,ccr.AsRun_Runs
	,pdt.Title_Code
	,pd.Agreement_Date
	,pd.Right_End_Date
	,pd.Right_Start_Date
	,tc.Title_Content_Code
	,tcm.Deal_For

