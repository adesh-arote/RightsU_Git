CREATE PROCEDURE USPMHMusicTrackList
@RequestTypeCode INT
AS
BEGIN
SET FMTONLY OFF
	SELECT MR.RequestID,COUNT(MRD.MHRequestCode) AS CountRequest,MRS.RequestStatusName AS Status,MRS.RequestStatusName,MR.UsersCode,
	CAST(MR.RequestedDate AS date) AS RequestedDate
	FROM MHRequest MR
	LEFT JOIN MHRequestStatus MRS ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
	LEFT JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
	WHERE MR.MHRequestTypeCode = @RequestTypeCode
	GROUP BY MRD.MHRequestCode,MR.RequestID,MRS.RequestStatusName,MRS.RequestStatusName,MR.UsersCode,MR.RequestedDate,MR.MHRequestCode
END
