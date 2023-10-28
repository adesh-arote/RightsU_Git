CREATE PROCEDURE [dbo].[USP_Check_HoldBack]
(
	@Title_Code BIGINT
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_HoldBack]', 'Step 1', 0, 'Started Procedure', 0, ''
		SELECT DISTINCT A.Is_HoldBack 
		FROM 
		(
			SELECT ISNULL(Holdback_On_Platform_Code,0) Is_HoldBack 
			FROM Acq_Deal_Rights_Title ADRT (NOLOCK)
			INNER JOIN Acq_Deal_Rights_Holdback ADRH (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code
			WHERE ADRT.Title_Code = @Title_Code AND ISNULL(Holdback_On_Platform_Code,0) != 0 AND ADRH.Holdback_Type = 'R'
			UNION
			SELECT ISNULL(TRP.Platform_Code,0) 
			FROM Title_Release TR (NOLOCK) INNER JOIN Title_Release_Platforms TRP (NOLOCK) ON TR.Title_Release_Code = TRP.Title_Release_Code
			WHERE TR.Title_Code = @Title_Code
		) A
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_HoldBack]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
