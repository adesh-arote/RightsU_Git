CREATE FUNCTION [dbo].[UFN_Get_DataFor_RightsUsageReport_New]
(
	@Acq_Deal_Movie_Code INT,
	@Type VARCHAR(50),
	 @StartDate VARCHAR(30),
	 @EndDate VARCHAR(30),
	 @Channel VARCHAR(MAX),
	 @RunType VARCHAR(1)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result NVARCHAR(MAX)	-----Platforms or Houseid
	SET @Result = ''	
	
	IF(@Type = '')
		SET @Type = 'H'
	-- =============================================
	-- TYPE 
	-- 'H' = House ID
	-- 'P' = Platform
	-- 'R' = No. Of Runs
	-- 'T' = International Territory
	-- 'CH' = Channels Name
	-- 'CC' = Channels Code
	
	-- 'RP' = Rights Period
	-- 'PR' = Provision Run
	-- 'AR' = Actual Run	
	
	-- 'PAR' = 'Provision Run' + 'Actual Run'
	-- =============================================
	
	
	--------------------- Platform ---------------------
	IF(@Type = 'P')
	BEGIN		
		SELECT DISTINCT 
		@Result += STUFF
		((
			SELECT DISTINCT ', ' + P.platform_name FROM ACQ_Deal_Rights DMR
			Inner JOIN Acq_Deal_Rights_Platform DMRP ON DMRP.Acq_Deal_Rights_Code = DMR.Acq_Deal_Rights_Code
			Inner JOIN Acq_Deal_Rights_Title DMRT ON DMRT.Acq_Deal_Rights_Code = DMR.Acq_Deal_Rights_Code
			Inner join Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code
			INNER JOIN [Platform]  P ON P.platform_code = DMRP.platform_code
			WHERE 1=1
			AND P.Platform_Code in
			(
				SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
			)
			
			FOR XML PATH('')
		),1,1,'') 
	END
	--------------------- END Platform ---------------------
	
	----------------------- International Territory ---------------------
	--ELSE IF(@Type = 'T')
	--BEGIN
	--	SELECT DISTINCT 
	--	@Result += STUFF
	--	((
	--		SELECT DISTINCT ', ' + IT.international_territory_name FROM Deal_Movie_Rights DMR
	--		INNER JOIN Deal_Movie_Rights_Territory DMRT ON DMRT.deal_movie_rights_code = DMR.deal_movie_rights_code
	--		INNER JOIN International_Territory  IT ON IT.international_territory_code = DMRT.territory_code
	--		WHERE DMR.deal_movie_code in (@Acq_Deal_Movie_Code)
	--		AND IT.international_territory_code in
	--		(
	--			SELECT international_territory_code FROM International_Territory WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
	--		)
			
	--		FOR XML PATH('')
	--	),1,1,'') 

	--END
	--------------------- End International Territory ---------------------
	----------------------- HouseID ---------------------
	--ELSE IF(@Type = 'H')
	--BEGIN
	--	SELECT DISTINCT 
	--	@Result += STUFF
	--	((
	--		SELECT DISTINCT ', ' + DMCH.House_ID FROM Deal_Movie_Contents_HouseID DMCH
	--		INNER JOIN Deal_Movie_Contents DMC ON DMC.deal_movie_content_code = DMCH.deal_movie_content_code
	--		WHERE DMC.deal_movie_code in (@Acq_Deal_Movie_Code)
			
	--		FOR XML PATH('')
	--	),1,1,'') 
	--END
	--------------------- End HouseID ---------------------
	
	--------------------- No Of Runs ---------------------
	ELSE IF(@Type = 'R')
	BEGIN
		DECLARE @NoOfRuns INT
		SET @NoOfRuns = 0
		
		DECLARE @Unlimited_Cnt INT
		SELECT  @Unlimited_Cnt = COUNT(run_type) FROM 
		(	
			SELECT DMR.no_of_runs, run_type FROM Acq_Deal_Run DMR
			WHERE 1=1 AND Acq_Deal_Code in (
				SELECT DISTINCT Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)
			)
		)  rights WHERE rights.run_type ='U' GROUP BY rights.run_type 
		
		SELECT @NoOfRuns = SUM(rights.no_of_runs) FROM 
		(
			SELECT DMR.no_of_runs FROM Acq_Deal_Run DMR
			WHERE 1=1 AND Acq_Deal_Code in (
				SELECT DISTINCT Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)
			)
		)  rights 
		
		
		IF(@Unlimited_Cnt > 0 AND @NoOfRuns > 0)
		BEGIN
			SET @Result = 'Unlimited' + ' / ' + CAST(@NoOfRuns as VARCHAR)
		END
		ELSE IF(@Unlimited_Cnt > 0)
		BEGIN
			SET @Result = 'Unlimited' ---------- + ',' + @Result
		END
		ELSE
		BEGIn
			SET @Result = @NoOfRuns
		END
		
		
		
	END
	--------------------- End No Of Runs ---------------------
	
	--------------------- Channel Names ---------------------
	ELSE IF(@Type = 'CH')
	BEGIN
		SELECT DISTINCT 
		@Result += STUFF
		(
			(
				SELECT DISTINCT ', ' + C.channel_name FROM ACQ_Deal D
				inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				AND ADRP.Platform_Code in
				(
					SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
				)
				INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Run_Channel DMRRC ON DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code
				inner join Channel C ON C.channel_code = DMRRC.channel_code
				WHERE 1=1 AND D.Acq_Deal_Code in ( SELECT DISTINCT Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code))
				AND ((@RunType<>'' AND DMRR.Run_Type = @RunType) OR @RunType='')
				--AND ((@Channel<>'' AND C.Channel_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')
			FOR XML PATH('')
			),1,1,''
		) 
		
	END
	--------------------- End Channel Names ---------------------

	--------------------- Channel Names ---------------------
	ELSE IF(@Type = 'CC')
	BEGIN
		SELECT DISTINCT 
		@Result += STUFF
		(
			(
				SELECT DISTINCT ', ' + C.channel_name FROM ACQ_Deal D
				inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				AND ADRP.Platform_Code in
				(
					SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
				)
				INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Run_Channel DMRRC ON DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code
				inner join Channel C ON C.channel_code = DMRRC.channel_code
				WHERE 1=1 AND D.Acq_Deal_Code in ( SELECT DISTINCT Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code))
				AND ((@RunType<>'' AND DMRR.Run_Type = @RunType) OR @RunType='')
				--AND ((@Channel<>'' AND C.Channel_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')
			FOR XML PATH('')
			),1,1,''
		) 
		
	END
	--------------------- End Channel Names ---------------------
	
	--------------------- Rights Period ---------------------
	ELSE IF(@Type = 'RP')
	BEGIN
		SELECT DISTINCT 
		@Result += STUFF
		((
			SELECT DISTINCT ',' + 
			
			--case when isnull(convert(VARCHAR(20),ADR.right_start_date,103),'')=''     
			--and isnull(convert(VARCHAR(20),ADR.right_end_date,103),'')='' then 'Unlimited' else    
			--convert(VARCHAR(20),ADR.right_start_date,103) +' - '+ convert(VARCHAR(20),ADR.right_end_date,103) end
			case when adr.Right_Type='U' then 'Perpetuity FROM ' + convert(VARCHAR(20),ADR.right_start_date,103)
			else    
			convert(VARCHAR(20),ADR.right_start_date,103) +' - '+ convert(VARCHAR(20),ADR.right_end_date,103) end
			FROM ACQ_Deal D
				inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				Inner Join Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				Inner Join Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = D.Acq_Deal_Code And ADRT.Title_Code = ADM.Title_Code And ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code
				AND ADRP.Platform_Code in
				(
					SELECT platform_code FROM Platform WHERE isnull(Is_No_Of_Run,'N') = 'Y'
				)
				AND 
				(
					(@RunType<>'' AND EXISTS(SELECT * FROM Acq_Deal_Run ADU
							INNER JOIN Acq_Deal_Run_Title ADUT ON ADU.Acq_Deal_Run_Code = ADUT.Acq_Deal_Run_Code
							WHERE ADU.Acq_Deal_Code = D.Acq_Deal_Code AND ADUT.Title_Code = ADM.Title_Code AND ADU.Run_Type = @RunType)
					)
				OR 
					@RunType=''
				)
		FOR XML PATH('')
		),1,1,'') 
		
	END
	--------------------- END Rights Period ---------------------
	
	--------------------- Provision Run ---------------------
	ELSE IF(@Type = 'PR')
	BEGIN
		
		SELECT @Result = count(*) FROM BV_Schedule_Transaction bv 
		Inner Join Acq_Deal_Movie adm ON adm.Acq_Deal_Movie_Code = bv.Deal_Movie_Code And adm.Title_Code = bv.Title_Code And adm.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code
		AND ((@Channel<>'' AND bv.Channel_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')
	AND ((@StartDate<>'' AND @EndDate <> '' AND CONVERT(DATE,bv.Schedule_Item_Log_Date,103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) OR (@StartDate<>'' AND @EndDate = '' AND CONVERT(DATE,bv.Schedule_Item_Log_Date,103) = CONVERT(DATE,@StartDate,103)) OR (@StartDate='' AND @EndDate <> '' AND CONVERT(DATE,bv.Schedule_Item_Log_Date,103) = CONVERT(DATE,@EndDate,103)) OR (@StartDate = '' AND @EndDate = ''))
	AND 
				(
					(@RunType<>'' AND EXISTS(SELECT * FROM Acq_Deal_Run ADU
							INNER JOIN Acq_Deal_Run_Title ADUT ON ADU.Acq_Deal_Run_Code = ADUT.Acq_Deal_Run_Code
							WHERE ADU.Acq_Deal_Code = adm.Acq_Deal_Code AND ADUT.Title_Code = adm.Title_Code AND ADU.Run_Type = @RunType)
					)
				OR 
					@RunType=''
				)
		--SELECT @Result = SUM(rights.no_of_runs_sched) FROM 
		--(
		--	SELECT a.no_of_runs_sched FROM 
		--	(
		--		SELECT ISNULL(DMRRC.no_of_runs_sched,0) no_of_runs_sched, ADRP.platform_code, 
		--		MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode
		--		FROM ACQ_Deal D
		--		Inner join Acq_Deal_Movie ADM ON ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)
		--		inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
		--		inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		--		AND ADRP.Platform_Code in
		--		(
		--			SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
		--		)
		--		INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code
		--		inner join Acq_Deal_Run_Channel DMRRC ON DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code
		--		inner join Channel C ON C.channel_code = DMRRC.channel_code
		--		--WHERE 1=1 AND D.Acq_Deal_Code in ( SELECT DISTINCT Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code))
		--	) a WHERE a.platform_code = a.MaxPtCode
		--)  rights 
	END
	--------------------- END Provision Run ---------------------	

	--------------------- Actual Run ---------------------
	ELSE IF(@Type = 'AR')
	BEGIN
		SELECT @Result = SUM(rights.no_of_AsRuns) FROM 
		(
			SELECT a.no_of_AsRuns FROM 
			(
				SELECT COALESCE(DMRRC.no_of_AsRuns,0) no_of_AsRuns, ADRP.platform_code, 
				MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode
				 FROM ACQ_Deal D
				Inner join Acq_Deal_Movie ADM ON ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)
				inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				AND ADRP.Platform_Code in
				(
					SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
				)
				INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Run_Channel DMRRC ON DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code
				inner join Channel C ON C.channel_code = DMRRC.channel_code
				WHERE ((@Channel<>'' AND C.Channel_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')
			) a WHERE a.platform_code = a.MaxPtCode		
		)  rights 
	END
	--------------------- END Actual Run ---------------------	
	
	--------------------- Actual Run ---------------------
	------------ PAR = Provision + Actual Run
	ELSE IF(@Type = 'PAR')
	BEGIN
		
		DECLARE @ProvRun INT;	SET @ProvRun = 0
		DECLARE @ActRun INT;	SET @ActRun = 0
		
		SELECT @ActRun = SUM(rights.no_of_AsRuns) FROM 
		(
			SELECT a.no_of_AsRuns FROM 
			(
				SELECT ISNULL(DMRRC.no_of_AsRuns,0) no_of_AsRuns, ADRP.platform_code, 
				MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode
				--0  as MaxPtCode
				FROM ACQ_Deal D
				Inner join Acq_Deal_Movie ADM ON ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)
				inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				AND ADRP.Platform_Code in
				(
					SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
				)
				INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Run_Channel DMRRC ON DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code
				inner join Channel C ON C.channel_code = DMRRC.channel_code
			) a WHERE a.platform_code = a.MaxPtCode		
		)  rights 
		
		SELECT @ProvRun = SUM(rights.no_of_runs_sched) FROM 
		(
			SELECT a.no_of_runs_sched FROM 
			(
				SELECT ISNULL(DMRRC.no_of_runs_sched,0) no_of_runs_sched, ADRP.platform_code, 
				MAX(ADRP.platform_code) over (partition by ADM.ACQ_deal_movie_code) as MaxPtCode
				FROM ACQ_Deal D
				Inner join Acq_Deal_Movie ADM ON ADm.Acq_Deal_Code = D.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code in (@Acq_Deal_Movie_Code)
				inner join Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP ON ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				AND ADRP.Platform_Code in
				(
					SELECT platform_code FROM Platform WHERE isnull(applicable_for_asrun_schedule,'N') = 'Y'
				)
				INNER JOIN ACQ_Deal_Run DMRR ON DMRR.Acq_Deal_Code = D.Acq_Deal_Code
				inner join Acq_Deal_Run_Channel DMRRC ON DMRRC.Acq_Deal_Run_Code = DMRR.Acq_Deal_Run_Code
				inner join Channel C ON C.channel_code = DMRRC.channel_code
			) a WHERE a.platform_code = a.MaxPtCode		
		)  rights 
		
		SET @Result = @ProvRun + @ActRun
		
	END
	--------------------- END Actual Run ---------------------	
	
	-- Return the result of the function
	RETURN @Result

END
