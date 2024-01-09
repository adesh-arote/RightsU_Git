CREATE PROCEDURE [dbo].[USPAPI_Language_List]
	@order VARCHAR(10) = NULL,
	@page INT = NULL,
	@search_value NVARCHAR(MAX) = NULL,
	@size INT = NULL,
	@sort VARCHAR (100) = NULL,
	@date_gt VARCHAR(50) = NULL,
	@date_lt VARCHAR(50) = NULL,
	@RecordCount INT = NULL OUT,
	@id INT = NULLt
AS
BEGIN
Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Language_List]', 'Step 1', 0, 'Started Procedure', 0, '' 

	if(@page = 0)
	BEGIN
		SET @page = 1      
	END
	   IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id Int Identity(1,1),      
		Language_Code Varchar(200),  
		Language_Name  Varchar(1000),  
		Is_Active Varchar(200),  
		Sort varchar(10),  
		Row_Num Int,  
		Last_Updated_Time datetime,
		Inserted_On datetime  
	);  

	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition ='';

	IF(ISNULL(@id,0) = 0)
	BEGIN
	   IF(ISNULL(@search_value,'')<>'')
	   BEGIN
			SET @SQL_Condition ='AND (Language_Code IN (select Language_Code from Language where Language_Name Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Language_Code = '+CAST(@id as VARCHAR(20))
		--PRINT @SQL_Condition
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Language_Code,Language_Name,Is_Active,''1'','' '',Last_Updated_Time,Inserted_On from Language where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Language_Name LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Language_Code ORDER BY Sort ASC) RowNum, Id, Language_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1 

	Select @RecordCount = Count(DISTINCT (Language_Code )) FROM #Temp
    SET @sort = @sort+' '+@order


	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Language_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size  

	select Language_Code,Language_Name,Is_Active from #Temp

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp         

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Language_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
