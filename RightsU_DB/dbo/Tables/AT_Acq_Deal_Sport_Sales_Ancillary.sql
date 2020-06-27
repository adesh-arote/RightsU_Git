CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Sales_Ancillary] (
    [AT_Acq_Deal_Sport_Sales_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]                       INT             NULL,
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
    [Acq_Deal_Sport_Sales_Ancillary_Code]    INT             NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Sales_Ancillary] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Sales_Ancillary_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Sales_Ancillary_AT_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code])
);



