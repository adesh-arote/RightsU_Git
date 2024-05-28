CREATE PROCEDURE [dbo].[USPMHNotificationList] 
@UsersCode INT,
@RecordFor NVARCHAR(2),
@UnReadCount INT OUT
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New   where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHNotificationList]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE
		--@UsersCode INT = 1284,
		--@RecordFor NVARCHAR(2) = 'L',
		--@UnReadCount INT-- OUT

		DECLARE @Count INT;
		DECLARE @VendorCode INt;

		SET @VendorCode = (Select Vendor_Code from MHUsers (NOLOCK) where Users_Code = @UsersCode)
		Print 'Vendor Code: '+CAST(@VendorCode AS NVARCHAR)

		IF(@RecordFor = 'N')
			BEGIN
				SET @Count = 5
			END
		ELSE
			BEGIN
				SET @Count = (SELECT COUNT(MHNotificationLogCode) FROM MHNotificationLog (NOLOCK) WHERE Vendor_Code = @VendorCode)
			END
	
		SET @UnReadCount = (SELECT COUNT(MHNotificationLogCode) FROM MHNotificationLog (NOLOCK) WHERE Vendor_Code = @VendorCode AND User_Code = @UsersCode AND Is_Read = 'N')
		print 'Unread Count: ' +CAST(@UnReadCount AS NVARCHAR)

		--SELECT TOP(@Count) MHNotificationLogCode,Subject,U.Login_Name AS UserName,CAST(REPLACE(CONVERT(NVARCHAR,Created_Time, 106),' ', '-') + ' ' +convert(char(5), Created_Time, 108) AS NVARCHAR)  AS CreatedTime,
		--Is_Read AS IsRead, MHRequestCode, MHRequestTypeCode  
		--FROM MHNotificationLog MNL
		--INNER JOIN Users U ON U.Users_Code = MNL.User_Code
		--Where Vendor_Code = @VendorCode AND User_Code = @UsersCode
		--Order BY MNL.Created_Time desc

		SELECT TOP(@Count) MHNotificationLogCode,Subject,UserName, CreatedTime, IsRead, MHRequestCode, MHRequestTypeCode FROM
		(
			SELECT DISTINCT MHNotificationLogCode,Subject,U.Login_Name AS UserName,CAST(REPLACE(CONVERT(NVARCHAR,Created_Time, 106),' ', '-') + ' ' +convert(char(5), Created_Time, 108) AS NVARCHAR)  AS CreatedTime,
			Is_Read AS IsRead, MHRequestCode, MHRequestTypeCode  
			FROM MHNotificationLog MNL (NOLOCK)
			INNER JOIN Users U (NOLOCK) ON U.Users_Code = MNL.User_Code
			Where Vendor_Code = @VendorCode AND User_Code = @UsersCode
		)
		AS A
		Order BY A.MHNotificationLogCode desc
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHNotificationList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO

