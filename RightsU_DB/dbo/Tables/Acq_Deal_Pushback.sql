CREATE TABLE [dbo].[Acq_Deal_Pushback] (
    [Acq_Deal_Pushback_Code]  INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]           INT             NULL,
    [Right_Type]              CHAR (1)        NULL,
    [Is_Tentative]            CHAR (1)        NULL,
    [Term]                    VARCHAR (12)    NULL,
    [Right_Start_Date]        DATETIME        NULL,
    [Right_End_Date]          DATETIME        NULL,
    [Milestone_Type_Code]     INT             NULL,
    [Milestone_No_Of_Unit]    INT             NULL,
    [Milestone_Unit_Type]     INT             NULL,
    [Is_Title_Language_Right] CHAR (1)        NULL,
    [Remarks]                 NVARCHAR (4000) NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    [Last_Updated_Time]       DATETIME        NULL,
    [Last_Action_By]          INT             NULL,
    CONSTRAINT [PK_Acq_Deal_Pushback_1] PRIMARY KEY CLUSTERED ([Acq_Deal_Pushback_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Pushback_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Milestone_Type] FOREIGN KEY ([Milestone_Type_Code]) REFERENCES [dbo].[Milestone_Type] ([Milestone_Type_Code])
);



