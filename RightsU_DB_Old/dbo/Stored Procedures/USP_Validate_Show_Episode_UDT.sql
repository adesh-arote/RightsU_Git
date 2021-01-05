CREATE PROCEDURE [dbo].[USP_Validate_Show_Episode_UDT]
(
	@Deal_Rights_Title Deal_Rights_Title READONLY
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 29-January-2015
-- Description:	Show has acquired for this Episode
-- =============================================
BEGIN
	--DECLARE @Deal_Right_Title Deal_Rights_Title

	CREATE TABLE #TmpNums(
		Eps_No INT
	)

	DECLARE @StartNum INT
	DECLARE @EndNum INT
	SELECT @StartNum = MIN(Episode_FROM), @EndNum = MAX(Episode_To) FROM @Deal_Rights_Title;

	WITH gen AS (
		SELECT @StartNum AS num UNION ALL
		SELECT num+1 FROM gen WHERE num+1<=@EndNum
	)

	INSERT INTO #TmpNums
	SELECT * FROM gen
	OPTION (maxrecursion 10000)

	SELECT DISTINCT a.Eps_No, t.Title_Code InTo #Temp_Syn_Title FROM #TmpNums A CROSS APPLY @Deal_Rights_Title T 
	WHERE A.Eps_No BETWEEN T.Episode_FROM AND T.Episode_To

	SELECT EPS_No, Title_Code InTo #Acq_Title_Eps FROM (
		Select Distinct vw.Episode_From, vw.Episode_To, vw.Title_Code From VW_Validate_SYN_General_Data vw Where vw.Title_Code  In (
			Select syn.Title_Code From #Temp_Syn_Title syn
		)
	) AA 
	CROSS APPLY #TmpNums A
	WHERE A.Eps_No BETWEEN AA.Episode_FROM AND AA.Episode_To

	--Select * From #Temp_Syn_Title
	--Select * From #Acq_Title_Eps

	SELECT * INTO #NAEps FROM #Temp_Syn_Title B WHERE B.Eps_No NOT IN (
		SELECT AA.EPS_No FROM #Acq_Title_Eps AA WHERE AA.Title_Code = B.Title_Code
	)

	SELECT b.Title_Code, t.Title_Name, 
	STUFF(
				(SELECT DISTINCT ', ' + CAST(a.Eps_No AS VARCHAR) FROM #NAEps A WHERE a.Title_Code = b.Title_Code FOR XML PATH('')), 1, 1, ''
		) AS Episode_No 
	FROM #NAEps b
	INNER JOIN Title t on b.Title_Code = t.Title_Code
	GROUP BY b.Title_Code, t.Title_Name
	DROP TABLE #TmpNums
	DROP TABLE #NAEps
	DROP TABLE #Temp_Syn_Title
	DROP TABLE #Acq_Title_Eps
END