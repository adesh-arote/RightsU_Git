CREATE TABLE [dbo].[Music_Title_Label] (
    [Music_Title_Label_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Music_Title_Code]       INT      NULL,
    [Music_Label_Code]       INT      NULL,
    [Effective_From]         DATETIME NULL,
    [Effective_To]           DATETIME NULL,
    CONSTRAINT [PK_Music_Title_Label] PRIMARY KEY CLUSTERED ([Music_Title_Label_Code] ASC),
    CONSTRAINT [FK_Music_Title_Label_Music_Label] FOREIGN KEY ([Music_Label_Code]) REFERENCES [dbo].[Music_Label] ([Music_Label_Code]),
    CONSTRAINT [FK_Music_Title_Label_Music_Title] FOREIGN KEY ([Music_Title_Code]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
);

