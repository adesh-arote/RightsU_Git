CREATE TABLE [dbo].[Title_Objection_Rights_Period] (
    [Title_Objection_Rights_Period_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Code]               INT      NULL,
    [Rights_Start_Date]                  DATETIME NULL,
    [Rights_End_Date]                    DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Title_Objection_Rights_Period_Code] ASC),
    CONSTRAINT [FK_Title_Objection_Rights_Period_Title_Objection] FOREIGN KEY ([Title_Objection_Code]) REFERENCES [dbo].[Title_Objection] ([Title_Objection_Code])
);

