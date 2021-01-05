CREATE TABLE [dbo].[Platform] (
    [Platform_Code]                     INT            IDENTITY (1, 1) NOT NULL,
    [Platform_Name]                     VARCHAR (100)  NULL,
    [Is_No_Of_Run]                      CHAR (1)       NULL,
    [Applicable_For_Holdback]           CHAR (1)       NULL,
    [Applicable_For_Demestic_Territory] CHAR (1)       CONSTRAINT [DF_Platform_Demo_Applicable_For_Demestic_Territory_1] DEFAULT ('N') NULL,
    [Inserted_On]                       DATETIME       NULL,
    [Inserted_By]                       INT            NULL,
    [Lock_Time]                         DATETIME       NULL,
    [Last_Updated_Time]                 DATETIME       NULL,
    [Last_Action_By]                    INT            NULL,
    [Is_Active]                         CHAR (1)       CONSTRAINT [DF_Platform_Demo_Is_Active] DEFAULT ('Y') NULL,
    [Applicable_For_Asrun_Schedule]     CHAR (1)       NULL,
    [Parent_Platform_Code]              INT            NULL,
    [Is_Last_Level]                     CHAR (1)       NULL,
    [Module_Position]                   VARCHAR (10)   NULL,
    [Base_Platform_Code]                INT            NULL,
    [Platform_Hiearachy]                VARCHAR (2000) NULL,
    [Is_Sport_Right]                    CHAR (1)       NULL,
    [Is_Applicable_Syn_Run]             CHAR (1)       NULL,
    CONSTRAINT [PK_Platform_Demo] PRIMARY KEY CLUSTERED ([Platform_Code] ASC)
);

