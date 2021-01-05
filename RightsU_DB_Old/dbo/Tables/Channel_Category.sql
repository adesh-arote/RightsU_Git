CREATE TABLE [dbo].[Channel_Category] (
    [Channel_Category_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Channel_Category_Name] NVARCHAR (100) NULL,
    [Inserted_On]           DATETIME       NOT NULL,
    [Inserted_By]           INT            NOT NULL,
    [Lock_Time]             DATETIME       NULL,
    [Last_Updated_Time]     DATETIME       NULL,
    [Last_Action_By]        INT            NULL,
    [Is_Active]             CHAR (1)       NOT NULL,
    [Type]                  CHAR (1)       NULL,
    CONSTRAINT [PK_Channel_Category] PRIMARY KEY CLUSTERED ([Channel_Category_Code] ASC)
);



