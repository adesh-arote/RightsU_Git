CREATE TABLE [dbo].[tempUsage] (
    [NoOfSongs]     INT             NULL,
    [Channel_Name]  NVARCHAR (100)  NULL,
    [Title_Name]    NVARCHAR (500)  NULL,
    [EpisodeFrom]   INT             NULL,
    [EpisodeTo]     INT             NULL,
    [TelecastFrom]  DATE            NULL,
    [TelecastTo]    DATE            NULL,
    [MusicLabel]    NVARCHAR (MAX)  NOT NULL,
    [RequestedDate] DATE            NULL,
    [Login_Name]    NVARCHAR (300)  NULL,
    [Vendor_Name]   NVARCHAR (1000) NULL
);

