CREATE PROC USP_Check_HoldBack
(
	@Title_Code BIGINT
)
AS
BEGIN
	SELECT DISTINCT A.Is_HoldBack 
	FROM 
	(
		SELECT ISNULL(Holdback_On_Platform_Code,0) Is_HoldBack 
		FROM Acq_Deal_Rights_Title ADRT
		INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRT.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code
		WHERE ADRT.Title_Code = @Title_Code AND ISNULL(Holdback_On_Platform_Code,0) != 0 AND ADRH.Holdback_Type = 'R'
		UNION
		SELECT ISNULL(TRP.Platform_Code,0) FROM 
		Title_Release TR INNER JOIN Title_Release_Platforms TRP ON TR.Title_Release_Code = TRP.Title_Release_Code
		WHERE TR.Title_Code = @Title_Code
	) A
END