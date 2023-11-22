CREATE PROCEDURE [dbo].[USP_Get_IPR_Dashboard_Details]
(
	@DashboardType varchar(10)='D',
	@SearchFor NVARCHAR(1000) ='',
	@User_Code INT = 143,
	@DashboardDays INT=30
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_IPR_Dashboard_Details]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON;
		--DECLARE 
		--@DashboardType varchar(10)='D',
		--@SearchFor NVARCHAR(1000) ='Colors',
		--@User_Code INT = 211,
		--@DashboardDays INT=30

		Declare @StartDate AS date
		Declare @EndDate AS date
		Declare @SQL As NVarchar(MAX)

		SELECT @StartDate = (SELECT CONVERT(date,GETDATE() ,103)), @EndDate = (SELECT CONVERT(date,GETDATE()+  @DashboardDays ,103))
	
		CREATE TABLE #Trademark (
			Trademark_No VARCHAR(100),
			Trademark_Name NVARCHAR(MAX),
			Applicant_Name VARCHAR(MAX),
			Renewed_Until DATETIME
		)
		INSERT INTO #Trademark (Trademark_No, Trademark_Name, Applicant_Name, Renewed_Until)
		SELECT Trademark_No,IR.Trademark,APPLICANT,Renewed_Until from IPR_Rep IR (NOLOCK)
		LEFT JOIN DM_IPR DI (NOLOCK) ON IR.Applicant_Code = DI.ID
		WHERE IPR_For = @DashboardType AND Renewed_Until BETWEEN @StartDate AND @EndDate
		and( Trademark_No LIKE N'%'+@SearchFor+'%'OR IR.Trademark LIKE N'%'+@SearchFor+'%' OR Applicant LIKE '%'+@SearchFor+'%' OR Renewed_Until LIKE N'%'+@SearchFor+'%')

		SELECT Trademark_No, Trademark_Name, Applicant_Name,Renewed_Until FROM #Trademark

		IF OBJECT_ID('tempdb..#Trademark') IS NOT NULL DROP TABLE #Trademark
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_IPR_Dashboard_Details]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END