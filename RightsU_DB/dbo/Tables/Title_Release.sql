CREATE TABLE [dbo].[Title_Release] (
    [Title_Release_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Code]         INT      NULL,
    [Release_Date]       DATETIME NULL,
    [Release_Type]       CHAR (1) CONSTRAINT [DF_Title_Released_On_Release_Type] DEFAULT ('W') NULL,
    CONSTRAINT [PK_Title_Released_On] PRIMARY KEY CLUSTERED ([Title_Release_Code] ASC),
    CONSTRAINT [FK_Title_Released_On_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

