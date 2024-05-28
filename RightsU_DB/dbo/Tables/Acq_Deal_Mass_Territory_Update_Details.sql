CREATE TABLE [dbo].[Acq_Deal_Mass_Territory_Update_Details] (
    [Acq_Deal_Mass_Update_Det_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Mass_Update_Code]     INT NULL,
    [Territory_Code]                INT NULL,
    CONSTRAINT [FK_Acq_Deal_Mass_Territory_Update_Details_Acq_Deal_Mass_Territory_Update] FOREIGN KEY ([Acq_Deal_Mass_Update_Code]) REFERENCES [dbo].[Acq_Deal_Mass_Territory_Update] ([Acq_Deal_Mass_Update_Code]),
    CONSTRAINT [FK_Acq_Deal_Mass_Territory_Update_Details_Territory] FOREIGN KEY ([Territory_Code]) REFERENCES [dbo].[Territory] ([Territory_Code])
);

