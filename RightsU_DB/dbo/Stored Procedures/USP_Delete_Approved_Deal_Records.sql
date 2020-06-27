CREATE PROCEDURE [dbo].[USP_Delete_Approved_Deal_Records] 
@Deal_Type_Code INT --Movie = 1 / Program  = 11
AS
BEGIN

		DELETE FROM dbo.Approved_Deal 
		WHERE 
			(Record_Code IN (SELECT adm.Acq_Deal_Code FROM Acq_Deal_Movie adm
			INNER JOIN Title t ON adm.Title_Code = t.Title_Code
			WHERE t.Deal_Type_Code = @Deal_Type_Code
			) AND Deal_Type = 'A')
		OR
			(Record_Code IN (SELECT sdm.Syn_Deal_Code FROM Syn_Deal_Movie sdm
				INNER JOIN Title t ON sdm.Title_Code = t.Title_Code
				WHERE t.Deal_Type_Code = @Deal_Type_Code
			) AND Deal_Type = 'S')
		
END