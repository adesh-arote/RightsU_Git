CREATE TABLE [dbo].[Content_Status_History] (
    [Content_Status_History_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Content_Code]          INT      NULL,
    [User_Code]                   INT      NULL,
    [User_Action]                 CHAR (1) NULL,
    [Record_Count]                INT      NULL,
    [Created_On]                  DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Content_Status_History_Code] ASC),
    CONSTRAINT [FK_Content_Status_History_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);



