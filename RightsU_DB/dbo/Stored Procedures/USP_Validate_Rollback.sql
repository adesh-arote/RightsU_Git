CREATE PROCEDURE USP_Validate_Rollback
(
	@Deal_Code INT,
	@Type CHAR(1)
)
AS
/*==============================================
Author:			Abhaysingh N. Rajpurohit
Create date:	14 Feb, 2017
Description:	Validate Deal for Rollback
===============================================*/
BEGIN
	--DECLARE @Deal_Code INT = 13505, @Type CHAR(1) = 'A'
	DECLARE @ErrorMessage NVARCHAR(MAX) = '', @Deal_Type_Code INT = 0

	IF(@Type = 'A')
	BEGIN

		DECLARE @dealTypeCodeForAllowAssignMusic VARCHAR(150) = '' ,  @User_Code INT = 0
		SELECT TOP 1 @Deal_Type_Code = Deal_Type_Code, @User_Code = Inserted_By FROM Acq_Deal WHERE Acq_Deal_Code = @Deal_Code
		SELECT TOP 1 @dealTypeCodeForAllowAssignMusic = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DealTypeCodeFor_AllowAssignMusic'

		IF(@Deal_Type_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@dealTypeCodeForAllowAssignMusic, ',')))
		BEGIN
			IF(OBJECT_ID('TEMPDB..#PreviousVersionData') IS NOT NULL )
				DROP TABLE #PreviousVersionData

			IF(OBJECT_ID('TEMPDB..#CurrentVersionData') IS NOT NULL )
				DROP TABLE #CurrentVersionData

			IF(OBJECT_ID('TEMPDB..#LinkedContent') IS NOT NULL )
				DROP TABLE #LinkedContent

			SELECT DISTINCT TC.Title_Content_Code INTO #CurrentVersionData FROM Acq_Deal AD
			INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN Title_Content TC ON TC.Title_Code = ADM.Title_Code AND TC.Episode_No BETWEEN ADM.Episode_Starts_From AND ADM.Episode_End_To
			INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
			WHERE AD.Acq_Deal_Code = @Deal_Code

			IF EXISTS (SELECT * FROM #CurrentVersionData)
			BEGIN
				SELECT DISTINCT TC.Title_Content_Code INTO #PreviousVersionData FROM AT_Acq_Deal atAD
				INNER JOIN AT_Acq_Deal_Movie atADM ON atADM.AT_Acq_Deal_Code = atAD.AT_Acq_Deal_Code
				INNER JOIN Title_Content TC ON TC.Title_Code = atADM.Title_Code AND TC.Episode_No BETWEEN atADM.Episode_Starts_From AND atADM.Episode_End_To
				WHERE atAD.Acq_Deal_Code = @Deal_Code

				SELECT Title_Content_Code INTO #LinkedContent FROM #CurrentVersionData 
				WHERE Title_Content_Code NOT IN (SELECT Title_Content_Code FROM #PreviousVersionData)

				IF EXISTS (SELECT * FROM #LinkedContent)
				BEGIN
					IF NOT EXISTS (
						SELECT * FROM Title_Content_Mapping TCM
						INNER JOIN #LinkedContent LC ON LC.Title_Content_Code = TCM.Title_Content_Code
						INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TCM.Acq_Deal_Movie_Code AND ADM.Acq_Deal_Code <> @Deal_Code
					)
					BEGIN
						SET @ErrorMessage =  'Cannot rollback deal, music already assigned to episode'
					END
				END
			END
		END
	END
	IF(@ErrorMessage = '' AND @Type = 'A')
	BEGIN
		INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
		VALUES (@Deal_Code ,30, 'N', 'R',GETDATE() ,NULL,NULL,@User_Code)
	END
	ELSE IF(@ErrorMessage = '' AND @Type = 'S')
	BEGIN
		INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
		VALUES (@Deal_Code ,35, 'N', 'R',GETDATE() ,NULL,NULL,@User_Code)
	END
	SELECT @ErrorMessage AS ErrorMessage

	IF OBJECT_ID('tempdb..#CurrentVersionData') IS NOT NULL DROP TABLE #CurrentVersionData
	IF OBJECT_ID('tempdb..#LinkedContent') IS NOT NULL DROP TABLE #LinkedContent
	IF OBJECT_ID('tempdb..#PreviousVersionData') IS NOT NULL DROP TABLE #PreviousVersionData
END