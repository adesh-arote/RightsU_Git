CREATE PROCEDURE [dbo].[USP_List_Content_Version] 
(            
	  @Title_Content_Code INT           
)
AS
BEGIN
--DECLARE
--@Duration Decimal
	--DECLARE
	--	@Title_Content_Code INT = 7009
			SET @Title_Content_Code = ISNULL(@Title_Content_Code, 0)  
				SELECT DISTINCT 
				    TCV.Title_Content_Version_Code AS [RU_PROGRAM_FOREIGN_ID],
					V.Version_Code AS [RU_VERSION_ID],
			   		TC.Episode_Title AS [RU_PROGRAM_EPISODE_TITLE],
					TC.Episode_Title AS [RU_PROGRAM_EPG_TITLE],
					TC.Episode_Title AS [RU_PROGRAM_EPISODE_SEASON],
					TC.Episode_Title AS [RU_PROGRAM_LISTING_TITLE],
					CONCAT(TC.Episode_Title ,'-',CAST(TC.Episode_No AS varchar(10))) AS [RU_PROGRAM_TITLE],
					T.Title_Name AS [MAINTITLE],
					ISNULL(TC.Ref_BMS_Content_Code, '') AS [BMS_Content_Code],
				    ISNULL(TC.Synopsis, '') AS [RU_PROGRAM_SYNOPSIS],				
					STUFF((
						SELECT DISTINCT ',' +  CAST(G.Genres_Name AS NVARCHAR(MAX))  FROM Genres  G   
						INNER JOIN Title_Geners TG on T.Title_Code = TG.Title_Code      
						WHERE G.Genres_Code = TG.Genres_Code
						FOR XML PATH(''),root('MyString'), type).value('/MyString[1]','nvarchar(max)') , 1, 1, '')  AS [RU_PROGRAM_GENRE],
					CASE WHEN TCV.Duration IS NULL THEN TC.Duration ELSE TCV.Duration END AS [RU_PROGRAM_DURATION],
					'' AS [RU_PROGRAM_CATEGORY],
					'' AS [RU_VERSION_MEDIA],
					GETDATE() AS RU_PROGRAM_UPDATE_DATETIME,
					'RightsU' AS RU_PROGRAM_UPDATE_USER,
					'RightsU' AS RU_PROGRAM_CREATE_USER,
					'' AS RU_PROGRAM_IS_ARCHVIED
			    	FROM Title_Content TC
						INNER  JOIN Title T ON TC.Title_Code = T.Title_Code
						INNER JOIN Title_Content_Version TCV ON TC.Title_Content_Code = TCV.Title_Content_Code
						INNER JOIN Version V ON TCV.Version_Code = V.Version_Code 
			 WHERE 
		TC.Title_Content_Code = @Title_Content_Code OR @Title_Content_Code = 0 

	--Select 
	-- 0 AS [RU_PROGRAM_FOREIGN_ID],
	-- 0 AS [RU_VERSION_ID], 
	-- '' AS [RU_PROGRAM_EPISODE_TITLE],
	-- '' AS [RU_PROGRAM_EPG_TITLE],
	-- '' AS [RU_PROGRAM_EPISODE_SEASON],
	-- '' AS [RU_PROGRAM_LISTING_TITLE],
	-- '' AS [RU_PROGRAM_TITLE],
	-- '' AS [MAINTITLE],
	-- '' AS BMS_Content_Code,
	-- '' AS [RU_PROGRAM_SYNOPSIS],
	-- '' AS [RU_PROGRAM_GENRE],
	-- @Duration AS [RU_PROGRAM_DURATION],
	-- '' AS [RU_PROGRAM_CATEGORY],
	-- '' AS [RU_VERSION_MEDIA],
	-- GETDATE() AS RU_PROGRAM_UPDATE_DATETIME,
	-- '' AS RU_PROGRAM_UPDATE_USER,
	-- '' AS RU_PROGRAM_CREATE_USER,
	-- '' AS RU_PROGRAM_IS_ARCHVIED
END
