CREATE PROCEDURE [dbo].[USP_List_Syn_Deal_Status]
(
	@Syn_Deal_Code INT,
	@Debug Char(1) = 'N'
)
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 16 FEB 2014
-- Description: Get List Of Pending Syn. Deal Status Like (Rights,Pushback,Ancillary,Run Defin.And Cost Pending)
-- =============================================
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Syn_Deal_Status]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET FMTONLY OFF
		SET NOCOUNT ON;

		--DECLARE @Syn_Deal_Code INT = 214, @Debug Char(1) = 'N'

		IF OBJECT_ID('tempdb..#Deal_Status') IS NOT NULL
			DROP TABLE #Deal_Status
		CREATE TABLE  #Deal_Status
		(
			Deal_Type_Code INT,
			Title_Code INT,
			Title_Name NVARCHAR(200),
			Episode_From INT,
			Episode_To INT,
			Is_Rights_Added VARCHAR(3),
			Is_Pushback_Added VARCHAR(3),
			Is_Run_Added VARCHAR(3),
			Is_Ancillary_Added VARCHAR(3),
			Is_Cost_Added VARCHAR(3)
		)
		DECLARE @Deal_Complete_Flag  Varchar(15) =''
		SELECT  @Deal_Complete_Flag = ','+Deal_Complete_Flag+',' FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @Syn_Deal_Code

		IF(@debug='D')
			SELECT  @Deal_Complete_Flag as Deal_Complete_Flag

		
		INSERT INTO #Deal_Status
		SELECT AD.Deal_Type_Code, ADM.Title_Code,
		DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADM.Episode_From, ADM.Episode_End_To) AS Title_Name, 
		ADM.Episode_From, ADM.Episode_End_To, 'No' Is_Rights_Added,'No' Is_Pushback_Added,'No' Is_Run_Added ,'No' Is_Ancillary_Added,'No' Is_Cost_Added 
		FROM Syn_Deal AD (NOLOCK)
		INNER JOIN  Syn_Deal_Movie ADM  (NOLOCK) ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code
		INNER JOIN  Title T (NOLOCK) ON ADM.Title_Code = T.Title_Code
		WHERE AD.Syn_Deal_Code = @Syn_Deal_Code

		IF(@debug='D')
			SELECT * FROM #Deal_Status

		IF CHARINDEX('R',@Deal_Complete_Flag) >0
		BEGIN
			UPDATE #Deal_Status SET Is_Rights_Added = 'Yes'
			FROM Syn_Deal_Movie ADM  
			INNER JOIN Syn_Deal_Rights ADR ON ADM.Syn_Deal_Code = ADR.Syn_Deal_Code
			INNER JOIN Syn_Deal_Rights_Title ADRT  ON ADR.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code
			INNER JOIN #Deal_Status DS  ON DS.Title_Code = ADRT.Title_Code
			WHERE ADR.Syn_Deal_Code = @Syn_Deal_Code AND DS.Title_Code = ADRT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADRT.Episode_From, 0) 
			AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADRT.Episode_To, 0) AND ISNULL(ADR.Is_Pushback,'N') = 'N'
		END

		IF CHARINDEX('A',@Deal_Complete_Flag) >0
			UPDATE #Deal_Status SET Is_Ancillary_Added = 'Yes'
			FROM Syn_Deal_Movie ADM  
			INNER JOIN Syn_Deal_Ancillary ADA ON ADM.Syn_Deal_Code = ADA.Syn_Deal_Code
			INNER JOIN Syn_Deal_Ancillary_Title ADAT ON ADA.Syn_Deal_Ancillary_Code = ADAT.Syn_Deal_Ancillary_Code
			INNER JOIN #Deal_Status DS ON DS.Title_Code = ADAT.Title_Code
			WHERE ADM.Syn_Deal_Code = @Syn_Deal_Code AND DS.Title_Code = ADAT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADAT.Episode_From, 0) 
			AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADAT.Episode_To, 0)

		IF CHARINDEX('C',@Deal_Complete_Flag) >0
			UPDATE #Deal_Status SET Is_Cost_Added = 'Yes'
			FROM Syn_Deal_Movie ADM 
			INNER JOIN Syn_Deal_Revenue ADC ON ADM.Syn_Deal_Code = ADC.Syn_Deal_Code
			INNER JOIN Syn_Deal_Revenue_Title ADCT ON ADC.Syn_Deal_Revenue_Code = ADCT.Syn_Deal_Revenue_Code
			INNER JOIN #Deal_Status DS ON DS.Title_Code = ADCT.Title_Code
			WHERE ADM.Syn_Deal_Code = @Syn_Deal_Code AND DS.Title_Code = ADCT.Title_Code AND ISNULL(DS.Episode_From, 0) =  ISNULL(ADCT.Episode_From, 0) 
			AND ISNULL(DS.Episode_To, 0) =  ISNULL(ADCT.Episode_To, 0)

		SELECT Title_Code ,Title_Name,Is_Rights_Added,Is_Pushback_Added,Is_Run_Added,Is_Ancillary_Added,Is_Cost_Added 
		FROM #Deal_Status ORDER BY Title_Name
	
		--DROP TABLE #Deal_Status

		IF OBJECT_ID('tempdb..#Deal_Status') IS NOT NULL DROP TABLE #Deal_Status
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Syn_Deal_Status]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END