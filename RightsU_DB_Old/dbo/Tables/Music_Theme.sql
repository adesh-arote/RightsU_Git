CREATE TABLE [dbo].[Music_Theme] (
    [Music_Theme_Code]  INT            IDENTITY (1, 1) NOT NULL,
    [Music_Theme_Name]  NVARCHAR (100) NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       NULL,
    CONSTRAINT [PK_Music_Theme] PRIMARY KEY CLUSTERED ([Music_Theme_Code] ASC)
);





