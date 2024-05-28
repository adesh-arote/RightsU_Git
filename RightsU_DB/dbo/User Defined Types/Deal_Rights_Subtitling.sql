CREATE TYPE [dbo].[Deal_Rights_Subtitling] AS TABLE (
    [Deal_Rights_Code]    INT      NOT NULL,
    [Language_Type]       CHAR (1) NULL,
    [Language_Group_Code] INT      NULL,
    [Subtitling_Code]     INT      NULL);

