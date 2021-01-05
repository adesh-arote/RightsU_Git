CREATE PROC usp_Schedule_Validate_TempBVSche_S1  
(  
 @File_Code BIGINT,  
 @Channel_Code VARCHAR(10),  
 @IsReprocess VARCHAR(10) = NULL,  
 @BV_Episode_ID VARCHAR(1000) = NULL,  
 @CanProcessRun INT = 0 OUTPUT  
)  
AS   
BEGIN  
  
 IF OBJECT_ID('tempdb..#tmpDealNotApprove') IS NOT NULL  
 BEGIN  
  DROP TABLE #tmpDealNotApprove  
 END  
 IF OBJECT_ID('tempdb..#TMP_Program_Episode_ID') IS NOT NULL  
 BEGIN  
  DROP TABLE #TMP_Program_Episode_ID  
 END  
 IF OBJECT_ID('tempdb..#TMP_Temp_BV_Schedule') IS NOT NULL  
 BEGIN  
  DROP TABLE #TMP_Temp_BV_Schedule  
 END   
  
PRINT '--===============4.0 PROCEES ALL MATCHED PROGRAMMIDS --==============='  
 --===============4.1 Inserting all matched PROGRAMMIDS records into BV_Schedule_Transaction --===============  
  SELECT   
   tbs.Temp_BV_Schedule_Code, tbs.Program_Episode_Title, tbs.Program_Episode_Number, tbs.Program_Title, tbs.Program_Category,  
   tbs.Schedule_Item_Log_Date, tbs.Schedule_Item_Log_Time, tbs.Schedule_Item_Duration,  
   tbs.File_Code, tbs.Channel_Code, CASE WHEN  ISNULL(dmc.Deal_For, 'A') = 'A' THEN D.Agreement_No ELSE pd.Agreement_No END AS Agreement_No, tc.Title_Code,   
   CASE WHEN  ISNULL(dmc.Deal_For, 'A') = 'A' THEN DM.Acq_Deal_Movie_Code ELSE pdt.Provisional_Deal_Title_Code END AS Acq_Deal_Movie_Code,  
   CASE WHEN  ISNULL(dmc.Deal_For, 'A') = 'A' THEN   
    CASE WHEN d.Deal_Workflow_Status = 'A' THEN 'Y' ELSE 'N' END   
   ELSE CASE WHEN pd.Deal_Workflow_Status = 'A' THEN 'Y' ELSE 'N' END END  
   AS IsDealApproved,  
   CASE WHEN  ISNULL(dmc.Deal_For, 'A') = 'A' THEN D.Acq_Deal_Code ELSE pd.Provisional_Deal_Code END AS Deal_Code,  
   ISNULL(dmc.Deal_For, 'A') Deal_For  
  INTO #tmpDealNotApprove  
  FROM Temp_BV_Schedule tbs  
   INNER JOIN Title_Content tc ON tc.Ref_BMS_Content_Code = tbs.Program_Episode_ID  
    AND ((ISNULL(@BV_Episode_ID,'N') != 'N' AND @IsReprocess = 'N'  AND tc.Ref_BMS_Content_Code = @BV_Episode_ID) OR 1=1)   
   INNER JOIN Title_Content_Mapping dmc ON dmc.Title_Content_Code = tc.Title_Content_Code  
   LEFT JOIN ACQ_Deal_Movie DM ON DM.ACQ_deal_movie_code = DMC.ACQ_deal_movie_code AND ISNULL(dmc.Deal_For, 'A') = 'A'  
   LEFT JOIN ACQ_Deal D ON D.ACQ_deal_code = DM.ACQ_deal_code   
   LEFT JOIN Provisional_Deal_Title pdt ON pdt.Provisional_Deal_Title_Code = DMC.Provisional_Deal_Title_Code AND ISNULL(dmc.Deal_For, 'A') = 'P'  
   LEFT JOIN Provisional_Deal  pd ON pd.Provisional_Deal_Code = pdt.Provisional_Deal_Code   
  WHERE 1=1 and  D.Deal_Workflow_Status NOT IN ('AR', 'WA')   
  --AND d.is_active = 'Y'  
  AND tbs.File_Code = @File_Code  
    
  UPDATE Temp_BV_Schedule   
   SET TitleCode = tmpDNA.Title_Code, DMCode = tmpDNA.Acq_Deal_Movie_Code, IsDealApproved = tmpDNA.IsDealApproved  
   , Deal_Code = tmpDNA.Deal_Code, Deal_Type = tmpDNA.Deal_For  
  FROM Temp_BV_Schedule tbs  
   INNER JOIN #tmpDealNotApprove tmpDNA ON tmpDNA.Temp_BV_Schedule_Code = tbs.Temp_BV_Schedule_Code  
        
 PRINT '----------  PROCESS THOSE TITLES WHOSE DEALS ARE NOT APPROVED ---------------'  
  INSERT INTO Upload_Err_Detail   
  (  
   File_Code, Row_Num, Row_Delimed, Err_Cols, Upload_Type, Upload_Title_Type  
  )  
  SELECT DISTINCT @File_Code, 0, '~~' + Program_Title +' ~~~'+ '1' AS Scheduled_Version_House_Number_List ,'1DNA', 'S', 'M'  
  FROM Temp_BV_Schedule UPT    
  WHERE 1=1 AND File_Code = @File_Code AND ISNULL(UPT.IsDealApproved,'Y') = 'N'     
      
  DECLARE @EmailMsg_New_Deal NVARCHAR(MAX)  
  SELECT @EmailMsg_New_Deal =  Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'Deal_Not_Approve' AND [Type] = 'S'  
     
  INSERT INTO Email_Notification_Schedule  
  (  
   BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,  
   Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,  
   File_Code, Channel_Code, Inserted_On, 
   Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code  
  )  
  SELECT Temp_BV_Schedule_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,  
   Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, 1 AS Scheduled_Version_House_Number_List,  
   File_Code, Channel_Code, GETDATE() Inserted_On,  
   @EmailMsg_New_Deal + ' (Deal No:- '+ CAST (Agreement_No AS VARCHAR(50)) + ') ' AS Email_Notification_Msg,  
   'N' AS IsMailSent, 'N' AS IsRunCountCalculate, NULL AS Title_Code  
  FROM #tmpDealNotApprove WHERE IsDealApproved != 'Y'  
  
  SELECT @CanProcessRun = COUNT(*) FROM #tmpDealNotApprove  
  
 PRINT '--===============4.0 PROCEES ALL MATCHED PROGRAMMIDS --==============='  
    
  DELETE TBS  
  FROM Temp_BV_Schedule TBS  
  INNER JOIN BV_HouseId_Data BSD on BSD.Program_Episode_ID = TBS.Program_Episode_ID  
  AND BSD.IsIgnore = 'Y' AND tbs.File_Code = @File_Code AND Channel_Code = @Channel_Code  
      
  SELECT DISTINCT ISNULL(tc.Ref_BMS_Content_Code,0) AS [Program_Episode_ID]   
  INTO #TMP_Program_Episode_ID  
  FROM  
  Title_Content tc  WITH (NOLOCK)  
  INNER JOIN Title_Content_Mapping dmc  WITH (NOLOCK) ON dmc.Title_Content_Code = tc.Title_Content_Code  
  LEFT JOIN ACQ_Deal_Movie DM WITH (NOLOCK) ON DM.ACQ_deal_movie_code = DMC.ACQ_deal_movie_code AND ISNULL(dmc.Deal_For, 'A') = 'A'  
  LEFT JOIN ACQ_Deal D  WITH (NOLOCK) ON D.ACQ_deal_code = DM.ACQ_deal_code   
  LEFT JOIN Provisional_Deal_Title pdt WITH (NOLOCK) ON pdt.Provisional_Deal_Title_Code = DMC.Provisional_Deal_Title_Code AND ISNULL(dmc.Deal_For, 'A') = 'P'  
  LEFT JOIN Provisional_Deal pd ON pd.Provisional_Deal_Code = pdt.Provisional_Deal_Code   
  WHERE 1 = 1 AND  
  (((D.Deal_Workflow_Status = 'A') OR CAST(D.[version] AS  NUMERIC(18, 2)) > 1) AND  ISNULL(dmc.Deal_For, 'A') = 'A')  
  OR                                     
  (((pd.Deal_Workflow_Status = 'A') OR CAST(pd.[version] AS  NUMERIC(18, 2)) > 1) AND  ISNULL(dmc.Deal_For, 'A') = 'P')  
  
  BEGIN    
  
  SELECT   
   tbs.Program_Episode_ID,  
   tbs.Program_Version_ID,  
   tbs.Program_Episode_Title,   
   CASE WHEN ISNULL(tbs.Program_Episode_Number,'') = '' THEN 1 ELSE tbs.Program_Episode_Number END Program_Episode_Number,  
   tbs.Program_Title,   
   tbs.Program_Category,  
   tbs.Schedule_Item_Log_Date,   
   tbs.Schedule_Item_Log_Time,   
   tbs.Schedule_Item_Duration,   
   tbs.File_Code, tbs.Channel_Code, tbs.Inserted_By,  
   tbs.TitleCode,  
   tbs.Channel_Code,  
   tbs.Temp_BV_Schedule_Code   
  INTO #TMP_Temp_BV_Schedule  
  FROM Temp_BV_Schedule tbs WITH (NOLOCK)  
  WHERE 1=1   
  AND   
  (   
   (  
    ISNULL(@BV_Episode_ID,'N') != 'N' AND @IsReprocess = 'N' AND tbs.Program_Episode_ID IN ( @BV_Episode_ID )  
   )  
   OR  
   (  
    @IsReprocess <> 'Y' AND ISNULL(@BV_Episode_ID,'N') = 'N'  
    AND  
    tbs.Program_Episode_ID IN ( SELECT Program_Episode_ID FROM #TMP_Program_Episode_ID )  
   )  
  )  
  AND TBS.File_Code = @File_Code  
  ORDER BY tbs.Temp_BV_Schedule_Code   
  
  
  INSERT INTO BV_Schedule_Transaction   
  (   
   Program_Episode_ID, Program_Version_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,   
   Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration,   
   Scheduled_Version_House_Number_List, Found_Status,   
   File_Code, Channel_Code, IsProcessed, Inserted_By, Inserted_On, Title_Code, Deal_Code, Deal_Type  
  )  
  SELECT   
   tbs.Program_Episode_ID,  
   tbs.Program_Version_ID,  
   tbs.Program_Episode_Title,   
   tbs.Program_Episode_Number,  
   tbs.Program_Title,   
   tbs.Program_Category,  
   tbs.Schedule_Item_Log_Date,   
   tbs.Schedule_Item_Log_Time,   
   tbs.Schedule_Item_Duration,   
   '1' AS Scheduled_Version_House_Number_List  
   , 'Y',   
   tbs.File_Code, tbs.Channel_Code, 'N', tbs.Inserted_By , GETDATE(),  
   tbs.TitleCode  
   ,tbs.Deal_Code  
   ,tbs.Deal_For  
  FROM #TMP_Temp_BV_Schedule tbs  
  WHERE 1=1 AND Tbs.Channel_Code = @Channel_Code  
  
  END  
      
  IF EXISTS( SELECT COUNT(*) FROM #tmpDealNotApprove WHERE IsDealApproved != 'Y' )  
  BEGIN  
     
   UPDATE bst  
   SET  
    IsException = 'Y'  
   FROM  
    BV_Schedule_Transaction bst   
    INNER JOIN #tmpDealNotApprove tDA on tdA.File_Code = bst.File_Code AND tDA.Channel_Code = bst.Channel_Code AND tDA.IsDealApproved ! = 'Y'   
    AND tdA.Program_Episode_ID = bst.Program_Episode_ID   
    AND tDA.Title_Code = bst.Title_Code  
    AND tDA.Program_Episode_Number = bst.Program_Episode_Number  
  
  END  
    
 --===============4.2 DELETING all matched PROGRAMMIDS records FROM Temp_BV_Schedule --===============  
 DELETE FROM Temp_BV_Schedule WHERE File_Code = @File_Code AND Temp_BV_Schedule_Code IN  
 (  
  SELECT tbs.Temp_BV_Schedule_Code FROM #TMP_Temp_BV_Schedule tbs   
 )  
	IF OBJECT_ID('tempdb..#TMP_Program_Episode_ID') IS NOT NULL DROP TABLE #TMP_Program_Episode_ID
	IF OBJECT_ID('tempdb..#TMP_Temp_BV_Schedule') IS NOT NULL DROP TABLE #TMP_Temp_BV_Schedule
	IF OBJECT_ID('tempdb..#tmpDealNotApprove') IS NOT NULL DROP TABLE #tmpDealNotApprove
  
END