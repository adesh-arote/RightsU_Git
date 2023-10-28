CREATE TABLE [dbo].[AL_Vendor_Details] (
    [AL_Vendor_Detail_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]                 INT            NULL,
    [Banner_Codes]                VARCHAR (2000) NULL,
    [Pref_Exclusion_Codes]        VARCHAR (2000) NULL,
    [Extended_Group_Code_Booking] INT            NULL,
    CONSTRAINT [PK_AL_Vendor_Details] PRIMARY KEY CLUSTERED ([AL_Vendor_Detail_Code] ASC),
    CONSTRAINT [FK_AL_Vendor_Details_Extended_Group] FOREIGN KEY ([Extended_Group_Code_Booking]) REFERENCES [dbo].[Extended_Group] ([Extended_Group_Code]),
    CONSTRAINT [FK_AL_Vendor_Details_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

