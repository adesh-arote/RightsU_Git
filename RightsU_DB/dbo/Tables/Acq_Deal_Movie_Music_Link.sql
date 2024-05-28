CREATE TABLE [dbo].[Acq_Deal_Movie_Music_Link] (
    [Acq_Deal_Movie_Music_Link_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Movie_Music_Code]      INT      NULL,
    [Link_Acq_Deal_Movie_Code]       INT      NULL,
    [Title_Code]                     INT      NULL,
    [Episode_No]                     INT      NULL,
    [No_Of_Play]                     INT      NULL,
    [Is_Active]                      CHAR (1) NULL,
    [Inserted_By]                    INT      NULL,
    [Inserted_On]                    DATETIME NULL,
    [Last_UpDated_Time]              DATETIME NULL,
    [Last_Action_By]                 INT      NULL,
    [Lock_Time]                      DATETIME NULL,
    CONSTRAINT [PK_Acq_Deal_Movie_Music_Link] PRIMARY KEY CLUSTERED ([Acq_Deal_Movie_Music_Link_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Movie_Music_Link_Acq_Deal_Movie_Music] FOREIGN KEY ([Acq_Deal_Movie_Music_Code]) REFERENCES [dbo].[Acq_Deal_Movie_Music] ([Acq_Deal_Movie_Music_Code]),
    CONSTRAINT [FK_Acq_Deal_Movie_Music_Link_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

