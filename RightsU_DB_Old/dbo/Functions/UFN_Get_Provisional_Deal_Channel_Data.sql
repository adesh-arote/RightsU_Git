CREATE FUNCTION DBO.[UFN_Get_Provisional_Deal_Channel_Data]
(
	@Provisional_Deal_Code INT
)
RETURNS NVARCHAR(MAX)
AS
-- =============================================
-- Author:		Akshay Rane
-- =============================================
BEGIN
	DECLARE @ReturnValue NVARCHAR(MAX) = ''

	Select @ReturnValue = @ReturnValue + A.Channel_Name + ', ' From 
	(
		SELECT DISTINCT C.Channel_Name  FROM Provisional_Deal PD
		INNER JOIN Provisional_Deal_Title PDT  On PD.Provisional_Deal_Code = PDT.Provisional_Deal_Code
		INNER JOIN Provisional_Deal_RUN PDR  On PDT.Provisional_Deal_Title_Code = PDR.Provisional_Deal_Title_Code
		INNER JOIN Provisional_Deal_Run_Channel PDRC  On PDR.Provisional_Deal_Run_Code = PDRC.Provisional_Deal_Run_Code
		INNER JOIN Channel C ON C.Channel_Code = PDRC.Channel_Code
		WHERE PD.Provisional_Deal_Code = @Provisional_Deal_Code
	) A
		
	SET @ReturnValue = LTRIM(RTRIM(@ReturnValue))
	IF(LEN(@ReturnValue) > 1)
	BEGIN
		SET @ReturnValue = LEFT(@ReturnValue, LEN(@ReturnValue) - 1)
	END

	RETURN @ReturnValue
END