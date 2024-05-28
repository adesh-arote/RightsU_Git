CREATE TABLE [dbo].[Genres] (
    [Genres_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Genres_Name]       NVARCHAR (100) NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       CONSTRAINT [DF_Genres_Is_Active] DEFAULT ('Y') NULL,
    [Ref_Genres_Key]    INT            NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED ([Genres_Code] ASC)
);

