CREATE TABLE [dbo].[Acq_Deal_Termination_Details]
(
	[Acq_Deal_Termination_Details_Code] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Acq_Deal_Code] INT NOT NULL, 
    [Title_Code] INT NULL, 
    [Termination_Episode_No] INT NULL, 
    [Termination_Date] DATETIME NULL, 
    [Users_Code] INT NULL, 
    [Created_Date] DATETIME NULL, 
    CONSTRAINT [FK_Acq_Deal_Termination_Details_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [Acq_Deal]([Acq_Deal_Code]), 
    CONSTRAINT [FK_Acq_Deal_Termination_Details_Title] FOREIGN KEY ([Title_Code]) REFERENCES [Title]([Title_Code])
)
