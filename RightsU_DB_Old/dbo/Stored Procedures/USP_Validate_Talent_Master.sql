
CREATE PROCEDURE USP_Validate_Talent_Master
(
	@Talent_Code INT,
	@Selected_Role_Code VARCHAR(150)
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 30 March 2015
-- Description:	Call From Talent Master , Disable Delete Button if reference is found in title Master , Check Talent in Title Master
-- =============================================
BEGIN
	SET NOCOUNT ON;    
	DECLARE @IS_Ref VARCHAR(3) = 'NO'
	IF(@Selected_Role_Code = '')
BEGIN 
	IF EXISTS(SELECT TOP  1 Talent_Code  FROM  Title_Talent WHERE Talent_Code = @Talent_Code)
	BEGIN
		SELECT 'YES'
		RETURN 
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT TOP 1 MECD.Map_Extended_Columns_Details_Code FROM  Extended_Columns EC
		INNER JOIN [Role] R  ON EC.Columns_Name = R.Role_Name AND R.Role_Type = 'T'		 
		INNER JOIN [Map_Extended_Columns] MEC  ON MEC.Columns_Code= EC.Columns_Code
		INNER JOIN [Map_Extended_Columns_Details] MECD  ON MECD.Map_Extended_Columns_Code= MEC.Map_Extended_Columns_Code AND MEC.Is_Multiple_Select = 'Y'		
		WHERE Ref_Table ='TALENT' AND MECD.Columns_Value_Code = @Talent_Code)
		BEGIN
			--SELECT 'YES' AS Talent_Found
			--RETURN 
			SET  @IS_Ref = 'YES'
		END
	END	
END
ELSE 
BEGIN
	IF EXISTS(SELECT TOP 1 Talent_Code  FROM  Title_Talent 
	WHERE Talent_Code = @Talent_Code AND Role_Code NOT IN(SELECT number FROM fn_Split_withdelemiter(@Selected_Role_Code,',')))
	BEGIN
		PRINT 'Title'
			--SELECT 'YES' AS Talent_Found
			--RETURN 
			SET  @IS_Ref = 'YES'
	END
	ELSE
	BEGIN
		PRINT 'Map'
		IF EXISTS(SELECT TOP 1 MECD.Map_Extended_Columns_Details_Code FROM  Extended_Columns EC
		INNER JOIN [Role] R  ON EC.Columns_Name = R.Role_Name AND R.Role_Type = 'T' AND R.Role_Code NOT IN(SELECT number FROM fn_Split_withdelemiter(@Selected_Role_Code,','))
		INNER JOIN [Map_Extended_Columns] MEC  ON MEC.Columns_Code= EC.Columns_Code
		INNER JOIN [Map_Extended_Columns_Details] MECD  ON MECD.Map_Extended_Columns_Code= MEC.Map_Extended_Columns_Code AND MEC.Is_Multiple_Select = 'Y'		
		WHERE Ref_Table ='TALENT' AND MECD.Columns_Value_Code = @Talent_Code )
		BEGIN
			--SELECT 'YES' AS Talent_Found
			--RETURN 
			SET  @IS_Ref = 'YES'
		END
	END
END
	SELECT @IS_Ref  AS Talent_Found
END