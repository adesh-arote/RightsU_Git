CREATE PROCEDURE [dbo].[USPAL_GetReCommendationList]
AS
BEGIN
/*---------------------------
Author          : Sachin S. Shelar
Created On      : 30/Mar/2023
Description     : Returns the List for Recommendation
Last Modified On: 19/Apr/2023
Last Change     : Added New output column IsMinimum, Correction in Proposal_CY column name			
---------------------------*/


	SET FMTONLY OFF 
	SET NOCOUNT ON
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetReCommendationList]', 'Step 1', 0, 'Started Procedure', 0, ''

	IF(OBJECT_ID('tempdb..#TempReccomendationListTbl') IS NOT NULL) DROP TABLE #TempReccomendationListTbl

	CREATE table #TempReccomendationListTbl(
	AL_Proposal_Code INT,
	AL_Recommendation_Code INT,
	Proposal_No VARCHAR(1000),
	Refresh_Cycle_No INT,
	Cycle VARCHAR(50),
	Vendor_Code INT,
	Vendor_Name VARCHAR(1000),
	Proposal_CY VARCHAR(1000),
	IsMinimum VARCHAR(10)
	)

	insert Into #TempReccomendationListTbl
	SELECT ap.AL_Proposal_Code, ar.AL_Recommendation_Code, ap.Proposal_No, ar.Refresh_Cycle_No, (format(ar.Start_Date, 'MMy') + ' - ' + format(ar.End_Date, 'MMy')) as Cycle,
		v.Vendor_Code, v.Vendor_Name, ap.Proposal_No + ' - CY ' + cast((ar.Refresh_Cycle_No) as varchar ) as 'Proposal - CY', 'N' as IsMinimum
	FROM AL_Proposal ap 
	INNER JOIN AL_Recommendation ar ON ap.AL_Proposal_Code = ar.AL_Proposal_Code
	INNER JOIN Vendor v ON v.Vendor_Code = ap.Vendor_Code
	WHERE ar.AL_Recommendation_Code NOT IN(SELECT AL_Recommendation_Code FROM AL_Booking_Sheet) and ar.Finally_Closed = 'Y'

	IF(OBJECT_ID('tempdb..#tempProposalNo') IS NOT NULL) DROP TABLE #tempProposalNo

	CREATE TABLE #tempProposalNo(
		Id INT IDENTITY (1,1) NOT NULL,
		Proposal_No VARCHAR(1000)
	)

	insert into #tempProposalNo
	select  distinct Proposal_No from #TempReccomendationListTbl

	declare @Row int = 1, @minValue int;
	WHILE(@ROW <= (select COUNT(*) from #tempProposalNo))
	begin
		set @minValue = (select Min(Refresh_Cycle_No ) from #TempReccomendationListTbl where Proposal_No = (select Proposal_No from #tempProposalNo where Id = @Row))
		UPDATE #TempReccomendationListTbl set IsMinimum = 'Y' where Proposal_No = (select Proposal_No from #tempProposalNo where Id = @Row) and Refresh_Cycle_No = @minValue
		set @Row = @Row + 1
	end

	select * from #TempReccomendationListTbl

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetReCommendationList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END