CREATE TABLE [dbo].[Provisional_Deal_Title] (
    [Provisional_Deal_Title_Code] INT          IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Code]       INT          NULL,
    [Title_Code]                  INT          NULL,
    [Episode_From]                INT          NULL,
    [Episode_To]                  INT          NULL,
    [Right_Start_Date]            DATETIME     NULL,
    [Right_End_Date]              DATETIME     NULL,
    [Term]                        VARCHAR (12) NULL,
    [Prime_Start_Time]            TIME (7)     NULL,
    [Prime_End_Time]              TIME (7)     NULL,
    [Off_Prime_Start_Time]        TIME (7)     NULL,
    [Off_Prime_End_Time]          TIME (7)     NULL,
    CONSTRAINT [PK_Provisional_Deal_Title] PRIMARY KEY CLUSTERED ([Provisional_Deal_Title_Code] ASC),
    CONSTRAINT [FK_Provisional_Deal_Title_Provisional_Deal] FOREIGN KEY ([Provisional_Deal_Code]) REFERENCES [dbo].[Provisional_Deal] ([Provisional_Deal_Code]),
    CONSTRAINT [FK_Provisional_Deal_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

