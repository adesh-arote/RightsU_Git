CREATE TABLE [dbo].[PointSystem] (
    [PointSystemId]    INT NOT NULL,
    [QuarterId]        INT NULL,
    [PointSystemUrlId] INT NULL,
    [Points]           INT NULL,
    [IsUnique]         BIT NULL,
    CONSTRAINT [PK_PointSystem] PRIMARY KEY CLUSTERED ([PointSystemId] ASC)
);

