﻿
CREATE PROCEDURE [dbo].[USP_MODULE_RIGHTS]
	@Module_Code INT =35,
	@Security_Group_Code INT =1,
	@Users_Code INT
AS
-- =============================================
-- Author:		RESHMA KUNJAL
-- Create date: 22 JUNE 2015
-- Description:	get the Module wise User Rights
-- =============================================
BEGIN
	--select * from System_Module
	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name  NVARCHAR(100),
		Visible VARCHAR(1)
	)

	INSERT INTO @Module_Rights (Right_Code, Right_Name, Visible)
	SELECT DISTINCT sr.Right_Code, sr.Right_Name, CASE WHEN ISNULL(sgr.Security_Group_Code, 0) = 0 THEN  'N' ELSE 'Y' END
	FROM 
	System_Module_Right smr 
	INNER JOIN System_Right sr on sr.Right_Code = smr.Right_Code
	INNER JOIN Security_Group_Rel sgr on smr.Module_Right_Code = sgr.System_Module_Rights_Code and sgr.Security_Group_Code = @Security_Group_Code
	WHERE smr.Module_Code=@Module_Code  and sgr.Security_Group_Code=@Security_Group_Code AND SMR.Module_Right_Code NOT IN
	(SELECT Module_Right_Code FROM Users_Exclusion_Rights where Users_Code = @Users_Code) 
	ORDER BY SR.Right_Code

	--select * from @Module_Rights
	
	DECLARE @Is_Right_Available VARCHAR(max)
  	SELECT  @Is_Right_Available = (SELECT '~'+STUFF((SELECT '~'+ cast(Right_Code as varchar(max)) FROM @Module_Rights FOR XML PATH('')), 1, 1, '')+'~' )
    	
	SELECT  @Is_Right_Available 

	END
