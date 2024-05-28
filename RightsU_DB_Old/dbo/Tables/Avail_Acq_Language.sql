CREATE TABLE [dbo].[Avail_Acq_Language] (
    [Avail_Acq_Language] NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Avail_Acq_Code]     NUMERIC (38) NULL,
    [Dubbing_Subtitling] VARCHAR (2)  NULL,
    [Language_Code]      INT          NULL,
    [Rights_Start_Date]  DATE         NULL,
    [Rights_End_Date]    DATE         NULL,
    [Acq_Deal_Code]      INT          NULL,
    CONSTRAINT [Avail_Acq_Language_Code] PRIMARY KEY CLUSTERED ([Avail_Acq_Language] ASC),
    CONSTRAINT [FK_Avail_Acq_Language] FOREIGN KEY ([Avail_Acq_Code]) REFERENCES [dbo].[Avail_Acq] ([Avail_Acq_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Language_Avail_Acq_Code_1]
    ON [dbo].[Avail_Acq_Language]([Avail_Acq_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Language_Dubbing_Subtitling_1]
    ON [dbo].[Avail_Acq_Language]([Dubbing_Subtitling] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Language_Language_Code_1]
    ON [dbo].[Avail_Acq_Language]([Language_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Language_Rights_Start_Date_1]
    ON [dbo].[Avail_Acq_Language]([Rights_Start_Date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Languages_Rights_End_Date_1]
    ON [dbo].[Avail_Acq_Language]([Rights_End_Date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Languages_All_1]
    ON [dbo].[Avail_Acq_Language]([Avail_Acq_Code] ASC, [Dubbing_Subtitling] ASC, [Language_Code] ASC, [Rights_Start_Date] ASC, [Rights_End_Date] ASC);

