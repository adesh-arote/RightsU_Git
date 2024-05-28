CREATE TABLE [dbo].[IPR_Opp_Attachment] (
    [IPR_Opp_Attachment_Code] INT            IDENTITY (1, 1) NOT NULL,
    [IPR_Opp_Code]            INT            NULL,
    [System_File_Name]        VARCHAR (500)  NULL,
    [File_Name]               VARCHAR (500)  NULL,
    [Flag]                    CHAR (1)       NULL,
    [Description]             NVARCHAR (200) NULL,
    CONSTRAINT [PK_IPR_Opp_Attachment] PRIMARY KEY CLUSTERED ([IPR_Opp_Attachment_Code] ASC),
    CONSTRAINT [FK_IPR_Opp_Attachment_IPR_Opp] FOREIGN KEY ([IPR_Opp_Code]) REFERENCES [dbo].[IPR_Opp] ([IPR_Opp_Code])
);



