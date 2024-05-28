CREATE TABLE [dbo].[Title_Content_Version_Details] (
    [Title_Content_Version_Details_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Title_Content_Version_Code]         INT           NULL,
    [House_Id]                           VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([Title_Content_Version_Details_Code] ASC),
    FOREIGN KEY ([Title_Content_Version_Code]) REFERENCES [dbo].[Title_Content_Version] ([Title_Content_Version_Code])
);

