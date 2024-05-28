CREATE PROCEDURE [dbo].[USP_Generate_Avail_Data]
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 26 February 2015
-- Description:	This procedure for Generate Available Data by executing another USP 'USP_Avail_Acq_Cache' OR 'USP_Avail_Syn_Cache'
-- =============================================
BEGIN
	DECLARE @Record_Code INT, @Deal_Type CHAR(1), @Is_Amend CHAR(1),@Deal_Right_Code INT
	DECLARE @Approved_Deal_Code INT = 0, @Title_Code INT = 0

	IF OBJECT_ID('tempdb..#TempTitleAvail') IS NOT NULL DROP TABLE #TempTitleAvail

	CREATE TABLE #TempTitleAvail
	(
		Title_Code INT
	)

	INSERT INTO #TempTitleAvail(Title_Code)
	SELECT DISTINCT Title_Code				--------------------------- Consider Title from Main Deal
	FROM (
		SELECT Title_Code FROM Acq_Deal_Movie 
		WHERE Acq_Deal_Code IN (
			SELECT Record_Code FROM Approved_Deal_Process 
			WHERE ISNULL(Deal_Status, 'P') = 'P' AND Deal_Type = 'A'
		)
		UNION
		SELECT Title_Code FROM Syn_Deal_Rights_Title 
		WHERE Syn_Deal_Rights_Code IN (
			SELECT Deal_Rights_Code FROM Approved_Deal_Process 
			WHERE ISNULL(Deal_Status, 'P') = 'P' AND Deal_Type = 'S'
		)
	) AS a
	UNION
	SELECT DISTINCT Title_Code			--------------------------- Consider Title from existing generated avail for title refresh mail avail
	FROM Avail_Acq WHERE Avail_Acq_Code IN ( 
		SELECT Avail_Acq_Code FROM Avail_Acq_Details 
		WHERE Avail_Raw_Code In (
			SELECT Avail_Raw_Code FROM Avail_Raw 
			WHERE Acq_Deal_Code IN (
				SELECT Record_Code FROM Approved_Deal_Process 
				WHERE ISNULL(Deal_Status, 'P') = 'P' AND Deal_Type = 'A'
			)
			UNION
			SELECT Avail_Raw_Code FROM Avail_Raw 
			WHERE Acq_Deal_Rights_Code IN (
				SELECT Deal_Rights_Code FROM Syn_Acq_Mapping
				WHERE Syn_Deal_Rights_Code IN (
					SELECT Deal_Rights_Code FROM Approved_Deal_Process 
					WHERE ISNULL(Deal_Status, 'P') = 'P' AND Deal_Type = 'S'
				)
			)
		)
	)
	UNION
	SELECT DISTINCT Title_Code		--------------------------- Consider Title from existing generated avail for title refresh theatrical avail
	FROM Avail_Acq_Theatrical WHERE Avail_Acq_Theatrical_Code IN ( 
		SELECT Avail_Acq_Theatrical_Code FROM Avail_Acq_Theatrical_Details 
		WHERE Avail_Raw_Code In (
			SELECT Avail_Raw_Code FROM Avail_Raw 
			WHERE Acq_Deal_Code IN (
				SELECT Record_Code FROM Approved_Deal_Process 
				WHERE ISNULL(Deal_Status, 'P') = 'P' AND Deal_Type = 'A'
			)
			UNION
			SELECT Avail_Raw_Code FROM Avail_Raw 
			WHERE Acq_Deal_Rights_Code IN (
				SELECT Deal_Rights_Code FROM Syn_Acq_Mapping 
				WHERE Syn_Deal_Rights_Code IN (
					SELECT Deal_Rights_Code FROM Approved_Deal_Process 
					WHERE ISNULL(Deal_Status, 'P') = 'P' AND Deal_Type = 'S'
				)
			)
		)
	)

	
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

	DECLARE CurRefreshTitleAvail CURSOR FOR SELECT Title_Code FROM #TempTitleAvail
	OPEN CurRefreshTitleAvail
	FETCH NEXT FROM CurRefreshTitleAvail INTO @Title_Code
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC [dbo].[USPGenerateAvailTitleData] @Title_Code
		FETCH NEXT FROM CurRefreshTitleAvail INTO @Title_Code	
	END
	CLOSE CurRefreshTitleAvail
	DEALLOCATE CurRefreshTitleAvail
	IF OBJECT_ID('tempdb..#TempTitleAvail') IS NOT NULL DROP TABLE #TempTitleAvail
END

