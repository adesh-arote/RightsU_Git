CREATE PROC [dbo].[usp_Schedule_Mapped_titles]  
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[usp_Schedule_Mapped_titles]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @File_Code INT,
		@Channel_Code INT,
		@BV_HouseId_Data_Code int,
		@BV_Title NVARCHAR(MAX),
		@Program_Episode_ID NVARCHAR(MAX)
			
		SET @File_Code  = 0
		SET @Channel_Code  = 0
		SET @BV_HouseId_Data_Code = 0
		SET  @BV_Title  = ''
		SET @Program_Episode_ID = ''
		BEGIN /*Process Mapped Title data */
			DECLARE CR_Mapped_titles_OUTER_1 CURSOR
			FOR
					SELECT DISTINCT BV_HouseId_Data_Code,BHD.BV_Title,Program_Episode_ID FROM BV_HouseId_Data BHD (NOLOCK)
					WHERE ISNULL(IsProcessed,'N') = 'N' and Is_Mapped = 'Y' AND ISNULL([TYPE],'S') = 'S'
			OPEN CR_Mapped_titles_OUTER_1
			FETCH NEXT FROM CR_Mapped_titles_OUTER_1 INTO  @BV_HouseId_Data_Code,@BV_Title,@Program_Episode_ID
			WHILE @@FETCH_STATUS<>-1
			BEGIN
				IF(@@FETCH_STATUS<>-2)
				BEGIN
					DECLARE CR_Mapped_titles_Inner_1 CURSOR
					FOR
						select distinct File_Code,Channel_Code from Temp_BV_Schedule (NOLOCK) where Program_Episode_ID=@Program_Episode_ID
					OPEN CR_Mapped_titles_Inner_1
					FETCH NEXT FROM CR_Mapped_titles_Inner_1 INTO  @File_Code,@Channel_Code
					WHILE @@FETCH_STATUS<>-1
					BEGIN            
						IF(@@FETCH_STATUS<>-2)
						BEGIN
							------------------------------------------- END GLOBAL VARIBALES -------------------------------------------
							DECLARE @IsReprocess VARCHAR(10);	SET @IsReprocess = 'N'
							EXEC [usp_Schedule_Validate_Temp_BV_Sche] @File_Code, @Channel_Code, @IsReprocess,@Program_Episode_ID
						END
						FETCH NEXT FROM CR_Mapped_titles_Inner_1 INTO  @File_Code,@Channel_Code
					END
					CLOSE CR_Mapped_titles_Inner_1
					DEALLOCATE CR_Mapped_titles_Inner_1
					update BV_HouseId_Data set IsProcessed = 'Y' where BV_HouseId_Data_Code = @BV_HouseId_Data_Code

					DELETE FROM Email_Notification_Schedule WHERE Program_Title = @BV_Title AND Email_Notification_Msg = 'BV Programme ID Not Found.' 
				END            
			FETCH NEXT FROM CR_Mapped_titles_OUTER_1 INTO  @BV_HouseId_Data_Code,@BV_Title,@Program_Episode_ID
			END
			CLOSE CR_Mapped_titles_OUTER_1
			DEALLOCATE CR_Mapped_titles_OUTER_1
		/*Process Mapped Title data */
		END

		BEGIN /*Process Deal Approved Data which was earlier not processed as the deal was in ammendment state*/
		DECLARE @Temp_BV_Schedule_Code INT 
			
		SET @Temp_BV_Schedule_Code = 0
		SET @Program_Episode_ID = ''
		DECLARE CR_Mapped_titles_OUTER_2 CURSOR
		FOR  
			--SELECT DISTINCT TBS.Temp_BV_Schedule_Code,TBS.Program_Episode_ID  FROM Temp_BV_Schedule TBS
			--INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = TBS.Program_Episode_ID
			--INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code
			--WHERE 1=1 AND TBS.IsDealApproved = 'N'

			select distinct TBS.Temp_BV_Schedule_Code,TBS.Program_Episode_ID  FROM Temp_BV_Schedule TBS (NOLOCK)
			INNER JOIN Title_Content TC (NOLOCK) ON TC.Ref_BMS_Content_Code = TBS.Program_Episode_ID
			INNER JOIN Content_Channel_Run ccr (NOLOCK) ON ccr.Title_Content_Code = TC.Title_Content_Code  
			LEFT JOIN Acq_Deal ad (NOLOCK) ON ad.Acq_Deal_Code = ccr.Acq_Deal_Code AND ISNULL(ccr.Deal_Type, 'A') = 'A'  
			LEFT JOIN Provisional_Deal pd (NOLOCK) ON pd.Provisional_Deal_Code = ccr.Provisional_Deal_Code AND ISNULL(ccr.Deal_Type, 'A') = 'P'  
			WHERE 1=1   
			--AND d.is_active = 'Y'   
			AND ((ad.Deal_Workflow_Status = 'A'  AND ISNULL(ccr.Deal_Type, 'A') = 'A') OR (pd.Deal_Workflow_Status = 'A'  AND ISNULL(ccr.Deal_Type, 'A') = 'P'))  
			AND TBS.IsDealApproved = 'N' 
			
		OPEN CR_Mapped_titles_OUTER_2
		FETCH NEXT FROM CR_Mapped_titles_OUTER_2 INTO  @Temp_BV_Schedule_Code,@Program_Episode_ID
		WHILE @@FETCH_STATUS<>-1
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				DECLARE CR_Mapped_titles_Inner_2 CURSOR
				FOR
					SELECT DISTINCT File_Code,Channel_Code FROM Temp_BV_Schedule WHERE Program_Episode_ID=@Program_Episode_ID AND IsDealApproved = 'N'
				OPEN CR_Mapped_titles_Inner_2
				FETCH NEXT FROM CR_Mapped_titles_Inner_2 INTO  @File_Code,@Channel_Code
				WHILE @@FETCH_STATUS<>-1
				BEGIN
					IF(@@FETCH_STATUS<>-2)
					BEGIN
						EXEC [usp_Schedule_Validate_Temp_BV_Sche] @File_Code, @Channel_Code, @IsReprocess,@Program_Episode_ID
					END
					FETCH NEXT FROM CR_Mapped_titles_Inner_2 INTO  @File_Code,@Channel_Code
				END
				CLOSE CR_Mapped_titles_Inner_2
				DEALLOCATE CR_Mapped_titles_Inner_2

				DELETE FROM Email_Notification_Schedule WHERE BV_Schedule_Transaction_Code = @Temp_BV_Schedule_Code
				UPDATE Temp_BV_Schedule SET IsDealApproved = 'Y' WHERE Temp_BV_Schedule_Code = @Temp_BV_Schedule_Code
				DELETE FROM BV_HouseId_Data WHERE Program_Episode_ID = @Program_Episode_ID
			END            
		FETCH NEXT FROM CR_Mapped_titles_OUTER_2 INTO  @Temp_BV_Schedule_Code,@Program_Episode_ID
		END
		CLOSE CR_Mapped_titles_OUTER_2
		DEALLOCATE CR_Mapped_titles_OUTER_2
		END
			
		BEGIN /*Process EMails*/
			if((SELECT ISNULL(Parameter_Value,'N') FROM System_Parameter_New WHERE Parameter_Name ='IS_Schedule_Mail_Channelwise')  = 'N' )
			BEGIN
				EXEC usp_Schedule_SendException_Userwise_Email
			END
		END	/*Process EMails*/
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[usp_Schedule_Mapped_titles]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
