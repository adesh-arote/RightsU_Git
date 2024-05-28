CREATE TABLE [dbo].[Ancillary_Platform] (
    [Ancillary_Platform_code] INT           IDENTITY (1, 1) NOT NULL,
    [Ancillary_Type_code]     INT           NULL,
    [Platform_Name]           VARCHAR (200) NULL,
    CONSTRAINT [PK_Ancillary_Platform] PRIMARY KEY CLUSTERED ([Ancillary_Platform_code] ASC),
    CONSTRAINT [FK_Ancillary_Platform_Ancillary_Type] FOREIGN KEY ([Ancillary_Type_code]) REFERENCES [dbo].[Ancillary_Type] ([Ancillary_Type_Code])
);

