CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Update_BV_Title_Name]
(
	@BMS_Log_Code INT,
	@Error_Details VARCHAR(MAX),
	@Record_Status VARCHAR(1),	
	@XML NVARCHAR(Max)	
)	
AS
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <31 Aug 2016>
-- Description:    <Call from BMS_Schedule_Get SSIS Package , Update BV Title Name>
-- =============================================
BEGIN	
	SET NOCOUNT ON
-------------------------DROP Temp Tables if Exist---------------------
	IF OBJECT_ID('tempdb..#BMS_XML') IS NOT NULL
	BEGIN
		DROP TABLE #BMS_XML
	END
-------------------------Create Temp Table---------------------

	CREATE TABLE #BMS_XML
	(
		BMS_Asset_Ref_Key  INT,
		Eps_No INT,
		Title NVARCHAR(MAX),		
		CategoryId NVARCHAR(MAX)
	)
	
	INSERT INTO #BMS_XML (Eps_No,BMS_Asset_Ref_Key,Title,CategoryId)		
	SELECT DISTINCT COL2,COL3,COL4,COL5 FROM  BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_Title_Name'

	--SELECT * 
	UPDATE BHD SET BHD.BV_Title = BX.Title,BHD.LastUpdatedOn = GETDATE(),BHD.Episode_No = ISNULL(BX.Eps_No,1), BHD.Program_Category=BX.CategoryId
	FROM BV_HouseId_Data BHD 
	INNER JOIN #BMS_XML BX ON ISNULL(BHD.Program_Episode_ID,0) = ISNULL(BX.BMS_Asset_Ref_Key,0) AND ISNULL(BHD.BV_Title,'') = ''
	AND ISNULL(BHD.Program_Episode_ID ,0) > 0  
		
	UPDATE BMS_Log SET
	Response_Time = GETDATE(),
	Response_Xml = CASE WHEN UPPER(@Record_Status) = 'Y' THEN '' ELSE @XML END,
	Record_Status = CASE WHEN UPPER(@Record_Status) = 'Y' THEN 'E' ELSE 'D' END,
	Error_Description = @Error_Details
	WHERE  BMS_Log_Code = @BMS_Log_Code	

	DELETE FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_Title_Name'

END

/*
Select * From SystemVersion
	EXEC  USP_BMS_Schedule_Update_BV_Title_Name 376529,'' ,
	'N',	
	'dummy'
--SELECT TOP 1 * FROM BMS_Log ORDER BY 1 desc
--376529
EXEC USP_BMS_Schedule_Get_BV_Title_Name
*/

--SELECT * FROM BV_HouseId_Data WHERE BMS_Schedule_Process_Data_Temp_Code > 0 AND BV_Title is not null ORDER BY 1 DESC
--SELECT * FROM BV_HouseId_Data WHERE BMS_Schedule_Process_Data_Temp_Code > 0 ORDER BY 1 DESC



