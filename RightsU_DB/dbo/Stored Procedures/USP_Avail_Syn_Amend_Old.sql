Create PROCEDURE [dbo].[USP_Avail_Syn_Amend_Old]
	@Syn_Deal_Code INT = 0
AS
--=============================================
-- Author:		Pavitar Dua
-- Create DATE: 15-April-2014
-- Description:	Calculate Availability After Syndication changes
-- =============================================
BEGIN
	DECLARE 
	@Title_Code INT,
	@Platform_Code INT,
	@Country_Code INT,
	@RSD DATE,
	@RED DATE,
	@Dubbing_Subtitling VARCHAR(2)='',
	@Language_Code INT=0
	 
	
	SELECT distinct Title_Code,Platform_Code,Country_Code
	into #tmpAvailSyn
	FROM Avail_Syn  AVS
	INNER JOIN Avail_Syn_Details AVSD ON AVS.Avail_Syn_Code=AVSD.Avail_Syn_Code
	WHERE AVSD.Syn_Deal_Code = @Syn_Deal_Code	

	/* Calculation of Availability */
	DECLARE curCalculateAvail CURSOR
	READ_ONLY
	FOR SELECT AVS.Title_Code,AVS.Platform_Code,AVS.Country_Code,AVSD.Rights_Start_Date,AVSD.Rights_End_Date
	           ,AVSL.Language_Code,AVSL.Dubbing_Subtitling
		FROM Avail_Syn  AVS
		INNER JOIN Avail_Syn_Details AVSD ON AVS.Avail_Syn_Code=AVSD.Avail_Syn_Code
		INNER JOIN #tmpAvailSyn tmpAS on tmpAS.Country_Code=AVS.Country_Code and tmpAS.Platform_Code=AVS.Platform_Code and tmpAS.Title_Code=AVS.Title_Code
		LEFT JOIN Avail_Syn_Language AVSL ON AVS.Avail_Syn_Code=AVSL.Avail_Syn_Code
		
	
	DECLARE @SYN_RSD DATE,@SYN_RED DATE
	OPEN curCalculateAvail

	FETCH NEXT FROM curCalculateAvail INTO @Title_Code, @Platform_Code, @Country_Code, @SYN_RSD, @SYN_RED, @Language_Code, @Dubbing_Subtitling
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			DECLARE @isLanguage CHAR(1)='N'
			IF(@Language_Code > 0 and @Dubbing_Subtitling !='') SET @isLanguage='Y'
			
			SELECT @SYN_RSD SYN_RSD, @SYN_RED SYN_RED--,DATEDIFF(D,@SYN_RSD,@SYN_RED) differdat
			SELECT CONVERT(DATE,ADR.right_start_Date,103) ACQ_RSD,CONVERT(DATE,ADR.right_end_Date,103) ACQ_RED	   
				FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Territory ADRTerr ON ADRTerr.Acq_Deal_Rights_code = ADR.Acq_Deal_Rights_code
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				WHERE 
				ADRT.Title_Code=@Title_Code 
				AND ADRP.Platform_Code=@Platform_Code 
				AND Country_Code=@Country_Code
				AND (@SYN_RSD between CONVERT(DATE,ADR.Right_Start_Date,103) AND CONVERT(DATE,ADR.Right_End_Date,103))
				AND (@SYN_RED between CONVERT(DATE,ADR.Right_Start_Date,103) AND CONVERT(DATE,ADR.Right_End_Date,103))
				
			/* store avail in acq tables */
			DECLARE curAvail_Acq CURSOR
			--READ_ONLY
			FOR SELECT CONVERT(DATE,ADR.right_start_Date,103) ACQ_RSD,CONVERT(DATE,ADR.right_end_Date,103) ACQ_RED	   
				FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Territory ADRTerr ON ADRTerr.Acq_Deal_Rights_code = ADR.Acq_Deal_Rights_code
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				WHERE 
				ADRT.Title_Code=@Title_Code 
				AND ADRP.Platform_Code=@Platform_Code 
				AND Country_Code=@Country_Code
				AND (@SYN_RSD between CONVERT(DATE,ADR.Right_Start_Date,103) AND CONVERT(DATE,ADR.Right_End_Date,103))
				AND (@SYN_RED between CONVERT(DATE,ADR.Right_Start_Date,103) AND CONVERT(DATE,ADR.Right_End_Date,103))
			
			DECLARE @ACQ_RSD DATE,@ACQ_RED DATE							
			OPEN curAvail_Acq

			FETCH NEXT FROM curAvail_Acq INTO @ACQ_RSD,@ACQ_RED
			WHILE (@@fetch_status <> -1)
			BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
					--EXEC USP_Cal_Availability 304
					DECLARE @Avail_Acq_Code numeric(38,0)
					DECLARE @Acq_Deal_Code INT
					
					SELECT @Avail_Acq_Code=AVA.Avail_Acq_Code											
						   ,@Acq_Deal_Code=AVAD.Acq_Deal_Code
					FROM Avail_Acq AVA
					LEFT JOIN Avail_Acq_Details AVAD ON AVA.Avail_Acq_Code=AVAD.Avail_Acq_Code
					LEFT JOIN Avail_Acq_Language AVAL ON AVA.Avail_Acq_Code=AVAL.Avail_Acq_Code
					WHERE Title_Code=@Title_Code 
					AND Platform_Code=@Platform_Code 					
					AND Country_Code=@Country_Code					
					AND (Language_Code=@Language_Code OR 1=1) AND (Dubbing_Subtitling=@Dubbing_Subtitling OR 1=1)
					-- Syndication START DATE != Acquisition START DATE
					-- Syn St date - 1 day
					-- => AcQ St Date				TO			Syn St date - 1 day
					
					-- Syndication END DATE	  != Acquisition END DATE
					-- Syn En date + 1 day 
					-- => Syn En date + 1 day		TO			AcQ EN Date
					Print @Avail_Acq_Code
					PRINT @ACQ_RSD
					PRINT @ACQ_RED
					
					  IF(@SYN_RSD = @ACQ_RSD and @ACQ_RED=@SYN_RED)                               
					  BEGIN                              
					    PRINT '@SYN_RSD = @ACQ_RSD and @ACQ_RED=@SYN_RED'
					  END
					  ELSE 
					  BEGIN
						Print ' !(@SYN_RSD = @ACQ_RSD and @ACQ_RED=@SYN_RED)  => Delete'
						DELETE AVAD 
						--SELECT AVAD.Avail_Acq_Code,'Trial'
						FROM Avail_Acq_Details  AVAD					
						INNER JOIN Avail_Acq AVA ON AVAD.Avail_Acq_Code=AVA.Avail_Acq_Code
						WHERE AVA.Avail_Acq_Code=@Avail_Acq_Code
						AND Title_Code=@Title_Code 
						AND Platform_Code=@Platform_Code 
						AND Country_Code=@Country_Code
						
						IF(@isLanguage ='Y')
						BEGIN 
							DELETE AVAL							
							FROM Avail_Acq_Language  AVAL		
							INNER JOIN Avail_Acq AVA ON AVAL.Avail_Acq_Code=AVA.Avail_Acq_Code
							WHERE AVA.Avail_Acq_Code=@Avail_Acq_Code
							AND Title_Code=@Title_Code 
							AND Platform_Code=@Platform_Code 
							AND Country_Code=@Country_Code
							AND Language_Code=@Language_Code
							AND Dubbing_Subtitling=@Dubbing_Subtitling
						END
					  END
					                                
					  IF(@SYN_RSD = @ACQ_RSD and @SYN_RED < @ACQ_RED)                               
					  BEGIN           
					    Print '@SYN_RSD = @ACQ_RSD and @SYN_RED < @ACQ_RED'
						INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
						SELECT  @Avail_Acq_Code ,dateadd(d,1,@SYN_RED), @ACQ_RED ,@Acq_Deal_Code
						
						IF(@isLanguage ='Y')
						BEGIN 
							INSERT INTO Avail_Acq_Language
							(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
							SELECT  @Avail_Acq_Code ,dateadd(d,1,@SYN_RED), @ACQ_RED, @Language_Code, @Dubbing_Subtitling ,@Acq_Deal_Code
						END
					  END                              
					                                
					  IF(@SYN_RSD > @ACQ_RSD and @SYN_RED = @ACQ_RED)                               
					  BEGIN
					   Print '@SYN_RSD > @ACQ_RSD and @SYN_RED = @ACQ_RED'
					   INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
					   SELECT @Avail_Acq_Code , DATEADD(d,0,@ACQ_RSD), dateadd(d,-1,@SYN_RSD),@Acq_Deal_Code
					   IF(@isLanguage ='Y')
					   BEGIN 
							INSERT INTO Avail_Acq_Language
							(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
							SELECT @Avail_Acq_Code , DATEADD(d,0,@ACQ_RSD), dateadd(d,-1,@SYN_RSD), @Language_Code, @Dubbing_Subtitling,@Acq_Deal_Code
					   END						   
					  END                              
					                                
					  IF(@SYN_RSD > @ACQ_RSD and @SYN_RED < @ACQ_RED)                               
					  BEGIN                              
					   Print '@SYN_RSD > @ACQ_RSD and @SYN_RED < @ACQ_RED'          
					   SELECT @Avail_Acq_Code
					   
					   INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
					   SELECT  @Avail_Acq_Code, @ACQ_RSD , dateadd(d,-1,@SYN_RSD),@Acq_Deal_Code
					                                 
					   INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
					   SELECT @Avail_Acq_Code, DATEADD(d ,1,@SYN_RED),@ACQ_RED,@Acq_Deal_Code					                             

					   IF(@isLanguage ='Y')
					   BEGIN 
							INSERT INTO Avail_Acq_Language
							(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
							SELECT  @Avail_Acq_Code, @ACQ_RSD , dateadd(d,-1,@SYN_RSD), @Language_Code, @Dubbing_Subtitling,@Acq_Deal_Code
							
							INSERT INTO Avail_Acq_Language
							(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
							SELECT @Avail_Acq_Code, DATEADD(d ,1,@SYN_RED),@ACQ_RED, @Language_Code, @Dubbing_Subtitling,@Acq_Deal_Code					                             		
					   END
					                               
					  END  					
				
				END			
				FETCH NEXT FROM curAvail_Acq INTO @ACQ_RSD,@ACQ_RED
			END

			CLOSE curAvail_Acq
			DEALLOCATE curAvail_Acq
			/* store avail in acq tables */
						
		END			
		FETCH NEXT FROM curCalculateAvail INTO @Title_Code, @Platform_Code, @Country_Code, @SYN_RSD, @SYN_RED, @Language_Code, @Dubbing_Subtitling
	END

	CLOSE curCalculateAvail
	DEALLOCATE curCalculateAvail	

END

print 'Proc [USP_Avail_Syn_Amend] called '


drop table #tmpAvailSyn