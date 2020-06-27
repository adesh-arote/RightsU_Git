CREATE TABLE [dbo].[Title_Promotion] (
    [Title_Promotion_Code] INT      IDENTITY (1, 1) NOT NULL,
    [External_Title_Code]  INT      NULL,
    [Effective_Start_Date] DATETIME NULL,
    [Effective_End_Date]   DATETIME NULL,
    [Is_Promotion]         CHAR (1) CONSTRAINT [DF_Title_Promotion_Is_Promotion] DEFAULT ('Y') NULL,
    [Inserted_On]          DATETIME NOT NULL,
    [Inserted_By]          INT      NOT NULL,
    [Lock_Time]            DATETIME NULL,
    [Last_Updated_Time]    DATETIME NULL,
    [Last_Action_By]       INT      NULL,
    CONSTRAINT [PK_Title_Promotion] PRIMARY KEY CLUSTERED ([Title_Promotion_Code] ASC)
);

