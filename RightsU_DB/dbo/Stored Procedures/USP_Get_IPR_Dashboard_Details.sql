CREATE PROCEDURE [dbo].[USP_Get_IPR_Dashboard_Details]
(
	@DashboardType varchar(10)='D',
	@SearchFor NVARCHAR(1000) ='',
	@User_Code INT = 143,
	@DashboardDays INT=30
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE 
	--@DashboardType varchar(10)='D',
	--@SearchFor NVARCHAR(1000) ='Aug',
	--@User_Code INT = 211,
	--@DashboardDays INT=1000

	IF (@DashboardType = 'I')
		SELECT @DashboardDays = Parameter_Value FROM system_parameter WHERE Parameter_Name = 'DB-ITE'
	ELSE IF (@DashboardType = 'D')
		SELECT @DashboardDays = Parameter_Value FROM system_parameter WHERE Parameter_Name = 'DB-TE'

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
	SELECT Trademark_No,IR.Trademark,APPLICANT,Renewed_Until from IPR_Rep IR
	INNER JOIN DM_IPR DI ON IR.Applicant_Code = DI.ID
	WHERE IPR_For = @DashboardType AND Renewed_Until BETWEEN @StartDate AND @EndDate
	and( Trademark_No LIKE N'%'+@SearchFor+'%'OR IR.Trademark LIKE N'%'+@SearchFor+'%' OR Applicant LIKE '%'+@SearchFor+'%' OR CONVERT(varchar, Renewed_Until, 106) LIKE N'%'+@SearchFor+'%')

	SELECT Trademark_No, Trademark_Name, Applicant_Name,  Renewed_Until FROM #Trademark

	IF OBJECT_ID('tempdb..#Trademark') IS NOT NULL DROP TABLE #Trademark
END