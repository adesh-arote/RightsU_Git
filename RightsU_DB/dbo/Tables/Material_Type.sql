CREATE TABLE [dbo].[Material_Type] (
    [Material_Type_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Material_Type_Name] NVARCHAR (100) NULL,
    [Inserted_On]        DATETIME       NULL,
    [Inserted_By]        INT            NULL,
    [Lock_Time]          DATETIME       NULL,
    [Last_Updated_Time]  DATETIME       NULL,
    [Last_Action_By]     INT            NULL,
    [Is_Active]          CHAR (1)       CONSTRAINT [DF_Material_Type_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Material_Type] PRIMARY KEY CLUSTERED ([Material_Type_Code] ASC)
);

