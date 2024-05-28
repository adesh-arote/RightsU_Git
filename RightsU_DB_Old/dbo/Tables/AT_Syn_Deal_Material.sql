CREATE TABLE [dbo].[AT_Syn_Deal_Material] (
    [AT_Syn_Deal_Material_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Code]          INT      NULL,
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
    [Syn_Deal_Material_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Material] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Material_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Material_AT_Syn_Deal] FOREIGN KEY ([AT_Syn_Deal_Code]) REFERENCES [dbo].[AT_Syn_Deal] ([AT_Syn_Deal_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Material_AT_Syn_Deal_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

