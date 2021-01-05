CREATE TABLE [dbo].[MHCueSheet] (
    [MHCueSheetCode]     INT            IDENTITY (1, 1) NOT NULL,
    [RequestID]          NVARCHAR (20)  NULL,
    [FileName]           NVARCHAR (400) NULL,
    [UploadStatus]       CHAR (1)       NULL,
    [VendorCode]         INT            NULL,
    [TotalRecords]       INT            NULL,
    [ErrorRecords]       INT            NULL,
    [CreatedBy]          INT            NULL,
    [CreatedOn]          DATETIME       NULL,
    [SubmitBy]           INT            NULL,
    [SubmitOn]           DATETIME       NULL,
    [ApprovedBy]         INT            NULL,
    [ApprovedOn]         DATETIME       NULL,
    [SpecialInstruction] NVARCHAR (MAX) NULL,
    [MHRequestCode]      BIGINT         NULL,
    CONSTRAINT [PK_MHCueSheet] PRIMARY KEY CLUSTERED ([MHCueSheetCode] ASC),
    CONSTRAINT [FK_MHCueSheet_Vendor] FOREIGN KEY ([VendorCode]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

