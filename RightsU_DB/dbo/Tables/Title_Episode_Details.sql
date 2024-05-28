CREATE TABLE [dbo].[Title_Episode_Details] (
    [Title_Episode_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Title_Code]                INT            NULL,
    [Episode_Nos]               INT            NULL,
    [Remarks]                   NVARCHAR (MAX) NULL,
    [Status]                    CHAR (1)       NULL,
    [Inserted_On]               DATETIME       NULL,
    [Inserted_By]               INT            NULL,
    CONSTRAINT [PK_Title_Episode_Details] PRIMARY KEY CLUSTERED ([Title_Episode_Detail_Code] ASC),
    CONSTRAINT [FK_Title_Episode_Details_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

