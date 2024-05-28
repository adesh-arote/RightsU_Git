CREATE TABLE [dbo].[AT_Music_Deal] (
    [AT_Music_Deal_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Agreement_No]          VARCHAR (50)    NULL,
    [Version]               VARCHAR (50)    NULL,
    [Agreement_Date]        DATETIME        NULL,
    [Description]           NVARCHAR (2000) NULL,
    [Deal_Tag_Code]         INT             NULL,
    [Reference_No]          NVARCHAR (200)  NULL,
    [Entity_Code]           INT             NULL,
    [Primary_Vendor_Code]   INT             NULL,
    [Music_Label_Code]      INT             NULL,
    [Title_Type]            CHAR (1)        NULL,
    [Duration_Restriction]  DECIMAL (18, 2) NULL,
    [Rights_Start_Date]     DATETIME        NULL,
    [Rights_End_Date]       DATETIME        NULL,
    [Term]                  VARCHAR (12)    NULL,
    [Run_Type]              CHAR (1)        NULL,
    [No_Of_Songs]           INT             NULL,
    [Channel_Type]          CHAR (1)        NULL,
    [Channel_Or_Category]   CHAR (1)        NULL,
    [Channel_Category_Code] INT             NULL,
    [Right_Rule_Code]       INT             NULL,
    [Link_Show_Type]        CHAR (2)        NULL,
    [Business_Unit_Code]    INT             NULL,
    [Deal_Type_Code]        INT             NULL,
    [Deal_Workflow_Status]  VARCHAR (5)     NULL,
    [Work_Flow_Code]        INT             NULL,
    [Parent_Deal_Code]      INT             NULL,
    [Inserted_By]           INT             NULL,
    [Inserted_On]           DATETIME        NULL,
    [Last_Updated_Time]     DATETIME        NULL,
    [Last_Action_By]        INT             NULL,
    [Lock_Time]             DATETIME        NULL,
    [Music_Deal_Code]       INT             NULL,
    [Remarks]               NVARCHAR (MAX)  NULL,
    [Agreement_Cost]        DECIMAL (38, 3) NULL,
    CONSTRAINT [PK_AT_Music_Deal] PRIMARY KEY CLUSTERED ([AT_Music_Deal_Code] ASC),
    CONSTRAINT [FK_AT_Music_Deal_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Channel_Category] FOREIGN KEY ([Channel_Category_Code]) REFERENCES [dbo].[Channel_Category] ([Channel_Category_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Deal_Tag] FOREIGN KEY ([Deal_Tag_Code]) REFERENCES [dbo].[Deal_Tag] ([Deal_Tag_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Deal_Type] FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Music_Label] FOREIGN KEY ([Music_Label_Code]) REFERENCES [dbo].[Music_Label] ([Music_Label_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Right_Rule] FOREIGN KEY ([Right_Rule_Code]) REFERENCES [dbo].[Right_Rule] ([Right_Rule_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Vendor] FOREIGN KEY ([Primary_Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'C = Channel, G = Category', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AT_Music_Deal', @level2type = N'COLUMN', @level2name = N'Channel_Or_Category';

