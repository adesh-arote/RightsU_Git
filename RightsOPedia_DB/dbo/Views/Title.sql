


CREATE VIEW [dbo].[Title]
AS
SELECT Title_Code, Title_Name, Title_Language_Code, Year_Of_Production, Duration_In_Min, Deal_Type_Code FROM RightsU_Plus_Testing.dbo.Title
WHERE Reference_Flag IS NULL AND Title_Code IN (
	SELECT DISTINCT Title_Code FROM RightsU_Plus_Testing.dbo.Acq_Deal_Movie
)





