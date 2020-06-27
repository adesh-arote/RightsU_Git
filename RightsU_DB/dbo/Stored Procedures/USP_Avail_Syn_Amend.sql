CREATE PROCEDURE [dbo].[USP_Avail_Syn_Amend]
	@Syn_Deal_Code INT = 0
AS
--=============================================
-- Author:		Pavitar Dua
-- Create DATE: 15-April-2014
-- Description:	Calculate Availability After Syndication changes
-- =============================================
BEGIN	

	declare @isSAMEACQ int=0
	declare @isSAMEDub varchar(2)=''
	declare @isSAMELan int=0
-- =============================================
-- Declare and using a KEYSET cursor
-- =============================================
DECLARE CUR_AMEND_SYN CURSOR
KEYSET
FOR 
	Select 
	 ADR.Acq_Deal_Code,CONVERT(DATE,ADR.right_start_Date,103) ACQ_RSD,CONVERT(DATE,ADR.right_end_Date,103) ACQ_RED  
	,TMP_ASYN.SYN_RSD ,TMP_ASYN.SYN_RED--,TMP_ASYN.Language_Code,TMP_ASYN.Dubbing_Subtitling
	,ADRT.Title_Code,ADRP.Platform_Code,ADRTerr.Country_Code,TMP_ASYN.Language_Code,TMP_ASYN.Dubbing_Subtitling
	from 
	Acq_Deal_Rights ADR
	INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Territory ADRTerr ON ADRTerr.Acq_Deal_Rights_code = ADR.Acq_Deal_Rights_code
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
	--LEFT JOIN Acq_Deal_Rights_Dubbing ADRD ON ADRD.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code 
	--LEFT JOIN Acq_Deal_Rights_Subtitling ADRS ON ADRS.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
	INNER JOIN
	(
		SELECT distinct AVS.Title_Code,AVS.Platform_Code,AVS.Country_Code,AVSD.Rights_Start_Date SYN_RSD
			  ,AVSD.Rights_End_Date SYN_RED,AVAL.Language_Code,AVAL.Dubbing_Subtitling
		FROM Avail_Syn  AVS
		INNER JOIN Avail_Syn_Details AVSD ON AVS.Avail_Syn_Code=AVSD.Avail_Syn_Code
		INNER JOIN Avail_Syn_Language AVAL ON AVS.Avail_Syn_Code=AVAL.Avail_Syn_Code 
		INNER JOIN 
		(	SELECT distinct Title_Code,Platform_Code,Country_Code FROM Avail_Syn  AVS
			INNER JOIN Avail_Syn_Details AVSD ON AVS.Avail_Syn_Code=AVSD.Avail_Syn_Code
			WHERE AVSD.Syn_Deal_Code = @Syn_Deal_Code
		) tmpAS on tmpAS.Country_Code=AVS.Country_Code and tmpAS.Platform_Code=AVS.Platform_Code and tmpAS.Title_Code=AVS.Title_Code
	) AS TMP_ASYN ON ADRT.Title_Code=TMP_ASYN.Title_Code 
	AND ADRP.Platform_Code=TMP_ASYN.Platform_Code 					
	AND ADRTerr.Country_Code=TMP_ASYN.Country_Code					
	--AND (ADRS.Language_Code=TMP_ASYN.Language_Code) AND (Dubbing_Subtitling=TMP_ASYN.Dubbing_Subtitling)
	AND (TMP_ASYN.SYN_RSD between CONVERT(DATE,ADR.Right_Start_Date,103) AND CONVERT(DATE,ADR.Right_End_Date,103))
	AND (TMP_ASYN.SYN_RED between CONVERT(DATE,ADR.Right_Start_Date,103) AND CONVERT(DATE,ADR.Right_End_Date,103))
		

DECLARE @Acq_Deal_Code int,@ACQ_RSD date ,@ACQ_RED date ,@SYN_RSD date,@SYN_RED date,@Title_Code int,@Platform_Code int,@Country_Code int,
		@Language_Code int,@Dubbing_Subtitling VARCHAR(2)

OPEN CUR_AMEND_SYN

FETCH NEXT FROM CUR_AMEND_SYN INTO @Acq_Deal_Code ,@ACQ_RSD,@ACQ_RED,@SYN_RSD ,@SYN_RED,@Title_Code,@Platform_Code,@Country_Code,@Language_Code ,@Dubbing_Subtitling
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
			
		DECLARE @Avail_Acq_Code numeric(38,0)
		declare @Avail_Acq_Language_Code  int--,@MIN_AVAIL_RSD date,@MAX_AVAIL_RED date
					
		SELECT @Avail_Acq_Code=AVA.Avail_Acq_Code											
		FROM Avail_Acq AVA
		LEFT JOIN Avail_Acq_Details AVAD ON AVA.Avail_Acq_Code=AVAD.Avail_Acq_Code
		LEFT JOIN Avail_Acq_Language AVAL ON AVA.Avail_Acq_Code=AVAL.Avail_Acq_Code
		WHERE Title_Code=@Title_Code 
		AND Platform_Code=@Platform_Code 					
		AND Country_Code=@Country_Code					
		--AND (Language_Code=@Language_Code OR 1=1) AND (Dubbing_Subtitling=@Dubbing_Subtitling OR 1=1)
		
		print '@isSAMEACQ' + convert(varchar(100),@isSAMEACQ)

		if(@isSAMEACQ<>@Avail_Acq_Code)
		BEGIN

			set @isSAMEACQ=@Avail_Acq_Code
			------------FOR FIRST SYNDICATION : DELETE AND INSERT--------------------
			IF(@SYN_RSD = @ACQ_RSD and @ACQ_RED=@SYN_RED)                               
			BEGIN                              
			PRINT '@SYN_RSD = @ACQ_RSD and @ACQ_RED=@SYN_RED'
			END
			ELSE 
			BEGIN
				DELETE AVAD FROM Avail_Acq_Details  AVAD WHERE Avail_Acq_Code=@Avail_Acq_Code
				AND (@SYN_RSD between CONVERT(DATE,Rights_Start_Date,103) AND CONVERT(DATE,Rights_End_Date,103))
				AND (@SYN_RED between CONVERT(DATE,Rights_Start_Date,103) AND CONVERT(DATE,Rights_End_Date,103))
		
				DELETE AVAL							
				FROM Avail_Acq_Language  AVAL		
				INNER JOIN Avail_Acq AVA ON AVAL.Avail_Acq_Code=AVA.Avail_Acq_Code
				WHERE AVA.Avail_Acq_Code=@Avail_Acq_Code
				AND Title_Code=@Title_Code 
				AND Platform_Code=@Platform_Code 
				AND Country_Code=@Country_Code
				AND Language_Code=@Language_Code
				AND Dubbing_Subtitling=@Dubbing_Subtitling
				AND (@SYN_RSD between CONVERT(DATE,Rights_Start_Date,103) AND CONVERT(DATE,Rights_End_Date,103))
				AND (@SYN_RED between CONVERT(DATE,Rights_Start_Date,103) AND CONVERT(DATE,Rights_End_Date,103))
			END
		END
		ELSE
		BEGIN
			
			----FOR MORE THAN ONE SYNDICATION FOR SAME TITLE-PLATOFRM-COUNTRY--------
			declare @Avail_Acq_Details_Code  int--@MIN_AVAIL_RSD date,@MAX_AVAIL_RED date,
			select @ACQ_RSD =MIN(AAD.Rights_Start_Date),@ACQ_RED=MAX(AAD.Rights_End_Date) 
			from Avail_Acq_Details AAD where Avail_Acq_Code=@Avail_Acq_Code 
			AND (@SYN_RSD between CONVERT(DATE,AAD.Rights_Start_Date,103) AND CONVERT(DATE,AAD.Rights_End_Date,103))
			AND (@SYN_RED between CONVERT(DATE,AAD.Rights_Start_Date,103) AND CONVERT(DATE,AAD.Rights_End_Date,103))
			
			delete AAD from Avail_Acq_Details AAD
			where Avail_Acq_Code=@Avail_Acq_Code 
			AND (@SYN_RSD between CONVERT(DATE,AAD.Rights_Start_Date,103) AND CONVERT(DATE,AAD.Rights_End_Date,103))
			AND (@SYN_RED between CONVERT(DATE,AAD.Rights_Start_Date,103) AND CONVERT(DATE,AAD.Rights_End_Date,103))
						
			select @ACQ_RSD =MIN(AAL.Rights_Start_Date),@ACQ_RED=MAX(AAL.Rights_End_Date) 
			from Avail_Acq_Language AAL where Avail_Acq_Code=@Avail_Acq_Code 
			AND (@SYN_RSD between CONVERT(DATE,AAL.Rights_Start_Date,103) AND CONVERT(DATE,AAL.Rights_End_Date,103))
			AND (@SYN_RED between CONVERT(DATE,AAL.Rights_Start_Date,103) AND CONVERT(DATE,AAL.Rights_End_Date,103))
			AND AAL.Language_Code=@Language_Code AND AAL.Dubbing_Subtitling=@Dubbing_Subtitling
			
			delete AAL from Avail_Acq_Language AAL
			where Avail_Acq_Code=@Avail_Acq_Code 
			AND (@SYN_RSD between CONVERT(DATE,AAL.Rights_Start_Date,103) AND CONVERT(DATE,AAL.Rights_End_Date,103))
			AND (@SYN_RED between CONVERT(DATE,AAL.Rights_Start_Date,103) AND CONVERT(DATE,AAL.Rights_End_Date,103))
			AND AAL.Language_Code=@Language_Code AND AAL.Dubbing_Subtitling=@Dubbing_Subtitling

		END	

		IF(@SYN_RSD = @ACQ_RSD and @SYN_RED < @ACQ_RED)                               
		BEGIN           
		Print '@SYN_RSD = @ACQ_RSD and @SYN_RED < @ACQ_RED'
			
			if((select count(*) from Avail_Acq_Details where Avail_Acq_Code=@Avail_Acq_Code 
			and Rights_Start_Date=dateadd(d,1,@SYN_RED) and Rights_End_Date=@ACQ_RED and Acq_Deal_Code=@Acq_Deal_Code)=0)
				INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
				SELECT  @Avail_Acq_Code ,dateadd(d,1,@SYN_RED), @ACQ_RED ,@Acq_Deal_Code
						
			INSERT INTO Avail_Acq_Language
			(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
			SELECT  @Avail_Acq_Code ,dateadd(d,1,@SYN_RED), @ACQ_RED, @Language_Code, @Dubbing_Subtitling ,@Acq_Deal_Code
			
		END                              
					                                
		IF(@SYN_RSD > @ACQ_RSD and @SYN_RED = @ACQ_RED)                               
		BEGIN
			Print '@SYN_RSD > @ACQ_RSD and @SYN_RED = @ACQ_RED'

			if((select count(*) from Avail_Acq_Details where Avail_Acq_Code=@Avail_Acq_Code 
				and Rights_Start_Date= DATEADD(d,0,@ACQ_RSD) and Rights_End_Date=dateadd(d,-1,@SYN_RSD) and Acq_Deal_Code=@Acq_Deal_Code)=0)
				INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
				SELECT @Avail_Acq_Code , DATEADD(d,0,@ACQ_RSD), dateadd(d,-1,@SYN_RSD),@Acq_Deal_Code
			
			INSERT INTO Avail_Acq_Language
			(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
			SELECT @Avail_Acq_Code , DATEADD(d,0,@ACQ_RSD), dateadd(d,-1,@SYN_RSD), @Language_Code, @Dubbing_Subtitling,@Acq_Deal_Code
			
		END                              
					                                
		IF(@SYN_RSD > @ACQ_RSD and @SYN_RED < @ACQ_RED)                               
		BEGIN                              
			Print '@SYN_RSD > @ACQ_RSD and @SYN_RED < @ACQ_RED'          
			SELECT @Avail_Acq_Code
					   
			if((select count(*) from Avail_Acq_Details where Avail_Acq_Code=@Avail_Acq_Code 
				and Rights_Start_Date=@ACQ_RSD and Rights_End_Date=dateadd(d,-1,@SYN_RSD) and Acq_Deal_Code=@Acq_Deal_Code)=0)
				INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
				SELECT  @Avail_Acq_Code, @ACQ_RSD , dateadd(d,-1,@SYN_RSD),@Acq_Deal_Code
			
			if((select count(*) from Avail_Acq_Details where Avail_Acq_Code=@Avail_Acq_Code 
				and Rights_Start_Date= DATEADD(d ,1,@SYN_RED) and Rights_End_Date=@ACQ_RED and Acq_Deal_Code=@Acq_Deal_Code)=0)		                                 
				INSERT INTO Avail_Acq_Details(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
				SELECT @Avail_Acq_Code, DATEADD(d ,1,@SYN_RED),@ACQ_RED,@Acq_Deal_Code					                             

			INSERT INTO Avail_Acq_Language
			(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
			SELECT  @Avail_Acq_Code, @ACQ_RSD , dateadd(d,-1,@SYN_RSD), @Language_Code, @Dubbing_Subtitling,@Acq_Deal_Code
							
			INSERT INTO Avail_Acq_Language
			(Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Language_Code,Dubbing_Subtitling,Acq_Deal_Code)
			SELECT @Avail_Acq_Code, DATEADD(d ,1,@SYN_RED),@ACQ_RED, @Language_Code, @Dubbing_Subtitling,@Acq_Deal_Code					                             		
			
		END  	

	END
	FETCH NEXT FROM CUR_AMEND_SYN INTO @Acq_Deal_Code ,@ACQ_RSD,@ACQ_RED,@SYN_RSD ,@SYN_RED,@Title_Code,@Platform_Code,@Country_Code,@Language_Code ,@Dubbing_Subtitling
END

CLOSE CUR_AMEND_SYN
DEALLOCATE CUR_AMEND_SYN
END