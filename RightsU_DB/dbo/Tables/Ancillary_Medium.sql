CREATE TABLE [dbo].[Ancillary_Medium] (
    [Ancillary_Medium_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Ancillary_Medium_Name] VARCHAR (300) NULL,
    CONSTRAINT [PK_Ancillary_Medium] PRIMARY KEY CLUSTERED ([Ancillary_Medium_Code] ASC)
);

