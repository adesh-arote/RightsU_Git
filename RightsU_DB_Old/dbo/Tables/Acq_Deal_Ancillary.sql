CREATE TABLE [dbo].[Acq_Deal_Ancillary] (
    [Acq_Deal_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]           INT             NULL,
    [Ancillary_Type_code]     INT             NULL,
    [Duration]                NUMERIC (5)     NULL,
    [Day]                     NUMERIC (4)     NULL,
    [Remarks]                 NVARCHAR (4000) NULL,
    [Group_No]                INT             NULL,
    [Catch_Up_From]           CHAR (1)        NULL,
    CONSTRAINT [PK_Acq_Deal_Ancillary] PRIMARY KEY CLUSTERED ([Acq_Deal_Ancillary_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Ancillary_Type] FOREIGN KEY ([Ancillary_Type_code]) REFERENCES [dbo].[Ancillary_Type] ([Ancillary_Type_Code])
);





