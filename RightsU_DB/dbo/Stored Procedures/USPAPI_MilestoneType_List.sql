﻿CREATE PROCEDURE [dbo].[USPAPI_MilestoneType_List]
	@order VARCHAR(10) = NULL,
	@page INT = NULL,
	@search_value NVARCHAR(MAX) = NULL,
	@size INT = NULL,
	@sort VARCHAR (100) = NULL,
	@RecordCount INT = NULL OUT,
	@id INT = NULL
	As
BEGIN
Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_MilestoneType_List]', 'Step 1', 0, 'Started Procedure', 0, '' 

	
	if(@page = 0)
	BEGIN
		SET @page = 1      
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id Int Identity(1,1),      
		Milestone_Type_Code Varchar(200),  
		Milestone_Type_Name  Varchar(200),  
		Is_Automated  Varchar(200),  
		Is_Active  Varchar(200),  
		Sort varchar(10),  
		Row_Num Int,  
	);  

	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition =''

	IF(ISNULL(@id,0) = 0)
	BEGIN
	   IF(ISNULL(@search_value,'')<>'')
	   BEGIN
			SET @SQL_Condition ='AND (Milestone_Type_Code IN (select Milestone_Type_Code from Milestone_Type where Milestone_Type_Name Like N''%' + @search_value+ '%''))'
		END
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND Milestone_Type_Code = '+CAST(@id as VARCHAR(20))
		--PRINT @SQL_Condition
	END

	Declare @SqlPageNo NVARCHAR(MAX) 
	Set @SqlPageNo ='Insert InTo #Temp  select Milestone_Type_Code,Milestone_Type_Name,Is_Automated,Is_Active,''1'','' '' from Milestone_Type where 1=1 '+@SQL_Condition+' ';
	Exec(@SqlPageNo);

	SET @search_value = '%'+@search_value+'%' 
	UPDATE #Temp SET Sort = '0' WHERE Milestone_Type_Name LIKE @search_value

	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY Milestone_Type_Code ORDER BY Sort ASC) RowNum, Id, Milestone_Type_Code, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  

	Select @RecordCount = Count(DISTINCT (Milestone_Type_Code )) FROM #Temp
        SET @sort = @sort+' '+@order

		DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', Milestone_Type_Code ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id'

	EXEC(@UpdateRowNum)
	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size     

	select Milestone_Type_Code,Milestone_Type_Name,Is_Automated,Is_Active from #Temp

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAPI_MilestoneType_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END