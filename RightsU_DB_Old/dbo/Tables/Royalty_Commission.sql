CREATE TABLE [dbo].[Royalty_Commission] (
    [Royalty_Commission_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Royalty_Commission_Name] VARCHAR (200) NULL,
    [Is_Active]               CHAR (1)      CONSTRAINT [DF_Royalty_Commission_Is_Active] DEFAULT ('Y') NULL,
    [Inserted_On]             DATETIME      NOT NULL,
    [Inserted_By]             INT           NOT NULL,
    [Lock_Time]               DATETIME      NULL,
    [Last_Updated_Time]       DATETIME      NULL,
    [Last_Action_By]          INT           NULL,
    CONSTRAINT [PK_Royalty_Commission] PRIMARY KEY CLUSTERED ([Royalty_Commission_Code] ASC)
);

