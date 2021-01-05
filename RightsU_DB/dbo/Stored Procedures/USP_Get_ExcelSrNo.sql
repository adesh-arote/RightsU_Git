CREATE PROCEDURE USP_Get_ExcelSrNo(
	@DM_Master_Import_Code INT,
	@Keyword VARCHAR(MAX),
	@CallFor VARCHAR(MAX)
)
AS
BEGIN
		--DECLARE @DM_Master_Import_Code INT=10164, @Keyword NVARCHAR(MAX)=''
		SELECT A.ExcelLineNo FROM (
				SELECT  Col1 AS ExcelLineNo, CONCAT(Col2,'-',Col3,'-',Col4,'-',Col5,'-',Col6,'-',Col7,'-',Col8,'-',Col9,'-',Col10,'-',Col11,'-',Col12,'-',Col13,'-',Col14,'-',Col15,'-',Col17,'-',Col18,'-',Col19,'-',Col20,'-',Col21,'-',Col22,'-',Col23,'-',Col24,'-',Col25,'-',Col26,'-',Col27,'-',Col28,'-',Col29,'-',Col30,'-',Col31,'-',Col32,'-',Col33) As [Concatenate]
				FROM DM_Title_Import_Utility_Data 
				WHERE DM_Master_Import_Code= @DM_Master_Import_Code AND ISNUMERIC(Col1) = 1
			) AS A WHERE A.Concatenate LIKE '%' + @Keyword +'%' 
END