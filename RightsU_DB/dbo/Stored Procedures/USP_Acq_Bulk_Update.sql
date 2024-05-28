﻿CREATE PROCEDURE [dbo].[USP_Acq_Bulk_Update]
(
	@Rights_Bulk_Update Rights_Bulk_Update_UDT READONLY,
	@Login_User_Code INT
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
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Bulk_Update]', 'Step 1', 0, 'Started Procedure', 0, ''
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
			IF OBJECT_ID('tempdb..#Error_Record') IS NOT NULL
		BEGIN
			DROP TABLE #Error_Record
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

		PRINT'A'
		if CHARINDEX('~',@Right_Codes) > 0
		begin
		 INSERT INTO #temp3(Is_Acq_Syn_Map)
			SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,'~') where number!=''
		end
		PRINT'B'

		IF((SELECT COUNT(*) FROM #temp3) > 1 )
		BEGIN
			   SELECT TOP 1 @isSynAcqMap = number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,'~') where number!='' ORDER BY number DESC
			   SELECT TOP 1 @Right_Codes = number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,'~') where number!='' ORDER BY number
		END
		PRINT'C'

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
			PRINT'D'
		INSERT INTO #SelectedCodeTab
		SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') where number!=''
		--if(@Codes!=NULL)
		INSERT INTO #temp1
		select a.number,b.number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')As a Inner Join  dbo.[fn_Split_withdelemiter](@Codes,',') AS b on 1=1
		where a.number!=0 AND b.number!=0
		CREATE TABLE #Error_Record
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
		PRINT'E'
		DECLARE RightCursor CURSOR FOR SELECT R_Code, Is_Acq_Syn_Map FROM #RightCodeTab
		OPEN RightCursor FETCH NEXT FROM RightCursor INTO @RCODE, @IS_SYN_ACQ_MAP
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @Deal_Rights_UDT(Deal_Rights_Code,Deal_Code,Right_Start_Date,Right_End_Date,Milestone_No_Of_Unit,Milestone_Type_Code,Milestone_Unit_Type,
			Is_Exclusive,Is_Sub_License,Is_Tentative,Is_Title_Language_Right,Right_Type,Sub_License_Code,Term) 
			select Acq_Deal_Rights_Code,Acq_Deal_Code,Right_Start_Date,Right_End_Date,Milestone_No_Of_Unit,Milestone_Type_Code,Milestone_Unit_Type,
			Is_Exclusive,Is_Sub_License,Is_Tentative,Is_Title_Language_Right,Right_Type,Sub_License_Code,Term FROM Acq_Deal_Rights (NOLOCK) where Acq_Deal_Rights_Code=@RCODE

			insert INTO @Deal_Rights_Territory_UDT(Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
			select Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code FROM Acq_Deal_Rights_Territory (NOLOCK) where Acq_Deal_Rights_Code=@RCODE

			insert Into @Deal_Rights_Subtitling_UDT(Deal_Rights_Code,Language_Group_Code,Language_Type,Subtitling_Code)
			select Acq_Deal_Rights_Code,Language_Group_Code,Language_Type,Language_Code FROM Acq_Deal_Rights_Subtitling (NOLOCK) where Acq_Deal_Rights_Code=@RCODE

			insert into @Deal_Rights_Dubbing_UDT(Deal_Rights_Code,Dubbing_Code,Language_Group_Code,Language_Type)
			select Acq_Deal_Rights_Code,Language_Code,Language_Group_Code,Language_Type FROM Acq_Deal_Rights_Dubbing (NOLOCK) where Acq_Deal_Rights_Code=@RCODE

			insert into @Deal_Rights_Platform_UDT(Deal_Rights_Code,Platform_Code)
			select Acq_Deal_Rights_Code,Platform_Code FROM Acq_Deal_Rights_Platform (NOLOCK) where Acq_Deal_Rights_Code=@RCODE

			INSERT INTO @Deal_Rights_Title_UDT(Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
			select Acq_Deal_Rights_Code,Title_Code,Episode_From,Episode_To FROM Acq_Deal_Rights_Title (NOLOCK) where Acq_Deal_Rights_Code=@RCODE

			IF(@Change_For = 'P')
			BEGIN
				select @Is_Theatrical=Is_Theatrical_Right from Acq_Deal_Rights (NOLOCK) where Acq_Deal_Rights_Code=@RCODE
				IF(@Is_Theatrical!='Y')
				BEGIN
					IF(@Action_For='A')
					BEGIN
						INSERT INTO @Deal_Rights_Platform_UDT(Deal_Rights_Code,Platform_Code) 
						select @RCODE,t.I_Code 
						from #SelectedCodeTab AS t 
						where t.I_Code NOT IN (select Platform_Code FROM @Deal_Rights_Platform_UDT)

						INSERT INTO Acq_Deal_Rights_Platform(Acq_Deal_Rights_Code,Platform_Code)
						select UD.Deal_Rights_Code,UD.Platform_Code FROM @Deal_Rights_Platform_UDT AS UD LEFT JOIN Acq_Deal_Rights_Platform AS ADRP 
						ON ADRP.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRP.Platform_Code = UD.Platform_Code 
						where isnull(ADRP.Platform_Code,0) = 0 and UD.Platform_Code!=0

						insert into #Error_Record(Rights_Code,Is_Updated)
						values(@RCODE,'Y')	
					END
					ELSE
					BEGIN

						IF (SELECT COUNT(*) FROM ( SELECT Platform_Code from Acq_Deal_Rights_Platform (NOLOCK) WHERE Acq_Deal_Rights_Code IN (@RCODE) --SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',')
						INTERSECT SELECT Platform_Code FROM Platform WHERE Is_No_Of_Run = 'Y') AS A ) = 0
						BEGIN
								DECLARE @Acq_Deal_Code INT = 0, @IsCableExistInOtherRightWithSameTitle CHAR(1) = 'Y', @Count_TC INT = 0
								DECLARE @TC_Of_CurrentRight TABLE (Title_Code INT)

								SELECT TOP 1 @Acq_Deal_Code =  Acq_Deal_Code FROM Acq_Deal_Rights (NOLOCK) WHERE Acq_Deal_Rights_Code IN (@RCODE) 

								SELECT @Count_TC = COUNT(*) FROM (
									SELECT  ADRT.Title_Code FROM Acq_Deal_Rights_Title ADRT (NOLOCK) INNER JOIN 
											Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
											WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADR.Acq_Deal_Rights_Code IN (@RCODE)
									INTERSECT
									SELECT  ADRT.Title_Code FROM Acq_Deal_Run ADR (NOLOCK) INNER JOIN 
											Acq_Deal_Run_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
											WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code

								) AS A
							
								INSERT INTO @TC_Of_CurrentRight (Title_Code)
								SELECT ADRT.Title_Code FROM Acq_Deal_Rights_Title ADRT (NOLOCK) INNER JOIN 
								Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
								WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADR.Acq_Deal_Rights_Code IN (@RCODE)

								IF (SELECT COUNT(*) FROM Acq_Deal_Rights ADR (NOLOCK) 
								INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
								INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
								INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = ADRP.Platform_Code
								WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code 
								AND  ADR.Acq_Deal_Rights_Code NOT IN (SELECT ADR.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR (NOLOCK)
								WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADR.Acq_Deal_Rights_Code IN (@RCODE))
								AND  ADRT.Title_Code IN (SELECT Title_Code FROM @TC_Of_CurrentRight)
								AND  P.Is_No_Of_Run = 'Y' ) > 0
								BEGIN
										SET @IsCableExistInOtherRightWithSameTitle = 'N';
								END

								IF(@Count_TC > 0 AND @IsCableExistInOtherRightWithSameTitle = 'Y')
								BEGIN
									INSERT INTO #RCodeForRunDef(Right_Code)
									SELECT @RCODE
								END

								--SELECT ADR.* FROM Acq_Deal_Rights ADR 
								--INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
								--INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
								--INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
								--WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code 
								--AND  ADR.Acq_Deal_Rights_Code NOT IN (SELECT ADR.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR 
								--WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADR.Acq_Deal_Rights_Code IN (@RCODE))
								--AND  ADRT.Title_Code IN (SELECT Title_Code FROM @TC_Of_CurrentRight)
								--AND  P.Is_No_Of_Run = 'Y'
						END

						DELETE FROM Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code IN(	
								select Acq_Deal_Rights_Code	from Acq_Deal_Rights_Platform AS SDRP (NOLOCK)
								where SDRP.Platform_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
								AND SDRP.Acq_Deal_Rights_Code IN(@RCODE)
								AND SDRP.Acq_Deal_Rights_Code NOT IN
								(
									select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
									Inner join Acq_Deal_Rights_Holdback_Platform HP (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HP.Acq_Deal_Rights_Holdback_Code
									where RH.Acq_Deal_Rights_Code IN(@RCODE)
									AND HP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
								)
								AND SDRP.Acq_Deal_Rights_Code NOT IN
								(
									SELECT Right_Code FROM #RCodeForRunDef
									/*
									select Distinct Adr.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR
									INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
									INNER JOIN Acq_Deal_Run_Title RunT ON ADRT.Title_Code=RunT.Title_Code
									Inner Join Acq_Deal_Rights_Platform ADRP ON  ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
									Inner JOIN [Platform] p ON ADRP.Platform_Code=p.Platform_Code
									where ADR.Acq_Deal_Rights_Code IN(@RCODE) 
									AND p.Is_No_Of_Run='Y' AND ADRP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
									*/
								
								)
								group by(SDRP.Acq_Deal_Rights_Code)
								HAVING COUNT(SDRP.Acq_Deal_Rights_Code)  > 0
							) AND Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
					
						DELETE FROM #RightCode where Right_Code IN(	
							select 
							Acq_Deal_Rights_Code
							from Acq_Deal_Rights_Platform AS SDRP (NOLOCK)
							where SDRP.Platform_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
							AND SDRP.Acq_Deal_Rights_Code IN(@RCODE)
							group by(SDRP.Acq_Deal_Rights_Code)
							HAVING COUNT(SDRP.Acq_Deal_Rights_Code)  > 0
						)
						INSERT INTO #RCodeForHoldback(Right_Code)
						select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
						Inner join Acq_Deal_Rights_Holdback_Platform HP (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HP.Acq_Deal_Rights_Holdback_Code
						Inner Join Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADRP.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
						where RH.Acq_Deal_Rights_Code IN(@RCODE) AND HP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
			
						/*
						INSERT INTO #RCodeForRunDef(Right_Code)
						select Distinct Adr.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR
						INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
						INNER JOIN Acq_Deal_Run_Title RunT ON ADRT.Title_Code=RunT.Title_Code
						Inner Join Acq_Deal_Rights_Platform ADRP ON  ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
						Inner JOIN [Platform] p ON ADRP.Platform_Code=p.Platform_Code
						where ADR.Acq_Deal_Rights_Code IN(@RCODE) 
						AND p.Is_No_Of_Run='Y' AND ADRP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
						*/
					END
				END
				ELSE
				BEGIN
					INSERT INTO #Result(Msg_Type,Right_Codes)
					Select 'It has Theatrical Rights' AS Msg_Type,Deal_Rights_Code FROM Syn_Acq_Mapping (NOLOCK) where Deal_Rights_Code = @RCODE
				END
			END
			ELSE IF(@Change_For = 'I')
			BEGIN
				select @Is_Theatrical=Is_Theatrical_Right from Acq_Deal_Rights (NOLOCK) where Acq_Deal_Rights_Code=@RCODE
				IF(@Is_Theatrical!='Y')
				BEGIN
					IF(@Action_For='A')
					BEGIN
						INSERT INTO @Deal_Rights_Territory_UDT(Deal_Rights_Code,Country_Code,Territory_Type)
						select @RCODE,t.I_Code,'I' from #SelectedCodeTab AS t where t.I_Code NOT IN (select Country_Code FROM @Deal_Rights_Territory_UDT)

						INSERT INTO Acq_Deal_Rights_Territory(Acq_Deal_Rights_Code,Country_Code,Territory_Type)
						select UD.Deal_Rights_Code,UD.Country_Code,UD.Territory_Type FROM @Deal_Rights_Territory_UDT AS UD
						LEFT JOIN Acq_Deal_Rights_Territory AS ADRT (NOLOCK) 
						ON ADRT.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRT.Country_Code = UD.Country_Code
						where isnull(ADRT.Country_Code,0) = 0 and UD.Country_Code!=0
				
					END
					ELSE
					BEGIN
						DELETE FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code IN
							(	
							select 
							Acq_Deal_Rights_Code
							from Acq_Deal_Rights_Territory AS SDRT (NOLOCK)
							where SDRT.Country_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
							AND SDRT.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRT.Acq_Deal_Rights_Code
							NOT IN(
							select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
							Inner join Acq_Deal_Rights_Holdback_Territory HT (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HT.Acq_Deal_Rights_Holdback_Code
							where RH.Acq_Deal_Rights_Code IN (@RCODE) 
							AND HT.Country_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
							)
							group by(SDRT.Acq_Deal_Rights_Code)
							HAVING COUNT(SDRT.Acq_Deal_Rights_Code)  > 0
						) AND Country_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
						DELETE FROM #RightCode where Right_Code IN
						(	
							select Acq_Deal_Rights_Code
							from Acq_Deal_Rights_Territory AS SDRT (NOLOCK)
							where SDRT.Country_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
							AND SDRT.Acq_Deal_Rights_Code IN(@RCODE)
							group by(SDRT.Acq_Deal_Rights_Code)
							HAVING COUNT(SDRT.Acq_Deal_Rights_Code)  > 0
						)
						INSERT INTO #RCodeForHoldback(Right_Code)
						select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
						Inner join Acq_Deal_Rights_Holdback_Platform HP (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HP.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Territory ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
						where RH.Acq_Deal_Rights_Code IN(@RCODE)
						AND HP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
						AND ADRT.Country_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))	
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
				select @Is_Theatrical=Is_Theatrical_Right from Acq_Deal_Rights (NOLOCK) where Acq_Deal_Rights_Code=@RCODE
				IF(@Is_Theatrical!='Y')
					BEGIN
					IF(@Action_For='A')
					BEGIN
						INSERT INTO #temp2(R_Code,CCount)
						select tmpb.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code,Count(*) AS CT from
						(
						select @RCODE AS Right_Code, TD.Country_Code FROM Territory_Details TD (NOLOCK) WHERE TD.Territory_Code 
						IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') ) 
						) as tmpA
						INNER JOIN 
						(	
						select SDT.Acq_Deal_Rights_Code,TDD.Country_Code from
						(
						select SD.Acq_Deal_Rights_Code,SD.Territory_Code  FROM Acq_Deal_Rights_Territory AS SD (NOLOCK) where Acq_Deal_Rights_Code
							IN(@RCODE)
							)AS SDT
						INNER JOIN Territory_Details AS TDD (NOLOCK) ON SDT.Territory_Code=TDD.Territory_Code
						) as tmpb on tmpA.Right_Code=tmpb.Acq_Deal_Rights_Code AND tmpA.Country_Code=tmpb.Country_Code
						group by tmpb.Acq_Deal_Rights_Code
	
						IF(EXISTS(SELECT * FROM #temp2))
						BEGIN
							INSERT INTO #RCodeGrp
							SELECT R_Code FROM #temp2 where CCount>0
							DELETE FROM #RightCodeTab
							INSERT INTO #RightCodeTab(R_Code)
							SELECT R_Code FROM #temp2 where CCount=0
						END

						INSERT INTO @Deal_Rights_Territory_UDT(Deal_Rights_Code,Territory_Code,Territory_Type)
						select @RCODE,t.I_Code,'G' from #SelectedCodeTab AS t where t.I_Code NOT IN (select Territory_Code FROM @Deal_Rights_Territory_UDT)

						INSERT INTO Acq_Deal_Rights_Territory(Acq_Deal_Rights_Code,Territory_Code,Territory_Type)
						select UD.Deal_Rights_Code,UD.Territory_Code,UD.Territory_Type FROM @Deal_Rights_Territory_UDT AS UD
						LEFT JOIN Acq_Deal_Rights_Territory AS ADRT (NOLOCK) 
						ON ADRT.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRT.Territory_Code = UD.Territory_Code
						where isnull(ADRT.Territory_Code,0) = 0
						and UD.Territory_Code!=0
					
					END
					ELSE
					BEGIN
						DELETE FROM Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code IN
							(	
								select Acq_Deal_Rights_Code
								from Acq_Deal_Rights_Territory AS SDRP (NOLOCK)
								where SDRP.Territory_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
								AND SDRP.Acq_Deal_Rights_Code IN(@RCODE)
								AND SDRP.Acq_Deal_Rights_Code NOT IN(
									select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
									Inner join Acq_Deal_Rights_Holdback_Territory HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
									Inner join Acq_Deal_Rights_Territory ADRS (NOLOCK) ON ADRS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
									INNER JOIN Territory_Details LGD (NOLOCK) ON ADRS.Territory_Code=LGD.Territory_Code
									where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
									( 
										HS.Country_Code=LGD.Country_Code
									)
								)
								group by(SDRP.Acq_Deal_Rights_Code) HAVING COUNT(SDRP.Acq_Deal_Rights_Code)  > 0
							) AND Territory_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
						DELETE FROM #RightCode where Right_Code IN
						(	
							select Acq_Deal_Rights_Code
							from Acq_Deal_Rights_Territory AS SDRP (NOLOCK)
							where SDRP.Territory_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
							AND SDRP.Acq_Deal_Rights_Code IN(@RCODE)
							group by(SDRP.Acq_Deal_Rights_Code)
							HAVING COUNT(SDRP.Acq_Deal_Rights_Code)  > 0
						) 
						INSERT INTO #RCodeForHoldback(Right_Code)
						select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
						Inner join Acq_Deal_Rights_Holdback_Territory HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
						Inner join Acq_Deal_Rights_Territory ADRS (NOLOCK) ON ADRS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
						INNER JOIN Territory_Details LGD (NOLOCK) ON ADRS.Territory_Code=LGD.Territory_Code
						where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
						( 
							HS.Country_Code=LGD.Country_Code
						) AND ADRS.Territory_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))	
					END
				END
				ELSE
				BEGIN
					INSERT INTO #Result(Msg_Type,Right_Codes)
					Select 'It has Theatrical Rights' AS Msg_Type,Deal_Rights_Code FROM Syn_Acq_Mapping (NOLOCK) where Deal_Rights_Code = @RCODE
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

					INSERT INTO Acq_Deal_Rights_Subtitling(Acq_Deal_Rights_Code,Language_Code,Language_Type)
					select UD.Deal_Rights_Code,UD.Subtitling_Code,UD.Language_Type FROM @Deal_Rights_Subtitling_UDT AS UD
					LEFT JOIN 
					Acq_Deal_Rights_Subtitling AS ADRS 
					ON ADRS.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRS.Language_Code = UD.Subtitling_Code
					where isnull(ADRS.Language_Code,0) = 0 and UD.Subtitling_Code!=0
			
				END
				ELSE
				BEGIN
					DELETE FROM Acq_Deal_Rights_Subtitling where Acq_Deal_Rights_Code IN
					(	
						SELECT SDR.Acq_Deal_Rights_Code FROM Acq_Deal_Rights SDR (NOLOCK)
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
							WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
							GROUP BY SDRS.Acq_Deal_Rights_Code 
						) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
							GROUP BY SDRD.Acq_Deal_Rights_Code 
						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						WHERE SDR.Acq_Deal_Rights_Code IN (@RCODE)
						AND
						(
							(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
						)
						AND SDR.Acq_Deal_Rights_Code NOT IN (
							select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
							Inner join Acq_Deal_Rights_Holdback_Subtitling HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
							where RH.Acq_Deal_Rights_Code IN (@RCODE)
							AND HS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
						)
					) AND Language_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					DELETE FROM #RightCode where Right_Code IN
					(	
						SELECT SDR.Acq_Deal_Rights_Code
						FROM Acq_Deal_Rights SDR
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
							WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
							GROUP BY SDRS.Acq_Deal_Rights_Code 
						) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
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
					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
					Inner join Acq_Deal_Rights_Holdback_Subtitling HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
					INNER JOIN Acq_Deal_Rights_Subtitling ADRSS (NOLOCK) ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
					where RH.Acq_Deal_Rights_Code IN (@RCODE)
					AND HS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
					AND ADRSS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
				END
			END
			ELSE IF(@Change_For = 'SG')
			BEGIN 
				IF(@Action_For='A')
				BEGIN
				INSERT INTO #temp2
				select tmpb.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code,Count(*) AS CT from
				(
					select @RCODE AS Right_Code,LGD.Language_Code FROM Language_Group_Details LGD (NOLOCK) WHERE LGD.Language_Group_Code 
					IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
				) as tmpA
				INNER JOIN 
				(	
					select SDT.Acq_Deal_Rights_Code,TDD.Language_Code from
					(
						select SD.Acq_Deal_Rights_Code,SD.Language_Group_Code  FROM Acq_Deal_Rights_Subtitling AS SD (NOLOCK) where Acq_Deal_Rights_Code IN(@RCODE)
					)AS SDT
					INNER JOIN Language_Group_Details AS TDD (NOLOCK) ON SDT.Language_Group_Code=TDD.Language_Group_Code
				) as tmpb on tmpA.Right_Code=tmpb.Acq_Deal_Rights_Code AND tmpA.Language_Code=tmpb.Language_Code
				group by tmpb.Acq_Deal_Rights_Code

				IF(EXISTS(SELECT * FROM #temp2))

				BEGIN
					INSERT INTO #RCodeGrp
					SELECT R_Code FROM #temp2 where CCount>0
					DELETE FROM #RightCodeTab
					INSERT INTO #RightCodeTab(R_Code)
					SELECT R_Code FROM #temp2 where CCount=0
				END

				INSERT INTO @Deal_Rights_Subtitling_UDT(Deal_Rights_Code,Language_Group_Code,Language_Type)
				select @RCODE,t.I_Code,'G' 
				from #SelectedCodeTab AS t 
				where t.I_Code NOT IN (select Language_Group_Code FROM @Deal_Rights_Subtitling_UDT)

				INSERT INTO Acq_Deal_Rights_Subtitling(Acq_Deal_Rights_Code,Language_Group_Code,Language_Type)
				select UD.Deal_Rights_Code,UD.Language_Group_Code,UD.Language_Type FROM @Deal_Rights_Subtitling_UDT AS UD
				LEFT JOIN 
				Acq_Deal_Rights_Subtitling AS ADRS (NOLOCK)
				ON ADRS.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRS.Language_Group_Code = UD.Language_Group_Code
				where isnull(ADRS.Language_Group_Code,0) = 0
				and UD.Language_Group_Code!=0					
			
			END
				ELSE
				BEGIN
				DELETE FROM Acq_Deal_Rights_Subtitling where Acq_Deal_Rights_Code IN
						(	
							SELECT 
								SDR.Acq_Deal_Rights_Code
							FROM Acq_Deal_Rights SDR
							LEFT JOIN 
							(	
								SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
								FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
								WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
								AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
								GROUP BY SDRS.Acq_Deal_Rights_Code 
							) AS TmpSDRS
								ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
							LEFT JOIN 
							(	
								SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
								FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
								WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
								GROUP BY SDRD.Acq_Deal_Rights_Code 

							) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
							WHERE 
							SDR.Acq_Deal_Rights_Code IN (@RCODE)
							AND
							((SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0))
								AND SDR.Acq_Deal_Rights_Code NOT IN (
								select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
							Inner join Acq_Deal_Rights_Holdback_Subtitling HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
							Inner join Acq_Deal_Rights_Subtitling ADRSS (NOLOCK) ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
							INNER JOIN Language_Group_Details LGD (NOLOCK) ON ADRSS.Language_Group_Code=LGD.Language_Group_Code
							where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
							( 
								HS.Language_Code=LGD.Language_Code))
						) AND Language_Group_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				DELETE FROM #RightCode where Right_Code IN
				(	
					SELECT SDR.Acq_Deal_Rights_Code FROM Acq_Deal_Rights SDR (NOLOCK) LEFT JOIN (SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
						WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
						AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
						GROUP BY SDRS.Acq_Deal_Rights_Code 
					) AS TmpSDRS
						ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					LEFT JOIN 			(	
						SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
						FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
						WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
						GROUP BY SDRD.Acq_Deal_Rights_Code 
					) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
					WHERE 
					SDR.Acq_Deal_Rights_Code IN (@RCODE)AND
					(
						(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
					))
				INSERT INTO #RCodeForHoldback(Right_Code)
						select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
							Inner join Acq_Deal_Rights_Holdback_Subtitling HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
							Inner join Acq_Deal_Rights_Subtitling ADRSS (NOLOCK) ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
							INNER JOIN Language_Group_Details LGD (NOLOCK) ON ADRSS.Language_Group_Code=LGD.Language_Group_Code
							where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
							( HS.Language_Code=LGD.Language_Code)AND ADRSS.Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
				END
			END
			ELSE IF(@Change_For = 'DL')
			BEGIN
				IF(@Action_For='A')
				BEGIN
					INSERT INTO @Deal_Rights_Dubbing_UDT(Deal_Rights_Code,Dubbing_Code,Language_Type)
					select @RCODE,t.I_Code,'L' FROM #SelectedCodeTab AS t where t.I_Code NOT IN( select Dubbing_Code FROM @Deal_Rights_Dubbing_UDT)

					INSERT INTO Acq_Deal_Rights_Dubbing(Acq_Deal_Rights_Code,Language_Code,Language_Type)
					select UD.Deal_Rights_Code,UD.Dubbing_Code,UD.Language_Type FROM @Deal_Rights_Dubbing_UDT AS UD
					LEFT JOIN Acq_Deal_Rights_Dubbing AS ADRD (NOLOCK)
					ON ADRD.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRD.Language_Code = UD.Dubbing_Code
					where isnull(ADRD.Language_Code,0) = 0
					and UD.Dubbing_Code!=0
			
				END
				ELSE
				BEGIN
					DELETE FROM Acq_Deal_Rights_Dubbing where Acq_Deal_Rights_Code IN
					(	
						SELECT SDR.Acq_Deal_Rights_Code
						FROM Acq_Deal_Rights SDR (NOLOCK)
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
							GROUP BY SDRD.Acq_Deal_Rights_Code 
						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
							WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
							GROUP BY SDRS.Acq_Deal_Rights_Code 
						) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						WHERE SDR.Acq_Deal_Rights_Code IN (@RCODE)
						AND
						(
							(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
						)
						AND SDR.Acq_Deal_Rights_Code NOT IN (
							select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
							Inner join Acq_Deal_Rights_Holdback_Dubbing HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
							where RH.Acq_Deal_Rights_Code IN(@RCODE) 
							AND HS.Language_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
						)

					) AND Language_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
					DELETE FROM #RightCode where Right_Code IN
					(	
						SELECT SDR.Acq_Deal_Rights_Code
						FROM Acq_Deal_Rights SDR
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
							GROUP BY SDRD.Acq_Deal_Rights_Code 
						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
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
					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
					Inner join Acq_Deal_Rights_Holdback_Dubbing HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
					Inner join Acq_Deal_Rights_Dubbing ADRS (NOLOCK) on ADRS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
					where RH.Acq_Deal_Rights_Code IN(@RCODE) 
					AND HS.Language_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))
					AND ADRS.Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ','))	
				END
			END
			ELSE IF(@Change_For = 'DG')
			BEGIN
				IF(@Action_For='A')
				BEGIN
					INSERT INTO #temp2
					select tmpb.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code,Count(*) AS CT from
					(
						SELECT @RCODE AS Right_Code,LGD.Language_Code FROM Language_Group_Details LGD (NOLOCK) WHERE LGD.Language_Group_Code 
						IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
						) as tmpA
						INNER JOIN 
						(	
							select SDT.Acq_Deal_Rights_Code,TDD.Language_Code from
							(
								select SD.Acq_Deal_Rights_Code,SD.Language_Group_Code  FROM Acq_Deal_Rights_Dubbing AS SD (NOLOCK) where Acq_Deal_Rights_Code IN(@RCODE)
							)AS SDT
							INNER JOIN Language_Group_Details AS TDD (NOLOCK) ON SDT.Language_Group_Code=TDD.Language_Group_Code
						) as tmpb on tmpA.Right_Code=tmpb.Acq_Deal_Rights_Code AND tmpA.Language_Code=tmpb.Language_Code group by tmpb.Acq_Deal_Rights_Code

					IF(EXISTS(SELECT * FROM #temp2))
					BEGIN
						INSERT INTO #RCodeGrp
						SELECT R_Code FROM #temp2 where CCount>0
						DELETE FROM #RightCodeTab
						INSERT INTO #RightCodeTab(R_Code)
						SELECT R_Code FROM #temp2 where CCount=0
					END

					INSERT INTO @Deal_Rights_Dubbing_UDT(Deal_Rights_Code,Language_Group_Code,Language_Type)
					select @RCODE,t.I_Code,'G' 
					from #SelectedCodeTab AS t 
					LEFT JOIN 
					Acq_Deal_Rights_Dubbing AS SDRP (NOLOCK)
					ON SDRP.Acq_Deal_Rights_Code = @RCODE AND SDRP.Language_Group_Code = t.I_Code
					where isnull(SDRP.Language_Group_Code,0) = 0

					INSERT INTO Acq_Deal_Rights_Dubbing(Acq_Deal_Rights_Code,Language_Group_Code,Language_Type)
					select UD.Deal_Rights_Code,UD.Language_Group_Code,UD.Language_Type FROM @Deal_Rights_Dubbing_UDT AS UD
					LEFT JOIN 
					Acq_Deal_Rights_Dubbing AS ADRD (NOLOCK)
					ON ADRD.Acq_Deal_Rights_Code = UD.Deal_Rights_Code AND ADRD.Language_Group_Code = UD.Language_Group_Code
					where isnull(ADRD.Language_Group_Code,0) = 0 and UD.Language_Group_Code!=0

					delete FROM @Deal_Rights_Dubbing_UDT
				
				END			
				ELSE
				BEGIN
					DELETE FROM Acq_Deal_Rights_Dubbing where Acq_Deal_Rights_Code IN
					(	
						SELECT SDR.Acq_Deal_Rights_Code
						FROM Acq_Deal_Rights SDR (NOLOCK)
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
							GROUP BY SDRD.Acq_Deal_Rights_Code 
						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
							WHERE SDRS.Acq_Deal_Rights_Code IN(@RCODE)
							GROUP BY SDRS.Acq_Deal_Rights_Code 
						) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						WHERE 
						SDR.Acq_Deal_Rights_Code IN (@RCODE)
						AND
						(
							(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
						)
						 AND SDR.Acq_Deal_Rights_Code NOT IN(select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
							Inner join Acq_Deal_Rights_Holdback_Dubbing HS (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
							Inner join Acq_Deal_Rights_Dubbing ADRSS (NOLOCK) ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
							INNER JOIN Language_Group_Details LGD (NOLOCK) ON ADRSS.Language_Group_Code=LGD.Language_Group_Code
							where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
							(HS.Language_Code=LGD.Language_Code)
						)) AND Language_Group_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
					DELETE FROM #RightCode where Right_Code IN
					(	
						SELECT SDR.Acq_Deal_Rights_Code
						FROM Acq_Deal_Rights SDR (NOLOCK)
						LEFT JOIN 
						(	
							SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
							WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
							AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
							GROUP BY SDRD.Acq_Deal_Rights_Code 
						) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
						LEFT JOIN 
						(	
							SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
							FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
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
					select Distinct RH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback RH (NOLOCK)
					Inner join Acq_Deal_Rights_Holdback_Dubbing HS  (NOLOCK) on RH.Acq_Deal_Rights_Holdback_Code=HS.Acq_Deal_Rights_Holdback_Code
					Inner join Acq_Deal_Rights_Dubbing ADRSS (NOLOCK) ON ADRSS.Acq_Deal_Rights_Code=RH.Acq_Deal_Rights_Code
					INNER JOIN Language_Group_Details LGD (NOLOCK) ON ADRSS.Language_Group_Code=LGD.Language_Group_Code
					where RH.Acq_Deal_Rights_Code IN (@RCODE) AND 
					( 
						HS.Language_Code=LGD.Language_Code
					) AND ADRSS.Language_Group_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
				END
			END
			-- STARTDATE AND ENDDATE
			ELSE
			BEGIN
				DeClare @DateCount INT=0
				if(@Change_For='RP')
				BEGIN
			
					IF EXISTS(SELECT * FROM Acq_Deal_Rights (NOLOCK) WHERE Acq_Deal_Rights_Code = @RCODE AND (
						Right_Start_Date != @Start_Date OR Right_End_Date != @End_Date OR Is_Tentative != @Is_Tentative
					))
					BEGIN 
						--Can not change rights period as Run Definition is already added. To change rights period, delete Run Definition first.
						--Can not change Tentative state as Run Definition is already added. To change rights period, delete Run Definition first.
						INSERT INTO #RCodeForRunDef(Right_Code)
						select DISTINCT Adr.Acq_Deal_Rights_Code FROM Acq_Deal_Rights ADR (NOLOCK)
						INNER JOIN Acq_Deal_Run ADRu (NOLOCK) ON ADR.Acq_Deal_Code=ADRu.Acq_Deal_Code
						INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
						INNER JOIN Acq_Deal_Run_Title RunT (NOLOCK) ON ADRu.Acq_Deal_Run_Code=RunT.Acq_Deal_Run_Code
						where ADR.Acq_Deal_Rights_Code IN(@RCODE)
						AND ADRu.Is_Yearwise_Definition = 'Y' AND ADRu.Run_Type!='U' 
					END		
					IF(@DateCount = 0 AND NOT EXISTS(SELECT * FROM #Result WHERE Right_Codes = @RCODE) AND NOT EXISTS(SELECT * FROM #RCodeForRunDef WHERE Right_Code = @RCODE))
					BEGIN
						UPDATE @Deal_Rights_UDT SET Right_Start_Date=@Start_Date,Right_End_Date=@End_Date,Term=@Term,Is_Tentative=@Is_Tentative,Right_Type=@Rights_Type,
						Milestone_No_Of_Unit=@Milestone_No_Of_Unit,Milestone_Type_Code=@Milestone_Type_Code,Milestone_Unit_Type=@Milestone_Unit_Type
						
						DECLARE @Enabled_Perpetuity CHAR(1)
						select @Enabled_Perpetuity=Parameter_Value from System_Parameter_New where Parameter_Name= 'Enabled_Perpetuity'
						IF(ISNULL(@Enabled_Perpetuity,'N')='N')
							BEGIN
								IF(@Original_Right_Type='Y')
									BEGIN
										UPDATE Acq_Deal_Rights SET Right_Start_Date=@Start_Date
										,Right_End_Date=@End_Date
										,Actual_Right_Start_Date=@Start_Date
										,Actual_Right_End_Date=@End_Date
										,Term=@Term
										,Is_Tentative=@Is_Tentative
										,Right_Type=@Original_Right_Type
										,Original_Right_Type=@Original_Right_Type
										,Milestone_No_Of_Unit=NULL
										,Milestone_Type_Code=NULL
										,Milestone_Unit_Type=NULL WHERE Acq_Deal_Rights_Code=@RCODE
									END
									ELSE IF(@Original_Right_Type='U')
									BEGIN
										UPDATE Acq_Deal_Rights SET Right_Start_Date=@Start_Date
										,Right_End_Date=NULL
										,Actual_Right_Start_Date=@Start_Date
										,Actual_Right_End_Date=NULL
										,Term=@Term
										,Is_Tentative=NULL
										,Right_Type=@Original_Right_Type
										,Original_Right_Type=''
										,Milestone_No_Of_Unit=NULL
										,Milestone_Type_Code=NULL
										,Milestone_Unit_Type=NULL
										,Is_ROFR='N'
										,ROFR_Date=NULL WHERE Acq_Deal_Rights_Code=@RCODE
									END
							END
							ELSE IF((@Original_Right_Type = 'Y' OR @Original_Right_Type = 'U')AND @Enabled_Perpetuity='Y')
							BEGIN
								UPDATE Acq_Deal_Rights SET 
								Right_Start_Date = @Start_Date,
								Right_End_Date = @End_Date,
								Actual_Right_Start_Date = @Start_Date,
								Actual_Right_End_Date = @End_Date,
								Effective_Start_Date = @Start_Date,
								Term = @Term,
								Is_Tentative = @Is_Tentative,
								Right_Type = @Rights_Type,
								Original_Right_Type = @Original_Right_Type,
								Milestone_No_Of_Unit = NULL,
								Milestone_Type_Code = NULL,
								Milestone_Unit_Type = NULL,
								Is_ROFR = CASE WHEN @Original_Right_Type = 'U' THEN 'N' ELSE Is_ROFR END,
								ROFR_Date = CASE WHEN @Original_Right_Type = 'U' THEN NULL ELSE ROFR_Date END
								WHERE Acq_Deal_Rights_Code = @RCODE
							END
							ELSE
							BEGIN
								DECLARE @Is_Ten VARCHAR(2), @ExistingType VARCHAR(2)
								SELECT @Is_Ten = Is_Tentative, @ExistingType = Right_Type FROM Acq_Deal_Rights (NOLOCK) WHERE Acq_Deal_Rights_Code = @RCODE

								IF(@Is_Ten = 'Y' OR @Is_Ten = '' OR @Is_Ten IS NULL)
									SET @Is_Tentative = 'Y'
								ELSE
									SET @Is_Tentative = 'N'

								IF(@Rights_Type = @ExistingType AND @Is_Ten = 'N')
								BEGIN
									INSERT INTO #Result(Msg_Type,Right_Codes)
									SELECT 'Milestone is already set' AS Msg_Type, @RCODE
								END
								ELSE
								BEGIN
									UPDATE Acq_Deal_Rights SET 
									Actual_Right_Start_Date = @Start_Date,
									Actual_Right_End_Date = @End_Date,
									Term = NULL,
									Is_Tentative = 'Y',
									Right_Start_Date = NULL,
									Right_End_Date = NULL,
									Right_Type = @Rights_Type,
									Original_Right_Type = @Original_Right_Type,
									Milestone_No_Of_Unit = @Milestone_No_Of_Unit,
									Milestone_Type_Code = @Milestone_Type_Code,
									Milestone_Unit_Type = @Milestone_Unit_Type 
									WHERE Acq_Deal_Rights_Code=@RCODE
								END														
							END				
					END
				END
				ELSE IF(@Change_For='TL')
				BEGIN
					IF(@Is_Title_Language='N')
					BEGIN
						UPDATE Acq_Deal_Rights SET  Is_Title_Language_Right=@Is_Title_Language WHERE Acq_Deal_Rights_Code IN 
								(
									SELECT SDR.Acq_Deal_Rights_Code	FROM Acq_Deal_Rights SDR
									LEFT JOIN 
									(	
										SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code 
										FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
										WHERE SDRD.Acq_Deal_Rights_Code=@RCODE
										GROUP BY SDRD.Acq_Deal_Rights_Code 
									) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
									LEFT JOIN 
									(	
										SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
										FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
										WHERE SDRS.Acq_Deal_Rights_Code=@RCODE
										GROUP BY SDRS.Acq_Deal_Rights_Code 
									) AS TmpSDRS ON TmpSDRS.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code	WHERE TmpSDRD.Dubb_Count > 0 OR TmpSDRS.Subb_Count > 0
								)
								AND	Acq_Deal_Rights_Code NOT IN 
								(
									select DISTINCT ADRH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback ADRH (NOLOCK) where ADRH.Is_Title_Language_Right='Y'
								)

						INSERT INTO #RCodeForHoldback(Right_Code)
						select DISTINCT ADRH.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Holdback ADRH (NOLOCK)
						where ADRH.Is_Title_Language_Right='Y' AND ADRH.Acq_Deal_Rights_Code=@RCODE

						DELETE FROM #RightCode where Right_Code IN
						(
							SELECT SDR.Acq_Deal_Rights_Code	FROM Acq_Deal_Rights SDR
							LEFT JOIN 
							(	
								SELECT COUNT(*) Dubb_Count,SDRD.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Dubbing SDRD (NOLOCK)
								WHERE SDRD.Acq_Deal_Rights_Code IN(@RCODE)
								GROUP BY SDRD.Acq_Deal_Rights_Code 
							) AS TmpSDRD ON TmpSDRD.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
							LEFT JOIN 
							(	
								SELECT COUNT(*) Subb_Count,SDRS.Acq_Deal_Rights_Code 
								FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK)
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
						UPDATE Acq_Deal_Rights SET Is_Title_Language_Right=@Is_Title_Language WHERE Acq_Deal_Rights_Code=@RCODE
					END
				END
				ELSE IF(@Change_For='E')
				BEGIN
					UPDATE @Deal_Rights_UDT SET  Is_Exclusive=@Is_Exclusive 
				
					IF(@Is_Exclusive='N')
					BEGIN
						UPDATE Acq_Deal_Rights SET Is_Exclusive=@Is_Exclusive WHERE Acq_Deal_Rights_Code=@RCODE
					END
					ELSE
					BEGIN
						UPDATE Acq_Deal_Rights SET Is_Exclusive=@Is_Exclusive WHERE Acq_Deal_Rights_Code=@RCODE
					END
				
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

					IF(@Codes='0'OR @Codes='-1')
					BEGIN
						UPDATE Acq_Deal_Rights SET  Is_Sub_License='N',Sub_License_Code=NULL WHERE Acq_Deal_Rights_Code = @RCODE	
					END
					ELSE
					BEGIN
							UPDATE Acq_Deal_Rights SET  Is_Sub_License='Y',Sub_License_Code=@Codes WHERE Acq_Deal_Rights_Code IN (@RCODE)
					END
				END
			END
			UPDATE Acq_Deal_Rights SET Last_Updated_Time=GETDATE(),Last_Action_By=@Login_User_Code WHERE Acq_Deal_Rights_Code IN (@RCODE)
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

		Select * from #Error_Record

		IF OBJECT_ID('tempdb..#temp') IS NOT NULL
			DROP TABLE #temp
		IF OBJECT_ID('tempdb..#temp1') IS NOT NULL
			DROP TABLE #temp1
		IF OBJECT_ID('tempdb..#temp2') IS NOT NULL
			DROP TABLE #temp2
		IF OBJECT_ID('tempdb..#RightCode') IS NOT NULL
			DROP TABLE #RightCode
		IF OBJECT_ID('tempdb..#RightCodeTab') IS NOT NULL
			DROP TABLE #RightCodeTab
		IF OBJECT_ID('tempdb..#RCodeForHoldback') IS NOT NULL
			DROP TABLE #RCodeForHoldback
		IF OBJECT_ID('tempdb..#RCodeForSynMap') IS NOT NULL
			DROP TABLE #RCodeForSynMap
		IF OBJECT_ID('tempdb..#RCodeForRunDef') IS NOT NULL
			DROP TABLE #RCodeForRunDef
		IF OBJECT_ID('tempdb..#RCodeGrp') IS NOT NULL
			DROP TABLE #RCodeGrp
		IF OBJECT_ID('tempdb..#Result') IS NOT NULL
			DROP TABLE #Result
		IF OBJECT_ID('tempdb..#Error_Record') IS NOT NULL
			DROP TABLE #Error_Record
		IF OBJECT_ID('tempdb..#SelectedCodeTab') IS NOT NULL
			DROP TABLE #SelectedCodeTab
		IF OBJECT_ID('tempdb..#temp3') IS NOT NULL
			DROP TABLE #temp3
	


	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Bulk_Update]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
