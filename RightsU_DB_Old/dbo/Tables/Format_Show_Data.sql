CREATE TABLE [dbo].[Format_Show_Data] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [House #]       NVARCHAR (255) NULL,
    [Program]       NVARCHAR (255) NULL,
    [Episode Title] NVARCHAR (255) NULL,
    [Episode]       NVARCHAR (255) NULL,
    [Type]          NVARCHAR (255) NULL,
    [Media]         NVARCHAR (255) NULL,
    [SAP]           NVARCHAR (255) NULL,
    [CC]            NVARCHAR (255) NULL,
    [DVI]           NVARCHAR (255) NULL,
    [Live]          NVARCHAR (255) NULL,
    [Duration]      NVARCHAR (255) NULL,
    CONSTRAINT [PK_Format_Show_Data] PRIMARY KEY CLUSTERED ([Id] ASC)
);

