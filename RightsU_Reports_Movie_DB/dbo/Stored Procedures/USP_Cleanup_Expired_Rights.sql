-- =============================================
-- Author:		RESHMA KUNJAL
-- Create date: 25 - May - 2017
-- Description:	Delete Expired Expired Rights
-- =============================================

CREATE PROCEDURE [dbo].[USP_Cleanup_Expired_Rights]
AS
BEGIN
	
	CREATE TABLE #Tmp_Avail_Dates (Avail_Dates_Code INT)

	INSERT INTO #Tmp_Avail_Dates (Avail_Dates_Code)
	SELECT Avail_Dates_Code FROM Avail_Dates WHERE End_Date < GETDATE()

	DELETE FROM [dbo].[Avail_Acq_Theatrical_Details]
	WHERE Avail_Raw_Code IN 
	(SELECT Avail_Raw_Code FROM [dbo].[Avail_Raw] where Avail_Dates_Code IN (SELECT Avail_Dates_Code FROM #Tmp_Avail_Dates))

	DELETE FROM [dbo].[Avail_Acq_Details] 
	WHERE Avail_Raw_Code IN 
	(SELECT Avail_Raw_Code FROM [dbo].[Avail_Raw] WHERE Avail_Dates_Code IN (SELECT Avail_Dates_Code FROM #Tmp_Avail_Dates))

	DELETE FROM [dbo].[Avail_Raw] WHERE Avail_Dates_Code IN (SELECT Avail_Dates_Code FROM #Tmp_Avail_Dates)

	DELETE FROM [dbo].[Avail_Dates] WHERE Avail_Dates_Code IN (SELECT Avail_Dates_Code FROM #Tmp_Avail_Dates)
	
END

