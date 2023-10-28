CREATE FunctiON [dbo].[UFN_Get_Platform_Group_WithNo]
(
	@PFCodes AS VARCHAR(2000)	
)
RETURNS @Temp TABLE(
	Media_Platform VARCHAR(200),
	ExploitatiON_Platform VARCHAR(2000)
)
AS
-- =============================================
-- Author:		Sachin KarANDe
-- Create DATE: 04-Feb-2019
-- DescriptiON:	Group Wise Platform SELECTiON
-- =============================================
BEGIN
	
	--DECLARE @PFCodes AS VARCHAR(2000) = '32,29,44,46,26,34,20,23,30,25,27,33,43,21'
		
	DECLARE @TempPF TABLE(
		Platform_Code INT,
		Parent_Platform_Code INT,
		Base_Platform_Code INT,
		Is_Last_Level VARCHAR(2),
		Platform_Hiearachy NVARCHAR(1000)
	)

	
	DECLARE @TempPF_1 TABLE(
		Platform_Name VARCHAR(500),
		Parent_Platform_Code INT,
		Attrib_Group_Name VARCHAR(100),
		Attrib_Group_Code INT
	)

	DECLARE @TempPF_2 TABLE(
		Platform_Name VARCHAR(500),
		Parent_Platform_Code INT,
		Attrib_Group_Name VARCHAR(100),
		Attrib_Group_Code INT
	)

	DECLARE @TempPF_3 TABLE(
		Platform_Code INT
	)
	
	DECLARE @TempPF_4 TABLE(
		Platform_Code INT
	)

	DECLARE @TempPF_5 TABLE(
		Platform_Code INT
	)

	DECLARE @TempPF_6 TABLE(
		Platform_Code INT
	)

	DECLARE @TempPF_7 TABLE(
		Platform_Name VARCHAR(500),
		Parent_Platform_Code INT,
		Platform_Code INT
	)

	DECLARE @TempPF_8 TABLE(
		Platform_Name VARCHAR(500),
		Platform_Code INT
	)

	DECLARE @TempOutput TABLE
	(
		IntCode INT IDENTITY(1 ,1),
		ParentOrder INT,
		--ChildOrder INT,
		ParentPlatform VARCHAR(200),
		PlatformName VARCHAR(2000)
	)
	
	DECLARE @TempOGOrder TABLE
	(
		IntCode INT IDENTITY(1 ,1),
		ParentPlatform VARCHAR(200)
	)
	
	DECLARE @TempOPT TABLE
	(
		IntCode INT IDENTITY(1 ,1),
		ParentOder INT,
		ParentPlatform VARCHAR(200),
		ExploitationPlatform VARCHAR(2000)
	)
	
	---------------

	IF(RTRIM(LTRIM(ISNULL(@PFCodes,''))) <> '')
	BEGIN

		INSERT INTO @TempPF(Platform_Code, Parent_Platform_Code, Base_Platform_Code, Is_Last_Level, Platform_Hiearachy)
		SELECT Platform_Code, Parent_Platform_Code, Base_Platform_Code, Is_Last_Level, Platform_Hiearachy
		FROM Platform WHERE Platform_Code IN (
			SELECT number FROM fn_Split_withdelemiter(@PFCodes, ',')
		)
		--SELECT * FROM DBO.UFN_Get_Platform_With_Parent(@PFCodes)

	END

	BEGIN

		--INSERT INTO @TempPF_3
		--SELECT Platform_Code FROM @TempPF WHERE Is_Last_Level = 'Y'

		--INSERT INTO @TempPF_4
		--SELECT Parent_Platform_Code FROM @TempPF WHERE Is_Last_Level = 'Y'
		--UNION
		--SELECT Platform_Code FROM @TempPF WHERE Is_Last_Level = 'N' 

		INSERT INTO @TempOutput(ParentPlatform, PlatformName)--, ChildOrder)
		SELECT DISTINCT p2.Platform_Name, p.Platform_Name--, ROW_NUMBER() OVER(PARTITION BY p2.Platform_Name ORDER BY p.Platform_Name ASC) --,p.Parent_Platform_Code,p.Platform_Code 
		FROM [Platform] p WITH (NOLOCK) 
		INNER JOIN @TempPF p1 ON p.Platform_Code = p1.Platform_Code
		INNER JOIN [Platform] p2 WITH (NOLOCK) ON p.Parent_Platform_Code = p2.Platform_Code

		INSERT INTO @TempOGOrder(ParentPlatform)
		SELECT DISTINCT ParentPlatform FROM @TempOutput

		--SELECT * 
		UPDATE ot SET ot.ParentOrder = grp.IntCode
		FROM @TempOutput ot
		INNER JOIN @TempOGOrder grp ON ot.ParentPlatform = grp.ParentPlatform

		INSERT INTO @TempOPT(ParentOder, ParentPlatform, ExploitationPlatform)
		SELECT ParentOrder, ParentPlatform,
		STUFF((
			SELECT + ', '+ t1.PlatformName 
			FROM @TempOutput T1
			WHERE T1.ParentPlatform = t2.ParentPlatform 
			FOR XML PATH('')), 1, 1, ''
		) AS ExploitatiON_Platform
		FROM (
			SELECT DISTINCT ParentOrder, ParentPlatform FROM @TempOutput
		) AS t2

		INSERT INTO @Temp(Media_Platform, ExploitatiON_Platform)
		SELECT
		STUFF((
			SELECT '~' + CAST(T1.ParentOder AS VARCHAR) + ') '+ t1.ParentPlatform
			FROM @TempOPT T1
			ORDER BY IntCode
			FOR XML PATH('')), 1, 1, ''
		) AS MediaPlatform,
		STUFF((
			SELECT '~'+ CAST(T1.ParentOder AS VARCHAR) + ') '+ t1.ExploitationPlatform
			FROM @TempOPT T1
			ORDER BY IntCode
			FOR XML PATH('')), 1, 1, ''
		) AS ExploitatiON_Platform

		--SELECT * FROM @Temp
	END
	RETURN

END

/*

SELECT * FROM [dbo].[UFN_Get_Platform_Group]('32,29,44,46,26,34,20,23,30,25,27,33,43,21')

*/