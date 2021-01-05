CREATE PROCEDURE [dbo].[USPValidateMHRequestConsumption]
	--DECLARE
	@MHRequestCode INT-- = 413
AS
--Created By : Anchal Sikarwar
--Created On : 19 June 2018
BEGIN
	IF OBJECT_ID('tempdb..#MHRequestTemp') IS NOT NULL
		DROP TABLE #MHRequestTemp

	IF OBJECT_ID('tempdb..#MusicDealTemp') IS NOT NULL
		DROP TABLE #MusicDealTemp

	CREATE TABLE #MHRequestTemp
	(
		MHRequestDetailsCode INT,
		IsValid CHAR(1),
		[Message] NVARCHAR(50)
	)

	INSERT INTO #MHRequestTemp(MHRequestDetailsCode,IsValid,Message)
	select DISTINCT MRD.MHRequestDetailsCode, 'Y', '' 
	from MHRequest MR
    INNER JOIN MHRequestDetails MRD ON 
	MR.MHRequestCode = MRD.MHRequestCode
	AND MR.MHRequestTypeCode=1
	AND MR.MHRequestCode = @MHRequestCode
	AND ISNULL(MRD.IsApprove,'P') = 'P'

	select DISTINCT MD.Music_Deal_Code, MD.Link_Show_Type, MD.Music_Label_Code, MRD.MHRequestDetailsCode, MR.TitleCode, MD.Rights_Start_Date, MD.Rights_End_Date, 
		MR.TelecastFrom, MR.TelecastTo, MD.No_Of_Songs, MR.ChannelCode, MDC.Defined_Runs,MD.Deal_Workflow_Status--, ISNULL(MDC.Scheduled_Runs,0) + ISNULL(MDC.RequestedSchedule,0) Scheduled_Runs
	INTO #MusicDealTemp 
	from MHRequest MR
    INNER JOIN MHRequestDetails MRD ON MR.MHRequestCode = MRD.MHRequestCode AND ISNULL(MRD.IsApprove,'P') = 'P'
    INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MR.MHRequestTypeCode=1 AND MR.MHRequestCode = @MHRequestCode
    INNER JOIN Music_Deal MD ON MD.Music_Label_Code = MTL.Music_Label_Code
	INNER JOIN Music_Deal_Channel MDC ON MD.Music_Deal_Code = MDC.Music_Deal_Code AND MDC.Channel_Code = MR.ChannelCode

	
	--Deal not found
	BEGIN
		Update #MHRequestTemp SET IsValid = 'N', Message = 'Music Deal not found' WHERE MHRequestDetailsCode NOT IN (SELECT MHRequestDetailsCode FROM #MusicDealTemp )

	END
	BEGIN
		Update #MHRequestTemp SET IsValid = 'N', Message = 'Music Deal not Approved' WHERE MHRequestDetailsCode NOT IN (SELECT MHRequestDetailsCode FROM #MusicDealTemp WHERE Deal_Workflow_Status = 'A')
	END
	--Invalid Show
	BEGIN
		Update #MHRequestTemp SET IsValid = 'N', [Message] = 'Invalid Show' WHERE MHRequestDetailsCode NOT IN (SELECT MHRequestDetailsCode from #MusicDealTemp T
		LEFT JOIN Music_Deal_LinkShow MDL ON MDL.Music_Deal_Code = T.Music_Deal_Code
		AND ((T.Link_Show_Type = 'SP' AND MDL.Title_Code = T.TitleCode) OR (T.Link_Show_Type = 'AF' AND T.TitleCode IN(select Title_Code from Title Where Deal_Type_Code=18))
		OR (T.Link_Show_Type = 'AS') OR (T.Link_Show_Type = 'AN' AND T.TitleCode IN(select Title_Code from Title Where Deal_Type_Code != 18))
		OR (T.Link_Show_Type = 'AE' AND T.TitleCode IN(select Title_Code from Title Where Deal_Type_Code=22))
		)
		)
		AND IsValid != 'N'
	END

	--Scheduled Outside Rights Period
	BEGIN
		Update #MHRequestTemp  SET IsValid = 'N', [Message] = 'Scheduled Outside Rights Period' 
		WHERE MHRequestDetailsCode NOT IN 
		(
			SELECT MHRequestDetailsCode from #MusicDealTemp T WHERE 
			((T.TelecastFrom BETWEEN T.Rights_Start_Date AND T.Rights_End_Date) AND (T.TelecastTo BETWEEN T.Rights_Start_Date AND T.Rights_End_Date))
		)
		AND  IsValid != 'N'
	END

	--Exceeded Number of Music tracks

	Update MRD SET MRD.IsValid = T.IsValid,MRD.ValidationMessage=T.Message FROM #MHRequestTemp T INNER JOIN MHRequestDetails MRD ON T.MHRequestDetailsCode = MRD.MHRequestDetailsCode

	select * from #MHRequestTemp

	IF OBJECT_ID('tempdb..#MHRequestTemp') IS NOT NULL DROP TABLE #MHRequestTemp
	IF OBJECT_ID('tempdb..#MusicDealTemp') IS NOT NULL DROP TABLE #MusicDealTemp
END
--go
--CREATE PROCEDURE [dbo].[USPValidateMHRequestConsumption]
--	--DECLARE
--	@MHRequestCode INT 
--AS
----Created By : Anchal Sikarwar
----Created On : 19 June 2018
--BEGIN
--DECLARE @MHRequestDetailsCode INT, @IsValid CHAR(1), @Message NVARCHAR(50)

--		SELECT @MHRequestDetailsCode MHRequestDetailsCode,
--		@IsValid IsValid ,
--		@Message [Message] 
	
--END

----DROP PROC USPValidateConsumption