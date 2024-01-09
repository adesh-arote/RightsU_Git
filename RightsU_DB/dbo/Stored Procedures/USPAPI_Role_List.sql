ALTER PROCEDURE [dbo].[USPAPI_Role_List]
	@order VARCHAR(10) = NULL,
	@page INT = NULL,
	@search_value NVARCHAR(MAX) = NULL,
	@size INT = NULL,
	@sort VARCHAR (100) = NULL,
	@RecordCount INT = NULL OUT,
	@id INT = NULL
AS

BEGIN

	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	IF(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Role_List]', 'Step 1', 0, 'Started Procedure', 0, '' 

	DECLARE @Condition NVARCHAR(MAX) = ''      
	DECLARE @delimt NVARCHAR(2) = N'﹐'     

	SET @Condition  += ' '
	if(@page = 0)
	BEGIN
		SET @page = 1      
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id INT IDENTITY(1,1),
		Role_Code  VARCHAR(200), 
		Role_Name  VARCHAR(200),  
		Role_Type  VARCHAR(200),  
		Deal_Type VARCHAR(200),  
		Sort VARCHAR(10),  
		Row_Num INT,  
	);

	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition =''
	
	IF(ISNULL(@id,0) = 0)
	BEGIN
		IF(ISNULL(@search_value,'')<>'')
		BEGIN
			SET @SQL_Condition ='AND (Role_Code IN (select Role_Code from Role WHERE Role_Name Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +='AND Role_Code = '+CAST(@id as VARCHAR(20))
		PRINT @SQL_Condition
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select R.Role_Code,R.Role_Name,RTRIM(R.Role_Type) as Role_Type,dt.Deal_Type_Name,''1'','' '' from Role R INNER JOIN Deal_Type dt ON R.Deal_Type_Code = dt.Deal_Type_Code where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo)

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Role_Name LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Role_Code ORDER BY Sort ASC) RowNum, Id, Role_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  

	SELECT @RecordCount = Count(DISTINCT (Role_Code)) FROM #Temp
    SET @sort = @sort+' '+@order

	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Role_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size   

	SELECT Role_Code,RTRIM(Role_Name)  AS Role_Name,Role_Type,Deal_Type FROM #Temp

    IF(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Role_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 

END
