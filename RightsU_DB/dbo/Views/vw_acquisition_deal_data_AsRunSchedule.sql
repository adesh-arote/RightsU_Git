CREATE VIEW [dbo].[vw_acquisition_deal_data_AsRunSchedule]      
AS 

select  
		distinct Ad.Agreement_No
		,T.Title_Name AS Title_Name
		,ADR.Right_Type
		,CONVERT(varchar(100), MIN(ADR.right_start_date), 103)       AS Display_deal_right_start_date
		,convert(datetime, MIN(ADR.Actual_Right_Start_Date),101) AS deal_right_start_date
		,CONVERT(varchar(100), MAX(ADR.right_end_date), 103)       AS Display_deal_right_end_date
		,convert(datetime, MAX(ADR.Actual_Right_End_Date),101) AS  deal_right_end_date
		,convert(datetime, MIN(adrb.Start_Date),101) AS deal_right_blackout_start_date
		,convert(datetime, MAX(adrb.End_Date),101) AS  deal_right_blackout_end_date
		--,p.platform_name
		,'' as platform_name
		--,l.language_name       
		,'' as language_name       
		,T.title_code
		--,p.platform_code
		,0 as platform_code
		--,L.Language_Code
		,0 as Language_Code
		,ADR.Is_Sub_License
		,AD.Agreement_Date
		--,Ter.Territory_Code
		,0 as Territory_Code
		,ADR.Is_Exclusive
		,T.Deal_Type_Code
		,AD.Entity_Code
		,AD.Status
		,ADR.Acq_Deal_Rights_Code
		,AD.Acq_Deal_Code
		,TC.Title_Content_Code
		,ADM.Acq_Deal_Movie_Code
		,DMR.Acq_Deal_Run_Code
		,DMR.Is_Yearwise_Definition
		,DMR.Run_Type
		,DMR.Run_Definition_Type
		,DMR.No_Of_Runs 
		,DMR.No_Of_Runs_Sched
		,DMR.No_Of_AsRuns
		,DMRRC.Channel_Code
		,DMRRC.Min_Runs as ChannelWise_NoOfRuns
		,DMRRC.no_of_runs_sched  [ChannelWise_NoOfRuns_Schedule]
		,DMRRC.No_Of_AsRuns as ChannelWise_no_of_AsRuns
		,DMRRC.Do_Not_Consume_Rights  as DoNotConsume
		,TC.Episode_No 
		,0 as no_of_runs_sched_Content
		,0 as no_of_AsRuns_Content
		,ADR.right_type as [RightPeriodFor]
		,AD.Deal_Workflow_Status as [Deal_Workflow_Status]
		--select distinct AD.Acq_Deal_Code
from Acq_Deal AD
inner join Acq_Deal_Rights ADR on AD.Acq_Deal_Code = ADR.Acq_Deal_Code
inner join Acq_Deal_Movie ADM on AD.Acq_Deal_Code = ADM.Acq_Deal_Code
inner join Acq_Deal_Rights_Title ADRT1 on ADRT1.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code And ADRT1.Title_Code = ADM.Title_Code
INNER JOIN Title_Content_Mapping TCM on ADM.Acq_Deal_Movie_Code = TCM.Acq_Deal_Movie_Code
Inner JOIN Title_Content TC on TC.Title_Content_Code = TCM.Title_Content_Code
INNER JOIN dbo.Title AS T ON T.title_code = ADM.Title_Code 

LEFT JOIN Acq_Deal_Rights_Blackout ADRB on ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code

LEFT JOIN Acq_Deal_Run DMR on AD.Acq_Deal_Code = DMR.Acq_Deal_Code 
INNER join Acq_Deal_Run_Title ADRT on ADRT.Acq_Deal_Run_Code = DMR.Acq_Deal_Run_Code And ADRT.Title_Code = ADM.Title_Code And ADRT.Title_Code = ADRT1.Title_Code AND ADRT.Title_Code = T.Title_Code
INNER JOIN Acq_Deal_Run_Channel DMRRC on DMR.Acq_Deal_Run_Code = DMRRC.Acq_Deal_Run_Code 
 where 1=1 AND (Ad.is_active = 'Y')
 


GROUP BY Ad.Agreement_No
		,T.Title_Name
		,ADR.Right_Type
		,ADR.Actual_Right_Start_Date
		,ADR.Actual_Right_End_Date
		--,ADRB.Start_Date
		--,ADRB.End_Date
		--,p.platform_name
		--,l.language_name       
		,T.title_code
		--,p.platform_code
		--,L.Language_Code
		,ADR.Is_Sub_License
		,AD.Agreement_Date
		--,Ter.Territory_Code
		,ADR.Is_Exclusive
		,T.Deal_Type_Code
		,AD.Entity_Code
		,AD.Status
		,ADR.Acq_Deal_Rights_Code
		,AD.Acq_Deal_Code
		,TC.Title_Content_Code
		,AD.Acq_Deal_Code
		,ADM.Acq_Deal_Movie_Code
		,DMR.Acq_Deal_Run_Code
		,DMR.Is_Yearwise_Definition
		,DMR.Run_Type
		,DMR.Run_Definition_Type
		,DMR.No_Of_Runs
		,DMR.No_Of_Runs_Sched
		,DMR.No_Of_AsRuns
		,DMRRC.Channel_Code
		,DMRRC.Min_Runs
		,DMRRC.no_of_runs_sched
		,DMRRC.No_Of_AsRuns
		,DMRRC.Do_Not_Consume_Rights 
		,TC.Episode_No
		,AD.Deal_Workflow_Status
