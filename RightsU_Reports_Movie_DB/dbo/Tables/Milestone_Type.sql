CREATE TABLE [dbo].[Milestone_Type] (
    [Milestone_Type_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Milestone_Type_Name] VARCHAR (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Automated]        CHAR (1)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Active]           CHAR (1)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);



