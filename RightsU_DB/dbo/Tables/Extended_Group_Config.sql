CREATE TABLE [dbo].[Extended_Group_Config] (
    [Extended_Group_Config_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Extended_Group_Code]        INT           NULL,
    [Columns_Code]               INT           NULL,
    [Group_Control_Order]        INT           NULL,
    [Validations]                VARCHAR (200) NULL,
    [Additional_Condition]       VARCHAR (MAX) NULL,
    [Inter_Group_Name]           VARCHAR (50)  NULL,
    [Display_Name]               VARCHAR (100) NULL,
    [Target_Table]               VARCHAR (100) NULL,
    [Target_Column]              VARCHAR (100) NULL,
    [Allow_Import]               CHAR (1)      NULL,
    [Is_Active]                  CHAR (1)      NULL,
    [Default_Value]              VARCHAR (500) NULL,
    CONSTRAINT [PK_Extended_Group_Config] PRIMARY KEY CLUSTERED ([Extended_Group_Config_Code] ASC),
    CONSTRAINT [FK_Extended_Group_Config_Extended_Columns] FOREIGN KEY ([Columns_Code]) REFERENCES [dbo].[Extended_Columns] ([Columns_Code]),
    CONSTRAINT [FK_Extended_Group_Config_Extended_Group] FOREIGN KEY ([Extended_Group_Code]) REFERENCES [dbo].[Extended_Group] ([Extended_Group_Code])
);

