CREATE TYPE [dbo].[TATSLAUDT] AS TABLE (
    [TATSLACode]        INT          NULL,
    [TATSLAMatrix1Code] INT          NULL,
    [TATSLAMatrix2Code] INT          NULL,
    [TATSLAMatrix3Code] INT          NULL,
    [WorkflowStatus]    INT          NULL,
    [SLA1FromDays]      INT          NULL,
    [SLA1ToDays]        INT          NULL,
    [SLA1Users]         VARCHAR (50) NULL,
    [SLA2FromDays]      INT          NULL,
    [SLA2ToDays]        INT          NULL,
    [SLA2Users]         VARCHAR (50) NULL,
    [SLA3FromDays]      INT          NULL,
    [SLA3ToDays]        INT          NULL,
    [SLA3Users]         VARCHAR (50) NULL,
    [Action]            VARCHAR (10) NULL);

