CREATE TABLE [dbo].[Currency_Exchange_Rate] (
    [Currency_Exchange_Rate_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Currency_Code]               INT             NULL,
    [Effective_Start_Date]        DATETIME        NOT NULL,
    [System_End_Date]             DATETIME        NULL,
    [Exchange_Rate]               NUMERIC (10, 3) NULL,
    CONSTRAINT [PK_Currency_Exchange_Rate] PRIMARY KEY CLUSTERED ([Currency_Exchange_Rate_Code] ASC),
    CONSTRAINT [FK_Currency_Exchange_Rate_Currency] FOREIGN KEY ([Currency_Code]) REFERENCES [dbo].[Currency] ([Currency_Code])
);

