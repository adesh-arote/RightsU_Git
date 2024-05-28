CREATE TABLE [dbo].[Ancillary_Platform_Medium] (
    [Ancillary_Platform_Medium_Code] INT IDENTITY (1, 1) NOT NULL,
    [Ancillary_Platform_code]        INT NULL,
    [Ancillary_Medium_Code]          INT NULL,
    CONSTRAINT [PK_Ancillary_Platform_Medium] PRIMARY KEY CLUSTERED ([Ancillary_Platform_Medium_Code] ASC),
    CONSTRAINT [FK_Ancillary_Platform_Medium_Ancillary_Medium_Code] FOREIGN KEY ([Ancillary_Medium_Code]) REFERENCES [dbo].[Ancillary_Medium] ([Ancillary_Medium_Code]),
    CONSTRAINT [FK_Ancillary_Platform_Medium_Ancillary_Platform_Code] FOREIGN KEY ([Ancillary_Platform_code]) REFERENCES [dbo].[Ancillary_Platform] ([Ancillary_Platform_code])
);

