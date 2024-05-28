CREATE TABLE [dbo].[Title_Content] (
    [Title_Content_Code]   INT             IDENTITY (1, 1) NOT NULL,
    [Title_Code]           INT             NULL,
    [Episode_No]           INT             NULL,
    [Duration]             DECIMAL (18, 2) NULL,
    [Ref_BMS_Content_Code] VARCHAR (50)    NULL,
    [Episode_Title]        NVARCHAR (2000) NULL,
    [Content_Status]       CHAR (1)        NULL,
    [Inserted_By]          INT             NULL,
    [Inserted_On]          DATETIME        NULL,
    [Last_Action_By]       INT             NULL,
    [Last_Updated_Time]    DATETIME        NULL,
    [Synopsis]             NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Title_Content] PRIMARY KEY CLUSTERED ([Title_Content_Code] ASC),
    CONSTRAINT [FK_Title_Content_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);



