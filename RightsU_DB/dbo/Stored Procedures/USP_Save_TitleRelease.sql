CREATE PROC [dbo].[USP_Save_TitleRelease]
	@Title_Code BIGINT,
	@Release_Type VARCHAR(1),
	@Release_Date VARCHAR(20),
	@Platform_Code VARCHAR(500),
	@Territory_Code VARCHAR(500),
	@Country_Code VARCHAR(500),
	@World_Code VARCHAR(100),
	@Title_Release_Code BIGINT
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Save_TitleRelease]', 'Step 1', 0, 'Started Procedure', 0, ''
		BEGIN TRY
			DECLARE @Is_Error INT
			DECLARE @Result INT 
			DECLARE @Release_Date_Dt DATETIME
			DECLARE @Region_Code VARCHAR(500)
			SET @Result = 0

			SET  @Release_Date_Dt = CONVERT(DATETIME,@Release_Date)

			--IF EXISTS(SELECT Title_Code FROM Title_Release TR INNER JOIN Title_Release_Platforms TRP ON TR.Title_Release_Code = TRP.Title_Release_Code
			--INNER JOIN Title_Release_Region TRR ON TR.Title_Release_Code = TRR.Title_Release_Code
			--WHERE Title_Code = @Title_Code AND TRP.Platform_Code IN (SELECT CAST(splitdata as INT) FROM dbo.fnSplitString(@Platform_Code, ',')) AND 
			--(TRR.Territory_Code IN (SELECT CAST(splitdata as INT) FROM dbo.fnSplitString(@Territory_Code, ',')) OR TRR.Country_Code IN (SELECT CAST(splitdata as INT) FROM dbo.fnSplitString(@Country_Code, ','))))
			--BEGIN
			--	SET @Result = 0
			--END
			--ELSE
			--BEGIN
			--	EXEC USP_Validate_Title_Release @Release_Type,@Release_Date,@Title_Code,@Country_Code,@Territory_Code,@Result = @Result OUTPUT
			--END
		
			--IF (@Result = 1)
			--BEGIN
		
			--	BEGIN TRAN
			--	INSERT INTO Title_Release(Title_Code,Release_Type,Release_Date)
			--	SELECT @Title_Code,@Release_Type,@Release_Date_Dt

			--	SET @Title_Release_Code = SCOPE_IDENTITY()

			--	INSERT INTO Title_Release_Platforms(Title_Release_Code,Platform_Code)
			--	SELECT @Title_Release_Code,CAST(splitdata as INT) FROM dbo.fnSplitString(@Platform_Code, ',')
			

			--	IF(@Territory_Code != '')
			--	BEGIN

			--		INSERT INTO Title_Release_Region(Title_Release_Code,Territory_Code)
			--		SELECT @Title_Release_Code,CAST(splitdata as INT) FROM dbo.fnSplitString(@Territory_Code, ',')

			--	END
			--	ELSE IF(@Country_Code != '')
			--	BEGIN
			--		INSERT INTO Title_Release_Region(Title_Release_Code,Country_Code)
			--		SELECT @Title_Release_Code,CAST(splitdata as INT) FROM dbo.fnSplitString(@Country_Code, ',')
			--	END
			--	ELSE IF(@World_Code != '')
			--	BEGIN
			--		INSERT INTO Title_Release_Region(Title_Release_Code,Territory_Code)
			--		SELECT @Title_Release_Code,@World_Code
			--	END
			--	SET @Is_Error = 1
			--	COMMIT TRAN
			--END
			--ELSE IF(@Result = 0)
			--BEGIN
			--	SET @Is_Error = 0
			--END
			SET @Region_Code = (CASE WHEN @Territory_Code != '' THEN @Territory_Code ELSE @Country_Code END)
		
			IF OBJECT_ID('tempdb..#Temp_Title_Release') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Title_Release
			END

			IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL
			BEGIN
				DROP TABLE #TempPlatform
			END

			IF OBJECT_ID('tempdb..#TempRegion') IS NOT NULL
			BEGIN
				DROP TABLE #TempRegion
			END

			CREATE TABLE #Temp_Title_Release
			(
				RowID INT IDENTITY(1,1),
				Title_Code INT,
				Platform_Code INT,
				Country_Code INT,
				Is_Duplicate CHAR(1)
			)
			BEGIN TRAN
			INSERT INTO #Temp_Title_Release(Title_Code, Platform_Code, Country_Code)
			SELECT DISTINCT TR.Title_Code, TRP.Platform_Code, 
			CASE TR.Release_Type 
				WHEN 'C' THEN TRR.Country_Code 
				WHEN 'T' THEN TD.Country_Code 
				WHEN 'W' THEN C.Country_Code
			END AS Country_Code
			From Title_Release TR (NOLOCK)
			INNER JOIN Title_Release_Platforms TRP (NOLOCK) ON TR.Title_Release_Code = TRP.Title_Release_Code
			INNER JOIN Title_Release_Region TRR (NOLOCK) ON TR.Title_Release_Code = TRR.Title_Release_Code
			LEFT JOIN Territory_Details TD (NOLOCK) ON TD.Territory_Code = TRR.Territory_Code AND TR.Release_Type = 'T'
			LEFT JOIN Country C (NOLOCK) ON TR.Release_Type = 'W'
			WHERE TR.Title_Release_Code <> @Title_Release_Code

			SELECT number AS Platform_Code INTO #TempPlatform FROM DBO.fn_Split_withdelemiter(@Platform_Code, ',')
			SELECT number AS Region_Code INTO #TempRegion FROM DBO.fn_Split_withdelemiter(@Region_Code, ',')

			INSERT INTO #Temp_Title_Release(Title_Code, Platform_Code, Country_Code)
			SELECT TR.Title_Code, TRP.Platform_Code, 
			CASE TR.Release_Type 
				WHEN 'C' THEN TRR.Region_Code 
				WHEN 'T' THEN TD.Country_Code 
				WHEN 'W' THEN C.Country_Code
			END AS Country_Code FROM 
			(SELECT @Title_Release_Code AS Title_Release_Code, @Title_Code AS Title_Code, @Release_Type AS Release_Type) AS TR
			INNER JOIN #TempPlatform TRP ON 1 = 1
			INNER JOIN #TempRegion TRR ON 1 = 1
			LEFT JOIN Territory_Details TD (NOLOCK) ON TD.Territory_Code = TRR.Region_Code AND TR.Release_Type = 'T'
			LEFT JOIN Country C (NOLOCK) ON TR.Release_Type = 'W'

			UPDATE T1 SET T1.Is_Duplicate = 'Y' FROM #Temp_Title_Release T1
			INNER JOIN #Temp_Title_Release T2 ON T1.RowID <> T2.RowID AND T1.Title_Code = T2.Title_Code AND 
			T1.Platform_Code = T2.Platform_Code AND T1.Country_Code = T2.Country_Code

			--SELECT * FROM #Temp_Title_Release
			IF NOT EXISTS (SELECT DISTINCT Title_Code, Platform_Code, Country_Code FROM #Temp_Title_Release where ISNULL(Is_Duplicate, 'N') = 'Y')
			BEGIN
			
				IF(@Title_Release_Code = 0)
				BEGIN
					INSERT INTO Title_Release(Release_Date, Release_Type, Title_Code)
					SELECT @Release_Date, @Release_Type, @Title_Code

					SELECT @Title_Release_Code = SCOPE_IDENTITY()
				END
				ELSE
				BEGIN
					UPDATE Title_Release SET Release_Date = @Release_Date, Release_Type = @Release_Type, @Title_Code = @Title_Code
					WHERE Title_Release_Code = @Title_Release_Code

					DELETE FROM Title_Release_Platforms WHERE Title_Release_Code = @Title_Release_Code
					DELETE FROM Title_Release_Region WHERE Title_Release_Code = @Title_Release_Code
				END

				INSERT INTO Title_Release_Platforms(Title_Release_Code, Platform_Code)
				SELECT @Title_Release_Code, Platform_Code FROM #TempPlatform

				IF(@Release_Type = 'C')
				BEGIN
					INSERT INTO Title_Release_Region(Title_Release_Code, Country_Code)
					SELECT @Title_Release_Code, Region_Code FROM #TempRegion
				END
				ELSE
				BEGIN
					INSERT INTO Title_Release_Region(Title_Release_Code, Territory_Code)
					SELECT @Title_Release_Code, Region_Code FROM #TempRegion
				END

				SET @Is_Error = 1
			
			END
			ELSE
			BEGIN
				SET @Is_Error = 0
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			SET @Is_Error = 0
		END CATCH
	
		SELECT @Is_Error

		IF OBJECT_ID('tempdb..#Temp_Title_Release') IS NOT NULL DROP TABLE #Temp_Title_Release
		IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
		IF OBJECT_ID('tempdb..#TempRegion') IS NOT NULL DROP TABLE #TempRegion
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Save_TitleRelease]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END