CREATE PROCEDURE [dbo].[USP_Generate_Avail_Data]
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 26 February 2015
-- Description:	This procedure for Generate Available Data by executing another USP 'USP_Avail_Acq_Cache' OR 'USP_Avail_Syn_Cache'
-- =============================================
BEGIN
	DECLARE @Record_Code INT, @Deal_Type CHAR(1), @Is_Amend CHAR(1),@Deal_Right_Code INT
	DECLARE @Approved_Deal_Code INT = 0
	
	SELECT TOP 1 @Approved_Deal_Code = Approved_Deal_Process_Code FROM Approved_Deal_Process WHERE ISNULL(Deal_Status, 'P') = 'P' ORDER BY Deal_Type ASC
	WHILE(@Approved_Deal_Code > 0)
	BEGIN
	
		SELECT TOP 1 @Record_Code = Record_Code, @Deal_Type = Deal_Type, @Is_Amend = Is_Amend, @Deal_Right_Code = Deal_Rights_Code FROM Approved_Deal_Process WHERE Approved_Deal_Process_Code = @Approved_Deal_Code

		IF(@Deal_Type = 'S')
		Begin
			Set @Record_Code = @Deal_Right_Code
		End

		Insert InTo dbo.Process_Schedule
		Select GETDATE(), 'S', @Record_Code, @Deal_Type
		
		EXEC [Usp_Avail_Cache] @Record_Code, @Deal_Type

		IF(@Deal_Type = 'A')
		BEGIN
			Delete From Approved_Deal_Process Where Record_Code = @Record_Code AND Deal_Type = @Deal_Type
		END
		ELSE IF(@Deal_Type = 'S')
		BEGIN
			DELETE FROM Approved_Deal_Process WHERE Deal_Rights_Code = @Record_Code AND Deal_Type = 'S'
		END
		
		Insert InTo dbo.Process_Schedule
		Select GETDATE(), 'D', @Record_Code, @Deal_Type
		
		SET @Approved_Deal_Code = 0
		SELECT TOP 1 @Approved_Deal_Code = Approved_Deal_Process_Code FROM Approved_Deal_Process WHERE ISNULL(Deal_Status, 'P') = 'P' Order By Deal_Type ASC
		
	END
END





