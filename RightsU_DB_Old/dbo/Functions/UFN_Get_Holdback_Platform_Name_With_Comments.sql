
CREATE Function [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](@Right_Code Int, @Right_Type CHAR(2),@HLD_Col CHAR(1))
Returns NVARCHAR(Max)
As
Begin

	--DECLARE @Right_Code Int = 1383 , @Right_Type CHAR(2) = 'AR'
	Declare @Holdback NVARCHAR(MAX) = ''

	DECLARE @HOLDBACK_TEMP TABLE(
		Row_No INT IDENTITY(1,1) ,
		Holdback_Comment NVARCHAR(MAX),
		Platform_Code VARCHAR(MAX),
		Platform_Name NVARCHAR(MAX)
	)
	
	DECLARE @COUNT INT = 0
	IF(@Right_Type = 'AR')
		SELECT @COUNT = COUNT(*) FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Right_Code 
	ELSE IF(@Right_Type = 'SR')
		SELECT @COUNT = COUNT(*) FROM Syn_Deal_Rights_Holdback WHERE Syn_Deal_Rights_Code = @Right_Code 

	IF(@COUNT > 0)
	BEGIN
		IF(@Right_Type = 'AR')
		BEGIN
			INSERT INTO  @HOLDBACK_TEMP
			SELECT ADRH.Holdback_Comment,
			stuff(
					(	
						select cast(Platform_Code  as varchar(MAX)) + ', '
						from Acq_Deal_Rights_Holdback_Platform where Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						FOR XML PATH('')
					),1,0, ''
				)
			as Platform_Code, NULL
			FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code
			WHERE ADR.Acq_Deal_Rights_Code = @Right_Code
		END
		ELSE IF(@Right_Type = 'SR')
		BEGIN
		
			INSERT INTO  @HOLDBACK_TEMP
			SELECT SDRH.Holdback_Comment,
			stuff(
					(	
						select cast(Platform_Code  as varchar(MAX)) + ','
						from Syn_Deal_Rights_Holdback_Platform where Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
						FOR XML PATH('')
					),1,0, ''
				)
			as Platform_Code, NULL
			FROM Syn_Deal_Rights SDR
			INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDR.Syn_Deal_Rights_Code = SDRH.Syn_Deal_Rights_Code
			WHERE SDR.Syn_Deal_Rights_Code = @Right_Code
		END
	
		DECLARE @maxRowNo INT = 0
		SELECT TOP 1 @maxRowNo = MAX(Row_No) FROM @HOLDBACK_TEMP where Platform_Name IS NULL
		WHILE(@maxRowNo > 0)
		BEGIN
			DECLARE @Platform_Code VARCHAR(MAX) = '', @Platform_Name NVARCHAR(MAX) = ''
			SELECT @Platform_Code = ISNULL(Platform_Code, '') FROM @HOLDBACK_TEMP WHERE Row_No = @maxRowNo
			SELECT @Platform_Name = @Platform_Name + Platform_Hiearachy + ', ' FROM DBO.UFN_Get_Platform_With_Parent(@Platform_Code)
			UPDATE @HOLDBACK_TEMP SET Platform_Name = @Platform_Name WHERE Row_No = @maxRowNo
			SET @maxRowNo = 0;
			SELECT TOP 1 @maxRowNo = MAX(Row_No) FROM @HOLDBACK_TEMP where Platform_Name IS NULL
		END
		begin
			if(@HLD_Col='P')
			Select @Holdback = @Holdback + Cast(Row_No as Varchar(5)) + ') ' + Platform_Name + '~'
			From (
					SELECT * FROM @HOLDBACK_TEMP WHERE ISNULL(Platform_Code, '') <> ''
			) As a 
			else if(@HLD_Col='R')
			Select @Holdback = @Holdback + Cast(Row_No as Varchar(5)) + ') ' +  Holdback_Comment + '~'
			From (
					SELECT * FROM @HOLDBACK_TEMP WHERE ISNULL(Platform_Code, '') <> '' AND ISNULL(Holdback_Comment,'') <> ''
			) As a 
		end
	END
	Return Substring(LTRIM(RTRIM(@Holdback)), 0, Len(LTRIM(RTRIM(@Holdback))))
	--SELECT @Holdback
End