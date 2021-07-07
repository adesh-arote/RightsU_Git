CREATE PROCEDURE [dbo].[USPMHMovieAlbumMusicDetailsList] (
	@RequestTypeCode INT, 
	@UsersCode INT
	)
AS
BEGIN
SET FMTONLY OFF
	
	--DECLARE 
	--@RequestTypeCode INT = 2,
	--@UsersCode INT = 293

	

	IF(@RequestTypeCode = 2)
	BEGIN
		EXEC ('SELECT MR.RequestID,ISNULL(MRD.MusicTrackName,'''') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'''') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'''') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'''') AS MusicAlbum,
		CASE WHEN MRD.MovieAlbum = ''A'' THEN ''Album'' ELSE ''Movie'' END AS MovieAlbum,
		CASE 
			WHEN MRD.CreateMap = ''C'' THEN ''Create'' WHEN MRD.CreateMap = ''M'' THEN ''Map'' ELSE ''Pending'' 
		END AS CreateMap,
		CASE 
			WHEN MRD.IsApprove = ''P'' THEN ''Pending''
			WHEN MRD.IsApprove = ''Y'' THEN ''Approve''
			ELSE ''Reject'' 
		END AS Status,ISNULL(U.Login_Name,'''') AS RequestedBy,ISNULL(MR.RequestedDate,'''') AS RequestDate, MRD.Remarks
		FROM MHRequest MR
		LEFT JOIN MHRequestStatus MRS ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
		LEFT JOIN Users U ON U.Users_Code = MR.UsersCode
		LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
		LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
		LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
		WHERE MR.MHRequestTypeCode = '+ @RequestTypeCode +' AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = '+ @UsersCode +') ORDER BY CAST(RequestedDate AS DATETIME) DESC')
	END	
	ELSE 
	BEGIN
		EXEC ('SELECT MR.RequestID,ISNULL(MRD.TitleName,'''') AS RequestedMusicTitleName,ISNULL(MA.Music_Album_Name,'''') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'''') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'''') AS MusicAlbum,
		CASE WHEN MRD.MovieAlbum = ''A'' THEN ''Album'' ELSE ''Movie'' END AS MovieAlbum,
		CASE 
			WHEN MRD.CreateMap = ''C'' THEN ''Create'' WHEN MRD.CreateMap = ''M'' THEN ''Map'' ELSE ''Pending'' 
		END AS CreateMap,
		CASE 
			WHEN MRD.IsApprove = ''P'' THEN ''Pending''
			WHEN MRD.IsApprove = ''Y'' THEN ''Approve''
			ELSE ''Reject'' 
		END AS Status,ISNULL(U.Login_Name,'''') AS RequestedBy,ISNULL(MR.RequestedDate,'''') AS RequestDate, MRD.Remarks
		FROM MHRequest MR
		LEFT JOIN MHRequestStatus MRS ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
		LEFT JOIN Users U ON U.Users_Code = MR.UsersCode
		LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
		LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
		LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
		WHERE MR.MHRequestTypeCode = '+ @RequestTypeCode +' AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = '+ @UsersCode +') ORDER BY CAST(RequestedDate AS DATETIME) DESC')
	END
END
GO

