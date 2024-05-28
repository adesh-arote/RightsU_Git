CREATE PROCEDURE [dbo].[USP_INSERT_UPLOAD_ERR_DETAIL]
( 
 @File_Code BIGINT
,@Row_Num INT
,@Row_Delimed VARCHAR(MAX)
,@Err_Cols VARCHAR(MAX)
,@Upload_Type CHAR(10)
,@Upload_Title_Type VARCHAR(5)
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 17-July-2015
-- Description:	Inserts Upload_Err_Detail Call From EF Table Mapping
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_INSERT_UPLOAD_ERR_DETAIL]', 'Step 1', 0, 'Started Procedure', 0, ''

	INSERT INTO Upload_Err_Detail
			(
			[File_Code]
			,[Row_Num]
			,[Row_Delimed]
			,[Err_Cols]
			,[Upload_Type]
			,[Upload_Title_Type]
			)
	Select 
			 @File_Code
			,@Row_Num
			,@Row_Delimed
			,@Err_Cols
			,@Upload_Type
			,@Upload_Title_Type

			SELECT SCOPE_IDENTITY() AS Upload_Detail_Code
		 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_INSERT_UPLOAD_ERR_DETAIL]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
