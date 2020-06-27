CREATE PROC [dbo].[usp_Schedule_Validate_Temp_BV_Sche]  
(
	@File_Code BIGINT,
	@Channel_Code VARCHAR(10),
	@IsReprocess VARCHAR(10) = NULL,
	@BV_Episode_ID VARCHAR(1000) = NULL
)
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY	--{-- 'BEGIN TRY'	
--BEGIN TRANSACTION		--  Transaction begins here       

	-----1.0-----
	IF(ISNULL(@BV_Episode_ID, 'N') = '')
		SET @BV_Episode_ID = 'N'
	IF(@IsReprocess IS NULL)
		SET @IsReprocess = 'N'
	DECLARE @CanProcessRun INT = 0

	/* Ignore Category other than movie*/
	DELETE FROM Temp_BV_Schedule WHERE ISNULL(Program_Category,'') NOT IN (SELECT BV_Program_Category_Name FROM BV_Program_Category WHERE Is_Active = 'Y')
	AND File_Code = @File_Code
	-----1.0-----
	PRINT '1'
	--===============3.0 REVERT_SCHEDULE_COUNT --===============
	IF(@IsReprocess <> 'Y')
	BEGIN
		
		EXEC USP_Schedule_Revert_Count  @File_Code, @Channel_Code
	END
	PRINT '2'
	--===============3.1 Inital Validation OF Temp_BV_Schedule--===============		
	EXEC usp_Schedule_Validate_TempBVSche_S1 @File_Code, @Channel_Code, @IsReprocess, @BV_Episode_ID, @CanProcessRun OUT
	PRINT '3'
	IF(@IsReprocess <> 'Y' AND ISNULL(@BV_Episode_ID,'N') = 'N' )
	BEGIN	
		PRINT '4'
		PRINT '--===============7.0 Inserting all invalid housIds records into movie title mapping table --==============='		
		DECLARE @House_Ids_Cur NVARCHAR(MAX),  
		@Program_Cur NVARCHAR(MAX),  
		@Episode_Cur NVARCHAR(MAX),  
		@Program_Episode_ID NVARCHAR(1000)  ,
		@Program_Version_ID NVARCHAR(1000),
		@Schedule_Item_Log_Date VARCHAR(50),
		@Schedule_Item_Log_Time VARCHAR(50), 
		@Program_Category VARCHAR(250),
		@CUR_CNT INT = 0

		DECLARE CR_Title_HouseID_Data CURSOR                   
		FOR               
			SELECT 
			'1' AS Scheduled_Version_House_Number_List, 
			tbs.Program_Title, 
			CASE WHEN ISNULL(Program_Episode_Number,'1') = '' THEN '1' ELSE Program_Episode_Number END,
			Program_Episode_ID,
			Program_Version_ID,
			Schedule_Item_Log_Date,
			Schedule_Item_Log_Time ,
			Program_Category
			FROM Temp_BV_Schedule tbs WHERE tbs.File_Code = @File_Code
		OPEN CR_Title_HouseID_Data             
		FETCH NEXT FROM CR_Title_HouseID_Data INTO  @House_Ids_Cur, @Program_Cur, @Episode_Cur, @Program_Episode_ID, @Program_Version_ID, @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, @Program_Category
		WHILE @@FETCH_STATUS<>-1             
		BEGIN            
			IF(@@FETCH_STATUS<>-2)                                                          
			BEGIN            
				
				DECLARE @House_Ids_Split_Cr NVARCHAR(MAX)
				DECLARE CR_Split_HouseID CURSOR                   
				FOR SELECT LTRIM(RTRIM(number)) FROM dbo.fn_Split_withdelemiter(@House_Ids_Cur, ',')
				OPEN CR_Split_HouseID
				FETCH NEXT FROM CR_Split_HouseID INTO  @House_Ids_Split_Cr
					WHILE @@FETCH_STATUS<>-1             
					BEGIN            
					IF(@@FETCH_STATUS<>-2)                                                          
					BEGIN
					PRINT '5'            
						EXEC dbo.USP_UpdateParentHIDCodeForSameTitle @House_Ids_Split_Cr, @Program_Cur, @Episode_Cur, 'Standard', @File_Code, @Program_Episode_ID, @Program_Version_ID, @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, 'S', @Program_Category							
					END            
				FETCH NEXT FROM CR_Split_HouseID INTO  @House_Ids_Split_Cr
				END                                                       
				CLOSE CR_Split_HouseID            
				DEALLOCATE CR_Split_HouseID
				        
			END            
		FETCH NEXT FROM CR_Title_HouseID_Data INTO  @House_Ids_Cur, @Program_Cur, @Episode_Cur, @Program_Episode_ID, @Program_Version_ID, @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, @Program_Category
		END                                                       
		CLOSE CR_Title_HouseID_Data            
		DEALLOCATE CR_Title_HouseID_Data
			
		PRINT '--===============7.0 End Of Inserting all invalid houseds records into movie title mapping table --==============='		
			
		PRINT '--===============7.1 Second Level Validation of Temp_BV_Schedule --==============='		
			PRINT '6'
			EXEC usp_Schedule_Validate_TempBVSche_S1 @File_Code,	@Channel_Code, @IsReprocess, @BV_Episode_ID, @CanProcessRun OUT
			PRINT '7'
		------===============7.1 END OF Second Level Validation of Temp_BV_Schedule --==============='		

		PRINT '--===============8.0 Inserting all invalid houseds records into Upload_Err_Detail table --==============='		
		
		DELETE FROM Upload_Err_Detail WHERE File_Code = @File_Code AND Upload_Title_Type = 'M'

		INSERT INTO Upload_Err_Detail 
		(
			File_Code, Row_Num, Row_Delimed, Err_Cols, Upload_Type, Upload_Title_Type
		)
		SELECT DISTINCT @File_Code, 0, '~~' + Program_Title +' ~~~'+ '1' AS Scheduled_Version_House_Number_List, '1HID_N', 'S', 'M'
		FROM Temp_BV_Schedule UPT  
		WHERE 1=1 AND File_Code = @File_Code AND ISNULL(UPT.IsDealApproved,'Y') = 'Y'
		AND ISNULL(TitleCode, 0) = 0

		----------------8.1 SEND EXCEPTION EMAIL HOUSEDID NOT FOUND------------
		DECLARE @EmailMsg_InvalidHID NVARCHAR(MAX)
		SELECT @EmailMsg_InvalidHID = Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'HouseIDNotFound' AND [Type] = 'S'
			
		INSERT INTO Email_Notification_Schedule
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Email_Notification_Msg, IsMailSent, IsRunCountCalculate
		)
		SELECT tbs.Temp_BV_Schedule_Code, tbs.Program_Episode_Title, tbs.Program_Episode_Number, tbs.Program_Title, tbs.Program_Category,
		tbs.Schedule_Item_Log_Date, tbs.Schedule_Item_Log_Time, tbs.Schedule_Item_Duration, '1'  AS Scheduled_Version_House_Number_List,
		tbs.File_Code, tbs.Channel_Code, GETDATE(), @EmailMsg_InvalidHID, 'N', 'N'
		FROM Temp_BV_Schedule tbs
		CROSS APPLY fn_Split_withdelemiter(tbs.Scheduled_Version_House_Number_List, ',' ) AS tempCross
		WHERE 
		1=1 AND File_Code = @File_Code AND tempCross.id = 1
		AND ISNULL(tbs.IsDealApproved,'Y') = 'Y'
		AND ISNULL(TitleCode, 0) = 0

		--------- Update Fileds ---------
		UPDATE Email_Notification_Schedule
		SET Channel_Name = (SELECT Channel_Name AS Channel_Name FROM Channel WHERE Channel_Code = Email.Channel_Code)
		FROM Email_Notification_Schedule Email
		WHERE Email.File_Code = @File_Code		
		-------------------------------------------12.0 END DELETE TEMP TABLES -------------------------------------------	
	END

	PRINT '--===============11.0 PROCESS_DATA --==============='
	PRINT '8'		
		EXEC  USP_Schedule_Process @File_Code , @Channel_Code,0,'N', @CanProcessRun--,@Called_FROM_JOB
		PRINT '9'
		IF((SELECT ISNULL(Parameter_Value, 'N') FROM System_Parameter_New WHERE Parameter_Name = 'IS_Schedule_Mail_Channelwise')  = 'Y' )
		BEGIN
			EXEC usp_Schedule_SendException_Email @File_Code, @Channel_Code
		END	
		
		PRINT '--===============14.0 FINAL RETRUN RESULT --==============='		
		DECLARE @IsErrYN CHAR(1);	SET @IsErrYN = 'N'
		DECLARE @Count INT;			SET @Count = 0
		SELECT @Count = COUNT(*) FROM Temp_BV_Schedule WHERE File_Code = @File_Code
		IF(@Count > 0)
		BEGIN
			SET @IsErrYN = 'Y'
		END
		ELSE 
		BEGIN
			SET @IsErrYN = 'N'
			DELETE FROM Upload_Err_Detail WHERE File_code = @File_Code
		END

		UPDATE Upload_Files SET Err_YN = @IsErrYN WHERE File_code = @File_Code
		PRINT '--===============14.0 END FINAL RETRUN RESULT --==============='		


	--COMMIT TRANSACTION		--	On Completion Commiting Transaction
	END TRY	--}-- 'END TRY'
	BEGIN CATCH
		--ROLLBACK TRANSACTION	-- Rolling Back Transaction  
		PRINT 'ERROR'
		PRINT ERROR_MESSAGE() 
	
		INSERT INTO	ErrorOn_AsRun_Schedule
		SELECT
		ERROR_NUMBER() AS ERRORNUMBER,
		ERROR_SEVERITY() AS ERRORSEVERITY,		
		ERROR_STATE() AS ERRORSTATE,
		ERROR_PROCEDURE() AS ERRORPROCEDURE,
		ERROR_LINE() AS ERRORLINE,
		ERROR_MESSAGE() AS ERRORMESSAGE,
		@File_Code, @Channel_Code, 'S', GETDATE() 
	
		UPDATE Upload_Files SET Err_YN = 'Y' WHERE File_code = @File_Code
	
	END CATCH
	
END
  
/*  
EXEC [usp_Schedule_Validate_Temp_BV_Sche] 15892,13,'N'
*/
GO

