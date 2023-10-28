CREATE TABLE [dbo].[Syn_Deal_Supplementary_Detail] (
    [Syn_Deal_Supplementary_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Supplementary_Code]        INT            NULL,
    [Supplementary_Tab_Code]             INT            NULL,
    [Supplementary_Config_Code]          INT            NULL,
    [Supplementary_Data_Code]            VARCHAR (1000) NULL,
    [User_Value]                         VARCHAR (MAX)  NULL,
    [Row_Num]                            INT            NULL,
    CONSTRAINT [PK_Syn_Deal_Supplementary_Detail] PRIMARY KEY CLUSTERED ([Syn_Deal_Supplementary_Detail_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Supplementary_Detail_Syn_Deal_Supplementary] FOREIGN KEY ([Syn_Deal_Supplementary_Code]) REFERENCES [dbo].[Syn_Deal_Supplementary] ([Syn_Deal_Supplementary_Code])
);

