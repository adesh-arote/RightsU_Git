CREATE PROCEDURE [dbo].[Avail_GetSyndicationDealRightsList]
(    
 @Title_Code INT
)     
AS       
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetSyndicationDealRightsList]', 'Step 1', 0, 'Started Procedure', 0, ''

	SELECT  Distinct top 1 A.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Title A (NOLOCK) -- WHERE Syn_Deal_Rights_Code IN
	INNER JOIN
	(
	SELECT SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR (NOLOCK)
				INNER JOIN Syn_Deal SD (NOLOCK) on SD.Syn_Deal_Code = SDR.Syn_Deal_Code
				WHERE 
				ISNULL(SDR.Is_Tentative, 'N') = 'N'
				AND ISNULL(SDR.Right_Status, '') <> 'E'
				--AND ISNULL(SDR.PA_Right_Type, '') = 'PR'
				AND SDR.Actual_Right_Start_Date IS NOT NULL
				AND (SDR.Actual_Right_End_Date IS NULL OR CAST(SDR.Actual_Right_End_Date AS DATE) > CAST(GetDate() AS DATE)) -- to filter expired syndication deals
				) B
				ON A.Syn_Deal_Rights_Code = B.Syn_Deal_Rights_Code
				AND Title_Code = @Title_Code
	Where A.Title_Code = @Title_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetSyndicationDealRightsList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END