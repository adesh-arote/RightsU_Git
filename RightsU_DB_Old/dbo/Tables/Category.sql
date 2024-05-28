CREATE TABLE [dbo].[Category] (
    [Category_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Category_Name]       NVARCHAR (100) NULL,
    [Inserted_On]         DATETIME       NULL,
    [Inserted_By]         INT            NULL,
    [Lock_Time]           DATETIME       NULL,
    [Last_Updated_Time]   DATETIME       NULL,
    [Last_Action_By]      INT            NULL,
    [Is_Active]           CHAR (1)       CONSTRAINT [DF_Category_Is_Active] DEFAULT ('Y') NULL,
    [Is_System_Generated] CHAR (1)       CONSTRAINT [DF_Category_Is_System_Generated] DEFAULT ('N') NULL,
    [Ref_Category_Key]    INT            NULL,
    [Record_Status]       CHAR (1)       DEFAULT ('P') NULL,
    [Error_Description]   VARCHAR (MAX)  NULL,
    [Request_Time]        DATETIME       NULL,
    [Response_Time]       DATETIME       NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([Category_Code] ASC)
);





