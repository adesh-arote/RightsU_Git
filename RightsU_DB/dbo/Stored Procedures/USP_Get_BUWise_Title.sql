CREATE PROCEDURE [dbo].[USP_Get_BUWise_Title]
	@BuCode INT,
	@SearchKey NVARCHAR(100)
AS
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_BUWise_Title]', 'Step 1', 0, 'Started Procedure', 0, ''
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel' 
		SELECT DISTINCT T.Title_Code, T.Title_Name FROM Acq_Deal AD (NOLOCK)
		INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Business_Unit_Code = @BuCode AND CCR.Schedule_Runs > 0
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = CCR.Title_Code	AND UPPER(T.Title_Name) LIKE '%' + UPPER(@SearchKey) + '%'
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_BUWise_Title]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END