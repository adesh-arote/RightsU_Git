ALTER PROCEDURE [dbo].[USPAPI_Platform]
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
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Platform]', 'Step 1', 0, 'Started Procedure', 0, '' 

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
		Platform_Code	INT,
		Platform_Name  VARCHAR (100),
		Is_No_Of_Run  CHAR (1),
		Applicable_For_Holdback  CHAR (1),
		Applicable_For_Demestic_Territory CHAR (1),
		Applicable_For_Asrun_Schedule	 CHAR (1),
		Parent_Platform_Code INT,
		Is_Last_Level	CHAR (1),
		Module_Position	VARCHAR (10),
		Base_Platform_Code	INT,
		Platform_Hiearachy	 VARCHAR (2000),
		Is_Sport_Right	CHAR (1),
		Is_Applicable_Syn_Run CHAR (1),
		Is_Active CHAR (1),
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
			SET @SQL_Condition ='AND (Platform_Code IN (select Platform_Code from Platform where Platform_Name Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Platform_Code = '+CAST(@id as VARCHAR(20))
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Platform_Code,Platform_Name,Is_No_Of_Run,Applicable_For_Holdback,Applicable_For_Demestic_Territory,Applicable_For_Asrun_Schedule,Parent_Platform_Code,Is_Last_Level,Module_Position,Base_Platform_Code,Platform_Hiearachy,Is_Sport_Right,Is_Applicable_Syn_Run,Is_Active,Last_Updated_Time,Inserted_On	,''1'','' '' from Platform where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Platform_Name LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Platform_Code ORDER BY Sort ASC) RowNum, Id, Platform_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  

	Select @RecordCount = Count(DISTINCT (Platform_Code )) FROM #Temp
    SET @sort = @sort+' '+@order

	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Platform_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)

	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size   

	select Platform_Code, Platform_Name, Is_No_Of_Run, Applicable_For_Holdback, Applicable_For_Demestic_Territory,Applicable_For_Asrun_Schedule,Parent_Platform_Code,Is_Last_Level,Module_Position,Base_Platform_Code,
	Platform_Hiearachy,Is_Sport_Right,Is_Applicable_Syn_Run,Is_Active from #Temp

    if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_Platform]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END