CREATE PROCEDURE [dbo].[USPITGetDealTypes]
@BusinessVerticalCodes VARCHAR(30)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetDealTypes]', 'Step 1', 0, 'Started Procedure', 0, ''
		SELECT DISTINCT DT.Deal_Type_Code, DT.Deal_Type_Name FROM deal_type DT (NOLOCK)
		INNER JOIN attrib_deal_type ADT
		(NOLOCK) ON ADT.deal_type_code = DT.deal_type_code
		WHERE ADT.attrib_group_code IN (SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@BusinessVerticalCodes, ''), ',') WHERE number <> '')
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetDealTypes]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
