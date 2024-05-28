CREATE Function [dbo].[UFN_Get_Platform_Name]
(
	@Rights_Code Int,
	@Right_Type Char(2)
)
Returns NVarchar(MAX)
As
Begin
	
	--DECLARE @Rights_Code Int, @Right_Type Char(2)
	--SELECT @Rights_Code = 75, @Right_Type = 'MD'
	DECLARE @platformCode VARCHAR(MAX) = ''

	IF(@Right_Type = 'AR')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		FROM Acq_Deal_Rights_Platform 
		WHERE Acq_Deal_Rights_Code = @Rights_Code 
		 
	END
	ELSE IF (@Right_Type = 'AP')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		FROM Acq_Deal_Pushback_Platform 
		WHERE Acq_Deal_Pushback_Code = @Rights_Code
	END
	ELSE IF (@Right_Type = 'SR' OR @Right_Type = 'SR')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		FROM Syn_Deal_Rights_Platform 
		WHERE Syn_Deal_Rights_Code = @Rights_Code
	END
	ELSE IF (@Right_Type = 'MD')
	BEGIN
		SELECT @platformCode = @platformCode + CAST(Music_Platform_Code AS NVARCHAR(MAX)) + ',' 
		FROM Music_Deal_Platform 
		WHERE Music_Deal_Code = @Rights_Code
	END
	--SELECT @platformCode 
	--select * from Music_Deal_Platform where Music_Deal_Code = 75

	Declare @Platform_Names NVarchar(MAX) = ''
	IF (@Right_Type <> 'MD')
	BEGIN
		DECLARE @TempPlatform TABLE(
			Platform_Code Int,
			Parent_Platform_Code Int,
			Base_Platform_Code Int,
			Is_Display Varchar(2),
			Is_Last_Level Varchar(2),
			TempCnt Int,
			TableCnt Int,
			Platform_Name NVarchar(1000)
		);

		INSERT INTO @TempPlatform(Platform_Code, Parent_Platform_Code, Base_Platform_Code, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Name)
		Select Platform_Code, Parent_Platform_Code, Base_Platform_Code, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Hiearachy from DBO.UFN_Get_Platform_With_Parent(@platformCode)
		--Select * from DBO.UFN_Get_Platform_With_Parent(@platformCode)

		Select @Platform_Names = @Platform_Names + Cast(RowId as Varchar(5)) + ') ' + a.Platform_Name + '~' From (
			Select ROW_NUMBER() OVER(Order By temp.Platform_Name Asc) RowId, temp.Platform_Name from @TempPlatform temp
		) as a 
	END
	ELSE
	BEGIN
		DECLARE @MusicTempPlatform TABLE(
			Music_Platform_Code Int,
			Parent_Code Int,
			Is_Display Varchar(2),
			Is_Last_Level Varchar(2),
			TempCnt Int,
			TableCnt Int,
			Platform_Name NVarchar(1000)
		);
		INSERT INTO @MusicTempPlatform(Music_Platform_Code, Parent_Code, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Name)
		Select Music_Platform_Code, Parent_Code, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Hierarchy from DBO.UFN_Get_Music_Platform_With_Parent(@platformCode)

		--Select * from @MusicTempPlatform
		Select @Platform_Names  = @Platform_Names + Cast(RowId as Varchar(5)) + ') ' + a.Platform_Name + '~' From (
			Select ROW_NUMBER() OVER(Order By tempMusic.Music_Platform_Code Asc) RowId, tempMusic.Platform_Name from @MusicTempPlatform tempMusic 
		)  as a  
		--Select @Platform_Names = @Platform_Names + Cast(RowId as Varchar(5)) + ') ' + a.Platform_Name + '~' From (
		--	Select ROW_NUMBER() OVER(Order By MP.Platform_Name Asc) RowId, MP.Platform_Name from Music_Platform MP
		--	WHERE Music_Platform_Code IN (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@platformCode, ',') WHERE ISNULL(number, '') <> '')
		--) as a 
	END

	IF(LEN(@Platform_Names) >= 1)
		SET @Platform_Names = LEFT(@Platform_Names, LEN(@Platform_Names) - 1)

	RETURN @Platform_Names
	--Select @Platform_Names
End


--Select * from Music_Deal order by Last_Updated_Time DESC
--Select * from Music_Deal_Platform
			--Select ROW_NUMBER() OVER(Order By tempMusic.Music_Platform_Code Asc) RowId, tempMusic.Platform_Name from @MusicTempPlatform tempMusic 


--Select * from Music_Platform
--Select * from Platform

