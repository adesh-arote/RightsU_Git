CREATE TABLE [dbo].[Royalty_Recoupment] (
    [Royalty_Recoupment_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Royalty_Recoupment_Name] NVARCHAR (200) NULL,
    [Is_Active]               CHAR (1)       CONSTRAINT [DF_Royalty_Recoupment_Is_Active] DEFAULT ('Y') NULL,
    [Inserted_On]             DATETIME       NOT NULL,
    [Inserted_By]             INT            NOT NULL,
    [Lock_Time]               DATETIME       NULL,
    [Last_Updated_Time]       DATETIME       NULL,
    [Last_Action_By]          INT            NULL,
    CONSTRAINT [PK_Royalty_Recoupment] PRIMARY KEY CLUSTERED ([Royalty_Recoupment_Code] ASC)
);

