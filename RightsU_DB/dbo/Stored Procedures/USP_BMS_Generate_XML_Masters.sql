CREATE PROCEDURE [dbo].[USP_BMS_Generate_XML_Masters]
(
		@Type VARCHAR(10),
		@Code INT
)
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 14 OCT 2015
-- Description:	Get XML (LICENSOR,DEALCATEGORY,Program Category,ASSETRIGHTRULE and BUDGETCODE)
-- =============================================
BEGIN	
	SET NOCOUNT ON;
	--=======================================================
	DECLARE @no_Of_Record_In_Batch INT  = 1 , @no_Of_Record_In_Batch_Master INT  = 1 ,
	@recordCount INT = 0, @noOfBatches INT = 0 ,@batchNo INT  = 1, @BaseAddress NVARCHAR(100) = '',@RequestUri NVARCHAR(100) = '', @moduleName VARCHAR(100)	
	
	SELECT TOP 1 @no_Of_Record_In_Batch_Master = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'BMS_No_Of_Record_In_Batch_Master' AND IsActive = 'Y'
	
-- ========================================================Delete Temp Table if Exist============================
	IF OBJECT_ID('TEMPDB..#Temp_Xml_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Xml_Data
	END
-- =============================================Create Temp Table================================================
	CREATE TABLE #Temp_Xml_Data
	(
		Code INT,
		Xml_Data NVARCHAR(MAX),
		Method_Type VARCHAR(10),
		--Method_Url VARCHAR(MAX)
		BaseAddress NVARCHAR(100),
		RequestUri NVARCHAR(100)
		,BMS_Log_Code INT
	)
	
--=========================================================While Loop============================================
	DECLARE @i INT = 1
		WHILE ( @i <= 2)
		BEGIN 
		
		PRINT '@i : ' + CAST(@i AS VARCHAR)
			-- @i = 1, It means generate XML data for Post
			-- @i = 2, It means generate XML data for PUT
			SET @recordCount = 0
			SET @noOfBatches = 0 
			SET @batchNo = 1
			SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Master
			
			IF(@Type = 'RUV')
			BEGIN				
				SELECT @recordCount = COUNT(bvV.Vendor_Code)
				FROM Vendor bvV
				WHERE (bvV.Vendor_Code = @Code OR @Code = 0)
				AND 
				(
						(ISNULL(LTRIM(RTRIM(bvV.Ref_Vendor_Key)), 0) = 0 AND @i = 1) OR 
						(ISNULL(LTRIM(RTRIM(bvV.Ref_Vendor_Key)), 0) > 0 AND @i = 2)
				)
				AND bvV.Record_Status = 'P'
			END -- Vendor Or Licensor						
			 ELSE IF(@Type = 'RUC')
            BEGIN
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Master
                SELECT @recordCount = COUNT(*)
                FROM Category bvC
                WHERE (bvC.Category_Code = @Code OR @Code = 0)
                AND (
                        (ISNULL(LTRIM(RTRIM(bvC.Ref_Category_Key)), 0) = 0 AND @i = 1) OR
                        (ISNULL(LTRIM(RTRIM(bvC.Ref_Category_Key)), 0) > 0 AND @i = 2)
                )
                AND bvC.Record_Status = 'P'
            END  --Category	
            ELSE IF(@Type = 'RURR')
            BEGIN
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Master
                SELECT @recordCount = COUNT(*)
                FROM Right_Rule bvRR
                WHERE (bvRR.Right_Rule_Code = @Code OR @Code = 0)
                AND (
                        (ISNULL(LTRIM(RTRIM(bvRR.Ref_Right_Rule_Key)), 0) = 0 AND @i = 1) OR
                        (ISNULL(LTRIM(RTRIM(bvRR.Ref_Right_Rule_Key)), 0) > 0 AND @i = 2)
                )
                AND bvRR.Record_Status = 'P'
            END --Right Rule	
            ELSE IF(@Type = 'RUECV')
            BEGIN
			--PRINT  '@recordCount : '+ CAST (@recordCount AS VARCHAR)
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Master
                SELECT @recordCount = COUNT(*)
                FROM Extended_Columns_Value bvECV
                WHERE (bvECV.Columns_Value_Code = @Code OR @Code = 0)
                AND (
                        (ISNULL(LTRIM(RTRIM(bvECV.Ref_BMS_Code)), 0) = 0 AND @i = 1) OR
                        (ISNULL(LTRIM(RTRIM(bvECV.Ref_BMS_Code)), 0) > 0 AND @i = 2)
                )
                AND bvECV.Columns_Value_Code IN (
                    SELECT DISTINCT RU_ProgramCategory_Code FROM BMS_Asset WHERE 
					ISNULL(Record_Status, '') IN ('P') AND 
					ISNULL(RU_ProgramCategory_Code,0) > 0
                )
                
            END	--ProgramCategory OR Extended_Columns_Value
            ELSE IF(@Type = 'RUBW')
            BEGIN            
                SET @no_Of_Record_In_Batch = @no_Of_Record_In_Batch_Master
                SELECT @recordCount = COUNT(SW.SAP_WBS_Code)
                FROM BMS_WBS bvW                
                INNER JOIN SAP_WBS SW ON bvW.SAP_WBS_Code = SW.SAP_WBS_Code
                WHERE (bvW.BMS_WBS_Code = @Code OR @Code = 0)
                AND (
                        (ISNULL(LTRIM(RTRIM(bvW.BMS_Key)), 0) = 0 AND @i = 1) OR
                        (ISNULL(LTRIM(RTRIM(bvW.BMS_Key)), 0) > 0 AND @i = 2)
                )
                AND bvW.Is_Process IN ('P')
                --AND (SW.Insert_On >= (SELECT MAX(Request_Time) FROM BMS_Log WHERE Module_Name = 'BMS_WBS' AND ISNULL(Record_Status,'') = 'D') OR @i = 1)
            END --BMS_WBS
--===============================================Paging Logic========================================================
			SET @noOfBatches = @recordCount/@no_Of_Record_In_Batch
			IF((@noOfBatches * @no_Of_Record_In_Batch) < @recordCount)
			BEGIN
				SET @noOfBatches = @noOfBatches  + 1
			END
			DECLARE @totalTopInner INT = 0, @totalTopOuter INT = 0
			WHILE(@batchNo <= @noOfBatches)
			BEGIN
			PRINT 'Inner While loop'			
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
				 PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
				 PRINT '@no_Of_Record_In_Batch : ' + CAST(@no_Of_Record_In_Batch AS VARCHAR)
				 PRINT '@noOfBatches : ' + CAST(@noOfBatches AS VARCHAR)
				 PRINT '@batchNo : ' + CAST(@batchNo AS VARCHAR)
				 PRINT '@totalTopInner : ' + CAST(@totalTopInner AS VARCHAR)
				 PRINT '@totalTopOuter : ' + CAST(@totalTopOuter AS VARCHAR)

				DECLARE @XML_Data XML, @CodesForUpdate VARCHAR(MAX) = '',@xmlData VARCHAR(MAX)
-- ==========================================================================================================================
				IF(@Type = 'RUV')
                BEGIN                
                    -- 'Generate XML Data for Licensors'
                    SET @moduleName = 'Vendor'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Module_Name = @moduleName AND Is_Active = 'Y' AND Method_Type = 'P'
					IF(ISNULL(@BaseAddress,'') <> '')
					BEGIN
						SELECT @xmlData = (
							SELECT [Key], Name, AddressLine1, AddressLine2, AddressLine3, City, Province, Country,
							PostalCode, Phone, Fax, Email, ExternalId, UpdateUserId, IsArchived, ForeignId
							FROM (
								SELECT TOP(@totalTopOuter) * FROM (
									SELECT TOP(@totalTopInner)
										bvV.Vendor_Code,
										ISNULL(bvV.Ref_Vendor_Key,0) AS [Key],         
										bvV.Vendor_Name AS [Name],
										SUBSTRING(bvV.Address,0,81) AS [AddressLine1],
										SUBSTRING(bvV.Address,81,80) AS [AddressLine2],
										SUBSTRING(bvV.Address,161,80) AS [AddressLine3],
										'' AS [City],
										bvV.Province AS [Province],
										'' AS [Country],
										bvV.PostalCode AS PostalCode,
										bvV.Phone_No AS Phone,
										bvV.Fax_No AS [Fax],
										'' AS [Email],
										bvV.ExternalId AS  [ExternalId],
										bvV.Last_Action_By AS [UpdateUserId],
										'false'  [IsArchived],
										'RUBMSV'+ CAST(bvV.Vendor_Code AS VARCHAR) AS [ForeignId]
									FROM Vendor bvV
									WHERE (bvV.Vendor_Code = @Code OR @Code = 0)
					AND 
					(
							(ISNULL(LTRIM(RTRIM(bvV.Ref_Vendor_Key)), 0) = 0 AND @i = 1) OR 
							(ISNULL(LTRIM(RTRIM(bvV.Ref_Vendor_Key)), 0) > 0 AND @i = 2)
					)
					AND bvV.Record_Status = 'P'
									ORDER BY bvV.Vendor_Code ASC
								) AS A
								ORDER BY Vendor_Code DESC
							)AS B
							ORDER BY Vendor_Code ASC
							FOR XML PATH('Licensor')
						)

						SET @CodesForUpdate = ''
						SET @XML_Data = @xmlData
						SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
							SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
							FROM   @XML_Data.nodes('//Licensor') AS A(B)
						) AS TBL
           
						-- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
						-- PRINT '@CodesForUpdate : ' + @CodesForUpdate
						SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSV', '')
						SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)

						UPDATE Vendor SET Record_Status = 'W', Request_Time = GETDATE()
						WHERE Vendor_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))
					END --if BaseAdd.
                END
                ELSE IF(@Type = 'RUC')
                BEGIN
                    -- 'Generate XML Data for Deal Category'
                    SET @moduleName = 'Category'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Module_Name = @moduleName AND  Is_Active = 'Y' AND Method_Type = 'P'
					IF(ISNULL(@BaseAddress,'') <> '')
					BEGIN
						SELECT @xmlData = (
							SELECT [Key], [Description], IsArchived, ForeignId
							FROM (
								SELECT TOP(@totalTopOuter) * FROM (
									SELECT TOP(@totalTopInner)
										bvC.Category_Code,
										ISNULL(bvC.Ref_Category_Key, 0) AS [Key],
										[Category_Name] AS [Description],
										'false' AS [IsArchived],
										'RUBMSC' + CAST(bvC.Category_Code AS VARCHAR) AS [ForeignId]
									FROM Category bvC
									WHERE (bvC.Category_Code = @Code OR @Code = 0)
									AND (
											(ISNULL(LTRIM(RTRIM(bvC.Ref_Category_Key)), 0) = 0 AND @i = 1) OR
											(ISNULL(LTRIM(RTRIM(bvC.Ref_Category_Key)), 0) > 0 AND @i = 2)
									)
									AND bvC.Record_Status = 'P'
									ORDER BY bvC.Category_Code ASC
								) AS A
								ORDER BY Category_Code DESC
							)AS B
							ORDER BY Category_Code ASC
							FOR XML PATH('DealCategory')
						)

						SET @CodesForUpdate = ''
						SET @XML_Data = @xmlData
						SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
							SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
							FROM   @XML_Data.nodes('//DealCategory') AS A(B)
						) AS TBL
           
						-- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
						-- PRINT '@CodesForUpdate : ' + @CodesForUpdate
						SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSC', '')
						SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)

						UPDATE Category SET Record_Status = 'W', Request_Time = GETDATE()
						WHERE Category_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))
					END --if Baseaddd.
                END
                ELSE IF(@Type = 'RURR')
                BEGIN
                    -- 'Generate XML Data for Asset Right Rule'
                    SET @moduleName = 'Right_Rule'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Module_Name = @moduleName AND Is_Active = 'Y' AND Method_Type = 'P'
					IF(ISNULL(@BaseAddress,'') <> '')
					BEGIN
						SELECT @xmlData = (
							SELECT [Key], [Description], Code, IsArchived, ForeignId
							FROM (
								SELECT TOP(@totalTopOuter) * FROM (
									SELECT DISTINCT TOP(@totalTopInner)
										bvRR.Right_Rule_Code,
										ISNULL(bvRR.Ref_Right_Rule_Key, 0) AS [Key],
										bvRR.Right_Rule_Name AS [Description],
										bvRR.Short_Key AS [Code],
										'false' AS [IsArchived],
										'RUBMSRR'+ CAST(bvRR.Right_Rule_Code AS VARCHAR) AS [ForeignId]       
									FROM Right_Rule bvRR
									WHERE (bvRR.Right_Rule_Code = @Code OR @Code = 0)
									AND (
											(ISNULL(LTRIM(RTRIM(bvRR.Ref_Right_Rule_Key)), 0) = 0 AND @i = 1) OR
											(ISNULL(LTRIM(RTRIM(bvRR.Ref_Right_Rule_Key)), 0) > 0 AND @i = 2)
									)
									AND bvRR.Record_Status = 'P'
									ORDER BY bvRR.Right_Rule_Code ASC
								) AS A
								ORDER BY Right_Rule_Code DESC
							)AS B
							ORDER BY Right_Rule_Code ASC
							FOR XML PATH('AssetRightRule')
						)

						SET @CodesForUpdate = ''
						SET @XML_Data = @xmlData
						SELECT @CodesForUpdate = @CodesForUpdate + Foreign_Id + ','  FROM (
							SELECT A.B.value('ForeignId[1]','VARCHAR(40)') AS Foreign_Id
							FROM   @XML_Data.nodes('//AssetRightRule') AS A(B)
						) AS TBL
           
						-- PRINT '@recordCount : ' + CAST(@recordCount AS VARCHAR)
						-- PRINT '@CodesForUpdate : ' + @CodesForUpdate
						SET @CodesForUpdate = REPLACE(@CodesForUpdate, 'RUBMSRR', '')
						SET @CodesForUpdate = LEFT(@CodesForUpdate, Len(@CodesForUpdate) - 1)

						UPDATE Right_Rule SET Record_Status = 'W', Request_Time = GETDATE()
						WHERE Right_Rule_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))
					END --if Baseadd
                END
                ELSE IF(@Type = 'RUECV')
                BEGIN
                    -- 'Generate XML Data for Program Category'
					--PRINT  'putorpost' + cast(@i as varchar)
                    SET @moduleName = 'BMS_ProgramCategory'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Module_Name = @moduleName AND Is_Active = 'Y' AND Method_Type = 'P'
					IF(ISNULL(@BaseAddress,'') <> '')
					BEGIN
						SELECT @xmlData = (
							SELECT [Key], [Description], IsArchived, ForeignId
							FROM (
								SELECT TOP(@totalTopOuter) * FROM (
									SELECT TOP(@totalTopInner)
										bvECV.Columns_Value_Code,
										ISNULL(bvECV.Ref_BMS_Code, 0) AS [Key],
										bvECV.Columns_Value AS [Description],
										'false' AS [IsArchived],
										'RUBMSECV' + CAST(bvECV.Columns_Value_Code AS VARCHAR) AS [ForeignId]
									FROM Extended_Columns_Value bvECV
									WHERE (bvECV.Columns_Value_Code = @Code OR @Code = 0)
									AND (
											(ISNULL(LTRIM(RTRIM(bvECV.Ref_BMS_Code)), 0) = 0 AND @i = 1) OR
											(ISNULL(LTRIM(RTRIM(bvECV.Ref_BMS_Code)), 0) > 0 AND @i = 2)
									)
									AND bvECV.Columns_Value_Code IN (
										SELECT DISTINCT RU_ProgramCategory_Code FROM BMS_Asset 
										WHERE 
										ISNULL(Record_Status, '') IN ('P') AND 
										ISNULL(RU_ProgramCategory_Code,0) > 0
									)
									ORDER BY bvECV.Columns_Value_Code ASC
								) AS A
								ORDER BY Columns_Value_Code DESC
							)AS B
							ORDER BY Columns_Value_Code ASC
							FOR XML PATH('ProgramCategory')
						)
					END--baseAdd.
                END
                ELSE IF(@Type = 'RUBW')
                BEGIN
                    -- 'Generate XML Data for Budget Code'
                    SET @moduleName = 'BMS_WBS'
                    SELECT 
						TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
					FROM BMS_All_Masters WHERE Module_Name = @moduleName AND Is_Active = 'Y' AND Method_Type = 'P'
					IF(ISNULL(@BaseAddress,'') <> '')
					BEGIN
						SELECT @xmlData = (
							SELECT [Key], [Description], Code, IsArchived, ForeignId
							FROM (
								SELECT TOP(@totalTopOuter) * FROM (
										SELECT TOP(@totalTopInner)
										bvW.BMS_WBS_Code,
										ISNULL(bvW.BMS_Key, 0) AS [Key],
										bvW.BMS_WBS_Code AS Code,
										--'2512' As Code,
										CASE
											WHEN ISNULL(bvW.Short_ID ,'') <> '' THEN
												SUBSTRING(bvW.WBS_Description, 1, (80 - (LEN(bvW.WBS_Code) + LEN(bvW.Short_ID) + 2))) +  '-' + bvW.Short_ID + '-' + CAST(bvW.WBS_Code AS VARCHAR)
											ELSE
												SUBSTRING(bvW.WBS_Description, 1, (80 - (LEN(bvW.WBS_Code) + 1))) + '-' + CAST(bvW.WBS_Code AS VARCHAR)
										END AS  [Description],
										Is_Archive As IsArchived,
										bvW.WBS_Code AS ForeignId
										--'RUBMSBW' + CAST(BMS_WBS_Code AS VARCHAR) AS ForeignId
									FROM BMS_WBS bvW
									INNER JOIN SAP_WBS SW ON SW.SAP_WBS_Code = bvW.Sap_WBS_Code
									WHERE (bvW.BMS_WBS_Code = @Code OR @Code = 0)
									AND (
											(ISNULL(LTRIM(RTRIM(bvW.BMS_Key)), 0) = 0 AND @i = 1) OR
											(ISNULL(LTRIM(RTRIM(bvW.BMS_Key)), 0) > 0 AND @i = 2)
									)
									AND bvW.Is_Process IN ('P')
									--AND (SW.Insert_On >= (SELECT MAX(Request_Time) FROM BMS_Log WHERE Module_Name = 'BMS_WBS' AND ISNULL(Record_Status,'') = 'D') OR @i = 1)
									ORDER BY bvW.BMS_WBS_Code ASC
								) AS A
								ORDER BY BMS_WBS_Code DESC
							)AS B
							ORDER BY BMS_WBS_Code ASC
							FOR XML PATH('Budgetcode')
						)

						SET @CodesForUpdate = ''
						SET @XML_Data = @xmlData
						SELECT @CodesForUpdate = @CodesForUpdate + Codes + ','  FROM (
							SELECT A.B.value('Code[1]','VARCHAR(40)') AS Codes
							FROM   @XML_Data.nodes('//Budgetcode') AS A(B)
						) AS TBL
												
						SET @CodesForUpdate = REPLACE(@CodesForUpdate, ' ', '')
						UPDATE BMS_WBS SET Is_Process = 'W', Request_Time = GETDATE()
						WHERE BMS_WBS_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CodesForUpdate, ','))

					END --IF BAse Add. End
                END
                SET @batchNo = (@batchNo + 1)
				IF(ISNULL(@xmlData,'') <> '')
				BEGIN
					SET @xmlData = '<?xml version="1.0" ?>' + @xmlData  + ''                
					INSERT INTO #Temp_Xml_Data(Code, Xml_Data, Method_Type, BaseAddress,RequestUri)
					SELECT 0 AS Code, @xmlData AS Xml_Data, CASE WHEN @i = 1 THEN 'POST' ELSE 'PUT' END AS Method_Type, @BaseAddress AS BaseAddress,@RequestUri AS RequestUri
				END
          
			END --End While(Inner) Loop
		
			SET @i = (@i + 1)			
		END -- End While(Outer) Loop
-- =============================================Start BV Log Code========================
    DECLARE @maxBvLogCode INT = 0
    SELECT @maxBvLogCode = ISNULL(MAX(BMS_Log_Code), 0) FROM BMS_Log
	
    INSERT INTO BMS_Log(Module_Name, Method_Type, Request_Time, Request_Xml,Record_Status)
    SELECT @moduleName AS Module_Name, Method_Type, GETDATE(), Xml_Data, 'W' AS Record_Status FROM #Temp_Xml_Data

    UPDATE tmp SET tmp.BMS_Log_Code = bvL.BMS_Log_Code FROM  #Temp_Xml_Data tmp
    INNER JOIN BMS_Log bvL ON tmp.Xml_Data collate SQL_Latin1_General_CP1_CI_AS= bvL.Request_Xml collate SQL_Latin1_General_CP1_CI_AS
    AND bvL.Record_Status = 'W' AND bvL.Module_Name = @moduleName AND bvL.BMS_Log_Code > @maxBvLogCode
    --- ---
-- =============================================Result Statment========================

    SELECT * FROM #Temp_Xml_Data    

    IF OBJECT_ID('tempdb..#Temp_Xml_Data') IS NOT NULL DROP TABLE #Temp_Xml_Data
END
-- =============================================Execute========================
--EXEC USP_BMS_Generate_XML_Masters 'RUV', 0
--EXEC USP_BMS_Generate_XML_Masters 'RUBW', 0
--EXEC USP_BMS_Generate_XML_Masters 'RURR', 0
--EXEC USP_BMS_Generate_XML_Masters 'RUECV', 0
--SELECT * FROM BMS_All_Masters
--UPDATE BMS_All_Masters SET Is_Active = 'N' WHERE Order_Id IN(28,29)
	
--END