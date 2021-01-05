CREATE TYPE [dbo].[Deal_Rights_Territory] AS TABLE (
    [Deal_Rights_Code] INT      NOT NULL,
    [Territory_Type]   CHAR (1) NULL,
    [Territory_Code]   INT      NULL,
    [Country_Code]     INT      NULL);

