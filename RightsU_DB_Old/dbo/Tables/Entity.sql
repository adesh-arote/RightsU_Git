CREATE TABLE [dbo].[Entity] (
    [Entity_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Entity_Name]       VARCHAR (100)  NOT NULL,
    [Inserted_On]       DATETIME       NOT NULL,
    [Inserted_By]       INT            NOT NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       NOT NULL,
    [Logo_Path]         VARCHAR (1000) NULL,
    [Logo_Name]         VARCHAR (200)  NULL,
    [ParentEntityCode]  INT            NULL,
    [Ref_Entity_Key]    INT            NULL,
    CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED ([Entity_Code] ASC)
);

