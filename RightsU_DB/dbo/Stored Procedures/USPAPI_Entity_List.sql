CREATE PROCEDURE [dbo].[USPAPI_Entity_List]
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
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Entity_List]', 'Step 1', 0, 'Started Procedure', 0, '' 

	DECLARE @Condition NVARCHAR(MAX);     
	DECLARE @delimt NVARCHAR(2) = N','      

	SET @Condition  += ' '
	if(@page = 0)
	BEGIN
		SET @page = 1      
	END

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  

		CREATE TABLE #Temp (      
		Id Int Identity(1,1),      
		Entity_Code Varchar(200),  
		[Entity_Name]  Varchar(200),  
		Is_Active  Varchar(200),  
		ParentEntityCode Varchar(200),
		Ref_Entity_Key  Varchar(200),
		Sort varchar(10),  
		Row_Num Int,  
		Last_Updated_Time datetime,
		Inserted_On datetime  
	);  


	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition =''
	IF(ISNULL(@id,0) = 0)
	BEGIN
		
		IF(ISNULL(@search_value,'')<>'')
		BEGIN
			SET @SQL_Condition ='AND (Entity_Code IN (SELECT Entity_Code FROM Entity WHERE [Entity_Name] LIKE N''%' + @search_value+ '%'') OR ParentEntityCode Like N''%' + @search_value + '%'' OR Ref_Entity_Key Like N''%' + @search_value + '%'')'
		END

		IF(ISNULL(@date_gt,'')<>'' AND ISNULL(@date_lt,'')<>'')
		BEGIN
			SET @SQL_Condition +=' AND CAST(Inserted_On AS DATE) BETWEEN '''+@date_gt+''' AND '''+@date_lt+''''
		END
		ELSE IF(ISNULL(@date_gt,'')<>'')
		BEGIN
			SET @SQL_Condition +=' AND CAST(Inserted_On AS DATE) >= '''+@date_gt+''''
		END
		ELSE IF(ISNULL(@date_lt,'')<>'')
		BEGIN
			SET @SQL_Condition +=' AND CAST(Inserted_On AS DATE) <= '''+@date_lt+''''
		END
		
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Entity_Code = '+CAST(@id as VARCHAR(20))
		PRINT @SQL_Condition
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Entity_Code,[Entity_Name],Is_Active,ParentEntityCode,Ref_Entity_Key,''1'','' '',Last_Updated_Time,Inserted_On from Entity where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE [Entity_Name] LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Entity_Code ORDER BY Sort ASC) RowNum, Id, Entity_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  

	Select @RecordCount = Count(DISTINCT (Entity_Code )) FROM #Temp
    SET @sort = @sort+' '+@order

	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Entity_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size   

	select Entity_Code,[Entity_Name],Is_Active,ParentEntityCode,Ref_Entity_Key from #Temp

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Entity_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
