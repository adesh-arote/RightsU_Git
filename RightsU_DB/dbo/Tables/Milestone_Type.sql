CREATE TABLE [dbo].[Milestone_Type] (
    [Milestone_Type_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Milestone_Type_Name] VARCHAR (100) NULL,
    [Is_Automated]        CHAR (1)      NULL,
    [Is_Active]           CHAR (1)      CONSTRAINT [DF_Milestone_Type_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Milestone_Type] PRIMARY KEY CLUSTERED ([Milestone_Type_Code] ASC)
);

