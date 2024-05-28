CREATE TABLE [dbo].[TitleType_HouseId_Prefix] (
    [TitleType_HouseId_Prefix_Code] INT            IDENTITY (1, 1) NOT NULL,
    [TitleType]                     VARCHAR (250)  NULL,
    [HouseId_Prefix]                VARCHAR (1000) NULL,
    [RangeFrom]                     VARCHAR (250)  NULL,
    [RangeTo]                       VARCHAR (250)  NULL,
    [HouseId_Prefix_Digits]         INT            NULL,
    CONSTRAINT [PK_TitleType_HouseId_Prefix] PRIMARY KEY CLUSTERED ([TitleType_HouseId_Prefix_Code] ASC)
);

