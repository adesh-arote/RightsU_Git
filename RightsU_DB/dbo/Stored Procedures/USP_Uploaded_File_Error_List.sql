CREATE PROCEDURE [dbo].[USP_Uploaded_File_Error_List]
(
	@Upload_Detail_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 21 May 2015
-- Description:	List of All Uploaded File
-- =============================================
BEGIN
	Declare @Loglevel  int; 

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Uploaded_File_Error_List]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET FMTONLY OFF
		DECLARE @Err_Cols VARCHAR(MAX) = '', @uploadType VARCHAR(MAX)
	
		select @Err_Cols = Err_Cols, @uploadType = Upload_Type from Upload_Err_Detail UED (NOLOCK)
		WHERE UED.Upload_Detail_Code = @Upload_Detail_Code

		SELECT number AS ERR_Code into #tblError_Code FROM DBO.fn_Split_withdelemiter(@Err_Cols, '~')

		SELECT DISTINCT EC.ERR_Code AS Error_Code,  EM.error_description AS Error_Description FROM #tblError_Code EC
		INNER JOIN Error_Code_Master EM  (NOLOCK) ON EC.ERR_Code = EM.upload_error_code AND error_for = @uploadType

		IF OBJECT_ID('tempdb..#tblError_Code') IS NOT NULL DROP TABLE #tblError_Code
	 
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Uploaded_File_Error_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END