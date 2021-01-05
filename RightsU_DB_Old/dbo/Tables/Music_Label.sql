CREATE TABLE [dbo].[Music_Label] (
    [Music_Label_Code]  INT            IDENTITY (1, 1) NOT NULL,
    [Music_Label_Name]  NVARCHAR (200) NULL,
    [Is_Active]         CHAR (1)       NULL,
    [Inserted_By]       INT            NULL,
    [Inserted_On]       DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    CONSTRAINT [PK_Music_Label] PRIMARY KEY CLUSTERED ([Music_Label_Code] ASC)
);





