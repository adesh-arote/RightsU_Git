CREATE TABLE [dbo].[Syn_Deal_Run] (
    [Syn_Deal_Run_Code]      INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]          INT      NULL,
    [Title_Code]             INT      NULL,
    [Episode_From]           INT      NULL,
    [Episode_To]             INT      NULL,
    [Run_Type]               CHAR (1) NULL,
    [No_Of_Runs]             INT      NULL,
    [Is_Yearwise_Definition] CHAR (1) NULL,
    [Is_Rule_Right]          CHAR (1) NULL,
    [Repeat_Within_Days_Hrs] CHAR (1) NULL,
    [Right_Rule_Code]        INT      NULL,
    [No_Of_Days_Hrs]         INT      NULL,
    [Inserted_By]            INT      NULL,
    [Inserted_On]            DATETIME NULL,
    [Last_action_By]         INT      NULL,
    [Last_updated_Time]      DATETIME NULL,
    CONSTRAINT [PK_Syn_Deal_Run] PRIMARY KEY CLUSTERED ([Syn_Deal_Run_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Run_Right_Rule] FOREIGN KEY ([Right_Rule_Code]) REFERENCES [dbo].[Right_Rule] ([Right_Rule_Code]),
    CONSTRAINT [FK_Syn_Deal_Run_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code]),
    CONSTRAINT [FK_Syn_Deal_Run_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

