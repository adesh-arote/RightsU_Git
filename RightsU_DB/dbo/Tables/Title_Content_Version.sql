CREATE TABLE [dbo].[Title_Content_Version] (
    [Title_Content_Version_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Title_Content_Code]         INT             NULL,
    [Version_Code]               INT             NULL,
    [Duration]                   DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_Title_Content_Version] PRIMARY KEY CLUSTERED ([Title_Content_Version_Code] ASC),
    CONSTRAINT [FK_Title_Content_Version_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code]),
    CONSTRAINT [FK_Title_Content_Version_Version] FOREIGN KEY ([Version_Code]) REFERENCES [dbo].[Version] ([Version_Code])
);



