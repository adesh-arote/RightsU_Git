 CREATE PROCEDURE USP_TitleMilestone_Report
 (
 	@TitleCode NVARCHAR(MAX),            
 	@TalentCode NVARCHAR(MAX),            
 	@MilestoneNatureCode NVARCHAR(MAX),            
	@StartRange VARCHAR(30),
	@EndRange VARCHAR(30)
 )
 AS 
 BEGIN
 --DECLARE
	--@TitleCode NVARCHAR(MAX) ='35265,35266',       
	--@TalentCode NVARCHAR(MAX)= '',            
	--@MilestoneNatureCode NVARCHAR(MAX) = '',            
	--@StartRange VARCHAR(30) = '',
	--@EndRange VARCHAR(30) = ''
	--@LastDate VARCHAR(30) = ''
	

	

	SELECT 
		T.Title_Name,
		TL.Talent_Name,
		MN.Milestone_Nature_Name,
		CONVERT(VARCHAR,TM.Expiry_Date,106) AS Expiry_Date, 
		TM.Milestone,
		TM.Action_Item,
		CASE WHEN TM.Is_Abandoned = 'Y'
		THEN 'ABANDONED' ELSE
		CASE WHEN  GETDATE() > Tm.Expiry_Date 
		 THEN 'EXPIRED' ELse 'ACTIVE' END
		END AS Status

	FROM 
	Title_Milestone TM
	INNER JOIN Title T ON T.Title_Code = TM.Title_Code
	INNER JOIN Talent TL ON TL.Talent_Code = TM.Talent_Code
	INNER JOIN Milestone_Nature MN ON MN.Milestone_Nature_Code = TM.Milestone_Nature_Code
	--INNER JOIN #TempDateStatus TDS ON TDS.Title_Milestone_Code = TM.Title_Milestone_Code 
	WHERE
	(@TitleCode = '' OR ISNULL(TM.Title_Code, 0) in (select number from fn_Split_withdelemiter(@TitleCode,',')) OR ISNULL(TM.Title_Code, 0) = 0)
	AND (@TalentCode = '' OR ISNULL(TL.Talent_Code, 0) in (select number from fn_Split_withdelemiter(@TalentCode,',')) OR ISNULL(TL.Talent_Code, 0) = 0)
	AND (@MilestoneNatureCode = '' OR ISNULL(MN.Milestone_Nature_Code, 0) in (select number from fn_Split_withdelemiter(@MilestoneNatureCode,',')) OR ISNULL(MN.Milestone_Nature_Code, 0) = 0)
	AND(TM.Expiry_Date BETWEEN CONVERT(VARCHAR,@StartRange,106) AND CONVERT(VARCHAR,@EndRange,106) OR @StartRange = '' OR @EndRange= '')
	--AND (TM.Expiry_Date BETWEEN CONVERT(VARCHAR,@StartRange,106) AND CONVERT(VARCHAR,@EndRange,106) OR @EndRange = '')
	--OR Expiry_Date BETWEEN GETDATE() AND @EndRange 
	--AND GETDATE() > Expiry_Date
	
	IF OBJECT_ID('tempdb..#TempDateStatus') IS NOT NULL DROP TABLE #TempDateStatus
 END

 
--Select * from Title_Milestone
--Select * from Milestone_Nature