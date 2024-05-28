CREATE Function [dbo].[UFN_Get_Platform_Name_Selected]
(
	@Rights_Code Int,
	@Right_Type Char(2),
	@Selected_Platform_Code VARCHAR(MAX) = '0'
)
Returns NVARCHAR(MAX)
As
Begin
	
	--DECLARE @Rights_Code Int, @Right_Type Char(2)
	--SELECT @Rights_Code = 18, @Right_Type = 'AR'
	DECLARE @platformCode VARCHAR(MAX) = ''

	DECLARE @Temp_Platform TABLE(Platform_Code INT)

	INSERT INTO @Temp_Platform (Platform_Code)
	SELECT DISTINCT number FROM dbo.fn_Split_withdelemiter(@Selected_Platform_Code,',') WHERE number NOT IN('0', '')

	IF(@Right_Type = 'AR')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		FROM Acq_Deal_Rights_Platform 
		WHERE Acq_Deal_Rights_Code = @Rights_Code 
		AND (LTRIM(RTRIM(@Selected_Platform_Code)) IN ('0', '') OR Platform_Code in (SELECT Platform_Code FROM @Temp_Platform))
		 
	END
	ELSE IF (@Right_Type = 'AP')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		FROM Acq_Deal_Pushback_Platform 
		WHERE Acq_Deal_Pushback_Code = @Rights_Code
		AND (LTRIM(RTRIM(@Selected_Platform_Code)) IN ('0', '') OR Platform_Code in (SELECT Platform_Code FROM @Temp_Platform))
	END
	ELSE IF (@Right_Type = 'SR' OR @Right_Type = 'SR')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		FROM Syn_Deal_Rights_Platform 
		WHERE Syn_Deal_Rights_Code = @Rights_Code
		AND (LTRIM(RTRIM(@Selected_Platform_Code)) IN ('0', '') OR Platform_Code in (SELECT Platform_Code FROM @Temp_Platform))
	END

	DECLARE @TempPlatform TABLE(
		Platform_Code Int,
		Parent_Platform_Code Int,
		Base_Platform_Code Int,
		Is_Display Varchar(2),
		Is_Last_Level Varchar(2),
		TempCnt Int,
		TableCnt Int,
		Platform_Name NVARCHAR(1000)
	);

	INSERT INTO @TempPlatform(Platform_Code, Parent_Platform_Code, Base_Platform_Code, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Name)
	Select Platform_Code, Parent_Platform_Code, Base_Platform_Code, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Hiearachy from DBO.UFN_Get_Platform_With_Parent(@platformCode)
	--Select * from DBO.UFN_Get_Platform_With_Parent(@platformCode)

	Declare @Platform_Names NVARCHAR(MAX) = ''
	Select @Platform_Names = @Platform_Names + Cast(RowId as NVARCHAR(10)) + ') ' + a.Platform_Name + '~' From (
		Select ROW_NUMBER() OVER(Order By temp.Platform_Name Asc) RowId, temp.Platform_Name from @TempPlatform temp
	) as a 

	IF(LEN(@Platform_Names) >= 1)
		SET @Platform_Names = LEFT(@Platform_Names, LEN(@Platform_Names) - 1)

	RETURN @Platform_Names
End