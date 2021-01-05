CREATE TABLE [dbo].[BMS_MediaFrameRates] (
    [BMS_MediaFrameRates_Id] INT            IDENTITY (1, 1) NOT NULL,
    [BMS_Key]                INT            NULL,
    [BMS_Description]        VARCHAR (1000) NULL,
    [Code]                   VARCHAR (100)  NULL,
    [IsArchived]             CHAR (1)       NULL,
    [MaxNumberOfFrames]      VARCHAR (1000) NULL,
    [Inserted_By]            INT            NULL,
    [Inserted_On]            DATETIME       NULL,
    [Last_Updated_Time]      DATETIME       NULL,
    [Last_Action_By]         INT            NULL
);

