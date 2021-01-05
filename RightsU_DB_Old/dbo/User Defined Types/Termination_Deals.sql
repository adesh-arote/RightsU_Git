CREATE TYPE [dbo].[Termination_Deals] AS TABLE (
    [Deal_Code]              INT      NOT NULL,
    [Title_Code]             INT      NULL,
    [Termination_Episode_No] INT      NULL,
    [Termination_Date]       DATETIME NULL);

