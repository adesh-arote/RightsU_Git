CREATE TABLE [dbo].[Email_Notification_Schedule] (
    [Email_Notification_Schedule_Code]    NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BV_Schedule_Transaction_Code]        NUMERIC (18)   NULL,
    [Program_Episode_Title]               NVARCHAR (500) NULL,
    [Program_Episode_Number]              VARCHAR (50)   NULL,
    [Program_Title]                       NVARCHAR (500) NULL,
    [Program_Category]                    VARCHAR (100)  NULL,
    [Schedule_Item_Log_Date]              VARCHAR (50)   NULL,
    [Schedule_Item_Log_Time]              VARCHAR (50)   NULL,
    [Schedule_Item_Duration]              VARCHAR (50)   NULL,
    [Scheduled_Version_House_Number_List] VARCHAR (1000) NULL,
    [File_Code]                           BIGINT         NULL,
    [Channel_Code]                        INT            NULL,
    [Inserted_On]                         DATETIME       NULL,
    [Deal_Movie_Code]                     NUMERIC (18)   NULL,
    [Deal_Movie_Rights_Code]              NUMERIC (18)   NULL,
    [Email_Notification_Msg]              NVARCHAR (MAX) NULL,
    [IsMailSent]                          CHAR (1)       NULL,
    [IsRunCountCalculate]                 CHAR (1)       NULL,
    [Title_Code]                          INT            NULL,
    [Title_Name]                          NVARCHAR (500) NULL,
    [Right_Start_Date]                    DATETIME       NULL,
    [Right_End_Date]                      DATETIME       NULL,
    [No_Of_Runs_Across_Beams]             VARCHAR (50)   NULL,
    [Available_Channels]                  VARCHAR (500)  NULL,
    [Count_Of_Schedule]                   VARCHAR (50)   NULL,
    [Channel_Name]                        NVARCHAR (250) NULL,
    [IsPrimeException]                    CHAR (2)       NULL,
    [IS_DATA_REPROCESS]                   VARCHAR (1)    NULL,
    [Allocated_Runs]                      NUMERIC (18)   NULL,
    [Consumed_Runs]                       NUMERIC (18)   NULL,
    CONSTRAINT [PK_Email_Notification_Schedule] PRIMARY KEY CLUSTERED ([Email_Notification_Schedule_Code] ASC)
);





