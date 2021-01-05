CREATE TABLE [dbo].[Music_Type] (
    [Music_Type_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Music_Type_Name] VARCHAR (100) NULL,
    [Type]            VARCHAR (3)   NULL,
    [Is_Active]       CHAR (1)      NULL,
    CONSTRAINT [PK_Music_Type] PRIMARY KEY CLUSTERED ([Music_Type_Code] ASC)
);

