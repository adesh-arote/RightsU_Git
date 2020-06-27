CREATE TABLE [dbo].[AT_Acq_Deal_Movie_Music] (
    [AT_Acq_Deal_Movie_Music_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Movie_Code]       INT      NULL,
    [Music_Title_Code]             INT      NULL,
    [Is_Active]                    CHAR (1) NULL,
    [Inserted_By]                  INT      NULL,
    [Inserted_On]                  DATETIME NULL,
    [Last_UpDated_Time]            DATETIME NULL,
    [Last_Action_By]               INT      NULL,
    [Lock_Time]                    DATETIME NULL,
    [Acq_Deal_Movie_Music_Code]    INT      NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Movie_Music] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Movie_Music_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Movie_Music_AT_Acq_Deal_Movie] FOREIGN KEY ([AT_Acq_Deal_Movie_Code]) REFERENCES [dbo].[AT_Acq_Deal_Movie] ([AT_Acq_Deal_Movie_Code])
);

