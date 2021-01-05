CREATE PROCEDURE [dbo].[USP_List_Platform_Group]
(
	@StrSearch NVARCHAR(Max),	
	@PageNo Int,
	@OrderByCndition VARCHAR(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int OUT
)	
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 30 OCT 2014
-- Description:	IPR List
-- =============================================
BEGIN
	SET NOCOUNT ON;	
	SET FMTONLY OFF;
	--PRINT @OrderByCndition 
	IF(@OrderByCndition = '')
		SET @OrderByCndition = 1
	DECLARE @SqlPageNo Varchar(Max),@Sql VARCHAR(MAX)	
	if(@PageNo=0)
		Set @PageNo = 1	
	CREATE Table #Temp
	(
		Platform_Group_Code INT,
		RowId Int		
	);
	SET @SqlPageNo = '
	WITH Y AS 
	(
		SELECT Platform_Group_Code, RowId = ROW_NUMBER() OVER (ORDER BY Platform_Group_Code desc) 
		FROM Platform_Group
		Where 1= 1  ' + @StrSearch + '
		GROUP BY Platform_Group_Code
	)
	INSERT INTO #Temp Select Platform_Group_Code, RowId From Y'

	PRINT @SqlPageNo
	EXEC(@SqlPageNo)
	SELECT @RecordCount = ISNULL(COUNT(Platform_Group_Code),0) FROM #Temp

	If(@IsPaging = 'Y')
		Begin	
			Delete From #Temp Where RowId < (((@PageNo - 1) * @PageSize) + 1) Or RowId > @PageNo * @PageSize 
		End	
	SET @Sql = '
	SELECT PG.Platform_Group_Code,RowId,Platform_Group_name,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,last_Action_By,Is_Active, 
	dbo.UFN_Get_Platform_Names(PG.Platform_Group_Code) AS Platform_Name FROM Platform_Group PG
	INNER JOIN #Temp T ON PG.Platform_Group_Code = T.Platform_Group_Code ORDER BY ' + @OrderByCndition 

	--PRINT @Sql
	EXEC(@Sql)

	DROP TABLE #Temp
END

/*

Declare @RCount Int = 0
Exec USP_List_Platform_Group ' AND Platform_Group_NAme like ''Linear and Home Video Rights''', 3, '', 'Y', 10, @RCount Out
Select @RCount

*/


