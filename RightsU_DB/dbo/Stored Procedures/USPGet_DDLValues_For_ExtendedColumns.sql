CREATE PROCEDURE [dbo].[USPGet_DDLValues_For_ExtendedColumns]
(
	@ExtendedColumnsCode INT
)
AS
BEGIN
		
/*---------------------------
Author			 : Prathamesh Naik
Created On		 : 14/April/2023
Description		 : Generates List with Column Name as ColumnsValue and Columns_Value_Code for Dropdown in Additional Info in Party Master for Content Rule Tab
Last Modified On : 15/April/2023
Last Change		 : Created Temporary Table to store and return selected values
---------------------------*/

SET FMTONLY OFF 
SET NOCOUNT ON 

IF(OBJECT_ID('tempdb..#TempColValNameTbl') IS NOT NULL) DROP TABLE #TempColValNameTbl

CREATE table #TempColValNameTbl(
	ColumnsValue VARCHAR(1000),
	Columns_Value_Code INT
)

	DECLARE @RefTable VARCHAR(1000);
	DECLARE @RefDisplayField VARCHAR(100);
	DECLARE @RefValueField VARCHAR(100);
	DECLARE @AdditionalCondition VARCHAR(100);
	DECLARE @ListQuery NVARCHAR(MAX);
	DECLARE @IsDefinedValue VARCHAR(5);
	
	SELECT @RefTable = ec.Ref_Table, @RefDisplayField = ec.Ref_Display_Field, @RefValueField = ec.Ref_Value_Field, @AdditionalCondition = ec.Additional_Condition, @IsDefinedValue = ec.Is_Defined_Values
	FROM Extended_Columns ec WHERE ec.Columns_Code = @ExtendedColumnsCode;
	
	--SELECT @RefTable, @RefDisplayField, @RefValueField, @AdditionalCondition;
	
	IF ((@AdditionalCondition IS NULL OR @AdditionalCondition = '') AND @IsDefinedValue = 'N')
		BEGIN
			INSERT INTO #TempColValNameTbl EXEC('SELECT ' + @RefDisplayField + ' AS ColumnsValue ,' + @RefValueField + ' AS Columns_Value_Code FROM ' + @RefTable);
		END
	ELSE IF(@RefTable = 'TALENT')
		BEGIN
			INSERT INTO #TempColValNameTbl EXEC('SELECT t.' + @RefDisplayField + ' AS ColumnsValue , t.' + @RefValueField + ' AS Columns_Value_Code FROM ' + @RefTable + ' t INNER JOIN Talent_Role tr ON tr.Talent_Code = t.Talent_Code AND tr.Role_Code = ' + @AdditionalCondition);
		END
	ELSE IF(@IsDefinedValue = 'Y')
		BEGIN
			INSERT INTO #TempColValNameTbl SELECT ecv.Columns_Value, ecv.Columns_Value_Code FROM Extended_Columns_Value ecv WHERE ecv.Columns_Code = @ExtendedColumnsCode
		END
	ELSE
		BEGIN
			INSERT INTO #TempColValNameTbl EXEC('SELECT ' + @RefDisplayField + ' AS ColumnsValue ,' + @RefValueField + ' AS Columns_Value_Code FROM ' + @RefTable + ' WHERE 1 = 1 ' + @AdditionalCondition);
		END

	SELECT * FROM #TempColValNameTbl

END