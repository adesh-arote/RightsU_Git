CREATE PROCEDURE [dbo].[USP_Avail_Acq_Amend] 
	-- Add the parameters for the stored procedure here
	@pDeal_Code INT = 0	
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 17-April-2014
-- Description:	Calculate Availability After Acquisition changes
-- Modified By : Reshma Kunjal
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Avail_Acq_Amend]', 'Step 1', 0, 'Started Procedure', 0, ''
			SELECT 
				 ADR.Acq_Deal_Rights_Code
				,ADRT.Title_Code
				,ADRP.Platform_Code
				,ADRC.Country_Code
				,ADR.Right_Start_Date
				,ADR.Right_End_Date		
				,ADR.Sub_License_Code
				,isnull(AVA.Avail_Acq_Code,0) Avail_Acq_Code
			into #tmpAVA
			FROM 
				Acq_Deal_Rights ADR (NOLOCK)
				INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADRP.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Territory ADRC (NOLOCK) ON ADRC.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
				INNER JOIN Country C (NOLOCK) ON ADRC.Country_Code=C.Country_Code AND C.Is_Theatrical_Territory='N'
				INNER JOIN Sub_License SL (NOLOCK) ON SL.Sub_License_Code=ADR.Sub_License_Code
				left join Avail_Acq AVA (NOLOCK) on AVA.Title_Code=ADRT.Title_Code
				and AVA.Platform_Code=ADRP.Platform_Code and AVA.Country_Code=ADRC.Country_Code and AVA.Sub_Licencing_Code=SL.Sub_License_Code
			WHERE 
				ADR.Is_Sub_License='Y' And Acq_Deal_Code = @pDeal_Code 

			--Delete the Records which are removed in ammend -Avail_Acq_Details 
			Delete from Avail_Acq_Details where Avail_Acq_Details_code in (
			select Avail_Acq_Details_code from Avail_Acq_Details AAD (NOLOCK) 
			left JOIN #tmpAVA TA on TA.Avail_Acq_Code=AAD.Avail_Acq_Code
			where AAD.ACQ_DEAL_CODE=@pDeal_Code
			and isnull(TA.Avail_Acq_Code,0)=0)

			--Delete the Records which are removed in ammend -Avail_Acq_Language
			Delete from Avail_Acq_Language where Avail_Acq_Language in (
			select Avail_Acq_Language from Avail_Acq_Language AAL  (NOLOCK)
			left JOIN #tmpAVA TA on TA.Avail_Acq_Code=AAL.Avail_Acq_Code
			where AAL.ACQ_DEAL_CODE=@pDeal_Code
			and isnull(TA.Avail_Acq_Code,0)=0)

			--Delete the Dubbing Language Records which are removed in ammend -Avail_Acq_Dubbing
			Delete from Avail_Acq_Language where Avail_Acq_Language in (
			select Avail_Acq_Language from Avail_Acq_Language AAL (NOLOCK)
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code=AAL.Acq_Deal_Code
			LEFT JOIN Acq_Deal_Rights_Dubbing ADRD (NOLOCK) ON ADRD.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
					  and ADRD.Language_Code=AAL.Language_Code
			WHERE ADR.Acq_Deal_Code=@pDeal_Code AND AAL.Dubbing_Subtitling='D'
			AND ISNULL(ADRD.Acq_Deal_Rights_Dubbing_Code,0)=0)

			--Delete the SubTitling Language Records which are removed in ammend -Avail_Acq_Subtitling
			Delete from Avail_Acq_Language where Avail_Acq_Language in (
			select Avail_Acq_Language from Avail_Acq_Language AAL (NOLOCK)
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code=AAL.Acq_Deal_Code
			LEFT JOIN Acq_Deal_Rights_Subtitling ADRS (NOLOCK) ON ADRS.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
					  and ADRS.Language_Code=AAL.Language_Code
			WHERE ADR.Acq_Deal_Code=@pDeal_Code AND AAL.Dubbing_Subtitling='S'
			AND ISNULL(ADRS.Acq_Deal_Rights_Subtitling_Code,0)=0)

		 
		BEGIN
		DECLARE curDMR CURSOR
		READ_ONLY
		FOR SELECT Acq_Deal_Rights_Code,Title_Code,Platform_Code,Country_Code,Right_Start_Date,Right_End_Date,Sub_License_Code,Avail_Acq_Code FROM #tmpAVA
	
		DECLARE @Acq_Deal_Rights_Code INT,@Title_code INT,@Platform_Code INT,@Country_Code INT,@RSD DATE,@RED DATE,@Sub_License_Code INT,@Avail_Acq_Code INT
		OPEN curDMR
		FETCH NEXT FROM curDMR INTO @Acq_Deal_Rights_Code,@Title_code,@Platform_Code,@Country_Code,@RSD,@RED,@Sub_License_Code ,@Avail_Acq_Code 
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN				
			
				declare @isNewRecord int=0
				--Insert the New added "Title_Code,Platform_Code,Country_Code,Sub_Licencing_Code" Combination
				if(@Avail_Acq_Code=0)
				BEGIN
					Insert into Avail_Acq (Title_Code,Platform_Code,Country_Code,Sub_Licencing_Code)
					select @Title_Code,@Platform_Code,@Country_Code,@Sub_License_Code

					set @Avail_Acq_Code=@@IDENTITY
					set @isNewRecord=1

					--Insert into Table Avail_Acq_Details 
					Insert into Avail_Acq_Details (Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
					select @Avail_Acq_Code,@RSD,@RED,@pDeal_Code
				END

				DECLARE @CountACQ INT,@CountAVA_SYN INT
			
				SET @CountACQ = ABS(DATEDIFF(DAY,DATEADD(DAY,-1,@RSD),@RED)) 
				SELECT @CountAVA_SYN=SUM(totalDays) FROM (
				SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVAD.Rights_Start_Date),AVAD.Rights_End_Date)) totalDays,AVAD.Rights_Start_Date,AVAD.Rights_End_Date
				FROM Avail_Acq_Details AVAD (NOLOCK)
				INNER JOIN Avail_Acq AVA (NOLOCK) ON AVAD.Avail_Acq_Code=AVA.Avail_Acq_Code
				WHERE 
				AVA.Avail_Acq_Code=@Avail_Acq_Code
				--Title_Code=@Title_code
				--AND Country_Code=@Country_Code
				--AND Platform_Code=@Platform_Code
				AND Acq_Deal_Code=@pDeal_Code
			
				UNION ALL
			
				SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVSD.Rights_Start_Date),AVSD.Rights_End_Date)) totalDays,AVSD.Rights_Start_Date,AVSD.Rights_End_Date
				FROM Avail_Syn_Details AVSD (NOLOCK)
				INNER JOIN Avail_Syn AVS (NOLOCK) ON AVSD.Avail_Syn_Code=AVS.Avail_Syn_Code
				WHERE 
				Title_Code=@Title_code
				AND Country_Code=@Country_Code
				AND Platform_Code=@Platform_Code
				AND (AVSD.Rights_Start_Date BETWEEN @RSD AND @RED
				OR AVSD.Rights_End_Date BETWEEN @RSD AND @RED)		
			
				) AS A
			
				--IF(@isNewRecord=0)--If not new Record
				--	IF(@CountACQ = @CountAVA_SYN) GOTO FETCH_NEXT_RECORD_Dubb;

				--ELSE
				--BEGIN
				--	SELECT @RSD ASD,@RED AED,@CountACQ DIFF_ACQ
				--	SELECT @CountAVA_SYN DIFF_AVA_SYN
			
				--	SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVAD.Rights_Start_Date),AVAD.Rights_End_Date))	totalDays,AVAD.Rights_Start_Date,AVAD.Rights_End_Date
				--	FROM Avail_Acq_Details AVAD
				--	INNER JOIN Avail_Acq AVA ON AVAD.Avail_Acq_Code=AVA.Avail_Acq_Code
				--	WHERE Title_Code=@Title_code
				--	AND Country_Code=@Country_Code
				--	AND Platform_Code=@Platform_Code
				--	AND Acq_Deal_Code=@pDeal_Code
				
				--	SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVSD.Rights_Start_Date),AVSD.Rights_End_Date))	totalDays,AVSD.Rights_Start_Date,AVSD.Rights_End_Date
				--	FROM Avail_Syn_Details AVSD
				--	INNER JOIN Avail_Syn AVS ON AVSD.Avail_Syn_Code=AVS.Avail_Syn_Code
				--	WHERE Title_Code=@Title_code
				--	AND Country_Code=@Country_Code
				--	AND Platform_Code=@Platform_Code
				--	AND (AVSD.Rights_Start_Date BETWEEN @RSD AND @RED
				--	OR AVSD.Rights_End_Date BETWEEN @RSD AND @RED)
				--END			
			
				--Delete from Avail_Acq_Details tables where Rights Start Date > MIN_RIGHTS_END_DATE 
				delete from Avail_Acq_Details where Avail_Acq_Code=@Avail_Acq_Code AND Acq_Deal_Code=@pDeal_Code
				and Rights_End_Date<=@RSD

				--Delete from Avail_Acq_Details tables where Rights END Date < MAX_RIGHTS_START_DATE 
				delete from Avail_Acq_Details where Avail_Acq_Code=@Avail_Acq_Code AND Acq_Deal_Code=@pDeal_Code
				and Rights_Start_Date>=@RED
			
				DECLARE @MinAvail_RSD DATE,@MaxAvail_RED DATE 
			
				SELECT  @MinAvail_RSD=MIN(AVAD.Rights_Start_Date), @MaxAvail_RED=MAX(AVAD.Rights_End_Date)
				FROM Avail_Acq_Details AVAD (NOLOCK)
				INNER JOIN Avail_Acq AVA (NOLOCK) ON AVAD.Avail_Acq_Code=AVA.Avail_Acq_Code
				WHERE  
				AVAD.Avail_Acq_Code=@Avail_Acq_Code 
				-- (Title_Code=@Title_code
				--AND Country_Code=@Country_Code
				--AND Platform_Code=@Platform_Code
				AND Acq_Deal_Code=@pDeal_Code
			
				PRINT CAST(@MinAvail_RSD AS VARCHAR)
				PRINT CAST(@MaxAvail_RED AS VARCHAR)
			
				IF(@RSD <> @MinAvail_RSD) 
				BEGIN
					IF(@RSD >= @MinAvail_RSD) 
					BEGIN
						PRINT 'UPDATE Current Min AVAIL DATE WITH NEW ACQ START DATE'
			
						UPDATE AVAD SET AVAD.Rights_Start_Date = @RSD
						FROM Avail_Acq_Details AVAD
						INNER JOIN Avail_Acq AVA ON AVA.Avail_Acq_Code=AVAD.Avail_Acq_Code
						WHERE 
						--Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						--AND Title_Code=@Title_code
						AVA.Avail_Acq_Code=@Avail_Acq_Code
						AND Acq_Deal_Code=@pDeal_Code
						AND Rights_Start_Date=@MinAvail_RSD
					END
					ELSE
					BEGIN
						PRINT 'INSERT RECORDS WITH END DATE = Current Min AVAIL DATE - 1'					
						PRINT CAST(@Avail_Acq_Code AS VARCHAR)
						--SELECT @Avail_Acq_Code=Avail_Acq_Code 
						--FROM Avail_Acq 
						--WHERE Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						--AND Title_Code=@Title_code
						--AND Acq_Deal_Code=@pDeal_Code
					
						INSERT INTO Avail_Acq_Details (Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
						SELECT @Avail_Acq_Code,@RSD,DATEADD(DAY,-1,@MinAvail_RSD),@pDeal_Code
					
					END
				END
			
				IF(@RED <> @MaxAvail_RED) 
				BEGIN
					IF(@RED <= @MaxAvail_RED)
					BEGIN
						PRINT 'UPDATE Current Max AVAIL DATE WITH NEW ACQ END DATE'
					
						UPDATE AVAD SET AVAD.Rights_End_Date = @RED
						FROM Avail_Acq_Details AVAD
						INNER JOIN Avail_Acq AVA ON AVA.Avail_Acq_Code=AVAD.Avail_Acq_Code
						WHERE 
						--Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						--AND Title_Code=@Title_code
						AVA.Avail_Acq_Code=@Avail_Acq_Code
						AND Acq_Deal_Code=@pDeal_Code
						AND Rights_End_Date=@MaxAvail_RED
					END				
					ELSE
					BEGIN
						PRINT 'INSERT RECORDS WITH START DATE = Current Max AVAIL DATE + 1'
						INSERT INTO Avail_Acq_Details (Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
						SELECT @Avail_Acq_Code,DATEADD(DAY,1,@MaxAvail_RED),@RED,@pDeal_Code
					END
				END
			
			
				/* Ava AcQ Language */			
				/* Dubbing */
				FETCH_NEXT_RECORD_Dubb:
				IF EXISTS (SELECT TOP 1 Language_Code FROM Acq_Deal_Rights_Dubbing (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
				BEGIN

					
						DECLARE @CountACQ_Dubb INT,@CountAVA_SYN_Dubb INT
			
						SET @CountACQ_Dubb = ABS(DATEDIFF(DAY,DATEADD(DAY,-1,@RSD),@RED)) 
					
						SELECT @CountAVA_SYN_Dubb=SUM(totalDays) FROM (
						SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVAL.Rights_Start_Date),AVAL.Rights_End_Date)) totalDays,AVAL.Rights_Start_Date,AVAL.Rights_End_Date
						FROM Avail_Acq_Language AVAL (NOLOCK)
						INNER JOIN Avail_Acq AVA (NOLOCK) ON AVAL.Avail_Acq_Code=AVA.Avail_Acq_Code
						WHERE 
						AVA.Avail_Acq_Code=@Avail_Acq_Code
						AND Dubbing_Subtitling='D'
						--AND Title_Code=@Title_code 
						--AND Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						AND Acq_Deal_Code=@pDeal_Code
					
						UNION ALL
					
						SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVSD.Rights_Start_Date),AVSD.Rights_End_Date)) totalDays,AVSD.Rights_Start_Date,AVSD.Rights_End_Date
						FROM Avail_Syn_Language AVSD (NOLOCK)
						INNER JOIN Avail_Syn AVS (NOLOCK) ON AVSD.Avail_Syn_Code=AVS.Avail_Syn_Code
						WHERE Title_Code=@Title_code AND Dubbing_Subtitling='D'
						AND Country_Code=@Country_Code
						AND Platform_Code=@Platform_Code
						AND (AVSD.Rights_Start_Date BETWEEN @RSD AND @RED
						OR AVSD.Rights_End_Date BETWEEN @RSD AND @RED)		
						) AS A
					
					
						--if(@isNewRecord=0)
						--	IF(@CountACQ_Dubb = @CountAVA_SYN_Dubb) GOTO FETCH_NEXT_RECORD_Sub;
					
						--Delete from Avail_Acq_Language tables where Rights Start Date > MIN_RIGHTS_END_DATE 
						delete from Avail_Acq_Language where Avail_Acq_Code=@Avail_Acq_Code AND Acq_Deal_Code=@pDeal_Code
						and Rights_End_Date<=@RSD  AND Dubbing_Subtitling='D'

						--Delete from Avail_Acq_Language tables where Rights END Date < MAX_RIGHTS_START_DATE 
						delete from Avail_Acq_Language where Avail_Acq_Code=@Avail_Acq_Code AND Acq_Deal_Code=@pDeal_Code
						and Rights_Start_Date>=@RED AND Dubbing_Subtitling='D'

						SELECT @MinAvail_RSD = null,@MaxAvail_RED = null
					
						SELECT  @MinAvail_RSD=MIN(AVAL.Rights_Start_Date), @MaxAvail_RED=MAX(AVAL.Rights_End_Date)
						--,DISTINCT @Avail_Acq_Code=AVA.Avail_Acq_Code
						FROM Avail_Acq_Language AVAL (NOLOCK)
						INNER JOIN Avail_Acq AVA (NOLOCK) ON AVAL.Avail_Acq_Code=AVA.Avail_Acq_Code
						WHERE Dubbing_Subtitling='D'
						AND AVA.Avail_Acq_Code=@Avail_Acq_Code
						--Title_Code=@Title_code AND 
						--AND Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						AND Acq_Deal_Code=@pDeal_Code
					
						PRINT CAST(@MinAvail_RSD AS VARCHAR)
						PRINT   CAST(@MaxAvail_RED AS VARCHAR)

					
						IF(@RSD <> @MinAvail_RSD) 
						BEGIN			
									
							IF(@RSD >= @MinAvail_RSD) 
							BEGIN
								PRINT 'Dubbing UPDATE Current Min AVAIL DATE WITH NEW ACQ START DATE'
							
								UPDATE AVAL SET AVAL.Rights_Start_Date = @RSD
								FROM Avail_Acq_Language AVAL
								INNER JOIN Avail_Acq AVA ON AVA.Avail_Acq_Code=AVAL.Avail_Acq_Code
								WHERE 
								AVA.Avail_Acq_Code=@Avail_Acq_Code
								AND Dubbing_Subtitling='D'
								--Country_Code=@Country_Code  
								--AND Platform_Code=@Platform_Code
								--AND Title_Code=@Title_code
								AND Acq_Deal_Code=@pDeal_Code
								AND Rights_Start_Date=@MinAvail_RSD
							END
							ELSE
							BEGIN
								PRINT 'Dubbing INSERT RECORDS WITH END DATE = Current Min AVAIL DATE - 1'					
							
								--SELECT @Avail_Acq_Code=Avail_Acq_Code 
								--FROM Avail_Acq 
								--WHERE 
								-- Avail_Acq_Code=@Avail_Acq_Code
								--Country_Code=@Country_Code
								--AND Platform_Code=@Platform_Code
								--AND Title_Code=@Title_code
								--AND Acq_Deal_Code=@pDeal_Code
							
								--select * from Avail_Acq_Language
								INSERT INTO Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
								--SELECT @Avail_Acq_Code,@RSD,DATEADD(DAY,-1,@MinAvail_RSD),'D',@pDeal_Code
								SELECT @Avail_Acq_Code,'D',ADRD.Language_Code,@RSD,DATEADD(DAY,-1,@MinAvail_RSD),ADR.Acq_Deal_Code
								FROM Acq_Deal_Rights_Dubbing ADRD (NOLOCK)
									inner join Acq_Deal_Rights adr (NOLOCK) on adr.Acq_Deal_Rights_Code=ADRD.Acq_Deal_Rights_Code
								where adr.Acq_Deal_Code=@pDeal_Code 
								and adrd.Language_Code in 
								(select Language_code from Avail_Acq_Language (NOLOCK) where Dubbing_Subtitling='D' and Acq_Deal_Code=@pDeal_Code and Avail_Acq_Code=@Avail_Acq_Code)

							
							END
						
						END
					
						IF(@RED <> @MaxAvail_RED) 
						BEGIN
						
							IF(@RED <= @MaxAvail_RED)
							BEGIN
								PRINT 'Dubbing UPDATE Current Max AVAIL DATE WITH NEW ACQ END DATE'
							
								UPDATE AVAL SET AVAL.Rights_End_Date = @RED
								FROM Avail_Acq_Language AVAL
								INNER JOIN Avail_Acq AVA ON AVA.Avail_Acq_Code=AVAL.Avail_Acq_Code
								WHERE Dubbing_Subtitling='D'
								AND AVAL.Avail_Acq_Code=@Avail_Acq_Code
								--Country_Code=@Country_Code  AND Dubbing_Subtitling='D'
								--AND Platform_Code=@Platform_Code
								--AND Title_Code=@Title_code
								AND Acq_Deal_Code=@pDeal_Code
								AND Rights_End_Date=@MaxAvail_RED
							END				
							ELSE
							BEGIN
								PRINT 'Dubbing INSERT RECORDS WITH START DATE = Current Max AVAIL DATE + 1'
								INSERT INTO Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
								--SELECT @Avail_Acq_Code,DATEADD(DAY,1,@MaxAvail_RED),@RED,'D',@pDeal_Code
								SELECT @Avail_Acq_Code,'D',ADRD.Language_Code,DATEADD(DAY,1,@MaxAvail_RED),@RED,ADR.Acq_Deal_Code
								FROM Acq_Deal_Rights_Dubbing ADRD (NOLOCK)
									inner join Acq_Deal_Rights adr (NOLOCK) on adr.Acq_Deal_Rights_Code=ADRD.Acq_Deal_Rights_Code
								where adr.Acq_Deal_Code=@pDeal_Code 
								and adrd.Language_Code in 
								(select Language_code from Avail_Acq_Language (NOLOCK) where Dubbing_Subtitling='D' and Acq_Deal_Code=@pDeal_Code and Avail_Acq_Code=@Avail_Acq_Code)
							END
						END

									
						--Insert into Avail_Acq_Language for Dubbing any new languages added
						Insert into Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)				
						SELECT distinct aad.Avail_Acq_Code,'D',ADRD.Language_Code,@RSD,@RED,aad.Acq_Deal_Code
						FROM Acq_Deal_Rights_Dubbing ADRD (NOLOCK)
							inner join Acq_Deal_Rights adr (NOLOCK) on adr.Acq_Deal_Rights_Code=ADRD.Acq_Deal_Rights_Code
							inner join Avail_Acq_Details aad (NOLOCK) on aad.Acq_Deal_Code =adr.Acq_Deal_Code 
							left join Avail_Acq_Language AAL (NOLOCK) ON AAL.Avail_Acq_Code=AAD.Avail_Acq_Code AND AAL.Acq_Deal_Code=ADR.Acq_Deal_Code
							AND AAL.Dubbing_Subtitling='D'  AND ADRD.Language_Code=AAL.Language_Code
						where adr.Acq_Deal_Code=@pDeal_Code AND AAD.Avail_Acq_Code=@Avail_Acq_Code AND isnull(AAL.Avail_Acq_Language,0)=0

				END
				
				/* Subtitling */
				FETCH_NEXT_RECORD_Sub:
				IF EXISTS (SELECT TOP 1 Language_Code FROM Acq_Deal_Rights_Subtitling (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
				BEGIN
						DECLARE @CountACQ_Sub INT,@CountAVA_SYN_Sub INT
			
						SET @CountACQ_Sub = ABS(DATEDIFF(DAY,DATEADD(DAY,-1,@RSD),@RED)) 
					
						SELECT @CountAVA_SYN_Sub=SUM(totalDays) FROM (
						SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVAL.Rights_Start_Date),AVAL.Rights_End_Date)) totalDays,AVAL.Rights_Start_Date,AVAL.Rights_End_Date
						FROM Avail_Acq_Language AVAL (NOLOCK)
						INNER JOIN Avail_Acq AVA (NOLOCK) ON AVAL.Avail_Acq_Code=AVA.Avail_Acq_Code
						WHERE 
						AVAL.Avail_Acq_Code=@Avail_Acq_Code AND Dubbing_Subtitling='S'
						--Title_Code=@Title_code 
						--AND Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						AND Acq_Deal_Code=@pDeal_Code
					
						UNION ALL
					
						SELECT  ABS(DATEDIFF(DAY,DATEADD(DAY,-1,AVSD.Rights_Start_Date),AVSD.Rights_End_Date)) totalDays,AVSD.Rights_Start_Date,AVSD.Rights_End_Date
						FROM Avail_Syn_Language AVSD (NOLOCK)
						INNER JOIN Avail_Syn AVS (NOLOCK) ON AVSD.Avail_Syn_Code=AVS.Avail_Syn_Code
						WHERE 
						Title_Code=@Title_code AND Dubbing_Subtitling='S'
						AND Country_Code=@Country_Code
						AND Platform_Code=@Platform_Code
						AND (AVSD.Rights_Start_Date BETWEEN @RSD AND @RED
						OR AVSD.Rights_End_Date BETWEEN @RSD AND @RED)		
					
						) AS A

				
						if(@isNewRecord=0)
						IF(@CountACQ_Sub = @CountAVA_SYN_Sub) GOTO FETCH_NEXT_RECORD;
					
						--Delete from Avail_Acq_Language tables where Rights Start Date > MIN_RIGHTS_END_DATE 
						delete from Avail_Acq_Language where Avail_Acq_Code=@Avail_Acq_Code AND Acq_Deal_Code=@pDeal_Code
						and Rights_End_Date<=@RSD  AND Dubbing_Subtitling='S'

						--Delete from Avail_Acq_Language tables where Rights END Date < MAX_RIGHTS_START_DATE 
						delete from Avail_Acq_Language where Avail_Acq_Code=@Avail_Acq_Code AND Acq_Deal_Code=@pDeal_Code
						and Rights_Start_Date>=@RED  AND Dubbing_Subtitling='S'
					
						SELECT @MinAvail_RSD = null,@MaxAvail_RED = null
					
						SELECT  @MinAvail_RSD=MIN(AVAL.Rights_Start_Date), @MaxAvail_RED=MAX(AVAL.Rights_End_Date)
						--,DISTINCT @Avail_Acq_Code=AVA.Avail_Acq_Code
						FROM Avail_Acq_Language AVAL (NOLOCK)
						INNER JOIN Avail_Acq AVA (NOLOCK) ON AVAL.Avail_Acq_Code=AVA.Avail_Acq_Code
						WHERE 
						AVAL.Avail_Acq_Code=@Avail_Acq_Code AND Dubbing_Subtitling='S'
						--Title_Code=@Title_code 
						--AND Country_Code=@Country_Code
						--AND Platform_Code=@Platform_Code
						AND Acq_Deal_Code=@pDeal_Code
					
						PRINT CAST(@MinAvail_RSD AS VARCHAR)
						PRINT CAST(@MaxAvail_RED AS VARCHAR)
					
						IF(@RSD <> @MinAvail_RSD) 
						BEGIN			
									
							IF(@RSD >= @MinAvail_RSD) 
							BEGIN
								PRINT 'Subtitling UPDATE Current Min AVAIL DATE WITH NEW ACQ START DATE'
							
								UPDATE AVAL SET AVAL.Rights_Start_Date = @RSD
								FROM Avail_Acq_Language AVAL
								INNER JOIN Avail_Acq AVA ON AVA.Avail_Acq_Code=AVAL.Avail_Acq_Code
								WHERE 
								AVAL.Avail_Acq_Code=@Avail_Acq_Code AND Dubbing_Subtitling='S'
								--Country_Code=@Country_Code  
								--AND Platform_Code=@Platform_Code
								--AND Title_Code=@Title_code
								AND Acq_Deal_Code=@pDeal_Code
								AND Rights_Start_Date=@MinAvail_RSD
							END
							ELSE
							BEGIN
								PRINT 'Subtitling INSERT RECORDS WITH END DATE = Current Min AVAIL DATE - 1'					
							
								--SELECT @Avail_Acq_Code=Avail_Acq_Code 
								--FROM Avail_Acq 
								--WHERE 
								--Avail_Acq_Code=@Avail_Acq_Code
								--Country_Code=@Country_Code
								--AND Platform_Code=@Platform_Code
								--AND Title_Code=@Title_code
								--AND Acq_Deal_Code=@pDeal_Code
							
								INSERT INTO Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code, Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
								--SELECT @Avail_Acq_Code,@RSD,DATEADD(DAY,-1,@MinAvail_RSD),'S',@pDeal_Code
								SELECT @Avail_Acq_Code,'S',ADRD.Language_Code,@RSD,DATEADD(DAY,-1,@MinAvail_RSD),ADR.Acq_Deal_Code
								FROM Acq_Deal_Rights_Subtitling ADRD (NOLOCK)
									inner join Acq_Deal_Rights adr (NOLOCK) on adr.Acq_Deal_Rights_Code=ADRD.Acq_Deal_Rights_Code
								where adr.Acq_Deal_Code=@pDeal_Code 
								and  adrd.Language_code in (select Language_code from Avail_Acq_Language (NOLOCK) where Dubbing_Subtitling='S' and Acq_Deal_Code=@pDeal_Code and Avail_Acq_Code=@Avail_Acq_Code)
							END
						
						END
					
						IF(@RED <> @MaxAvail_RED) 
						BEGIN
						
							IF(@RED <= @MaxAvail_RED)
							BEGIN
								PRINT 'Subtitling UPDATE Current Max AVAIL DATE WITH NEW ACQ END DATE'
							
								UPDATE AVAL SET AVAL.Rights_End_Date = @RED
								FROM Avail_Acq_Language AVAL 
								INNER JOIN Avail_Acq AVA ON AVA.Avail_Acq_Code=AVAL.Avail_Acq_Code
								WHERE 
								AVAL.Avail_Acq_Code=@Avail_Acq_Code AND Dubbing_Subtitling='S'
								--Country_Code=@Country_Code  
								--AND Platform_Code=@Platform_Code
								--AND Title_Code=@Title_code
								AND Acq_Deal_Code=@pDeal_Code
								AND Rights_End_Date=@MaxAvail_RED
							END				
							ELSE
							BEGIN
								PRINT 'Subtitling INSERT RECORDS WITH START DATE = Current Max AVAIL DATE + 1'
								INSERT INTO Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
								--SELECT @Avail_Acq_Code,DATEADD(DAY,1,@MaxAvail_RED),@RED,'S',@pDeal_Code
								SELECT @Avail_Acq_Code,'S',ADRD.Language_Code,DATEADD(DAY,1,@MaxAvail_RED),@RED,ADR.Acq_Deal_Code
								FROM Acq_Deal_Rights_Subtitling ADRD (NOLOCK)
									inner join Acq_Deal_Rights adr (NOLOCK) on adr.Acq_Deal_Rights_Code=ADRD.Acq_Deal_Rights_Code
								where adr.Acq_Deal_Code=@pDeal_Code 
								and  adrd.Language_code in (select Language_code from Avail_Acq_Language (NOLOCK) where Dubbing_Subtitling='S' and Acq_Deal_Code=@pDeal_Code and Avail_Acq_Code=@Avail_Acq_Code)
							END
						END

									
						--Insert into Avail_Acq_Language for Subtitling 
						Insert into Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)				
						SELECT distinct aad.Avail_Acq_Code,'S',ADRS.Language_Code,@RSD,@RED,aad.Acq_Deal_Code
						FROM Acq_Deal_Rights_Subtitling ADRS (NOLOCK)
							inner join Acq_Deal_Rights adr (NOLOCK) on adr.Acq_Deal_Rights_Code=ADRS.Acq_Deal_Rights_Code
							inner join Avail_Acq_Details aad (NOLOCK) on aad.Acq_Deal_Code =adr.Acq_Deal_Code 
							left join Avail_Acq_Language AAL (NOLOCK) ON AAL.Avail_Acq_Code=AAD.Avail_Acq_Code AND AAL.Acq_Deal_Code=ADR.Acq_Deal_Code
							AND AAL.Dubbing_Subtitling='S'  AND ADRS.Language_Code=AAL.Language_Code
						where adr.Acq_Deal_Code=@pDeal_Code AND AAD.Avail_Acq_Code=@Avail_Acq_Code AND isnull(AAL.Avail_Acq_Language,0)=0

				END
			
			END		
			FETCH_NEXT_RECORD:	
			FETCH NEXT FROM curDMR INTO @Acq_Deal_Rights_Code,@Title_code,@Platform_Code,@Country_Code,@RSD,@RED,@Sub_License_Code ,@Avail_Acq_Code 
		END

		CLOSE curDMR
		DEALLOCATE curDMR

	
		END
		IF OBJECT_ID('tempdb..#tmpAVA') IS NOT NULL DROP TABLE #tmpAVA

	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Avail_Acq_Amend]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END