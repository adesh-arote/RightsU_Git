--Upload_Files

CREATE PROCEDURE [dbo].[USP_INSERT_UPLOAD_FILES]
( 
 @File_Name VARCHAR(500)
,@Err_YN CHAR(10)
,@Upload_Date DATETIME
,@Uploaded_By INT
,@Upload_Type CHAR(10)
,@Pending_Review_YN CHAR(1)
,@Upload_Record_Count INT
,@Bank_Code INT
,@Records_Inserted INT
,@Records_Updated INT
,@Total_Errors INT
,@ChannelCode INT
,@StartDate DATETIME
,@EndDate DATETIME
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 17-July-2015
-- Description:	Inserts Upload_Files Call From EF Table Mapping
-- =============================================
BEGIN

INSERT INTO Upload_Files
		(
		[File_Name],
		[Err_YN],
		[Upload_Date],
		[Uploaded_By],
		[Upload_Type],
		[Pending_Review_YN],
		[Upload_Record_Count],
		[Bank_Code],
		[Records_Inserted],
		[Records_Updated],
		[Total_Errors],
		[ChannelCode],
		[StartDate],
		[EndDate]
		)
Select 
		@File_Name
		,@Err_YN
		,@Upload_Date
		,@Uploaded_By
		,@Upload_Type
		,@Pending_Review_YN
		,@Upload_Record_Count
		,@Bank_Code
		,@Records_Inserted
		,@Records_Updated
		,@Total_Errors
		,@ChannelCode
		,@StartDate
		,@EndDate

		SELECT SCOPE_IDENTITY() AS File_Code
END
