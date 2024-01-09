CREATE PROCEDURE [dbo].[USPAPI_Deal_Tag]
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
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Deal_Tag]', 'Step 1', 0, 'Started Procedure', 0, '' 

	DECLARE @Condition NVARCHAR(MAX) = '';
	DECLARE @delimt NVARCHAR(2) = N',' 

	SET @Condition  += ' '
	if(@page = 0)
	BEGIN
		SET @page = 1      
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id Int Identity(1,1),      
		Deal_Tag_Code Varchar(200),  
		Deal_Tag_Description  Varchar(200),  
		Deal_Flag  Varchar(200),  
		Sort varchar(10),  
		Row_Num Int,  
	);  

	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition =''

	IF(ISNULL(@id,0) = 0)
	BEGIN
	   IF(ISNULL(@search_value,'')<>'')
	   BEGIN
			SET @SQL_Condition ='AND (Deal_Tag_Code IN (select Deal_Tag_Code from Deal_Tag where Deal_Tag_Description Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Deal_Tag_Code = '+CAST(@id as VARCHAR(20))
		--PRINT @SQL_Condition
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Deal_Tag_Code,Deal_Tag_Description,Deal_Flag,''1'','' '' from Deal_Tag where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Deal_Tag_Description LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Deal_Tag_Code ORDER BY Sort ASC) RowNum, Id, Deal_Tag_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  

	Select @RecordCount = Count(DISTINCT (Deal_Tag_Code )) FROM #Temp
    SET @sort = @sort+' '+@order


	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Deal_Tag_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size   

	select Deal_Tag_Code,Deal_Tag_Description,Deal_Flag from #Temp

    if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Deal_Tag]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
