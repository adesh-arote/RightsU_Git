CREATE TABLE [dbo].[Vendor_Contacts] (
    [Vendor_Contacts_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]          INT            NULL,
    [Contact_Name]         NVARCHAR (100) NULL,
    [Phone_No]             VARCHAR (20)   NULL,
    [Email]                NVARCHAR (50)  NULL,
    [Department]           NVARCHAR (100) NULL,
    CONSTRAINT [PK_Vendor_Contacts] PRIMARY KEY CLUSTERED ([Vendor_Contacts_Code] ASC),
    CONSTRAINT [FK_Vender_Contacts_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);



