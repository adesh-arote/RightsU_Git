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
END