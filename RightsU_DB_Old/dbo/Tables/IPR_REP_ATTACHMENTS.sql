CREATE TABLE [dbo].[IPR_REP_ATTACHMENTS] (
    [IPR_Rep_Attachment_Code] INT            IDENTITY (1, 1) NOT NULL,
    [IPR_Rep_Code]            INT            NULL,
    [System_File_Name]        VARCHAR (500)  NULL,
    [File_Name]               VARCHAR (500)  NULL,
    [Flag]                    CHAR (1)       NULL,
    [Description]             NVARCHAR (200) NULL,
    CONSTRAINT [PK_IPR_ATTACHMENTS] PRIMARY KEY CLUSTERED ([IPR_Rep_Attachment_Code] ASC),
    CONSTRAINT [FK_IPR_ATTACHMENTS_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);



