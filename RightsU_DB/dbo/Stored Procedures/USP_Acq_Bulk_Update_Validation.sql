ALTER PROCEDURE [dbo].[USP_Acq_Bulk_Update_Validation]
(
	@Rights_Bulk_Update Rights_Bulk_Update_UDT READONLY
)
AS
-- =============================================
-- Author:	Anchal Sikarwar
-- Create DATE: 09-06-2016
-- Description:	Acquisition Deal Rights Bulk Update
-- Updated by :
-- Date :
-- Reason:
-- =============================================
BEGIN
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL
	BEGIN
		DROP TABLE #temp1
	END
	IF OBJECT_ID('tempdb..#temp2') IS NOT NULL
	BEGIN
		DROP TABLE #temp2
	END
	IF OBJECT_ID('tempdb..#RightCode') IS NOT NULL
	BEGIN
		DROP TABLE #RightCode
	END
	IF OBJECT_ID('tempdb..#RightCodeTab') IS NOT NULL
	BEGIN
		DROP TABLE #RightCodeTab
	END
	IF OBJECT_ID('tempdb..#RCodeForHoldback') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeForHoldback
	END
	IF OBJECT_ID('tempdb..#RCodeForSynMap') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeForSynMap
	END
	IF OBJECT_ID('tempdb..#RCodeForRunDef') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeForRunDef
	END
	IF OBJECT_ID('tempdb..#RCodeGrp') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeGrp
	END
	IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	BEGIN
		DROP TABLE #Result
	END
		IF OBJECT_ID('tempdb..##Error_Record') IS NOT NULL
	BEGIN
		DROP TABLE ##Error_Record
	END

	IF OBJECT_ID('tempdb..#temp3') IS NOT NULL
	BEGIN
		DROP TABLE #temp3
	END

	Create TABLE #temp1(R_Code INT,I_Code INT);
	Create TABLE #temp2(R_Code INT,CCount INT);
	Create TABLE #temp3(Is_Acq_Syn_Map NVARCHAR(MAX));
	Create TABLE #RightCode(Right_Code INT);
	Create TABLE #RightCodeTab(R_Code INT,Is_Acq_Syn_Map char(1))
	Create TABLE #SelectedCodeTab(I_Code INT)
	Create TABLE #RCodeForHoldback(Right_Code INT);
	Create TABLE #RCodeForSynMap(Right_Code INT);
	Create TABLE #RCodeForRunDef(Right_Code INT);
	Create TABLE #RCodeGrp(Right_Code INT);
	Create TABLE #Result(Msg_Type VARCHAR(100),Right_Codes INT);
		
	Declare @rcount INT=0
	DECLARE @Right_Codes VARCHAR(MAX), @Codes VARCHAR(MAX), @Code INT, @Change_For CHAR(2), @Action_For CHAR(1), @Right_Code INT, @Rights_Type CHAR(1),
	@Original_Right_Type CHAR(1), @Start_Date DATE, @Milestone_Unit_Type VARCHAR(10), @End_Date DATE, @Term VARCHAR(10), @Milestone_Type_Code VARCHAR(10), 
	@Is_Tentative CHAR(1), @Milestone_No_Of_Unit VARCHAR(10), @Is_Exclusive VARCHAR(5), @Is_Title_Language VARCHAR(5), @Is_Sublicensing CHAR(1),
	@isSynAcqMap NVARCHAR(MAX) = '';

	SELECT 
	@Right_Codes = [Right_Codes], 
	@Change_For = [Change_For],
	@Action_For = [Action_For], 
	@Start_Date = [Start_Date], 
	@End_Date = [End_Date], 
	@Term = [Term], 
	@Milestone_Unit_Type=[Milestone_Unit_Type],
	@Milestone_Type_Code=[Milestone_Type_Code],
	@Milestone_No_Of_Unit=[Milestone_No_Of_Unit],
	@Original_Right_Type = [Rights_Type], 
	@Rights_Type = CASE WHEN [Rights_Type] = 'U' THEN 'Y' ELSE [Rights_Type] END,
	@Codes = [Codes], 
	@Is_Exclusive = [Is_Exclusive], 
	@Is_Title_Language = [Is_Title_Language], 
	@Is_Tentative = [Is_Tentative] 
	FROM @Rights_Bulk_Update

	if CHARINDEX('~',@Right_Codes) > 0
	begin
	 INSERT INTO #temp3(Is_Acq_Syn_Map)
		SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,'~') where number!=''
	end


	IF((SELECT COUNT(*) FROM #temp3) > 1 )
	BEGIN
		   SELECT TOP 1 @isSynAcqMap = number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,'~') where number!='' ORDER BY number DESC
		   SELECT TOP 1 @Right_Codes = number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,'~') where number!='' ORDER BY number
	END

	INSERT INTO #RightCode
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!=''

	IF((SELECT COUNT(*) FROM #temp3) > 1 )
	BEGIN
		INSERT INTO #RightCodeTab (R_Code,Is_Acq_Syn_Map)
		SELECT B.number, A.number FROM dbo.[fn_Split_withdelemiter](@isSynAcqMap,',') A 
		INNER JOIN dbo.[fn_Split_withdelemiter](@Right_Codes,',') B ON B.id = A.id
		WHERE A.number!='' and b.number != ''
	END
	ELSE
	BEGIN
		INSERT INTO #RightCodeTab(R_Code)
		SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!=''
	END

	INSERT INTO #SelectedCodeTab
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') where number!=''
	--if(@Codes!=NULL)
	INSERT INTO #temp1
	select a.number,b.number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')As a Inner Join  dbo.[fn_Split_withdelemiter](@Codes,',') AS b on 1=1
	where a.number!=0 AND b.number!=0
	CREATE TABLE ##Error_Record
	(
		Rights_Code INT,
		Title_Name NVARCHAR(MAX),
		Platform_Name VARCHAR(MAX), 
		Right_Start_Date DateTime, 
		Right_End_Date DateTime,
		Right_Type VARCHAR(MAX),
		Is_Sub_License VARCHAR(MAX),
		Is_Title_Language_Right VARCHAR(MAX),
		Country_Name NVARCHAR(MAX),
		Subtitling_Language NVARCHAR(MAX),
		Dubbing_Language NVARCHAR(MAX),
		Agreement_No VARCHAR(MAX), 
		ErrorMSG VARCHAR(MAX), 
		Episode_From INT, 
		Episode_To INT,
		Is_Updated VARCHAR(2)
	)

	DECLARE @RCODE INT,@IS_SYN_ACQ_MAP CHAR(1),@Deal_Rights_UDT Deal_Rights,@Deal_Rights_Territory_UDT Deal_Rights_Territory,@Deal_Rights_Subtitling_UDT Deal_Rights_Subtitling,
			@Deal_Rights_Dubbing_UDT Deal_Rights_Dubbing,@Deal_Rights_Platform_UDT Deal_Rights_Platform,@Deal_Rights_Title_UDT Deal_Rights_Title,@Is_Theatrical CHAR(1)

	DECLARE RightCursor CURSOR FOR SELECT R_Code, Is_Acq_Syn_Map FROM #RightCodeTab
	OPEN RightCursor FETCH NEXT FROM RightCursor INTO @RCODE, @IS_SYN_ACQ_MAP
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @Deal_Rights_UDT(Deal_Rights_Code,Deal_Code,Right_Start_Date,Right_End_Date,Milestone_No_Of_Unit,Milestone_Type_Code,Milestone_Unit_Type,
		Is_Exclusive,Is_Sub_License,Is_Tentative,Is_Title_Language_Right,Right_Type,Sub_License_Code,Term) 
		select Acq_Deal_Rights_Code,Acq_Deal_Code,Right_Start_Date,Right_End_Date,Milestone_No_Of_Unit,Milestone_Type_Code,Milestone_Unit_Type,
		Is_Exclusive,Is_Sub_License,Is_Tentative,Is_Title_Language_Right,Right_Type,Sub_License_Code,Term FROM Acq_Deal_Rights where Acq_Deal_Rights_Code=@RCODE

		insert INTO @Deal_Rights_Territory_UDT(Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
		select Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code=@RCODE

		insert Into @Deal_Rights_Subtitling_UDT(Deal_Rights_Code,Language_Group_Code,Language_Type,Subtitling_Code)
		select Acq_Deal_Rights_Code,Language_Group_Code,Language_Type,Language_Code FROM Acq_Deal_Rights_Subtitling where Acq_Deal_Rights_Code=@RCODE

		insert into @Deal_Rights_Dubbing_UDT(Deal_Rights_Code,Dubbing_Code,Language_Group_Code,Language_Type)
		select Acq_Deal_Rights_Code,Language_Code,Language_Group_Code,Language_Type FROM Acq_Deal_Rights_Dubbing where Acq_Deal_Rights_Code=@RCODE

		insert into @Deal_Rights_Platform_UDT(Deal_Rights_Code,Platform_Code)
		select Acq_Deal_Rights_Code,Platform_Code FROM Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code=@RCODE

		INSERT INTO @Deal_Rights_Title_UDT(Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
		select Acq_Deal_Rights_Code,Title_Code,Episode_From,Episode_To FROM Acq_Deal_Rights_Title where Acq_Deal_Rights_Code=@RCODE

		IF(@Change_For = 'P')
		BEGIN
			select @Is_Theatrical=Is_Theatrical_Right from Acq_Deal_Rights where Acq_Deal_Rights_Code = @RCODE
			IF(@Is_Theatrical!='Y')
			BEGIN
				IF(@Action_For='A')
				BEGIN
					INSERT INTO @Deal_Rights_Platform_UDT(Deal_Rights_Code,Platform_Code) 
					select @RCODE,t.I_Code 
					from #SelectedCodeTab AS t 
					where t.I_Code NOT IN (select Platform_Code FROM @Deal_Rights_Platform_UDT)

					INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
					Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
					EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																		@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''
					Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''
					IF(NOT EXISTS(select * FROM ##Error_Record where Rights_Code=@RCODE))
					BEGIN
						insert into ##Error_Record(Rights_Code,Is_Updated)
						values(@RCODE,'Y')
					END
					else
					BEGIN 
						Update ##Error_Record SET Is_Updated='N' where Rights_Code=@RCODE
					END
				END
				ELSE
				BEGIN

					DELETE FROM #RightCode where Right_Code IN(	
						select 
						Acq_Deal_Rights_Code
						from Acq_Deal_Rights_Platform AS SDRP
						where SDRP.Platform_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
						AND SDRP.Acq_Deal_Rights_Code IN(@RCODE)
						group by(SDRP.Acq_Deal_Rights_Code)
						HAVING COUNT(SDRP.Acq_Deal_Rights_Code)  > 0
					)

					INSERT INTO #RCodeForHoldback(Right_Code)
					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH
					Inner join Acq_Deal_Rights_Holdback_Platform HP on RH.Acq_Deal_Rights_Holdback_Code=HP.Acq_Deal_Rights_Holdback_Code
					Inner Join Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
					where RH.Acq_Deal_Rights_Code IN(@RCODE) AND HP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
			
					IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
					BEGIN
						INSERT INTO #RCodeForSynMap(Right_Code)
						select DISTINCT SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
						INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
						INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDRP.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
						INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
						where SAM.Deal_Rights_Code IN(@RCODE) 
						AND SDRP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
						AND ADRP.Platform_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
					END

					INSERT INTO #RCodeForRunDef(Right_Code)
					select Distinct Adr.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR
					INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Run_Title RunT ON ADRT.Title_Code=RunT.Title_Code
					Inner Join Acq_Deal_Rights_Platform ADRP ON  ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
					Inner JOIN [Platform] p ON ADRP.Platform_Code=p.Platform_Code
					where ADR.Acq_Deal_Rights_Code IN(@RCODE) 
					AND p.Is_No_Of_Run='Y' AND ADRP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

				END
			END
			ELSE
			BEGIN
				INSERT INTO #Result(Msg_Type,Right_Codes)
				Select 'It has Theatrical Rights' AS Msg_Type,Deal_Rights_Code FROM Syn_Acq_Mapping where Deal_Rights_Code = @RCODE
			END
		END
		ELSE IF(@Change_For = 'I')
		BEGIN
			select @Is_Theatrical=Is_Theatrical_Right from Acq_Deal_Rights where Acq_Deal_Rights_Code=@RCODE
			IF(@Is_Theatrical!='Y')
			BEGIN
				IF(@Action_For='A')
				BEGIN
					INSERT INTO @Deal_Rights_Territory_UDT(Deal_Rights_Code,Country_Code,Territory_Type)
					select @RCODE,t.I_Code,'I' from #SelectedCodeTab AS t where t.I_Code NOT IN (select Country_Code FROM @Deal_Rights_Territory_UDT)

					INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
					Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
					EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																			@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''
					Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''

					
				END
				ELSE
				BEGIN
					
					DELETE FROM #RightCode where Right_Code IN
					(	
						select Acq_Deal_Rights_Code
						from Acq_Deal_Rights_Territory AS SDRT
						where SDRT.Country_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
						AND SDRT.Acq_Deal_Rights_Code IN(@RCODE)
						group by(SDRT.Acq_Deal_Rights_Code)
						HAVING COUNT(SDRT.Acq_Deal_Rights_Code)  > 0
					)

					INSERT INTO #RCodeForHoldback(Right_Code)
					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH
					Inner join Acq_Deal_Rights_Holdback_Platform HP on RH.Acq_Deal_Rights_Holdback_Code=HP.Acq_Deal_Rights_Holdback_Code
					INNER JOIN Acq_Deal_Rights_Territory ADRT ON ADRT.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
					where RH.Acq_Deal_Rights_Code IN(@RCODE)
					AND HP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
					AND ADRT.Country_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

					IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
					BEGIN
						INSERT INTO #RCodeForSynMap(Right_Code)
						select DISTINCT SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
						INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
						INNER JOIN Syn_Deal_Rights_Territory SDRTT ON SDRTT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
						INNER JOIN Acq_Deal_Rights_Territory ADRT ON ADRT.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
						where SAM.Deal_Rights_Code IN (@RCODE) 
						AND SDRTT.Country_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
						AND ADRT.Country_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
					END
				END
			END
			ELSE
			BEGIN
				INSERT INTO #Result(Msg_Type,Right_Codes)
				Select 'It has Theatrical Rights' AS Msg_Type,Deal_Rights_Code FROM Syn_Acq_Mapping where Deal_Rights_Code = @RCODE
			END
		END
		ELSE IF(@Change_For = 'T')
		BEGIN 
			select @Is_Theatrical=Is_Theatrical_Right from Acq_Deal_Rights where Acq_Deal_Rights_Code=@RCODE
			IF(@Is_Theatrical!='Y')
				BEGIN
				IF(@Action_For='A')
				BEGIN
					INSERT INTO #temp2(R_Code,CCount)
					select tmpb.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code,Count(*) AS CT from
					(
					select @RCODE AS Right_Code, TD.Country_Code FROM Territory_Details TD WHERE TD.Territory_Code 
					IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') ) 
					) as tmpA
					INNER JOIN 
					(	
					select SDT.Acq_Deal_Rights_Code,TDD.Country_Code from
					(
					select SD.Acq_Deal_Rights_Code,SD.Territory_Code  FROM Acq_Deal_Rights_Territory AS SD where Acq_Deal_Rights_Code
						IN(@RCODE)
						)AS SDT
					INNER JOIN Territory_Details AS TDD ON SDT.Territory_Code=TDD.Territory_Code
					) as tmpb on tmpA.Right_Code=tmpb.Acq_Deal_Rights_Code AND tmpA.Country_Code=tmpb.Country_Code
					group by tmpb.Acq_Deal_Rights_Code
	
					IF(EXISTS(SELECT * FROM #temp2))
					BEGIN
						INSERT INTO #RCodeGrp
						SELECT R_Code FROM #temp2 where CCount>0
						DELETE FROM #RightCodeTab
						INSERT INTO #RightCodeTab
						SELECT R_Code FROM #temp2 where CCount=0
					END

					INSERT INTO @Deal_Rights_Territory_UDT(Deal_Rights_Code,Territory_Code,Territory_Type)
					select @RCODE,t.I_Code,'G' from #SelectedCodeTab AS t where t.I_Code NOT IN (select Territory_Code FROM @Deal_Rights_Territory_UDT)



					INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
					Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
					EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																			@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

					Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''

				END
				ELSE
				BEGIN
				
					DELETE FROM #RightCode where Right_Code IN
					(	
						select Acq_Deal_Rights_Code
						from Acq_Deal_Rights_Territory AS SDRP
						where SDRP.Territory_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
						AND SDRP.Acq_Deal_Rights_Code IN(@RCODE)
						group by(SDRP.Acq_Deal_Rights_Code)
						HAVING COUNT(SDRP.Acq_Deal_Rights_Code)  > 0
					) 

					INSERT INTO #RCodeForHoldback(Right_Code)
					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH
					Inner join Acq_Deal_Rights_Holdback_Territory HS on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
					Inner join Acq_Deal_Rights_Territory ADRS ON ADRS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
					INNER JOIN Territory_Details LGD ON ADRS.Territory_Code=LGD.Territory_Code
					where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
					( 
						HS.Country_Code=LGD.Country_Code
					) AND ADRS.Territory_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

					IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
					BEGIN
						INSERT INTO #RCodeForSynMap(Right_Code)
						select DISTINCT  SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
						INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
						INNER JOIN Syn_Deal_Rights_Territory SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
						INNER JOIN Acq_Deal_Rights_Territory ADRT ON ADRT.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
						INNER JOIN Territory_Details TD ON ADRT.Territory_Code=TD.Territory_Code
						where SAM.Deal_Rights_Code IN (@RCODE) 
						AND 
						( 
							SDRT.Territory_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
							OR 
							SDRT.Country_Code=TD.Country_Code
						) AND ADRT.Territory_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
					END
				END
			END
			ELSE
			BEGIN
				INSERT INTO #Result(Msg_Type,Right_Codes)
				Select 'It has Theatrical Rights' AS Msg_Type,Deal_Rights_Code FROM Syn_Acq_Mapping where Deal_Rights_Code = @RCODE
			END
		END
		ELSE IF(@Change_For = 'SL')
		BEGIN 
			IF(@Action_For='A')
			BEGIN
				INSERT INTO @Deal_Rights_Subtitling_UDT(Deal_Rights_Code,Subtitling_Code,Language_Type)
				select @RCODE,t.I_Code,'L' 
				from #SelectedCodeTab AS t 
				where t.I_Code NOT IN (select Subtitling_Code FROM @Deal_Rights_Subtitling_UDT)

				INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
				Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
				EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																		@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

				Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''

			END
			ELSE
			BEGIN
			
				DELETE FROM #RightCode where Right_Code IN
				(	
					SELECT SDR.Acq_Deal_Rights_Code
					FROM Acq_Deal_Rights SDR
					LEFT JOIN 
					(	
						SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Subtitling SDRS
						WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
						AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
						GROUP BY SDRS.Acq_Deal_Rights_Code 
					) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					LEFT JOIN 
					(	
						SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Dubbing SDRD
						WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
						GROUP BY SDRD.Acq_Deal_Rights_Code 
					) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					WHERE SDR.Acq_Deal_Rights_Code IN (@RCODE)
					AND
					(
						(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
					)
				)

				INSERT INTO #RCodeForHoldback(Right_Code)
				select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH
				Inner join Acq_Deal_Rights_Holdback_Subtitling HS on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
				INNER JOIN Acq_Deal_Rights_Subtitling ADRSS ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
				where RH.Acq_Deal_Rights_Code IN (@RCODE)
				AND HS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
				AND ADRSS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))

				IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
				BEGIN
					INSERT INTO #RCodeForSynMap(Right_Code)
					select DISTINCT  SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
					INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Subtitling SDRSS ON SDRSS.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Subtitling ADRSS ON ADRSS.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
					where SAM.Deal_Rights_Code IN (@RCODE)
					AND SDRSS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
					AND ADRSS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
				END
			END
		END
		ELSE IF(@Change_For = 'SG')
		BEGIN 
			IF(@Action_For='A')
			BEGIN
			INSERT INTO #temp2
			select tmpb.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code,Count(*) AS CT from
			(
				select @RCODE AS Right_Code,LGD.Language_Code FROM Language_Group_Details LGD WHERE LGD.Language_Group_Code 
				IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
			) as tmpA
			INNER JOIN 
			(	
				select SDT.Acq_Deal_Rights_Code,TDD.Language_Code from
				(
					select SD.Acq_Deal_Rights_Code,SD.Language_Group_Code  FROM Acq_Deal_Rights_Subtitling AS SD where Acq_Deal_Rights_Code	IN(@RCODE)
				)AS SDT
				INNER JOIN Language_Group_Details AS TDD ON SDT.Language_Group_Code=TDD.Language_Group_Code
			) as tmpb on tmpA.Right_Code=tmpb.Acq_Deal_Rights_Code AND tmpA.Language_Code=tmpb.Language_Code
			group by tmpb.Acq_Deal_Rights_Code

			IF(EXISTS(SELECT * FROM #temp2))

			BEGIN
				INSERT INTO #RCodeGrp
				SELECT R_Code FROM #temp2 where CCount>0
				DELETE FROM #RightCodeTab
				INSERT INTO #RightCodeTab
				SELECT R_Code FROM #temp2 where CCount=0
			END

			INSERT INTO @Deal_Rights_Subtitling_UDT(Deal_Rights_Code,Language_Group_Code,Language_Type)
			select @RCODE,t.I_Code,'G' 
			from #SelectedCodeTab AS t 
			where t.I_Code NOT IN (select Language_Group_Code FROM @Deal_Rights_Subtitling_UDT)

			INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
			Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
			EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																	@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

			Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''

		END
			ELSE
			BEGIN

					DELETE FROM #RightCode where Right_Code IN
					(	
						SELECT 
							SDR.Acq_Deal_Rights_Code
						FROM Acq_Deal_Rights SDR
						LEFT JOIN 
						(	
						SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 

							FROM Acq_Deal_Rights_Subtitling SDRS

							WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)

							AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 

							GROUP BY SDRS.Acq_Deal_Rights_Code 

						) AS TmpSDRS

							ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code

						LEFT JOIN 

						(	

							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 

							FROM Acq_Deal_Rights_Dubbing SDRD

							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)

							GROUP BY SDRD.Acq_Deal_Rights_Code 

						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code

						WHERE 

						SDR.Acq_Deal_Rights_Code IN (@RCODE)

						AND

						(

							(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)

						)

					)

					--select * FROM #RightCode 

					INSERT INTO #RCodeForHoldback(Right_Code)

					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH

						Inner join Acq_Deal_Rights_Holdback_Subtitling HS on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code

						Inner join Acq_Deal_Rights_Subtitling ADRSS ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code

						INNER JOIN Language_Group_Details LGD ON ADRSS.Language_Group_Code=LGD.Language_Group_Code

						where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 

						( 

							HS.Language_Code=LGD.Language_Code

							)

							AND ADRSS.Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))

							--select * FROM #RCodeForHoldback
					IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
					BEGIN
					INSERT INTO #RCodeForSynMap(Right_Code)
						select DISTINCT SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
						INNER JOIN Syn_Deal_Rights SDRR ON SAM.Syn_Deal_Rights_Code=SDRR.Syn_Deal_Rights_Code
						INNER JOIN Syn_Deal_Rights_Subtitling SDRSS ON SDRSS.Syn_Deal_Rights_Code=SDRSS.Syn_Deal_Rights_Code
						INNER JOIN Acq_Deal_Rights_Subtitling ADRS ON ADRS.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
						INNER JOIN Language_Group_Details LGD ON ADRS.Language_Group_Code=LGD.Language_Group_Code 
							where SAM.Deal_Rights_Code IN (@RCODE) AND ( SDRSS.Language_Group_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
							OR SDRSS.Language_Code=LGD.Language_Code)
							AND ADRS.Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
					END
				END
		END
		ELSE IF(@Change_For = 'DL')
		BEGIN
			IF(@Action_For='A')
			BEGIN
				INSERT INTO @Deal_Rights_Dubbing_UDT(Deal_Rights_Code,Dubbing_Code,Language_Type)
				select @RCODE,t.I_Code,'L' FROM #SelectedCodeTab AS t where t.I_Code NOT IN( select Dubbing_Code FROM @Deal_Rights_Dubbing_UDT)

				INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
				Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
				EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																		@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

				Update ##Error_Record SET Rights_Code=@RCODE	where Rights_Code IS NULL OR Rights_Code=''

			END
			ELSE
			BEGIN
				

				DELETE FROM #RightCode where Right_Code IN
				(	
					SELECT SDR.Acq_Deal_Rights_Code
					FROM Acq_Deal_Rights SDR
					LEFT JOIN 
					(	
						SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Dubbing SDRD
						WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
						AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
						GROUP BY SDRD.Acq_Deal_Rights_Code 
					) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					LEFT JOIN 
					(	
						SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Subtitling SDRS
						WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
						GROUP BY SDRS.Acq_Deal_Rights_Code 
					) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					WHERE 
					SDR.Acq_Deal_Rights_Code IN (@RCODE)
					AND
					(
						(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
					)
				)

				INSERT INTO #RCodeForHoldback(Right_Code)
				select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH
				Inner join Acq_Deal_Rights_Holdback_Dubbing HS on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
				Inner join Acq_Deal_Rights_Dubbing ADRS on ADRS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
				where RH.Acq_Deal_Rights_Code IN(@RCODE) 
				AND HS.Language_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
				AND ADRS.Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))

				IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
				BEGIN
					INSERT INTO #RCodeForSynMap(Right_Code)
					select DISTINCT  SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
					INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Dubbing SDRS ON SDRS.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					Inner join Acq_Deal_Rights_Dubbing ADRS on ADRS.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
					where SAM.Deal_Rights_Code IN(@RCODE) 
					AND SDRS.Language_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
					AND ADRS.Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
				END
			END
		END
		ELSE IF(@Change_For = 'DG')
		BEGIN
			IF(@Action_For='A')
			BEGIN
				INSERT INTO #temp2
				select tmpb.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code,Count(*) AS CT from
				(
					SELECT @RCODE AS Right_Code,LGD.Language_Code FROM Language_Group_Details LGD WHERE LGD.Language_Group_Code 
					IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
					) as tmpA
					INNER JOIN 
					(	
						select SDT.Acq_Deal_Rights_Code,TDD.Language_Code from
						(
							select SD.Acq_Deal_Rights_Code,SD.Language_Group_Code  FROM Acq_Deal_Rights_Dubbing AS SD where Acq_Deal_Rights_Code IN(@RCODE)
						)AS SDT
						INNER JOIN Language_Group_Details AS TDD ON SDT.Language_Group_Code=TDD.Language_Group_Code
					) as tmpb on tmpA.Right_Code=tmpb.Acq_Deal_Rights_Code AND tmpA.Language_Code=tmpb.Language_Code group by tmpb.Acq_Deal_Rights_Code

				IF(EXISTS(SELECT * FROM #temp2))
				BEGIN
					INSERT INTO #RCodeGrp
					SELECT R_Code FROM #temp2 where CCount>0
					DELETE FROM #RightCodeTab
					INSERT INTO #RightCodeTab
					SELECT R_Code FROM #temp2 where CCount=0
				END

				INSERT INTO @Deal_Rights_Dubbing_UDT(Deal_Rights_Code,Language_Group_Code,Language_Type)
				select @RCODE,t.I_Code,'G' 
				from #SelectedCodeTab AS t 
				LEFT JOIN 
				Acq_Deal_Rights_Dubbing AS SDRP 
				ON SDRP.Acq_Deal_Rights_Code = @RCODE AND SDRP.Language_Group_Code = t.I_Code
				where isnull(SDRP.Language_Group_Code,0) = 0

				INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
				Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
				EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																		@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

				Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''

				IF(NOT EXISTS(select * FROM ##Error_Record where Rights_Code=@RCODE) AND NOT EXISTS(select * from #RCodeGrp))
				BEGIN
					delete FROM @Deal_Rights_Dubbing_UDT
				END
			END			
			ELSE
			BEGIN
				

				DELETE FROM #RightCode where Right_Code IN
				(	
					SELECT SDR.Acq_Deal_Rights_Code
					FROM Acq_Deal_Rights SDR
					LEFT JOIN 
					(	
						SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Dubbing SDRD
						WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
						AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
						GROUP BY SDRD.Acq_Deal_Rights_Code 
					) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					LEFT JOIN 
					(	
						SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Subtitling SDRS
						WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
						GROUP BY SDRS.Acq_Deal_Rights_Code 
					) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					WHERE SDR.Acq_Deal_Rights_Code IN (@RCODE)
					AND
					(
						(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
					)
				)

				INSERT INTO #RCodeForHoldback(Right_Code)
				select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH
				Inner join Acq_Deal_Rights_Holdback_Dubbing HS on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
				Inner join Acq_Deal_Rights_Dubbing ADRSS ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
				INNER JOIN Language_Group_Details LGD ON ADRSS.Language_Group_Code=LGD.Language_Group_Code
				where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
				( 
					HS.Language_Code=LGD.Language_Code
				) AND ADRSS.Language_Group_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

				IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
				BEGIN
					INSERT INTO #RCodeForSynMap(Right_Code)
					select DISTINCT SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
					INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Dubbing SDRS ON SDRS.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Dubbing ADRS ON ADRS.Acq_Deal_Rights_Code=SAM.Deal_Rights_Code
					INNER JOIN Language_Group_Details LGD ON ADRS.Language_Group_Code=LGD.Language_Group_Code 
					where SAM.Deal_Rights_Code IN (@RCODE) 
					AND ( SDRS.Language_Group_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))	OR SDRS.Language_Code=LGD.Language_Code	)
					AND ADRS.Language_Group_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
				END
			END
		END
		-- STARTDATE AND ENDDATE
		ELSE
		BEGIN
			DeClare @DateCount INT=0
			if(@Change_For='RP')
			BEGIN
				IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
				BEGIN
					if(EXISTS(Select Syn_Deal_Rights_Code FROM Syn_Acq_Mapping where Deal_Rights_Code=@RCODE))
				BEGIN
					IF(@Original_Right_Type = 'Y')
					BEGIN
						DECLARE @Is_T Varchar(2)
						SELECT @Is_T= Is_Tentative FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code=@RCODE
						IF(@Is_T='N' AND @Is_Tentative='Y')
						BEGIN
							INSERT INTO #Result(Msg_Type,Right_Codes)
							Select 'Can not be set to Tentative as it is already syndicated' AS Msg_Type,Deal_Rights_Code FROM Syn_Acq_Mapping where Deal_Rights_Code = @RCODE
						END
						select @DateCount=COUNT(*) FROM Syn_Deal_Rights where (DATEDIFF(day,@Start_Date,Right_Start_Date)<0 OR DATEDIFF(day,@End_Date,Right_End_Date)>0)
						AND Syn_Deal_Rights_Code IN(Select Syn_Deal_Rights_Code FROM Syn_Acq_Mapping where Deal_Rights_Code=@RCODE)
					END
					ELSE IF(@Rights_Type = (SELECT Right_Type FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @RCODE))
					BEGIN
						SELECT @DateCount = COUNT(*) FROM Syn_Deal_Rights WHERE (DATEDIFF(DAY, @Start_Date, Right_Start_Date) < 0 OR DATEDIFF(DAY, @End_Date, Right_End_Date) > 0)
						AND Syn_Deal_Rights_Code IN (SELECT Syn_Deal_Rights_Code FROM Syn_Acq_Mapping WHERE Deal_Rights_Code = @RCODE)
					END
					ELSE
					BEGIN
						INSERT INTO #Result(Msg_Type,Right_Codes)
						SELECT 'Can not change rights type as it is already syndicated' AS Msg_Type,@RCODE
					END	
					IF(@DateCount>0)
					BEGIN
						INSERT INTO #Result(Msg_Type,Right_Codes)
						SELECT 'Can not reduce rights period as it is already syndicated' As Msg_Type,@RCODE
					END
				END
				END
				IF EXISTS(SELECT * FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @RCODE AND (
					Right_Start_Date != @Start_Date OR Right_End_Date != @End_Date OR Is_Tentative != @Is_Tentative
				))
				BEGIN 
					--Can not change rights period as Run Definition is already added. To change rights period, delete Run Definition first.
					--Can not change Tentative state as Run Definition is already added. To change rights period, delete Run Definition first.
					INSERT INTO #RCodeForRunDef(Right_Code)
					select DISTINCT Adr.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR
					INNER JOIN Acq_Deal_Run ADRu ON ADR.Acq_Deal_Code=ADRu.Acq_Deal_Code
					INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Run_Title RunT ON ADRu.Acq_Deal_Run_Code=RunT.Acq_Deal_Run_Code
					where ADR.Acq_Deal_Rights_Code IN(@RCODE)
					AND ADRu.Is_Yearwise_Definition = 'Y' AND ADRu.Run_Type!='U' 
				END		
				IF(@DateCount = 0 AND NOT EXISTS(SELECT * FROM #Result WHERE Right_Codes = @RCODE) AND NOT EXISTS(SELECT * FROM #RCodeForRunDef WHERE Right_Code = @RCODE))
				BEGIN
					UPDATE @Deal_Rights_UDT SET Right_Start_Date=@Start_Date,Right_End_Date=@End_Date,Term=@Term,Is_Tentative=@Is_Tentative,Right_Type=@Rights_Type,
					Milestone_No_Of_Unit=@Milestone_No_Of_Unit,Milestone_Type_Code=@Milestone_Type_Code,Milestone_Unit_Type=@Milestone_Unit_Type
						
					INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
					Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
					EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
								@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''
													
					Update ##Error_Record SET Rights_Code=@RCODE	where Rights_Code IS NULL OR Rights_Code=''		
					IF(NOT EXISTS(select * FROM ##Error_Record where Rights_Code=@RCODE) AND NOT EXISTS(select * FROM #RCodeForRunDef where Right_Code=@RCODE))
					BEGIN
						DECLARE @Enabled_Perpetuity CHAR(1)
						select @Enabled_Perpetuity=Parameter_Value from System_Parameter_New where Parameter_Name= 'Enabled_Perpetuity'
						IF(ISNULL(@Enabled_Perpetuity,'N')='N')
						BEGIN
							select @Enabled_Perpetuity=Parameter_Value from System_Parameter_New where Parameter_Name= 'Enabled_Perpetuity'
						END
						ELSE IF((@Original_Right_Type = 'Y' OR @Original_Right_Type = 'U')AND @Enabled_Perpetuity='Y')
						BEGIN
							select @Enabled_Perpetuity=Parameter_Value from System_Parameter_New where Parameter_Name= 'Enabled_Perpetuity'
						END
						ELSE
						BEGIN
							DECLARE @Is_Ten VARCHAR(2), @ExistingType VARCHAR(2)
							SELECT @Is_Ten = Is_Tentative, @ExistingType = Right_Type FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @RCODE

							IF(@Is_Ten = 'Y' OR @Is_Ten = '' OR @Is_Ten IS NULL)
								SET @Is_Tentative = 'Y'
							ELSE
								SET @Is_Tentative = 'N'

							IF(@Rights_Type = @ExistingType AND @Is_Ten = 'N')
							BEGIN
								INSERT INTO #Result(Msg_Type,Right_Codes)
								SELECT 'Milestone is already set' AS Msg_Type, @RCODE
							END								
						END
					END
					else
						BEGIN 
							Update ##Error_Record SET Is_Updated='N' where Rights_Code=@RCODE
						END					
				END
			END
			ELSE IF(@Change_For='TL')
			BEGIN
				IF(@Is_Title_Language='N')
				BEGIN

				IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
				BEGIN
					INSERT INTO #RCodeForSynMap(Right_Code)
					select DISTINCT SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM
					INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					where SAM.Deal_Rights_Code = @RCODE AND SDR.Is_Title_Language_Right='Y'
				END


					INSERT INTO #RCodeForHoldback(Right_Code)
					select DISTINCT ADRH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback ADRH
					where ADRH.Is_Title_Language_Right='Y' AND ADRH.Acq_Deal_Rights_Code=@RCODE

					DELETE FROM #RightCode where Right_Code IN
					(
						SELECT SDR.Acq_Deal_Rights_Code	FROM Acq_Deal_Rights SDR
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Dubbing SDRD
							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
							GROUP BY SDRD.Acq_Deal_Rights_Code 
						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS
							WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
							GROUP BY SDRS.Acq_Deal_Rights_Code 
						) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						WHERE SDR.Acq_Deal_Rights_Code IN (@RCODE)
						AND
						(
							(TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
						)
					)
				END
				ELSE
				BEGIN
					UPDATE @Deal_Rights_UDT SET Is_Title_Language_Right=@Is_Title_Language
					INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
					Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
					EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																		@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

					Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''
	
				END
			END
			ELSE IF(@Change_For='E')
			BEGIN
				UPDATE @Deal_Rights_UDT SET  Is_Exclusive=@Is_Exclusive 
				INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
				Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
				EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,
				@Deal_Rights_Territory_UDT,@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

				Update ##Error_Record SET Rights_Code=@RCODE	where Rights_Code IS NULL OR Rights_Code=''
				
				delete FROM @Deal_Rights_UDT
			END
			ELSE IF(@Change_For='S')
			BEGIN
				SELECT @Codes = number FROM dbo.[fn_Split_withdelemiter](@Codes,',') where number!=''
				if(@Codes='0' OR @Codes='-1')
				BEGIN
					UPDATE @Deal_Rights_UDT SET  Is_Sub_License='N',Sub_License_Code=NULL
				END
				ELSE
				BEGIN
					UPDATE @Deal_Rights_UDT SET  Is_Sub_License='Y',Sub_License_Code=@Codes 
				END

				IF(ISNULL(@IS_SYN_ACQ_MAP,'') = 'Y')
				BEGIN
					INSERT INTO #RCodeForSynMap(Right_Code)
					select DISTINCT  SAM.Deal_Rights_Code FROM Syn_Acq_Mapping SAM INNER JOIN Syn_Deal_Rights SDR ON SAM.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
					where SAM.Deal_Rights_Code IN(@RCODE) 
				END
				INSERT INTO ##Error_Record (Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
				Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To)
				EXEC [dbo].[USP_Validate_Rights_Duplication_UDT_Acq] @Deal_Rights_UDT,@Deal_Rights_Title_UDT,@Deal_Rights_Platform_UDT,@Deal_Rights_Territory_UDT,
																	@Deal_Rights_Subtitling_UDT,@Deal_Rights_Dubbing_UDT,'AR',''

				Update ##Error_Record SET Rights_Code=@RCODE where Rights_Code IS NULL OR Rights_Code=''

			END
		END
		
		DELETE FROM @Deal_Rights_UDT
		DELETE FROM @Deal_Rights_Platform_UDT
		DELETE FROM @Deal_Rights_Territory_UDT
		DELETE FROM @Deal_Rights_Subtitling_UDT
		DELETE FROM @Deal_Rights_Dubbing_UDT
		DELETE FROM @Deal_Rights_Title_UDT
		FETCH NEXT FROM RightCursor
		INTO @RCODE, @IS_SYN_ACQ_MAP
	END
	CLOSE RightCursor
	DEALLOCATE RightCursor

	IF((select COUNT(*) FROM #RCodeForHoldback)>0)
	BEGIN
		print '#RCodeForHoldback'
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT 'HB',rc.Right_Code FROM #RCodeForHoldback rc
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT '',number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!='0' AND number!='' AND number 
		NOT IN(select Right_Code FROM #RCodeForHoldback)
	END																	 																	
	IF((select COUNT(*) FROM #RCodeForRunDef)>0)						 
	BEGIN	
		print '#RCodeForRunDef'
		Insert INTO #Result(Msg_Type,Right_Codes)							 
		SELECT 'RD',rc.Right_Code FROM #RCodeForRunDef rc
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT '',number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!='0' AND number!='' AND number 
		NOT IN(select Right_Code FROM #RCodeForRunDef)
	END																	 																	
	IF((select COUNT(*) FROM #RCodeForSynMap)>0)						 
	BEGIN
		print '#RCodeForSynMap'
		Insert INTO #Result(Msg_Type,Right_Codes)							 
		SELECT 'SM' AS Msg_Type,rc.Right_Code AS Right_Codes FROM #RCodeForSynMap rc
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT '' AS Msg_Type,number AS Right_Codes FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!='0' AND number!='' AND number 
		NOT IN(select Right_Code FROM #RCodeForSynMap)
	END
	IF((@Change_For='P' OR @Change_For = 'I' OR @Change_For='T' OR @Change_For='SL' OR @Change_For='SG' OR @Change_For='DL' OR @Change_For='DG') AND @Action_For='D' 
	OR (@Change_For='TL' AND @Is_Title_Language='N') AND (select COUNT(*) FROM #RightCode)>0)
	BEGIN
		print '@Change_For sfgdfg'

		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT 'AO',rc.Right_Code FROM #RightCode rc
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT '',number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!='0' 
		AND number!='' AND number NOT IN(select Right_Code FROM #RightCode)

	END
	ELSE IF((@Change_For='T' OR @Change_For='SG' OR @Change_For='DG') AND @Action_For='A')
	BEGIN
		print '@Action_For'
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT 'GV',rc.R_Code FROM #temp2 rc where rc.CCount>1
		Insert INTO #Result(Msg_Type,Right_Codes)
		SELECT '',rc.R_Code FROM #temp2 rc where rc.CCount<1
	END

	DECLARE @RC INT,@MT VARCHAR(MAX)

	IF(EXISTS(SELECT * FROM #Result) OR EXISTS(SELECT distinct(Rights_Code) FROM ##Error_Record where Is_Updated='Y'))
	BEGIN
		IF((SELECT COUNT(*) FROM ##Error_Record where Is_Updated='Y')>0)
		BEGIN
			insert into #Result(Right_Codes,Msg_Type)
			select distinct(Rights_Code),'' FROM ##Error_Record where Is_Updated='Y'
		END
			
		DECLARE FinalCursor CURSOR FOR SELECT Msg_Type,Right_Codes FROM #Result
		OPEN FinalCursor
		FETCH NEXT FROM FinalCursor
		INTO @MT,@RC
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO ##Error_Record(Rights_Code,Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
			Is_Title_Language_Right,Country_Name,Subtitling_Language,Dubbing_Language,Agreement_No,ErrorMSG,Episode_From,Episode_To,Is_Updated)
			Select @RC AS Rights_Code,
			Title_Name, 
			abcd.Platform_Hiearachy AS Platform_Name , 
			Actual_Right_Start_Date  as Right_Start_Date, 
			Actual_Right_End_Date as Right_End_Date,
			CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
			CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
			CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
			Country_Name,
			CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
			CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
			Agreement_No,
			@MT AS ErrorMSG, 
			Episode_From,
			Episode_To,
			CASE WHEN @MT='' THEN 'Y' ELSE 'N' END AS Is_Updated
			From(
			Select *,
			REVERSE(
					stuff(
						reverse(
							STUFF((
								Select CASE WHEN Territory_Type = 'G' THEN t.Territory_Name+', ' 
								WHEN Territory_Type = 'I' THEN c.Country_Name+', ' END
								from Acq_Deal_Rights_Territory adrt
								LEFT JOIN Territory t ON t.Territory_Code = adrt.Territory_Code
								LEFT JOIN Country c ON c.Country_Code = adrt.Country_Code
								where adrt.Acq_Deal_Rights_Code In (@RC) FOR XML PATH(''), root('Country_Name'), type
								).value('/Country_Name[1]','Nvarchar(max)'
						),2,0, '')), 1, 1, '')) as Country_Name
			,
			STUFF((
				Select ',' + CAST(P.Platform_Code as Varchar) 
				From Platform p Where p.Platform_Code In
				(
					Select Platform_Code 
					FROM Acq_Deal_Rights_Platform 
					where Acq_Deal_Rights_Code=@RC
				)
				FOR XML PATH('')), 1, 1, ''
			) as Platform_Code,
			REVERSE(
					STUFF(REVERSE(STUFF((
						Select CASE WHEN Language_Type = 'G' THEN lg.Language_Group_Name+', '
						WHEN Language_Type = 'L' THEN l.Language_Name+', ' END
						from Acq_Deal_Rights_Subtitling adrs
						LEFT JOIN Language_Group lg ON lg.Language_Group_Code = adrs.Language_Group_Code
						LEFT JOIN [Language] l ON l.Language_Code = adrs.Language_Code
						where adrs.Acq_Deal_Rights_Code In (@RC)
						FOR XML PATH(''), root('Subtitling_Language'), type
						).value('/Subtitling_Language[1]','Nvarchar(max)'

					),2,0, '')), 1, 1, '')) as Subtitling_Language
			,
			REVERSE(
					STUFF(REVERSE(STUFF((
						Select   CASE WHEN Language_Type = 'G' THEN lg.Language_Group_Name+', '
						WHEN Language_Type = 'L' THEN l.Language_Name+', ' END
						from Acq_Deal_Rights_Dubbing adrs
						LEFT JOIN Language_Group lg ON lg.Language_Group_Code = adrs.Language_Group_Code
						LEFT JOIN [Language] l ON l.Language_Code = adrs.Language_Code
						where adrs.Acq_Deal_Rights_Code In (@RC)
						FOR XML PATH(''), root('Dubbing_Language'), type
						).value('/Dubbing_Language[1]','Nvarchar(max)'
					),2,0, '')), 1, 1, ''))  as Dubbing_Language
			,
			STUFF
			(
				(
					Select ', ' + t.Agreement_No FROM Acq_Deal t
					Where  t.Deal_Workflow_Status NOT IN ('AR', 'WA') AND t.Acq_Deal_Code In (
						Select adr.Acq_Deal_Code FROM Acq_Deal_Rights adr where adr.Acq_Deal_Rights_Code=@RC
				)FOR XML PATH('')), 1, 1, ''
			) as Agreement_No
			From (
				Select T.Title_Code,
				DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
				ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
				Is_Sub_License, Is_Title_Language_Right, 
				Right_Type, Episode_From, Episode_To
				from Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Title ADRT on ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
				INNER JOIN Title T ON T.Title_Code=ADRT.Title_Code where ADR.Acq_Deal_Rights_Code=@RC
				Group By T.Title_Code, T.Title_Name, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Sub_License,
				Is_Title_Language_Right,Right_Type,Episode_From,Episode_To,Deal_Type_Code
			) as a
		) as MainOutput
		Cross Apply
		(
			Select * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
		) as abcd
		FETCH NEXT FROM FinalCursor
		INTO @MT,@RC
		END
		CLOSE FinalCursor
		DEALLOCATE FinalCursor
	END
	 --SELECT * FROM ##Error_Record

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	BEGIN
		DROP TABLE #temp
	END
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL
	BEGIN
		DROP TABLE #temp1
	END
	IF OBJECT_ID('tempdb..#temp2') IS NOT NULL
	BEGIN
		DROP TABLE #temp2
	END
	IF OBJECT_ID('tempdb..#RightCode') IS NOT NULL
	BEGIN
		DROP TABLE #RightCode
	END
	IF OBJECT_ID('tempdb..#RightCodeTab') IS NOT NULL
	BEGIN
		DROP TABLE #RightCodeTab
	END
	IF OBJECT_ID('tempdb..#RCodeForHoldback') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeForHoldback
	END
	IF OBJECT_ID('tempdb..#RCodeForSynMap') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeForSynMap
	END
	IF OBJECT_ID('tempdb..#RCodeForRunDef') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeForRunDef
	END
	IF OBJECT_ID('tempdb..#RCodeGrp') IS NOT NULL
	BEGIN
		DROP TABLE #RCodeGrp
	END
	IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	BEGIN
		DROP TABLE #Result
	END
	--	IF OBJECT_ID('tempdb..##Error_Record') IS NOT NULL
	--BEGIN
	--	DROP TABLE ##Error_Record
	--END
END

/*	DECLARE @MyTable [dbo].[Rights_Bulk_Update_UDT]
	INSERT INTO @MyTable([Right_Codes],
		[Change_For],
		[Action_For],
		[Start_Date],
		[End_Date],
		[Term],
		[Milestone_Type_Code],
		[Milestone_No_Of_Unit],
		[Milestone_Unit_Type], 
		[Rights_Type],
		[Codes],
		[Is_Exclusive],
		[Is_Title_Language],
		[Is_Tentative])
	VALUES (',26487~,Y','P','D',null,null,null,null,null,null,null,'0,127,128,0,336,337,130',null,NULL,null)

	select * from @MyTable

	EXEC USP_Acq_Bulk_Update_Validation @MyTable

	*/
	----select * from Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code=7517 and Platform_Code=269
	--select * from Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code=7516


