CREATE PROCEDURE [dbo].[USP_AT_Music_Deal]
(
	@Music_Deal_Code INT, 
	@Is_Error VARCHAR(1) OUTPUT
)
AS
/*=============================================
Author		: Abhaysingh N. Rajpurohit 
Create date	: 07 Oct, 2014
Description	: Insert data of Music Deal module in AT table of Music Deal module
=============================================*/
BEGIN
	SET NOCOUNT ON 
	--DECLARE @Music_Deal_Code INT, @Is_Error VARCHAR(1) = ''

	BEGIN TRAN Audit_Transaction
	BEGIN TRY
		/* INSERT INTO AT_Music_Deal */
		INSERT INTO AT_Music_Deal
		(	
			[Agreement_No], [Version], [Agreement_Date], [Description], [Deal_Tag_Code], [Reference_No], [Entity_Code], [Primary_Vendor_Code], 
			[Music_Label_Code], [Title_Type], [Duration_Restriction], [Rights_Start_Date], [Rights_End_Date], [Term], [Run_Type], [No_Of_Songs], [Channel_Type], 
			[Right_Rule_Code], [Link_Show_Type], [Business_Unit_Code], [Deal_Type_Code], [Deal_Workflow_Status], [Work_Flow_Code], [Parent_Deal_Code], 
			[Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By], [Lock_Time], [Remarks],[Agreement_Cost],[Channel_Category_Code],[Channel_Or_Category], [Music_Deal_Code]
		)
		SELECT 
			[Agreement_No], [Version], [Agreement_Date], [Description], [Deal_Tag_Code], [Reference_No], [Entity_Code], [Primary_Vendor_Code], 
			[Music_Label_Code], [Title_Type], [Duration_Restriction], [Rights_Start_Date], [Rights_End_Date], [Term], [Run_Type], [No_Of_Songs], [Channel_Type], 
			[Right_Rule_Code], [Link_Show_Type], [Business_Unit_Code], [Deal_Type_Code], [Deal_Workflow_Status], [Work_Flow_Code], [Parent_Deal_Code], 
			[Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By], [Lock_Time], [Remarks],[Agreement_Cost],[Channel_Category_Code],[Channel_Or_Category], [Music_Deal_Code]
		FROM Music_Deal WHERE Music_Deal_Code = @Music_Deal_Code
			
		DECLARE @AT_Music_Deal_Code INT = 0
		SELECT @AT_Music_Deal_Code = IDENT_CURRENT('AT_Music_Deal')

		/* INSERT INTO AT_Music_Deal_Channel */
		INSERT INTO AT_Music_Deal_Channel 
		(
			[AT_Music_Deal_Code], [Channel_Code], [Defined_Runs], [Scheduled_Runs], [Music_Deal_Channel_Code]
		)
		SELECT 
			@AT_Music_Deal_Code, [Channel_Code], [Defined_Runs], [Scheduled_Runs], [Music_Deal_Channel_Code]
		FROM Music_Deal_Channel WHERE Music_Deal_Code = @Music_Deal_Code

		/* INSERT INTO AT_Music_Deal_Country */
		INSERT INTO AT_Music_Deal_Country
		(
			[AT_Music_Deal_Code], [Country_Code], [Music_Deal_Country_Code]
		)
		SELECT 
			@AT_Music_Deal_Code, [Country_Code], [Music_Deal_Country_Code]
		FROM Music_Deal_Country WHERE Music_Deal_Code = @Music_Deal_Code

		/* INSERT INTO AT_Music_Deal_Language */
		INSERT INTO AT_Music_Deal_Language
		(
			[AT_Music_Deal_Code], [Music_Language_Code], [Music_Deal_Language_Code]
		)
		SELECT 
			@AT_Music_Deal_Code, [Music_Language_Code], [Music_Deal_Language_Code]
		FROM Music_Deal_Language WHERE Music_Deal_Code = @Music_Deal_Code

		/* INSERT INTO AT_Music_Deal_LinkShow */
		INSERT INTO AT_Music_Deal_LinkShow
		(
			[AT_Music_Deal_Code], [Title_Code], [Music_Deal_LinkShow_Code]
		)
		SELECT 
			@AT_Music_Deal_Code, [Title_Code], [Music_Deal_LinkShow_Code]
		FROM Music_Deal_LinkShow WHERE Music_Deal_Code = @Music_Deal_Code

		/* INSERT INTO AT_Music_Deal_Vendor */
		INSERT INTO AT_Music_Deal_Vendor
		(
			[AT_Music_Deal_Code], [Vendor_Code], [Music_Deal_Vendor_Code]
		)
		SELECT 
			@AT_Music_Deal_Code, [Vendor_Code], [Music_Deal_Vendor_Code]
		FROM Music_Deal_Vendor WHERE Music_Deal_Code = @Music_Deal_Code
		SET @Is_Error = 'N'
		COMMIT TRAN Audit_Transaction
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Audit_Transaction
		SET @Is_Error = 'Y'
	END CATCH
END