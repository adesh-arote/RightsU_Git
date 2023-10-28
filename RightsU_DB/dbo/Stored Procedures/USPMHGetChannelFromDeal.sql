﻿CREATE Procedure [dbo].[USPMHGetChannelFromDeal] 
@TitleCode BIGINT
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetChannelFromDeal]', 'Step 1', 0, 'Started Procedure', 0, ''

		IF(OBJECT_ID('TEMPDB..#tempDefaultChannels') IS NOT NULL)
			DROP TABLE #tempDefaultChannels
	
		DECLARE @ChannelCode Int

		CREATE TABLE #tempDefaultChannels(
		Channel_Code INT,
		Channel_Name NVARCHAR(MAX)
		)

		INSERT INTO #tempDefaultChannels(Channel_Code,Channel_Name)
		Select Channel_Code,Channel_Name from Channel (NOLOCK)  Where 1=1  AND Is_active = 'Y' AND Channel_Name IN ('Colors Bangla','Colors Gujarati','Colors India','Colors Kannada','Colors Marathi','Colors Oriya','Colors Super','Colors Tamil','MTV')

		--Select * from #tempDefaultChannels
	
		SET @ChannelCode = (SELECT top 1 Channel_Code from Acq_Deal_Run_Channel (NOLOCK)  WHERE Acq_Deal_Run_Code IN (Select Acq_Deal_Run_Code from Acq_Deal_Run_Title (NOLOCK)  WHERE Title_Code = @TitleCode))
		Print @ChannelCode

		IF EXISTS(Select * from #tempDefaultChannels where Channel_Code = @ChannelCode)
			BEGIN
				SELECT CAST(@ChannelCode AS NVARCHAR) AS ChannelCode
			END
		ELSE
			BEGIN
				SELECT '1' AS ChannelCode
			END

			IF OBJECT_ID('tempdb..#tempDefaultChannels') IS NOT NULL DROP TABLE #tempDefaultChannels
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetChannelFromDeal]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END