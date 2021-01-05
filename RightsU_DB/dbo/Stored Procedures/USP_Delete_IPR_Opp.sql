CREATE PROCEDURE [dbo].[USP_Delete_IPR_Opp]
(
	@IPR_Opp_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N Rajpurohit
-- Create DATE: 19 Aug 2015
-- Description:	DELETE IPR_Opp Calling From EF 
-- =============================================
BEGIN
	DELETE FROM IPR_Opp_Attachment WHERE IPR_Opp_Code =@IPR_Opp_Code
	DELETE FROM IPR_Opp_Email_Freq WHERE IPR_Opp_Code =@IPR_Opp_Code
	DELETE FROM IPR_Opp_Status_History WHERE IPR_Opp_Code =@IPR_Opp_Code
	DELETE FROM IPR_Opp WHERE IPR_Opp_Code =@IPR_Opp_Code
END
