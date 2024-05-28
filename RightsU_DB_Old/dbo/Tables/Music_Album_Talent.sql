CREATE TABLE [dbo].[Music_Album_Talent] (
    [Music_Album_Talent_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Album_Code]        INT NULL,
    [Talent_Code]             INT NULL,
    [Role_Code]               INT NULL,
    CONSTRAINT [PK_Music_Album_Talent] PRIMARY KEY CLUSTERED ([Music_Album_Talent_Code] ASC),
    CONSTRAINT [FK_Music_Album_Talent_Music_Album] FOREIGN KEY ([Music_Album_Code]) REFERENCES [dbo].[Music_Album] ([Music_Album_Code]),
    CONSTRAINT [FK_Music_Album_Talent_Role] FOREIGN KEY ([Role_Code]) REFERENCES [dbo].[Role] ([Role_Code]),
    CONSTRAINT [FK_Music_Album_Talent_Talent] FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code])
);

