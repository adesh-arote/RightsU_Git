
CREATE PROCEDURE [dbo].[USP_Import_Title_Content_UDT]
(
	@Title_Content_UDT Title_Content_UDT READONLY,
	@Deal_Code INT
)
AS
-- =============================================
-- Author:		Anchal Sikarwar / Abhaysingh N. Rajpurohit
-- Create date: 18 Feb 2016
-- Description:	Update Content Name Duration
-- =============================================
BEGIN
	DECLARE @Err_Message NVARCHAR(MAX), @allCount INT, @distinctCount INT
	SET @Err_Message='S~Uploaded Succeccfully'

	select @allCount = COUNT(Title_Content_Code) from @Title_Content_UDT
	select @distinctCount = COUNT(DISTINCT(Title_Content_Code)) from @Title_Content_UDT

	IF(@allCount <> @distinctCount)
	BEGIN
		SET @Err_Message='E~PLease do not fill Title Content Code more then one Time'
	END
	ELSE
	BEGIN
		UPDATE TC SET  
		TC.Episode_Title = CASE WHEN RTRIM(LTRIM(TCU.Episode_Title)) <> '' THEN  RTRIM(LTRIM(TCU.Episode_Title)) ELSE TC.Episode_Title END,
		TC.Duration = CASE WHEN TCU.Duration IS NOT NULL THEN  TCU.Duration ELSE TC.Duration END
		FROM @Title_Content_UDT TCU
		INNER JOIN Title_Content TC ON TC.Title_Content_Code = TCU.Title_Content_Code
	END
	select @Err_Message AS Err_Message
END