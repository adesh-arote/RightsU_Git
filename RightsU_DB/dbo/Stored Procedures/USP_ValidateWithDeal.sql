CREATE PROCEDURE [dbo].[USP_ValidateWithDeal] 
@Territory_Code varchar(2000),
@Country_Code  varchar(2000)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel' 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_ValidateWithDeal]', 'Step 1', 0, 'Started Procedure', 0, ''
		Declare @query as nvarchar(max)
		set @query =
		'select * from acq_deal_rights_territory (NOLOCK) where Acq_Deal_Rights_Code is not Null
		AND Territory_Code in('+@Territory_Code+')
		AND Country_Code in('+@Country_Code+')
		UNION
		select * from acq_deal_pushback_territory (NOLOCK) where acq_deal_pushback_Code is not Null
		AND Territory_Code in('+@Territory_Code+')
		AND Country_Code in('+@Country_Code+')'
		EXECUTE sp_executesql @query

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_ValidateWithDeal]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
