CREATE Procedure [dbo].[USPITPopulateFieldsData]
@View_Name NVARCHAR(MAX),
@List_Source NVARCHAR(MAX) ,
@Lookup_Column NVARCHAR(MAX),
@Display_Column NVARCHAR(MAX),
@WhCondition NVARCHAR(MAX)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITPopulateFieldsData]', 'Step 1', 0, 'Started Procedure', 0, ''
		--EXEC USPITGetFields 'Acquisition'
		--DECLARE @temp NVARCHAR(MAX) 
		--Select @temp = WhCondition FROM Report_Column_Setup WHERE Column_Code = 1408
		--Select @temp
		--SELECT '1' AS ValueField,'India' AS TextField
		DECLARE @ExecSql NVARCHAR(MAX) = ''

		IF(@WhCondition = '')
		BEGIN
			SET @ExecSql = N'SELECT '+@Lookup_Column+' AS ValueField,'+@Display_Column+' AS TextField FROM '+@List_Source+' '
		END
		ELSE
		BEGIN
			SET @ExecSql = N'SELECT '+@Lookup_Column+' AS ValueField,'+@Display_Column+' AS TextField FROM '+@List_Source+' Where 1=1 AND '+ @WhCondition+' '
		END
	
		Print @ExecSql

		EXEC sp_executesql @ExecSql
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITPopulateFieldsData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
