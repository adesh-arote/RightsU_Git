CREATE TABLE [dbo].[Acq_Deal_Digital] (
    [Acq_Deal_Digital_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]         INT           NULL,
    [Title_code]            INT           NULL,
    [Episode_From]          INT           NULL,
    [Episode_To]            INT           NULL,
    [Remarks]               VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Acq_Deal_Digital] PRIMARY KEY CLUSTERED ([Acq_Deal_Digital_Code] ASC)
);

