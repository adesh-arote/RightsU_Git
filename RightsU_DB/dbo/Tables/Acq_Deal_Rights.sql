CREATE TABLE [dbo].[Acq_Deal_Rights] (
    [Acq_Deal_Rights_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]           INT             NOT NULL,
    [Is_Exclusive]            CHAR (1)        NULL,
    [Is_Title_Language_Right] CHAR (1)        NULL,
    [Is_Sub_License]          CHAR (1)        NULL,
    [Sub_License_Code]        INT             NULL,
    [Is_Theatrical_Right]     CHAR (1)        NULL,
    [Right_Type]              CHAR (1)        NULL,
    [Is_Tentative]            CHAR (1)        NULL,
    [Term]                    VARCHAR (12)    NULL,
    [Right_Start_Date]        DATETIME        NULL,
    [Right_End_Date]          DATETIME        NULL,
    [Milestone_Type_Code]     INT             NULL,
    [Milestone_No_Of_Unit]    INT             NULL,
    [Milestone_Unit_Type]     INT             NULL,
    [Is_ROFR]                 CHAR (1)        NULL,
    [ROFR_Date]               DATETIME        NULL,
    [Restriction_Remarks]     NVARCHAR (4000) NULL,
    [Effective_Start_Date]    DATETIME        NULL,
    [Actual_Right_Start_Date] DATETIME        NULL,
    [Actual_Right_End_Date]   DATETIME        NULL,
    [ROFR_Code]               INT             NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    [Last_Updated_Time]       DATETIME        NULL,
    [Last_Action_By]          INT             NULL,
    [Is_Verified]             CHAR (1)        CONSTRAINT [DF_Acq_Deal_Rights_Is_Verified] DEFAULT ('Y') NULL,
    [Original_Right_Type]     CHAR (1)        NULL,
    [Promoter_Flag]           CHAR (1)        NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Code] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Rights_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Milestone_Type] FOREIGN KEY ([Milestone_Type_Code]) REFERENCES [dbo].[Milestone_Type] ([Milestone_Type_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_ROFR] FOREIGN KEY ([ROFR_Code]) REFERENCES [dbo].[ROFR] ([ROFR_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Sub_License] FOREIGN KEY ([Sub_License_Code]) REFERENCES [dbo].[Sub_License] ([Sub_License_Code])
);








GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_1]
    ON [dbo].[Acq_Deal_Rights]([Acq_Deal_Code] ASC);

