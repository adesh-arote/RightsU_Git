CREATE TABLE [dbo].[AT_Acq_Deal_Budget] (
    [AT_Acq_Deal_Budget_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]        INT NULL,
    [Title_Code]              INT NULL,
    [Episode_From]            INT NULL,
    [Episode_To]              INT NULL,
    [SAP_WBS_Code]            INT NULL,
    [Acq_Deal_Budget_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Budget] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Budget_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Budget_AT_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Budget_SAP_WBS] FOREIGN KEY ([SAP_WBS_Code]) REFERENCES [dbo].[SAP_WBS] ([SAP_WBS_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Budget_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

