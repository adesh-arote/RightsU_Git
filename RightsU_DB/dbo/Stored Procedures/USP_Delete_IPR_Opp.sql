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
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel' 

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_IPR_Opp]', 'Step 1', 0, 'Started Procedure', 0, ''
		DELETE FROM IPR_Opp_Attachment WHERE IPR_Opp_Code =@IPR_Opp_Code
		DELETE FROM IPR_Opp_Email_Freq WHERE IPR_Opp_Code =@IPR_Opp_Code
		DELETE FROM IPR_Opp_Status_History WHERE IPR_Opp_Code =@IPR_Opp_Code
		DELETE FROM IPR_Opp WHERE IPR_Opp_Code =@IPR_Opp_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_IPR_Opp]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
