CREATE TABLE [dbo].[Title_Episode_Details_TC] (
    [Title_Episode_Detail_TC_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Episode_Detail_Code]    INT NULL,
    [Title_Content_Code]           INT NULL,
    CONSTRAINT [PK_Title_Episode_Details_TC] PRIMARY KEY CLUSTERED ([Title_Episode_Detail_TC_Code] ASC),
    CONSTRAINT [FK_Title_Episode_Details_TC_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code]),
    CONSTRAINT [FK_Title_Episode_Details_TC_Title_Episode_Details] FOREIGN KEY ([Title_Episode_Detail_Code]) REFERENCES [dbo].[Title_Episode_Details] ([Title_Episode_Detail_Code])
);

