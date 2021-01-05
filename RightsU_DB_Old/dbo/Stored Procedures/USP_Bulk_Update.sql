--DECLARE @MyTable [dbo].[Rights_Bulk_Update_UDT]
--	INSERT INTO @MyTable([Right_Codes],
--		[Change_For],
--		[Action_For],
--		[Start_Date],
--		[End_Date],
--		[Term],
--		[Milestone_Type_Code],
--		[Milestone_No_Of_Unit],
--		[Milestone_Unit_Type], 
--		[Rights_Type],
--		[Codes],
--		[Is_Exclusive],
--		[Is_Title_Language],
--		[Is_Tentative])
--	VALUES (',6626','P','D',NULL,null,null,null,null,null,NULL,'0,0,56,57,58,59,60,61,62,63,259,0,0,121,122,123,124,125,126,127,128,129,130,0,131,132,133,134,135,136,137,138,139,140,0,141,142,143,144,145,146,147,148,149,150,0,67,68,0,69,270,271,272,273,274
--,0,0,0,151,152,153,154,155,156,157,158,159,160,0,161,162,163,164,165,166,167,168,169,170,0,171,172,173,174,175,176,177,178,179,180,0,73,74,75,76,77,78,79,80,260,0,0,181,182,183,184,185,186,187,188,189,190,0,191,192,193,194,195,196,197,198,199,200,0,201,20
--2,203,204,205,206,207,208,209,210,0,211,212,213,214,215,216,217,218,219,220,0,221,222,223,224,225,226,227,228,229,230,0,86,87,88,89,90,261,0,21,22',null,null,NULL)
--	EXEC USP_Bulk_Update @MyTable

CREATE PROCEDURE [dbo].[USP_Bulk_Update]
(
	@Rights_Bulk_Update Rights_Bulk_Update_UDT READONLY,
	@Login_User_Code INT
)
AS
-- =============================================
-- Author:	Anchal Sikarwar
-- Create DATE: 09-Oct-2016
-- Description:	Acquisition Deal Rights Bulk Update
-- Updated by :
-- Date :
-- Reason:
-- =============================================
BEGIN
	Create TABLE #temp1(R_Code INT,I_Code INT);
	Create TABLE #temp2(R_Code INT,CCount INT);
	Create TABLE #RightCode(Right_Code INT);
	Create TABLE #RCodeForRunDef(Right_Code INT);
	Create TABLE #RCodeForHB(Right_Code INT);
	Create TABLE #RCodeForRunPlatform(Right_Code INT);
	
	Create TABLE #FinalErrorResult(R_Codes INT,ErrorType VARCHAR(5))
	
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
	
	DECLARE @rcount INT=0
	DECLARE @Right_Codes VARCHAR(MAX), @Codes VARCHAR(MAX), @Code INT, @Change_For CHAR(2), @Action_For CHAR(1), @Right_Code INT, @Rights_Type CHAR(1),
	@Original_Right_Type CHAR(1), @Start_Date DATE, @Milestone_Unit_Type VARCHAR (10), @End_Date DATE, @Term VARCHAR (10), @Milestone_Type_Code VARCHAR (10), 
	@Is_Tentative CHAR (1), @Milestone_No_Of_Unit VARCHAR (10) , @Is_Exclusive VARCHAR (5) , @Is_Title_Language VARCHAR (5), @Is_Sublicensing CHAR (1)	

	SELECT 
	@Right_Codes = [Right_Codes], 
	@Change_For = [Change_For],
	@Action_For = [Action_For], 
	@Start_Date = [Start_Date], 
	@End_Date = [End_Date], 
	@Term = [Term], 
	--[Milestone_Type_Code], [Milestone_No_Of_Unit], [Milestone_Unit_Type], 
	@Original_Right_Type = [Rights_Type], 
	@Rights_Type = CASE WHEN [Rights_Type] = 'U' THEN 'Y' ELSE [Rights_Type] END,
	@Codes = [Codes], 
	@Is_Exclusive = [Is_Exclusive], 
	@Is_Title_Language = [Is_Title_Language], 
	@Is_Tentative = [Is_Tentative] 
	FROM @Rights_Bulk_Update

	INSERT INTO #RightCode
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!=''

	INSERT INTO #temp1
	select a.number,b.number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')As a Inner Join  dbo.[fn_Split_withdelemiter](@Codes,',') AS b on 1=1
	where a.number!=0 AND b.number!=0

	IF(@Change_For = 'P')
	BEGIN
		IF(@Action_For='A')
		BEGIN
			INSERT INTO Syn_Deal_Rights_Platform(Syn_Deal_Rights_Code, Platform_Code) 
			select t.R_Code,t.I_Code 
			from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Platform AS SDRP 
			ON SDRP.Syn_Deal_Rights_Code = t.R_Code AND SDRP.Platform_Code = t.I_Code
			where isnull(SDRP.Platform_Code,0) = 0
		END
		ELSE
		BEGIN
			DECLARE @RCODE INT
			DECLARE RightCursor CURSOR FOR SELECT Right_Code FROM #RightCode
			OPEN RightCursor
			FETCH NEXT FROM RightCursor
			INTO @RCODE
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO #RCodeForRunPlatform(Right_Code)
				select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR
				inner join Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code=SDRT.Syn_Deal_Rights_Code
				INNER JOIN Syn_Deal_Run RunT ON SDRT.Title_Code=RunT.Title_Code
				Inner Join Syn_Deal_Rights_Platform SDRP ON  SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code 
				Inner JOIN [Platform] p ON SDRP.Platform_Code=p.Platform_Code
				where SDR.Syn_Deal_Rights_Code IN(@RCODE) 
				AND p.Is_No_Of_Run='Y' AND SDRP.Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

				INSERT INTO #RCodeForHB(Right_Code)
				select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
				inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
				inner join Syn_Deal_Rights_Holdback_Platform SDRHP ON SDRHP.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
				where SDRH.Syn_Deal_Rights_Code=@RCODE AND SDRHP.Platform_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
			FETCH NEXT FROM RightCursor
			INTO @RCODE
			END
			CLOSE RightCursor
			DEALLOCATE RightCursor
			--select * from #RCodeForRunPlatform
			DELETE from Syn_Deal_Rights_Platform where Syn_Deal_Rights_Code IN
			(	
				select 
				Syn_Deal_Rights_Code
				from Syn_Deal_Rights_Platform AS SDRP
				where SDRP.Platform_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				AND SDRP.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				group by(SDRP.Syn_Deal_Rights_Code)
				HAVING COUNT(SDRP.Syn_Deal_Rights_Code)  > 0
			) AND Platform_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForRunPlatform)
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForHB)

			DELETE from #RightCode where Right_Code IN
			(	
				select 
				Syn_Deal_Rights_Code
				from Syn_Deal_Rights_Platform AS SDRP
				where SDRP.Platform_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				AND SDRP.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				group by(SDRP.Syn_Deal_Rights_Code)
				HAVING COUNT(SDRP.Syn_Deal_Rights_Code)  > 0
			)
		END
	END
	ELSE IF(@Change_For = 'I')
	BEGIN
		IF(@Action_For='A')
		BEGIN
			INSERT INTO Syn_Deal_Rights_Territory(Syn_Deal_Rights_Code,Country_Code,Territory_Type) 
			select t.R_Code,t.I_Code,'I'
			from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Territory AS SDRT 
			ON SDRT.Syn_Deal_Rights_Code = t.R_Code AND SDRT.Country_Code = t.I_Code
			where isnull(SDRT.Country_Code,0) = 0
		END
		ELSE
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
			inner join Syn_Deal_Rights_Holdback_Territory SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
			where SDRH.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')) 
			AND SDRHT.Country_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

			DELETE from Syn_Deal_Rights_Territory where Syn_Deal_Rights_Code IN
			(	
				select 
				Syn_Deal_Rights_Code
				from Syn_Deal_Rights_Territory AS SDRT
				where SDRT.Country_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				AND SDRT.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				group by(SDRT.Syn_Deal_Rights_Code)
				HAVING COUNT(SDRT.Syn_Deal_Rights_Code)  > 0
			) AND Country_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 

			DELETE from #RightCode where Right_Code IN
			(	
				select 
				Syn_Deal_Rights_Code
				from Syn_Deal_Rights_Territory AS SDRT
				where SDRT.Country_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				AND SDRT.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				group by(SDRT.Syn_Deal_Rights_Code)
				HAVING COUNT(SDRT.Syn_Deal_Rights_Code)  > 0
			)
		END
	END
	ELSE IF(@Change_For = 'T')
	BEGIN 
		IF(@Action_For='A')
		BEGIN
			INSERT INTO #temp2
			select tmpb.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code,Count(*) AS CT from
			(
			select a.number AS Right_Code,b.Country_Code FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')As a INNER JOIN
			(SELECT TD.Country_Code FROM Territory_Details TD WHERE TD.Territory_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') )) 
			AS b ON 1=1	where a.number!=0
			) as tmpA
			inner join 
			(	
				select SDT.Syn_Deal_Rights_Code,TDD.Country_Code from
				(
					select SD.Syn_Deal_Rights_Code,SD.Territory_Code  from Syn_Deal_Rights_Territory AS SD where Syn_Deal_Rights_Code
					IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				)AS SDT
				inner join Territory_Details AS TDD ON SDT.Territory_Code=TDD.Territory_Code
			) as tmpb on tmpA.Right_Code=tmpb.Syn_Deal_Rights_Code AND tmpA.Country_Code=tmpb.Country_Code
			group by tmpb.Syn_Deal_Rights_Code

			INSERT INTO Syn_Deal_Rights_Territory(Syn_Deal_Rights_Code,Territory_Code,Territory_Type) 
			select t.R_Code,t.I_Code,'G'
			from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Territory AS SDRT 
			ON SDRT.Syn_Deal_Rights_Code = t.R_Code AND SDRT.Territory_Code = t.I_Code
			where isnull(SDRT.Territory_Code,0) = 0 AND t.R_Code NOT IN(select R_Code from #temp2 where CCount>1)
		END
		ELSE
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Territory SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
			inner join Territory_Details TD ON TD.Territory_Code=SDRT.Territory_Code
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code 
			inner join Syn_Deal_Rights_Holdback_Territory SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
			where SDRH.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')) 
			AND SDRHT.Country_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) AND SDRHT.Country_Code=TD.Country_Code

			DELETE from Syn_Deal_Rights_Territory where Syn_Deal_Rights_Code IN
			(	
				select 
				Syn_Deal_Rights_Code
				from Syn_Deal_Rights_Territory AS SDRP
				where SDRP.Territory_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				AND SDRP.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				group by(SDRP.Syn_Deal_Rights_Code)
				HAVING COUNT(SDRP.Syn_Deal_Rights_Code)  > 0
			) AND Territory_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForHB)

			DELETE from #RightCode where Right_Code IN
			(	
				select 
				Syn_Deal_Rights_Code
				from Syn_Deal_Rights_Territory AS SDRP
				where SDRP.Territory_Code NOT IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
				AND SDRP.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				group by(SDRP.Syn_Deal_Rights_Code)
				HAVING COUNT(SDRP.Syn_Deal_Rights_Code)  > 0
			) 
		END
	END
	ELSE IF(@Change_For = 'SL')
	BEGIN 
		IF(@Action_For='A')
		BEGIN
			INSERT INTO Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code,Language_Code,Language_Type) 
			select t.R_Code,t.I_Code,'L'
			from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Subtitling AS SDRS 
			ON SDRS.Syn_Deal_Rights_Code = t.R_Code AND SDRS.Language_Code = t.I_Code
			where isnull(SDRS.Language_Code,0) = 0
		END
		ELSE
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code 
			inner join Syn_Deal_Rights_Holdback_Subtitling SDRHS ON SDRHS.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
			where SDRH.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')) 
			AND SDRHS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

			DELETE from Syn_Deal_Rights_Subtitling where Syn_Deal_Rights_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE 
				SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			) AND Language_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForHB)

			DELETE from #RightCode where Right_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE 
				SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			)
		END
	END
	--Sub-Titling Language Group
	ELSE IF(@Change_For = 'SG')
	BEGIN 
		IF(@Action_For='A')
		BEGIN
			INSERT INTO #temp2
			select tmpb.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code,Count(*) AS CT from
			(
				select a.number AS Right_Code,b.Language_Code FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')As a INNER JOIN
				(SELECT LGD.Language_Code FROM Language_Group_Details LGD WHERE LGD.Language_Group_Code
					IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') )) 
					AS b ON 1=1 where a.number!=0
			) as tmpA
			inner join 
			(	
				select SDT.Syn_Deal_Rights_Code,TDD.Language_Code from
				(
					select SD.Syn_Deal_Rights_Code,SD.Language_Group_Code  from Syn_Deal_Rights_Subtitling AS SD where Syn_Deal_Rights_Code
					IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				)AS SDT
				inner join Language_Group_Details AS TDD ON SDT.Language_Group_Code=TDD.Language_Group_Code
			) as tmpb on tmpA.Right_Code=tmpb.Syn_Deal_Rights_Code AND tmpA.Language_Code=tmpb.Language_Code
			group by tmpb.Syn_Deal_Rights_Code

			INSERT INTO Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code,Language_Group_Code,Language_Type) 
			select t.R_Code,t.I_Code,'G'
			from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Subtitling AS SDRS 
			ON SDRS.Syn_Deal_Rights_Code = t.R_Code AND SDRS.Language_Group_Code = t.I_Code
			where isnull(SDRS.Language_Group_Code,0) = 0 AND t.R_Code NOT IN(select R_Code from #temp2 where CCount>1)
		END
		ELSE
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Subtitling SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
			inner join Language_Group_Details TD ON TD.Language_Group_Code=SDRT.Language_Group_Code
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code 
			inner join Syn_Deal_Rights_Holdback_Subtitling SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
			where SDRH.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')) 
			AND SDRHT.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) AND SDRHT.Language_Code=TD.Language_Code

			DELETE from Syn_Deal_Rights_Subtitling where Syn_Deal_Rights_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE 
				SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			) AND Language_Group_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 

			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForHB)

			DELETE from #RightCode where Right_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRS.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			) 
		END
	END
	--Dubbing Language
	ELSE IF(@Change_For = 'DL')
	BEGIN
		IF(@Action_For='A')
		BEGIN
			INSERT INTO Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code,Language_Code,Language_Type) 
			select t.R_Code,t.I_Code,'L' from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Dubbing AS SDRS 
			ON SDRS.Syn_Deal_Rights_Code = t.R_Code AND SDRS.Language_Code = t.I_Code
			where isnull(SDRS.Language_Code,0) = 0 OR  (isnull(SDRS.Language_Code,0) = 1 AND isnull(SDRS.Syn_Deal_Rights_Code,0) = 1)
		END
		ELSE
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code 
			inner join Syn_Deal_Rights_Holdback_Dubbing SDRHS ON SDRHS.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
			where SDRH.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')) 
			AND SDRHS.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,','))

			DELETE from Syn_Deal_Rights_Dubbing where Syn_Deal_Rights_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			) AND Language_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForHB)
			DELETE from #RightCode where Right_Code IN
			(	
				SELECT 	SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			)
		END
	END
	--Dubbing Language Group
	ELSE IF(@Change_For = 'DG')
	BEGIN
		IF(@Action_For='A')
		BEGIN
			INSERT INTO #temp2
			select tmpb.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code,Count(*) AS CT from
			(
				select a.number AS Right_Code,b.Language_Code FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')As a INNER JOIN
				(SELECT LGD.Language_Code FROM Language_Group_Details LGD WHERE LGD.Language_Group_Code 
				IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes,',') )) 
				AS b ON 1=1	where a.number!=0
				) as tmpA
				inner join 
				(	
				select SDT.Syn_Deal_Rights_Code,TDD.Language_Code from
				(
					select SD.Syn_Deal_Rights_Code,SD.Language_Group_Code  from Syn_Deal_Rights_Dubbing AS SD where Syn_Deal_Rights_Code
					IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,','))
				)AS SDT
				inner join Language_Group_Details AS TDD ON SDT.Language_Group_Code=TDD.Language_Group_Code
			) as tmpb on tmpA.Right_Code=tmpb.Syn_Deal_Rights_Code AND tmpA.Language_Code=tmpb.Language_Code group by tmpb.Syn_Deal_Rights_Code

			INSERT INTO Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code,Language_Group_Code,Language_Type) 
			select t.R_Code,t.I_Code,'G'
			from #temp1 AS t 
			LEFT JOIN 
			Syn_Deal_Rights_Dubbing AS SDRS 
			ON SDRS.Syn_Deal_Rights_Code = t.R_Code AND SDRS.Language_Group_Code = t.I_Code
			where isnull(SDRS.Language_Group_Code,0) = 0  AND t.R_Code NOT IN(select R_Code from #temp2 where CCount>1)
		END
		ELSE
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Dubbing SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
			inner join Language_Group_Details TD ON TD.Language_Group_Code=SDRT.Language_Group_Code
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code 
			inner join Syn_Deal_Rights_Holdback_Dubbing SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code=SDRH.Syn_Deal_Rights_Holdback_Code 
			where SDRH.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',')) 
			AND SDRHT.Language_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) AND SDRHT.Language_Code=TD.Language_Code

			DELETE from Syn_Deal_Rights_Dubbing where Syn_Deal_Rights_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			) AND Language_Group_Code IN (select number FROM dbo.[fn_Split_withdelemiter](@Codes,',')) 
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForHB)

			DELETE from #RightCode where Right_Code IN
			(	
				SELECT SDR.Syn_Deal_Rights_Code
				FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					AND SDRD.Language_Code NOT IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Codes, ',')) 
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE 
				SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(SDR.Is_Title_Language_Right = 'Y') OR (TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			)
		END
	END
	-- STARTDATE AND ENDDATE
	ELSE IF(@Change_For = 'RP')
	BEGIN
	
		DECLARE @R_CODE INT
		DECLARE RightCursor CURSOR FOR SELECT Right_Code FROM #RightCode
		OPEN RightCursor
		FETCH NEXT FROM RightCursor
		INTO @R_CODE
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if(EXISTS(select * from Syn_Deal_Rights where Syn_Deal_Rights_Code=@R_CODE AND (Right_Start_Date!=@Start_Date OR Right_End_Date != @End_Date 
			OR Is_Tentative!=@Is_Tentative)))
			BEGIN
			--Can not change rights period as Run Definition is already added. To change rights period, delete Run Definition first.
			--Can not change Tentative state as Run Definition is already added. To change rights period, delete Run Definition first.
				INSERT INTO #RCodeForRunDef(Right_Code)
				select DISTINCT SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR
				inner join Syn_Deal_Run SDRu ON SDR.Syn_Deal_Code=SDRu.Syn_Deal_Code
				inner join Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code=SDRT.Syn_Deal_Rights_Code AND SDRT.Title_Code=SDRu.Title_Code
				where SDR.Syn_Deal_Rights_Code IN(@R_CODE)
				AND SDRu.Is_Yearwise_Definition = 'Y' AND SDRu.Run_Type!='U'
			END
			FETCH NEXT FROM RightCursor
			INTO @R_CODE
		END
		CLOSE RightCursor
		DEALLOCATE RightCursor
		DECLARE @Enabled_Perpetuity CHAR(1)
		SELECT @Enabled_Perpetuity=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name= 'Enabled_Perpetuity'
		IF(ISNULL(@Enabled_Perpetuity,'N')='Y')
		BEGIN
			UPDATE Syn_Deal_Rights SET 
			Right_Start_Date = @Start_Date,
			Right_End_Date = CASE WHEN @Is_Tentative = 'Y' AND @Original_Right_Type = 'Y' THEN NULL ELSE  @End_Date END,
			Actual_Right_Start_Date = @Start_Date,
			Actual_Right_End_Date = CASE WHEN @Is_Tentative = 'Y' AND @Original_Right_Type = 'Y' THEN NULL ELSE  @End_Date END,
			Effective_Start_Date = @Start_Date,
			Is_Tentative = @Is_Tentative,
			Right_Type = @Rights_Type,
			Original_Right_Type = @Original_Right_Type,
			Term = @Term ,
			Is_ROFR = CASE @Original_Right_Type WHEN 'U' THEN 'N' ELSE Is_ROFR END,
			ROFR_Date = CASE @Original_Right_Type WHEN 'U' THEN NULL ELSE ROFR_Date END
			WHERE Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') where number!='')
			AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForRunDef)
		END
		ELSE
		BEGIN
			if(@Is_Tentative='N' AND @Original_Right_Type='Y')
			BEGIN
				UPDATE Syn_Deal_Rights SET 
				Right_Start_Date=@Start_Date,
				Right_End_Date=@End_Date,
				Actual_Right_Start_Date=@Start_Date,
				Actual_Right_End_Date=@End_Date,
				Effective_Start_Date=@Start_Date,
				Is_Tentative=@Is_Tentative,
				Right_Type=@Original_Right_Type,
				Term=@Term 
				WHERE Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
				AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForRunDef)
			END
			ELSE IF( @Original_Right_Type='U')
			BEGIN
				UPDATE Syn_Deal_Rights SET 
				Right_Start_Date=@Start_Date,
				Right_End_Date=NULL,
				Actual_Right_Start_Date=@Start_Date,
				Actual_Right_End_Date=NULL,
				Effective_Start_Date=@Start_Date,
				Is_Tentative=NULL,
				Right_Type=@Original_Right_Type,
				Term=@Term ,
				Is_ROFR='N',
				ROFR_Date=NULL
				WHERE Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
				AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForRunDef)
			END
			ELSE
			BEGIN
				UPDATE Syn_Deal_Rights SET 
				Right_Start_Date=@Start_Date,
				Right_End_Date=NULL,
				Actual_Right_Start_Date=@Start_Date,
				Actual_Right_End_Date=NULL,
				Effective_Start_Date=@Start_Date,
				Is_Tentative=@Is_Tentative,
				Right_Type=@Original_Right_Type,
				Term=@Term 
				WHERE Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
				AND Syn_Deal_Rights_Code NOT IN(select Right_Code from #RCodeForRunDef)
			END
		END



	END
	-- Title Language
	ELSE IF(@Change_For = 'TL')
	BEGIN
		IF(@Is_Title_Language='N')
		BEGIN
			INSERT INTO #RCodeForHB(Right_Code)
			select Distinct SDR.Syn_Deal_Rights_Code FROM Syn_Deal_Rights SDR 
			inner join Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
			where SDRH.Syn_Deal_Rights_Code=@RCODE AND SDRH.Is_Original_Language='Y'

			UPDATE Syn_Deal_Rights SET  Is_Title_Language_Right=@Is_Title_Language WHERE Syn_Deal_Rights_Code IN (
				SELECT SDR.Syn_Deal_Rights_Code	FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE 
				SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			) AND  Syn_Deal_Rights_Code NOT IN (select Right_Code from #RCodeForHB)

			DELETE from #RightCode where Right_Code IN
			(
				SELECT SDR.Syn_Deal_Rights_Code	FROM Syn_Deal_Rights SDR
				LEFT JOIN 
				(	
					SELECT COUNT(*) Dubb_Count,SDRD.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Dubbing SDRD
					WHERE SDRD.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRD.Syn_Deal_Rights_Code 
				) AS TmpSDRD
					ON TmpSDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				LEFT JOIN 
				(	
					SELECT COUNT(*) Subb_Count,SDRS.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights_Subtitling SDRS
					WHERE SDRS.Syn_Deal_Rights_Code IN(select number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
					GROUP BY SDRS.Syn_Deal_Rights_Code 
				) AS TmpSDRS ON TmpSDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE 
				SDR.Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes, ','))
				AND
				(
					(TmpSDRD.Dubb_Count > 0) OR (TmpSDRS.Subb_Count > 0)
				)
			)

		END
		ELSE
		BEGIN
		UPDATE Syn_Deal_Rights SET  Is_Title_Language_Right=@Is_Title_Language WHERE Syn_Deal_Rights_Code IN 
		(SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
		END
	END
	-- Start Exclusive
	ELSE IF(@Change_For = 'E')
	BEGIN
		UPDATE Syn_Deal_Rights SET  Is_Exclusive=@Is_Exclusive WHERE Syn_Deal_Rights_Code IN 
		(SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
	END
	--Sublicencing
	ELSE IF(@Change_For = 'S')
	BEGIN
		if(@Codes='0' OR @Codes='-1')
		BEGIN
			UPDATE Syn_Deal_Rights SET  Is_Sub_License='N',Sub_License_Code=NULL WHERE Syn_Deal_Rights_Code IN 
			(SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
		END
		ELSE
		BEGIN
			UPDATE Syn_Deal_Rights SET  Is_Sub_License='Y',Sub_License_Code=@Codes WHERE Syn_Deal_Rights_Code IN 
			(SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')
		END
	END

	UPDATE Syn_Deal_Rights SET  Right_Status='P',Last_Updated_Time=GETDATE(),Last_Action_By=@Login_User_Code WHERE Syn_Deal_Rights_Code IN (SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!='')

	IF((@Change_For='P' OR @Change_For = 'I' OR @Change_For='T' OR @Change_For='SL' OR @Change_For='SG' OR @Change_For='DL' OR @Change_For='DG') AND @Action_For='D' OR (@Change_For='TL' AND @Is_Title_Language='N'))
	BEGIN
		INSERT INTO #FinalErrorResult(R_Codes,ErrorType)
		--SELECT Stuff((SELECT ', ' + Cast(rc.Right_Code AS VARCHAR(MAX))	FROM #RightCode rc FOR XML PATH('')), 1, 2, '') AS R_Codes,''
		SELECT Right_Code,'' FROM #RightCode 
	END
	 IF((@Change_For='T' OR @Change_For='SG' OR @Change_For='DG') AND @Action_For='A')
	BEGIN
		INSERT INTO #FinalErrorResult(R_Codes,ErrorType)
		--SELECT Stuff((SELECT ', ' + Cast(rc.R_Code AS VARCHAR(MAX))	FROM #temp2 rc where rc.CCount>1 FOR XML PATH('')), 1, 2, '') AS R_Codes,''
		SELECT R_Code,'' FROM #temp2
	END
	 IF(EXISTS(select * from #RCodeForRunDef))
	BEGIN
		INSERT INTO #FinalErrorResult(R_Codes,ErrorType)
		--SELECT Stuff((SELECT ', ' + Cast(rc.Right_Code AS VARCHAR(MAX))	FROM #RCodeForRunDef rc FOR XML PATH('')), 1, 2, '') AS R_Codes,'RD'
		SELECT Right_Code,'RD' FROM #RCodeForRunDef
	END 
	 IF(EXISTS(select * from #RCodeForRunPlatform))
	BEGIN
	--print 'AA'
		INSERT INTO #FinalErrorResult(R_Codes,ErrorType)
		--SELECT Stuff((SELECT ', ' + Cast(rc.Right_Code AS VARCHAR(MAX))	FROM #RCodeForRunPlatform rc FOR XML PATH('')), 1, 2, '') AS R_Codes,'RDP'
		SELECT Right_Code,'RDP' FROM #RCodeForRunPlatform
	END
	 IF(EXISTS(select * from #RCodeForHB))
	BEGIN
		INSERT INTO #FinalErrorResult(R_Codes,ErrorType)
		--SELECT Stuff((SELECT ', ' + Cast(rc.Right_Code AS VARCHAR(MAX))	FROM #RCodeForHB rc FOR XML PATH('')), 1, 2, '') AS R_Codes,'HB'
		SELECT Right_Code,'HB' FROM #RCodeForHB
	END
	--select R_Codes AS RightsCodes,ErrorType from #FinalErrorResult




	--New Change
	IF(EXISTS(SELECT * FROM #FinalErrorResult))
	BEGIN
		DECLARE @RC INT,@MT VARCHAR(MAX)	
		DECLARE FinalCursor CURSOR FOR SELECT ErrorType,R_Codes FROM #FinalErrorResult
		OPEN FinalCursor
		FETCH NEXT FROM FinalCursor
		INTO @MT,@RC
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #Error_Record(Rights_Code,Title_Name,Platform_Name,Right_Start_Date,Right_End_Date,Right_Type,Is_Sub_License,
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
			'N' AS Is_Updated
			From(
			Select *,
			REVERSE(
					stuff(
						reverse(
							STUFF((
								Select CASE WHEN Territory_Type = 'G' THEN t.Territory_Name+', ' 
								WHEN Territory_Type = 'I' THEN c.Country_Name+', ' END
								from Syn_Deal_Rights_Territory adrt
								LEFT JOIN Territory t ON t.Territory_Code = adrt.Territory_Code
								LEFT JOIN Country c ON c.Country_Code = adrt.Country_Code
								where adrt.Syn_Deal_Rights_Code In (@RC) FOR XML PATH(''), root('Country_Name'), type
								).value('/Country_Name[1]','Nvarchar(max)'
						),2,0, '')), 1, 1, '')) as Country_Name
			,
			STUFF((
				Select ',' + CAST(P.Platform_Code as Varchar) 
				From Platform p Where p.Platform_Code In
				(
					Select Platform_Code 
					FROM Syn_Deal_Rights_Platform 
					where Syn_Deal_Rights_Code=@RC
				)
				FOR XML PATH('')), 1, 1, ''
			) as Platform_Code,
			REVERSE(
					STUFF(REVERSE(STUFF((
						Select CASE WHEN Language_Type = 'G' THEN lg.Language_Group_Name+', '
						WHEN Language_Type = 'L' THEN l.Language_Name+', ' END
						from Syn_Deal_Rights_Subtitling adrs
						LEFT JOIN Language_Group lg ON lg.Language_Group_Code = adrs.Language_Group_Code
						LEFT JOIN [Language] l ON l.Language_Code = adrs.Language_Code
						where adrs.Syn_Deal_Rights_Code In (@RC)
						FOR XML PATH(''), root('Subtitling_Language'), type

						).value('/Subtitling_Language[1]','Nvarchar(max)'

					),2,0, '')), 1, 1, '')) as Subtitling_Language
			,
			REVERSE(
					STUFF(REVERSE(STUFF((
						Select   CASE WHEN Language_Type = 'G' THEN lg.Language_Group_Name+', '
						WHEN Language_Type = 'L' THEN l.Language_Name+', ' END
						from Syn_Deal_Rights_Dubbing adrs
						LEFT JOIN Language_Group lg ON lg.Language_Group_Code = adrs.Language_Group_Code
						LEFT JOIN [Language] l ON l.Language_Code = adrs.Language_Code
						where adrs.Syn_Deal_Rights_Code In (@RC)
						FOR XML PATH(''), root('Dubbing_Language'), type
						).value('/Dubbing_Language[1]','Nvarchar(max)'
					),2,0, '')), 1, 1, ''))  as Dubbing_Language
			,
			STUFF
			(
				(
					Select ', ' + t.Agreement_No FROM Syn_Deal t
					Where t.Syn_Deal_Code In (
						Select adr.Syn_Deal_Code FROM Syn_Deal_Rights adr where adr.Syn_Deal_Rights_Code=@RC
				)FOR XML PATH('')), 1, 1, ''
			) as Agreement_No
			From (
				Select T.Title_Code,
				DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
				ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
				Is_Sub_License, Is_Title_Language_Right, 
				Right_Type, Episode_From, Episode_To
				from Syn_Deal_Rights ADR
				INNER JOIN Syn_Deal_Rights_Title ADRT on ADR.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code
				INNER JOIN Title T ON T.Title_Code=ADRT.Title_Code where ADR.Syn_Deal_Rights_Code=@RC
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
	SELECT * FROM #Error_Record
	--New Change
END


