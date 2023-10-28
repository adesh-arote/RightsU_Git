CREATE PROCEDURE [dbo].[USPMHMovieAlbumMusicList]
(
	@RequestTypeCode INT, @UsersCode INT
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHMovieAlbumMusicList]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF
		SELECT MR.RequestID,ISNULL(MR.MHRequestCode,0) AS RequestCode,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS RequestedBy,
		ISNULL(MR.RequestedDate,'') AS RequestDate
		FROM MHRequest MR (NOLOCK)
		LEFT JOIN MHRequestStatus MRS (NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN MHRequestDetails MRD (NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
		LEFT JOIN Users U (NOLOCK) ON U.Users_Code = MR.UsersCode
		WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode)
		GROUP BY MRD.MHRequestCode,MR.RequestID,MRS.RequestStatusName,MRS.RequestStatusName,MR.UsersCode,MR.RequestedDate,MR.MHRequestCode,U.Login_Name,MRD.MHRequestCode
		ORDER BY MR.RequestedDate DESC
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHMovieAlbumMusicList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END

