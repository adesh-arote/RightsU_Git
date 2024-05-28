CREATE TABLE [dbo].[Acq_Deal_Cost_Costtype_Episode] (
    [Acq_Deal_Cost_Costtype_Episode_Code] INT              IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Cost_Costtype_Code]         INT              NULL,
    [Episode_From]                        INT              NULL,
    [Episode_To]                          INT              NULL,
    [Amount_Type]                         CHAR (1)         NULL,
    [Amount]                              NUMERIC (38, 10) NULL,
    [Percentage]                          NUMERIC (38, 10) NULL,
    [Remarks]                             NVARCHAR (1000)  NULL,
    [Per_Eps_Amount]                      NUMERIC (38, 10) NULL,
    CONSTRAINT [PK_Acq_Deal_Cost_Costtype_Episode] PRIMARY KEY CLUSTERED ([Acq_Deal_Cost_Costtype_Episode_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Cost_Costtype_Episode_Acq_Deal_Cost_Costtype] FOREIGN KEY ([Acq_Deal_Cost_Costtype_Code]) REFERENCES [dbo].[Acq_Deal_Cost_Costtype] ([Acq_Deal_Cost_Costtype_Code])
);

