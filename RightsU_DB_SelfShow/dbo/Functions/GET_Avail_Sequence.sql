CREATE Function DBO.GET_Avail_Sequence()
RETURNS NUMERIC(38, 0)
AS
BEGIN

	DECLARE @RetValue NUMERIC(38, 0) = 0

	--BEGIN TRAN
	
	
	Declare @TempCountry As Table(
		Country_Code Int
	)
	INSERT INTO @TempCountry(Country_Code) VALUES(1)

	SELECT @RetValue = IDENT_CURRENT('Avail_Sequence')
	
	--Delete From Avail_Sequence

	--ROLLBACK TRAN

	RETURN @RetValue

END