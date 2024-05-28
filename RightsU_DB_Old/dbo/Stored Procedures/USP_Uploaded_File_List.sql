CREATE PROCEDURE [dbo].[USP_Uploaded_File_List]
    @StrSearch NVARCHAR(MAX),
	@PageNo INT,  
    @RecordCount INT OUT,  
    @IsPaging VARCHAR(2),  
    @PageSize INT
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 21 May 2015
-- Description:	List of All Uploaded File
-- =============================================
BEGIN

	IF(@PageNo = 0)
		SET @PageNo = 1

	CREATE TABLE #Temp(
		Id INT,
		RowId VARCHAR(200)
	);

	DECLARE @SqlPageNo VARCHAR(5000)
		
	SET @SqlPageNo = 
			'WITH Y AS (
		  
						SELECT k, File_Code FROM 
						(
							SELECT k = ROW_NUMBER() OVER (ORDER BY File_Code DESC), * FROM (
								SELECT File_Code, File_Name , Upload_Date, Err_YN, Upload_Type, Pending_Review_YN, Upload_Record_Count,
								Records_Inserted, Records_Updated, Bank_Code, Total_Errors, ChannelCode, StartDate, EndDate
							FROM Upload_Files 
								)AS XYZ WHERE 1 = 1  
									'+ @StrSearch + '
							)AS X
					)
	INSERT INTO #Temp SELECT k, File_Code FROM Y '
	
	EXEC(@SqlPageNo)
		
	SELECT @RecordCount = COUNT(*) FROM #Temp
	--select * from #Temp
		
	IF(@IsPaging = 'Y')
	BEGIN	
		DELETE FROM #Temp WHERE Id < (((@PageNo - 1) * @PageSize) + 1) OR Id > @PageNo * @PageSize 		
	END	

	DECLARE @Sql NVARCHAR(MAX)
	SET @Sql = 'SELECT File_Code, SUBSTRING(File_Name, CHARINDEX(''~'', File_Name) + 1, LEN(File_Name) - CHARINDEX(''~'', File_Name) + 1) AS File_Name,
				Upload_Date, LTRIM(RTRIM(Err_YN)) AS Is_Error, 
				LTRIM(RTRIM(Upload_Type)) AS Upload_Type, 
				ISNULL(Pending_Review_YN, '''') AS Is_Review_Pending, 
				ISNULL(Upload_Record_Count, 0) AS Total_Record_Uploaded, 
				ISNULL(Records_Inserted, 0) AS Total_Records_Inserted , 
				ISNULL(Records_Updated, 0) AS Total_Records_Updated, 
				ISNULL(Bank_Code, 0) AS Bank_Code, 
				ISNULL(Total_Errors, 0) AS Total_Errors, ChannelCode AS Channel_Code, StartDate AS Start_Date, EndDate AS End_Date, 
				ISNULL((SELECT TOP 1 CASE WHEN Row_Num = 0 AND LTRIM(RTRIM(Err_Cols)) != '''' THEN UED.Upload_Detail_Code ELSE 0 END AS Upload_Detail_Code FROM Upload_Err_Detail UED where UED.File_Code = FU.File_Code), 0)AS Upload_Detail_Code
				FROM Upload_Files FU  WHERE File_Code IN 
				(
					select RowId from #Temp 
				) 
				ORDER BY File_Code desc'
	PRINT(@Sql)
	EXEC(@Sql)
		
	DROP TABLE #Temp

END