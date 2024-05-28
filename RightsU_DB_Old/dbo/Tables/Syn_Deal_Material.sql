CREATE TABLE [dbo].[Syn_Deal_Material] (
    [Syn_Deal_Material_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]          INT      NULL,
    [Title_Code]             INT      NULL,
    [Material_Medium_Code]   INT      NULL,
    [Material_Type_Code]     INT      NULL,
    [Quantity]               INT      NULL,
    [Inserted_On]            DATETIME NULL,
    [Inserted_By]            INT      NULL,
    [Lock_Time]              DATETIME NULL,
    [Last_Updated_Time]      DATETIME NULL,
    [Last_Action_By]         INT      NULL,
    [Episode_From]           INT      NULL,
    [Episode_To]             INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Material] PRIMARY KEY CLUSTERED ([Syn_Deal_Material_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Material_Material_Medium] FOREIGN KEY ([Material_Medium_Code]) REFERENCES [dbo].[Material_Medium] ([Material_Medium_Code]),
    CONSTRAINT [FK_Syn_Deal_Material_Material_Type] FOREIGN KEY ([Material_Type_Code]) REFERENCES [dbo].[Material_Type] ([Material_Type_Code]),
    CONSTRAINT [FK_Syn_Deal_Material_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code]),
    CONSTRAINT [FK_Syn_Deal_Material_Syn_Deal_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

