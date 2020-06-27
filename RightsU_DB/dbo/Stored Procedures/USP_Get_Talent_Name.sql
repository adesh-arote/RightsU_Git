CREATE PROCEDURE [dbo].[USP_Get_Talent_Name]
AS
BEGIN
	--select Talent_Code,Talent_Name from talent where 1=1 AND EXISTS 
	--( SELECT talent_code FROM Talent_Role WHERE talent_code=Talent.talent_code AND role_code=@Role_Code) 
	
	
	
	select T.Talent_Code,T.Talent_Name,Tr.Role_Code from talent T
	inner join Talent_Role TR on TR.Talent_Code = T.Talent_Code
	where T.Is_Active = 'Y'
	--AND TR.Role_Code in (@Role_Code)
	RETURN
END

--EXEC [dbo].[USP_Get_Talent_Name] 4

