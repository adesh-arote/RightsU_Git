CREATE PROCEDURE [dbo].[USP_Update_Syn_Acq_Mapping]	
(
	@Acq_Deal_Code INT,
	@Acq_Deal_Rights_Code VARCHAR(1000),
	@Map_Syn_Deal_Rights_Code VARCHAR(1000)
)	
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 15 April 2015
-- Description:	Call From Save Acq Rights(only Summary and details)  
-- =============================================

BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON;
	/******************************** Delete Temp Tables*********************************/
	IF OBJECT_ID('tempdb..#Temp_Syn_Rights') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Syn_Rights
	END
	IF OBJECT_ID('tempdb..#Temp_Rights_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Code
	END
	IF OBJECT_ID('tempdb..#Temp_Syn_Rights_Title_Plt') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Syn_Rights_Title_Plt
	END

	DECLARE @Cur_Rights_Code INT = 0
	/******************************** INSERT INTO Temp Tables(Syn Rights)*********************************/
	SELECT DISTINCT SDR.Syn_Deal_Code,SDR.Syn_Deal_Rights_Code,
		SDR.Actual_Right_Start_Date AS Actual_Right_Start_Date,SDR.Actual_Right_End_Date  AS Actual_Right_End_Date
	INTO #Temp_Syn_Rights
	FROM Syn_Deal_Rights SDR 
	WHERE  SDR.Syn_Deal_Rights_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Map_Syn_Deal_Rights_Code,','))

	SELECT DISTINCT SDR.Syn_Deal_Code,SDRT.Syn_Deal_Rights_Code,
		SDRT.Title_Code,SDRT.Episode_From,SDRT.Episode_To,SDRP.Platform_Code,SDR.Actual_Right_Start_Date,SDR.Actual_Right_End_Date
	INTO #Temp_Syn_Rights_Title_Plt
	FROM #Temp_Syn_Rights SDR
	INNER JOIN  Syn_Deal_Rights_Title SDRT  ON SDR.Syn_Deal_Rights_Code =SDRT.Syn_Deal_Rights_Code
	INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDRT.Syn_Deal_Rights_Code= SDRP.Syn_Deal_Rights_Code 

	DROP TABLE #Temp_Syn_Rights

	SELECT number AS Acq_Deal_Rights_Code 
	INTO #Temp_Rights_Code
	FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Code,',')

	/******************************** Start Cursor*********************************/
	DECLARE CR_Rights_Data CURSOR                   
	FOR               
		SELECT DISTINCT TRC.Acq_Deal_Rights_Code 		
		FROM #Temp_Rights_Code TRC				
	OPEN CR_Rights_Data             
		FETCH NEXT FROM CR_Rights_Data INTO  @Cur_Rights_Code
		WHILE @@FETCH_STATUS<>-1             
			BEGIN            
				IF(@@FETCH_STATUS<>-2)                                                          
				BEGIN 
					DELETE FROM Syn_Acq_Mapping WHERE Deal_Rights_Code = @Cur_Rights_Code
					IF EXISTS (SELECT TOP 1 ADRT.Acq_Deal_Rights_Code 
							   FROM  Acq_Deal_Rights_Title ADRT 
							   INNER JOIN Acq_Deal_Rights_Platform  ADRP ON ADRT.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
							   WHERE ADRT.Title_Code IN
							   (
									SELECT TSRTP.Title_Code FROM #Temp_Syn_Rights_Title_Plt TSRTP
									WHERE
									( 
										TSRTP.Episode_From BETWEEN ADRT.Episode_From AND ADRT.Episode_To
										OR TSRTP.Episode_To BETWEEN ADRT.Episode_From AND ADRT.Episode_To
									)
									OR
									(
										ADRT.Episode_From BETWEEN TSRTP.Episode_From AND TSRTP.Episode_To
										OR ADRT.Episode_To BETWEEN TSRTP.Episode_From AND TSRTP.Episode_To
									)
							   ) 
							   AND ADRP.Platform_Code IN
							   (
									SELECT TSRTP.Platform_Code FROM #Temp_Syn_Rights_Title_Plt TSRTP
							   )
							   AND ADRT.Acq_Deal_Rights_Code = @Cur_Rights_Code
							  )
							  BEGIN
								DECLARE @Actual_Right_Start_Date DateTime='',@Actual_Right_End_Date DateTime=''								
								SELECT @Actual_Right_Start_Date =ADR.Actual_Right_Start_Date,
									@Actual_Right_End_Date =ADR.Actual_Right_End_Date   
								FROM Acq_Deal_Rights ADR 
								WHERE Acq_Deal_Rights_Code = @Cur_Rights_Code										
								
								INSERT INTO Syn_Acq_Mapping(
									Syn_Deal_Code,Syn_Deal_Movie_Code,Syn_Deal_Rights_Code,
									Deal_Code,Deal_Movie_Code,Deal_Rights_Code,Right_Start_Date,Right_End_Date)
								SELECT DISTINCT TSRT.Syn_Deal_Code,0,TSRT.Syn_Deal_Rights_Code,@Acq_Deal_Code,0,
									@Cur_Rights_Code,									
									CASE WHEN @Actual_Right_Start_Date < TSRT.Actual_Right_Start_Date THEN TSRT.Actual_Right_Start_Date 
										ELSE @Actual_Right_Start_Date 
									END AS Actual_Right_Start_Date,		
									CASE WHEN ISNULL(@Actual_Right_End_Date, TSRT.Actual_Right_End_Date) > TSRT.Actual_Right_End_Date 
										THEN TSRT.Actual_Right_End_Date ELSE ISNULL(@Actual_Right_End_Date, TSRT.Actual_Right_End_Date) 
									END AS Actual_Right_End_Date
								FROM #Temp_Syn_Rights_Title_Plt TSRT
								--SELECT 'sagar',* FROM Syn_Acq_Mapping WHERE Deal_Rights_Code = @Cur_Rights_Code
							  END
				END
				FETCH NEXT FROM CR_Rights_Data INTO  @Cur_Rights_Code			                                                       			
			END
	CLOSE CR_Rights_Data            
	DEALLOCATE CR_Rights_Data			
	/******************************** DROP TABLE*********************************/
	DROP TABLE #Temp_Syn_Rights_Title_Plt
	DROP TABLE #Temp_Rights_Code

	SELECT 'Success' AS RESULT

	IF OBJECT_ID('tempdb..#Temp_Rights_Code') IS NOT NULL DROP TABLE #Temp_Rights_Code
	IF OBJECT_ID('tempdb..#Temp_Syn_Rights') IS NOT NULL DROP TABLE #Temp_Syn_Rights
	IF OBJECT_ID('tempdb..#Temp_Syn_Rights_Title_Plt') IS NOT NULL DROP TABLE #Temp_Syn_Rights_Title_Plt
END