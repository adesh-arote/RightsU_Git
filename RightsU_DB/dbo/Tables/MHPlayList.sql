CREATE TABLE [dbo].[MHPlayList] (
    [MHPlayListCode] INT            IDENTITY (1, 1) NOT NULL,
    [PlaylistName]   NVARCHAR (400) NULL,
    [TitleCode]      INT            NULL,
    [VendorCode]     INT            NULL,
    [IsActive]       CHAR (1)       NULL,
    CONSTRAINT [PK_MHPlayList] PRIMARY KEY CLUSTERED ([MHPlayListCode] ASC),
    CONSTRAINT [FK_MHPlayList_Title] FOREIGN KEY ([TitleCode]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_MHPlayList_Vendor] FOREIGN KEY ([VendorCode]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

