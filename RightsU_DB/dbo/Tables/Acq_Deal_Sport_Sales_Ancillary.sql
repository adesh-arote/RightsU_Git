CREATE TABLE [dbo].[Acq_Deal_Sport_Sales_Ancillary] (
    [Acq_Deal_Sport_Sales_Ancillary_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]                          INT             NULL,
    [FRO_Given_Title_Sponsor]                CHAR (1)        NULL,
    [FRO_Given_Official_Sponsor]             CHAR (1)        NULL,
    [Title_FRO_No_of_Days]                   INT             NULL,
    [Title_FRO_Validity]                     INT             NULL,
    [Price_Protection_Title_Sponsor]         CHAR (1)        NULL,
    [Price_Protection_Official_Sponsor]      CHAR (1)        NULL,
    [Last_Matching_Rights_Title_Sponsor]     CHAR (1)        NULL,
    [Last_Matching_Rights_Official_Sponsor]  CHAR (1)        NULL,
    [Title_Last_Matching_Rights_Validity]    INT             NULL,
    [Remarks]                                NVARCHAR (4000) NULL,
    [Official_FRO_No_of_Days]                INT             NULL,
    [Official_FRO_Validity]                  INT             NULL,
    [Official_Last_Matching_Rights_Validity] INT             NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Sales_Ancillary] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Sales_Ancillary_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Sales_Ancillary_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code])
);



