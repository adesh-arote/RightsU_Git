CREATE TABLE [dbo].[Avail_Acq] (
    [Avail_Acq_Code]     NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Title_Code]         INT          NULL,
    [Platform_Code]      INT          NULL,
    [Country_Code]       INT          NULL,
    [Sub_Licencing_Code] INT          NULL,
    [Territory_Code]     INT          NULL,
    [Territory_Type]     CHAR (1)     NULL,
    [Eps_No]             INT          NULL,
    CONSTRAINT [PK_Avail_Acq_Code] PRIMARY KEY CLUSTERED ([Avail_Acq_Code] ASC),
    CONSTRAINT [FK_Country_Avail_Acq] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Platform_Avail_Acq] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Title_Avail_Acq] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Territory_Code_1]
    ON [dbo].[Avail_Acq]([Territory_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Title_Code_1]
    ON [dbo].[Avail_Acq]([Title_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Platform_Code_1]
    ON [dbo].[Avail_Acq]([Platform_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Avail_Acq_Country_Code_1]
    ON [dbo].[Avail_Acq]([Country_Code] ASC);

