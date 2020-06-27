CREATE TABLE [dbo].[AT_Acq_Deal_Material] (
    [AT_Acq_Deal_Material_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]          INT      NULL,
    [Title_Code]                INT      NULL,
    [Material_Medium_Code]      INT      NULL,
    [Material_Type_Code]        INT      NULL,
    [Quantity]                  INT      NULL,
    [Inserted_On]               DATETIME NULL,
    [Inserted_By]               INT      NULL,
    [Lock_Time]                 DATETIME NULL,
    [Last_Updated_Time]         DATETIME NULL,
    [Last_Action_By]            INT      NULL,
    [Episode_From]              INT      NULL,
    [Episode_To]                INT      NULL,
    [Acq_Deal_Material_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Material] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Material_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Material_AT_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Material_AT_Acq_Deal_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

