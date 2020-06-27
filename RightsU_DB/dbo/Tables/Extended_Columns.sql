CREATE TABLE [dbo].[Extended_Columns] (
    [Columns_Code]         INT            IDENTITY (1, 1) NOT NULL,
    [Columns_Name]         VARCHAR (100)  NULL,
    [Control_Type]         VARCHAR (5)    NULL,
    [Is_Ref]               CHAR (1)       NULL,
    [Is_Defined_Values]    CHAR (1)       NULL,
    [Is_Multiple_Select]   CHAR (1)       NULL,
    [Ref_Table]            VARCHAR (100)  NULL,
    [Ref_Display_Field]    VARCHAR (100)  NULL,
    [Ref_Value_Field]      VARCHAR (100)  NULL,
    [Additional_Condition] VARCHAR (1000) NULL,
    CONSTRAINT [PK_Extended_Columns] PRIMARY KEY CLUSTERED ([Columns_Code] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TextBox = TXT, Radio Button = RB, check Box = CHK, Drop Down List = DDL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Extended_Columns', @level2type = N'COLUMN', @level2name = N'Control_Type';

