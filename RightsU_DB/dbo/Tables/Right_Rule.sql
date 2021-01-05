CREATE TABLE [dbo].[Right_Rule] (
    [Right_Rule_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [Right_Rule_Name]    NVARCHAR (100) NULL,
    [Start_Time]         VARCHAR (50)   NULL,
    [Play_Per_Day]       INT            NULL,
    [Duration_Of_Day]    INT            NULL,
    [No_Of_Repeat]       INT            NULL,
    [Inserted_On]        DATETIME       NOT NULL,
    [Inserted_By]        INT            NOT NULL,
    [Lock_Time]          DATETIME       NULL,
    [Last_Updated_Time]  DATETIME       NULL,
    [Last_Action_By]     INT            NULL,
    [Is_Active]          CHAR (1)       NOT NULL,
    [IS_First_Air]       BIT            NULL,
    [Ref_Right_Rule_Key] INT            NULL,
    [Short_Key]          NVARCHAR (20)  NULL,
    [Record_Status]      CHAR (1)       DEFAULT ('P') NULL,
    [Error_Description]  VARCHAR (MAX)  NULL,
    [Request_Time]       DATETIME       NULL,
    [Response_Time]      DATETIME       NULL,
    CONSTRAINT [PK_Right_Rule] PRIMARY KEY CLUSTERED ([Right_Rule_Code] ASC)
);

