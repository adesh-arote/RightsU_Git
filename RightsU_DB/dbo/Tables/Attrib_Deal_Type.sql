CREATE TABLE [dbo].[Attrib_Deal_Type] (
    [Attrib_Deal_Type_Code] INT NOT NULL,
    [Attrib_Group_Code]     INT NULL,
    [Deal_Type_Code]        INT NULL,
    [Business_Unit_Code]    INT NULL,
    CONSTRAINT [PK_Attrib_Deal_Type] PRIMARY KEY CLUSTERED ([Attrib_Deal_Type_Code] ASC),
    CONSTRAINT [FK_Attrib_Deal_Type_Attrib_Group] FOREIGN KEY ([Attrib_Group_Code]) REFERENCES [dbo].[Attrib_Group] ([Attrib_Group_Code]),
    CONSTRAINT [FK_Attrib_Deal_Type_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_Attrib_Deal_Type_Deal_Type] FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code])
);

