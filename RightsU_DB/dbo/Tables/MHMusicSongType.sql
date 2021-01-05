CREATE TABLE [dbo].[MHMusicSongType] (
    [MHMusicSongTypeCode] INT          IDENTITY (1, 1) NOT NULL,
    [SongType]            VARCHAR (50) NOT NULL,
    [IsActive]            CHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([MHMusicSongTypeCode] ASC)
);

