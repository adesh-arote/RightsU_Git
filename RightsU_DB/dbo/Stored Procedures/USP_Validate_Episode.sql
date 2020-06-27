CREATE PROC [dbo].[USP_Validate_Episode]
(
	@Title_with_Episode NVARCHAR(max),
	@Program_Type CHAR(1)
)
AS 
BEGIN
	--DECLARE @Title_with_Episode varchar(max)
	--set @Title_with_Episode = ''
	--set @Title_with_Episode  = '808~1,808~500'

	IF OBJECT_ID('tempdb..#Invalid_Episode_ID') IS NOT NULL
	BEGIN
		DROP TABLE #Invalid_Episode_ID
	END
	
	CREATE TABLE #Invalid_Episode_ID
	(
		Title NVARCHAR(MAX), Episode_Id  VARCHAR(4000)
	)
	DECLARE  @tbl AS TABLE(id INT,number VARCHAR(max))
	DECLARE  @Title_Episode_Cur NVARCHAR(MAX) = '', @Title_Cur INT = 0, @Episode_Cur INT= 0

	INSERT INTO @tbl                                          
	SELECT * FROM [DBO].[FN_SPLIT_WITHDELEMITER](@Title_with_Episode ,',')
	
	BEGIN TRY
		DECLARE CR_Title_HouseID_Data CURSOR
		FOR 
		SELECT number FROM @tbl
		OPEN CR_Title_HouseID_Data
		FETCH NEXT FROM CR_Title_HouseID_Data INTO  @Title_Episode_Cur
		WHILE @@FETCH_STATUS<>-1
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				SELECT @Title_Cur = CASE WHEN number = '' THEN 0 ELSE CAST(number AS INT) END  FROM [DBO].[FN_SPLIT_WITHDELEMITER](@Title_Episode_Cur ,'~')
				WHERE id = 1
				SELECT @Episode_Cur = CASE WHEN number = '' THEN 0 ELSE CAST(number AS INT) END  FROM [DBO].[FN_SPLIT_WITHDELEMITER](@Title_Episode_Cur ,'~')
				WHERE id = 2
				IF
				(
					(
						SELECT COUNT(TCM.Acq_Deal_Movie_Code) + COUNT(TCM.Provisional_Deal_Title_Code) FROM Title_Content_Mapping TCM
						INNER JOIN Title_Content TC ON TC.Title_Content_Code = TCM.Title_Content_Code
						AND ((TC.Title_Code in (@Title_Cur) AND @Program_Type ='M')
						OR (TCM.Acq_Deal_Movie_Code in (@Title_Cur) AND @Program_Type ='S')) AND TC.Episode_No IN (@Episode_Cur)


					) <= 0
				)
				BEGIN
					INSERT INTO #Invalid_Episode_ID
					SELECT @Title_Cur,@Episode_Cur
				END
			END            
		FETCH NEXT FROM CR_Title_HouseID_Data INTO  @Title_Episode_Cur
		END                                                       
		CLOSE CR_Title_HouseID_Data            
		DEALLOCATE CR_Title_HouseID_Data
	END TRY 
	BEGIN CATCH
		CLOSE CR_Title_HouseID_Data            
		DEALLOCATE CR_Title_HouseID_Data	
	END CATCH

	SELECT t.Title_Name AS TitleName, temp.Episode_Id AS EpisodeNo FROM #Invalid_Episode_ID Temp
	INNER JOIN Title T ON T.Title_Code  = temp.Title

	IF OBJECT_ID('tempdb..#Invalid_Episode_ID') IS NOT NULL
	BEGIN
		DROP TABLE #Invalid_Episode_ID
	END
END



/* 
	EXEC dbo.USP_Validate_Episode '808~1,808~500' 

*/