--USE [RightsU_LePlex]
--GO
--/****** Object:  StoredProcedure [dbo].[USP_BMS_Schedule_Channel_For_GET]    Script Date: 6/15/2017 12:28:01 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
CREATE PROC [dbo].[USP_BMS_Schedule_Channel_For_GET]
AS
--    ==========================
--    Author		:   Abhaysingh N. Rajpurohit   
--    Created On    :   05 July 2016
--    Description   :   Select All Channel Which is IsUseForAsRun = 'Y' to Get schedule data
--    Notes			:   This procedure will return recordset(table) with five columns (1. Channel_Code, 2. Ref_Station_Key, 3. Method_Type, 4. BaseAddress, 5. RequestUri,)
--    ==========================
BEGIN
	DECLARE @BaseAddress VARCHAR(300) = '',@RequestUri VARCHAR(100) = '', @moduleName VARCHAR(MAX)
	SET @moduleName = 'BMS_Schedule'
    SELECT TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
	FROM BMS_All_Masters WHERE Method_Type = 'G' AND Module_Name = @moduleName AND Is_Active = 'Y'

	SELECT Channel_Code, Ref_Channel_Key, 'GET' AS Method_Type, @BaseAddress AS BaseAddress, 
	--@RequestUri + CAST(Ref_Channel_Key AS VARCHAR) + '?since=1900-01-01T12:00:00' AS RequestUri, '1900-01-01T12:00:00' AS Data_Since
	@RequestUri + CAST(Ref_Channel_Key AS VARCHAR)  AS RequestUri, '1900-01-01T12:00:00' AS Data_Since
	FROM DBO.Channel WHERE ISNULL(IsUseForAsRun, 'N') = 'Y' AND Ref_Channel_Key IS NOT NULL
	AND @BaseAddress <> '' AND @RequestUri <> '' --AND Channel_Code IN(4)
	AND ISNULL(Is_Get,'N')='Y'
	ORDER BY Order_For_schedule
END

--UPDATE Channel SET Is_Get='Y',Is_Put='Y' WHERE Channel_Code IN(24,25)

--EXEC USP_BMS_Schedule_Channel_For_GET