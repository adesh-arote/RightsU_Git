CREATE PROCEDURE [dbo].[USP_BMS_Deserialize_Masters]	
(
	@strXml VARCHAR(MAX),
    @Type VARCHAR(10),
    @Is_Error VARCHAR(1),
    @Error_Details VARCHAR(MAX),
    @BMS_Log_Code INT
)
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 13 OCT 2015
-- Description:	Deserialize XML  
-- =============================================

BEGIN
	SET NOCOUNT ON;	
	--	DECLARE @strXml VARCHAR(MAX), @Type VARCHAR(10) = 'BMS_D'
	--DECLARE @XML_Data XML
	--SET @XML_Data = @strXml
	IF OBJECT_ID('TEMPDB..#Temp_Updated_Keys') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Updated_Keys
	END
	CREATE TABLE #Temp_Updated_Keys
	(
		BMS_Key INT, 
		Code INT
	)
	--    DECLARE @strXml VARCHAR(MAX), @Type VARCHAR(10) = 'BMS_D'
    --DECLARE @XML_Data XML
   -- SET @XML_Data = @strXml   
    IF(UPPER(@Type)='RUV')
    BEGIN
        --INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
        --SELECT A.B.value('Key[1]','INT') AS BMS_Key,
        --REPLACE(A.B.value('ForeignId[1]','VARCHAR(40)'), 'RUV', '')  AS Code
        --FROM   @XML_Data.nodes('//Licensor') AS A(B)
        
        INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSV', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUV'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSV', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUV'

		IF(@Is_Error = 'Y')
		BEGIN		  
			UPDATE bvV SET bvV.Error_Description = @Error_Details, bvV.Record_Status = 'E', bvV.Response_Time = GETDATE() 
			FROM Vendor bvV
			INNER JOIN #Temp_Updated_Keys tmp ON bvV.Vendor_Code = tmp.Code
			WHERE bvV.Vendor_Code = tmp.Code
		END

        IF(@Is_Error = 'N')
        BEGIN
            UPDATE bvV SET bvV.Ref_Vendor_Key = tmp.BMS_Key ,bvV.Record_Status = 'D', bvV.Response_Time = GETDATE() 
			FROM Vendor bvV
            INNER JOIN #Temp_Updated_Keys tmp ON bvV.Vendor_Code = tmp.Code

            UPDATE bvD SET bvD.BMS_Licensor_Code = tmp.BMS_Key FROM BMS_Deal bvD
            INNER JOIN #Temp_Updated_Keys tmp ON bvD.RU_Licensor_Code = tmp.Code
        END
    END
    ELSE IF(UPPER(@Type)='RUC')
    BEGIN
       
		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSC', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUC'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSC', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUC'

		IF(@Is_Error = 'Y')
		BEGIN		  
			UPDATE bvV SET bvV.Error_Description = @Error_Details, bvV.Record_Status = 'E', bvV.Response_Time = GETDATE() 
			FROM Category bvV
			INNER JOIN #Temp_Updated_Keys tmp ON bvV.Category_Code = tmp.Code
			WHERE bvV.Category_Code = tmp.Code
		END
        IF(@Is_Error = 'N')
        BEGIN
            UPDATE bvC SET bvC.Ref_Category_Key = tmp.BMS_Key ,bvC.Record_Status = 'D', bvC.Response_Time = GETDATE() 
			FROM Category bvC
            INNER JOIN #Temp_Updated_Keys tmp ON bvC.Category_Code = tmp.Code

            UPDATE bvD SET bvD.BMS_Category_Code = tmp.BMS_Key FROM BMS_Deal bvD
            INNER JOIN #Temp_Updated_Keys tmp ON bvD.RU_Category_Code = tmp.Code
        END
    END
    IF(UPPER(@Type)='RURR')
    BEGIN              

		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSRR', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RURR'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSRR', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RURR'
		
		IF(@Is_Error = 'Y')
		BEGIN		  
			UPDATE bvV SET bvV.Error_Description = @Error_Details, bvV.Record_Status = 'E', bvV.Response_Time = GETDATE() 
			FROM Right_Rule bvV
			INNER JOIN #Temp_Updated_Keys tmp ON bvV.Right_Rule_Code = tmp.Code
			WHERE bvV.Right_Rule_Code = tmp.Code
		END

        IF(@Is_Error = 'N')
        BEGIN
            UPDATE bvRR SET bvRR.Ref_Right_Rule_Key = tmp.BMS_Key ,bvRR.Record_Status = 'D', bvRR.Response_Time = GETDATE() 
			FROM Right_Rule bvRR
            INNER JOIN #Temp_Updated_Keys tmp ON bvRR.Right_Rule_Code = tmp.Code

            UPDATE bvDCR SET bvDCR.BMS_Right_Rule_Ref_Key = tmp.BMS_Key FROM BMS_Deal_Content_Rights bvDCR
            INNER JOIN #Temp_Updated_Keys tmp ON bvDCR.RU_Right_Rule_Code = tmp.Code
        END
    END
    IF(UPPER(@Type)='RUECV')
    BEGIN                     

		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSECV', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUECV'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSECV', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUECV'

        IF(@Is_Error = 'N')
        BEGIN
            UPDATE bvECV SET bvECV.Ref_BMS_Code = tmp.BMS_Key FROM Extended_Columns_Value bvECV
            INNER JOIN #Temp_Updated_Keys tmp ON bvECV.Columns_Value_Code = tmp.Code

            UPDATE bvA SET bvA.Ref_BMS_ProgramCategroy = tmp.BMS_Key FROM BMS_Asset bvA
            INNER JOIN #Temp_Updated_Keys tmp ON bvA.RU_ProgramCategory_Code = tmp.Code
        END   
    END
	IF(UPPER(@Type)='RUBW')  
    BEGIN               
		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, ' ', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUBW'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, ' ', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUBW'
		PRINT 'ad'
		IF(@Is_Error = 'Y')
		BEGIN		  
			UPDATE bvW SET bvW.Error_Description = @Error_Details, bvW.Is_Process = 'E',bvW.Response_Time = GETDATE() 
			FROM BMS_WBS bvW
			INNER JOIN #Temp_Updated_Keys tmp ON bvW.BMS_WBS_Code = tmp.Code
		END
        IF(@Is_Error = 'N')
        BEGIN
			DECLARE @File_Code INT = 0, @File_Name VARCHAR(MAX) = ''

			Select @File_Name = REPLACE(CONVERT(VARCHAR, GETDATE(), 102), '.', '') + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', '') + '~' 
			+ CONVERT(VARCHAR, GETDATE(), 103) + ' ' + CONVERT(VARCHAR, GETDATE(), 108) 

			INSERT INTO Upload_Files([File_Name], Err_YN, Upload_Date, Uploaded_By, Upload_Type, Upload_Record_Count, Bank_Code, ChannelCode)
			VALUES(@File_Name,'N', GETDATE(), 143, 'BMS_WBS_EXP', 1, 0, 0)

			select @File_Code = IDENT_CURRENT('Upload_Files')
			PRINT 'ad1'

            UPDATE bvW SET bvW.BMS_Key = tmp.BMS_Key, Is_Process = 'D',File_Code = @File_Code ,bvW.Response_Time = GETDATE() 
			FROM BMS_WBS bvW
            INNER JOIN #Temp_Updated_Keys tmp ON bvW.BMS_WBS_Code = tmp.Code

			UPDATE SW SET SW.BMS_Key = tmp.BMS_Key 
			FROM SAP_WBS SW
			INNER JOIN BMS_WBS bvW ON SW.SAP_WBS_Code = bvW.SAP_WBS_Code
            INNER JOIN #Temp_Updated_Keys tmp ON bvW.BMS_WBS_Code = tmp.Code

			--SELECT * 
			UPDATE BDRC SET BDRC.SAP_WBS_Ref_Key = tmp.BMS_Key 
			FROM BMS_Deal_Content_Rights BDRC 
			INNER JOIN BMS_WBS BW ON BDRC.SAP_WBS_Code = BW.SAP_WBS_Code
			INNER JOIN #Temp_Updated_Keys tmp ON BW.BMS_WBS_Code = tmp.Code
			WHERE  ISNULL(BDRC.SAP_WBS_Ref_Key,0) = 0 

        END   
    END

	
	UPDATE BMS_Log SET
    Response_Time = GETDATE(),
    Response_Xml = CASE WHEN UPPER(@Is_Error) = 'Y' THEN '' ELSE @strXml END,
    Record_Status = CASE WHEN UPPER(@Is_Error) = 'Y' THEN 'E' ELSE 'D' END,
    Error_Description = @Error_Details
    WHERE  BMS_Log_Code = @BMS_Log_Code

END

