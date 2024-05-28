CREATE PROCEDURE [dbo].[USPMHMusicTrackList]
@RequestTypeCode INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHMusicTrackList]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF
		SELECT MR.RequestID,COUNT(MRD.MHRequestCode) AS CountRequest,MRS.RequestStatusName AS Status,MRS.RequestStatusName,MR.UsersCode,
		CAST(MR.RequestedDate AS date) AS RequestedDate
		FROM MHRequest MR (NOLOCK)
		LEFT JOIN MHRequestStatus MRS  (NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN MHRequestDetails MRD (NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
		WHERE MR.MHRequestTypeCode = @RequestTypeCode
		GROUP BY MRD.MHRequestCode,MR.RequestID,MRS.RequestStatusName,MRS.RequestStatusName,MR.UsersCode,MR.RequestedDate,MR.MHRequestCode
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHMusicTrackList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
