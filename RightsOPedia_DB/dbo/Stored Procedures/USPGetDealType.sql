CREATE PROCEDURE [dbo].[USPGetDealType]
@TitleCode INT
AS 
	SELECT dt.Deal_Type_Name AS DealType FROM Title t
	INNER JOIN DealType dt ON t.Deal_Type_Code = dt.Deal_Type_Code 
	WHERE t.Title_Code = @TitleCode

	


	