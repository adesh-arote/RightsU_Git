CREATE TABLE [dbo].[Acq_Deal_Supplementary_detail] (
    [Acq_Deal_Supplementary_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Supplementary_Code]        INT            NULL,
    [Supplementary_Tab_Code]             INT            NULL,
    [Supplementary_Config_Code]          INT            NULL,
    [Supplementary_Data_Code]            VARCHAR (1000) NULL,
    [User_Value]                         VARCHAR (MAX)  NULL,
    [Row_Num]                            INT            NULL,
    CONSTRAINT [PK_Acq_Deal_Supplementary_detail] PRIMARY KEY CLUSTERED ([Acq_Deal_Supplementary_Detail_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Supplementary_detail_Acq_Deal_Supplementary] FOREIGN KEY ([Acq_Deal_Supplementary_Code]) REFERENCES [dbo].[Acq_Deal_Supplementary] ([Acq_Deal_Supplementary_Code])
);

