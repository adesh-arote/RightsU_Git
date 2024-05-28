CREATE TABLE [dbo].[Acq_Deal_Movie_Music] (
    [Acq_Deal_Movie_Music_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Movie_Code]       INT      NULL,
    [Music_Title_Code]          INT      NULL,
    [Is_Active]                 CHAR (1) NULL,
    [Inserted_By]               INT      NULL,
    [Inserted_On]               DATETIME NULL,
    [Last_UpDated_Time]         DATETIME NULL,
    [Last_Action_By]            INT      NULL,
    [Lock_Time]                 DATETIME NULL,
    CONSTRAINT [PK_Acq_Deal_Movie_Music] PRIMARY KEY CLUSTERED ([Acq_Deal_Movie_Music_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Movie_Music_Music_Title] FOREIGN KEY ([Music_Title_Code]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
);

