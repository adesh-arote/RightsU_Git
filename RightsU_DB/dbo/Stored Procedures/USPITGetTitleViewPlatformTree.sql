CREATE PROCEDURE [dbo].[USPITGetTitleViewPlatformTree]
(
	@Deal_Rights_Code INT,
	@TabName NVARCHAR(50)
)
AS
BEGIN
Declare @Loglevel int;
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewPlatformTree]', 'Step 1', 0, 'Started Procedure', 0, ''

	IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
	IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
	IF OBJECT_ID('tempdb..#TempAcqRightsPlatform') IS NOT NULL DROP TABLE #TempAcqRightsPlatform

	--Declare @Deal_Rights_Code INT = 36376


	CREATE TABLE #TempPlatform
	(
		Platform_Code INT,
		Platform_Name VARCHAR(MAX),
		Parent_Platform_Code INT,
		Is_Last_Level VARCHAR(2),
		Is_Active VARCHAR(2),
		Module_Position VARCHAR(MAX),
		Selected VARCHAR(10)

	)

	CREATE TABLE #TempAcqRightsPlatform
	(
		Acq_Deal_Rights_Code INT,
		Platform_Code INT
	)

	Create Table #TempPF(
		Platform_Code Int,
		Parent_Platform_Code Int,
		Is_Last_Level Varchar(2)
	)

	INSERT INTO #TempPlatform(Platform_Code, Platform_Name, Parent_Platform_Code, Is_Last_Level, Is_Active,Module_Position)
	SELECT Platform_Code, Platform_Name, Parent_Platform_Code, Is_Last_Level, Is_Active,Module_Position  FROM Platform (NOLOCK)

	IF(@TabName = 'Rights Tab')
	BEGIN
		INSERT INTO #TempAcqRightsPlatform
		SELECT Acq_Deal_Rights_Code,Platform_Code FROM Acq_Deal_Rights_Platform (NOLOCK)
		WHERE Acq_Deal_Rights_Code = @Deal_Rights_Code
	END
	ELSE
	BEGIN
		INSERT INTO #TempAcqRightsPlatform
		SELECT Syn_Deal_Rights_Code,Platform_Code FROM Syn_Deal_Rights_Platform (NOLOCK)
		WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code
	END
	
	If((SELECT COUNT(*) FROM #TempAcqRightsPlatform) <> 0)
	BEGIN
	
		INSERT INTO #TempPF
		Select tap.platform_code, ISNULL(tap.Parent_Platform_Code, 0), Is_Last_Level
		From #TempPlatform tap
		INNER JOIN #TempAcqRightsPlatform parp ON parp.Platform_Code = tap.Platform_Code
		ORDER BY tap.platform_name 
		
		While((	
			SELECT Count(*) From #TempPlatform Where Platform_Code In (Select Parent_Platform_Code From #TempPF) And Platform_Code Not In (Select Platform_Code From #TempPF)
		) > 0)
		Begin
			
			INSERT INTO #TempPF
			SELECT platform_code, ISNULL(Parent_Platform_Code, 0), Is_Last_Level
			FROM #TempPlatform Where Platform_Code in (Select Parent_Platform_Code From #TempPF) And Platform_Code Not In (Select Platform_Code From #TempPF)
			
		End
	END
	ELSE
	BEGIN
		INSERT INTO #TempPF(Platform_Code, Parent_Platform_Code)
		SELECT Platform_Code, IsNull(Parent_Platform_Code, 0) From #TempPlatform
	END

	UPDATE t SET t.Selected = 'true'
	FROM #TempPlatform t
	where t.Platform_Code IN 
	(
		SELECT Platform_Code
		From #TempPlatform Where Is_Active = 'Y' 
		And Platform_Code In (Select Platform_Code From #TempPF) 
	)

	Select Platform_Code, Platform_Name
	, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position,
	(Select Count(*) From #TempPF tp Where tp.Parent_Platform_Code = #TempPlatform.Platform_Code) ChildCount, Selected 
	from #TempPlatform

	IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
	IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
	IF OBJECT_ID('tempdb..#TempAcqRightsPlatform') IS NOT NULL DROP TABLE #TempAcqRightsPlatform

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewPlatformTree]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End