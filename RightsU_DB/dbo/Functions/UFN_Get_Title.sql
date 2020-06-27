CREATE FUNCTION [dbo].[UFN_Get_Title]    
(    
 @Deal_Code AS INT,
 @Type Char(1)   
)     
RETURNS NVARCHAR(MAX)     
AS 
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 09-October-2014
-- Description:	Get CSV Titles
-- =============================================       
BEGIN     
	-- Declare return variable here     
	DECLARE  @retStr AS NVARCHAR(MAX)    
	SET @retStr = ''    
            
	DECLARE @OriginalTitles AS NVARCHAR(MAX)          
	SET @OriginalTitles = ''

	IF(@Type = 'A') 
	BEGIN
		SELECT @OriginalTitles +=  Title_Name + ', '
		FROM (
			SELECT DISTINCT TOP 3 ISNULL(Title_Name,Original_Title) AS Title_Name
			FROM Acq_Deal_Movie ADM with(nolock)      
			INNER JOIN Title T with(nolock) On T.title_code = ADM.Title_Code    
			WHERE ADM.Acq_Deal_Code = @Deal_Code 
		) TEMP
	END
	ELSE 
	BEGIN
		SELECT @OriginalTitles +=  Title_Name + ', '
		FROM (
			SELECT DISTINCT TOP 3 ISNULL(Title_Name,Original_Title) AS Title_Name
			FROM Syn_Deal_Movie SDM    with(nolock)   
			INNER JOIN Title T with(nolock) On T.title_code = SDM.Title_Code    
			WHERE SDM.Syn_Deal_Code = @Deal_Code 
		) TEMP
	END

	SET @retStr = SUBSTRING(@OriginalTitles,0,LEN(@OriginalTitles))    
	RETURN @retStr    
END