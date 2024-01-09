ALTER PROCEDURE [dbo].[USPAPI_Channel_Category]
	@order VARCHAR(10) = NULL,
	@page INT = NULL,
	@search_value NVARCHAR(MAX) = NULL,
	@size INT = NULL,
	@sort VARCHAR (100) = NULL,
	@date_gt VARCHAR(50) = NULL,
	@date_lt VARCHAR(50) = NULL,
	@RecordCount INT = NULL OUT,
	@id INT = NULL
AS
BEGIN

Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Channel_Category]', 'Step 1', 0, 'Started Procedure', 0, '' 

	DECLARE @Condition NVARCHAR(MAX) = '';
	DECLARE @delimt NVARCHAR(2) = N',' 

	SET @Condition  += ' '
	IF(@page = 0)
	BEGIN
		SET @page = 1      
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id INT IDENTITY(1,1),  
		Channel_Category_Code	INT,
		Channel_Category_Name  VARCHAR (100),
		Type CHAR(1),
		Is_Active CHAR(1),
		Last_Updated_Time DATETIME,
		Inserted_On DATETIME,
		Sort VARCHAR(10),  
		Row_Num INT,  
	); 

	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition =''

	IF(ISNULL(@id,0) = 0)
	BEGIN
	   IF(ISNULL(@search_value,'')<>'')
	   BEGIN
			SET @SQL_Condition ='AND (Channel_Category_Code IN (select Channel_Category_Code from Channel_Category where Channel_Category_Name Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Channel_Category_Code = '+CAST(@id as VARCHAR(20))
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Channel_Category_Code,Channel_Category_Name,Type,Is_Active,Last_Updated_Time,Inserted_On,''1'','' '' from Channel_Category where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Channel_Category_Name LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Channel_Category_Code ORDER BY Sort ASC) RowNum, Id, Channel_Category_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1 

	Select @RecordCount = Count(DISTINCT (Channel_Category_Code )) FROM #Temp
    SET @sort = @sort+' '+@order

	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Channel_Category_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size   

	select Channel_Category_Code, Channel_Category_Name, Type,Is_Active from #Temp

    if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Channel_Category]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
