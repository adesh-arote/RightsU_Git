CREATE TABLE [dbo].[Material_Medium] (
    [Material_Medium_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Material_Medium_Name] NVARCHAR (100) NULL,
    [Type]                 CHAR (2)       NULL,
    [Duration]             INT            NULL,
    [Is_Qc_Required]       CHAR (1)       NULL,
    [Inserted_On]          DATETIME       NULL,
    [Inserted_By]          INT            NULL,
    [Lock_Time]            DATETIME       NULL,
    [Last_Updated_Time]    DATETIME       NULL,
    [Last_Action_By]       INT            NULL,
    [Is_Active]            CHAR (1)       CONSTRAINT [DF_Material_Medium_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Material_Medium] PRIMARY KEY CLUSTERED ([Material_Medium_Code] ASC)
);



