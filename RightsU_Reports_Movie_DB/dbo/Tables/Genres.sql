CREATE TABLE [dbo].[Genres] (
    [Genres_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Genres_Name]       NVARCHAR (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Ref_Genres_Key]    INT            NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED ([Genres_Code] ASC)
);

