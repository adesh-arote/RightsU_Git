CREATE PROC [dbo].[Avail_GetAcquisitionDealRightsList]
(    
 @Title_Code INT
)     
AS       
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetAcquisitionDealRightsList]', 'Step 1', 0, 'Started Procedure', 0, ''

	SELECT Distinct A.Acq_Deal_Rights_Code AcqDealRightsCode FROM Acq_Deal_Rights_Title A (NOLOCK)
	 --WHERE Acq_Deal_Rights_Code
	  INNER JOIN
	  (
	SELECT ADR.Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights ADR (NOLOCK)
				INNER JOIN Acq_Deal AD (NOLOCK) on AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				WHERE AD.Is_Master_Deal = 'Y'
				AND IsNull(ADR.Is_Tentative, 'N') = 'N'
				AND ADR.Is_Sub_License = 'Y'
				--AND ADR.PA_Right_Type = 'PR'
				AND ADR.Actual_Right_Start_Date IS NOT NULL
				AND (ADR.Actual_Right_End_Date IS NULL OR Cast(ADR.Actual_Right_End_Date As DATE) > CAST(GetDate()As DATE)) -- to filter expired acquisition deals
				) B
				ON A.Acq_Deal_Rights_Code = B.Acq_Deal_Rights_Code AND Title_Code = @Title_Code
				WHERE A.Title_Code = @Title_Code
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetAcquisitionDealRightsList]', 'Step 2', 0, 'Procedure Execution Completed', 0, ''
END