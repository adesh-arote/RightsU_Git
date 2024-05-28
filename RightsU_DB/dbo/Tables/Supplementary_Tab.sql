CREATE TABLE [dbo].[Supplementary_Tab] (
    [Supplementary_Tab_Code]        INT            NOT NULL,
    [Short_Name]                    NVARCHAR (20)  NULL,
    [Supplementary_Tab_Description] NVARCHAR (100) NULL,
    [Order_No]                      INT            NULL,
    [Tab_Type]                      VARCHAR (2)    NULL,
    [EditWindowType]                VARCHAR (10)   NULL,
    [Module_Code]                   INT            NULL,
    [Key_Config_Code]               INT            NULL,
    [Is_Show]                       CHAR (1)       NULL,
    CONSTRAINT [PK_Supplementary_Tab] PRIMARY KEY CLUSTERED ([Supplementary_Tab_Code] ASC)
);

