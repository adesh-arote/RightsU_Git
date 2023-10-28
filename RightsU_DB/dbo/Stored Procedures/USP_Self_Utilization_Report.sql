CREATE PROCEDURE [dbo].[USP_Self_Utilization_Report]( 
	@Title_Name NVARCHAR(MAX), 
	@ModeOfAcquisition VARCHAR(MAX)
)
As
BEGIN

	SET NOCOUNT ON
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Self_Utilization_Report]', 'Step 1', 0, 'Started Procedure', 0, ''   
	 --DECLARE
		--@Title_Name NVARCHAR(100), 
		--@ModeOfAcquisition VARCHAR(100)

		SELECT DISTINCT
			T.Title_Name, 
			AD.Agreement_No, 
			R.Role_Name,
			BU.Business_Unit_Name,
			pg.Promoter_Group_Name,
			pr.Promoter_Remark_Desc,
			CONVERT(VARCHAR(12),ADR.Actual_Right_Start_Date,103) AS Rights_Start_Date, 
			CONVERT(VARCHAR(12),ADR.Actual_Right_End_Date,103) AS Rights_End_Date  
		FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Business_Unit BU  (NOLOCK) ON BU.Business_Unit_Code = AD.Business_Unit_Code
			INNER JOIN ROLE R (NOLOCK) ON AD.Role_Code =R.Role_Code
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN Title T (NOLOCK) ON ADRT.Title_Code = T.title_code
			INNER JOIN Acq_Deal_Rights_Promoter adrp ON ADR.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Promoter_Group adrpg ON adrp.Acq_Deal_Rights_Promoter_Code = adrpg.Acq_Deal_Rights_Promoter_Code
			INNER JOIN Acq_Deal_Rights_Promoter_Remarks adrpr ON adrp.Acq_Deal_Rights_Promoter_Code = adrpr.Acq_Deal_Rights_Promoter_Code
			INNER JOIN Promoter_Group pg ON pg.Promoter_Group_Code = adrpg.Promoter_Group_Code
			INNER JOIN Promoter_Remarks pr ON pr.Promoter_Remarks_Code = adrpr.Promoter_Remarks_Code
		WHERE (@ModeOfAcquisition = '' OR AD.Role_Code IN (select number from fn_Split_withdelemiter(@ModeOfAcquisition,',')))
			AND (@Title_Name = '' OR ADRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,',')))

	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Self_Utilization_Report]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''

END