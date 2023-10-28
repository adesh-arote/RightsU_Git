CREATE TABLE [dbo].[AL_Lab] (
    [AL_Lab_Code]         INT            IDENTITY (1, 1) NOT NULL,
    [AL_Lab_Name]         NVARCHAR (500) NULL,
    [AL_Lab_Short_Name]   NVARCHAR (100) NULL,
    [Contact_Person]      VARCHAR (200)  NULL,
    [Inserted_By]         INT            NULL,
    [Inserted_On]         DATETIME       NULL,
    [Last_Updated_Time]   DATETIME       NULL,
    [Last_Action_By]      INT            NULL,
    [Lock_Time]           DATETIME       NULL,
    [Extended_Group_Code] INT            NULL,
    CONSTRAINT [PK_AL_Lab] PRIMARY KEY CLUSTERED ([AL_Lab_Code] ASC)
);

