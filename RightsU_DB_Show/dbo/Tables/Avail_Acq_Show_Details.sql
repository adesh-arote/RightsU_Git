CREATE TABLE [dbo].[Avail_Acq_Show_Details] (
    [Avail_Acq_Show_Code] NUMERIC (38) NULL,
    [Avail_Raw_Code]      NUMERIC (38) NULL,
    [Is_Title_Language]   BIT          NULL,
    [Sub_Language_Code]   NUMERIC (38) NULL,
    [Dub_Language_code]   NUMERIC (38) NULL,
    CONSTRAINT [FK_Avail_Acq_Show_Details_Avail_Acq_Show] FOREIGN KEY ([Avail_Acq_Show_Code]) REFERENCES [dbo].[Avail_Acq_Show] ([Avail_Acq_Show_Code]),
    CONSTRAINT [FK_Avail_Acq_Show_Details_Avail_Raw] FOREIGN KEY ([Avail_Raw_Code]) REFERENCES [dbo].[Avail_Raw] ([Avail_Raw_Code])
);

