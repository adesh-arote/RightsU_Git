CREATE PROCEDURE [dbo].[USP_RightsU_Health_Checkup_Mail](@recipients VARCHAR(1000), @copy_recipients VARCHAR(1000), @subject VARCHAR(1000), @body VARCHAR(MAX))
AS
BEGIN
	Declare @Loglevel  int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel <2)Exec [USPLogSQLSteps] '[USP_RightsU_Health_Checkup_Mail]', 'Step 1', 0, 'Started Procedure', 0, ''

		INSERT INTO Notifications (NotificationType, TransCode, TransType, UserCode, Email, CC, BCC, [Subject], HtmlBody, CreatedOn, ModifiedOn, NoOfRetry, API_Status, IsReminderMail, IsSend, IsRead, IsAutoEscalated)
		SELECT distinct 'Email_NTF', 0, 0, 0, ISNULL(@recipients ,''), ISNULL(@copy_recipients ,''), '', @subject, @body, GETDATE(), GETDATE(),0 ,'P' , 0, 0, 0, 0 

	if(@Loglevel <2)Exec [USPLogSQLSteps] '[USP_RightsU_Health_Checkup_Mail]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END