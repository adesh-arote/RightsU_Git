CREATE TABLE [dbo].[Title_Release] (
    [Title_Release_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Code]         INT      NULL,
    [Release_Date]       DATETIME NULL,
    [Release_Type]       CHAR (1) NULL,
    CONSTRAINT [PK_Title_Released_On] PRIMARY KEY CLUSTERED ([Title_Release_Code] ASC)
);



