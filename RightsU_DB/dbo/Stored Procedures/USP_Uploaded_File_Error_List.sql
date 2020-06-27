--DROP FUNCTION UFN_Get_Error_Description
CREATE PROCEDURE USP_Uploaded_File_Error_List
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
	SET FMTONLY OFF
	DECLARE @Err_Cols VARCHAR(MAX) = '', @uploadType VARCHAR(MAX)
	
	select @Err_Cols = Err_Cols, @uploadType = Upload_Type from Upload_Err_Detail UED
	WHERE UED.Upload_Detail_Code = @Upload_Detail_Code

	SELECT number AS ERR_Code into #tblError_Code FROM DBO.fn_Split_withdelemiter(@Err_Cols, '~')

	SELECT DISTINCT EC.ERR_Code AS Error_Code,  EM.error_description AS Error_Description FROM #tblError_Code EC
	INNER JOIN Error_Code_Master EM ON EC.ERR_Code = EM.upload_error_code AND error_for = @uploadType
END