CREATE PROC [dbo].[usp_Schedule_Reject_File]
(
	@File_Code BIGINT,
	@ChannelCode INT
)
AS  
BEGIN  
-- =============================================
/*	
Steps:-	To validate the Schedule file; reject the Schedule file on diff. criteria.	
1.0	Update Schedule StartDate N EndDate For That Schedule File.
2.0	To update schedule date to add one day, due to schedule file contains same date for next days file (BROADCASTING DATE)
	(For eg. after 12am file contains last days date.)
3.0	Reject the Schedule file if ASRUN for the same date exist. 
	But system needs to show Log / Alert specifying the reason for rejection (i.e. send email).
	(for eg. system has ASRUN till 5th October 2011, then system will not accept schedule file of 1st Oct 2011). 
	3.1 Start send an exception email on file rejection (Reject file if AsRun loaded for that date).
	
4.0 System will not accept the ASRUN File for the month if Amort month is closed for that month. 
	(For eg. If system has ASRUN data till 31st August 2012 and if user close the amort month for that month. And tries to upload 
	10th August 2011 ASRUN file (revised AsRun), then system will reject the file with an Alert / Log specifying the reason for rejection).
	4.1 Start send an exception email on file rejection (Reject file if Amort month is closed for that date).

5.0 System will not accept the Schedule file if file contains start date time and end date time (with Offset time) 
	is not between as per define in Syatem Param. (i.e. 6.00 am to 6.00 am and with OffSet time)
	5.1 Start send an exception email on file rejection (i.e with above reason).

6.0 Delete from Temp_BV_Schedule AND Temp_BV_Schedule_Show, if revised dates schedule is load for the particular channel.
7.0 Filter shows related records and insert into temp_bv_schedule_Shows table.
	(THIS SQL STATEMENT MUST BE SAME AS DELETE OTHER THAN MOVIES STATEMENT (BELOW))
8.0 Delete the invalid houseid ranges except which are define in System Params. 
	(i.e. 'GM' & 'GMH' for Movies; 'GS' & 'GSH' for Shows)

	Note:-	As per discussed with prathesh sir on 06-FEB-2012 offset time is not consider for Schedule file.
*/
-- =============================================
	DECLARE @IsValidFileData CHAR(1);	SET @IsValidFileData = 'Y'

	--===============1.0 Update Schedule StartDate N EndDate For That Schedule File ===============--
	DECLARE @AsRunStartTime VARCHAR(100);	SET @AsRunStartTime = ''
	SELECT @AsRunStartTime = LTRIM(RTRIM(parameter_value)) FROM system_parameter_new WHERE parameter_name IN ('AsRun_StartTime')
	
	DECLARE @OffsetTime VARCHAR(50)
	SELECT @OffsetTime = ISNUll(OffsetTime_Schedule,'00:00') FROM Channel WHERE channel_code = @ChannelCode
	DECLARE @ScheduleStartTime_With_Offset DATETIME
	SET @OffsetTime  = '00:00'
	SELECT @ScheduleStartTime_With_Offset = CONVERT(DATETIME, @AsRunStartTime, 1) + @OffsetTime
	
	DECLARE @Schedule_StartDate DATETIME;	SET @Schedule_StartDate = ''
	
	SELECT @Schedule_StartDate = MIN(CONVERT(DATETIME, CONVERT (VARCHAR, Schedule_Item_Log_Date, 111), 111))+ @ScheduleStartTime_With_Offset 
	FROM Temp_BV_Schedule WHERE 1=1 AND File_Code = @File_Code --AND Channel_Code IN (@ChannelCode) --Commented By Bhavesh on 24 Dec 2014
	
	DECLARE @AsRunEndTime VARCHAR(100);	SET @AsRunEndTime = ''
	SELECT @AsRunEndTime =LTRIM(RTRIM(parameter_value)) FROM system_parameter_new WHERE parameter_name in ('AsRun_EndTime')
	
	SELECT @OffsetTime = ISNULL(OffsetTime_Schedule, '00:00') FROM Channel WHERE channel_code = @ChannelCode
		SET @OffsetTime  = '00:00'
	DECLARE @ScheduleEndTime_With_Offset DATETIME
	SELECT @ScheduleEndTime_With_Offset = CONVERT(DATETIME ,@AsRunEndTime, 1) + @OffsetTime
	
	DECLARE @Schedule_EndDate DATETIME;	SET @Schedule_EndDate = ''
	SELECT @Schedule_EndDate = MAX(CONVERT(DATETIME, CONVERT (VARCHAR, Schedule_Item_Log_Date, 111), 111)) + @ScheduleEndTime_With_Offset 
	FROM Temp_BV_Schedule WHERE 1 = 1 AND File_Code = @File_Code AND Channel_Code IN (@ChannelCode) 
	
	UPDATE Upload_Files SET StartDate = @Schedule_StartDate, EndDate = DATEADD(D, 1, @Schedule_EndDate)  WHERE File_code = @File_Code	
	--===============1.0 End Update Schedule StartDate N EndDate For That Schedule File ===============--
	
	SET @IsValidFileData = 'Y'
	SELECT @IsValidFileData AS 'IsValidFileData'
	
END  
/*  
EXEC [usp_Schedule_Reject_File] 1,24
*/