CREATE PROCEDURE [dbo].[USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode]
	@Deal_Movie_Rights_Code int
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode]', 'Step 1', 0, 'Started Procedure', 0, '' 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	   Select Min(CAST(Schedule_Item_Log_Date  as Date)) as Start_Date,Max(CAST(Schedule_Item_Log_Date  as Date)) as End_Date from BV_Schedule_Transaction (NOLOCK)
	   Where Deal_Movie_Rights_Code = @Deal_Movie_Rights_Code
  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END
