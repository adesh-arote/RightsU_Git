CREATE PROCEDURE [dbo].[USP_GetContentRestrictionRemarks]
(
	@TitleContentCode BIGINT,
	@MusicTitleCodes VARCHAR(MAX)
)
AS
/*==============================================
Author:			Abhaysingh N. Rajpurohit
Create date:	19 Sep, 2016
Description:	List for Restriction Remarks
===============================================*/
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentRestrictionRemarks]', 'Step 1', 0, 'Started Procedure', 0, '' 
	
		SET FMTONLY OFF

		--DECLARE
		--@AcqDealMovieContentCode BIGINT = 120350,
		--@MusicTitleCodes VARCHAR(MAX) = '1,3091,3096,3095,3093,3089'

		IF(OBJECT_ID('TEMPDB..#tempRestrictionRemarks') IS NOT NULL)
			DROP TABLE #tempRestrictionRemarks

		CREATE TABLE #tempRestrictionRemarks
		(
			Music_Title_Code INT,
			Music_Title_Name NVARCHAR(2000),
			Restriction_Remarks NVARCHAR(MAX)
		)

		IF(OBJECT_ID('TEMPDB..#tempMusicTitles') IS NOT NULL)
			DROP TABLE #tempMusicTitles

		SELECT number AS Music_Title_Code INTO #tempMusicTitles FROM DBO.fn_Split_withdelemiter(@MusicTitleCodes, ',')

		IF(OBJECT_ID('TEMPDB..#tempScheduleDate') IS NOT NULL)
			DROP TABLE #tempScheduleDate

		SELECT CONVERT(DATETIME, BST.Schedule_Item_Log_Date, 121) AS Schedule_Date INTO #tempScheduleDate FROM Title_Content TC (NOLOCK)
		INNER JOIN Title_Content_Mapping TCM (NOLOCK) ON TCM.Title_Content_Code = TC.Title_Content_Code
		INNER JOIN BV_Schedule_Transaction BST (NOLOCK) ON BST.Deal_Movie_Code = TCM.Acq_Deal_Movie_Code AND  CAST(TC.Episode_No AS VARCHAR) = ISNULL(BST.Program_Episode_Number, '0')
		WHERE TC.Title_Content_Code = @TitleContentCode

		IF EXISTS (SELECT * FROM #tempScheduleDate)
		BEGIN
			INSERT INTO #tempRestrictionRemarks(Music_Title_Code, Restriction_Remarks)
			SELECT DISTINCT TMT.Music_Title_Code, ADR.Restriction_Remarks FROM #tempMusicTitles TMT
			INNER JOIN Music_Title_Label MTL (NOLOCK) ON TMT.Music_Title_Code = MTL.Music_Title_Code AND MTL.Effective_To IS NULL
			INNER JOIN Title T (NOLOCK) ON T.Music_Label_Code = MTL.Music_Label_Code
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Title_Code = T.Title_Code
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code
			INNER JOIN #tempScheduleDate SD ON (SD.Schedule_Date BETWEEN ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) OR ADR.Right_Type = 'U'
			WHERE ISNULL(ADR.Restriction_Remarks, '') != ''

			UPDATE TRR SET TRR.Music_Title_Name = MT.Music_Title_Name FROM #tempRestrictionRemarks TRR
			INNER JOIN Music_Title MT (NOLOCK) ON TRR.Music_Title_Code = MT.Music_Title_Code
		END

		SELECT DISTINCT Music_Title_Code, Music_Title_Name, Restriction_Remarks FROM #tempRestrictionRemarks
		ORDER BY Music_Title_Name, Restriction_Remarks

		IF OBJECT_ID('tempdb..#tempMusicTitles') IS NOT NULL DROP TABLE #tempMusicTitles
		IF OBJECT_ID('tempdb..#tempRestrictionRemarks') IS NOT NULL DROP TABLE #tempRestrictionRemarks
		IF OBJECT_ID('tempdb..#tempScheduleDate') IS NOT NULL DROP TABLE #tempScheduleDate
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentRestrictionRemarks]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END