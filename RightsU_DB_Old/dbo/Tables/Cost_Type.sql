CREATE TABLE [dbo].[Cost_Type] (
    [Cost_Type_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [Cost_Type_Name]      NVARCHAR (100) NULL,
    [Inserted_On]         DATETIME       NOT NULL,
    [Inserted_By]         INT            NOT NULL,
    [Lock_Time]           DATETIME       NULL,
    [Last_Updated_Time]   DATETIME       NULL,
    [Last_Action_By]      INT            NULL,
    [Is_Active]           CHAR (1)       NOT NULL,
    [Is_System_Generated] CHAR (1)       CONSTRAINT [DF_Cost_Type_Is_System_Generated] DEFAULT ('N') NULL,
    CONSTRAINT [PK_Cost_Type] PRIMARY KEY CLUSTERED ([Cost_Type_Code] ASC)
);



