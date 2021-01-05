CREATE TABLE [dbo].[Business_Unit_Detail] (
    [Business_Unit_Detail_Code] INT IDENTITY (1, 1) NOT NULL,
    [Business_Unit_Code]        INT NULL,
    [Deal_Type_Code]            INT NULL,
    FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code])
);

