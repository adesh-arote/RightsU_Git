CREATE TABLE [dbo].[AL_Vendor_Rule_Criteria] (
    [AL_Vendor_Rule_Criteria_Code] INT           IDENTITY (1, 1) NOT NULL,
    [AL_Vendor_Rule_Code]          INT           NULL,
    [Columns_Code]                 INT           NULL,
    [Columns_Value]                VARCHAR (500) NULL,
    CONSTRAINT [PK_AL_Vendor_Rule_Criteria] PRIMARY KEY CLUSTERED ([AL_Vendor_Rule_Criteria_Code] ASC),
    CONSTRAINT [FK_AL_Vendor_Rule_Criteria_AL_Vendor_Rule] FOREIGN KEY ([AL_Vendor_Rule_Code]) REFERENCES [dbo].[AL_Vendor_Rule] ([AL_Vendor_Rule_Code]),
    CONSTRAINT [FK_AL_Vendor_Rule_Criteria_Extended_Columns] FOREIGN KEY ([Columns_Code]) REFERENCES [dbo].[Extended_Columns] ([Columns_Code])
);

