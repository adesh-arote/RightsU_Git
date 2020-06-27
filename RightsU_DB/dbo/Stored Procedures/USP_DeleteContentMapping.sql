CREATE PROC USP_DeleteContentMapping
(
	@DealCode INT,
	@DealType CHAR(1)
)
AS
BEGIN
	--DECLARE @DealCode INT = 2484, @DealType CHAR(1) = 'A'
	SET FMTONLY OFF
	
	IF(@DealType = 'A')
	BEGIN
		DELETE TMC FROM Acq_Deal_Movie ADM
		INNER JOIN Title_Content_Mapping TMC ON TMC.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code 
		WHERE ADM.Acq_Deal_Code = @DealCode AND Title_Content_Mapping_Code NOT IN (
			SELECT TMC.Title_Content_Mapping_Code FROM Acq_Deal_Movie ADM 
			INNER JOIN Title_Content TC ON TC.Title_Code = ADM.Title_Code AND TC.Episode_No BETWEEN ADM.Episode_Starts_From AND ADM.Episode_End_To
			INNER JOIN Title_Content_Mapping TMC ON TMC.Title_Content_Code = TC.Title_Content_Code AND TMC.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code 
			WHERE ADM.Acq_Deal_Code = @DealCode
		)
	END
END