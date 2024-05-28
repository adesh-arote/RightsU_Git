CREATE TABLE [dbo].[Content_Amort_Deal] (
    [Content_Amort_Deal_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Title_Content_Code]      INT             NULL,
    [Acq_Deal_Code]           INT             NULL,
    [Acq_Deal_Movie_Code]     INT             NULL,
    [Amort_Rule_Code]         INT             NULL,
    [Effective_From]          DATETIME        NULL,
    [System_End_Date]         DATETIME        NULL,
    [Amorted_Amount]          NUMERIC (18, 3) NULL,
    [Balance_Amount]          NUMERIC (18, 3) NULL,
    [Amort_Cost]              NUMERIC (18, 3) NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    CONSTRAINT [PK_Content_Amort_Deal] PRIMARY KEY CLUSTERED ([Content_Amort_Deal_Code] ASC),
    CONSTRAINT [FK_Content_Amort_Deal_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Content_Amort_Deal_Amort_Rule] FOREIGN KEY ([Amort_Rule_Code]) REFERENCES [dbo].[Amort_Rule] ([Amort_Rule_Code]),
    CONSTRAINT [FK_Content_Amort_Deal_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);

