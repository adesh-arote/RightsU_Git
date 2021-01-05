CREATE PROC [dbo].[USP_BMS_Generate_Xml_Deal]
(
    @Type VARCHAR(10),
    @Code INT
)
AS
--    ==========================
--    Author		:   Abhaysingh N. Rajpurohit   
--    Created On    :   29 September 2015
--    Description   :   Generate XML from table format
--    Notes			:   This procedure will return recordset(table) with five columns (1. Code, 2. XML_Data, 3. Method_Type, 4. Method_Url, 5. BMS_Log_Code)
--						In case of @Type = 'BMS_D' returning table will contain value of 'Code' column as BMS_Deal_Code and will catain always 1 record per batch,
--						In case of @Type != 'BMS_D' returnig table will contain value of 'Code' column as '0' and record per batch is configured
--    ==========================
BEGIN

    --DECLARE @Type VARCHAR(10) = 'BMS_DCR', @Code INT = 0
    DECLARE @no_Of_Record_In_Batch INT  = 1 , @no_Of_Record_In_Batch_Deal INT  = 1 , @no_Of_Record_In_Batch_Master INT  = 1 ,
    @recordCount INT = 0, @noOfBatches INT = 0 ,@batchNo INT  = 1, @BaseAddress VARCHAR(MAX) = '',@RequestUri VARCHAR(100) = '', @moduleName VARCHAR(MAX)

    SELECT TOP 1 @no_Of_Record_In_Batch_Deal = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'BMS_No_Of_Record_In_Batch_Deal' AND IsActive = 'Y'
    SELECT TOP 1 @no_Of_Record_In_Batch_Master = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'BMS_No_Of_Record_In_Batch_Master' AND IsActive = 'Y'
	
    IF OBJECT_ID('TEMPDB..#Temp_Xml_Data') IS NOT NULL
    BEGIN
        DROP TABLE #Temp_Xml_Data
    END

    CREATE TABLE #Temp_Xml_Data
    (
        Code INT,
        Xml_Data NVARCHAR(MAX),
        Method_Type VARCHAR(10),
       -- Method_Url VARCHAR(MAX),
		BaseAddress NVARCHAR(100),
		RequestUri NVARCHAR(100),
        BMS_Log_Code INT
    )


    IF(@Type = 'RUBVD')
    BEGIN
        --SET @BaseAddress = 'http://172.31.24.36:8080/rightsu-service/rest/Deal/'
        SET @moduleName = 'BMS_Deal'
        SELECT 
			TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
		FROM BMS_All_Masters WHERE Method_Type = 'P' AND Module_Name = @moduleName AND Is_Active = 'Y'
        INSERT INTO #Temp_Xml_Data(Code, Xml_Data, Method_Type,BaseAddress, RequestUri)
        SELECT bvD2.BMS_Deal_Code AS Code, '<?xml version="1.0" ?>' + (
            SELECT
                ISNULL(bvD.BMS_Deal_Ref_Key, 0) AS [Key],
                'RUBMSBVD' + CAST(bvD.BMS_Deal_Code AS VARCHAR) AS [ForeignId],
                bvD.BMS_Licensor_Code AS [LicensorId],
                bvD.BMS_Payee_Code AS [PayeeId],
                bvD.BMS_Currency_Code AS [CurrencyId],
                bvD.Status_SLUId AS [StatusSLUId],
                bvD.BMS_Licensee_Code AS [LicenseeId],
                bvD.BMS_Category_Code AS [DealCategoryId],
                bvD.Type_SLUId AS [TypeSLUId],
                ISNULL(bvD.License_Fees, 0) AS [LicenseFee],
                bvD.[Start_Date] AS [StartDate],
                bvD.End_Date AS [EndDate],
                bvD.[Description] AS [Description],
				bvD.Acquisition_Date AS [AcquisitionDate],
                bvD.Revision AS [Revision],
                bvD.Contact AS [Contact],
                bvD.Lic_Ref_No AS [LicensorReferenceNo],
                Is_Archived AS [IsArchived]
            FROM BMS_Deal bvD
            WHERE bvD.BMS_Deal_Code = bvD2.BMS_Deal_Code
            AND ISNULL(bvD.BMS_Licensor_Code, 0) > 0 AND ISNULL(bvD.BMS_Category_Code, 0) > 0
            AND ISNULL(bvD.Record_Status, '') IN ('P')
            ORDER BY bvD.BMS_Deal_Code ASC
            FOR XML PATH('Deal')
        ) AS Xml_Data, CASE WHEN ISNULL(bvD2.BMS_Deal_Ref_Key , '') = '' THEN 'POST' ELSE 'PUT' END AS Method_Type,
        @BaseAddress AS BaseAddress,@RequestUri AS RequestUri
        FROM BMS_Deal bvD2
        WHERE ISNULL(bvD2.Record_Status, '') IN ('P')
        AND ISNULL(bvD2.BMS_Licensor_Code, 0) > 0 AND ISNULL(bvD2.BMS_Category_Code, 0) > 0

        -- W = Waiting for response
        UPDATE BMS_Deal SET Record_Status = 'W', Request_Time = GETDATE()
        WHERE BMS_Deal_Code IN (SELECT DISTINCT Code FROM #Temp_Xml_Data)
    END
    ELSE
    BEGIN
        DECLARE @i INT = 1
        WHILE ( @i <= 2)
        BEGIN
            -- @i = 1, It means generate XML data for Post
            -- @i = 2, It means generate XML data for PUT
            SET @recordCount = 0
            SET @noOfBatches = 0
            SET @batchNo = 1
            IF(@Type = 'RUBVA')
            BEGIN
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Deal
                SELECT @recordCount = COUNT(*)
                FROM BMS_Asset bvA
                WHERE (bvA.BMS_Asset_Code IN (SELECT BMS_Asset_Code FROM BMS_Deal_Content WHERE BMS_Deal_Code = @Code) OR @Code = 0)
                AND (
                    (ISNULL(LTRIM(RTRIM(bvA.BMS_Asset_Ref_Key)), 0) = 0 AND @i = 1) OR
                    (ISNULL(LTRIM(RTRIM(bvA.BMS_Asset_Ref_Key)), 0) > 0 AND @i = 2)
                )
                --AND ISNULL(LTRIM(RTRIM(bvA.Ref_BMS_ProgramCategroy)), 0) > 0
                AND ISNULL(bvA.Record_Status, '') IN ('P') 
				AND ISNULL(IS_Consider,'Y') <> 'N'
            END
			ELSE IF(@Type = 'RUBVPV')
            BEGIN
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Deal
                SELECT @recordCount = COUNT(*)
                FROM BMS_ProgramVersion bvA
                WHERE 
				--(bvA.BMS_Asset_Code IN (SELECT BMS_Asset_Code FROM BMS_Deal_Content WHERE BMS_Deal_Code = @Code) OR @Code = 0)
				1 =1 
                AND 
				(
                    (ISNULL(LTRIM(RTRIM(bvA.BMS_ProgramVersion_Ref_Key)), 0) = 0 AND @i = 1) OR
                    (ISNULL(LTRIM(RTRIM(bvA.BMS_ProgramVersion_Ref_Key)), 0) > 0 AND @i = 2)
                )
                AND ISNULL(LTRIM(RTRIM(bvA.AssetId)), 0) > 0
                AND ISNULL(bvA.Record_Status, '') IN ('P')

				--SELECT @recordCount AS recordCount 
            END

            ELSE IF(@Type = 'RUBVDC')
            BEGIN
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Deal
                SELECT @recordCount = COUNT(*)
                FROM BMS_Deal_Content bvDC
                WHERE (bvDC.BMS_Deal_Code = @Code OR @Code = 0)
                AND (
                        (ISNULL(LTRIM(RTRIM(bvDC.BMS_Deal_Content_Ref_Key)), 0) = 0 AND @i = 1) OR
                        (ISNULL(LTRIM(RTRIM(bvDC.BMS_Deal_Content_Ref_Key)), 0) > 0 AND @i = 2)
                )
                AND ISNULL(LTRIM(RTRIM(bvDC.BMS_Deal_Ref_Key)), 0) > 0
                AND ISNULL(LTRIM(RTRIM(bvDC.BMS_Asset_Ref_Key)), 0) > 0
                AND ISNULL(bvDC.Record_Status, '') IN ('P')
            END
            ELSE IF(@Type = 'RUBVDCR')
            BEGIN
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Deal
                SELECT @recordCount = COUNT(*)
                FROM BMS_Deal_Content_Rights bvDCR
                WHERE (bvDCR.BMS_Deal_Content_Code IN (SELECT BMS_Deal_Content_Code FROM BMS_Deal_Content WHERE BMS_Deal_Code = @Code) OR @Code = 0)
                AND (
                        (ISNULL(LTRIM(RTRIM(bvDCR.BMS_Deal_Content_Rights_Ref_Key)), 0) = 0 AND @i = 1) OR
                        (ISNULL(LTRIM(RTRIM(bvDCR.BMS_Deal_Content_Rights_Ref_Key)), 0) > 0 AND @i = 2)
                )
                AND ISNULL(LTRIM(RTRIM(bvDCR.BMS_Deal_Content_Ref_Key)), 0) > 0
                AND ISNULL(LTRIM(RTRIM(bvDCR.BMS_Asset_Ref_Key)), 0) > 0
				AND ((ISNULL(LTRIM(RTRIM(bvDCR.RU_Right_Rule_Code)), 0) > 0 AND ISNULL(LTRIM(RTRIM(bvDCR.BMS_Right_Rule_Ref_Key)), 0) > 0) OR (ISNULL(LTRIM(RTRIM(bvDCR.RU_Right_Rule_Code)), 0) = 0))
				AND ((ISNULL(LTRIM(RTRIM(bvDCR.SAP_WBS_Code)), 0) > 0 AND ISNULL(LTRIM(RTRIM(bvDCR.SAP_WBS_Ref_Key)), 0) > 0) OR (ISNULL(LTRIM(RTRIM(bvDCR.SAP_WBS_Code)), 0) = 0))
                AND ISNULL(bvDCR.Record_Status, '') IN ('P')
            END
   
            SET @noOfBatches = @recordCount/@no_Of_Record_In_Batch

            IF((@noOfBatches * @no_Of_Record_In_Batch) < @recordCount)
            BEGIN
                SET @noOfBatches = @noOfBatches  + 1
            END
       
            DECLARE @totalTopInner INT = 0, @totalTopOuter INT = 0
            WHILE(@batchNo <= @noOfBatches)
            BEGIN
                IF((@batchNo * @no_Of_Record_In_Batch) > @recordCount)
                BEGIN
                    SET @totalTopInner = @recordCount
                    SET @totalTopOuter = (@recordCount - ((@batchNo - 1) * @no_Of_Record_In_Batch))
                END
                ELSE
                BEGIN
                    SET @totalTopInner = (@batchNo * @no_Of_Record_In_Batch)
                    SET @totalTopOuter = @no_Of_Record_In_Batch
                END

                -- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
                -- PRINT '@no_Of_Record_In_Batch : ' + CAST(@no_Of_Record_In_Batch AS VARCHAR)
                -- PRINT '@noOfBatches : ' + CAST(@noOfBatches AS VARCHAR)
                -- PRINT '@batchNo : ' + CAST(@batchNo AS VARCHAR)
                -- PRINT '@totalTopInner : ' + CAST(@totalTopInner AS VARCHAR)
                -- PRINT '@totalTopOuter : ' + CAST(@totalTopOuter AS VARCHAR)

                DECLARE @XML_Data XML, @CodesForUpdate VARCHAR(MAX) = ''
                DECLARE @xmlData NVARCHAR(MAX)
                IF(@Type = 'RUBVA')
                BEGIN
					/********************************DELETE Temp Table if Exists ****************/
					IF OBJECT_ID('tempdb..#TempTitleAndEpisodes') IS NOT NULL
					BEGIN
						DROP TABLE #TempTitleAndEpisodes
					END
					IF OBJECT_ID('tempdb..#TempAsset') IS NOT NULL
					BEGIN
						DROP TABLE #TempAsset
					END	
					IF OBJECT_ID('tempdb..#TempDummy') IS NOT NULL
					BEGIN
						DROP TABLE #TempDummy
					END		
				/*******************************************Temp Logic******************/
				CREATE TABLE #TempTitleAndEpisodes
				(
					Title_Code INT,
					Episode_From INT,
					Episode_To INT
				)
				INSERT INTO #TempTitleAndEpisodes(Title_Code,Episode_From,Episode_To)
				SELECT DISTINCT ADM.Title_Code,MIN(ADM.Episode_Starts_From) AS Episode_From, MAX(ADM.Episode_End_To)  AS Episode_To 
				FROM 
				(
					SELECT DISTINCT tempAsset.RU_Title_Code
					FROM BMS_Asset tempAsset 	
					WHERE tempAsset.Record_Status = 'P' AND ISNULL(IS_Consider,'Y') <> 'N'
				) AS a INNER JOIN Acq_Deal_Movie ADM ON ADM.Title_Code = a.RU_Title_Code
				GROUP BY ADM.Title_Code
				
				CREATE TABLE #TempAsset
				(
					BMS_Asset_Ref_Key INT,
					Ref_BMS_ProgramCategroy INT,
					Ref_Language_Key INT,
					Duration VARCHAR(20),
					Title NVARCHAR(80),
					Title_Listing NVARCHAR(80),
					Episode_Title NVARCHAR(80),
					Episode_Season NVARCHAR(20),	
					Episode_Number NVARCHAR(20),
					Synopsis NVARCHAR(MAX),
					Is_Archived VARCHAR(10),
					BMS_Asset_Code INT,
				)

				SELECT T.N AS Row_Num INTO #TempDummy
						FROM  (
							SELECT TOP(5000) ROW_NUMBER() OVER(ORDER BY 1/0)
							FROM sys.all_objects AS o1, sys.all_objects AS o2
						) AS T(N)		
				
				INSERT INTO #TempAsset
				(
					BMS_Asset_Ref_Key,Ref_BMS_ProgramCategroy,Ref_Language_Key,Duration,Title,Title_Listing,Episode_Title ,
					Episode_Season ,Episode_Number ,
					Synopsis,Is_Archived,
					BMS_Asset_Code 
				)
				SELECT DISTINCT
				ISNULL(BA.BMS_Asset_Ref_Key,0),BA.Ref_BMS_ProgramCategroy,Ref_Language_Key, CAST(BA.Duration AS VARCHAR(8)) + '.00' AS [Duration],
				BA.Title,BA.Title_Listing,BA.Episode_Title ,
				BA.Episode_Season,
				--Episode_Number ,
				(REPLICATE('0', LEN(Episode_To) - LEN(BA.Episode_Number)) +  CAST(BA.Episode_Number AS VARCHAR))  AS Episode_Number,
				BA.Synopsis,
				CASE BA.Is_Archived WHEN 1 THEN 'true' else 'false' END AS [IsArchived],
				BMS_Asset_Code 
				FROM #TempTitleAndEpisodes TBL
				INNER JOIN #TempDummy temp ON temp.Row_Num between TBL.Episode_From AND TBL.Episode_To
				INNER JOIN BMS_Asset BA ON BA.RU_Title_Code = TBL.Title_Code AND temp.Row_Num = BA.Episode_Number COLLATE SQL_Latin1_General_CP1_CI_AS
				AND ISNULL(BA.Record_Status, '') IN ('P')
				AND ISNULL(BA.IS_Consider,'Y') <> 'N'			
				AND ISNULL(BA.BMS_Asset_Ref_Key,0) = 0
				
				DROP TABLE #TempDummy
				/***********************************************************************/
                    -- 'Generate XML Data for BMS_Assets'										
                    SET @moduleName = 'BMS_Asset'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Method_Type = 'P' AND Module_Name = @moduleName AND Is_Active = 'Y'
                    SELECT @xmlData = (
                        SELECT [Key], CategoryId, LanguageId, Duration, Title, TitleListing, EpisodeTitle, EpisodeSeason,
                        EpisodeNumber, Synopsis, IsArchived, ForeignId
                        FROM (
                            SELECT TOP(@totalTopOuter) * FROM (
                                SELECT TOP(@totalTopInner)
                                    bvA.BMS_Asset_Code,
                                    ISNULL(bvA.BMS_Asset_Ref_Key, 0) AS [Key],
                                    bvA.Ref_BMS_ProgramCategroy AS [CategoryId],
                                    bvA.Ref_Language_Key AS [LanguageId],
                                    --CAST(bvA.Duration AS VARCHAR(8)) + '.00' AS [Duration],
									bvA.Duration AS [Duration],
                                    bvA.Title AS [Title],
                                    bvA.Title_Listing AS [TitleListing],
                                    bvA.Episode_Title AS [EpisodeTitle],
                                    bvA.Episode_Season AS [EpisodeSeason],									
                                    bvA.Episode_Number AS [EpisodeNumber],
                                    bvA.Synopsis AS [Synopsis],
                                    bvA.Is_Archived AS [IsArchived],
                                    'RUBMSBVA' + CAST(bvA.BMS_Asset_Code AS VARCHAR) AS [ForeignId]
                                FROM #TempAsset bvA 
								WHERE 
									--(
									--		bvA.BMS_Asset_Code IN (SELECT BMS_Asset_Code FROM BMS_Deal_Content WHERE BMS_Deal_Code = @Code) 
									--	OR
									--		 @Code = 0
									--)
									--AND 
									(
										(ISNULL(LTRIM(RTRIM(bvA.BMS_Asset_Ref_Key)), 0) = 0 AND @i = 1) OR
										(ISNULL(LTRIM(RTRIM(bvA.BMS_Asset_Ref_Key)), 0) > 0 AND @i = 2)
									)
									--AND ISNULL(LTRIM(RTRIM(bvA.Ref_BMS_ProgramCategroy)), 0) > 0
									--AND ISNULL(bvA.Record_Status, '') IN ('P')
									--AND ISNULL(bvA.IS_Consider,'Y') <> 'N'
                               ORDER BY bvA.BMS_Asset_Code ASC
                            ) AS A
                            ORDER BY BMS_Asset_Code DESC
                        )AS B
                        ORDER BY BMS_Asset_Code ASC
                        FOR XML PATH('Program')
                    )								
				DROP TABLE #TempAsset
				
                    SET @CodesForUpdate = ''
                    SET @XML_Data = @xmlData
                    SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
                        SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
                        FROM   @XML_Data.nodes('//Program') AS A(B)
                    ) AS TBL
           
                    -- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
                    -- PRINT '@CodesForUpdate : ' + @CodesForUpdate
                    SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSBVA', '')
                    SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)

                    UPDATE BMS_Asset SET Record_Status = 'W', Request_Time = GETDATE()
                    WHERE BMS_Asset_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))
                END
				ELSE IF(@Type= 'RUBVPV')
				BEGIN
					 -- 'Generate XML Data for BMS_ProgramVersion'
					 --PRINT  @moduleName 
                    SET @moduleName = 'BMS_ProgramVersion'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Method_Type = 'P' AND Module_Name = @moduleName AND Is_Active = 'Y'
                    SELECT @xmlData = (
                        SELECT [Key], AssetId, VersionTypeId, Duration, MediaTypeId, [Description], Tapes, IsLive,
                        --CreatedDateTime, 
						CreatedUserId,
						--UpdateDateTime,
						UpdateUserId, IsArchived, ForeignId
                        FROM (
                            SELECT TOP(@totalTopOuter) * FROM (
                                SELECT TOP(@totalTopInner)
                                    bvA.BMS_ProgramVersion_Code,
                                    ISNULL(bvA.BMS_ProgramVersion_Ref_Key, 0) AS [Key],
                                    bvA.AssetId AS AssetId,
                                    bvA.VersionTypeId AS VersionTypeId,
                                    CAST(bvA.Duration AS VARCHAR(8)) + '.00' AS [Duration],
                                    bvA.MediaTypeId AS MediaTypeId,                                    
                                    bvA.[Description] AS [Description],
                                    bvA.Tapes AS Tapes,                                    
                                    bvA.IsLive AS IsLive,							
									REPLACE(CONVERT(VARCHAR, CreatedDateTime, 111), '/', '-')  AS CreatedDateTime,
									bvA.CreatedUserId AS CreatedUserId,                                                                  
									REPLACE(CONVERT(VARCHAR, UpdateDateTime, 111), '/', '-')  AS UpdateDateTime,
									bvA.UpdateUserId AS UpdateUserId,
                                    --CASE bvA.IsArchived WHEN 1 THEN 'true' else 'false' END AS [IsArchived],
                                    bvA.IsArchived  AS [IsArchived],
                                    'RUBMSBVPV' + CAST(bvA.BMS_ProgramVersion_Code AS VARCHAR) AS [ForeignId]
                                FROM BMS_ProgramVersion bvA 
								WHERE 
								--(bvA.BMS_Asset_Code IN (SELECT BMS_Asset_Code FROM BMS_Deal_Content WHERE BMS_Deal_Code = @Code) OR @Code = 0)
									1=1
                                    AND 
									(
                                        (ISNULL(LTRIM(RTRIM(bvA.BMS_ProgramVersion_Ref_Key)), 0) = 0 AND @i = 1) OR
                                        (ISNULL(LTRIM(RTRIM(bvA.BMS_ProgramVersion_Ref_Key)), 0) > 0 AND @i = 2)
                                    )
                                    AND ISNULL(LTRIM(RTRIM(bvA.AssetId)), 0) > 0
                                    AND ISNULL(bvA.Record_Status, '') IN ('P')

                                ORDER BY bvA.BMS_ProgramVersion_Code ASC
                            ) AS A
                            ORDER BY BMS_ProgramVersion_Code DESC
                        )AS B
                        ORDER BY BMS_ProgramVersion_Code ASC
                        FOR XML PATH('ProgramVersion')
                    )

                    SET @CodesForUpdate = ''
                    SET @XML_Data = @xmlData
                    SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
                        SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
                        FROM   @XML_Data.nodes('//ProgramVersion') AS A(B)
                    ) AS TBL
           
                    -- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
                    -- PRINT '@CodesForUpdate : ' + @CodesForUpdate
                    SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSBVPV', '')
                    SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)

                    UPDATE BMS_ProgramVersion SET Record_Status = 'W', Request_Time = GETDATE()
                    WHERE BMS_ProgramVersion_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))
				END
                ELSE IF(@Type = 'RUBVDC')
                BEGIN
                    -- 'Generate XML Data for Deal_Content_Header'
                    --SET @BaseAddress = 'http://172.31.24.36:8080/rightsu-service/rest/DealContent_Header/'
                    SET @moduleName = 'BMS_Deal_Content'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Method_Type = 'P' AND Module_Name = @moduleName AND Is_Active = 'Y'
                    SELECT @xmlData = (
                        SELECT [Key], DealId, AssetId, AssetType, Title,
                        DateAvailableFrom, DateAvailableTo, ForeignId
                        FROM (
                            SELECT TOP(@totalTopOuter) * FROM (
                                SELECT TOP(@totalTopInner)
                                    bvDC.BMS_Deal_Content_Code,
                                    ISNULL(bvDC.BMS_Deal_Content_Ref_Key, 0) AS [Key],
                                    bvDC.BMS_Deal_Ref_Key AS [DealId],
                                    bvDC.BMS_Asset_Ref_Key AS [AssetId],
                                    bvDC.Asset_Type AS [AssetType],
                                    bvDC.Title AS [Title],
                                    REPLACE(CONVERT(VARCHAR, bvDC.[Start_Date], 111), '/', '-') AS [DateAvailableFrom],
                                    REPLACE(CONVERT(VARCHAR, bvDC.[End_Date], 111), '/', '-') AS [DateAvailableTo],
                                    'RUBMSBVDC' + CAST(bvDC.BMS_Deal_Content_Code AS VARCHAR) AS [ForeignId]
                                FROM BMS_Deal_Content bvDC
                                WHERE (bvDC.BMS_Deal_Code = @Code OR @Code = 0)
                                    AND (
                                            (ISNULL(LTRIM(RTRIM(bvDC.BMS_Deal_Content_Ref_Key)), 0) = 0 AND @i = 1) OR
                                            (ISNULL(LTRIM(RTRIM(bvDC.BMS_Deal_Content_Ref_Key)), 0) > 0 AND @i = 2)
                                    )
                                    AND ISNULL(LTRIM(RTRIM(bvDC.BMS_Deal_Ref_Key)), 0) > 0
                                    AND ISNULL(LTRIM(RTRIM(bvDC.BMS_Asset_Ref_Key)), 0) > 0
                                    AND ISNULL(bvDC.Record_Status, '') IN ('P')
                                ORDER BY BMS_Deal_Content_Code ASC
                            ) AS A
                            ORDER BY BMS_Deal_Content_Code DESC
                        )AS B
                        ORDER BY BMS_Deal_Content_Code ASC
                        FOR XML PATH('DealContent_Header')
                    )

                    SET @CodesForUpdate = ''
                    SET @XML_Data = @xmlData
                    SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
                        SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
                        FROM   @XML_Data.nodes('//DealContent_Header') AS A(B)
                    ) AS TBL
           
                    -- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
                    -- PRINT '@CodesForUpdate : ' + @CodesForUpdate
                    SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSBVDC', '')
                    SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)
                    UPDATE BMS_Deal_Content SET Record_Status = 'W', Request_Time = GETDATE()
                    WHERE BMS_Deal_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))

                END
                ELSE IF(@Type = 'RUBVDCR')
                BEGIN
                    -- 'Generate XML Data for Deal_Content_Rights'
                    --SET @BaseAddress = 'http://172.31.24.36:8080/rightsu-service/rest/DealContent_Rights/'
                    SET @moduleName = 'BMS_Deal_Content_Rights'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Method_Type = 'P' AND Module_Name = @moduleName AND Is_Active = 'Y'
                    SELECT @xmlData = (
                        SELECT [Key], DealId, DealContentHeaderId, StationId, AssetRightRuleId, BudgetCodeId, AssetId,
                        DaysAvailable, DaysUsed, DateAvailableFrom, DateAvailableTo, BlackoutFrom,
                        BlackoutTo, BlackoutFrom2, BlackoutTo2, BlackoutFrom3, BlackoutTo3, ForeignId,MinPlays,MaxPlays
                        FROM (
                            SELECT TOP(@totalTopOuter) * FROM (
                                SELECT TOP(@totalTopInner)
                                    bvDCR.BMS_Deal_Content_Rights_Code,
                                    ISNULL(bvDCR.BMS_Deal_Content_Rights_Ref_Key, 0) AS [Key],
                                    bvDC.BMS_Deal_Ref_Key AS [DealId],
                                    bvDCR.BMS_Deal_Content_Ref_Key AS [DealContentHeaderId],
									--NULL [DealContentHeaderId],
                                    bvDCR.BMS_Station_Code AS [StationId],
                                    bvDCR.BMS_Right_Rule_Ref_Key AS [AssetRightRuleId],
                                    bvDCR.SAP_WBS_Ref_Key AS [BudgetCodeId],
                                    bvDCR.BMS_Asset_Ref_Key AS [AssetId],
                                    --(ISNULL(bvDCR.Total_Runs, 0) - ISNULL(bvDCR.Utilised_Run, 0)) AS [DaysAvailable],
                                    ISNULL(bvDCR.Total_Runs, 0) AS [DaysAvailable],
                                    ISNULL(bvDCR.Utilised_Run, 0) AS [DaysUsed],
                                    REPLACE(CONVERT(VARCHAR, bvDCR.[Start_Date], 111), '/', '-') AS [DateAvailableFrom],
                                    REPLACE(CONVERT(VARCHAR, bvDCR.[End_Date], 111), '/', '-') AS [DateAvailableTo],
                                    bvDCR.Blackout_From_1 AS [BlackoutFrom],
                                    bvDCR.Blackout_To_1 AS [BlackoutTo],
                                    bvDCR.Blackout_From_2 AS [BlackoutFrom2],
                                    bvDCR.Blackout_To_2 AS [BlackoutTo2],
                                    bvDCR.Blackout_From_3 AS [BlackoutFrom3],
                                    bvDCR.Blackout_To_3 AS [BlackoutTo3],
                                    bvDCR.Min_Runs AS [MinPlays],
                                    bvDCR.Max_Runs AS [MaxPlays],
                                    'RUBMSBVDCR' + CAST(bvDCR.BMS_Deal_Content_Rights_Code AS VARCHAR) AS [ForeignId]
                                FROM BMS_Deal_Content_Rights bvDCR
                                INNER JOIN BMS_Deal_Content bvDC ON bvDCR.BMS_Deal_Content_Code = bvDC.BMS_Deal_Content_Code
                                --INNER JOIN Channel C ON bvDCR.RU_Channel_Code = C.Channel_Code
                                WHERE (bvDCR.BMS_Deal_Content_Code IN (SELECT BMS_Deal_Content_Code FROM BMS_Deal_Content WHERE BMS_Deal_Code = @Code) OR @Code = 0)
                                AND (
                                        (ISNULL(LTRIM(RTRIM(bvDCR.BMS_Deal_Content_Rights_Ref_Key)), 0) = 0 AND @i = 1) OR
                                        (ISNULL(LTRIM(RTRIM(bvDCR.BMS_Deal_Content_Rights_Ref_Key)), 0) > 0 AND @i = 2)
                                )
                                AND ISNULL(LTRIM(RTRIM(bvDCR.BMS_Deal_Content_Ref_Key)), 0) > 0
                                AND ISNULL(LTRIM(RTRIM(bvDCR.BMS_Asset_Ref_Key)), 0) > 0
								AND ((ISNULL(LTRIM(RTRIM(bvDCR.RU_Right_Rule_Code)), 0) > 0 AND ISNULL(LTRIM(RTRIM(bvDCR.BMS_Right_Rule_Ref_Key)), 0) > 0) OR (ISNULL(LTRIM(RTRIM(bvDCR.RU_Right_Rule_Code)), 0) = 0))
								AND ((ISNULL(LTRIM(RTRIM(bvDCR.SAP_WBS_Code)), 0) > 0 AND ISNULL(LTRIM(RTRIM(bvDCR.SAP_WBS_Ref_Key)), 0) > 0) OR (ISNULL(LTRIM(RTRIM(bvDCR.SAP_WBS_Code)), 0) = 0))
                                AND ISNULL(bvDCR.Record_Status, '') IN ('P')
                                ORDER BY bvDCR.BMS_Deal_Content_Rights_Code ASC
                            ) AS A
                            ORDER BY BMS_Deal_Content_Rights_Code DESC
                        )AS B
                        ORDER BY BMS_Deal_Content_Rights_Code ASC
                        FOR XML PATH('DealContent_Right')
                    )

                    SET @CodesForUpdate = ''
                    SET @XML_Data = @xmlData
                    SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
                        SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
                        FROM   @XML_Data.nodes('//DealContent_Right') AS A(B)
                    ) AS TBL
           
				
                    --SELECT @CodesForUpdate 

                    SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSBVDCR', '')
                    -- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
                    -- PRINT '@CodesForUpdate : ' + @CodesForUpdate
                    SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)
                    UPDATE BMS_Deal_Content_Rights SET Record_Status = 'W', Request_Time = GETDATE()
                    WHERE BMS_Deal_Content_Rights_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))

                END

                SET @batchNo = (@batchNo + 1)
                SET @xmlData = '<?xml version="1.0" ?>' + @xmlData  + ''

                INSERT INTO #Temp_Xml_Data(Code, Xml_Data, Method_Type, BaseAddress,RequestUri)
                SELECT 0 AS Code, @xmlData AS Xml_Data, CASE WHEN @i = 1 THEN 'POST' ELSE 'PUT' END AS Method_Type, @BaseAddress AS BaseAddress,@RequestUri AS RequestUri
            END

            SET @i = (@i + 1)
        END
    END

    --- Start BMS_Log Code ---
    DECLARE @maxBvLogCode INT = 0
    SELECT @maxBvLogCode = ISNULL(MAX(BMS_Log_Code), 0) FROM BMS_Log
    INSERT INTO BMS_Log(Module_Name, Method_Type, Request_Time, Request_Xml,    Record_Status)
    SELECT @moduleName AS Module_Name, Method_Type, GETDATE(), Xml_Data, 'W' AS Record_Status FROM #Temp_Xml_Data

    UPDATE tmp SET tmp.BMS_Log_Code = bvL.BMS_Log_Code FROM  #Temp_Xml_Data tmp
    INNER JOIN BMS_Log bvL ON tmp.Xml_Data COLLATE SQL_Latin1_General_CP1_CI_AS = bvL.Request_Xml  COLLATE SQL_Latin1_General_CP1_CI_AS
	AND bvL.Record_Status = 'W' AND bvL.Module_Name = @moduleName AND bvL.BMS_Log_Code > @maxBvLogCode
    --- End BMS_Log Code ---

    SELECT * FROM #Temp_Xml_Data
END