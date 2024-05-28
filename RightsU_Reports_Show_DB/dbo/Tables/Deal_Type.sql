CREATE TABLE [dbo].[Deal_Type] (
    [Deal_Type_Code]          INT           IDENTITY (1, 1) NOT NULL,
    [Deal_Type_Name]          VARCHAR (100) NULL,
    [Is_Default]              CHAR (1)      NULL,
    [Is_Grid_Required]        CHAR (1)      NULL,
    [Inserted_On]             DATETIME      NULL,
    [Inserted_By]             INT           NULL,
    [Lock_Time]               DATETIME      NULL,
    [Last_Updated_Time]       DATETIME      NULL,
    [Last_Action_By]          INT           NULL,
    [Is_Active]               CHAR (1)      NULL,
    [Is_Master_Deal]          CHAR (1)      NULL,
    [Parent_Code]             INT           NULL,
    [Deal_Or_Title]           VARCHAR (5)   NULL,
    [Deal_Title_Mapping_Code] INT           NULL,
    CONSTRAINT [PK_Deal_Type] PRIMARY KEY CLUSTERED ([Deal_Type_Code] ASC)
);



