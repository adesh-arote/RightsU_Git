CREATE TABLE [dbo].[Acq_Deal_Attachment] (
    [Acq_Deal_Attachment_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]            INT            NULL,
    [Title_Code]               INT            NULL,
    [Attachment_Title]         NVARCHAR (500) NULL,
    [Attachment_File_Name]     VARCHAR (250)  NULL,
    [System_File_Name]         VARCHAR (250)  NULL,
    [Document_Type_Code]       INT            NULL,
    [Episode_From]             INT            NULL,
    [Episode_To]               INT            NULL,
    CONSTRAINT [PK_Acq_Deal_Attachment] PRIMARY KEY CLUSTERED ([Acq_Deal_Attachment_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Attachment_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Attachment_Document_Type] FOREIGN KEY ([Document_Type_Code]) REFERENCES [dbo].[Document_Type] ([Document_Type_Code]),
    CONSTRAINT [FK_Acq_Deal_Attachment_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

