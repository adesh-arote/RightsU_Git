CREATE PROCEDURE [dbo].[USP_Get_Talent_Name]
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Talent_Name]', 'Step 1', 0, 'Started Procedure', 0, ''
		--select Talent_Code,Talent_Name from talent where 1=1 AND EXISTS 
		--( SELECT talent_code FROM Talent_Role WHERE talent_code=Talent.talent_code AND role_code=@Role_Code) 

		select DISTINCT T.Talent_Code,T.Talent_Name,Tr.Role_Code from talent T (NOLOCK)
		inner join Talent_Role TR (NOLOCK) on TR.Talent_Code = T.Talent_Code
		where T.Is_Active = 'Y'
		AND TR.Role_Code in (1,2,4)
		RETURN
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Talent_Name]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
