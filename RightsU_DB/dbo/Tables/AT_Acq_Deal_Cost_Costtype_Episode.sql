CREATE TABLE [dbo].[AT_Acq_Deal_Cost_Costtype_Episode] (
    [AT_Acq_Deal_Cost_Costtype_Episode_Code] INT              IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Cost_Costtype_Code]         INT              NULL,
    [Episode_From]                           INT              NULL,
    [Episode_To]                             INT              NULL,
    [Amount_Type]                            CHAR (1)         NULL,
    [Amount]                                 NUMERIC (38, 10) NULL,
    [Percentage]                             NUMERIC (38, 10) NULL,
    [Remarks]                                NVARCHAR (1000)  NULL,
    [Acq_Deal_Cost_Costtype_Episode_Code]    INT              NULL,
    [Per_Eps_Amount]                         NUMERIC (38, 10) NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Cost_Costtype_Episode] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Cost_Costtype_Episode_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Costtype_Episode_AT_Acq_Deal_Cost_Costtype] FOREIGN KEY ([AT_Acq_Deal_Cost_Costtype_Code]) REFERENCES [dbo].[AT_Acq_Deal_Cost_Costtype] ([AT_Acq_Deal_Cost_Costtype_Code])
);

