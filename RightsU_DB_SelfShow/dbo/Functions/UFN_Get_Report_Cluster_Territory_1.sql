CREATE FUNCTION [dbo].[UFN_Get_Report_Cluster_Territory](@Country_Codes VARCHAR(2000), @RowId INT, @Territory_Codes VARCHAR(2000), @Is_IFTA_Cluster CHAR(1))    
RETURNS @Tbl_Ret TABLE (    
	Region_Code INT,    
	Full_Cluster_Name NVARCHAR(MAX),    
	Partial_Cluster_Name NVARCHAR(MAX),    
	Region_Name NVARCHAR(MAX)    
) AS    
BEGIN    
	-- Declare @Country_Codes Varchar(2000) = '10,125,130,133,135,142,149,184,200,210,224,229,247,264,305',  
	--	@RowId INT = 1,  
	--	@Territory_Codes Varchar(1000) = 'T34',
	--	@Is_IFTA_Cluster CHAR(1) = 'Y'
	--Declare @Tbl_Ret TABLE (  
	-- Region_Code INT,    
	-- Full_Cluster_Name NVARCHAR(MAX),    
	-- Partial_Cluster_Name NVARCHAR(MAX),    
	-- Region_Name NVARCHAR(MAX)    
	--)
	DECLARE @InclPercent Int = 50
    
	DECLARE @Temp_Country_In AS TABLE(
		Country_Code INT,
		Report_Territory_Code INT
	)
     
	DECLARE @Temp_Country_NIn AS TABLE(    
		Country_Code INT,    
		Report_Territory_Code INT    
	)    
     
	DECLARE @Temp_Territory AS TABLE(    
		Report_Territory_Code INT,    
		DB_Cnt INT,    
		In_Cnt INT,    
		NIn_Cnt INT,    
		In_Percent DECIMAL(18,2),    
		Eligible CHAR(1),    
		Exclusion_Countries NVARCHAR(Max)    
	) 

	DECLARE @Temp_Report_Territory AS TABLE(
		Territory_Code INT 
	)
	
	DECLARE @All_Expected_Territory AS TABLE(
		Report_Territory_Code INT,
		Is_Child CHAR(1)
	)

	DECLARE @Is_Language_Cluster CHAR(1) = 'N', @Child_Codes VARCHAR(2000), @Parent_Codes VARCHAR(2000) , @Is_Child CHAR(1)= 'N', @Is_Parent  CHAR(1) = 'N' 
		Declare @WorldCode Int = 0, @All_Territory_Count Int = 0, @Full_Avail_Territory Int = 0
		DECLARE @Full_Cluster_Name NVARCHAR(MAX) = '', @Partial_Cluster_Name NVARCHAR(MAX)='',@PartialCountries NVARCHAR(MAX)='',@Countries_Name NVARCHAR(MAX) = ''   
		
	INSERT INTO @Temp_Report_Territory(Territory_Code)
	SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Territory_Codes, ',') WHERE number LIKE 'T%' AND number NOT IN('0')


	IF(@Is_IFTA_Cluster = 'Y')
	BEGIN
	
  		SELECT @WorldCode = Report_Territory_Code FROM Report_Territory WHERE Report_Territory_Name = 'World'
		
		INSERT INTO @All_Expected_Territory(Report_Territory_Code, Is_Child)
		SELECT DISTINCT rtc.Report_Territory_Code, 'N' FROM Report_Territory_Country rtc
		INNER JOIN dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') ON ISNULL(number, '') <> '' AND CAST(number AS INT) = rtc.Country_Code
		INNER JOIN Report_Territory rt ON rt.Report_Territory_Code = rtc.Report_Territory_Code AND Is_Language_Cluster = 'N' AND ISNULL(Parent_Territory_Code, 0) = 0

	

		INSERT INTO @All_Expected_Territory(Report_Territory_Code, Is_Child)
		SELECT DISTINCT Report_Territory_Code, 'Y' From Report_Territory
		Where Report_Territory_Code IN(SELECT Territory_Code FROM @Temp_Report_Territory) AND Is_Language_Cluster = 'Y'
					
		INSERT INTO @All_Expected_Territory(Report_Territory_Code, Is_Child)
		SELECT DISTINCT Report_Territory_Code, 'Y' From Report_Territory
		Where Report_Territory_Code IN(SELECT Territory_Code FROM @Temp_Report_Territory) AND ISNULL(Parent_Territory_Code, 0) > 0

		IF EXISTS(SELECT TOP 1 * FROM @All_Expected_Territory WHERE Is_Child = 'Y')
		BEGIN
			DELETE FROM @All_Expected_Territory WHERE Is_Child = 'N'

			INSERT INTO @All_Expected_Territory(Report_Territory_Code, Is_Child)
			SELECT DISTINCT selTer.Territory_Code, 'N' FROM @Temp_Report_Territory selTer
			INNER JOIN Report_Territory rt ON rt.Report_Territory_Code = selTer.Territory_Code AND Is_Language_Cluster = 'N' AND ISNULL(Parent_Territory_Code, 0) = 0
		END
		
		INSERT INTO @Temp_Territory(Report_Territory_Code, DB_Cnt, Eligible, Exclusion_Countries)    
		SELECT Report_Territory_Code, (    
			SELECT COUNT(*) FROM Report_Territory_Country trc2 WHERE trc2.Report_Territory_Code = trc1.Report_Territory_Code AND trc2.Country_Code IN (    
				SELECT Country_Code FROM Country WHERE Is_Active = 'Y'    
			)
		), 'N', ''    
		FROM @All_Expected_Territory trc1
		
		UPDATE @Temp_Territory SET In_Percent = ((DB_Cnt * @InclPercent) / 100.0)    
    
		INSERT INTO @Temp_Country_In(Country_Code, Report_Territory_Code)    
		SELECT Country_Code, Report_Territory_Code FROM Report_Territory_Country rtc    
		INNER JOIN dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') ON ISNULL(number, '') <> '' AND CAST(number AS INT) = rtc.Country_Code

		--IF(@Territory_Codes = 'T' + CAST(@WorldCode AS VARCHAR))
		--BEGIN
		--	INSERT INTO @Temp_Country_In(Country_Code, Report_Territory_Code)    
		--	SELECT Country_Code, Report_Territory_Code FROM Report_Territory_Country rtc    
		--	INNER JOIN dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') ON ISNULL(number, '') <> '' AND CAST(number AS INT) = rtc.Country_Code
		-- END
		-- ELSe
		-- BEGIN
	 --		INSERT INTO @Temp_Country_In(Country_Code, Report_Territory_Code)    
		--	SELECT Country_Code, Report_Territory_Code FROM Report_Territory_Country rtc    
		--	INNER JOIN dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') ON ISNULL(number, '') <> '' AND CAST(number AS INT) = rtc.Country_Code
		--	WHERE rtc.Report_Territory_Code IN(SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Territory_Codes, ',') WHERE number LIKE 'T%' AND number NOT IN('0'))  
		--END

		INSERT INTO @Temp_Country_NIn(Country_Code, Report_Territory_Code)    
		SELECT Country_Code, Report_Territory_Code FROM Report_Territory_Country rtc WHERE rtc.Country_Code NOT IN (    
			SELECT CAST(number AS INT) FROM dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') WHERE ISNULL(number, '') <> ''    
		)    
     
		UPDATE t1 SET In_Cnt = (    
			SELECT COUNT(*) FROM @Temp_Country_In t2 WHERE t1.Report_Territory_Code = t2.Report_Territory_Code    
		)    
		FROM @Temp_Territory t1    
     
		DELETE FROM @Temp_Territory WHERE In_Cnt = 0    
    
		UPDATE @Temp_Territory SET NIn_Cnt = DB_Cnt - In_Cnt    


		UPDATE @Temp_Territory SET Eligible = 'Y' WHERE In_Cnt > In_Percent    
    
		IF EXISTS (SELECT TOP 1 * FROM @Temp_Territory WHERE NIn_Cnt = 0 AND Report_Territory_Code = @WorldCode)    
		BEGIN    
			INSERT INTO @Tbl_Ret(Region_Code, Region_Name, Full_Cluster_Name)    
			SELECT @RowId, '', 'World'    
		END    
		ELSE    
		BEGIN      
      
			SELECT @All_Territory_Count = COUNT(*) FROM Report_Territory WHERE Report_Territory_Code <> @WorldCode    
			SELECT @Full_Avail_Territory = COUNT(*) FROM @Temp_Territory WHERE NIn_Cnt = 0 And Report_Territory_Code <> @WorldCode    
    
			--IF(@Full_Avail_Territory > ((@All_Territory_Count * @InclPercent) / 100.0))
			--BEGIN    
       
			--	SEt @Full_Cluster_Name = LTRIM(STUFF(    
			--	(    
			--	SELECT DISTINCT ', ' + rt.Report_Territory_Name + ' (Partial)' FROM @Temp_Territory tt    
			--	Inner Join Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code And NIn_Cnt <> 0    
			--	FOR XML PATH('')    
			--	), 1, 1, ''))    
    
			--	SET @Full_Cluster_Name = 'World Excluding ' + @Full_Cluster_Name    
			--END    
			--ELSE    
			BEGIN    
    
				SET @Full_Cluster_Name = LTRIM(STUFF(    
				(    
				SELECT DISTINCT ', ' + rt.Report_Territory_Name FROM @Temp_Territory tt    
				Inner Join Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code AND NIn_Cnt = 0    
				FOR XML PATH('')    
				), 1, 1, ''))    
			END    
      
			UPDATE t1 SET Exclusion_Countries =  LTRIM(STUFF(    
			(    
				SELECT DISTINCT ', ' + Country_Name FROM @Temp_Country_NIn tcn    
				INNER JOIN Country c On c.Country_Code = tcn.Country_Code    
				WHERE t1.Report_Territory_Code = tcn.Report_Territory_Code-- And tcn.Report_Territory_Code <> @WorldCode    
				FOR XML PATH('')    
			), 1, 1, ''))    
			FROM @Temp_Territory t1 WHERE Eligible = 'Y' AND NIn_Cnt <> 0    
    
			SET @Partial_Cluster_Name = ISNULL(LTRIM(STUFF(    
			(    
				SELECT '; ' + rt.Report_Territory_Name + ' Excluding (' + Exclusion_Countries + ')' FROM @Temp_Territory tt    
				INNER JOIN Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code AND Exclusion_Countries <> '' AND Eligible = 'Y'    
				FOR XML PATH('')    
			), 1, 1, '')), '')    
   
			SET @PartialCountries  = ISNULL(LTRIM(STUFF(    
			(    
				SELECT DISTINCT ', ' + rt.Report_Territory_Name + ' (Partial)' FROM @Temp_Territory tt    
				INNER JOIN Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code And Exclusion_Countries <> '' AND Eligible = 'Y'    
				FOR XML PATH('')    
			), 1, 1, '')), '')    
 
		IF(@Full_Cluster_Name Is NULL)  
		BEGIN  
			SET @Full_Cluster_Name = @PartialCountries    
		END  
		ELSE IF(@PartialCountries IS NULL OR @PartialCountries = '')
		BEGIN
			SET @Full_Cluster_Name = @Full_Cluster_Name
		END   
		ELSE
		BEGIN  
			SET @Full_Cluster_Name = @Full_Cluster_Name+ ', ' + @PartialCountries    
		END  

		SET @Countries_Name  = ISNULL(LTRIM(STUFF(    
		(    
			SELECT DISTINCT ', ' + Country_Name FROM @Temp_Territory tt
			INNER JOIN @Temp_Country_In tcn ON tt.Report_Territory_Code = tcn.Report_Territory_Code AND Eligible = 'N' --And tt.Report_Territory_Code <> @WorldCode    
			INNER JOIN Country c ON c.Country_Code = tcn.Country_Code    
			WHERE tcn.Country_Code NOT IN (
				SELECT tcn1.Country_Code
				FROM @Temp_Territory tt1
				INNER JOIN @Temp_Country_In tcn1 ON tt1.Report_Territory_Code = tcn1.Report_Territory_Code AND tt1.Eligible = 'Y'
			)
			FOR XML PATH('')    
		), 1, 1, '')), '')    
      
		INSERT INTO @Tbl_Ret(Region_Code, Region_Name, Full_Cluster_Name, Partial_Cluster_Name)    
		SELECT @RowId, @Countries_Name, @Full_Cluster_Name, @Partial_Cluster_Name    
	 END    
END
ELSE
BEGIN
	INSERT INTO @Temp_Territory(Report_Territory_Code, DB_Cnt, Eligible, Exclusion_Countries)    
		SELECT Report_Territory_Code, (    
			SELECT COUNT(*) FROM Report_Territory_Country trc2 WHERE trc2.Report_Territory_Code = trc1.Report_Territory_Code AND trc2.Country_Code IN (    
				SELECT Country_Code FROM Country WHERE Is_Active = 'Y'    
			)    
		), 'N', ''    
	FROM Report_Territory trc1    
  
	UPDATE @Temp_Territory SET In_Percent = ((DB_Cnt * @InclPercent) / 100.0)    
    
	INSERT INTO @Temp_Country_In(Country_Code, Report_Territory_Code)    
	SELECT Country_Code, Report_Territory_Code FROM Report_Territory_Country rtc    
	INNER JOIN dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') ON ISNULL(number, '') <> '' AND CAST(number AS INT) = rtc.Country_Code
     
	INSERT INTO @Temp_Country_NIn(Country_Code, Report_Territory_Code)    
	SELECT Country_Code, Report_Territory_Code FROM Report_Territory_Country rtc WHERE rtc.Country_Code NOT IN (    
	SELECT CAST(number AS INT) FROM dbo.fn_Split_withdelemiter(ISNULL(@Country_Codes, ''), ',') WHERE ISNULL(number, '') <> ''    
	)    
     
	UPDATE t1 SET In_Cnt = (    
		SELECT COUNT(*) FROM @Temp_Country_In t2 WHERE t1.Report_Territory_Code = t2.Report_Territory_Code    
	)    
	FROM @Temp_Territory t1    
     
	DELETE FROM @Temp_Territory WHERE In_Cnt = 0    
    
	UPDATE @Temp_Territory SET NIn_Cnt = DB_Cnt - In_Cnt    


	UPDATE @Temp_Territory SET Eligible = 'Y' WHERE In_Cnt > In_Percent    
    
    
	SELECT @WorldCode = Report_Territory_Code FROM Report_Territory WHERE Report_Territory_Name = 'World'    
    
	IF EXISTS (SELECT TOP 1 * FROM @Temp_Territory WHERE NIn_Cnt = 0 AND Report_Territory_Code = @WorldCode)    
	BEGIN    
		INSERT INTO @Tbl_Ret(Region_Code, Region_Name, Full_Cluster_Name)    
		SELECT @RowId, '', 'World'    
	END    
	ELSE    
	BEGIN    
		
		SELECT @All_Territory_Count = COUNT(*) FROM Report_Territory WHERE Report_Territory_Code <> @WorldCode    
		SELECT @Full_Avail_Territory = COUNT(*) FROM @Temp_Territory WHERE NIn_Cnt = 0 And Report_Territory_Code <> @WorldCode    
    
		IF(@Full_Avail_Territory > ((@All_Territory_Count * @InclPercent) / 100.0))    
		BEGIN    
       
			SEt @Full_Cluster_Name = LTRIM(STUFF(    
			(    
			SELECT DISTINCT ', ' + rt.Report_Territory_Name + ' (Partial)' FROM @Temp_Territory tt    
			Inner Join Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code And NIn_Cnt <> 0    
			FOR XML PATH('')    
			), 1, 1, ''))    
    
			SET @Full_Cluster_Name = 'World Excluding ' + @Full_Cluster_Name    
		END    
		ELSE    
		BEGIN    
    
			SET @Full_Cluster_Name = LTRIM(STUFF(    
			(    
			SELECT DISTINCT ', ' + rt.Report_Territory_Name FROM @Temp_Territory tt    
			Inner Join Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code AND NIn_Cnt = 0    
			FOR XML PATH('')    
			), 1, 1, ''))    
		END    
      
		UPDATE t1 SET Exclusion_Countries =  LTRIM(STUFF(    
		(    
			SELECT DISTINCT ', ' + Country_Name FROM @Temp_Country_NIn tcn    
			INNER JOIN Country c On c.Country_Code = tcn.Country_Code    
			WHERE t1.Report_Territory_Code = tcn.Report_Territory_Code-- And tcn.Report_Territory_Code <> @WorldCode    
			FOR XML PATH('')    
		), 1, 1, ''))    
		FROM @Temp_Territory t1 WHERE Eligible = 'Y' AND NIn_Cnt <> 0    
    
		SET @Partial_Cluster_Name= ISNULL(LTRIM(STUFF(    
		(    
			SELECT '; ' + rt.Report_Territory_Name + ' Excluding (' + Exclusion_Countries + ')' FROM @Temp_Territory tt    
			INNER JOIN Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code AND Exclusion_Countries <> '' AND Eligible = 'Y'    
			FOR XML PATH('')    
		), 1, 1, '')), '')    
   
		SET @PartialCountries  = ISNULL(LTRIM(STUFF(    
		(    
			SELECT DISTINCT ', ' + rt.Report_Territory_Name + ' (Partial)' FROM @Temp_Territory tt    
			INNER JOIN Report_Territory rt ON tt.Report_Territory_Code = rt.Report_Territory_Code And Exclusion_Countries <> '' AND Eligible = 'Y'    
			FOR XML PATH('')    
		), 1, 1, '')), '')    
 
	IF(@Full_Cluster_Name Is NULL)  
	BEGIN  
		SET @Full_Cluster_Name = @PartialCountries    
	END  
	ELSE IF(@PartialCountries IS NULL OR @PartialCountries = '')
	BEGIN
	 SET @Full_Cluster_Name = @Full_Cluster_Name
	END   
	ELSE
	BEGIN  
		SET @Full_Cluster_Name = @Full_Cluster_Name+ ', ' + @PartialCountries    
	END  
  
	SET @Countries_Name  = ISNULL(LTRIM(STUFF(    
		(    
			SELECT DISTINCT ', ' + Country_Name FROM @Temp_Territory tt
			INNER JOIN @Temp_Country_In tcn ON tt.Report_Territory_Code = tcn.Report_Territory_Code AND Eligible = 'N' --And tt.Report_Territory_Code <> @WorldCode    
			INNER JOIN Country c ON c.Country_Code = tcn.Country_Code    
			WHERE tcn.Country_Code NOT IN (
				SELECT tcn1.Country_Code
				FROM @Temp_Territory tt1
				INNER JOIN @Temp_Country_In tcn1 ON tt1.Report_Territory_Code = tcn1.Report_Territory_Code AND tt1.Eligible = 'Y'
			)
			FOR XML PATH('')    
		), 1, 1, '')), '')     
      
	INSERT INTO @Tbl_Ret(Region_Code, Region_Name, Full_Cluster_Name, Partial_Cluster_Name)    
	SELECT @RowId, @Countries_Name, @Full_Cluster_Name, @Partial_Cluster_Name    
	END
END 
-- select *from @Tbl_Ret
RETURN     
END