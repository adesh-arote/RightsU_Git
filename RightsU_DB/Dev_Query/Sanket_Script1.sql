USE RightsU_SPN_DM2
DROP TABLE #Temp
SELECT * 
INTO #Temp  
FROM 
(
SELECT  DISTINCT-- DCO_ASS_ID,
BA.Title
,Convert(DATETIME,ISNULL(DBDCR.DCO_DATEAVAILABLEFROM,'31DEC9999'),103) AS BV_Start_Date,
Convert(DATETIME,ISNULL(DBDCR.DCO_DATEAVAILABLETO,'31DEC9999'),103) AS BV_End_Date,
RR.Right_Rule_Name AS RU_Right_Rule,CASE WHEN DCO_ARR_ID = RR.Ref_Right_Rule_Key THEN RR.Right_Rule_Name ELSE DCO_ARR_ID END AS BV_Right_Rule,
DCO_DAYSAVAILABLE AS BV_TotalRuns,
DCO_DAYSUSED AS BV_Schedule_Runs,
CASE WHEN ADRun.Is_Yearwise_Definition = 'Y' 
	THEN ADRunY.[Start_Date] ELSE ADR.Actual_Right_Start_Date  
END AS RU_Start_Date  ,
CASE WHEN ADRun.Is_Yearwise_Definition = 'Y' 
	THEN ADRunY.[End_Date] ELSE ADR.Actual_Right_End_Date
END AS RU_End_Date ,
ADrun.No_Of_Runs AS RU_Total_Runs,ADRun.No_Of_Runs_Sched AS RU_Schedule_Run,
ADrunC.Min_Runs AS ChannelWise_Define_Run,ADrunC.No_Of_Runs_Sched AS ChannelWise_Schedule_Run,
ADRunY.No_Of_Runs AS YearWise_Run ,ADRunY.No_Of_Runs_Sched AS YearWise_Schedule_Run,
C.Channel_Name,C.Channel_Code,ADrun.Is_Yearwise_Definition,BA.RU_Title_Code,
ADrun.Acq_Deal_Code,ADrun.Acq_Deal_Run_Code,ADrunC.Acq_Deal_Run_Channel_Code,ADRunY.Acq_Deal_Run_Yearwise_Run_Code
FROM DM_BMS_Deal_Content_Rights DBDCR
INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Ref_Key = DBDCR.DCO_ASS_ID
INNER JOIN Channel C ON C.Ref_Station_Key= DBDCR.DCO_CHA_ID
INNER JOIN Acq_Deal_Run_Title ADrunT ON ADrunT.Title_Code = BA.RU_Title_Code
INNER JOIN Acq_Deal_Run_Channel ADrunC ON ADrunT.Acq_Deal_Run_Code = ADrunC.Acq_Deal_Run_Code AND ADrunC.Channel_Code = C.Channel_Code
INNER JOIN Acq_Deal_Run ADrun ON ADrunC.Acq_Deal_Run_Code = ADrun.Acq_Deal_Run_Code
INNER JOIN Acq_Deal_Rights ADR ON ADrun.Acq_Deal_Code = ADR.Acq_Deal_Code
INNER JOIN Acq_Deal_Rights_Title ADRT ON ADrunT.Title_Code = ADRT.Title_Code 
AND ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 
AND BA.RU_Title_Code = ADRT.Title_Code
AND Convert(DATETIME,ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'),103) > GETDATE()
AND Convert(DATETIME,ISNULL(DBDCR.DCO_DATEAVAILABLETO,'31DEC9999'),103) > GETDATE()
AND Convert(DATETIME,ISNULL(DBDCR.DCO_DATEAVAILABLEFROM,'31DEC9999'),103) < GETDATE()
AND Convert(DATETIME,ISNULL(ADR.Actual_Right_Start_Date,'31DEC9999'),103) < GETDATE()
AND ISNULL(DBDCR.DCO_DATEAVAILABLEFROM,'') <> '' AND ISNULL(DBDCR.DCO_DATEAVAILABLETO,'') <> '' 	 
LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRunY ON ADrunC.Acq_Deal_Run_Code = ADRunY.Acq_Deal_Run_Code  AND ADRunY.End_Date > GETDATE()
LEFT JOIN Right_Rule RR ON ADrun.Right_Rule_Code = RR.Right_Rule_Code
WHERE DCO_CHA_ID IN(1160,1290)  AND ADRun.Run_Type = 'C'
) AS TBL 
WHERE  1 =1 
AND Convert(DATETIME,ISNULL(TBL.RU_Start_Date,'31DEC9999'),103) =  Convert(DATETIME,ISNULL(TBL.BV_Start_Date,'31DEC9999'),103) 
AND  Convert(DATETIME,ISNULL(TBL.RU_End_Date,'31DEC9999'),103) =  Convert(DATETIME,ISNULL(TBL.BV_End_Date,'31DEC9999'),103) 
ORDER BY Is_Yearwise_Definition,Title,TBl.Channel_Code,TBL.RU_Start_Date

SELECT AD.Agreement_No,Title,Channel_Name,BV_TotalRuns,  
CASE WHEN ISNULL(Acq_Deal_Run_Yearwise_Run_Code,0) = 0 THEN 
	ChannelWise_Define_Run ELSE YearWise_Run END 
AS RU_Define_Runs,
CASE WHEN ISNULL(Acq_Deal_Run_Yearwise_Run_Code,0) = 0 THEN 
	ChannelWise_Schedule_Run ELSE YearWise_Schedule_Run END 
AS RU_Schedule_Runs
,BV_Schedule_Runs
,BV_Start_Date,BV_End_Date,RU_Start_Date,RU_End_Date,ChannelWise_Define_Run,YearWise_Run
,RU_Schedule_Run,BV_Schedule_Runs,YearWise_Schedule_Run,RU_Total_Runs
,BV_Right_Rule,RU_Right_Rule,
T.Acq_Deal_Code,RU_Title_Code,Channel_Code
Acq_Deal_Run_Code,Acq_Deal_Run_Channel_Code,Acq_Deal_Run_Yearwise_Run_Code
FROM  #Temp T
INNER JOIN Acq_Deal AD ON T.Acq_Deal_Code = AD.Acq_Deal_Code
WHERE  1 = 1 
AND  
(
(T.ChannelWise_Schedule_Run <> T.BV_Schedule_Runs AND  ISNULL(Acq_Deal_Run_Yearwise_Run_Code,0) = 0)
OR
(T.YearWise_Schedule_Run <> T.BV_Schedule_Runs AND  ISNULL(Acq_Deal_Run_Yearwise_Run_Code,0) > 0)
)
--AND  
--(
--	(ChannelWise_Define_Run = BV_TotalRuns AND  ISNULL(Acq_Deal_Run_Yearwise_Run_Code,0) = 0)
--	OR
--	(YearWise_Run = BV_TotalRuns AND  ISNULL(Acq_Deal_Run_Yearwise_Run_Code,0) > 0)
--)
--AND Title like 'Everything Or Nothing%'
ORDER BY Title,Acq_Deal_Code,RU_Start_Date,RU_End_Date	

--SElECT * FROM Acq_Deal_Run_Channel WHERE  Acq_Deal_Run_Channel_Code = 5292
--SElECT * FROM Acq_Deal_Run_Yearwise_Run WHERE  Acq_Deal_Run_Yearwise_Run_Code = 5292
--SELECT * FROM DM_BMS_Deal_Content_Rights WHERE DCO_TITLE like '%LICENSE%'
SELECT * FROM DM_BMS_Deal_Content_Rights WHERE DCO_TITLE like 'ANGELS & DEMONS'
SELECT * FROM BMS_Deal_Content_Rights WHERE TITLE like 'APOLLO 13- OFF PRIME TIME'
SELECT * FROM Title WHERE Title_Code = 2087 
SELECT * FROM BV_Schedule_Transaction WHERE Title_Code = 9671 AND IsIgnore = 'N'  AND Channel_Code = 24 
ORDER BY Schedule_Item_Log_Date
