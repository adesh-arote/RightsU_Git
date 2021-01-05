CREATE PROCEDURE [dbo].[USPMHCueSheetList] 
	@ProductionHouseCode INT = 0,
	@MHUploadStatus CHAR(1)='',
	@PageNo INT = 1,
	@PageSize INT = 99,
	@RecordCount INT OUT
AS
-- =============================================
-- Author:  Akshay Rane
-- Create date: 27 June 2018
-- Description: 
-- =============================================
BEGIN  
	SET NOCOUNT ON
	IF(OBJECT_ID('TEMPDB..#TempRightsPagingData') IS NOT NULL)
		DROP TABLE #TempRightsPagingData

	CREATE TABLE #TempRightsPagingData
	(
		Row_No INT IDENTITY(1,1),
		MHCueSheetCode INT,
		RequestID NVARCHAR(40),
		[FileName] NVARCHAR(MAX),
		NoOfRecords INT,
		UploadStatus NVARCHAR(50),
		CreatedBy NVARCHAR(500),
		CreatedOn DATETIME,
		ApprovedBy NVARCHAR(500),
		ApprovedOn DATETIME,
		SpecialInstruction NVARCHAR(MAX)
	)

	IF(@PageNo = 0)
        SET @PageNo = 1

	INSERT INTO #TempRightsPagingData
	(
		MHCueSheetCode, RequestID, [FileName], NoOfRecords, UploadStatus, CreatedBy, CreatedOn, ApprovedBy, ApprovedOn, SpecialInstruction
	)
	SELECT DISTINCT
		MR.MHCueSheetCode,
		MR.RequestID, 
		MR.[FileName],
		(SELECT COUNT(*) FROM MHCueSheetSong MCSS WHERE MR.MHCueSheetCode = MCSS.MHCueSheetCode) AS NoOfRecords,
		CASE WHEN MR.UploadStatus = 'W'  THEN  'Data Error'
			 WHEN MR.UploadStatus = 'S'  THEN  'Submitted'
			 WHEN MR.UploadStatus = 'C'  THEN  'Completed'
			 WHEN MR.UploadStatus = 'P'  THEN  'Pending'
			 ELSE 'Error'
		END,
		V.Vendor_Name +' / '+ U.First_Name,
		MR.CreatedOn,
		UM.First_Name,
		MR.ApprovedOn,
		MR.SpecialInstruction
	FROM MHCueSheet MR
		LEFT JOIN MHUsers MU ON MR.CreatedBy = MU.Users_Code AND MR.VendorCode = MU.Vendor_Code
		LEFT JOIN Users U ON MU.Users_Code = U.Users_Code
		LEFT JOIN Users UM ON MR.ApprovedBy = UM.Users_Code
		LEFT JOIN Vendor V ON V.Vendor_Code = MU.Vendor_Code
	WHERE
		(@ProductionHouseCode = 0 OR MR.VendorCode = @ProductionHouseCode)
		AND (@MHUploadStatus = '' OR MR.UploadStatus = @MHUploadStatus)
		AND MR.UploadStatus not in( 'E','P')
		AND MR.SubmitBy IS NOT NULL
	ORDER By MR.CreatedOn DESC

	SELECT @RecordCount = COUNT(*) FROM #TempRightsPagingData

	DELETE from  #TempRightsPagingData
	WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

	SELECT MHCueSheetCode, RequestID, [FileName], NoOfRecords, UploadStatus, CreatedBy, CreatedOn, SpecialInstruction FROM #TempRightsPagingData

	IF OBJECT_ID('tempdb..#TempRightsPagingData') IS NOT NULL DROP TABLE #TempRightsPagingData
END

--DECLARE @RC INT  
--EXEC USPMHCueSheetList 0,'',1,25,@RC  