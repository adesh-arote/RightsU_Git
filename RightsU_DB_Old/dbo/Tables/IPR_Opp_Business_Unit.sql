CREATE TABLE [dbo].[IPR_Opp_Business_Unit] (
    [IPR_Opp_Business_Unit_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Opp_Code]               INT NULL,
    [Business_Unit_Code]         INT NULL,
    CONSTRAINT [PK_IPR_Opp_Business_Unit] PRIMARY KEY CLUSTERED ([IPR_Opp_Business_Unit_Code] ASC),
    CONSTRAINT [FK_IPR_Opp_Business_Unit_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_IPR_Opp_Business_Unit_IPR_Opp] FOREIGN KEY ([IPR_Opp_Code]) REFERENCES [dbo].[IPR_Opp] ([IPR_Opp_Code])
);

