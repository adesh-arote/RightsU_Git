CREATE TABLE [dbo].[tbl_Mcastudents] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (50) NULL,
    [Location] NVARCHAR (30) NULL,
    [Gender]   VARCHAR (10)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

