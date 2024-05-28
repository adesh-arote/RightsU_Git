CREATE TABLE [dbo].[IPR_Rep_Business_Unit] (
    [IPR_Rep_Business_Unit_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Rep_Code]               INT NULL,
    [Business_Unit_Code]         INT NULL,
    CONSTRAINT [PK_IPR_Rep_Business_Unit] PRIMARY KEY CLUSTERED ([IPR_Rep_Business_Unit_Code] ASC),
    CONSTRAINT [FK_IPR_Rep_Business_Unit_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_IPR_Rep_Business_Unit_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);

