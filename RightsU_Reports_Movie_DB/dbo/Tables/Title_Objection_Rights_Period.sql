CREATE TABLE [dbo].[Title_Objection_Rights_Period] (
    [Title_Objection_Rights_Period_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Code]               INT      NULL,
    [Rights_Start_Date]                  DATETIME NULL,
    [Rights_End_Date]                    DATETIME NULL,
    CONSTRAINT [PK_Title_Objection_Rights_Period] PRIMARY KEY CLUSTERED ([Title_Objection_Rights_Period_Code] ASC)
);

