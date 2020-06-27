CREATE PROCEDURE [dbo].[USP_List_Acq_Deal_Status]
(
	@Acq_Deal_Code INT,
	@Debug Char(1) = 'N'
)
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 11 Nov 2014
-- Description: Get List Of Pending Acq. Deal Status Like (Rights,Pushback,Ancillary,Run Defin.And Cost Pending)
-- =============================================
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON;

	--DECLARE @Acq_Deal_Code INT = 214, @Debug Char(1) = 'N'

	IF OBJECT_ID('tempdb..#Deal_Status') IS NOT NULL
		DROP TABLE #Deal_Status
	CREATE TABLE  #Deal_Status
	(
		Deal_Type_Code INT,
		Title_Code INT,
		Title_Name NVARCHAR(400),
		Episode_From INT,
		Episode_To INT,
		Is_Rights_Added VARCHAR(3),
		Is_Pushback_Added VARCHAR(3),
		Is_Run_Added VARCHAR(3),
		Is_Ancillary_Added VARCHAR(3),
		Is_Cost_Added VARCHAR(3),
		Is_Budget_Added VARCHAR(3)
	)
	DECLARE @Deal_Complete_Flag  Varchar(15) =''
	SELECT  @Deal_Complete_Flag = ','+Deal_Complete_Flag+',' FROM Acq_Deal  Where Acq_Deal_Code = @Acq_Deal_Code

	IF(@debug='D')
		SELECT  @Deal_Complete_Flag as Deal_Complete_Flag

		
	INSERT INTO #Deal_Status
	SELECT AD.Deal_Type_Code, ADM.Title_Code,
	DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name,
	ADM.Episode_Starts_From, ADM.Episode_End_To, 'No' Is_Rights_Added,'No' Is_Pushback_Added,'No' Is_Run_Added ,'No' Is_Ancillary_Added,'No' Is_Cost_Added , 'No' Is_Budget_Added 
	FROM Acq_Deal AD
	INNER JOIN  Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	INNER JOIN  Title T ON ADM.Title_Code = T.Title_Code
	WHERE AD.Acq_Deal_Code = @Acq_Deal_Code

	IF(@debug='D')
		SELECT * FROM #Deal_Status

	IF CHARINDEX('R',@Deal_Complete_Flag) >0
	BEGIN
		UPDATE #Deal_Status SET Is_Rights_Added = 'Yes'
		FROM Acq_Deal_Movie ADM 
		INNER JOIN Acq_Deal_Rights ADR ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		INNER JOIN #Deal_Status DS ON DS.Title_Code = ADRT.Title_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND DS.Title_Code = ADRT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADRT.Episode_From, 0) 
		AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADRT.Episode_To, 0)
	END

	IF CHARINDEX('P',@Deal_Complete_Flag) >0
		UPDATE #Deal_Status SET Is_Pushback_Added = 'Yes'
		FROM Acq_Deal_Movie ADM 
		INNER JOIN Acq_Deal_Pushback ADP ON ADM.Acq_Deal_Code = ADP.Acq_Deal_Code
		INNER JOIN Acq_Deal_Pushback_Title ADPT ON ADP.Acq_Deal_Pushback_Code = ADPT.Acq_Deal_Pushback_Code
		INNER JOIN #Deal_Status DS ON DS.Title_Code = ADPT.Title_Code
		Where ADM.Acq_Deal_Code = @Acq_Deal_Code AND DS.Title_Code = ADPT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADPT.Episode_From, 0) 
		AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADPT.Episode_To, 0)

	IF CHARINDEX('D',@Deal_Complete_Flag) >0
		UPDATE #Deal_Status SET Is_Ancillary_Added = 'Yes'
		FROM Acq_Deal_Movie ADM 
		INNER JOIN Acq_Deal_Run ADR ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
		INNER JOIN #Deal_Status DS ON DS.Title_Code = ADRT.Title_Code
		Where ADM.Acq_Deal_Code = @Acq_Deal_Code AND DS.Title_Code = ADRT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADRT.Episode_From, 0) 
		AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADRT.Episode_To, 0)

	IF CHARINDEX('A',@Deal_Complete_Flag) >0
		UPDATE #Deal_Status SET Is_Ancillary_Added = 'Yes'
		FROM Acq_Deal_Movie ADM 
		INNER JOIN Acq_Deal_Ancillary ADA ON ADM.Acq_Deal_Code = ADA.Acq_Deal_Code
		INNER JOIN Acq_Deal_Ancillary_Title ADAT ON ADA.Acq_Deal_Ancillary_Code = ADAT.Acq_Deal_Ancillary_Code
		INNER JOIN #Deal_Status DS ON DS.Title_Code = ADAT.Title_Code
		Where ADM.Acq_Deal_Code = @Acq_Deal_Code AND DS.Title_Code = ADAT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADAT.Episode_From, 0) 
		AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADAT.Episode_To, 0)

	IF CHARINDEX('C',@Deal_Complete_Flag) >0
		UPDATE #Deal_Status SET Is_Cost_Added = 'Yes'
		FROM Acq_Deal_Movie ADM 
		INNER JOIN Acq_Deal_Cost ADC ON ADM.Acq_Deal_Code = ADC.Acq_Deal_Code
		INNER JOIN Acq_Deal_Cost_Title ADCT ON ADC.Acq_Deal_Cost_Code = ADCT.Acq_Deal_Cost_Code
		INNER JOIN #Deal_Status DS ON DS.Title_Code = ADCT.Title_Code
		Where ADM.Acq_Deal_Code = @Acq_Deal_Code AND DS.Title_Code = ADCT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADCT.Episode_From, 0) 
		AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADCT.Episode_To, 0)

	IF CHARINDEX('B',@Deal_Complete_Flag) >0
		UPDATE #Deal_Status SET Is_Budget_Added = 'Yes'
		FROM Acq_Deal_Movie ADM 
		INNER JOIN Acq_Deal_Budget ADB ON ADM.Acq_Deal_Code = ADB.Acq_Deal_Code
		INNER JOIN #Deal_Status DS ON DS.Title_Code = ADB.Title_Code
		Where ADB.Acq_Deal_Code = @Acq_Deal_Code AND DS.Title_Code = ADB.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADB.Episode_From, 0) 
		AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADB.Episode_To, 0)

	Select Title_Code ,Title_Name,Is_Rights_Added,Is_Pushback_Added,Is_Run_Added,Is_Ancillary_Added,Is_Cost_Added ,Is_Budget_Added
	from #Deal_Status ORDER BY Title_Name
	
	DROP Table #Deal_Status
END