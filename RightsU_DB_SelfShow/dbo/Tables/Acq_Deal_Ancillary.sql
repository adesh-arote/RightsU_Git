CREATE TABLE [dbo].[Acq_Deal_Ancillary] (
    [Acq_Deal_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]           INT             NULL,
    [Ancillary_Type_code]     INT             NULL,
    [Duration]                NUMERIC (5)     NULL,
    [Day]                     NUMERIC (4)     NULL,
    [Remarks]                 NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Group_No]                INT             NULL,
    [Catch_Up_From]           CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Acq_Deal_Ancillary] PRIMARY KEY CLUSTERED ([Acq_Deal_Ancillary_Code] ASC)
);

