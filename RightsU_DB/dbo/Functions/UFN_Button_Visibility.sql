CREATE FUNCTION [dbo].[UFN_Button_Visibility]
(
	--DECLARE
	@User_Code INT,
	@Module_Code INT
) 
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @Is_Right_Available VARCHAR(MAX)
Declare @UserSecCode  INT =0
	SELECT @UserSecCode = Security_Group_Code FROM Users WHERE Users_Code = @User_Code  
	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name  varchar(100),
		Visible varchar(1)
	)

	INSERT INTO @Module_Rights (Right_Code, Right_Name,Visible)
	SELECT distinct sr.Right_Code, sr.Right_Name ,CASE WHEN ISNULL(sgr.Security_Group_Code,0)=0 THEN  'N' ELSE 'Y' END
	FROM 
	System_Module_Right smr 
	INNER JOIN System_Right sr on sr.Right_Code = smr.Right_Code
	LEFT JOIN Security_Group_Rel sgr on smr.Module_Right_Code = sgr.System_Module_Rights_Code and sgr.Security_Group_Code=@UserSecCode
	WHERE 
	SR.Right_Code IN (select Right_Code from System_Module_Right) AND smr.Module_Code=@Module_Code  
	ORDER BY SR.Right_Code

	
		

  		 SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )
    	
		--if(@MileStone='Y')
		--	RETURN  @Is_Right_Available + ',' + @MileStone +','
		

		RETURN  ','+@Is_Right_Available +','
END
