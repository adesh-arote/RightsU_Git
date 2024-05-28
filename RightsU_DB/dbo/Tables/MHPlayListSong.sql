CREATE TABLE [dbo].[MHPlayListSong] (
    [MHPlayListSongCode] BIGINT IDENTITY (1, 1) NOT NULL,
    [MHPlayListCode]     INT    NULL,
    [MusicTitleCode]     INT    NULL,
    CONSTRAINT [PK_MHPlayListSong] PRIMARY KEY CLUSTERED ([MHPlayListSongCode] ASC),
    CONSTRAINT [FK_MHPlayListSong_MHPlayList] FOREIGN KEY ([MHPlayListCode]) REFERENCES [dbo].[MHPlayList] ([MHPlayListCode]),
    CONSTRAINT [FK_MHPlayListSong_Music_Title] FOREIGN KEY ([MusicTitleCode]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
);

