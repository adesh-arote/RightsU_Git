CREATE TABLE [dbo].[AT_Syn_Deal_Attachment] (
    [AT_Syn_Deal_Attachment_Code] INT            IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Code]            INT            NULL,
    [Title_Code]                  INT            NULL,
    [Attachment_Title]            NVARCHAR (250) NULL,
    [Attachment_File_Name]        VARCHAR (250)  NULL,
    [System_File_Name]            VARCHAR (250)  NULL,
    [Document_Type_Code]          INT            NULL,
    [Episode_From]                INT            NULL,
    [Episode_To]                  INT            NULL,
    [Syn_Deal_Attachment_Code]    INT            NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Attachment] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Attachment_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Attachment_AT_Syn_Deal_Attachment] FOREIGN KEY ([AT_Syn_Deal_Attachment_Code]) REFERENCES [dbo].[AT_Syn_Deal_Attachment] ([AT_Syn_Deal_Attachment_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Attachment_AT_Syn_Deal_Movie] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Attachment_Document_Type] FOREIGN KEY ([Document_Type_Code]) REFERENCES [dbo].[Document_Type] ([Document_Type_Code])
);



