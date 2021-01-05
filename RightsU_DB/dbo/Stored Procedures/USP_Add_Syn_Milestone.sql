
--|=========================================================================================
--| Author:		  RUSHABH V. GOHIL
--| Date Created: 25-Aug-2015
--| Description:  Get Title Name & Milestone name from combination of Rights and Milestone 
--|=========================================================================================

create PROCEDURE [dbo].[USP_Add_Syn_Milestone](@Syn_Deal_Code INT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SD.Agreement_No, T.Title_Name, T.Title_Code, MT.Milestone_Type_Name, 
		SDR.Syn_Deal_Rights_Code , SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type,
		SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date
	FROM Syn_Deal SD
	INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Code = SD.Syn_Deal_Code 
	INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
	INNER JOIN Milestone_Type MT ON MT.Milestone_Type_Code = SDR.Milestone_Type_Code
	INNER JOIN Title T ON T.Title_Code = SDRT.Title_Code
	WHERE SD.Deal_Workflow_Status = 'A' AND SD.Syn_Deal_Code = @Syn_Deal_Code AND ISNULL(MT.Is_Automated,'N') = 'N' 
		AND SDR.Right_Start_Date IS NULL AND SDR.Right_End_Date IS NULL
END

/*
EXEC [USP_Add_Syn_Milestone] 140, 'N'
*/
