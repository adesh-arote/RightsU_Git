CREATE TABLE [dbo].[AT_Acq_Deal_Ancillary] (
    [AT_Acq_Deal_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]           INT             NULL,
    [Ancillary_Type_code]        INT             NULL,
    [Duration]                   NUMERIC (5)     NULL,
    [Day]                        NUMERIC (4)     NULL,
    [Remarks]                    NVARCHAR (4000) NULL,
    [Group_No]                   INT             NULL,
    [Acq_Deal_Ancillary_Code]    INT             NULL,
    [Catch_Up_From]              CHAR (1)        NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Ancillary] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Ancillary_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Ancillary_Ancillary_Type] FOREIGN KEY ([Ancillary_Type_code]) REFERENCES [dbo].[Ancillary_Type] ([Ancillary_Type_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Ancillary_AT_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code])
);







