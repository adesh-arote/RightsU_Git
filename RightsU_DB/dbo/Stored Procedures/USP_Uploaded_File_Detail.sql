CREATE PROCEDURE [dbo].[USP_Uploaded_File_Detail]
(
	@File_Code VARCHAR(10),
	@StrSearch NVARCHAR(MAX),
	@PageNo INT,  
    @RecordCount INT OUT,  
    @IsPaging VARCHAR(2),  
    @PageSize INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 21 May 2015
-- Description:	List of All Uploaded File Detail
-- =============================================
BEGIN

	IF(@PageNo = 0)
		SET @PageNo = 1

	CREATE TABLE #Temp(
		Id INT,
		RowId VARCHAR(200)
	);

	DECLARE @SqlPageNo VARCHAR(5000) = ''
		
	SET @SqlPageNo = 
			'WITH Y AS (
		  
						SELECT k, upload_detail_code FROM 
						(
							SELECT k = ROW_NUMBER() OVER (ORDER BY upload_detail_code DESC), * FROM (
								SELECT upload_detail_code, File_Code, Row_Num , Err_Cols,  Row_Delimed
							FROM Upload_Err_Detail 
								)AS XYZ WHERE 1 = 1  AND file_code = ' + @File_Code + ' 
								' + @StrSearch +  ' 
							)AS X
					)
	INSERT INTO #Temp SELECT k, upload_detail_code FROM Y '
	
	PRINT @SqlPageNo
	EXEC(@SqlPageNo)
		
	SELECT @RecordCount = COUNT(*) FROM #Temp
		
	IF(@IsPaging = 'Y')
	BEGIN	
		DELETE FROM #Temp WHERE Id < (((@PageNo - 1) * @PageSize) + 1) OR Id > @PageNo * @PageSize 		
	END	

	DECLARE @Sql NVARCHAR(MAX)
	SET @Sql = 'SELECT UED.upload_detail_code as Upload_Detail_Code, UED.Row_Num, UED.Err_Cols as Error_Codes, 
				(SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 1) AS WBS_Code,
				(SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 2) AS WBS_Description,
				(SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 3) AS Studio_Vendor,
				(SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 4) AS Original_Dubbed,
				(SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 5) AS Short_ID,
				(SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 6) AS Status,
				isnull((SELECT TOP 1 number from dbo.fn_Split_withdelemiter(Row_Delimed, ''~'') WHERE ID = 7),'''') AS Sport_Type
				FROM Upload_Err_Detail UED
				WHERE Row_Num > 0 AND UED.file_code = ' + @File_Code + ' AND UED.upload_detail_code IN 
				(
					select RowId from #Temp 
				) 
				ORDER BY UED.upload_detail_code desc'
	PRINT(@Sql)
	EXEC(@Sql)
		
	--DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp

END

--select * from Upload_Err_Detail where File_Code=27
--exec USP_Uploaded_File_Detail 27