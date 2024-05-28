CREATE TABLE [dbo].[Amort_Rule] (
    [Amort_Rule_Code]   INT            IDENTITY (1, 1) NOT NULL,
    [Rule_Type]         CHAR (1)       NULL,
    [Rule_No]           NVARCHAR (100) NULL,
    [Rule_Desc]         NVARCHAR (500) NULL,
    [Distribution_Type] CHAR (1)       NULL,
    [Period_For]        CHAR (1)       NULL,
    [Year_Type]         CHAR (1)       NULL,
    [Nos]               INT            NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       CONSTRAINT [DF_Amort_Rule_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Amort_Rule] PRIMARY KEY CLUSTERED ([Amort_Rule_Code] ASC)
);



