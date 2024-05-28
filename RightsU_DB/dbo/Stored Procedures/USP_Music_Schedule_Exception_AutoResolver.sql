CREATE PROC [dbo].[USP_Music_Schedule_Exception_AutoResolver]
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	25 November 2016
Description:	Auto Resolve Music Schedule Exception, If they are Valid
=======================================================================================================================================*/
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Music_Schedule_Exception_AutoResolver]', 'Step 1', 0, 'Started Procedure', 0, '' 
		IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransactionCodes') IS NOT NULL)
				DROP TABLE #TempMusicScheduleTransactionCodes


		SELECT Music_Schedule_Transaction_Code, BV_Schedule_Transaction_Code, 'N' AS Is_Processed
		INTO #TempMusicScheduleTransactionCodes
		FROM Music_Schedule_Transaction (NOLOCK) WHERE ISNULL(Is_Exception, 'N') = 'Y'

		DECLARE @MusicScheduleTransactionCode BIGINT = 0, @BV_Schedule_Transaction_Code BIGINT = 0
		SELECT TOP 1 @MusicScheduleTransactionCode = Music_Schedule_Transaction_Code, @BV_Schedule_Transaction_Code = BV_Schedule_Transaction_Code
		FROM #TempMusicScheduleTransactionCodes WHERE Is_Processed = 'N'
		WHILE(@MusicScheduleTransactionCode > 0)
		BEGIN
			/*START : Implementation of Code */
			EXEC USP_Music_Schedule_Process
			@TitleCode = 0, 
			@EpisodeNo = 0, 
			@BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code, 
			@MusicScheduleTransactionCode = @MusicScheduleTransactionCode,
			@CallFrom= 'AR'
			/*END : Implementation of Code */

			UPDATE #TempMusicScheduleTransactionCodes SET Is_Processed = 'Y' 
			WHERE Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode AND Is_Processed = 'N' 

			SELECT @MusicScheduleTransactionCode = 0, @BV_Schedule_Transaction_Code = 0
			SELECT TOP 1 @MusicScheduleTransactionCode = Music_Schedule_Transaction_Code, @BV_Schedule_Transaction_Code = BV_Schedule_Transaction_Code
			FROM #TempMusicScheduleTransactionCodes WHERE Is_Processed = 'N'
		END
		IF OBJECT_ID('tempdb..#TempMusicScheduleTransactionCodes') IS NOT NULL DROP TABLE #TempMusicScheduleTransactionCodes
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Music_Schedule_Exception_AutoResolver]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END