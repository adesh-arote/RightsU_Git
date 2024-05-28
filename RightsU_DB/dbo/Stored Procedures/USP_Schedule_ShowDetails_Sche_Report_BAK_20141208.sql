CREATE PROCEDURE [dbo].[USP_Schedule_ShowDetails_Sche_Report_BAK_20141208]   
(  
 @DMCode INT  
)  
AS  
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Schedule_ShowDetails_Sche_Report_BAK_20141208]', 'Step 1', 0, 'Started Procedure', 0, ''
		-- Set NOCOUNT ON added to prevent extra result Sets From  
		-- interfering with Select statements.  
		Set NOCOUNT ON;  
   
		DECLARE @PtCode_N_TerrCode AS TABLE  
		(  
			PtCode INT  
		)  
		INSERT INTO @PtCode_N_TerrCode (PtCode)  
		Select platform_code From Platform (NOLOCK) Where IsNull(applicable_for_asrun_schedule,'N') = 'Y'  
   
		DECLARE @Schedule_Details_ReportAS TABLE
		(
			BV_Schedule_Transaction_Code NUMERIC(18,0),
			Program_Episode_Title VARCHAR(500),
			Program_Episode_Number VARCHAR(250),
			Program_Title VARCHAR(500),
			Program_Category VARCHAR(250),
			Schedule_Item_Log_Date VARCHAR(100),
			Schedule_Item_Log_Time VARCHAR(100),
			Schedule_Item_Duration VARCHAR(100),
			Scheduled_Version_House_Number_List VARCHAR(1000),
			File_Code NUMERIC (18,0),
			Channel_Code NUMERIC (18,0),
			IsProcessed CHAR(1),
			Deal_Movie_Code NUMERIC (18,0),
			Deal_Movie_Rights_Code NUMERIC (18,0),
			Channel_Name VARCHAR(1000),
			RightsPeriod VARCHAR(100),
			DMR_StartDate DATETIME,
			DMR_EndDate  DATETIME,
			Available_Channels_Code VARCHAR(1000),
			Available_Channels VARCHAR(1000)
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
		bst.Program_Category, bst.Schedule_Item_Log_Date, bst.Schedule_Item_Log_Time, bst.Schedule_Item_Duration, bst.Scheduled_Version_House_Number_List,  
		bst.File_Code, bst.Channel_Code, bst.IsProcessed, bst.Deal_Movie_Code, bst.Deal_Movie_Rights_Code,  
		C.channel_name,  
		Case
			--When IsNull(Convert(varchar(20),dmr.Right_Start_Date,103),'') = '' And IsNull(Convert(varchar(20),dmr.Right_End_Date,103),'') = '' Then 'Perpetuity'
			When IsNull(dmr.Right_Type, 'Y') = 'U' Then Convert(varchar(20),dmr.right_start_date,103) + ' - Perpetuity'
			Else  Convert(varchar(20),dmr.right_start_date,103) +' - '+ Convert(varchar(20),dmr.right_end_date,103)
		End as RightPeriod,
		dmr.right_start_date, dmr.right_end_date, NULL, NULL
		From BV_Schedule_Transaction bst (NOLOCK)
		Inner Join Acq_Deal_Movie dm (NOLOCK) on dm.Acq_Deal_Movie_Code = bst.Deal_Movie_Code And dm.Title_Code = bst.Title_Code
		Inner Join Acq_Deal_Rights dmr (NOLOCK) on dmr.Acq_Deal_Code = dm.Acq_Deal_Code
		Inner Join Acq_Deal_Rights_Title dmrt (NOLOCK) on dmrt.Acq_Deal_Rights_Code = dmr.Acq_Deal_Rights_Code And dm.Title_Code = dmrt.Title_Code
		--Inner Join Acq_Deal_Rights_Platform dmrp on dmrp.Acq_Deal_Rights_Code = dmr.Acq_Deal_Rights_Code
		-----------And dmr.deal_movie_rights_code in (bst.Deal_Movie_Rights_Code)
		Inner Join Channel C (NOLOCK) on C.channel_code = bst.Channel_Code
		Where --dmrp.Platform_Code in (Select IsNull(PtCode,0) From @PtCode_N_TerrCode) And 
		dm.Acq_Deal_Movie_Code in (@DMCode)
		And IsNull(bst.IsRevertCnt_OnAsRunLoad,'N') = 'N'

		Update @Schedule_Details_ReportAS  Set
		Available_Channels_Code = (Select dbo.UFN_Get_DataFor_RightsUsageReport (a.deal_movie_code, 'CC')),
		Available_Channels = (Select dbo.UFN_Get_DataFor_RightsUsageReport (a.deal_movie_code, 'CH'))
		From @Schedule_Details_ReportAS a

		Select Program_Episode_Title, Program_Episode_Number, Program_Title,Program_Category,
		Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
		Channel_Name, RightsPeriod, DMR_StartDate, DMR_EndDate,  Available_Channels_Code, Available_Channels
		From @Schedule_Details_ReportAS order by --Schedule_Item_Log_Date
		Convert(date, Schedule_Item_Log_Date, 103)
   
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Schedule_ShowDetails_Sche_Report_BAK_20141208]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
