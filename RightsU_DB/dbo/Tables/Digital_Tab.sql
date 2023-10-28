CREATE TABLE [dbo].[Digital_Tab] (
    [Digital_Tab_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [Short_Name]              NVARCHAR (20)  NULL,
    [Digital_Tab_Description] NVARCHAR (100) NULL,
    [Order_No]                INT            NULL,
    [Tab_Type]                VARCHAR (2)    NULL,
    [EditWindowType]          VARCHAR (10)   NULL,
    [Module_Code]             INT            NULL,
    [Key_Config_Code]         INT            NULL,
    [Is_Show]                 CHAR (1)       NULL,
    CONSTRAINT [PK_Digital_Tab] PRIMARY KEY CLUSTERED ([Digital_Tab_Code] ASC)
);

