CREATE TABLE [dbo].[Version] (
    [Version_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [Version_Name]      VARCHAR (1000) NULL,
    [BMS_Version_ID]    VARCHAR (1000) NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       NULL,
    CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED ([Version_Code] ASC)
);

