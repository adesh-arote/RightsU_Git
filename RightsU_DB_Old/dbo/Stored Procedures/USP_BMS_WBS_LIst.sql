
CREATE PROCEDURE [dbo].[USP_BMS_WBS_LIst]
(
	@Is_Process VARCHAR(5),
	@WBS_Code NVARCHAR(100),
	@File_Code INT
)	
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 12 Aug 2015
-- Description:	Get List of BMS_WBS 
-- =============================================

BEGIN	
	SET NOCOUNT ON;

    SELECT [BMS_WBS_Code]
      ,[SAP_WBS_Code]
      ,[WBS_Code]
      ,[WBS_Description]
      ,[Short_ID]
	  ,CASE
		 WHEN ISNULL([Short_ID] ,'') <> '' THEN [WBS_Description] + '-' + [Short_ID] + '-' + [WBS_Code] 
			ELSE  [WBS_Description] +  '-' + [WBS_Code] 
	  END
		AS  WBS_Description_Short_ID
      ,[Is_Archive]
      ,[Status]
      ,ISNULL([Error_Details],'') AS Error_Details
      ,[Is_Process]
      ,[File_Code]
	  ,[BMS_Key]
	  ,ISNULL([Response_Type],'') AS Response_Type
	  ,ISNULL([Response_Status],'') AS Response_Status
	  INTO #Temp
  FROM [dbo].[BMS_WBS]
  WHERE [Is_Process] = @Is_Process
  --AND ISNULL([BMS_Key],0) > 0

	UPDATE #Temp SET WBS_Description_Short_ID = 
	CASE 
		WHEN LEN(WBS_Description_Short_ID) > 80
			THEN  -- SUBSTRING(WBS_Description ,1, (LEN(WBS_Description) - (LEN(WBS_Description_Short_ID) - 80)))  + '-'			 
			CASE
				 WHEN ISNULL([Short_ID] ,'') <> '' 
					THEN SUBSTRING(WBS_Description ,1, (LEN(WBS_Description) - (LEN(WBS_Description_Short_ID) - 80))) + '-' + [Short_ID] + '-' + [WBS_Code] 
					ELSE  SUBSTRING(WBS_Description ,1, (LEN(WBS_Description) - (LEN(WBS_Description_Short_ID) - 80))) +  '-' + [WBS_Code] 
			END
        ELSE WBS_Description_Short_ID
	END  

	SELECT * FROM #Temp

	DROP TABLE #Temp

END