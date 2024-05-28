CREATE TABLE [dbo].[Title_Release] (
    [Title_Release_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Code]         INT      NULL,
    [Release_Date]       DATETIME NULL,
    [Release_Type]       CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Title_Released_On] PRIMARY KEY CLUSTERED ([Title_Release_Code] ASC)
);

