CREATE TABLE [dbo].[Temp_BV_Schedule_DeletedRecords] (
    [Temp_BV_Schedule_DeletedRecords_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Program_Episode_Title]                VARCHAR (250)  NULL,
    [Program_Episode_Number]               VARCHAR (100)  NULL,
    [Program_Title]                        VARCHAR (250)  NULL,
    [Program_Category]                     VARCHAR (250)  NULL,
    [Schedule_Item_Log_Date]               VARCHAR (50)   NULL,
    [Schedule_Item_Log_Time]               VARCHAR (50)   NULL,
    [Schedule_Item_Duration]               VARCHAR (100)  NULL,
    [Scheduled_Version_House_Number_List]  VARCHAR (1000) NULL,
    [File_Code]                            BIGINT         NULL,
    [Channel_Code]                         INT            NULL,
    [Inserted_By]                          INT            NULL,
    [Inserted_On]                          DATETIME       NULL,
    [Email_Notification_Msg]               VARCHAR (5000) NULL,
    [IsMailSent]                           CHAR (1)       NULL,
    CONSTRAINT [PK_Temp_BV_Schedule_DeletedRecords] PRIMARY KEY CLUSTERED ([Temp_BV_Schedule_DeletedRecords_Code] ASC)
);

