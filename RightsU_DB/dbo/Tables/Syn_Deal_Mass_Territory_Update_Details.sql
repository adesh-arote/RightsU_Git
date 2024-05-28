CREATE TABLE [dbo].[Syn_Deal_Mass_Territory_Update_Details] (
    [Syn_Deal_Mass_Update_Det_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Mass_Update_Code]     INT NULL,
    [Territory_Code]                INT NULL,
    CONSTRAINT [FK_Syn_Deal_Mass_Territory_Update_Details_Syn_Deal_Mass_Territory_Update] FOREIGN KEY ([Syn_Deal_Mass_Update_Code]) REFERENCES [dbo].[Syn_Deal_Mass_Territory_Update] ([Syn_Deal_Mass_Update_Code]),
    CONSTRAINT [FK_Syn_Deal_Mass_Territory_Update_Details_Territory] FOREIGN KEY ([Territory_Code]) REFERENCES [dbo].[Territory] ([Territory_Code])
);

