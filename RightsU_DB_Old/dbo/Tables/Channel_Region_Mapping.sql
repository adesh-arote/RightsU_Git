CREATE TABLE [dbo].[Channel_Region_Mapping] (
    [Channel_Region_Mapping_code] INT IDENTITY (1, 1) NOT NULL,
    [Channel_Region_Code]         INT NULL,
    [Channel_code]                INT NULL,
    CONSTRAINT [PK_Channel_Region_Mapping] PRIMARY KEY CLUSTERED ([Channel_Region_Mapping_code] ASC),
    CONSTRAINT [FK_Channel_Region_Mapping_Channel] FOREIGN KEY ([Channel_code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_Channel_Region_Mapping_Channel_Region] FOREIGN KEY ([Channel_Region_Code]) REFERENCES [dbo].[Channel_Region] ([Channel_Region_Code])
);

