CREATE FUNCTION DBO.[UFN_Get_Music_Deal_Child_Data]
(
	@Music_Deal_Code INT,
	@Selected_Channel_Code VARCHAR(MAX) = '',
	@CallFor VARCHAR(20)
)
RETURNS NVARCHAR(MAX)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 02 March 2016
-- Description:	Get Child Data like Channels, Countries,Languages, Titles(LinkShow), Vendors by passing flag in @CallFor Parameter
-- =============================================    
BEGIN
	
	DECLARE @ReturnValue NVARCHAR(MAX) = ''
	--@Music_Deal_Code INT = 67,
	--@Selected_Channel_Code VARCHAR(MAX) = '',
	--@CallFor VARCHAR(20) = 'DealType'
	DECLARE @TempTable TABLE
	(
		Code INT
	)

	INSERT INTO @TempTable
	SELECT number FROM DBO.fn_Split_withdelemiter(@Selected_Channel_Code, ',') WHERE number <> ''

	IF(@CallFor = 'CHANNEL')
	BEGIN
		SELECT @ReturnValue = @ReturnValue + C.Channel_Name + ', '  FROM Music_Deal_Channel MDC
		INNER JOIN Channel C ON C.Channel_Code = MDC.Channel_Code
		WHERE MDC.Music_Deal_Code = @Music_Deal_Code AND 
		(
			@Selected_Channel_Code = '' OR C.Channel_Code IN ( SELECT Code FROM @TempTable)
		)
	END
	ELSE IF(@CallFor = 'COUNTRY')
	BEGIN
		SELECT @ReturnValue = @ReturnValue + C.Country_Name + ', '  FROM Music_Deal_Country MDC
		INNER JOIN Country C ON C.Country_Code = MDC.Country_Code
		WHERE MDC.Music_Deal_Code = @Music_Deal_Code AND 
		(
			@Selected_Channel_Code = '' OR C.Country_Code IN ( SELECT Code FROM @TempTable)
		)
	END
	ELSE IF(@CallFor = 'LANGUAGE')
	BEGIN
		SELECT @ReturnValue = @ReturnValue + ML.Language_Name + ', '  FROM Music_Deal_Language MDL
		INNER JOIN [Music_Language] ML ON ML.Music_Language_Code = MDL.Music_Language_Code
		WHERE MDL.Music_Deal_Code = @Music_Deal_Code AND 
		(
			@Selected_Channel_Code = '' OR ML.Music_Language_Code IN ( SELECT Code FROM @TempTable)
		)
	END
	ELSE IF(@CallFor = 'LINKSHOW')
	BEGIN
		SELECT @ReturnValue = @ReturnValue + T.Title_Name + ', '  FROM Music_Deal_LinkShow MDL
		INNER JOIN Title T ON T.Title_Code = MDL.Title_Code
		WHERE MDL.Music_Deal_Code = @Music_Deal_Code AND 
		(
			@Selected_Channel_Code = '' OR T.Title_Code IN ( SELECT Code FROM @TempTable)
		)
	END
	ELSE IF(@CallFor = 'VENDOR')
	BEGIN
		SELECT @ReturnValue = @ReturnValue + V.Vendor_Name + ', '  FROM Music_Deal_Vendor MDV
		INNER JOIN Vendor V ON V.Vendor_Code = MDV.Vendor_Code
		WHERE MDV.Music_Deal_Code = @Music_Deal_Code AND 
		(
			@Selected_Channel_Code = '' OR V.Vendor_Code IN ( SELECT Code FROM @TempTable)
		)
	END
	ELSE IF(@CallFor = 'DEALTYPE')
	BEGIN
		SELECT @ReturnValue = @ReturnValue + DT.Deal_Type_Name + ', '  FROM Music_Deal_DealType MDD
		INNER JOIN Deal_Type DT ON DT.Deal_Type_Code= MDD.Deal_Type_Code
		WHERE MDD.Music_Deal_Code = @Music_Deal_Code AND 
		(
			@Selected_Channel_Code = '' OR DT.Deal_Type_Code IN ( SELECT Code FROM @TempTable)
		)
	END
	SET @ReturnValue = LTRIM(RTRIM(@ReturnValue))
	IF(LEN(@ReturnValue) > 1)
	BEGIN
		SET @ReturnValue = LEFT(@ReturnValue, LEN(@ReturnValue) - 1)
	END

	--Select @ReturnValue
	RETURN @ReturnValue
END
