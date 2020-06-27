CREATE PROCEDURE [dbo].[USP_RollBack_Music_Deal]
(
	@Music_Deal_Code INT, 
	@User_Code INT,
	@ErrorMessage NVARCHAR(MAX) OUTPUT
)
AS
/*=============================================
Author		: Abhaysingh N. Rajpurohit 
Create date	: 07 Oct, 2014
Description	: Restore Music Deal to it's last approved state  
=============================================*/
BEGIN
	SET NOCOUNT ON 
	--DECLARE @Music_Deal_Code INT, @User_Code INT,  @ErrorMessage VARCHAR(MAX) = ''
	SET @ErrorMessage = ''
	BEGIN TRAN Audit_Transaction
	BEGIN TRY
		DECLARE @AT_Music_Deal_Code INT = 0
		SELECT TOP 1 @AT_Music_Deal_Code = ISNULL(AT_Music_Deal_Code, 0) FROM AT_Music_Deal WHERE Music_Deal_Code = @Music_Deal_Code
		ORDER BY CAST([Version] AS DECIMAL) DESC

		/* UPDATE Music_Deal */
		UPDATE MD SET
			MD.[Agreement_No]  = AT_MD.[Agreement_No], 
			MD.[Version]  = AT_MD.[Version], 
			MD.[Agreement_Date]  = AT_MD.[Agreement_Date], 
			MD.[Description]  = AT_MD.[Description], 
			MD.[Deal_Tag_Code]  = AT_MD.[Deal_Tag_Code], 
			MD.[Reference_No]  = AT_MD.[Reference_No], 
			MD.[Entity_Code]  = AT_MD.[Entity_Code], 
			MD.[Primary_Vendor_Code]  = AT_MD.[Primary_Vendor_Code], 
			MD.[Music_Label_Code]  = AT_MD.[Music_Label_Code], 
			MD.[Title_Type]  = AT_MD.[Title_Type], 
			MD.[Duration_Restriction]  = AT_MD.[Duration_Restriction], 
			MD.[Rights_Start_Date]  = AT_MD.[Rights_Start_Date], 
			MD.[Rights_End_Date]  = AT_MD.[Rights_End_Date], 
			MD.[Term]  = AT_MD.[Term], 
			MD.[Run_Type]  = AT_MD.[Run_Type], 
			MD.[No_Of_Songs]  = AT_MD.[No_Of_Songs], 
			MD.[Channel_Type]  = AT_MD.[Channel_Type], 
			MD.[Right_Rule_Code]  = AT_MD.[Right_Rule_Code], 
			MD.[Link_Show_Type]  = AT_MD.[Link_Show_Type], 
			MD.[Business_Unit_Code]  = AT_MD.[Business_Unit_Code], 
			MD.[Deal_Type_Code]  = AT_MD.[Deal_Type_Code], 
			MD.[Deal_Workflow_Status]  = AT_MD.[Deal_Workflow_Status], 
			MD.[Work_Flow_Code]  = AT_MD.[Work_Flow_Code], 
			MD.[Parent_Deal_Code]  = AT_MD.[Parent_Deal_Code], 
			MD.[Inserted_By]  = AT_MD.[Inserted_By], 
			MD.[Inserted_On]  = AT_MD.[Inserted_On], 
			MD.[Last_Updated_Time]  = GETDATE(), 
			MD.[Last_Action_By]  = @User_Code, 
			MD.[Lock_Time]  = AT_MD.[Lock_Time],
			MD.[Remarks]  = AT_MD.[Remarks],
			MD.[Agreement_Cost] = AT_MD.[agreement_Cost],
			MD.[Channel_Category_Code] = AT_MD.[Channel_Category_Code],
			MD.[Channel_Or_Category] = AT_MD.[Channel_Or_Category]
		FROM Music_Deal MD
		INNER JOIN AT_Music_Deal AT_MD ON AT_MD.Music_Deal_Code = MD.Music_Deal_Code AND AT_MD.AT_Music_Deal_Code = @AT_Music_Deal_Code

		/* INSERT INTO AT_Music_Deal_Channel */
		DELETE FROM Music_Deal_Channel WHERE Music_Deal_Code = @Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Channel ON

		INSERT INTO Music_Deal_Channel 
		(
			[Music_Deal_Channel_Code], [Music_Deal_Code], [Channel_Code], [Defined_Runs], [Scheduled_Runs]
		)
		SELECT 
			[Music_Deal_Channel_Code], @Music_Deal_Code, [Channel_Code], [Defined_Runs], [Scheduled_Runs]
		FROM AT_Music_Deal_Channel WHERE [AT_Music_Deal_Code] = @AT_Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Channel OFF

		/* INSERT INTO AT_Music_Deal_Country */
		DELETE FROM Music_Deal_Country WHERE Music_Deal_Code = @Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Country ON

		INSERT INTO Music_Deal_Country
		(
			[Music_Deal_Country_Code], [Music_Deal_Code], [Country_Code]
		)
		SELECT 
			[Music_Deal_Country_Code], @Music_Deal_Code, [Country_Code]
		FROM AT_Music_Deal_Country WHERE [AT_Music_Deal_Code] = @AT_Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Country OFF

		/* INSERT INTO AT_Music_Deal_Language */
		DELETE FROM Music_Deal_Language WHERE Music_Deal_Code = @Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Language ON

		INSERT INTO Music_Deal_Language
		(
			[Music_Deal_Language_Code], [Music_Deal_Code], [Music_Language_Code]
		)
		SELECT 
			[Music_Deal_Language_Code], @Music_Deal_Code, [Music_Language_Code]
		FROM AT_Music_Deal_Language WHERE [AT_Music_Deal_Code] = @AT_Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Language OFF

		/* INSERT INTO AT_Music_Deal_LinkShow */
		DELETE FROM Music_Deal_LinkShow WHERE Music_Deal_Code = @Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_LinkShow ON

		INSERT INTO Music_Deal_LinkShow
		(
			[Music_Deal_LinkShow_Code], [Music_Deal_Code], [Title_Code]
		)
		SELECT 
			[Music_Deal_LinkShow_Code], @Music_Deal_Code, [Title_Code]
		FROM AT_Music_Deal_LinkShow WHERE [AT_Music_Deal_Code] = @AT_Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_LinkShow OFF

		/* INSERT INTO AT_Music_Deal_Vendor */
		DELETE FROM Music_Deal_Vendor WHERE Music_Deal_Code = @Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Vendor ON

		INSERT INTO Music_Deal_Vendor
		(
			[Music_Deal_Vendor_Code], [Music_Deal_Code], [Vendor_Code]
		)
		SELECT 
			[Music_Deal_Vendor_Code], @Music_Deal_Code, [Vendor_Code]
		FROM AT_Music_Deal_Vendor WHERE [AT_Music_Deal_Code] = @AT_Music_Deal_Code

		SET IDENTITY_INSERT Music_Deal_Vendor ON

		COMMIT TRAN Audit_Transaction
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Audit_Transaction
		SET @ErrorMessage = 'Error occured in USP_RollBack_Music_Deal stored procedure. Line number : ' + CAST(ERROR_LINE() AS VARCHAR) + 
			' Error message : ' + ERROR_MESSAGE()
	END CATCH
END