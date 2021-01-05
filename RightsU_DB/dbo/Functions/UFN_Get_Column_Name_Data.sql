

CREATE FUNCTION [dbo].[UFN_Get_Column_Name_Data] 
(
	@Columns_Value_Code INT,
	@Is_Defined_Values varchar(10),
	@Record_code INT,
	@Map_Extended_Columns_Code INT
)
RETURNS NVARCHAR(1000)
AS
BEGIN

	DECLARE  @Result NVARCHAR(3000) 
	SET @Result = ''


	IF( @Is_Defined_Values = 'Y' )
	BEGIN
		SELECT @Result = ECV_inner.Columns_Value FROM Extended_Columns_Value ECV_inner WHERE  ECV_inner.Columns_Value_Code = @Columns_Value_Code
	END
	ELSE IF( @Is_Defined_Values = 'N'  )
	BEGIN
		IF( (SELECT TOP 1 Control_Type FROM Extended_Columns WHERE Columns_Code =  @Columns_Value_Code) ='TXT' )
		BEGIN
			SELECT  @Result = Column_Value FROM  Map_Extended_Columns WHERE Record_Code = @Record_code AND Columns_Code = @Columns_Value_Code
		END
		ELSE IF( (SELECT Control_Type FROM Extended_Columns WHERE Columns_Code =  @Columns_Value_Code) ='DDL' )
		BEGIN
			IF(@Columns_Value_Code = 5)
				BEGIN
					SELECT  @Result = @Result + cast(Columns_Value as NVARCHAR(3000)) + ', ' FROM (
					SELECT DISTINCT ECV.Columns_Value FROM Map_Extended_Columns_Details MECD
					INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Columns_Value_Code
					WHERE Map_Extended_Columns_Code in (@Map_Extended_Columns_Code )
					) AS a
				END
			ELSE
				BEGIN
					SELECT  @Result = @Result + cast(Talent_Name as NVARCHAR(3000)) + ', ' FROM (
					SELECT DISTINCT T.Talent_Name FROM Map_Extended_Columns_Details MECD
					INNER JOIN Talent T ON T.Talent_Code = MECD.Columns_Value_Code
					WHERE Map_Extended_Columns_Code in (@Map_Extended_Columns_Code )
					) AS a
				END
			SELECT  @Result = LEFT(@Result , NULLIF(LEN(@Result )-1,-1))		
		END
	END
	RETURN @Result 
END


--select [dbo].[UFN_Get_Column_Name_Data]  (3,'N',2973)
