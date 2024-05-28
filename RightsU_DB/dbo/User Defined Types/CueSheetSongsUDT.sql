CREATE TYPE [dbo].[CueSheetSongsUDT] AS TABLE (
    [SrNo]           NVARCHAR (100) NULL,
    [Show Name]      NVARCHAR (100) NULL,
    [Episode]        NVARCHAR (10)  NULL,
    [Music Track]    NVARCHAR (100) NULL,
    [Movie/Album]    NVARCHAR (100) NULL,
    [Usage Type]     NVARCHAR (100) NULL,
    [TC IN]          NVARCHAR (100) NULL,
    [TC IN Frame]    NVARCHAR (100) NULL,
    [TC OUT]         NVARCHAR (100) NULL,
    [TC OUT Frame]   NVARCHAR (50)  NULL,
    [Duration]       NVARCHAR (100) NULL,
    [Duration Frame] NVARCHAR (100) NULL);

	