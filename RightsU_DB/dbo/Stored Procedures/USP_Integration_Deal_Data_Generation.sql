CREATE PROCEDURE [dbo].[USP_Integration_Deal_Data_Generation]      
AS      
/*==============================================      
Author:   Anchal Sikarwar      
Create date: 13 Apr 2017      
Description: Data Generation for RU-FPC Integration      
===============================================*/      
BEGIN      
 DECLARE @Is_Error CHAR(1), @Error_Desc NVARCHAR(MAX)      
 BEGIN TRY      
  SET NOCOUNT ON;       
  DECLARE @Deal_Code INT = 0      
  IF NOT EXISTS(SELECT TOP 1 Acq_Deal_Code FROM Integration_Deal WHERE Record_Status = 'W' )      
  BEGIN      
  DECLARE CUS_Deal_Process CURSOR FOR       
  SELECT DISTINCT Acq_Deal_Code FROM  Integration_Deal WHERE Record_Status = 'P'       
  OPEN CUS_Deal_Process      
  FETCH NEXT FROM CUS_Deal_Process INTO @Deal_Code      
  WHILE(@@FETCH_STATUS = 0)      
  BEGIN    
   /********************************DELETE Temp Table if Exists ****************/       
   BEGIN      
    IF OBJECT_ID('tempdb..#Temp_Integration_Title') IS NOT NULL              
    BEGIN              
    DROP TABLE #Temp_Integration_Title              
    END       
    IF OBJECT_ID('tempdb..#Temp_Acq_Deal_Run') IS NOT NULL              
    BEGIN              
    DROP TABLE #Temp_Acq_Deal_Run              
    END       
    IF OBJECT_ID('tempdb..#Temp_Acq_Deal_Run_Channel') IS NOT NULL              
    BEGIN              
    DROP TABLE #Temp_Acq_Deal_Run_Channel             
    END       
    IF OBJECT_ID('tempdb..#Temp_Acq_Deal_Run_Yearwise') IS NOT NULL              
    BEGIN              
    DROP TABLE #Temp_Acq_Deal_Run_Yearwise             
    END       
    IF OBJECT_ID('tempdb..#Temp_Deal_Data') IS NOT NULL              
    BEGIN              
    DROP TABLE #Temp_Deal_Data             
    END       
    IF OBJECT_ID('tempdb..#Temp_Min_Max_Rights_Date') IS NOT NULL              
    BEGIN              
    DROP TABLE #Temp_Min_Max_Rights_Date             
    END       
   END       
   /***************************************************Insert Record*********************************************************************/                
   /*Select All Title Related To @Deal_Code*/      
   SELECT DISTINCT T.Title_Code,0 AS Foreign_System_Code,T.Title_Name, T.Duration_In_Min, T.Year_Of_Production, T.Deal_Type_Code,      
   ISNULL((            
    SELECT Case When MEC.Columns_Value_Code = 3 Then 'O' When MEC.Columns_Value_Code = 4 Then 'D' Else '' End             
    FROM Map_Extended_Columns MEC WHERE Columns_Value_Code IN              
    (              
    SELECT Columns_Value_Code FROM Extended_Columns_Value  WHERE Columns_Code IN(              
    SELECT Columns_Code FROM Extended_Columns WHERE Columns_Name like 'Type of Film')          
    )              
    AND MEC.Table_Name = 'TITLE' AND MEC.Record_Code = T.Title_Code            
    ), '') AS  Original_Dub,      
    T.Title_Language_Code      
    INTO #Temp_Integration_Title      
    FROM Acq_Deal AD      
   INNER JOIN Acq_Deal_Run ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code              
   INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code       
   INNER JOIN Title T ON T.Title_Code= ADRT.Title_Code       
   WHERE  
    AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
   AD.Acq_Deal_Code = @Deal_Code      
   /*Update Changed Title in Integration_title*/      
   UPDATE IT SET IT.Deal_Type_Code=TIT.Deal_Type_Code, IT.Duration=TIT.Duration_In_Min, IT.Original_Dub=TIT.Original_Dub      
   , IT.Title_Language_Code=TIT.Title_Language_Code, IT.Title_Name=TIT.Title_Name, IT.Year_Of_Production=TIT.Year_Of_Production, IT.Record_Status='P'      
   FROM Integration_Title IT       
   INNER JOIN #Temp_Integration_Title TIT ON TIT.Title_Code=IT.Title_Code      
   WHERE TIT.Deal_Type_Code!=IT.Deal_Type_Code OR TIT.Duration_In_Min!=IT.Duration OR TIT.Original_Dub!=IT.Original_Dub      
    OR TIT.Title_Language_Code!=IT.Title_Language_Code OR TIT.Title_Name!=IT.Title_Name OR TIT.Year_Of_Production!=IT.Year_Of_Production      
   /*Delete Updated Data in Integration_Title from #Temp_Integration_Title*/      
   DELETE TIT       
   FROM      
   Integration_Title IT       
   INNER JOIN #Temp_Integration_Title TIT ON TIT.Title_Code=IT.Title_Code      
   /*Insert new Titles*/      
   INSERT INTO Integration_Title(      
   Title_Code ,Foreign_System_Code ,Title_Name ,Duration ,Year_Of_Production ,Deal_Type_COde ,Original_Dub ,Title_Language_Code ,Inserted_On ,Record_Status      
   )      
   select Title_Code,Foreign_System_Code,Title_Name,Duration_In_Min,Year_Of_Production,Deal_Type_Code,Original_Dub,Title_Language_Code,GETDATE(),'P'       
   from #Temp_Integration_Title      
   CREATE TABLE #Temp_Deal_Data              
   (              
   Acq_Deal_Code INT,                  
   Deal_Type_Code INT,              
   Title_Code INT,              
   Acq_Deal_Rights_Code INT,              
   Rights_Start_Date DATETIME,              
   Rights_End_Date DATETIME,              
   HB_Start_Date DATETIME,              
   HB_End_Date DATETIME,              
   Acq_Deal_Run_Code INT,              
   Right_Rule_Code INT,              
   Channel_Code INT,      
   Licensor_Code INT,      
   Deal_Desc NVARCHAR(500)           
   )              
   CREATE TABLE #Temp_Min_Max_Rights_Date              
   (               
   Acq_Deal_Code INT,                  
   Title_Code INT,              
   Rights_Start_Date DATETIME,              
   Rights_End_Date DATETIME              
   )       
   INSERT INTO #Temp_Deal_Data(Acq_Deal_Code,Deal_Type_Code,Title_Code,              
   Acq_Deal_Rights_Code,Rights_Start_Date,Rights_End_Date,              
   Acq_Deal_Run_Code,Right_Rule_Code,Channel_Code, Deal_Desc,Licensor_Code)              
   SELECT DISTINCT  AD.Acq_Deal_Code,AD.Deal_Type_Code,ADRT.Title_Code,              
   ADRTitle.Acq_Deal_Rights_Code,ADRight.Actual_Right_Start_Date,ADRight.Actual_Right_End_Date,              
   ADR.Acq_Deal_Run_Code,ISNULL(ADR.Right_Rule_Code,0),ADRC.Channel_Code, ad.Deal_Desc,AD.Vendor_Code      
   FROM Acq_Deal AD               
   INNER JOIN Acq_Deal_Rights ADRight ON AD.Acq_Deal_Code = ADRight.Acq_Deal_Code               
   AND ISNULL(ADRight.Actual_Right_Start_Date,'') <> ''              
   --AND ISNULL(ADRight.Actual_Right_End_Date,'31DEC9999') > GETDATE()              
   INNER JOIN Acq_Deal_Rights_Title ADRTitle ON  ADRight.Acq_Deal_Rights_Code =ADRTitle.Acq_Deal_Rights_Code              
   INNER JOIN Acq_Deal_Run ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code              
   INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code AND ADRTitle.Title_Code = ADRT.Title_Code              
   INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRT.Acq_Deal_Run_Code= ADRC.Acq_Deal_Run_Code       
   INNER JOIN Title T ON T.Title_Code= ADRT.Title_Code               
   WHERE   AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code =@Deal_Code      
      
   UPDATE TDRD SET TDRD.Rights_Start_Date = ADRH.Holdback_Release_Date              
   FROM Acq_Deal_Rights_Holdback ADRH              
   INNER JOIN #Temp_Deal_Data TDRD ON ADRH.Acq_Deal_Rights_Code = TDRD.Acq_Deal_Rights_Code              
   INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRP ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRP.Acq_Deal_Rights_Holdback_Code              
   AND ADRP.Platform_Code IN(SELECT P.Platform_Code FROM [Platform] P   WHERE P.Applicable_For_Asrun_Schedule = 'Y')              
   WHERE  1 = 1              
   AND ISNULL(ADRH.Holdback_Type,'') = 'D'  AND ISNULL(ADRH.Holdback_Release_Date,'') <> ''              
              
   INSERT INTO #Temp_Min_Max_Rights_Date(Acq_Deal_Code,Title_Code,Rights_Start_Date,Rights_End_Date)              
   SELECT DISTINCT TDRD.Acq_Deal_Code,TDRD.Title_Code,MIN(TDRD.Rights_Start_Date),MAX(TDRD.Rights_End_Date)              
   FROM #Temp_Deal_Data TDRD              
   GROUP BY TDRD.Acq_Deal_Code,TDRD.Title_Code      
    
   SELECT DISTINCT              
   TDD.Acq_Deal_Run_Code AS Acq_Deal_Run_Code,              
   0 AS Foreign_System_Code,                   
   TDD.Title_Code AS Title_Code,              
   ISNULL(ADR.Run_Type,'N') Run_Type,              
   ISNULL(ADR.No_Of_Runs,0) No_Of_Runs,              
   ISNULL(ADR.Is_Yearwise_Definition,'N') Is_Yearwise_Definition,              
   ISNULL(ADR.Is_Rule_Right,'N') AS Is_Rule_Right,              
   ADR.Right_Rule_Code AS Right_Rule_Code,                   
   ISNULL(ADR.Repeat_Within_Days_Hrs,' ') AS Repeat_Within_Days_Hrs,              
   ISNULL(ADR.No_Of_Days_Hrs,0) AS No_Of_Days_Hrs,              
   ISNULL(ADR.Is_Channel_Definition_Rights,'N') AS Is_Channel_Definition_Rights,              
   ISNULL([dbo].[UFN_Get_Integration_Key] ('Channel',ADR.Primary_Channel_Code,'FPC'),0) AS Primary_Channel_Code,              
   ISNULL(ADR.Run_Definition_Type,'N') Run_Definition_Type,              
   ISNULL(ADR.Prime_Start_Time,'00:00:00') Prime_Start_Time,               
   ISNULL(ADR.Prime_End_Time,'00:00:00') Prime_End_Time,              
   ISNULL(ADR.Off_Prime_Start_Time,'01Jan1900') Off_Prime_Start_Time,              
   ISNULL(ADR.Off_Prime_End_Time,'01Jan1900') Off_Prime_End_Time,              
   ISNULL(ADR.Time_Lag_Simulcast,'00:00:00') Time_Lag_Simulcast,              
   ISNULL(ADR.Prime_Run,0) Prime_Run,              
   ISNULL(ADR.Off_Prime_Run,0) Off_Prime_Run,              
   ISNULL(ADR.Prime_Time_Provisional_Run_Count,0) AS Prime_Time_Provisional_Run_Count,       
   ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0) AS Off_Prime_Time_Provisional_Run_Count,      
   ISNULL((              
   SELECT STUFF((SELECT DISTINCT ', '+  CAST(ADRRD.Day_Code AS VARCHAR)              
   FROM Acq_Deal_Run_Repeat_On_Day ADRRD              
   WHERE ADRRD.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code                    
   AND ADRRD.Day_Code is NOT NULL              
   FOR XML PATH('')), 1, 1, '')              
   ),'NA') AS Repeat_On_Day,              
   CAST(ISNULL((              
   SELECT DISTINCT TOP 1 Temp.Rights_Start_Date                 
   FROM #Temp_Min_Max_Rights_Date Temp                           
   WHERE Temp.Acq_Deal_Code =ADR.Acq_Deal_Code              
   AND Temp.Title_Code = ADRT.Title_Code              
   ),'01Jan1900') AS DATETIME) AS Rights_Start_Date,              
   CAST(ISNULL((                   
   SELECT DISTINCT TOP 1 Temp.Rights_End_Date              
   FROM #Temp_Min_Max_Rights_Date Temp                           
   WHERE Temp.Acq_Deal_Code =ADR.Acq_Deal_Code       
   AND  Temp.Title_Code = ADRT.Title_Code              
   ),'31DEC9999') AS DATETIME) AS Rights_End_Date,          
   ADR.Acq_Deal_Code AS Acq_Deal_Code,      
   ISNULL(TDD.Deal_Desc,'NA') AS Deal_Description,      
   ISNULL([dbo].[UFN_Get_Integration_Key] ('Licensor',TDD.Licensor_Code,'FPC'),0) AS Licensor_Code      
   ,      
   (Case When ADM.Title_Type='P' THEN 'P' ELSE 'L' END) AS Title_Type,      
   (select Top 1 Integration_Title_Code from Integration_Title where Title_Code=TDD.Title_Code) AS Integration_Title_Code      
   INTO #Temp_Acq_Deal_Run      
   FROM Acq_Deal_Run ADR              
   INNER JOIN #Temp_Deal_Data TDD ON ADR.Acq_Deal_Code = TDD.Acq_Deal_Code      
   INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND TDD.Title_Code = ADRT.Title_Code              
   AND TDD.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code              
   --AND TDD.Title_Code IN              
   --(              
   -- SELECT ID.RU_Record_Code              
   -- FROM Integration_Data ID              
   -- WHERE ID.Integration_Config_Code IN              
   -- (              
   --  SELECT TOP 1 IC.Integration_Config_Code              
   --  FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'TITLE'  AND IC.Foreign_System_Name=@Foreign_System_Name          
   -- )              
   --)      
   INNER JOIN Acq_Deal_Movie ADM ON ADM.Title_Code=ADRT.Title_Code       
   AND ADM.Acq_Deal_Code=ADR.Acq_Deal_Code       
   AND ADM.Episode_Starts_From=ADRT.Episode_From       
   AND ADM.Episode_End_To=ADRT.Episode_To        
   AND TDD.Acq_Deal_Code = @Deal_Code      
    
   /*Update Only Changed Acq_Run Data in Integration_Acq_Run*/      
   UPDATE IAR SET      
   IAR.Run_Type=TADR.Run_Type, IAR.No_Of_Runs=TADR.No_Of_Runs, IAR.Is_Yearwise_Definition=TADR.Is_Yearwise_Definition,       
   IAR.Is_Rule_Right=TADR.Is_Rule_Right, IAR.Right_Rule_Code=TADR.Right_Rule_Code, IAR.Repeat_Within_Days_Hrs=TADR.Repeat_Within_Days_Hrs,      
   IAR.No_Of_Days_Hrs=TADR.No_Of_Days_Hrs, IAR.Is_Channel_Definition_Rights=TADR.Is_Channel_Definition_Rights,       
   IAR.Primary_Channel_Code=TADR.Primary_Channel_Code, IAR.Run_Definition_Type=TADR.Run_Definition_Type, IAR.Prime_Start_Time=TADR.Prime_Start_Time,      
   IAR.Prime_End_Time=TADR.Prime_End_Time, IAR.Off_Prime_Start_Time=TADR.Off_Prime_Start_Time, IAR.Off_Prime_End_Time=TADR.Off_Prime_End_Time,      
   IAR.Time_Lag_Simulcast=TADR.Time_Lag_Simulcast, IAR.Prime_Run=ISNULL(TADR.Prime_Run,0), IAR.Off_Prime_Run=ISNULL(TADR.Off_Prime_Run,0),       
   IAR.Repeat_On_Day=TADR.Repeat_On_Day, IAR.Rights_Start_Date=TADR.Rights_Start_Date, IAR.Rights_End_Date=TADR.Rights_End_Date,      
   IAR.Deal_Description=TADR.Deal_Description, IAR.Licensor_Code=TADR.Licensor_Code,IAR.Title_Type=(Case When TADR.Title_Type='P' THEN 'P' ELSE 'L' END),      
   IAR.Record_Status='P'      
          
   FROM      
   Integration_Acq_Run IAR      
   INNER JOIN      
   #Temp_Acq_Deal_Run TADR ON IAR.Acq_Deal_Run_Code  =TADR.Acq_Deal_Run_Code AND IAR.Acq_Deal_Code =@Deal_Code       
   WHERE       
   IAR.Run_Type!=TADR.Run_Type OR IAR.No_Of_Runs!=TADR.No_Of_Runs OR IAR.Is_Yearwise_Definition!=TADR.Is_Yearwise_Definition       
   OR IAR.Is_Rule_Right!=TADR.Is_Rule_Right OR IAR.Right_Rule_Code!=TADR.Right_Rule_Code OR IAR.Repeat_Within_Days_Hrs!=TADR.Repeat_Within_Days_Hrs      
   OR IAR.No_Of_Days_Hrs!=TADR.No_Of_Days_Hrs OR IAR.Is_Channel_Definition_Rights!=TADR.Is_Channel_Definition_Rights       
   OR IAR.Primary_Channel_Code!=TADR.Primary_Channel_Code OR IAR.Run_Definition_Type!=TADR.Run_Definition_Type       
   OR IAR.Prime_Start_Time!=TADR.Prime_Start_Time OR IAR.Prime_End_Time!=TADR.Prime_End_Time OR IAR.Off_Prime_Start_Time!=TADR.Off_Prime_Start_Time      
   OR IAR.Off_Prime_End_Time!=TADR.Off_Prime_End_Time OR IAR.Time_Lag_Simulcast!=TADR.Time_Lag_Simulcast OR ISNULL(IAR.Prime_Run,0)!=ISNULL(TADR.Prime_Run,0)
   OR ISNULL(IAR.Off_Prime_Run,0)!=ISNULL(TADR.Off_Prime_Run,0) OR IAR.Repeat_On_Day!=TADR.Repeat_On_Day OR IAR.Rights_Start_Date!=TADR.Rights_Start_Date      
   OR IAR.Rights_End_Date!=TADR.Rights_End_Date      
    OR IAR.Deal_Description collate SQL_Latin1_General_CP1_CI_AS !=TADR.Deal_Description collate SQL_Latin1_General_CP1_CI_AS      
    OR IAR.Licensor_Code!=TADR.Licensor_Code      
   OR IAR.Title_Type!=TADR.Title_Type      
      
   --UPDATE IAR SET IAR.Is_Archive='Y' FROM Integration_Acq_Run IAR      
   --INNER JOIN #Temp_Acq_Deal_Run TADR ON IAR.Acq_Deal_Run_Code!=TADR.Acq_Deal_Run_Code AND IAR.Acq_Deal_Code=@Deal_Code  
         
    UPDATE IAR SET IAR.Is_Archive='Y',IAR.Record_Status='P' FROM Integration_Acq_Run IAR where  
  IAR.Acq_Deal_Run_Code NOT IN(select DISTINCT TADR.Acq_Deal_Run_Code from #Temp_Acq_Deal_Run TADR)  
   AND IAR.Acq_Deal_Code=@Deal_Code     
  
   DELETE TADR       
   FROM      
   Integration_Acq_Run IAR      
   INNER JOIN      
   #Temp_Acq_Deal_Run TADR ON IAR.Acq_Deal_Run_Code=TADR.Acq_Deal_Run_Code AND IAR.Acq_Deal_Code=@Deal_Code      
         
   INSERT INTO Integration_Acq_Run(Acq_Deal_Run_Code,Foreign_System_Code,Run_Type,No_Of_Runs,Is_Yearwise_Definition,Is_Rule_Right,Right_Rule_Code      
   ,Repeat_Within_Days_Hrs,No_Of_Days_Hrs,Is_Channel_Definition_Rights,Primary_Channel_Code,Run_Definition_Type,Prime_Start_Time,Prime_End_Time      
   ,Off_Prime_Start_Time,Off_Prime_End_Time,Time_Lag_Simulcast,Prime_Run,Off_Prime_Run,Repeat_On_Day,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code      
   ,Deal_Description,Licensor_Code,Title_Type,Integration_Title_Code,Inserted_On,Record_Status      
   )      
   select Acq_Deal_Run_Code,Foreign_System_Code,Run_Type,No_Of_Runs,Is_Yearwise_Definition,Is_Rule_Right,Right_Rule_Code,Repeat_Within_Days_Hrs      
    ,No_Of_Days_Hrs,Is_Channel_Definition_Rights,Primary_Channel_Code,Run_Definition_Type,Prime_Start_Time,Prime_End_Time,Off_Prime_Start_Time      
    ,Off_Prime_End_Time,Time_Lag_Simulcast,ISNULL(Prime_Run,0),ISNULL(Off_Prime_Run,0),Repeat_On_Day,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code      
    ,Deal_Description,Licensor_Code,Title_Type,Integration_Title_Code,GETDATE(),'P' from #Temp_Acq_Deal_Run      
         
   SELECT DISTINCT      
   IAR.Integration_Acq_Run_Code, ADRC.Channel_Code, ADRC.Min_Runs, ADRC.Max_Runs      
   INTO #Temp_Acq_Deal_Run_Channel      
   from Acq_Deal_Run_Channel ADRC      
   INNER JOIN Acq_Deal_Run ADR ON ADRC.Acq_Deal_Run_Code =ADR.Acq_Deal_Run_Code      
   INNER JOIN Integration_Acq_Run IAR ON IAR.Acq_Deal_Run_Code=ADRC.Acq_Deal_Run_Code      
   where ADR.Acq_Deal_Code=@Deal_Code      
   SELECT DISTINCT       
   IAR.Integration_Acq_Run_Code, ADRYR.[Start_Date] AS Start_Date, ADRYR.End_Date AS End_Date,      
   ISNULL(ADRYR.No_Of_Runs,0) AS No_Of_Runs        
   INTO #Temp_Acq_Deal_Run_Yearwise      
   FROM Acq_Deal_Run_Yearwise_Run ADRYR                    
   INNER JOIN Acq_Deal_Run ADR ON ADRYR.Acq_Deal_Run_Code =ADR.Acq_Deal_Run_Code      
   INNER JOIN Integration_Acq_Run IAR ON IAR.Acq_Deal_Run_Code=ADRYR.Acq_Deal_Run_Code       
   where ADR.Acq_Deal_Code=@Deal_Code      
         
   UPDATE IARC SET IARC.Channel_Code=TIARC.Channel_Code, IARC.Max_Runs=ISNULL(TIARC.Max_Runs,0), IARC.Min_Runs=ISNULL(TIARC.Min_Runs,0), 
   IARC.Record_Status='P' 
   FROM Integration_Acq_Run_Channel IARC      
   INNER JOIN #Temp_Acq_Deal_Run_Channel TIARC ON IARC.Integration_Acq_Run_Code=TIARC.Integration_Acq_Run_Code       
   AND IARC.Channel_Code=TIARC.Channel_Code      
   WHERE IARC.Integration_Acq_Run_Code IN
   (
   select DISTINCT IARC1.Integration_Acq_Run_Code   
   FROM Integration_Acq_Run_Channel IARC1      
   INNER JOIN #Temp_Acq_Deal_Run_Channel TIARC1 ON IARC1.Integration_Acq_Run_Code=TIARC1.Integration_Acq_Run_Code       
   AND IARC1.Channel_Code=TIARC1.Channel_Code      
   WHERE ISNULL(IARC1.Min_Runs,0)!=ISNULL(TIARC1.Min_Runs,0)  )    
    
   UPDATE IARC SET IARC.Is_Archive='Y' FROM Integration_Acq_Run_Channel IARC      
   INNER JOIN #Temp_Acq_Deal_Run_Channel TIARC ON IARC.Integration_Acq_Run_Code=TIARC.Integration_Acq_Run_Code       
   --AND IARC.Channel_Code!=TIARC.Channel_Code      
   WHERE IARC.Integration_Acq_Run_Channel_Code NOT IN(      
   select Integration_Acq_Run_Channel_Code FROM Integration_Acq_Run_Channel IARC1      
   INNER JOIN #Temp_Acq_Deal_Run_Channel TIARC1 ON IARC1.Integration_Acq_Run_Code=TIARC1.Integration_Acq_Run_Code       
   AND IARC1.Channel_Code=TIARC1.Channel_Code      
   )      
      
   DELETE TIARC FROM Integration_Acq_Run_Channel IARC      
   INNER JOIN #Temp_Acq_Deal_Run_Channel TIARC ON TIARC.Integration_Acq_Run_Code=IARC.Integration_Acq_Run_Code       
   AND IARC.Channel_Code=TIARC.Channel_Code      
      
   INSERT INTO Integration_Acq_Run_Channel(      
   Integration_Acq_Run_Code,Channel_Code,Min_Runs,Max_Runs,Inserted_On,Record_Status      
   )      
   select Integration_Acq_Run_Code,Channel_Code,ISNULL(Min_Runs,0),ISNULL(Max_Runs,0),GETDATE(),'P' from #Temp_Acq_Deal_Run_Channel      
      
   UPDATE ADRYR SET ADRYR.No_Of_Runs=ISNULL(TADR.No_Of_Runs,0),ADRYR.Record_Status='P'      
   FROM Integration_Acq_Run_Yearwise ADRYR                    
   INNER JOIN #Temp_Acq_Deal_Run_Yearwise TADR       
   ON ADRYR.Integration_Acq_Run_Code =TADR.Integration_Acq_Run_Code      
   AND ADRYR.Start_Date = TADR.Start_Date      
   AND ADRYR.End_Date = TADR.End_Date      
   WHERE ADRYR.Integration_Acq_Run_Code IN
   (
   SELECT ADRYR1.Integration_Acq_Run_Code
   FROM Integration_Acq_Run_Yearwise ADRYR1                    
   INNER JOIN #Temp_Acq_Deal_Run_Yearwise TADR1       
   ON ADRYR1.Integration_Acq_Run_Code =TADR1.Integration_Acq_Run_Code      
   AND ADRYR1.Start_Date = TADR1.Start_Date      
   AND ADRYR1.End_Date = TADR1.End_Date      
   WHERE ISNULL(ADRYR1.No_Of_Runs,0)!=ISNULL(TADR1.No_Of_Runs,0)

   )         
      
   UPDATE IARC SET IARC.Is_Archive='Y' FROM Integration_Acq_Run_Yearwise IARC      
   INNER JOIN #Temp_Acq_Deal_Run_Yearwise TIARC ON IARC.Integration_Acq_Run_Code=TIARC.Integration_Acq_Run_Code       
   --AND (IARC.Start_Date!=TIARC.Start_Date OR IARC.End_Date != TIARC.End_Date)      
   where IARC.Integration_Acq_Run_Yearwise_Code NOT IN(      
   select Integration_Acq_Run_Yearwise_Code FROM Integration_Acq_Run_Yearwise IARC      
   INNER JOIN #Temp_Acq_Deal_Run_Yearwise TIARC ON IARC.Integration_Acq_Run_Code=TIARC.Integration_Acq_Run_Code       
   AND (IARC.Start_Date=TIARC.Start_Date OR IARC.End_Date = TIARC.End_Date)      
   )      
      
   DELETE TADR      
   FROM Integration_Acq_Run_Yearwise ADRYR                    
   INNER JOIN #Temp_Acq_Deal_Run_Yearwise TADR    
   ON ADRYR.Integration_Acq_Run_Code =TADR.Integration_Acq_Run_Code      
   AND ADRYR.Start_Date = TADR.Start_Date      
   AND ADRYR.End_Date = TADR.End_Date      
      
   INSERT INTO Integration_Acq_Run_Yearwise(      
   Integration_Acq_Run_Code,Start_Date,End_Date,No_Of_Runs,Inserted_On,Record_Status      
   )      
   SELECT Integration_Acq_Run_Code,Start_Date,End_Date,ISNULL(No_Of_Runs,0),GETDATE(),'P' FROM #Temp_Acq_Deal_Run_Yearwise      
      
   UPDATE Integration_Deal SET Record_Status='D' where Acq_Deal_Code=@Deal_Code      
   FETCH NEXT FROM CUS_Deal_Process INTO @Deal_Code      
  END      
  CLOSE CUS_Deal_Process;      
  DEALLOCATE CUS_Deal_Process;      
  END      
 END TRY              
 BEGIN CATCH                  
  SET @Is_Error   = 'Y'               
  SET @Error_Desc = 'Error In USP_Integration_Deal_Data_Generation : Error_Desc : ' +  ERROR_MESSAGE() + ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)              
  SET @Error_Desc =  @Error_Desc + ';ErrorLine : '+ CAST(ERROR_LINE() AS VARCHAR) + ' ;'               
  PRINT CAST (@Error_Desc AS VARCHAR)      
 END CATCH       

	IF OBJECT_ID('tempdb..#Temp_Acq_Deal_Run') IS NOT NULL DROP TABLE #Temp_Acq_Deal_Run
	IF OBJECT_ID('tempdb..#Temp_Acq_Deal_Run_Channel') IS NOT NULL DROP TABLE #Temp_Acq_Deal_Run_Channel
	IF OBJECT_ID('tempdb..#Temp_Acq_Deal_Run_Yearwise') IS NOT NULL DROP TABLE #Temp_Acq_Deal_Run_Yearwise
	IF OBJECT_ID('tempdb..#Temp_Deal_Data') IS NOT NULL DROP TABLE #Temp_Deal_Data
	IF OBJECT_ID('tempdb..#Temp_Integration_Title') IS NOT NULL DROP TABLE #Temp_Integration_Title
	IF OBJECT_ID('tempdb..#Temp_Min_Max_Rights_Date') IS NOT NULL DROP TABLE #Temp_Min_Max_Rights_Date
END