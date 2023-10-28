CREATE  PROCEDURE [dbo].[USP_List_DM_Master_Import]  
(  
	@strSearch  NVARCHAR(2000),  
	@PageNo INT=1,  
	@OrderByCndition NVARCHAR(100),  
	@IsPaging VARCHAR(2),  
	@PageSize INT,
	@RecordCount INT OUT,  
	@User_Code INT
)   
AS  
BEGIN  
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_List_DM_Master_Import]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET FMTONLY OFF  
  
		DECLARE @SqlPageNo NVARCHAR(MAX),@Sql NVARCHAR(MAX)  
		SET NOCOUNT ON;   
		IF(@PageNo=0)  
			Set @PageNo = 1   
		CREATE TABLE #Temp  
		(  
			DM_Master_Import_Code INT,  
			RowId VARCHAR(200)
		);  

			DECLARE @Is_Advance_Title_Import NVARCHAR(MAX) = ''
			select @Is_Advance_Title_Import =  Parameter_Value from system_parameter_new where parameter_name = 'Is_Advance_Title_Import'

			IF (@strSearch LIKE '%DM.File_Type = ''T''%')	
			BEGIN
				IF(@Is_Advance_Title_Import = 'N')
				BEGIN
						SET @SqlPageNo = '  
						WITH Y AS   
						(  
							SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
							FROM DM_Master_Import DM  (NOLOCK) 
							Where  DM.DM_Master_Import_Code NOT IN (
								 SELECT DISTINCT DM_Master_Import_Code FROM DM_TITLE_IMPORT_Utility_data (NOLOCK)
								) AND 1= 1  '+@StrSearch+'  
							GROUP BY DM.DM_Master_Import_Code  
						)  
						INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'  
				END
				ELSE
				BEGIN
						SET @SqlPageNo = '  
						WITH Y AS   
						(  
							SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
							FROM DM_Master_Import DM   (NOLOCK)
							INNER JOIN DM_Title_Import_Utility_DATA B (NOLOCK) ON  B.DM_Master_Import_Code = DM.DM_Master_Import_Code
							Where 1= 1  '+@StrSearch+'  
							GROUP BY DM.DM_Master_Import_Code  
						)  
						INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'  
				END
			END
			ELSE
			BEGIN
					SET @SqlPageNo = '  
						WITH Y AS   
						(  
							SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
							FROM DM_Master_Import DM   (NOLOCK)
							Where 1= 1  '+@StrSearch+'  
							GROUP BY DM.DM_Master_Import_Code  
						)  
						INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'
			END

			PRINT @SqlPageNo  
			EXEC(@SqlPageNo)  

			SELECT @RecordCount = ISNULL(COUNT(DM_Master_Import_Code),0) FROM #Temp  
  
		IF(@IsPaging = 'Y')  
		BEGIN   
			DELETE FROM #Temp WHERE RowId < (((@PageNo - 1) * @PageSize) + 1) OR RowId > @PageNo * @PageSize   
		END   
		ALTER TABLE #Temp ADD FileType CHAR(1)
		ALTER TABLE #Temp ADD TotalCount INT
		ALTER TABLE #Temp ADD SuccessCount INT
		ALTER TABLE #Temp ADD ConflictCount INT
		ALTER TABLE #Temp ADD IgnoreCount INT
		ALTER TABLE #Temp ADD ErrorCount INT
		ALTER TABLE #Temp ADD WaitingCount INT

		UPDATE T SET T.FileType = (SELECT File_Type FROM DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
		FROM #Temp T

		DECLARE @FileType CHAR(1)
		SELECT @FileType = FileType FROM #Temp
		IF(@FileType = 'M')
		BEGIN
			UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
			FROM #Temp T

			UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
			FROM #Temp T

			UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND Is_Ignore ='N')
			FROM #Temp T

			UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
			FROM #Temp T

			UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
			FROM #Temp T

			UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
			FROM #Temp T
		END
		ELSE IF(@FileType= 'T')
		BEGIN 
		
			IF(@Is_Advance_Title_Import = 'N')
			BEGIN
				UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
				FROM #Temp T

				UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
				FROM #Temp T

				UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND Is_Ignore ='N')
				FROM #Temp T

				UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
				FROM #Temp T

				UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
				FROM #Temp T

				UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Title (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
				FROM #Temp T
			END
			ELSE
			BEGIN
				UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNUMERIC(Col1) = 1 and DM_Master_Import_Code = T.DM_Master_Import_Code)
				FROM #Temp T

				UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
				FROM #Temp T

				UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND ISNULL(Is_Ignore,'') ='N')
				FROM #Temp T

				UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND ISNULL(Is_Ignore,'') = 'Y')
				FROM #Temp T

				UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E' AND ISNULL(Is_Ignore,'') <> 'Y')
				FROM #Temp T

				UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND ISNULL(Record_Status,'') = '' AND ISNULL(Is_Ignore,'') <> 'Y')
				FROM #Temp T
			END
		
		END
		ELSE
		BEGIN
			UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
			FROM #Temp T

			UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
			FROM #Temp T

			UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND (Record_Status = 'OR' 
				OR Record_Status = 'MR' OR Record_Status = 'SM' OR Record_Status = 'MO' OR Record_Status = 'SO') AND Is_Ignore = 'N')
			FROM #Temp T

			UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
			FROM #Temp T

			UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
			FROM #Temp T

			UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
			FROM #Temp T
		END

		SET @Sql = 'SELECT DM.DM_Master_Import_Code As DM_Master_Import_Code, DM.File_Name As File_Name, U.Login_Name AS UserName, 
		REPLACE(CONVERT(char(11), DM.Uploaded_Date, 106),'' '',''-'') + right(convert(varchar(32),DM.Uploaded_Date,100),8) AS Uploaded_Date, 
		DM.Status AS Status, T.TotalCount As TotalCount, T.SuccessCount As SuccessCount, T.ConflictCount AS ConflictCount, T.IgnoreCount AS IgnoreCount,
		T.ErrorCount As ErrorCount, T.WaitingCount As WaitingCount
		FROM DM_Master_Import DM  (NOLOCK) 
		INNER JOIN USers U  
		 (NOLOCK) ON DM.Upoaded_By = U.Users_Code  
		INNER JOIN #Temp T (NOLOCK) ON DM.DM_Master_Import_Code = T.DM_Master_Import_Code ORDER BY ' +@OrderByCndition  
  
		PRINT @sql  
		EXEC (@Sql)  
   

		--DROP TABLE #Temp  
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_List_DM_Master_Import]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
