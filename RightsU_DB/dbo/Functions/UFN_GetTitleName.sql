CREATE FUNCTION [dbo].[UFN_GetTitleName]
(	
	@Acq_DealAncillary_Code INT,
	@Title_Codes VARCHAR(MAX),
	@Deal_Type VARCHAR(30)
)
RETURNS NVARCHAR(MAX)       
AS      
BEGIN       	
	DECLARE @TitleName NVARCHAR(MAX)
	SET @TitleName=''

	SELECT @TitleName = Stuff ((
		SELECT DISTINCT ', '+  Title_Name FROM	(
			SELECT	dbo.UFN_GetTitleNameInFormat(@Deal_Type, ISNULL(T.Title_Name,''), ADAT.Episode_From, ADAT.Episode_To) AS Title_Name
			FROM Title T 
			INNER JOIN Acq_Deal_Ancillary_Title ADAT ON ADAT.Title_Code = T.Title_Code AND ADAT.Acq_Deal_Ancillary_Code = @Acq_DealAncillary_Code
			WHERE 1= 1 AND (
				ISNULL(@Title_Codes,'')<>'' AND ADAT.Title_Code IN (Select Number FROM fn_Split_withdelemiter(@Title_Codes,',')) OR 
				ISNULL(@Title_Codes,'')=''
			)			
		) AS temp FOR XML PATH('')), 1, 1, '')
	SELECT @TitleName = REPLACE(@TitleName, '&amp;', '&')
	RETURN @TitleName
END      