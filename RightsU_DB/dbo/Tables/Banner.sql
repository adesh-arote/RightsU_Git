CREATE TABLE [dbo].[Banner] (
    [Banner_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Banner_Name]       NVARCHAR (500) NULL,
    [Banner_Short_Name] NVARCHAR (100) NULL,
    [Inserted_By]       INT            NULL,
    [Inserted_On]       DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED ([Banner_Code] ASC)
);

