CREATE TABLE [dbo].[Email_Template] (
    [Template_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Template_For]  VARCHAR (100) NULL,
    [Template_Desc] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Email_Template] PRIMARY KEY CLUSTERED ([Template_Id] ASC)
);

