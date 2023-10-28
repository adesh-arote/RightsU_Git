CREATE TABLE [dbo].[AL_Vendor_OEM] (
    [AL_Vendor_OEM_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AL_OEM_Code]        INT      NULL,
    [Vendor_Code]        INT      NULL,
    [Is_Active]          CHAR (1) NULL,
    [Inserted_By]        INT      NULL,
    [Inserted_On]        DATETIME NULL,
    [Last_Updated_Time]  DATETIME NULL,
    [Last_Action_By]     INT      NULL,
    CONSTRAINT [PK_AL_Vendor_OEM] PRIMARY KEY CLUSTERED ([AL_Vendor_OEM_Code] ASC),
    CONSTRAINT [FK_AL_Vendor_OEM_AL_OEM] FOREIGN KEY ([AL_OEM_Code]) REFERENCES [dbo].[AL_OEM] ([AL_OEM_Code]),
    CONSTRAINT [FK_AL_Vendor_OEM_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

