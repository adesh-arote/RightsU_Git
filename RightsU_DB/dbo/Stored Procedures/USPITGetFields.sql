CREATE PROCEDURE [dbo].[USPITGetFields]
@ViewName NVARCHAR(50)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetFields]', 'Step 1', 0, 'Started Procedure', 0, ''
		Select  Column_Code,Display_Name,View_Name,List_Source,Lookup_Column,Display_Column,WhCondition,Valued_As--,Display_Order 
		from Report_Column_Setup  (NOLOCK)
		where Display_Type = 'CR' --AND Valued_As = 1 
		AND IsPartofSelectOnly IN ('N','B') AND View_Name = CASE WHEN @ViewName = 'Acquisition' THEN 'VW_ACQ_DEALS' ELSE 'VW_SYN_DEALS' END --AND Valued_AS = 3
		ORDER BY Display_Order
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetFields]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
