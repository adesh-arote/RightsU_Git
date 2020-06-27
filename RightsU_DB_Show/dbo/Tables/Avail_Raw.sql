CREATE TABLE [dbo].[Avail_Raw] (
    [Avail_Raw_Code]       NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]        INT          NULL,
    [Acq_Deal_Rights_Code] INT          NULL,
    [Avail_Dates_Code]     NUMERIC (38) NULL,
    [Is_Exclusive]         BIT          NULL,
    [Episode_From]         INT          NULL,
    [Episode_To]           INT          NULL,
    [Is_Delete]            BIT          NULL,
    CONSTRAINT [PK_Avail_Acq_Show_Det] PRIMARY KEY CLUSTERED ([Avail_Raw_Code] ASC),
    CONSTRAINT [FK_Avail_Acq_Show_Details_Avail_Dates] FOREIGN KEY ([Avail_Dates_Code]) REFERENCES [dbo].[Avail_Dates] ([Avail_Dates_Code])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0=No, 1=Yes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Avail_Raw', @level2type = N'COLUMN', @level2name = N'Is_Exclusive';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0=No, 1=Yes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Avail_Raw', @level2type = N'COLUMN', @level2name = N'Is_Delete';

