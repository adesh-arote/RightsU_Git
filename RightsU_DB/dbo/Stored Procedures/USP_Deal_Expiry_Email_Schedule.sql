
CREATE Proc [dbo].[USP_Deal_Expiry_Email_Schedule]
As
Begin
 Exec [USPLogSQLSteps] '[USP_Deal_Expiry_Email_Schedule]', 'Step 1', 0, 'Started Procedure', 0, ''
	Exec USP_Deal_Expiry_Email 'D', 'ACE'

	Exec USP_Deal_Expiry_Email 'D', 'SYE'

	Exec USP_Deal_Expiry_Email 'D', 'AROD'

	Exec USP_Deal_Expiry_Email 'D', 'TER'

	Exec USP_Deal_Expiry_Email 'D', 'SROD'

	/*********Holdback Related Email**********/

	Exec USP_HoldbackExpiryMail 'D', 'SRHB'

	Exec USP_HoldbackExpiryMail 'D', 'ARHB'

	Exec USP_HoldbackExpiryMail 'D', 'SHB'

	Exec USP_HoldbackExpiryMail 'D', 'AHB'

	Exec [USPLogSQLSteps] '[USP_Deal_Expiry_Email_Schedule]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End
