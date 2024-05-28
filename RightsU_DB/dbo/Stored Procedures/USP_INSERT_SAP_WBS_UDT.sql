CREATE PROCEDURE [dbo].[USP_INSERT_SAP_WBS_UDT]
(
	@SAP_WBS_DATA SAP_WBS_DATA READONLY,
	@Upload_File_Data Upload_File_Data READONLY,
	@Is_ERROR Char(1)
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_INSERT_SAP_WBS_UDT]', 'Step 1', 0, 'Started Procedure', 0, '' 
		INSERT INTO Upload_Files([File_Name], Err_YN, Upload_Date, Uploaded_By, Upload_Type, Pending_Review_YN, Upload_Record_Count, Bank_Code)
		VALUES('SAP~'+CONVERT(VARCHAR, GETDATE(), 113), @Is_ERROR, GETDATE(), 143, 'SAP_IMP', Null, (SELECT COUNT(*) FROM @Upload_File_Data), 0)

		DECLARE @File_Code INT = 0
		SELECT @File_Code = IDENT_CURRENT('Upload_Files')

		INSERT INTO Upload_Err_Detail(File_Code, Row_Num, Row_Delimed, Err_Cols, Upload_Type, Upload_Title_Type)
		SELECT @File_Code, Row_Num, Row_Delimed, Err_Cols, Upload_Type, Upload_Title_Type FROM @Upload_File_Data

		MERGE SAP_WBS sap 
		USING @SAP_WBS_DATA swt On LTRIM(RTRIM(sap.WBS_Code)) = LTRIM(RTRIM(swt.WBS_Code))
		WHEN MATCHED
			THEN UPDATE SET sap.WBS_Description = swt.WBS_Description,
							sap.Studio_Vendor = swt.Studio_Vendor,
							sap.Original_Dubbed = swt.Original_Dubbed,
							sap.Status = swt.Status,
							sap.Short_ID = swt.Short_ID,
							sap.Sport_Type = swt.Sport_Type
		WHEN NOT MATCHED BY TARGET
			THEN INSERT (WBS_Code, WBS_Description, Studio_Vendor, Original_Dubbed, [Status], Sport_Type, Short_ID, Insert_On, File_Code, BMS_Key)
				 VALUES(swt.WBS_Code, swt.WBS_Description, swt.Studio_Vendor, swt.Original_Dubbed, swt.[Status], swt.Sport_Type, swt.Short_ID, GETDATE(), @File_Code, NULL);

	
		SELECT DISTINCT SAP_WBS_Code, WBS_Code, WBS_Description,sap.Studio_Vendor, Short_ID, sap.Status, BMS_Key
		INTO #Temp_BMS_WBS
		FROM SAP_WBS sap (NOLOCK) WHERE WBS_Code In (
			SELECT LTRIM(RTRIM(WBS_Code)) FROM @SAP_WBS_DATA		
		)
	
		;MERGE BMS_WBS BW
		USING #Temp_BMS_WBS TBW On LTRIM(RTRIM(TBW.WBS_Code)) = LTRIM(RTRIM(BW.WBS_Code)) --AND BW.IS_Process= 'P' 
		WHEN MATCHED
			THEN UPDATE SET BW.WBS_Description = TBW.WBS_Description,
						--	BW.Studio_Vendor = TBW.Studio_Vendor,						
							BW.[Status] = TBW.[Status],
							BW.Short_ID = TBW.Short_ID,
							BW.IS_Process = 'P'
							--,BW.Sport_Type = TBW.Sport_Type
		WHEN NOT MATCHED BY TARGET
			THEN  INSERT  ([SAP_WBS_Code], [WBS_Code], [WBS_Description], [Short_ID], [Is_Archive], [Status], [Error_Details], [Is_Process], [File_Code], [BMS_Key])
		VALUES(TBW.SAP_WBS_Code, TBW.WBS_Code, TBW.WBS_Description, TBW.Short_ID, CASE WHEN TBW.[Status] = 'REL' THEN 'N' ELSE 'Y' END, TBW.[Status], '' ,
		 'P' , NULL , BMS_Key
		 );

			IF OBJECT_ID('tempdb..#Temp_BMS_WBS') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_BMS_WBS
			END		

		--INSERT INTO BMS_WBS([SAP_WBS_Code], [WBS_Code], [WBS_Description], [Short_ID], [Is_Archive], [Status], [Error_Details], [Is_Process], [File_Code], [BMS_Key])
		--SELECT SAP_WBS_Code, WBS_Code, WBS_Description, Short_ID, CASE WHEN [Status] = 'REL' THEN 'N' ELSE 'Y' END, '', '', 'P', NULL, BMS_Key
		--FROM SAP_WBS sap WHERE WBS_Code In (
		--	SELECT LTRIM(RTRIM(WBS_Code)) FROM @SAP_WBS_DATA		
		--)

		Declare @WBS_CODES Varchar(MAX) = ''
		Select @WBS_CODES = @WBS_CODES + WBS_Code + ',' From @SAP_WBS_DATA WHERE [Status] IN ('TECO', 'CLSD''LKD')

		IF(LEN(@WBS_CODES) > 0)
		BEGIN
			SET @WBS_CODES = SUBSTRING(@WBS_CODES, LEN(@WBS_CODES), 1)
			EXEC USP_Send_Mail_WBS_Linked_Titles @WBS_CODES
		END

		IF OBJECT_ID('tempdb..#Temp_BMS_WBS') IS NOT NULL DROP TABLE #Temp_BMS_WBS
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_INSERT_SAP_WBS_UDT]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END