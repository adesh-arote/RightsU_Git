CREATE TABLE [dbo].[AL_Vendor_Rule] (
    [AL_Vendor_Rule_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]         INT            NULL,
    [Rule_Name]           NVARCHAR (100) NULL,
    [Rule_Short_Name]     VARCHAR (50)   NULL,
    [Rule_Type]           CHAR (1)       NULL,
    [Criteria]            VARCHAR (MAX)  NULL,
    [Is_Active]           CHAR (1)       NULL,
    CONSTRAINT [PK_AL_Vendor_Rule] PRIMARY KEY CLUSTERED ([AL_Vendor_Rule_Code] ASC),
    CONSTRAINT [FK_AL_Vendor_Rule_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

