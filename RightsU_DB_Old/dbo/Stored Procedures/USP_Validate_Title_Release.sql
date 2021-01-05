
--DECLARE @Result INT
--EXEC USP_Validate_Title_Release 'C','08 Jun 2016',677,'42','',@Result = @Result OUTPUT
--SELECT @Result

CREATE PROC USP_Validate_Title_Release
	@Release_Type VARCHAR(1),
	@Release_Date VARCHAR(20),
	@Title_Code BIGINT,
	@Country_Code VARCHAR(500),
	@Territory_Code VARCHAR(500),
	@Result INT OUTPUT
AS
BEGIN
	DECLARE @Territory_Details_Temp TABLE
	(
		Territory_Code INT,
		Country_Code INT
	)
	--World
	DECLARE @Release_Type_Table VARCHAR(1)
	SET @Result = 1
	
	BEGIN
		SELECT @Release_Type_Table  = Release_Type 
		FROM Title_Release 
		WHERE Title_Code = @Title_Code

		IF((@Release_Type_Table = 'W' AND (@Release_Type = 'T' OR @Release_Type = 'C')) OR @Release_Type = 'W' AND (@Release_Type_Table = 'T' OR @Release_Type_Table = 'C'))
		BEGIN
		PRINT 1
			SET @Result = 0
		END
		ELSE
		BEGIN
			IF (@Release_Type = 'T')
			BEGIN
			PRINT 2
				INSERT INTO @Territory_Details_Temp(Territory_Code,Country_Code)
				SELECT Territory_Code,Country_Code 
				FROM Territory_Details 
				WHERE Territory_Code = @Territory_Code

				INSERT INTO @Territory_Details_Temp(Country_Code)
				SELECT TRR.Country_Code
				FROM Title_Release_Region TRR INNER JOIN Title_Release TR 
				ON TRR.Title_Release_Code = TR.Title_Release_Code 
				WHERE TR.Title_Code= @Title_Code

				IF EXISTS(SELECT Country_Code,Count(*) FROM @Territory_Details_Temp GROUP BY Country_Code HAVING Count(*) > 1)
				BEGIN
					SET @Result = 0
				END

			END
			ELSE IF (@Release_Type = 'C')
			BEGIN
			PRINT 3
				INSERT INTO @Territory_Details_Temp(Territory_Code,Country_Code)
				SELECT Territory_Code,Country_Code 
				FROM Territory_Details 
				WHERE Territory_Code IN (SELECT TRR.Territory_Code
				FROM Title_Release_Region TRR INNER JOIN Title_Release TR 
				ON TRR.Title_Release_Code = TR.Title_Release_Code WHERE TR.Title_Code= @Title_Code)

				INSERT INTO @Territory_Details_Temp(Country_Code)
				SELECT @Country_Code

				IF EXISTS(SELECT Country_Code,Count(*) FROM @Territory_Details_Temp GROUP BY Country_Code HAVING Count(*) > 1)
				BEGIN
					SET @Result = 0
				END
			END
		END
		
		RETURN @Result
	END
	--ELSE
	--BEGIN
	--	RETURN @Result
	--END
END