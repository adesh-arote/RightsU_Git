CREATE TABLE [dbo].[Grade_Master] (
    [Grade_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [Grade_Name]        NVARCHAR (200) NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       CONSTRAINT [DF_Grade_Master_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Grade] PRIMARY KEY CLUSTERED ([Grade_Code] ASC)
);



