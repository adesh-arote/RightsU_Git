CREATE TABLE [dbo].[Music_Title_Talent] (
    [Music_Title_Talent_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Title_Code]        INT NULL,
    [Talent_Code]             INT NULL,
    [Role_Code]               INT NULL,
    CONSTRAINT [PK_Music_Title_Talent] PRIMARY KEY CLUSTERED ([Music_Title_Talent_Code] ASC),
    CONSTRAINT [FK_Music_Title_Talent_Music_Title_Talent] FOREIGN KEY ([Music_Title_Code]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code]),
    CONSTRAINT [FK_Music_Title_Talent_Role] FOREIGN KEY ([Role_Code]) REFERENCES [dbo].[Role] ([Role_Code]),
    CONSTRAINT [FK_Music_Title_Talent_Talent] FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code])
);

