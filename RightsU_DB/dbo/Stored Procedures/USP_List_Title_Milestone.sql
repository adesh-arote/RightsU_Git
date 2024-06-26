﻿ CREATE PROCEDURE USP_List_Title_Milestone
 (
 	@PageNo Int=0,            
 	@RecordCount Int out,            
 	@PagingRequired Varchar(2),            
 	@PageSize Int,            
 	@TitleCode INT
 )
 AS 
 BEGIN
	--DECLARE 
	--@PageNo Int=0,            
 --	@RecordCount Int  = 10,            
 --	@PagingRequired Varchar(2) = 'Y',            
 --	@PageSize Int =10,            
 --	@TitleCode INT = 35267

	
	IF(OBJECT_ID('TEMPDB..#TempTitleMilestoneList') IS NOT NULL)
		DROP TABLE #TempTitleMilestoneList

	CREATE TABLE #TempTitleMilestoneList(
		Row_No INT IDENTITY(1,1),
		Title_Milestone_Code INT,
		Title_Code INT,
		Title_Name NVARCHAR(MAX),
		Talent_Name NVARCHAR(MAX),
		Milestone_Nature_Name NVARCHAR(MAX),
		Expiry_Date DATETIME,
		Milestone NVARCHAR(MAX),
		Action_Item NVARCHAR(MAX),
		Is_Abandoned VARCHAR(10),
		Remarks NVARCHAR(MAX)
	)
	
	if(@PageNo = 0)
        Set @PageNo = 1

	INSERT INTO #TempTitleMilestoneList(Title_Milestone_Code,Title_Code,Title_Name,Talent_Name,Milestone_Nature_Name,Expiry_Date,Milestone,Action_Item,Is_Abandoned,Remarks)
	SELECT TM.Title_Milestone_Code 
	,TM.Title_Code
	,T.Title_Name 
	,TL.Talent_Name
	,MN.Milestone_Nature_Name
	,TM.Expiry_Date
	,TM.Milestone
	,TM.Action_Item
	,CASE WHEN TM.Is_Abandoned = 'Y' THEN 'Yes' ELSE 'No' END 
	,TM.Remarks
	FROM Title_Milestone TM
	INNER JOIN Title T ON T.Title_Code = TM.Title_Code
	INNER JOIN Talent TL ON TL.Talent_Code = TM.Talent_Code
	INNER JOIN Milestone_Nature MN ON MN.Milestone_Nature_Code = TM.Milestone_Nature_Code
	WHERE T.Title_Code = @TitleCode 
	order by TM.Last_Updated_Time desc

	SELECT @RecordCount = COUNT(*) FROM #TempTitleMilestoneList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	IF(@PagingRequired  = 'Y')
		BEGIN
			DELETE from  #TempTitleMilestoneList
			WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
		END
	SELECT Title_Milestone_Code,Title_Name,Talent_Name,Milestone_Nature_Name,Expiry_Date,Milestone,Action_Item,Is_Abandoned,Remarks FROM #TempTitleMilestoneList

	IF OBJECT_ID('tempdb..#TempTitleMilestoneList') IS NOT NULL DROP TABLE #TempTitleMilestoneList
 END	


	

	

	

--DECLARE @RecordCount INT
--EXEC USPMHConsumptionRequestList 1,1287,'L','Y',10,1,@RecordCount OUTPUT,'','','','','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)