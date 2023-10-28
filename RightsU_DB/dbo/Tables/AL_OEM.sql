CREATE TABLE [dbo].[AL_OEM] (
    [AL_OEM_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [Company_Name]       NVARCHAR (500) NULL,
    [Company_Short_Name] NVARCHAR (500) NULL,
    [Inserted_By]        INT            NULL,
    [Inserted_On]        DATETIME       NULL,
    [Last_Updated_Time]  DATETIME       NULL,
    [Last_Action_By]     INT            NULL,
    [Lock_Time]          DATETIME       NULL,
    CONSTRAINT [PK_AL_OEM] PRIMARY KEY CLUSTERED ([AL_OEM_Code] ASC)
);

