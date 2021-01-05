CREATE TYPE [dbo].[RightsDefination] AS TABLE (
    [IntCode]         INT            NULL,
    [TitleCode]       INT            NULL,
    [EpisodeStart]    INT            NULL,
    [EpisodeEnd]      INT            NULL,
    [StartDate]       DATE           NULL,
    [EndDate]         DATE           NULL,
    [CountryCodes]    VARCHAR (4000) NULL,
    [PlatformCodes]   VARCHAR (4000) NULL,
    [DubbingCodes]    VARCHAR (4000) NULL,
    [SubtitlingCodes] VARCHAR (4000) NULL);

