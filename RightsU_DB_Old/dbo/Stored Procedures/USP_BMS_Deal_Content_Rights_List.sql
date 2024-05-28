CREATE PROCEDURE [dbo].[USP_BMS_Deal_Content_Rights_List]
	@Language_Code INT
AS
BEGIN
--DECLARE @Language_Code INT=21
	SELECT C.Channel_Name, CONVERT(DATE, BDCR.Start_Date,103), CONVERT(DATE, BDCR.End_Date ,103), BDCR.Error_Description
	FROM BMS_Deal_Content_Rights BDCR
	INNER JOIN Channel C ON C.Channel_Code=BDCR.RU_Channel_Code
	INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code=BDCR.BMS_Asset_Code
	WHERE BA.Language_Code=@Language_Code
END



