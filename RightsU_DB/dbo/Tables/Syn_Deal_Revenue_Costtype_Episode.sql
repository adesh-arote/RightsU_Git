CREATE TABLE [dbo].[Syn_Deal_Revenue_Costtype_Episode] (
    [Syn_Deal_Revenue_Costtype_Episode_Code] INT              IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Revenue_Costtype_Code]         INT              NULL,
    [Episode_From]                           INT              NULL,
    [Episode_To]                             INT              NULL,
    [Amount_Type]                            CHAR (1)         NULL,
    [Amount]                                 NUMERIC (38, 10) NULL,
    [Percentage]                             NUMERIC (38, 10) NULL,
    [Remarks]                                NVARCHAR (500)   NULL,
    CONSTRAINT [PK_Syn_Deal_Revenue_Costtype_Episode] PRIMARY KEY CLUSTERED ([Syn_Deal_Revenue_Costtype_Episode_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Revenue_Costtype_Episode_Syn_Deal_Revenue_Costtype] FOREIGN KEY ([Syn_Deal_Revenue_Costtype_Code]) REFERENCES [dbo].[Syn_Deal_Revenue_Costtype] ([Syn_Deal_Revenue_Costtype_Code])
);



