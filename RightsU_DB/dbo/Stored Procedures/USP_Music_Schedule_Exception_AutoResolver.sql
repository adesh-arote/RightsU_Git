CREATE PROC USP_Music_Schedule_Exception_AutoResolver
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	25 November 2016
Description:	Auto Resolve Music Schedule Exception, If they are Valid
=======================================================================================================================================*/
BEGIN
	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransactionCodes') IS NOT NULL)
			DROP TABLE #TempMusicScheduleTransactionCodes


	SELECT Music_Schedule_Transaction_Code, BV_Schedule_Transaction_Code, 'N' AS Is_Processed
	INTO #TempMusicScheduleTransactionCodes
	FROM Music_Schedule_Transaction WHERE ISNULL(Is_Exception, 'N') = 'Y'

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
END