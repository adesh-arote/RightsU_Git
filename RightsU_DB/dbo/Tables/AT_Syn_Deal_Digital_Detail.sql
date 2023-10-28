CREATE TABLE [dbo].[AT_Syn_Deal_Digital_Detail] (
    [AT_Syn_Deal_Digital_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Digital_Code]        INT            NULL,
    [Digital_Tab_Code]                INT            NULL,
    [Digital_Config_Code]             INT            NULL,
    [Digital_Data_Code]               VARCHAR (1000) NULL,
    [User_Value]                      VARCHAR (MAX)  NULL,
    [Row_Num]                         INT            NULL,
    [Syn_Deal_Digital_Detail_Code]    INT            NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Digital_Detail] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Digital_Detail_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Digital_Detail_AT_Syn_Deal_Digital] FOREIGN KEY ([AT_Syn_Deal_Digital_Code]) REFERENCES [dbo].[AT_Syn_Deal_Digital] ([AT_Syn_Deal_Digital_Code])
);

