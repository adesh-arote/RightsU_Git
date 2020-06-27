CREATE TABLE [dbo].[TblHouseIdRanges] (
    [RangeCode]          INT          IDENTITY (1, 1) NOT NULL,
    [RangeFrom]          VARCHAR (20) NULL,
    [RangeTo]            VARCHAR (20) NULL,
    [UseForValidationYN] CHAR (1)     NULL,
    [ChannelCode]        INT          NULL,
    CONSTRAINT [PK_TblHouseIdRanges] PRIMARY KEY CLUSTERED ([RangeCode] ASC)
);

