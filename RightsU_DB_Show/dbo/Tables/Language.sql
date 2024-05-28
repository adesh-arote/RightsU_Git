CREATE TABLE [dbo].[Language] (
    [Language_Code]     INT            IDENTITY (1, 1) NOT NULL,
    [Language_Name]     NVARCHAR (100) NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       NULL,
    [Ref_Language_Key]  INT            NULL,
    CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED ([Language_Code] ASC)
);

