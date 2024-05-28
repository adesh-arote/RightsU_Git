CREATE PROCEDURE [dbo].[USP_UpdateContentHouseID]
--DECLARE
@BV_HouseId_Data_Code INT,
@MappedDealTitleCode INT
AS
BEGIN   
	Declare @Loglevel int  
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_UpdateContentHouseID]', 'Step 1', 0, 'Started Procedure', 0, '' 
	
		DECLARE @HouseIds AS NVARCHAR(MAX) = '', @EpisodeID int = 0, @HouseIdType AS NVARCHAR(MAX) = 0, @Program_Episode_ID AS NVARCHAR(1000)
		, @Program_Version_ID AS NVARCHAR(1000), @Schedule_Item_Log_Date AS VARCHAR(5000) = '', @Schedule_Item_Log_Time AS VARCHAR(5000) = '' 
		, @Show_Program_Category VARCHAR(250), @Bv_HSD_Code INT

		DECLARE CR_HouseID_Data CURSOR
		FOR
			SELECT BV.BV_HouseId_Data_Code
				   ,BV.House_Type
				   ,ISNULL(BV.Episode_No, 1)
				   ,BV.House_Ids
				   ,[Program_Episode_ID]
				   ,[Program_Version_ID]
				   ,Schedule_Item_Log_Date
				   ,Schedule_Item_Log_Time
			FROM BV_HouseId_Data BV (NOLOCK) 
			WHERE BV.BV_HouseId_Data_Code = @BV_HouseId_Data_Code
			OR BV.Parent_BV_HouseId_Data_Code =  @BV_HouseId_Data_Code
		OPEN CR_HouseID_Data
		FETCH NEXT FROM CR_HouseID_Data INTO  @Bv_HSD_Code, @HouseIdType, @EpisodeID, @HouseIds, @Program_Episode_ID, @Program_Version_ID, @Schedule_Item_Log_Date,
		@Schedule_Item_Log_Time
		WHILE @@FETCH_STATUS<>-1
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				DECLARE @Title_Content_Code AS INT
				SET @Title_Content_Code = 0

				PRINT '@Title_Content_Code ' + CAST(@Title_Content_Code AS VARCHAR)

				SELECT TOP 1 @Title_Content_Code = tc.Title_Content_Code FROM Content_Channel_Run CCR (NOLOCK) 
				INNER JOIN Title_Content tc (NOLOCK)  ON tc.Title_Content_Code = CCR.Title_Content_Code
				WHERE tc.Episode_No = @EpisodeID AND 
					(
						(
							tc.title_code = @MappedDealTitleCode
						)
					)
					and ISNULL(CCR.Is_Archive, 'N') = 'N'

				UPDATE Title_Content set Ref_BMS_Content_Code = ISNULL(@Program_Episode_ID,0) WHERE Title_Content_Code = @Title_Content_Code
				UPDATE BV_HouseId_Data SET Is_Mapped = 'Y', Title_Content_Code = @Title_Content_Code, Title_Code = @MappedDealTitleCode 
				WHERE BV_HouseId_Data_Code = @Bv_HSD_Code 
			END                
			FETCH NEXT FROM CR_HouseID_Data INTO  @Bv_HSD_Code, @HouseIdType, @EpisodeID, @HouseIds ,@Program_Episode_ID  ,@Program_Version_ID   
			,@Schedule_Item_Log_Date,@Schedule_Item_Log_Time
		END
		CLOSE CR_HouseID_Data
		DEALLOCATE CR_HouseID_Data
	   
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_UpdateContentHouseID]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
