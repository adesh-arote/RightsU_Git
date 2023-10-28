CREATE PROCEDURE USPGetPlatformwiseTitle
@Media_Platform NVARCHAR(MAX),
@Mode_Of_Exploitation NVARCHAR(MAX)
AS
BEGIN
	IF OBJECT_ID('tempdb..#PlatformRightsCode') IS NOT NULL DROP TABLE #PlatformRightsCode
	IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search

	CREATE TABLE #Platform_Search(
		Platform_Code INT
	)
	
	DECLARE @ParentPlatform AS TABLE 
	(
		Parent_Platform_Code INT
	)
	
	DECLARE @ChildPlatform AS TABLE 
	(
		Platform_Code INT
	)
	
	CREATE TABLE #PlatformRightsCode
	(
		Acq_Deal_Rights_Code INT
	)
	
	INSERT INTO @ParentPlatform(Parent_Platform_Code)
	SELECT Platform_Code FROM Platform WHERE Platform_Name COLLATE Latin1_General_CI_AI IN (
		SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Media_Platform,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
	)
	
	INSERT INTO @ChildPlatform(Platform_Code)
	SELECT Platform_Code FROM Platform WHERE Platform_Name COLLATE Latin1_General_CI_AI IN (
		SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Mode_Of_Exploitation,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
	)
	
	IF NOT EXISTS(SELECT TOP 1 * FROM @ParentPlatform)
	BEGIN
	
		INSERT INTO @ParentPlatform(Parent_Platform_Code)
		SELECT DISTINCT Parent_Platform_Code FROM Platform WHERE IS_Last_Level = 'Y' AND ISNULL(Parent_Platform_Code, 0) > 0
	
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM @ChildPlatform)
	BEGIN
	
		INSERT INTO @ChildPlatform(Platform_Code)
		SELECT DISTINCT Platform_Code FROM Platform WHERE IS_Last_Level = 'Y' AND ISNULL(Parent_Platform_Code, 0) > 0
	
	END
	
	INSERT INTO #Platform_Search(Platform_Code)
	SELECT DISTINCT p.Platform_Code
	FROM (
		SELECT cl.Platform_Code, pl.Parent_Platform_Code
		FROM @ParentPlatform pl
		INNER JOIN @ChildPlatform cl ON 1 = 1
	) AS tmp
	INNER JOIN Platform p ON p.Platform_Code = tmp.Platform_Code AND p.Parent_Platform_Code = tmp.Parent_Platform_Code AND IS_Last_Level = 'Y'
	
	INSERT INTO #PlatformRightsCode(Acq_Deal_Rights_Code)
	SELECT DISTINCT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform adrp 
	INNER JOIN #Platform_Search ps ON adrp.Platform_Code = ps.Platform_Code
	
	Select Distinct Title_Code from Acq_Deal_Rights_Title adrt
	INNER JOIN #PlatformRightsCode t on t.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code

	IF OBJECT_ID('tempdb..#PlatformRightsCode') IS NOT NULL DROP TABLE #PlatformRightsCode
	IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search

END

