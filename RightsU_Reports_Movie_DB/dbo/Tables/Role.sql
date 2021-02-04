CREATE TABLE [dbo].[Role] (
    [Role_Code]         INT           IDENTITY (1, 1) NOT NULL,
    [Role_Name]         VARCHAR (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Role_Type]         CHAR (10)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Rate_Card]      CHAR (10)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Last_Action_By]    DATETIME      NULL,
    [Lock_Time]         DATETIME      NULL,
    [Last_Updated_Time] DATETIME      NULL,
    [Deal_Type_Code]    INT           NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([Role_Code] ASC)
);

