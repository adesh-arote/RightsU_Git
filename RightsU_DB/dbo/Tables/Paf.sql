CREATE TABLE [dbo].[Paf] (
    [Paf_Code]      INT             IDENTITY (1, 1) NOT NULL,
    [Master_Paf_No] VARCHAR (1000)  NULL,
    [Paf_No]        VARCHAR (1000)  NULL,
    [Creation_Date] DATETIME        NULL,
    [Title_Name]    VARCHAR (5000)  NULL,
    [Amount]        DECIMAL (22, 2) NULL,
    [Utilized]      DECIMAL (22, 2) NULL,
    [Balance]       DECIMAL (22, 2) NULL,
    CONSTRAINT [PK_Paf] PRIMARY KEY CLUSTERED ([Paf_Code] ASC)
);

