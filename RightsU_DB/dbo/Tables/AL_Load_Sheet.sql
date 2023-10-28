CREATE TABLE [dbo].[AL_Load_Sheet] (
    [AL_Load_Sheet_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Load_Sheet_No]      VARCHAR (50)   NULL,
    [Load_Sheet_Month]   DATE           NULL,
    [Remarks]            VARCHAR (4000) NULL,
    [Status]             CHAR (1)       NULL,
    [Download_File_Name] VARCHAR (200)  NULL,
    [Inserted_By]        INT            NULL,
    [Inserted_On]        DATETIME       NULL,
    [Updated_By]         INT            NULL,
    [Updated_On]         DATETIME       NULL,
    [Lock_Time]          DATETIME       NULL,
    CONSTRAINT [PK_AL_Load_Sheet] PRIMARY KEY CLUSTERED ([AL_Load_Sheet_Code] ASC)
);

