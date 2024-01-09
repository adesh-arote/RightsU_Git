CREATE PROCEDURE [dbo].[USPAPI_Deal_Type]
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
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Deal_Type]', 'Step 1', 0, 'Started Procedure', 0, '' 
	
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	DECLARE @Condition NVARCHAR(MAX) = '';
	DECLARE @delimt NVARCHAR(2) = N',' 

	SET @Condition  += ' '
	IF(@page = 0)
	BEGIN
		SET @page = 1      
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id INT Identity(1,1),  
		Deal_Type_Code	INT,
		Deal_Type_Name  VARCHAR (100),
		Is_Default	 CHAR(1),
		Is_Grid_Required  CHAR(1),
		Is_Active CHAR(1),
		Is_Master_Deal CHAR(1),
		Parent_Code INT,
		Deal_Or_Title VARCHAR (5),
		Deal_Title_Mapping_Code Int,
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
			SET @SQL_Condition ='AND (Deal_Type_Code IN (select Deal_Type_Code from Deal_Type where Deal_Type_Name Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Deal_Type_Code = '+CAST(@id as VARCHAR(20))
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Deal_Type_Code,Deal_Type_Name,Is_Default,Is_Grid_Required,Is_Active,Is_Master_Deal,Parent_Code,Deal_Or_Title,Deal_Title_Mapping_Code,Last_Updated_Time,Inserted_On,''1'','' '' from Deal_Type where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Deal_Type_Name LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Deal_Type_Code ORDER BY Sort ASC) RowNum, Id, Deal_Type_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  

	Select @RecordCount = Count(DISTINCT (Deal_Type_Code )) FROM #Temp
    SET @sort = @sort+' '+@order

	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Deal_Type_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size   

	select Deal_Type_Code, Deal_Type_Name, Is_Default, Is_Grid_Required, Is_Active, Is_Master_Deal, Parent_Code, Deal_Or_Title, Deal_Title_Mapping_Code from #Temp

    if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Deal_Type]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END

