CREATE TABLE [dbo].[Title_Type] (
    [Title_Type_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Title_Type]      VARCHAR (100) NULL,
    [Is_Active]       CHAR (1)      CONSTRAINT [DF_Table_1_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Title_Type] PRIMARY KEY CLUSTERED ([Title_Type_Code] ASC)
);

