CREATE TABLE [dbo].[Music_Album] (
    [Music_Album_Code]  INT            IDENTITY (1, 1) NOT NULL,
    [Music_Album_Name]  NVARCHAR (100) NULL,
    [Album_Type]        CHAR (1)       NULL,
    [Inserted_By]       INT            NULL,
    [Inserted_On]       DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Last_UpDated_Time] DATETIME       NULL,
    [Is_Active]         CHAR (1)       NULL,
    CONSTRAINT [PK_Music_Album] PRIMARY KEY CLUSTERED ([Music_Album_Code] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A- Album, M- Movie', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Music_Album', @level2type = N'COLUMN', @level2name = N'Album_Type';

