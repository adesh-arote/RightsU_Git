﻿CREATE PROC [dbo].[USPMHGetMusicLabel](@ChannelCode INT, @TitleCode INT)
AS
BEGIN

	IF(@ChannelCode = 0 OR @TitleCode = 0)
	BEGIN

		SELECT DISTINCT ml.Music_Label_Code AS MusicLabelCode, ml.Music_Label_Name AS MusicLabelName--, Link_Show_Type 
		From Music_Label ml WHERE ml.Is_Active = 'Y'

	END
	ELSE
	BEGIN

		CREATE TABLE #TmpDT
		(
			Acq_Deal_Code INT,
			Deal_Type_Code INT
		)

		INSERT INTO #TmpDT(Acq_Deal_Code, Deal_Type_Code)
		SELECT DISTINCT AD.Acq_Deal_Code, Deal_Type_Code FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Run ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR.Acq_Deal_Code IN (SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run_Channel ADRC WHERE ADRC.Channel_Code = @ChannelCode)
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND Title_Code = @TitleCode
		WHERE Deal_Type_Code IN(11,13,22)

		SELECT DISTINCT ml.Music_Label_Code AS MusicLabelCode, ml.Music_Label_Name AS MusicLabelName--, Link_Show_Type 
		FROM Music_Deal md
		INNER JOIN Music_Deal_Channel mdc ON md.Music_Deal_Code = mdc.Music_Deal_Code AND Channel_Code = @ChannelCode
		INNER JOIN Music_Label ml ON md.Music_Label_Code = ml.Music_Label_Code
		WHERE
		(
			Link_Show_Type = 'AE' AND EXISTS
			(
				SELECT TOP 1 * FROM #TmpDT WHERE Deal_Type_Code = 22
			)
		)
		OR
		(
			Link_Show_Type = 'AF' AND EXISTS
			(
				SELECT TOP 1 * FROM #TmpDT WHERE Deal_Type_Code IN (11,13)
			)
		)
		OR
		(
			Link_Show_Type = 'SP' AND MD.Music_Deal_Code IN
			(
				SELECT Music_Deal_Code FROM Music_Deal_LinkShow WHERE Title_Code = @TitleCode
			)
		)
		OR
		Link_Show_Type = 'AS'

		--DROP TABLE #TmpDT

	END
	IF OBJECT_ID('tempdb..#TmpDT') IS NOT NULL DROP TABLE #TmpDT
END