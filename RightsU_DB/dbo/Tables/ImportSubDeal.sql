CREATE TABLE [dbo].[ImportSubDeal] (
    [ImportSubDeal_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [DealDesc]              NVARCHAR (MAX) NULL,
    [AgreementDate]         DATETIME       NULL,
    [ModeOfAcquisition]     NVARCHAR (100) NULL,
    [MasterDealAgreementNo] VARCHAR (20)   NULL,
    [MasterDealTitle]       NVARCHAR (MAX) NULL,
    [YearOfDefinition]      CHAR (2)       NULL,
    [DealFor]               NVARCHAR (500) NULL,
    [BusinessUnit]          NVARCHAR (500) NULL,
    [Talent]                NVARCHAR (MAX) NULL,
    [Remarks]               NVARCHAR (MAX) NULL,
    [IsProcessed]           CHAR (1)       CONSTRAINT [DF__ImportSub__IsPro__1D28BC6F] DEFAULT ('N') NULL,
    [Acq_Deal_Code]         INT            NULL,
    CONSTRAINT [PK_ImportSubDeal] PRIMARY KEY CLUSTERED ([ImportSubDeal_Code] ASC)
);

