CREATE TABLE [dbo].[Avail_Acq_Details] (
    [Avail_Acq_Code]    NUMERIC (38) NULL,
    [Avail_Raw_Code]    NUMERIC (38) NULL,
    [Is_Title_Language] BIT          NULL,
    [Sub_Language_Code] NUMERIC (38) NULL,
    [Dub_Language_code] NUMERIC (38) NULL,
    CONSTRAINT [FK_Avail_Acq_Details_Avail_Acq] FOREIGN KEY ([Avail_Acq_Code]) REFERENCES [dbo].[Avail_Acq] ([Avail_Acq_Code]),
    CONSTRAINT [FK_Avail_Acq_Details_Avail_Raw] FOREIGN KEY ([Avail_Raw_Code]) REFERENCES [dbo].[Avail_Raw] ([Avail_Raw_Code])
);

