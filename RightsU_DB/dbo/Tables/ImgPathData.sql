CREATE TABLE [dbo].[ImgPathData] (
    [Id]      INT           IDENTITY (1, 1) NOT NULL,
    [ImgPath] VARCHAR (500) NULL,
    [ImgData] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

