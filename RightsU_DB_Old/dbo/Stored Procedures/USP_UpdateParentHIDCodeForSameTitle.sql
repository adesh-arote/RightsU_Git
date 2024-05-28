ALTER PROC [dbo].[USP_UpdateParentHIDCodeForSameTitle]
(
	@House_Ids NVARCHAR(MAX),    
	@Program NVARCHAR(MAX),    
	@Episode NVARCHAR(MAX),    
	@HouseType NVARCHAR(MAX),  
	@UploadFileCode INT,
	@Program_Episode_ID NVARCHAR(MAX),
	@Program_Version_ID NVARCHAR(1000),
	@Schedule_Item_Log_Date VARCHAR(5000),
	@Schedule_Item_Log_Time VARCHAR(5000),
	@Type VARCHAR(2) = 'S',
	@Program_Category VARCHAR(250)
)
AS    
BEGIN    
	DECLARE @BV_HouseId_Data_Code INT    
	SET @BV_HouseId_Data_Code = 0    
    
	IF(@Type = 'S')   
	BEGIN
		SELECT TOP 1 @BV_HouseId_Data_Code = ISNULL(BV_HouseId_Data_Code  ,0)
		FROM BV_HouseId_Data WHERE 1=1     
			AND Program_Episode_ID = @Program_Episode_ID 
			AND BV_Title = @Program
		ORDER BY BV_HouseId_Data_Code ASC    
	
		DECLARE @Show_Program_Category VARCHAR(250), @Is_Program_Category INT =0
		SELECT @Show_Program_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Show_Program_Category'
	
		SELECT @Is_Program_Category = COUNT(*)  FROM 
		(SELECT number FROM dbo.fn_Split_withdelemiter(@Show_Program_Category, ',') WHERE number NOT IN ('', '0')) AS a
		WHERE a.number IN (@Program_Category)

		IF(@BV_HouseId_Data_Code = 0)
		BEGIN
			INSERT INTO BV_HouseId_Data(House_Ids, BV_Title, Episode_No, House_Type, Is_Mapped, Parent_BV_HouseId_Data_Code, upload_file_code, Program_Episode_ID, Program_Version_ID, Schedule_Item_Log_Date, Schedule_Item_Log_Time, [Type], InsertedOn, LastUpdatedOn, Program_Category)
			SELECT @House_Ids, @Program, @Episode, @HouseType, 'N', 0, @UploadFileCode, @Program_Episode_ID, @Program_Version_ID, @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, @Type, GETDATE(), NULL, @Program_Category
		END

		DECLARE @BV_Code VARCHAR(MAX) = ''
		SELECT @BV_Code = (SELECT STUFF((SELECT ','+ CAST(BV_HouseId_Data_Code AS VARCHAR(MAX)) 
		FROM BV_HouseId_Data WHERE BV_Title = @Program  AND Is_Mapped = 'Y' AND ISNULL(Title_Content_Code,0) <> 0 --AND ISNULL(Mapped_Deal_Title_Code,0)  <> ''
		FOR XML PATH('')), 1, 1, '' ))

		IF(@BV_Code <> '' AND @Is_Program_Category > 0)
		BEGIN
			EXEC USP_BV_Title_Mapping_Shows @BV_Code
		END
	END
	ELSE
	BEGIN
		SELECT TOP 1 @BV_HouseId_Data_Code = ISNULL(BV_HouseId_Data_Code, 0)
		FROM BV_HouseId_Data WHERE 1=1
			AND BV_Title = @Program
			AND  House_Ids = @House_Ids
		ORDER BY BV_HouseId_Data_Code ASC
	   
		IF (@BV_HouseId_Data_Code = 0)
		BEGIN
			DECLARE @Cnt INT
			SELECT @Cnt = COUNT(BV_HouseId_Data_Code) FROM BV_HouseId_Data WHERE BV_Title = @Program AND Episode_No = @Episode
				AND ISNULL([Type], 'S') = 'S' AND Is_Mapped = 'N'

			IF (@Cnt > 0)
			BEGIN
				DECLARE @EmailMsg_New NVARCHAR(MAX)
				SELECT @EmailMsg_New = Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'SchMapMissing_AsRun' and [Type] = 'A'
				
				INSERT INTO Email_Notification_AsRun
				(
					asrun_Tr_id, ON_AIR, Dt_Tm, ID, S,
					TITLE, DURATION, [STATUS], DEVICE, CH, RECONCILE, TYP, SEC,
					File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code,
					Email_Notification_Msg, IsMailSent, IsRunCountCalculate,Title_Name
				)
				SELECT TAR.as_run_id, TAR.ON_AIR, TAR.DATE_TIME, TAR.ID, TAR.S,
				TAR.TITLE, TAR.DURATION, TAR.[STATUS], TAR.DEVICE, TAR.CH, TAR.RECONCILE, TAR.[TYPE], TAR.SEC,
				TAR.FileCode, TAR.ChannelCode, GETDATE(), NULL, NULL,
				@EmailMsg_New, 'N', 'N', NULL
				FROM temp_ASRUN TAR
				WHERE TAR.S = 1
				AND TAR.ID = @House_Ids
				AND TAR.FileCode = @UploadFileCode
				AND TAR.Title = @Program
			END
			ELSE
				INSERT INTO BV_HouseId_Data(House_Ids, BV_Title, Episode_No, House_Type, Is_Mapped, Parent_BV_HouseId_Data_Code, upload_file_code, Program_Episode_ID, Program_Version_ID, Schedule_Item_Log_Date, Schedule_Item_Log_Time, [Type], InsertedOn ,LastUpdatedOn )
				SELECT @House_Ids, @Program, @Episode, @HouseType ,'N', 0, @UploadFileCode, '', '', @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, @Type, GETDATE(), NULL
		END
	END
END    
    
    
/*    
    
select * from BV_HouseId_Data_Temp    
    
    
Declare @BV_HouseId_Data_Code INT    
SELECT  TOP 1 @BV_HouseId_Data_Code = BV_HouseId_Data_Code  FROM BV_HouseId_Data WHERE 1=1 and BV_Title = 'Khatron Ke Khiladi' order by BV_HouseId_Data_Code asc    
select @BV_HouseId_Data_Code    
@House_Ids_Split_Cr Z806348 @Program_CurEXTRAA SHOTS SPECIAL- MERE DAD
@Program_Episode_ID 287364871
@Program_Version_ID 331752275
@Schedule_Item_Log_Date Jan 12, 2014
@Schedule_Item_Log_Time 4:00 AM

*/
GO

