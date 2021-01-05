CREATE PROCEDURE [dbo].[USP_BMS_Asset_Mapping_UDT]
@BMS_Schedule_Mapped_Title_UDT BMS_Schedule_Mapped_Title_UDT ReadOnly
AS
-- =============================================
-- Author:         <Anchal Sikarwar>
-- Create date:	   <03 Jan 2017>
-- Description:    <Updating BMS_Asset>
-- =============================================
BEGIN   
	IF OBJECT_ID('tempdb..#tempMTExist') IS NOT NULL
	BEGIN
		DROP TABLE #tempMTExist
	END
	IF OBJECT_ID('tempdb..#tempMTNew') IS NOT NULL
	BEGIN
		DROP TABLE #tempMTNew
	END
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	BEGIN
		DROP TABLE #temp
	END
	CREATE TABLE #temp
	(
		Row_ID INT IDENTITY (1, 1) NOT NULL,
		BV_HouseId_Data_Code INT,
		BV_Title NVARCHAR(MAX),
		Episode_No INT,
		Mapped_Deal_Title_Code INT,
		Is_Mapped CHAR(1),
		Program_Episode_ID INT,
		IsProcessed CHAR(1),
		IsIgnore CHAR(1),
		Program_Category NVARCHAR(MAX),
		BMS_Schedule_Process_Data_Temp_Code INT
	)

	INSERT INTO #temp(BV_HouseId_Data_Code,BV_Title,Episode_No,Mapped_Deal_Title_Code,Is_Mapped,Program_Episode_ID,IsProcessed,IsIgnore,Program_Category,
						BMS_Schedule_Process_Data_Temp_Code)
	select * from @BMS_Schedule_Mapped_Title_UDT

	IF(EXISTS(SELECT * FROM #temp))
	BEGIN
		INSERT INTO BMS_Asset(
							BMS_Asset_Ref_Key
							,RU_Title_Code
							,Title
							,Title_Listing
							,Language_Code
							,Ref_Language_Key 
							,RU_ProgramCategory_Code
							,Ref_BMS_ProgramCategroy					
							,Episode_Title 
							,Episode_Season
							,Synopsis
							,Episode_Number
							,Is_Archived
							,IS_Consider
							,Record_Status
							,Duration)
		Select Program_Episode_ID
		,Mapped_Deal_Title_Code
		,t.Title_Name
		,t.Title_Name
		,t.Title_Language_Code
		,(select Ref_Language_Key from Language where Language_Code=t.Title_Language_Code)
		,(SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = t.Title_Code)
		,(SELECT Ref_BMS_Code FROM [dbo].[Extended_Columns_Value] 
		WHERE Columns_Value_Code In (SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = t.Title_Code))
		,(CASE WHEN Deal_Type_Code IN (1, 20, 21, 22) THEN NULL ELSE 'Episode ' + CAST(tm.Episode_No AS VARCHAR) END)
		,NULL
		,t.Synopsis
		,tm.Episode_No
		,'false'
		,'Y'
		,'D',
		(RIGHT('0' + CAST (FLOOR(COALESCE (t.Duration_In_Min, 0) / 60) AS VARCHAR (8)), 2) + ':' + 
		RIGHT('0' + CAST (FLOOR(COALESCE (t.Duration_In_Min, 0) % 60) AS VARCHAR (2)), 2) + ':' + 
		RIGHT('0' + CAST (FLOOR((t.Duration_In_Min* 60) % 60) AS VARCHAR (2)), 2))+'.0000000'
		 from #temp tm
		inner join Title t ON t.Title_Code=tm.Mapped_Deal_Title_Code
	END
	UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status='P' 
	WHERE BMS_Schedule_Process_Data_Temp_Code IN(SELECT BMS_Schedule_Process_Data_Temp_Code FROM #temp)

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#tempMTExist') IS NOT NULL DROP TABLE #tempMTExist
	IF OBJECT_ID('tempdb..#tempMTNew') IS NOT NULL DROP TABLE #tempMTNew
END