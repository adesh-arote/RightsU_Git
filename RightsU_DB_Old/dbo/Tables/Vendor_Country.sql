CREATE TABLE [dbo].[Vendor_Country] (
    [Vendor_Country_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]         INT      NULL,
    [Country_Code]        INT      NULL,
    [Is_Theatrical]       CHAR (1) NULL,
    CONSTRAINT [PK_Vendor_Country] PRIMARY KEY CLUSTERED ([Vendor_Country_Code] ASC),
    CONSTRAINT [FK_Vendor_Country_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Vendor_Country_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

