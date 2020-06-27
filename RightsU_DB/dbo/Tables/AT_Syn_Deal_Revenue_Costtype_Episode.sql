CREATE TABLE [dbo].[AT_Syn_Deal_Revenue_Costtype_Episode] (
    [AT_Syn_Deal_Revenue_Costtype_Episode_Code] INT              IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Revenue_Costtype_Code]         INT              NULL,
    [Episode_From]                              INT              NULL,
    [Episode_To]                                INT              NULL,
    [Amount_Type]                               CHAR (1)         NULL,
    [Amount]                                    NUMERIC (38, 10) NULL,
    [Percentage]                                NUMERIC (38, 10) NULL,
    [Remarks]                                   NVARCHAR (500)   NULL,
    [Syn_Deal_Revenue_Costtype_Episode_Code]    INT              NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Revenue_Costtype_Episode] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Revenue_Costtype_Episode_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Costtype_Episode_AT_Syn_Deal_Revenue_Costtype] FOREIGN KEY ([AT_Syn_Deal_Revenue_Costtype_Code]) REFERENCES [dbo].[AT_Syn_Deal_Revenue_Costtype] ([AT_Syn_Deal_Revenue_Costtype_Code])
);



