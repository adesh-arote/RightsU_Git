CREATE TABLE [dbo].[Syn_Deal_Digital_Detail] (
    [Syn_Deal_Digital_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Digital_Code]        INT            NULL,
    [Digital_Tab_Code]             INT            NULL,
    [Digital_Config_Code]          INT            NULL,
    [Digital_Data_Code]            VARCHAR (1000) NULL,
    [User_Value]                   VARCHAR (MAX)  NULL,
    [Row_Num]                      INT            NULL,
    CONSTRAINT [PK_Syn_Deal_Digital_Detail] PRIMARY KEY CLUSTERED ([Syn_Deal_Digital_Detail_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Digital_Detail_Syn_Deal_Digital] FOREIGN KEY ([Syn_Deal_Digital_Code]) REFERENCES [dbo].[Syn_Deal_Digital] ([Syn_Deal_Digital_Code])
);

