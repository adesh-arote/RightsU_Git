CREATE Proc [dbo].[USP_Deal_Expiry_Email_Schedule]
As
Begin

	Exec USP_Deal_Expiry_Email 'D', 'A'

	Exec USP_Deal_Expiry_Email 'D', 'S'

	Exec USP_Deal_Expiry_Email 'D', 'T'

End