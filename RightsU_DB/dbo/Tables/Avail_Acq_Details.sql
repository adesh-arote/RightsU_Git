CREATE TABLE [dbo].[Avail_Acq_Details] (
    [Avail_Acq_Details_Code] NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Avail_Acq_Code]         NUMERIC (38) NULL,
    [Rights_Start_Date]      DATE         NULL,
    [Rights_End_Date]        DATE         NULL,
    [Acq_Deal_Code]          INT          NULL,
    CONSTRAINT [Avail_Acq_Details_Code] PRIMARY KEY CLUSTERED ([Avail_Acq_Details_Code] ASC),
    CONSTRAINT [FK_Avail_Acq_Details] FOREIGN KEY ([Avail_Acq_Code]) REFERENCES [dbo].[Avail_Acq] ([Avail_Acq_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Details_Avail_Acq_Code_1]
    ON [dbo].[Avail_Acq_Details]([Avail_Acq_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Details_Rights_Start_Date_1]
    ON [dbo].[Avail_Acq_Details]([Rights_Start_Date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Details_Rights_End_Date_1]
    ON [dbo].[Avail_Acq_Details]([Rights_End_Date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Details_All_1]
    ON [dbo].[Avail_Acq_Details]([Avail_Acq_Code] ASC, [Rights_Start_Date] ASC, [Rights_End_Date] ASC);

