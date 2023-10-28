CREATE TABLE [dbo].[AT_Acq_Deal_Supplementary_detail] (
    [AT_Acq_Deal_Supplementary_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Supplementary_Code]        INT            NULL,
    [Supplementary_Tab_Code]                INT            NULL,
    [Supplementary_Config_Code]             INT            NULL,
    [Supplementary_Data_Code]               VARCHAR (1000) NULL,
    [User_Value]                            VARCHAR (MAX)  NULL,
    [Row_Num]                               INT            NULL,
    [Acq_Deal_Supplementary_Detail_Code]    INT            NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Supplementary_detail] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Supplementary_Detail_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Supplementary_detail_AT_Acq_Deal_Supplementary] FOREIGN KEY ([AT_Acq_Deal_Supplementary_Code]) REFERENCES [dbo].[AT_Acq_Deal_Supplementary] ([AT_Acq_Deal_Supplementary_Code])
);

