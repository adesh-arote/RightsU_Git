CREATE TABLE [dbo].[QuarterDefinition] (
    [QuarterId]        INT  NOT NULL,
    [QuarterStartDate] DATE NULL,
    [QuarterEndDate]   DATE NULL,
    CONSTRAINT [PK_QuarterDefinition] PRIMARY KEY CLUSTERED ([QuarterId] ASC)
);

