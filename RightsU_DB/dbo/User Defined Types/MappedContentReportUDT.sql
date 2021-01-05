CREATE TYPE [dbo].[MappedContentReportUDT] AS TABLE (
    [RUTitleCode]        VARCHAR (4000) NULL,
    [RUTitleContentCode] VARCHAR (4000) NULL,
    [PlatformCode]       VARCHAR (4000) NULL,
    [CountryCode]        VARCHAR (4000) NULL,
    [EpisodeFrom]        INT            NULL,
    [EpisodeTo]          INT            NULL,
    [DBSource]           VARCHAR (10)   NULL,
    [SubtitlingCode]     VARCHAR (100)  NULL,
    [ExpireDays]         INT            NULL,
    [MHReportCode]       INT            NULL,
    [ExpiredDeal]        VARCHAR (1)    NULL);

