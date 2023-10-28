CREATE TABLE [dbo].[DurationDefinition] (
    [DurationId]    INT          NOT NULL,
    [StartDate]     DATE         NULL,
    [EndDate]       DATE         NULL,
    [DurationLabel] VARCHAR (50) NULL,
    CONSTRAINT [PK_DurationDefinitio] PRIMARY KEY CLUSTERED ([DurationId] ASC)
);

