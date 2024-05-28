CREATE TABLE [dbo].[Material_Receipt] (
    [Material_Receipt_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Material_Receipt_No]   VARCHAR (50)  NULL,
    [Received_On]           DATETIME      NULL,
    [Inserted_On]           DATETIME      NULL,
    [Inserted_By]           INT           NULL,
    [Lock_Time]             DATETIME      NULL,
    [Last_Updated_Time]     DATETIME      NULL,
    [Last_Action_By]        INT           NULL,
    [Remarks]               VARCHAR (500) NULL,
    CONSTRAINT [PK_Material_Receipt] PRIMARY KEY CLUSTERED ([Material_Receipt_Code] ASC)
);

