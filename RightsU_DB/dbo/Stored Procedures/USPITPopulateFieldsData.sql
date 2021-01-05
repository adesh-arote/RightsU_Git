CREATE Procedure USPITPopulateFieldsData
@View_Name NVARCHAR(MAX),
@List_Source NVARCHAR(MAX) ,
@Lookup_Column NVARCHAR(MAX),
@Display_Column NVARCHAR(MAX),
@WhCondition NVARCHAR(MAX)
AS
BEGIN
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

	
END



--EXEC USPITGetFields ''
