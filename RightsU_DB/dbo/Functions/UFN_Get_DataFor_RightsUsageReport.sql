CREATE FUNCTION [dbo].[UFN_Get_DataFor_RightsUsageReport]    
(    
 @Acq_Deal_Movie_Code INT,    
 @Type VARCHAR(50)    
)    
RETURNS VARCHAR(5000)    
AS    
BEGIN    
 -- Declare the return variable here    
 DECLARE @Result VARCHAR(5000) -----Platforms or Houseid    
 SET @Result = ''     
     
 IF(@Type = '')    
  SET @Type = 'H'    
 -- =============================================    
 -- TYPE     
 -- 'H' = House ID    
 -- 'P' = Platform    
 -- 'R' = No. Of Runs    
 -- 'T' = International Territory    
 -- 'CH' = Channels Name    
 -- 'CC' = Channels Code    
     
 -- 'RP' = Rights Period    
 -- 'PR' = Provision Run    
 -- 'AR' = Actual Run     
     
 -- 'PAR' = 'Provision Run' + 'Actual Run'    
 -- =============================================    
     
     
 --------------------- Platform ---------------------    
 IF(@Type = 'P')    
 BEGIN      
  select distinct     
  @Result += STUFF    
  ((    
   SELECT DISTINCT ', ' + P.platform_name FROM ACQ_Deal_Rights DMR    
   Inner JOIN Acq_Deal_Rights_Platform DMRP on DMRP.Acq_Deal_Rights_Code = DMR.Acq_Deal_Rights_Code    
   Inner JOIN Acq_Deal_Rights_Title DMRT on DMRT.Acq_Deal_Rights_Code = DMR.Acq_Deal_Rights_Code    
   Inner join Acq_Deal_Movie ADM on ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code    
   INNER JOIN [Platform]  P ON P.platform_code = DMRP.platform_code    
   WHERE 1=1    
   AND P.Platform_Code in    
   (    
    select platform_code from Platform where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
   )    
       
   FOR XML PATH('')    
  ),1,1,'')     
 END    
 --------------------- END Platform ---------------------    
     
 ----------------------- International Territory ---------------------    
 --ELSE IF(@Type = 'T')    
 --BEGIN    
 -- select distinct     
 -- @Result += STUFF    
 -- ((    
 --  SELECT DISTINCT ', ' + IT.international_territory_name FROM Deal_Movie_Rights DMR    
 --  INNER JOIN Deal_Movie_Rights_Territory DMRT on DMRT.deal_movie_rights_code = DMR.deal_movie_rights_code    
 --  INNER JOIN International_Territory  IT ON IT.international_territory_code = DMRT.territory_code    
 --  WHERE DMR.deal_movie_code in (@Acq_Deal_Movie_Code)    
 --  AND IT.international_territory_code in    
 --  (    
 --   select international_territory_code from International_Territory where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
 --  )    
       
 --  FOR XML PATH('')    
 -- ),1,1,'')     
    
 --END    
 --------------------- End International Territory ---------------------    
 ----------------------- HouseID ---------------------    
 --ELSE IF(@Type = 'H')    
 --BEGIN    
 -- select distinct     
 -- @Result += STUFF    
 -- ((    
 --  SELECT DISTINCT ', ' + DMCH.House_ID FROM Deal_Movie_Contents_HouseID DMCH    
 --  INNER JOIN Deal_Movie_Contents DMC ON DMC.deal_movie_content_code = DMCH.deal_movie_content_code    
 --  WHERE DMC.deal_movie_code in (@Acq_Deal_Movie_Code)    
       
 --  FOR XML PATH('')    
 -- ),1,1,'')     
 --END    
 --------------------- End HouseID ---------------------    
     
 --------------------- No Of Runs ---------------------    
 ELSE IF(@Type = 'R')    
 BEGIN    
  DECLARE @NoOfRuns INT    
  SET @NoOfRuns = 0    
      
  DECLARE @Unlimited_Cnt INT    
  SELECT  @Unlimited_Cnt = COUNT(run_type) from     
  (     
   SELECT DMR.no_of_runs, run_type FROM Acq_Deal_Run DMR    
   WHERE 1=1 AND Acq_Deal_Code in (    
    select distinct Acq_Deal_Code from Acq_Deal_Movie where Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
   )    
  )  rights WHERE rights.run_type ='U' group by rights.run_type     
      
  SELECT @NoOfRuns = SUM(rights.no_of_runs) from     
  (    
   SELECT DMR.no_of_runs FROM Acq_Deal_Run DMR    
   WHERE 1=1 AND Acq_Deal_Code in (    
    select distinct Acq_Deal_Code from Acq_Deal_Movie where Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
   )    
  )  rights     
      
      
  IF(@Unlimited_Cnt > 0 AND @NoOfRuns > 0)    
  BEGIN    
   SET @Result = 'Unlimited' + ' / ' + CAST(@NoOfRuns as varchar)    
  END    
  ELSE IF(@Unlimited_Cnt > 0)      BEGIN    
   SET @Result = 'Unlimited' ---------- + ',' + @Result    
  END    
  ELSE    
  BEGIn    
   SET @Result = @NoOfRuns    
  END    
      
      
      
 END    
 --------------------- End No Of Runs ---------------------    
     
 --------------------- Channel Names ---------------------    
 ELSE IF(@Type = 'CH')    
 BEGIN    
  DECLARE  @Acq_D_Code INT=0, @Title_Code INT = 0, @EpisodeFrom INT=0, @EpisodeTo INT=0    
  select TOP 1 @Acq_D_Code = Acq_Deal_Code, @Title_Code = Title_Code, @EpisodeFrom = Episode_Starts_From, @EpisodeTo = Episode_End_To    
  from Acq_Deal_Movie where Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
    
    
    
     IF EXISTS(SELECT TOP 1 D.Acq_Deal_Code from ACQ_Deal D INNER JOIN    
   Acq_Deal_Rights ADR on ADR.Acq_Deal_Code = D.Acq_Deal_Code AND D.Acq_Deal_Code in (@Acq_D_Code)    
   Where D.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADR.Acq_Deal_Rights_Code in    
   (    
    select DISTINCT ADRP.Acq_Deal_Rights_Code from Acq_Deal_Rights_Platform ADRP    
    INNER JOIN Platform P ON ADRP.Platform_Code = P.Platform_Code AND isnull(applicable_for_asrun_schedule,'N') = 'Y'    
   )    
  )    
  BEGIN    
   select distinct     
   @Result += STUFF    
   (    
    (    
     select DISTINCT ', ' + C.channel_name from ACQ_Deal D    
     INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code AND D.Acq_Deal_Code in (@Acq_D_Code)    
     INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code    
     AND ADRT.Episode_From = @EpisodeFrom AND ADRT.Episode_To = @EpisodeTo    
     INNER JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code    
     INNER JOIN Channel C on C.channel_code = DMRRC.channel_code    
  WHERE  
  D.Deal_Workflow_Status NOT IN ('AR', 'WA')  
    FOR XML PATH('')    
    ),1,1,''    
   )     
  END    
 END    
 --------------------- End Channel Names ---------------------    
    
 --------------------- Channel Names ---------------------    
 ELSE IF(@Type = 'CC')    
 BEGIN    
  select distinct     
  @Result += STUFF    
  (    
   (    
    select DISTINCT ', ' + C.channel_name from ACQ_Deal D    
    inner join Acq_Deal_Rights ADR on ADR.Acq_Deal_Code = D.Acq_Deal_Code    
    inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code    
    AND ADRP.Platform_Code in    
    (    
     select platform_code from Platform where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
    )    
    INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code    
    inner join Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code    
    inner join Channel C on C.channel_code = DMRRC.channel_code    
    WHERE 1=1 AND D.Deal_Workflow_Status NOT IN ('AR', 'WA') AND D.Acq_Deal_Code in ( select distinct Acq_Deal_Code from Acq_Deal_Movie where Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code))    
   FOR XML PATH('')    
   ),1,1,''    
  )     
      
 END    
 --------------------- End Channel Names ---------------------    
     
 --------------------- Rights Period ---------------------    
 ELSE IF(@Type = 'RP')    
 BEGIN    
  select distinct     
  @Result += STUFF    
  ((    
   select DISTINCT ',' +     
       
   case when isnull(convert(varchar(20),ADR.right_start_date,103),'')=''         
   and isnull(convert(varchar(20),ADR.right_end_date,103),'')='' then 'Unlimited' else        
   convert(varchar(20),ADR.right_start_date,103) +' - '+ convert(varchar(20),ADR.right_end_date,103) end    
       
   from ACQ_Deal D    
    inner join Acq_Deal_Rights ADR on ADR.Acq_Deal_Code = D.Acq_Deal_Code    
    inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code    
    Inner Join Acq_Deal_Rights_Title ADRT on ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code    
    Inner Join Acq_Deal_Movie ADM On ADM.Acq_Deal_Code = D.Acq_Deal_Code And ADRT.Title_Code = ADM.Title_Code And ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code    
    AND ADRP.Platform_Code in    
    (    
     select platform_code from Platform where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
    )    
 WHERE D.Deal_Workflow_Status NOT IN ('AR', 'WA')  
    --WHERE 1=1 AND D.Acq_Deal_Code in ( select distinct Acq_Deal_Code from Acq_Deal_Movie where Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code))    
  FOR XML PATH('')    
  ),1,1,'')     
      
 END    
 --------------------- END Rights Period ---------------------    
     
 --------------------- Provision Run ---------------------    
 ELSE IF(@Type = 'PR')    
 BEGIN    
      
  Select @Result = count(*) From BV_Schedule_Transaction bv     
  Inner Join Acq_Deal_Movie adm On adm.Acq_Deal_Movie_Code = bv.Deal_Movie_Code And adm.Title_Code = bv.Title_Code And adm.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code    
    
  --SELECT @Result = SUM(rights.no_of_runs_sched) from     
  --(    
  -- select a.no_of_runs_sched from     
  -- (    
  --  SELECT ISNULL(DMRRC.no_of_runs_sched,0) no_of_runs_sched, ADRP.platform_code,     
  --  MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode    
  --  FROM ACQ_Deal D    
  --  Inner join Acq_Deal_Movie ADM on ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
  --  inner join Acq_Deal_Rights ADR on ADR.Acq_Deal_Code = D.Acq_Deal_Code    
  --  inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code    
  --  AND ADRP.Platform_Code in    
  --  (    
  --   select platform_code from Platform where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
  --  )    
  --  INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code    
  --  inner join Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code    
  --  inner join Channel C on C.channel_code = DMRRC.channel_code    
  --  --WHERE 1=1 AND D.Acq_Deal_Code in ( select distinct Acq_Deal_Code from Acq_Deal_Movie where Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code))    
  -- ) a where a.platform_code = a.MaxPtCode    
  --)  rights     
 END    
 --------------------- END Provision Run ---------------------     
    
 --------------------- Actual Run ---------------------    
 ELSE IF(@Type = 'AR')    
 BEGIN    
  SELECT @Result = SUM(rights.no_of_AsRuns) from     
  (    
   select a.no_of_AsRuns from     
   (    
    SELECT ISNULL(DMRRC.no_of_AsRuns,0) no_of_AsRuns, ADRP.platform_code,     
    MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode    
     FROM ACQ_Deal D    
    Inner join Acq_Deal_Movie ADM on ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
    inner join Acq_Deal_Rights ADR on ADR.Acq_Deal_Code = D.Acq_Deal_Code    
    inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code    
    AND ADRP.Platform_Code in    
    (    
     select platform_code from Platform where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
    )    
    INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code    
    inner join Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code    
    inner join Channel C on C.channel_code = DMRRC.channel_code    
 WHERE D.Deal_Workflow_Status NOT IN ('AR', 'WA')  
   ) a where a.platform_code = a.MaxPtCode      
  )  rights     
 END    
 --------------------- END Actual Run ---------------------     
     
 --------------------- Actual Run ---------------------    
 ------------ PAR = Provision + Actual Run    
 ELSE IF(@Type = 'PAR')    
 BEGIN    
      
  DECLARE @ProvRun INT; SET @ProvRun = 0    
  DECLARE @ActRun INT; SET @ActRun = 0    
    
  --SELECT @ActRun = SUM(rights.no_of_AsRuns) from     
  --(    
  -- select a.no_of_AsRuns from     
  -- (    
  --  SELECT ISNULL(DMRRC.no_of_AsRuns,0) no_of_AsRuns, ADRP.platform_code,     
  --  MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode    
  --  --0  as MaxPtCode    
  --  FROM ACQ_Deal D    
 --  Inner join Acq_Deal_Movie ADM on ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
  --  inner join Acq_Deal_Rights ADR on ADR.Acq_Deal_Code = D.Acq_Deal_Code    
  --  inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code    
  --  AND ADRP.Platform_Code in    
  --  (    
  --   select platform_code from Platform where isnull(applicable_for_asrun_schedule,'N') = 'Y'    
  --  )    
  --  INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code    
  --  inner join Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code    
  --  inner join Channel C on C.channel_code = DMRRC.channel_code    
  -- ) a where a.platform_code = a.MaxPtCode      
  --)  rights     
      
  --set @ActRun = 0    
      
  SELECT @ProvRun = SUM(rights.no_of_runs_sched) from     
  (    
   SELECT DISTINCT ISNULL(DMRRC.no_of_runs_sched,0) no_of_runs_sched, DMRRC.Acq_Deal_Run_Channel_Code    
   FROM ACQ_Deal D    
   Inner join Acq_Deal_Movie ADM on ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)    
   INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code    
   INNER JOIN Acq_Deal_Run_Title DMRRT on DMRRT.Title_Code = ADM.Title_Code AND DMRRT.Episode_From = ADM.Episode_Starts_From     
   AND DMRRT.Episode_To = ADM.Episode_End_To    
   inner join Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_Code = DMRRT.Acq_Deal_Run_Code    
   inner join Channel C on C.channel_code = DMRRC.channel_code   
   WHERE D.Deal_Workflow_Status NOT IN ('AR', 'WA')  
  )  rights     
      
  SET @Result = @ProvRun + @ActRun    
      
 END    
 --------------------- END Actual Run ---------------------     
     
 -- Return the result of the function    
 RETURN @Result    
    
END    
    
/*    
SELECT dbo.fn_getDataFor_RightsUsageReport (TmpRightsUsage.deal_movie_code, 'H')    
SELECT dbo.fn_getDataFor_RightsUsageReport (637, 'CC')    
*/