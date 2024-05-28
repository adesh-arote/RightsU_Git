

CREATE FunctiON [dbo].[UFN_Get_Platform_Hierarchy_WithNo]
(
	@PFCodes AS VARCHAR(2000)	
)
RETURNS @Temp TABLE(
	Platform_Hierarchy NVARCHAR(MAX)
)
AS
-- =============================================
-- Author:		Aditya B
-- Create DATE: 25-Sep-2020
-- DescriptiON:	Group Wise Platform Hierarchy SELECTiON
-- =============================================
BEGIN
	--DECLARE @Temp TABLE(
	--Platform_Hierarchy NVARCHAR(MAX)
	--)
	--DECLARE @PFCodes AS VARCHAR(2000) = '20,21,23,25,26,27,29,30,32,33,34,36,37,39,42,43,44,46,47,48,49,51'
	
	

	DECLARE @PlatformWithCodes TABLE (
		INT_Code INT IDENTITY(1 ,1),
		Platform_Code INT,
		PL_Hierarchy NVARCHAR(MAX)
	)
	

	INSERT INTO @PlatformWithCodes(Platform_Code,PL_Hierarchy)
	SELECT  Platform_Code,Platform_Hiearachy
	from Platform WHERE Platform_Code IN(SELECT number FROM fn_Split_withdelemiter(@PFCodes, ','))


	
	INSERT INTO @Temp
	Select STUFF((
			SELECT '~'+ CAST(T1.Int_Code AS VARCHAR) + ') '+ t1.PL_Hierarchy
			FROM @PlatformWithCodes T1
			ORDER BY Int_Code
			FOR XML PATH('')), 1, 1, ''
		) AS Platform_Hierarchy
		
		--SELECT * FROM @Temp
	--END
	RETURN

END

/*

SELECT * FROM [dbo].[UFN_Get_Platform_Group]('32,29,44,46,26,34,20,23,30,25,27,33,43,21')

*/