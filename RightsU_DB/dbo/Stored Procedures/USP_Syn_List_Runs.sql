
CREATE PROC [dbo].[USP_Syn_List_Runs](
--DECLARE
@Deal_Code Int,@Title_Codes VARCHAR(MAX)
)
As
-- =============================================
-- Author:		Rajesh J Godse
-- Create DATE: 25 Feb 2015
-- Description:	Get Syndication Run List page
-- =============================================
Begin
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END
	CREATE TABLE #Temp(
	Syn_Deal_Run_Code INT,
	Title_Name NVARCHAR(1000),
	Platform_Hiearachy VARCHAR(MAX),
	Run_Type VARCHAR(1000),
	No_Of_Runs INT,
	Is_Rule_Right CHAR(2),
	Last_updated_Time DATETIME,
	Inserted_On DATETIME
	)
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal WHERE Syn_Deal_Code = @Deal_Code
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	INSERT INTO #Temp
	SELECT distinct Tbl.Syn_Deal_Run_Code AS Syn_Deal_Run_Code ,
	Title_Name,
	 STUFF((SELECT distinct ',' + p.Platform_Hiearachy 
        from Syn_Deal_Run SDR
		INNER JOIN Title t ON SDR.Title_Code = TBL.Title_Code
		INNER JOIN Syn_Deal_Movie SDM ON SDR.Syn_Deal_Code = SDM.Syn_Deal_Code AND 
				SDR.Episode_From = SDM.Episode_From AND SDR.Episode_To = SDM.Episode_End_To AND SDR.Title_Code = SDM.Title_Code
		Inner JOIN Syn_Deal_Run_Platform SDRP ON tbl.Syn_Deal_Run_Code = SDRP.Syn_Deal_Run_Code
		INNER JOIN Platform P ON SDRP.Platform_Code = p.Platform_Code
		WHERE SDR.Syn_Deal_Code = @Deal_Code
		AND (((SDR.Title_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) AND @Title_Codes <> '0' AND 
		(@Deal_Type_Condition != 'DEAL_PROGRAM' OR @Deal_Type_Condition != 'DEAL_MUSIC')) OR @Title_Codes = '0') OR
			((SDM.Syn_Deal_Movie_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) AND @Title_Codes <> '0' 
			AND (@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC')) OR @Title_Codes = '0'))
        FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'),1,1,'') AS Platform_Hiearachy,
		Run_Type,
		No_Of_Runs,
		Is_Rule_Right,
		Tbl.Last_updated_Time,
		Tbl.Inserted_On
		--INTO #Temp
	FROM (	
		Select SDR.Title_Code, SDR.Syn_Deal_Run_Code,
		DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, t.Title_Name, SDR.Episode_From, SDR.Episode_To) as [Title_Name],
		Run_Type,No_Of_Runs,Is_Rule_Right,SDR.Inserted_On,SDR.Last_updated_Time 		
		from Syn_Deal_Run SDR
		INNER JOIN Title t ON SDR.Title_Code = t.Title_Code                 
		INNER JOIN Syn_Deal_Movie SDM ON SDR.Syn_Deal_Code = SDM.Syn_Deal_Code AND 
					SDR.Episode_From = SDM.Episode_From AND SDR.Episode_To = SDM.Episode_End_To AND SDR.Title_Code = SDM.Title_Code
		Inner JOIN Syn_Deal_Run_Platform SDRP ON SDR.Syn_Deal_Run_Code = SDRP.Syn_Deal_Run_Code
		INNER JOIN Platform P ON SDRP.Platform_Code = p.Platform_Code
		WHERE SDR.Syn_Deal_Code = @Deal_Code                               
		AND (((SDR.Title_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) AND @Title_Codes <> '0' AND (@Deal_Type_Condition != 'DEAL_PROGRAM' OR @Deal_Type_Condition != 'DEAL_MUSIC')) OR @Title_Codes = '0') OR
		((SDM.Syn_Deal_Movie_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) AND @Title_Codes <> '0' AND (@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC')) OR @Title_Codes = '0'))
	) AS Tbl

	SELECT Syn_Deal_Run_Code,Title_Name,Platform_Hiearachy,Run_Type,No_Of_Runs,Is_Rule_Right FROM #Temp
	Order by ISNULL(Last_updated_Time,Inserted_On) DESC

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
End