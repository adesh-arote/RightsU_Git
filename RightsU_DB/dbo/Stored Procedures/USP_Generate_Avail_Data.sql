CREATE PROCEDURE [dbo].[USP_Generate_Avail_Data]
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 26 February 2015
-- Description:	This procedure for Generate Available Data by executing another USP 'USP_Avail_Acq_Cache' OR 'USP_Avail_Syn_Cache'
-- =============================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Generate_Avail_Data]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @Record_Code INT, @Deal_Type CHAR(1), @Is_Amend CHAR(1)
		DECLARE @Approved_Deal_Code INT = 0
		SELECT TOP 1 @Approved_Deal_Code = Approved_Deal_Code FROM Approved_Deal (NOLOCK) WHERE ISNULL(Deal_Status, 'P') = 'P'
		WHILE(@Approved_Deal_Code > 0)
		BEGIN
			PRINT 'Approver_Deal_Code = ' + CAST(@Approved_Deal_Code AS VARCHAR)
			SELECT TOP 1 @Record_Code = Record_Code, @Deal_Type = Deal_Type, @Is_Amend = Is_Amend FROM Approved_Deal (NOLOCK) WHERE Approved_Deal_Code = @Approved_Deal_Code
			IF(@Deal_Type = 'A')
			BEGIN
				PRINT 'Calling USP_Avail_Acq_Cache for Acq_Deal_Code = ' + CAST( @Record_Code AS VARCHAR) + ' and Is_Amend = ' + @Is_Amend
				EXEC USP_Avail_Acq_Cache @Record_Code, @Is_Amend

			END
			ELSE IF(@Deal_Type = 'S')
			BEGIN
				PRINT 'Calling USP_Avail_Syn_Cache for Syn_Deal_Code = ' + CAST( @Record_Code AS VARCHAR) + ' and Is_Amend = ' + @Is_Amend
				EXEC USP_Avail_Syn_Cache @Record_Code, @Is_Amend
			END
			ELSE
				PRINT 'ERROR : Unknown Deal Type'

			UPDATE Approved_Deal SET Deal_Status = 'D' WHERE Approved_Deal_Code = @Approved_Deal_Code
			PRINT 'Updated Deal_Status =  ''D'' of ''Approved_Deal'' table for Approver_Deal_Code = ' + CAST(@Approved_Deal_Code AS VARCHAR)
			PRINT ''
			SET @Approved_Deal_Code = 0
			SELECT TOP 1 @Approved_Deal_Code = Approved_Deal_Code FROM Approved_Deal (NOLOCK) WHERE ISNULL(Deal_Status, 'P') = 'P'
		END
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Generate_Avail_Data]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
