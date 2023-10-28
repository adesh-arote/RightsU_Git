CREATE PROCEDURE [dbo].[USP_BMS_Upload_Data]
@UDT Schedule_Data READONLY,
@FileType VARCHAR(10) = NULL,
@ChannelCode INT = NULL
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_BMS_Upload_Data]', 'Step 1', 0, 'Started Procedure', 0, ''

	INSERT INTO Temp_BV_Schedule ([Program_Episode_ID], [Program_Episode_Title], [Program_Episode_Number] , [Program_Category], [Program_Version_ID], [Schedule_Item_Log_Date], [Schedule_Item_Log_Time], [Schedule_Item_Duration], 
		[Scheduled_Version_House_Number_List], [Program_Title], [File_Code], [Channel_Code], [Inserted_By], [Inserted_On], [IsDealApproved], [TitleCode], [DMCode], [Deal_Code], [Deal_Type])

	SELECT [Program_Episode_ID], [Program_Episode_Title], [Program_Episode_Number] , [Program_Category], [Program_Version_ID], [Schedule_Item_Log_Date], [Schedule_Item_Log_Time], [Schedule_Item_Duration], 
		[Scheduled_Version_House_Number_List], [Program_Title], [File_Code], @ChannelCode, 0, GETDATE(), [IsDealApproved], [TitleCode], [DMCode], [Deal_Code], [Deal_Type] FROM @UDT   
	
	SELECT SCOPE_IDENTITY()

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_BMS_Upload_Data]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END