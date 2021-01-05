CREATE TABLE [dbo].[Program] (
    [Program_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [Program_Name]      NVARCHAR (200) NULL,
    [Deal_Type_Code]    INT            NULL,
    [Genres_Code]       INT            NULL,
    [Is_Active]         CHAR (1)       NULL,
    [Inserted_By]       INT            NULL,
    [Inserted_On]       DATETIME       NULL,
    [Last_UpDated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED ([Program_Code] ASC),
    CONSTRAINT [FK_Program_Deal_Type] FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code]),
    CONSTRAINT [FK_Program_Genres] FOREIGN KEY ([Genres_Code]) REFERENCES [dbo].[Genres] ([Genres_Code])
);

