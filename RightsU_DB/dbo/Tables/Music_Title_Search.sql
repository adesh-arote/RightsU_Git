CREATE TABLE [dbo].[Music_Title_Search] (
    [Music_Title_Search_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Music_Title_Code]        INT            NULL,
    [Masters_Value]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Music_Title_Search] PRIMARY KEY CLUSTERED ([Music_Title_Search_Code] ASC)
);

