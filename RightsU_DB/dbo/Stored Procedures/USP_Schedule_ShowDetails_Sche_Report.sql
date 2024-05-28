CREATE PROCEDURE [dbo].[USP_Schedule_ShowDetails_Sche_Report]   
(  
	 @DMCode varchar(MAX),
	 @Title_Code INT,
	 @Deal_Code INT,
	 @Episode INT,
	 @Deal_Type CHAR(1),

	 @StartDate VARCHAR(30),
	 @EndDate VARCHAR(30),
	 @Channel VARCHAR(MAX),
	 @ExcludeExpiredDeal BIT,
	 @RunType VARCHAR(1)
)  
AS  

BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Schedule_ShowDetails_Sche_Report]', 'Step 1', 0, 'Started Procedure', 0, ''
		-- Set NOCOUNT ON added to prevent extra result Sets From  
		-- interfering with Select statements.  
		Set NOCOUNT ON;

		DECLARE @DealTypeName VARCHAR(20) = '', @DealTypeCode INT 

		select @DealTypeCode = Deal_Type_Code from Title  where Title_Code = @Title_Code

		select  @DealTypeName = [dbo].[UFN_GetDealTypeCondition](@DealTypeCode)
   
		DECLARE @PtCode_N_TerrCode AS TABLE  
		(  
			PtCode INT  
		)  
		INSERT INTO @PtCode_N_TerrCode (PtCode)  
		Select platform_code From Platform (NOLOCK) Where IsNull(applicable_for_asrun_schedule,'N') = 'Y'  
   
		DECLARE @Schedule_Details_ReportAS TABLE
		(
			BV_Schedule_Transaction_Code NUMERIC(18,0),
			Program_Episode_Title NVARCHAR(500),
			Program_Episode_Number NVARCHAR(250),
			Program_Title NVARCHAR(500),
			Program_Category NVARCHAR(250),
			Schedule_Item_Log_Date VARCHAR(100),
			Schedule_Item_Log_Time VARCHAR(100),
			Schedule_Item_Duration VARCHAR(100),
			Scheduled_Version_House_Number_List NVARCHAR(1000),
			File_Code NUMERIC (18,0),
			Channel_Code NUMERIC (18,0),
			IsProcessed CHAR(1),
			Deal_Movie_Code NUMERIC (18,0),
			Deal_Movie_Rights_Code NUMERIC (18,0),
			Channel_Name NVARCHAR(1000),
			RightsPeriod VARCHAR(100),
			DMR_StartDate DATETIME,
			DMR_EndDate  DATETIME,
			Available_Channels_Code VARCHAR(1000),
			Available_Channels NVARCHAR(1000)
		)  
   
		Insert InTo @Schedule_Details_ReportAS
		(  
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title,
			Program_Category , Schedule_Item_Log_Date , Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, IsProcessed, Deal_Movie_Code, Deal_Movie_Rights_Code,
			Channel_Name,
			RightsPeriod, DMR_StartDate, DMR_EndDate, Available_Channels_Code, Available_Channels
		)
		Select Distinct  
		bst.BV_Schedule_Transaction_Code, bst.Program_Episode_Title, bst.Program_Episode_Number, bst.Program_Title,  
		bst.Program_Category, convert(varchar(20),cast(bst.Schedule_Item_Log_Date as datetime),103), bst.Schedule_Item_Log_Time, bst.Schedule_Item_Duration, bst.Scheduled_Version_House_Number_List,  
		bst.File_Code, bst.Channel_Code, bst.IsProcessed, bst.Deal_Movie_Code, bst.Deal_Movie_Rights_Code,  
		C.channel_name,  
		Case
			--When IsNull(Convert(varchar(20),dmr.Right_Start_Date,103),'') = '' And IsNull(Convert(varchar(20),dmr.Right_End_Date,103),'') = '' Then 'Perpetuity'
			When IsNull(dmr.Right_Type, 'Y') = 'U' Then Convert(varchar(20),dmr.right_start_date,103) + ' - Perpetuity'
			Else  Convert(varchar(20),dmr.right_start_date,103) +' - '+ Convert(varchar(20),dmr.right_end_date,103)
		End as RightsPeriod,
		dmr.right_start_date, dmr.right_end_date, NULL, NULL
		From BV_Schedule_Transaction bst (NOLOCK)
		Inner Join Acq_Deal_Movie dm (NOLOCK) on dm.Title_Code = bst.Title_Code
		Inner Join Acq_Deal_Rights dmr (NOLOCK) on dmr.Acq_Deal_Code = dm.Acq_Deal_Code
		Inner Join Acq_Deal_Rights_Title dmrt (NOLOCK) on dmrt.Acq_Deal_Rights_Code = dmr.Acq_Deal_Rights_Code And dm.Title_Code = dmrt.Title_Code AND @Episode BETWEEN dmrt.Episode_From AND dmrt.Episode_To
		--Inner Join Acq_Deal_Rights_Platform dmrp on dmrp.Acq_Deal_Rights_Code = dmr.Acq_Deal_Rights_Code
		-----------And dmr.deal_movie_rights_code in (bst.Deal_Movie_Rights_Code)
		Inner Join Channel C (NOLOCK) on C.channel_code = bst.Channel_Code
		Where --dmrp.Platform_Code in (Select IsNull(PtCode,0) From @PtCode_N_TerrCode) And 
		(bst.Program_Episode_Number = @Episode OR @DealTypeName = 'DEAL_MOVIE') 
		AND dm.Acq_Deal_Movie_Code in (select number from fn_Split_withdelemiter(@DMCode,',')) 
		And IsNull(bst.IsRevertCnt_OnAsRunLoad,'N') = 'N'
		AND ((IsNull(@Channel, '') = '' OR bst.Channel_Code in (select number from dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')
		AND ((ISNULL(@StartDate, '') = '' OR @EndDate <> '' AND CONVERT(date,bst.Schedule_Item_Log_Date,103) BETWEEN CONVERT(date,@StartDate,103) AND CONVERT(date,@EndDate,103)) OR (@StartDate<>'' AND @EndDate = '' AND CONVERT(date,bst.Schedule_Item_Log_Date,103) = CONVERT(date,@StartDate,103)) OR (@StartDate='' AND @EndDate <> '' AND CONVERT(date,bst.Schedule_Item_Log_Date,103) = CONVERT(date,@EndDate,103)) OR (@StartDate = '' AND @EndDate = ''))
		AND ((@ExcludeExpiredDeal = '1' AND ((Convert(date, dmr.Right_Start_Date, 103) >= Convert(date, GETDATE() , 103)) OR (Convert(date, isnull(dmr.Right_End_Date, GETDATE() ), 103) >= Convert(date, GETDATE() , 103)))) OR @ExcludeExpiredDeal = '0')
		AND 
					(
						(EXISTS(SELECT * FROM Acq_Deal_Run ADU (NOLOCK)
								INNER JOIN Acq_Deal_Run_Title ADUT (NOLOCK) ON ADU.Acq_Deal_Run_Code = ADUT.Acq_Deal_Run_Code
								WHERE ADU.Acq_Deal_Code = dm.Acq_Deal_Code AND ADUT.Title_Code = dm.Title_Code AND ADU.Run_Type = @RunType)
						)
					OR 
						ISNULL(@RunType, '') = ''
					)
				

		Update @Schedule_Details_ReportAS  Set
		Available_Channels_Code = (Select dbo.UFN_Get_DataFor_RightsUsageReport_New (a.deal_movie_code, 0, 'CC',@StartDate,@EndDate,@Channel,@RunType)),
		Available_Channels = (Select dbo.UFN_Get_DataFor_RightsUsageReport_New (a.deal_movie_code, 0, 'CH',@StartDate,@EndDate,@Channel,@RunType))
		From @Schedule_Details_ReportAS a


	--Select Program_Episode_Title, Program_Episode_Number, Program_Title,Program_Category,
	--				Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
	--				Channel_Name, RightsPeriod, DMR_StartDate, DMR_EndDate,  Available_Channels_Code, Available_Channels
	--				From @Schedule_Details_ReportAS order by --Schedule_Item_Log_Date
	--				Convert(date, Schedule_Item_Log_Date, 103) DESC

				select 
					Program_Episode_Title
					, Program_Episode_Number
					, Program_Title
					, Program_Category
					, Schedule_Item_Log_Date
					, Schedule_Item_Log_Time
					, Schedule_Item_Duration
					, Scheduled_Version_House_Number_List
					, Channel_Name
					, RightsPeriod
					--STUFF(
					--(Select Distinct ', ' + CAST(b.RightsPeriod as varchar)
					--	From @Schedule_Details_ReportAS b
					--	Where a.BV_Schedule_Transaction_Code = b.BV_Schedule_Transaction_Code 
					--			And ISNULL(a.Program_Episode_Title,'') = ISNULL(b.Program_Episode_Title ,'')
					--			And ISNULL(a.Program_Episode_Number,'1') = ISNULL(b.Program_Episode_Number,'1')
					--			And a.Program_Title = b.Program_Title
					--			And a.Program_Category = b.Program_Category
					--			And a.Schedule_Item_Log_Date = b.Schedule_Item_Log_Date
					--			And a.Schedule_Item_Log_Time = b.Schedule_Item_Log_Time
					--			And a.Schedule_Item_Duration = b.Schedule_Item_Duration
					--			And a.Channel_Name = b.Channel_Name
					-- FOR XML PATH('')), 1, 1, '') as RightsPeriod
					--, DMR_StartDate
					--, DMR_EndDate
					, Available_Channels_Code
					, Available_Channels
					from 
				(
					Select BV_Schedule_Transaction_Code,Program_Episode_Title, Program_Episode_Number, Program_Title,Program_Category,
					Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
					Channel_Name, RightsPeriod,
					--DMR_StartDate, DMR_EndDate, 
					Available_Channels_Code, Available_Channels
					From @Schedule_Details_ReportAS 
				
					GROUP BY BV_Schedule_Transaction_Code,Program_Episode_Title, Program_Episode_Number, Program_Title,Program_Category,
					Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
					Channel_Name, RightsPeriod
					--,DMR_StartDate, DMR_EndDate
					, Available_Channels_Code, Available_Channels
				)AS a
 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Schedule_ShowDetails_Sche_Report]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END