CREATE PROCEDURE [dbo].[USP_Integration_Runs_Insert]        
(        
 @Acq_Deal_Run_Channel_Code VARCHAR(MAX),  
 @Acq_Deal_Run_Yearwise_Run_Code VARCHAR(MAX)  
)        
AS        
-- =============================================        
-- Author:  <Sagar Mahajan>        
-- Create date: <18 July 2016>        
-- Description: <Call From USP_Schedule_Process , Insert Record into Integration_Runs>         
-- =============================================      
BEGIN 
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Integration_Runs_Insert]', 'Step 1', 0, 'Started Procedure', 0, ''  
		PRINT 'In USP_Integration_Runs_Insert'
		SET @Acq_Deal_Run_Channel_Code = ISNULL(@Acq_Deal_Run_Channel_Code, 0 )
		SET @Acq_Deal_Run_Yearwise_Run_Code = ISNULL(@Acq_Deal_Run_Yearwise_Run_Code, 0 )
			/*********************DROP Temp Tables if Exist***************************/
			IF OBJECT_ID('tempdb..#Temp_Integration_Runs') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Integration_Runs
			END	
			/*********************Create Temp Tables***************************/
			 CREATE TABLE #Temp_Integration_Runs
			 (			
					Acq_Deal_Run_Code INT,
					Title_Code INT,
					Channel_Code INT NULL,				
					Schedule_Run INT NULL,
					Prime_Runs_Sched  INT NULL ,
					Off_Prime_Runs_Sched  INT NULL,
					[Start_Date] DATETIME NULL,
					[End_Date]  DATETIME NULL
			 )
			/*********************Insert into Temp Tables***************************/
			INSERT INTO #Temp_Integration_Runs(Acq_Deal_Run_Code,Channel_Code,Schedule_Run,[Start_Date],End_Date)
			SELECT DISTINCT 
				ADRC.Acq_Deal_Run_Code,  		
				ADRC.Channel_Code,ADRC.No_Of_Runs_Sched, 
				NULL AS StartDate,NULL AS End_Date  
			FROM Acq_Deal_Run_Channel ADRC    (NOLOCK) 
			WHERE ADRC.Acq_Deal_Run_Channel_Code IN(
				SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Run_Channel_Code,',') 
			)
		
			UNION

			SELECT DISTINCT 
				ADRY.Acq_Deal_Run_Code,  		
				NULL AS Channel_Code,ADRY.No_Of_Runs_Sched,  
				ADRY.[Start_Date],ADRY.End_Date  
			FROM Acq_Deal_Run_Yearwise_Run ADRY  (NOLOCK)
			WHERE ADRY.Acq_Deal_Run_Yearwise_Run_Code IN(
				SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Run_Yearwise_Run_Code,',')
			) 
		
			/*********************Update Temp Tables***************************/
			-- SELECT * 		 
			 UPDATE temp SET temp.Title_Code = ADRT.Title_Code , temp.Prime_Runs_Sched = ADR.Prime_Time_Provisional_Run_Count,Off_Prime_Runs_Sched = ADR.Off_Prime_Time_Provisional_Run_Count
			 FROM  #Temp_Integration_Runs temp 
			 INNER JOIN Acq_Deal_Run ADR ON temp.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			 INNER JOIN Acq_Deal_Run_Title ADRT  ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND ISNULL(temp.Acq_Deal_Run_Code,0) > 0

			 /*********************Insert or Update Integration_Runs ***************************/
				MERGE Integration_Runs IR
				USING  #Temp_Integration_Runs TIR
					  ON TIR.Acq_Deal_Run_Code= IR.Acq_Deal_Run_Code AND IR.ISRead = 'N'
					  AND
					  (
						  (	
							ISNULL(TIR.ChanneL_Code,0)  = 0 AND			
							TIR.[Start_Date]= IR.[Start_Date] AND TIR.End_Date= IR.End_Date
						  )
						  OR
						  (				
							ISNULL(TIR.ChanneL_Code,0)  > 0 AND		
							TIR.ChanneL_Code= IR.ChanneL_Code						
						  )
					  )	
				WHEN MATCHED  THEN
						  UPDATE SET IR.Schedule_Run = TIR.Schedule_Run,
						  IR.Prime_Runs_Sched = TIR.Prime_Runs_Sched,
						  IR.Off_Prime_Runs_Sched = TIR.Off_Prime_Runs_Sched,
						  IR.Title_Code =  TIR.Title_Code
				WHEN NOT MATCHED BY TARGET THEN	
					INSERT (Acq_Deal_Run_Code,Title_Code,Channel_Code,Schedule_Run,Prime_Runs_Sched,Off_Prime_Runs_Sched ,[Start_Date],End_Date)
					VALUES (TIR.Acq_Deal_Run_Code,TIR.Title_Code,TIR.Channel_Code,TIR.Schedule_Run,TIR.Prime_Runs_Sched,TIR.Off_Prime_Runs_Sched ,TIR.[Start_Date],TIR.End_Date);	  						  
	

				IF OBJECT_ID('tempdb..#Temp_Integration_Runs') IS NOT NULL DROP TABLE #Temp_Integration_Runs

			 
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Integration_Runs_Insert]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END