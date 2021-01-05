

CREATE PROCEDURE [dbo].[USPMHMovieAlbumMusicList] (@RequestTypeCode INT, @UsersCode INT)
AS
BEGIN
SET FMTONLY OFF
	SELECT MR.RequestID,ISNULL(MR.MHRequestCode,0) AS RequestCode,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS RequestedBy,
	ISNULL(MR.RequestedDate,'') AS RequestDate
	FROM MHRequest MR
	LEFT JOIN MHRequestStatus MRS ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
	LEFT JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
	LEFT JOIN Users U ON U.Users_Code = MR.UsersCode
	WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
	GROUP BY MRD.MHRequestCode,MR.RequestID,MRS.RequestStatusName,MRS.RequestStatusName,MR.UsersCode,MR.RequestedDate,MR.MHRequestCode,U.Login_Name,MRD.MHRequestCode
	ORDER BY MR.RequestedDate DESC
END

