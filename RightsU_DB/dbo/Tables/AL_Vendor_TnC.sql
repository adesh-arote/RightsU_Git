CREATE TABLE [dbo].[AL_Vendor_TnC] (
    [AL_Vendor_TnC_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]        INT            NULL,
    [TnC_Description]    NVARCHAR (500) NULL,
    CONSTRAINT [PK_AL_Vendor_TnC] PRIMARY KEY CLUSTERED ([AL_Vendor_TnC_Code] ASC),
    CONSTRAINT [FK_AL_Vendor_TnC_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

