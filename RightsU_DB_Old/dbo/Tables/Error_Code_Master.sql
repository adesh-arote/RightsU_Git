CREATE TABLE [dbo].[Error_Code_Master] (
    [Error_Code]        INT           IDENTITY (1, 1) NOT NULL,
    [Upload_Error_Code] VARCHAR (10)  NOT NULL,
    [Error_Description] VARCHAR (250) NOT NULL,
    [Error_For]         VARCHAR (10)  NULL,
    CONSTRAINT [PK_Error_Code_Master] PRIMARY KEY CLUSTERED ([Error_Code] ASC)
);

