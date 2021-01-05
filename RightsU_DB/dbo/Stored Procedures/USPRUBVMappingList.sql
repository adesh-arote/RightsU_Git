CREATE PROCEDURE [dbo].[USPRUBVMappingList] 
--DECLARE
   @DropdownOption VARCHAR(20)='',
    @Tabselect VARCHAR(50)='',
	@PageNo INT=1,
	@PageSize INT = 10,
	@RecordCount INT OUT
AS
BEGIN
	IF(OBJECT_ID('TEMPDB..#TempRUBVMappingData') IS NOT NULL)
		DROP TABLE #TempRUBVMappingData
	IF(OBJECT_ID('TEMPDB..#Label') IS NOT NULL)
		DROP TABLE #Label
				SET NOCOUNT ON;
	CREATE TABLE #TempRUBVMappingData
	(
		Row_No INT IDENTITY(1,1),
		Title VARCHAR(MAX),                                      
		EpisodeNo INT,
		RUID INT,
		BVID INT,
		ErrorDescription VARCHAR(MAX),
		RecordStatus VARCHAR(MAX) ,
		LicenseRefNo NVARCHAR(50) ,
		RequestTime DATETIME,
		StartDate DATETIME,
		EndDate DATETIME,
		ChannelCode INT,
		VendorName  VARCHAR(MAX)
	)
	IF(@Tabselect='Asset')
	BEGIN
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(Title, EpisodeNo, BVID, RUID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Title, Episode_Number, BMS_Asset_Ref_Key, BMS_Asset_Code, Request_Time, Error_Description, 
			CASE WHEN Record_Status='E' THEN 'Error'  END AS Record_Status 
			FROM BMS_Asset WHERE Record_Status = 'E' order by BMS_Asset_Code desc;
		END
		ELSE IF(@DropdownOption='M')
		BEGIN
			INSERT INTO #TempRUBVMappingData(Title, EpisodeNo, BVID, RUID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Title, Episode_Number, BMS_Asset_Ref_Key, BMS_Asset_Code,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status
			FROM BMS_Asset WHERE BMS_Asset_Ref_Key=0 OR BMS_Asset_Ref_Key IS NULL order by BMS_Asset_Code desc;
		END
		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(Title, EpisodeNo, BVID, RUID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Title, Episode_Number, BMS_Asset_Ref_Key, BMS_Asset_Code,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status
			FROM BMS_Asset WHERE  Record_Status IN ('P','W') order by BMS_Asset_Code desc;
		END
	END
  IF(@Tabselect='Deal')
	BEGIN
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID, RequestTime, ErrorDescription, RecordStatus)
			SELECT Lic_Ref_No,  BMS_Deal_Code, BMS_Deal_Ref_Key,Request_Time, Error_Description, 
			CASE WHEN Record_Status='E' THEN 'Error'  END AS Record_Status  
			FROM BMS_Deal	WHERE Record_Status = 'E' order by BMS_Deal_Code desc;
		END
		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Lic_Ref_No,  BMS_Deal_Code, BMS_Deal_Ref_Key,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status 
			FROM BMS_Deal WHERE  Record_Status IN ('P','W') order by BMS_Deal_Code desc;
		END
    END 	
	IF(@Tabselect='Content')
	BEGIN
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID,RequestTime, Title,EpisodeNo,StartDate,EndDate, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, C.BMS_Deal_Code, C.BMS_Deal_Content_Ref_Key,C.Request_Time, C.Title,A.Episode_No,  C.Start_Date, C.End_Date , C.Error_Description, 
			CASE WHEN C.Record_Status='E' THEN 'Error'  END AS Record_Status  FROM BMS_Deal_Content C 
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	ON C.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status = 'E' order by A.BMS_Asset_Code desc;
		END

		ELSE IF(@DropdownOption='P')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID, RequestTime,Title,EpisodeNo,StartDate,EndDate, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, C.BMS_Deal_Code, C.BMS_Deal_Content_Ref_Key,C.Request_Time, C.Title, A.Episode_No,  C.Start_Date, C.End_Date , C.Error_Description, 
			 CASE WHEN C.Record_Status='W' THEN 'Waiting' WHEN C.Record_Status='P' THEN 'Pending'  END AS Record_Status FROM BMS_Deal_Content C 
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	ON C.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status IN ('P','W')  order by A.BMS_Asset_Code desc;
		END
    END

	IF(@Tabselect='Rights')
	BEGIN
	 IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID, RequestTime,Title,EpisodeNo,StartDate,EndDate, ChannelCode, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, D.BMS_Deal_Code, R.BMS_Deal_Content_Ref_Key,R.Request_Time, R.Title, A.Episode_Number,  R.Start_Date, R.End_Date ,R.RU_Channel_Code , R.Error_Description,
			CASE WHEN R.Record_Status='E' THEN 'Error'  END AS Record_Status  FROM BMS_Deal_Content_Rights R 
			INNER JOIN BMS_Deal_Content C ON R.BMS_Deal_Content_Code=C.BMS_Deal_Content_Code
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	on R.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status = 'E' order by A.BMS_Asset_Code desc;
		END

		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID,RequestTime, Title,EpisodeNo,StartDate,EndDate, ChannelCode, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, D.BMS_Deal_Code, R.BMS_Deal_Content_Ref_Key,R.Request_Time, R.Title, A.Episode_Number,   R.Start_Date, R.End_Date , R.RU_Channel_Code, R.Error_Description,
			 CASE WHEN R.Record_Status='W' THEN 'Waiting' WHEN R.Record_Status='P' THEN 'Pending'  END AS Record_Status  FROM BMS_Deal_Content_Rights R 
			INNER JOIN BMS_Deal_Content C ON R.BMS_Deal_Content_Code=C.BMS_Deal_Content_Code
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	on R.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status IN ('P','W')  order by A.BMS_Asset_Code desc;
		END
    END
	IF(@Tabselect='License')
	BEGIN  
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(VendorName, RUID, BVID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Vendor_Name, Vendor_Code, Ref_Vendor_Key,Request_Time, Error_Description, 
			CASE WHEN Record_Status='E' THEN 'Error'  END AS Record_Status  
			FROM Vendor WHERE Record_Status = 'E' order by Vendor_Code desc;
		END
		ELSE IF(@DropdownOption='M')
		BEGIN
			INSERT INTO #TempRUBVMappingData(VendorName, RUID, BVID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Vendor_Name, Vendor_Code, Ref_Vendor_Key,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status			
			FROM Vendor WHERE Ref_Vendor_Key=0 OR Ref_Vendor_Key IS NULL order by Vendor_Code desc		
        END
		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(VendorName,RUID, BVID, RequestTime, ErrorDescription, RecordStatus)
			SELECT Vendor_Name, Vendor_Code, Ref_Vendor_Key,Request_Time, Error_Description,
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status 
			 FROM Vendor WHERE Record_Status IN ('P','W') order by Vendor_Code desc;
		END
	END
	select @RecordCount = Count(*) from #TempRUBVMappingData
	delete from #TempRUBVMappingData where Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	select Title,EpisodeNo ,RUID,BVID, RequestTime,ErrorDescription ,RecordStatus ,LicenseRefNo,StartDate,EndDate,ChannelCode,VendorName from #TempRUBVMappingData
	
	IF OBJECT_ID('tempdb..#Label') IS NOT NULL DROP TABLE #Label
	IF OBJECT_ID('tempdb..#TempRUBVMappingData') IS NOT NULL DROP TABLE #TempRUBVMappingData
END