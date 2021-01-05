CREATE TABLE [dbo].[Language_Group_Details] (
    [Language_Group_Details_Code] INT IDENTITY (1, 1) NOT NULL,
    [Language_Group_Code]         INT NULL,
    [Language_Code]               INT NULL,
    CONSTRAINT [PK_Language_Group_Details\] PRIMARY KEY CLUSTERED ([Language_Group_Details_Code] ASC),
    CONSTRAINT [FK_Language_Group_Details_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Language_Group_Details_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);

