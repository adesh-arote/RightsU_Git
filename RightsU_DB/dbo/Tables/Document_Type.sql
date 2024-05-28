CREATE TABLE [dbo].[Document_Type] (
    [Document_Type_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Document_Type_Name] NVARCHAR (200) NULL,
    [Inserted_On]        DATETIME       NULL,
    [Inserted_By]        INT            NULL,
    [Lock_Time]          DATETIME       NULL,
    [Last_Updated_Time]  DATETIME       NULL,
    [Last_Action_By]     INT            NULL,
    [Is_Active]          CHAR (1)       CONSTRAINT [DF_Document_Type_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Document_Type] PRIMARY KEY CLUSTERED ([Document_Type_Code] ASC)
);

