CREATE TABLE [dbo].[Acq_Deal_Digital_detail] (
    [Acq_Deal_Digital_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Digital_Code]        INT            NULL,
    [Digital_Tab_Code]             INT            NULL,
    [Digital_Config_Code]          INT            NULL,
    [Digital_Data_Code]            VARCHAR (1000) NULL,
    [User_Value]                   VARCHAR (MAX)  NULL,
    [Row_Num]                      INT            NULL,
    CONSTRAINT [PK_Acq_Deal_Digital_detail] PRIMARY KEY CLUSTERED ([Acq_Deal_Digital_Detail_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Digital_detail_Acq_Deal_Digital] FOREIGN KEY ([Acq_Deal_Digital_Code]) REFERENCES [dbo].[Acq_Deal_Digital] ([Acq_Deal_Digital_Code])
);

