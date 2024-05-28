CREATE PROCEDURE [dbo].[USP_Title_Content_Version_PI]
(
	@Title_Content_Version_UDT Title_Content_Version_UDT READONLY,
	@UserCode INT
)
AS
------ =============================================
---- author:  ADITYA BANDIBVADEKAR
---- create date: 06 december 2017
---- description: this usp call from title_content_viewcontroller  and check error and insert into title_content_version_udt
---- =============================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Content_Version_PI]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;
		--DECLARE	@Title_Content_Code INT  
		--select top 1 @Title_Content_Code = Title_Content_Code from @Title_Content_Version_UDT
	
		INSERT INTO Title_Content_Version_Details([Title_Content_Version_Code],[House_Id])
		SELECT  [Title_Content_Version_Code], [House_Id] 
		FROM @Title_Content_Version_UDT T
		WHERE
		NOT EXISTS (SELECT * FROM Title_Content_Version_Details TCV (NOLOCK) WHERE T.Title_Content_Version_Code = TCV.Title_Content_Version_Code AND T.House_Id =TCV.House_Id)

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Content_Version_PI]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
