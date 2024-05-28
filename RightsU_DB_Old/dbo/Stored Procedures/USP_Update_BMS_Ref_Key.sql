CREATE PROCEDURE [dbo].[USP_Update_BMS_Ref_Key]
	@Acq_Deal_Code INT
AS
BEGIN
	Select Agreement_No AS AggrementNo,Deal_Desc AS Deal_Description FROM  Acq_Deal WHERE Acq_Deal_Code=@Acq_Deal_Code
END
