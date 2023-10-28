CREATE PROCEDURE USPAL_UpdateAL_Recommendation
@AL_Recommendation_Code INT,
@ExcelFileName NVARCHAR(MAX)
AS
BEGIN
	UPDATE AL_Recommendation SET Excel_File = @ExcelFileName WHERE AL_Recommendation_Code = @AL_Recommendation_Code
END