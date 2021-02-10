Create Proc [dbo].[USP_Run_Avail]
As
Begin

	Exec [dbo].[Usp_Drop_Create_Tables]

	Exec [dbo].[Usp_CreateIndexes_AcqSyn]

	Exec [dbo].[USP_Generate_Avail_Data]

End

