CREATE TABLE [dbo].[Vendor_Role] (
    [Vendor_Role_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]      INT      NOT NULL,
    [Role_Code]        INT      NOT NULL,
    [Is_Active]        CHAR (1) CONSTRAINT [DF_Vendor_Role_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Vendor_Role] PRIMARY KEY CLUSTERED ([Vendor_Role_Code] ASC),
    CONSTRAINT [FK_Vendor_Role_Role] FOREIGN KEY ([Role_Code]) REFERENCES [dbo].[Role] ([Role_Code]),
    CONSTRAINT [FK_Vendor_Role_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

