CREATE Procedure [dbo].[USPITGetStylesData]
@ViewName NVARCHAR(50)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetStylesData]', 'Step 1', 0, 'Started Procedure', 0, ''
		Select ValidOpList AS GroupName,Display_Name AS [Key], Column_Code AS [Value] 
		FROM Report_Column_Setup (NOLOCK) where Display_Type = 'CR'
		AND IsPartofSelectonly IN ('Y','B') 
		AND View_Name =  CASE WHEN @ViewName = 'Acquisition' Then 'VW_ACQ_DEALS' ELSE 'VW_SYN_DEALS' END
		AND ValidOpList IS NOT NULL
		Order by 1 
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetStylesData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
