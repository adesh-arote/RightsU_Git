CREATE TABLE [dbo].[Music_Language] (
    [Music_Language_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [Language_Name]          NVARCHAR (100) NULL,
    [Inserted_On]            DATETIME       NULL,
    [Inserted_By]            INT            NULL,
    [Last_Updated_Time]      DATETIME       NULL,
    [Last_Action_By]         INT            NULL,
    [Is_Active]              CHAR (1)       NULL,
    [Original_Language_Code] INT            NULL,
    CONSTRAINT [PK_Music_Language] PRIMARY KEY CLUSTERED ([Music_Language_Code] ASC)
);





