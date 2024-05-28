CREATE TABLE [dbo].[Title_Audio_Details_Singers] (
    [Title_Audio_Details_Singers_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Code]                       INT NULL,
    [Title_Audio_Details_Code]         INT NULL,
    [Talent_Code]                      INT NULL,
    CONSTRAINT [PK_Title_Audio_Details_Singers] PRIMARY KEY CLUSTERED ([Title_Audio_Details_Singers_Code] ASC),
    CONSTRAINT [FK_Title_Audio_Details_Singers_Talent] FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code]),
    CONSTRAINT [FK_Title_Audio_Details_Singers_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

