CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Rollback_Runs]
@Acq_Deal_Code INT
AS
-- =============================================
-- Author:		<Sagar Mahajan>
-- Create date: <29 Dec 2016>
-- Description:	<>
-- =============================================
BEGIN	
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Rollback_Runs]', 'Step 1', 0, 'Started Procedure', 0, ''
	DECLARE @BMS_Schedule_Process_Revert_UDT BMS_Schedule_Process_Revert_UDT
	IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Process_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_BMS_Schedule_Process_Data
	END		
	CREATE TABLE #Temp_BMS_Schedule_Process_Data 
	(
		BV_Schedule_Transaction_Code INT,
		Acq_Deal_Code INT,            			
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Run_Code INT,
		Agreement_Date DATETIME, 
		BMS_Asset_Ref_Key INT,
		BMS_Schedule_Log_Code INT,
		Channel_Code INT,
		ChannelWise_NoOfRuns INT, 
		ChannelWise_NoOfRuns_Schedule INT, 			
		Deal_Workflow_Status VARCHAR(2),
		Delete_Flag BIT,
		Do_Not_Consume VARCHAR(10),
		Is_In_BlackOut_Period VARCHAR(3),
		Is_In_Right_Perod VARCHAR(3),	
		--Is_Yearwise_Definition VARCHAR(10),	
		--No_Of_Runs INT, 
		--No_Of_Runs_Sched INT, 			
		Right_Start_Date  DATETIME  NULL,
		Right_End_Date DATETIME NULL,
		Right_Type VARCHAR(3),
		--Run_Definition_Type VARCHAR(3),
		Run_Type CHAR(1),
		Schedule_Log_Date  DATE,
		Schedule_Log_Time DATETIME , 
		Timeline_ID INT,
		Title_Code INT 			
	)
	INSERT INTO  #Temp_BMS_Schedule_Process_Data
	(						
		BV_Schedule_Transaction_Code,
		Acq_Deal_Code,            						
		Acq_Deal_Rights_Code,
		Acq_Deal_Run_Code ,
		Agreement_Date, 
		BMS_Asset_Ref_Key ,
		BMS_Schedule_Log_Code,
		Channel_Code,
		--ChannelWise_NoOfRuns, 
		--ChannelWise_NoOfRuns_Schedule, 			
		Deal_Workflow_Status,
		Delete_Flag ,						
		Is_In_BlackOut_Period,
		Is_In_Right_Perod,	
		--Is_Yearwise_Definition,							
		--No_Of_Runs,
		--No_Of_Runs_Sched,
		Right_Start_Date,
		Right_End_Date ,
		Right_Type ,
		--Run_Definition_Type,
		Run_Type,
		Schedule_Log_Date,
		Schedule_Log_Time , 
		Timeline_ID,
		Title_Code 
	)
	--SELECT DISTINCT
	--	TBSPD.BMS_Schedule_Process_Data_Code,
	--	VWB.Acq_Deal_Code,            						
	--	VWB.Acq_Deal_Rights_Code,	
	--	VWB.Acq_Deal_Run_Code ,
	--	VWB.Agreement_Date, 
	--	TBSPD.BMS_Asset_Ref_Key ,
	--	TBSPD.BMS_Schedule_Log_Code,
	--	VWB.Channel_Code,
	--	VWB.ChannelWise_NoOfRuns, 
	--	VWB.ChannelWise_NoOfRuns_Schedule, 			
	--	VWB.Deal_Workflow_Status,
	--	ISNULL(TBSPD.Delete_Flag,'false') AS Delete_Flag,														
	--	CASE WHEN 
	--		(
	--			CONVERT(DATETIME,TBSPD.Log_Date,101) 
	--			BETWEEN 
	--			CONVERT(DATETIME,VWB.Blackout_Start_Date,101)  AND CONVERT(DATETIME,VWB.Blackout_End_Date,101)  
	--		)   
	--		THEN 'Y' ELSE 'N' 
	--	END Is_In_BlackOut_Period,
	--	CASE WHEN 
	--		(                        
	--			CONVERT(DATETIME,TBSPD.Log_Date,101)
	--			BETWEEN 
	--			CONVERT(DATETIME,VWB.Actual_Right_Start_Date,101)  AND CONVERT(DATETIME,ISNULL(VWB.Actual_Right_End_Date,'31DEC9999'),101)
	--		OR 
	--			(VWB.right_type = 'U')
	--		)   
	--	THEN 'Y' ELSE 'N' 
	--	END Is_In_Right_Perod,
	--	VWB.Is_Yearwise_Definition,
	--	VWB.No_Of_Runs,
	--	VWB.No_Of_Runs_Sched,
	--	VWB.Actual_Right_Start_Date,
	--	VWB.Actual_Right_End_Date ,
	--	VWB.Right_Type ,
	--	ISNULL(VWB.Run_Definition_Type,'N'),
	--	ISNULL(VWB.Run_Type,'C'),
	--	CAST(TBSPD.Log_Date AS DATE) AS Schedule_Log_Date,
	--	CAST(CAST(TBSPD.Date_Time AS DATETIME2) AS DATETIME) AS Schedule_Log_Time , 
	--	TBSPD.Timeline_ID,
	--	VWB.Title_Code 
	--FROM VW_BMS_Schedule_Acq_Rights_Data VWB (NOLOCK)
	--INNER JOIN BMS_Schedule_Process_Data TBSPD ON VWB.Title_Code = TBSPD.Title_Code AND ISNULL(TBSPD.Title_Code,0) > 0 	
	--INNER JOIN BMS_Schedule_Runs BSR ON BSR.Acq_Deal_Run_Code = TBSPD.Acq_Deal_Run_Code AND BSR.Channel_Code = VWB.Channel_Code  	
	--AND VWB.Acq_Deal_Code = @Acq_Deal_Code 
	--ORDER BY VWB.Channel_Code

		SELECT DISTINCT
			BST.BV_Schedule_Transaction_Code,
			VWB.Acq_Deal_Code,            						
			VWB.Acq_Deal_Rights_Code,	
			VWB.Acq_Deal_Run_Code ,
			VWB.Agreement_Date, 
			BST.Program_Episode_ID ,
			BST.File_Code,
			VWB.Channel_Code,
			--VWB.ChannelWise_NoOfRuns, 
			--VWB.ChannelWise_NoOfRuns_Schedule, 			
			VWB.Deal_Workflow_Status,
			ISNULL(BST.Delete_Flag,'false') AS Delete_Flag,														
			CASE WHEN 
				(
					CONVERT(DATETIME,BST.Schedule_Item_Log_Date,101) 
					BETWEEN 
					CONVERT(DATETIME,VWB.Blackout_Start_Date,101)  AND CONVERT(DATETIME,VWB.Blackout_End_Date,101)  
				)   
				THEN 'Y' ELSE 'N' 
			END Is_In_BlackOut_Period,
			CASE WHEN 
				(                        
					CONVERT(DATETIME,BST.Schedule_Item_Log_Date,101)
					BETWEEN 
					CONVERT(DATETIME,VWB.Actual_Right_Start_Date,101)  AND CONVERT(DATETIME,ISNULL(VWB.Actual_Right_End_Date,'31DEC9999'),101)
				OR 
					(VWB.right_type = 'U')
				)   
			THEN 'Y' ELSE 'N' 
			END Is_In_Right_Perod,
			--VWB.Is_Yearwise_Definition,
			--VWB.No_Of_Runs,
			--VWB.No_Of_Runs_Sched,
			VWB.Actual_Right_Start_Date,
			VWB.Actual_Right_End_Date ,
			VWB.Right_Type ,
			--ISNULL(VWB.Run_Definition_Type,'N'),
			ISNULL(VWB.Run_Type,'C'),
			CAST(BST.Schedule_Item_Log_Date AS DATE) AS Schedule_Log_Date,
			CAST(CAST(BST.Schedule_Item_Log_Time AS DATETIME2) AS DATETIME) AS Schedule_Log_Time , 
			BST.Timeline_ID,
			VWB.Title_Code 
		FROM VW_BMS_Schedule_Acq_Rights_Data VWB 
		INNER JOIN BV_Schedule_Transaction BST (NOLOCK) ON VWB.Title_Code = BST.Title_Code AND ISNULL(BST.Title_Code,0) > 0 	
		INNER JOIN BMS_Schedule_Runs BSR (NOLOCK) ON BSR.Acq_Deal_Run_Code = BST.Acq_Deal_Run_Code AND BSR.Channel_Code = VWB.Channel_Code  	
		AND VWB.Acq_Deal_Code = @Acq_Deal_Code 
		ORDER BY VWB.Channel_Code

		--UPDATE BSPD SET BSPD.Is_Processed = 'P'
		--FROM #Temp_BMS_Schedule_Process_Data  TBSPDT
		--INNER JOIN BMS_Schedule_Process_Data BSPD ON TBSPDT.BMS_Schedule_Process_Data_Code = BSPD.BMS_Schedule_Process_Data_Code
		--AND TBSPDT.Timeline_ID = BSPD.Timeline_ID	

		UPDATE BST SET BST.IsProcessed= 'P'
		FROM #Temp_BMS_Schedule_Process_Data  TBSPDT
		INNER JOIN BV_Schedule_Transaction BST ON TBSPDT.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code
		AND TBSPDT.Timeline_ID = BST.Timeline_ID	

	/************* Start Cursor*/
	BEGIN 		
		/*********************************Declare global variables ******************/		
		DECLARE @ChannelCode INT = 0,@BMS_Schedule_LogCode INT  = 0
		DECLARE CR_BMS_Schedule_Reprocess CURSOR       
		FOR 
			SELECT DISTINCT TBSUDT.BMS_Schedule_Log_Code,TBSUDT.Channel_Code
			FROM #Temp_BMS_Schedule_Process_Data TBSUDT
		OPEN CR_BMS_Schedule_Reprocess  
		FETCH NEXT FROM CR_BMS_Schedule_Reprocess INTO @BMS_Schedule_LogCode,@ChannelCode
		WHILE @@FETCH_STATUS<>-1 
		BEGIN                                              
			IF(@@FETCH_STATUS<>-2)    --if While Loop(CR_BMS_Schedule_Reprocess)                                          
			BEGIN
				PRINT 'Cursor'		
				INSERT INTO @BMS_Schedule_Process_Revert_UDT
				(
					Acq_Deal_Code,Acq_Deal_Rights_Code,Acq_Deal_Run_Code ,
					Agreement_Date, BMS_Asset_Ref_Key,BMS_Schedule_Log_Code,Channel_Code,--ChannelWise_NoOfRuns,ChannelWise_NoOfRuns_Schedule,
					Delete_Flag,Is_In_BlackOut_Period,Is_In_Right_Perod,--Is_Yearwise_Definition,No_Of_Runs,No_Of_Runs_Sched,	
					Right_Start_Date,Right_End_Date ,Right_Type,Run_Type,--Run_Definition_Type,
					Schedule_Log_Date,
					Schedule_Log_Time ,Timeline_ID,Title_Code 						 
				)
				SELECT DISTINCT
					TBSPD.Acq_Deal_Code,TBSPD.Acq_Deal_Rights_Code,TBSPD.Acq_Deal_Run_Code,
					TBSPD.Agreement_Date,TBSPD.BMS_Asset_Ref_Key,TBSPD.BMS_Schedule_Log_Code,TBSPD.Channel_Code,
					--TBSPD.ChannelWise_NoOfRuns,TBSPD.ChannelWise_NoOfRuns_Schedule,
					TBSPD.Delete_Flag ,TBSPD.Is_In_BlackOut_Period,
					TBSPD.Is_In_Right_Perod,--TBSPD.Is_Yearwise_Definition,TBSPD.No_Of_Runs,TBSPD.No_Of_Runs_Sched,
					TBSPD.Right_Start_Date,ISNULL(TBSPD.Right_End_Date,'31DEC9999'), 
					TBSPD.Right_Type,TBSPD.Run_Type,--TBSPD.Run_Definition_Type,
					Schedule_Log_Date,Schedule_Log_Time,
					TBSPD.Timeline_ID,TBSPD.Title_Code
				FROM #Temp_BMS_Schedule_Process_Data TBSPD  WHERE TBSPD.BMS_Schedule_Log_Code = @BMS_Schedule_LogCode 
				AND TBSPD.Channel_Code = @ChannelCode			
			
		/******************Call USP_BMS_Schedule_Process******/
				IF EXISTS(SELECT TOP 1 BSPRU.Timeline_ID FROM @BMS_Schedule_Process_Revert_UDT BSPRU)
				BEGIN
					EXEC USP_BMS_Schedule_Process  @BMS_Schedule_Process_Revert_UDT-- For Process Schedule Run 	
				END
										
					DECLARE @Acq_Deal_RunCodes VARCHAR(MAX) = ''
					SELECT  @Acq_Deal_RunCodes = STUFF((SELECT DISTINCT  ',' +  CAST(ISNULL(TBSPD.Acq_Deal_Run_Code,0) AS VARCHAR)
					FROM #Temp_BMS_Schedule_Process_Data TBSPD WHERE ISNULL(TBSPD.Acq_Deal_Run_Code,0) > 0 
					AND TBSPD.BMS_Schedule_Log_Code = @BMS_Schedule_LogCode AND TBSPD.Channel_Code = @ChannelCode 
					FOR XML PATH('')), 1, 1, '')					
					--SELECT  @Acq_Deal_RunCodes AS Acq_Deal_RunCodes

					-- /******************Call BMS_Schedule_Reprocess_Runs******/
					-- IF(ISNULL(@Acq_Deal_RunCodes,'') <> '')
						-- EXEC USP_BMS_Schedule_Reprocess_Runs @Acq_Deal_RunCodes,@ChannelCode,''
							
					PRINT 'Completed Reprocess of Runs BMS_Schedule_Reprocess_Runs'
			END						--   --End if While Loop(CR_BMS_Schedule_Reprocess)                                          
			FETCH NEXT FROM CR_BMS_Schedule_Reprocess INTO @BMS_Schedule_LogCode,@ChannelCode
		END   -- -- While End(CR_BMS_Schedule_Reprocess)  		
		CLOSE CR_BMS_Schedule_Reprocess
		DEALLOCATE CR_BMS_Schedule_Reprocess
	END		
	/************* End Cursor*/
	IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Process_Data') IS NOT NULL DROP TABLE #Temp_BMS_Schedule_Process_Data

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Rollback_Runs]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END