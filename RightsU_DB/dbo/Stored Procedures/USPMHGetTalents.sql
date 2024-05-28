CREATE Procedure [dbo].[USPMHGetTalents]
@RoleCode INT,
@StrSearch NVARCHAR(MAX)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetTalents]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		Select TOP 25 TR.Talent_Code AS TalentCode,T.Talent_Name AS TalentName from Talent_Role TR (NOLOCK) 
		INNER JOIN Talent T (NOLOCK)  On T.Talent_Code = TR.Talent_Code
		INNER JOIN ROLE R  (NOLOCK) ON R.Role_Code = TR.Role_Code
		WHERE T.Talent_Name like '%'+@StrSearch+'%' AND TR.Role_Code = @RoleCode
		ORDER BY TR.Talent_Role_Code
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetTalents]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END