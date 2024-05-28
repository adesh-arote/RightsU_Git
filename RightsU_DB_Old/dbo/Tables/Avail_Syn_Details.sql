CREATE TABLE [dbo].[Avail_Syn_Details] (
    [Avail_Syn_Details_Code] NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Avail_Syn_Code]         NUMERIC (38) NULL,
    [Rights_Start_Date]      DATE         NULL,
    [Rights_End_Date]        DATE         NULL,
    [Syn_Deal_Code]          INT          NULL,
    CONSTRAINT [Avail_Syn_Details_Code] PRIMARY KEY CLUSTERED ([Avail_Syn_Details_Code] ASC),
    CONSTRAINT [FK_Avail_Syn_Details] FOREIGN KEY ([Avail_Syn_Code]) REFERENCES [dbo].[Avail_Syn] ([Avail_Syn_Code]),
    CONSTRAINT [FK_Avail_Syn_Details_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code])
);

