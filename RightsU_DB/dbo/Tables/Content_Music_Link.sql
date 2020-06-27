CREATE TABLE [dbo].[Content_Music_Link] (
    [Content_Music_Link_Code]    INT      IDENTITY (1, 1) NOT NULL,
    [Title_Content_Code]         INT      NULL,
    [Title_Content_Version_Code] INT      NULL,
    [Acq_Deal_Movie_Code]        INT      NULL,
    [Music_Title_Code]           INT      NULL,
    [From]                       TIME (7) NULL,
    [From_Frame]                 INT      NULL,
    [To]                         TIME (7) NULL,
    [To_Frame]                   INT      NULL,
    [Duration]                   TIME (7) NOT NULL,
    [Duration_Frame]             INT      NULL,
    [Inserted_By]                INT      NULL,
    [Inserted_On]                DATETIME NULL,
    [Last_UpDated_Time]          DATETIME NULL,
    [Last_Action_By]             INT      NULL,
    CONSTRAINT [PK_Music_Program_Link_1] PRIMARY KEY CLUSTERED ([Content_Music_Link_Code] ASC),
    CONSTRAINT [FK_Content_Music_Link_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code]),
    CONSTRAINT [FK_Content_Music_Link_Title_Content_Version] FOREIGN KEY ([Title_Content_Version_Code]) REFERENCES [dbo].[Title_Content_Version] ([Title_Content_Version_Code]),
    CONSTRAINT [FK_Music_Program_Link_Acq_Deal_Movie] FOREIGN KEY ([Acq_Deal_Movie_Code]) REFERENCES [dbo].[Acq_Deal_Movie] ([Acq_Deal_Movie_Code]),
    CONSTRAINT [FK_Music_Program_Link_Music_Title] FOREIGN KEY ([Music_Title_Code]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
);



