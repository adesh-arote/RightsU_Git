CREATE TABLE [dbo].[Title_Objection] (
    [Title_Objection_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Status_Code] INT            NULL,
    [Title_Objection_Type_Code]   INT            NULL,
    [Title_Code]                  INT            NULL,
    [Record_Code]                 INT            NULL,
    [Record_Type]                 CHAR (1)       NULL,
    [Objection_Start_Date]        DATETIME       NULL,
    [Objection_End_Date]          DATETIME       NULL,
    [Objection_Remarks]           NVARCHAR (MAX) NULL,
    [Resolution_Remarks]          NVARCHAR (MAX) NULL,
    [Inserted_On]                 DATETIME       NULL,
    [Inserted_By]                 INT            NULL,
    [Last_Updated_Time]           DATETIME       NULL,
    [Last_Action_By]              INT            NULL,
    PRIMARY KEY CLUSTERED ([Title_Objection_Code] ASC),
    CONSTRAINT [FK_Title_Objection_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_Title_Objection_Title_Objection_Status] FOREIGN KEY ([Title_Objection_Status_Code]) REFERENCES [dbo].[Title_Objection_Status] ([Title_Objection_Status_Code]),
    CONSTRAINT [FK_Title_Objection_Title_Objection_Type] FOREIGN KEY ([Title_Objection_Type_Code]) REFERENCES [dbo].[Title_Objection_Type] ([Objection_Type_Code])
);


