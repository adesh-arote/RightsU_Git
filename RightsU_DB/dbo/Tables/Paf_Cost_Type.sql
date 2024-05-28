CREATE TABLE [dbo].[Paf_Cost_Type] (
    [Paf_Cost_Type_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Paf_Code]           INT             NULL,
    [Paf_Ctm_Code]       INT             NOT NULL,
    [Ams_Cost_Type_Code] INT             NOT NULL,
    [Amount]             DECIMAL (22, 2) NULL,
    [Utilized]           DECIMAL (22, 2) NULL,
    [Balance]            DECIMAL (22, 2) NULL,
    [Entry_Type]         CHAR (1)        NULL,
    CONSTRAINT [PK_Paf_Cost_Type] PRIMARY KEY CLUSTERED ([Paf_Cost_Type_Code] ASC)
);

