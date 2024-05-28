CREATE TABLE [dbo].[Temp_BV_Schedule] (
    [Temp_BV_Schedule_Code]               NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Program_Episode_ID]                  VARCHAR (2000) NULL,
    [Program_Episode_Title]               VARCHAR (250)  NULL,
    [Program_Episode_Number]              VARCHAR (100)  NULL,
    [Program_Category]                    VARCHAR (250)  NULL,
    [Program_Version_ID]                  VARCHAR (1000) NULL,
    [Schedule_Item_Log_Date]              VARCHAR (50)   NULL,
    [Schedule_Item_Log_Time]              VARCHAR (50)   NULL,
    [Schedule_Item_Duration]              VARCHAR (100)  NULL,
    [Scheduled_Version_House_Number_List] VARCHAR (4000) NULL,
    [Program_Title]                       VARCHAR (250)  NULL,
    [File_Code]                           BIGINT         NULL,
    [Channel_Code]                        INT            NULL,
    [Inserted_By]                         INT            NULL,
    [Inserted_On]                         DATETIME       NULL,
    [IsDealApproved]                      CHAR (1)       NULL,
    [TitleCode]                           INT            NULL,
    [DMCode]                              INT            NULL,
    [Deal_Code]                           INT            NULL,
    [Deal_Type]                           CHAR (1)       NULL,
    CONSTRAINT [PK_Temp_BV_Schedule] PRIMARY KEY CLUSTERED ([Temp_BV_Schedule_Code] ASC)
);

