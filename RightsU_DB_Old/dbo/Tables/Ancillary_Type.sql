CREATE TABLE [dbo].[Ancillary_Type] (
    [Ancillary_Type_Code] INT          IDENTITY (1, 1) NOT NULL,
    [Ancillary_Type_Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_Ancillary_Type] PRIMARY KEY CLUSTERED ([Ancillary_Type_Code] ASC)
);

