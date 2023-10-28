CREATE PROCEDURE [dbo].[USPITGetSearchSequence]
@BVCode INT,
@ColumnCode INT,
@Type VARCHAR(10)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetSearchSequence]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--DECLARE
		--@BVCode INT = 19,
		--@ColumnCode INT = 1277,
		--@Type VARCHAR(10) = 'PR'

		SELECT rcs.Display_Name,it.Display_Order,it.IsMandatory,it.IsSkip,it.IsSkipAll 
		FROM IT_FilterSequence it WITH(NOLOCK)
		INNER JOIN Report_Column_Setup_IT rcs WITH(NOLOCK) ON rcs.Column_Code = IT.Column_Code_Seq
		WHERE it.BVAttribGroupCode = @BVCode AND it.Column_Code = @ColumnCode
		AND IT.Type = @Type
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetSearchSequence]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END