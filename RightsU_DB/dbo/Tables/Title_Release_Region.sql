CREATE TABLE [dbo].[Title_Release_Region] (
    [Title_Release_Region_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Release_Code]        INT NULL,
    [Territory_Code]            INT NULL,
    [Country_Code]              INT NULL,
    CONSTRAINT [PK_Title_Release_Region] PRIMARY KEY CLUSTERED ([Title_Release_Region_Code] ASC),
    CONSTRAINT [FK_Title_Release_Region_Title_Release] FOREIGN KEY ([Title_Release_Code]) REFERENCES [dbo].[Title_Release] ([Title_Release_Code])
);

