CREATE TABLE [dbo].[Channel_Region] (
    [Channel_Region_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Channel_Region_Name] VARCHAR (1000) NULL,
    [Business_Unit_Code]  VARCHAR (100)  NULL,
    CONSTRAINT [PK_Channel_Region] PRIMARY KEY CLUSTERED ([Channel_Region_Code] ASC)
);

