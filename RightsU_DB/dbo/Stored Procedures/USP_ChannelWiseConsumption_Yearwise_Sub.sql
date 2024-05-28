CREATE PROCEDURE [dbo].[USP_ChannelWiseConsumption_Yearwise_Sub]
(          
 @DealMovieCode INT,
 @ChannelCode VARCHAR(MAX),
 @AllYears CHAR(1)='N' ,
 @IsDisplay_Date CHAR(1) ='N',
 @dBug CHAR(1)='N' 
)          
AS          

BEGIN          
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_ChannelWiseConsumption_Yearwise_Sub]', 'Step 1', 0, 'Started Procedure', 0, ''
         
	 SET NOCOUNT ON;          
	
	 CREATE TABLE #ScheduleAsRun_YearWiseDetails_Report
	 (                     
	  Yearwise_Start_Date DATETIME,
	  Yearwise_End_Date  DATETIME,
	  No_Of_Runs INT,          
	  Provision INT,          
	  Consume INT,      
	  Balance INT
	 )           
		IF(ISNULL(@ChannelCode,'')='')
			SET @ChannelCode=''
	
	Declare @BUCode INT =0
	Select @BUCode = Business_Unit_Code from Acq_Deal (NOLOCK) Where Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code IN
	(
		Select Distinct Acq_Deal_Code from Acq_Deal_Movie (NOLOCK)  Where Acq_Deal_Movie_Code=ISNULL(@DealMovieCode,0)
	)
		IF(@IsDisplay_Date='Y')
		BEGIN
				insert into #ScheduleAsRun_YearWiseDetails_Report(Yearwise_Start_Date,Yearwise_End_Date)
				select distinct ADYR.Start_Date,ADYR.End_Date
				from Acq_Deal_Movie ADM  (NOLOCK)
				inner join Acq_Deal AD (NOLOCK) on AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @DealMovieCode		
				inner join Acq_Deal_Run_Title ADRT  (NOLOCK) on ADRT.Title_Code = ADM.Title_Code
				inner join Acq_Deal_Run ADR (NOLOCK) on ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code
				inner join Acq_Deal_Run_Channel ADRC  (NOLOCK) on ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code 
				AND ((@ChannelCode <>'' AND ADRc.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) 
				or @ChannelCode ='' )
				inner join Acq_Deal_Run_Yearwise_Run ADYR (NOLOCK) on ADYR.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
				WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		END

	IF((Select COUNT(@BUCode) from Business_Unit (NOLOCK) Where Business_Unit_Code = @BUCode AND RTRIM(LTRIM(Business_Unit_Name)) = 'Hindi Movies')>0)
	 BEGIN  
	 if(@dBug='D')
		PRINT 'HINDI'
		IF(@IsDisplay_Date='N')
		BEGIN
		insert into #ScheduleAsRun_YearWiseDetails_Report
		 select 
			distinct 
		   ADYR.Start_Date,
		   ADYR.End_Date,
		   ADYR.No_Of_Runs as No_Of_Runs
		   ,ADYR.No_Of_Runs_Sched  as Provision
		   ,ADYR.No_Of_AsRuns as Consume
		   , (  (ADYR.No_Of_Runs) - (ISNULL(ADYR.No_Of_Runs_Sched,0) + ISNULL(ADYR.No_Of_AsRuns,0)) )   as Balance
		   from Acq_Deal_Movie ADM  (NOLOCK)
			inner join Acq_Deal AD (NOLOCK) on AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @DealMovieCode
			inner join Acq_Deal_Run_Title ADRT (NOLOCK) on ADRT.Title_Code = ADM.Title_Code
			inner join Acq_Deal_Run_Channel ADRC (NOLOCK) on ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND  ((@ChannelCode <>'' AND ADRc.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) or @ChannelCode ='' )
			inner join Acq_Deal_Run_Yearwise_Run ADYR (NOLOCK) on ADYR.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		END
	END       
	ELSE
	BEGIN
	if(@dBug='D')
		PRINT 'English'
		IF(@IsDisplay_Date='N')
		BEGIN	
			insert into #ScheduleAsRun_YearWiseDetails_Report
			select distinct ADYR.Start_Date,ADYR.End_Date,
			case When ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 THEN 0 ELSE  ISNULL(ADYR.No_Of_Runs,Min_Runs) END as No_Of_Runs,
			case When ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 AND  ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0	THEN 0 ELSE  ISNULL(ADYR.No_Of_Runs_Sched,0)  END as Provision,
			case When ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 THEN 0 ELSE ISNULL(ADYR.No_Of_AsRuns,0) END as Consume,
			case When ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 THEN 0 ELSE  (  (ISNULL(ADYR.No_Of_Runs,0)) - (ISNULL(ADYR.No_Of_Runs_Sched,0) + ISNULL(ADYR.No_Of_AsRuns,0)) ) END  as Balance
			 --((ADYR.No_Of_Runs) - (ADYR.No_Of_Runs_Sched + ADYR.No_Of_AsRuns) ) as Balance
			from Acq_Deal_Movie ADM  (NOLOCK)
			inner join Acq_Deal AD  (NOLOCK) on AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @DealMovieCode		
			inner join Acq_Deal_Run_Title ADRT (NOLOCK) on ADRT.Title_Code = ADM.Title_Code
			inner join Acq_Deal_Run ADR  (NOLOCK) on ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code
			inner join Acq_Deal_Run_Channel ADRC (NOLOCK) on ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND ((@ChannelCode <>'' AND ADRc.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) or @ChannelCode ='' )
			inner join Acq_Deal_Run_Yearwise_Run ADYR (NOLOCK) on ADYR.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		END		
	END
		select distinct  
			CONVERT(VARCHAR(25), convert(datetime,Yearwise_Start_Date,103), 106) as Yearwise_Start_Date,
			CONVERT(VARCHAR(25), convert(datetime,Yearwise_End_Date,103), 106) as Yearwise_End_Date,
			No_Of_Runs
		   , Provision
		   , Consume, Balance
		   , CASE WHEN (GETDATE() BETWEEN Yearwise_Start_Date AND Yearwise_End_Date)
			 THEN 'Y'  ELSE 'N' END isCurrentYear
		FROM #ScheduleAsRun_YearWiseDetails_Report
		WHERE 1=1 AND	
			(
				(@AllYears = 'N' AND GETDATE() BETWEEN Yearwise_Start_Date AND Yearwise_End_Date)
				OR @AllYears = 'Y'
			)
	 drop table #ScheduleAsRun_YearWiseDetails_Report          
 
	 IF(@dBug='D')
	 BEGIN
	  select 
			distinct 
			ADRC.No_Of_AsRuns,ADRC.No_Of_Runs_Sched,
		   ADYR.Start_Date,
		   ADYR.End_Date,
		   ADYR.No_Of_Runs as No_Of_Runs
		   ,ADYR.No_Of_Runs_Sched  as Provision
		   ,ADYR.No_Of_AsRuns as Consume
		   , (  (ADYR.No_Of_Runs) - (ADYR.No_Of_Runs_Sched + ADYR.No_Of_AsRuns) )   as Balance
		   from Acq_Deal_Movie ADM  (NOLOCK)
			inner join Acq_Deal AD (NOLOCK) on AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @DealMovieCode
			inner join Acq_Deal_Run_Title ADRT (NOLOCK) on ADRT.Title_Code = ADM.Title_Code
			inner join Acq_Deal_Run_Channel ADRC (NOLOCK) on ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND ((@ChannelCode <>'' AND ADRc.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) or @ChannelCode ='' )
			inner join Acq_Deal_Run_Yearwise_Run ADYR (NOLOCK) on ADYR.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	END

		IF OBJECT_ID('tempdb..#ScheduleAsRun_YearWiseDetails_Report') IS NOT NULL DROP TABLE #ScheduleAsRun_YearWiseDetails_Report
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_ChannelWiseConsumption_Yearwise_Sub]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END