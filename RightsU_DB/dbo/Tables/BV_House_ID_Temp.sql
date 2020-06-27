CREATE TABLE [dbo].[BV_House_ID_Temp] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [House_Ids]     NVARCHAR (255) NULL,
    [Program]       NVARCHAR (255) NULL,
    [Episode_Title] NVARCHAR (255) NULL,
    [Episode]       NVARCHAR (255) NULL,
    [Type]          NVARCHAR (255) NULL,
    [Media]         NVARCHAR (255) NULL,
    [SAP]           NVARCHAR (255) NULL,
    [CC]            NVARCHAR (255) NULL,
    [DVI]           NVARCHAR (255) NULL,
    [Live]          NVARCHAR (255) NULL,
    [Duration]      NVARCHAR (255) NULL,
    CONSTRAINT [PK_BV_House_ID_Temp] PRIMARY KEY CLUSTERED ([Id] ASC)
);

