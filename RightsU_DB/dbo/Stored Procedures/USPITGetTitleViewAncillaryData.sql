CREATE PROCEDURE USPITGetTitleViewAncillaryData 
@TitleCode NVARCHAR(MAX)
AS
BEGIN
	
	Select DISTINCT ad.Agreement_No, adnt.Title_Code ,at.Ancillary_Type_Name AS Type, CASE WHEN adn.Catch_Up_From = 'E' THEN 'Each Broadcast'
	WHEN adn.Catch_Up_From = 'F' THEN 'First Broadcast'
	ELSE '' END AS CatchUp_From, adn.Duration AS Duration , adn.Day AS Qty   from Acq_Deal ad
	INNER JOIN Acq_Deal_Ancillary adn ON adn.Acq_Deal_Code = ad.Acq_Deal_Code
	INNER JOIN Acq_Deal_Ancillary_Title adnt ON adnt.Acq_Deal_Ancillary_Code = adn.Acq_Deal_Ancillary_Code
	--INNER JOIN Title t ON adnt.Title_Code= t.Title_Code
	INNER JOIN Ancillary_Type at ON at.Ancillary_Type_Code= adn.Ancillary_Type_code
	WHERE adnt.Title_Code IN (Select number AS TitleCode FROM fn_Split_withdelemiter(@TitleCode,',') where number <> '')
END