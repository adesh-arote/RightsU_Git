CREATE TABLE [dbo].[Digital_Config] (
    [Digital_Config_Code]          INT             IDENTITY (1, 1) NOT NULL,
    [Digital_Code]                 INT             NULL,
    [Digital_Tab_Code]             INT             NULL,
    [Page_Group]                   NVARCHAR (50)   NULL,
    [Label_Name]                   NVARCHAR (200)  NULL,
    [Control_Type]                 NVARCHAR (50)   NULL,
    [Is_Mandatory]                 CHAR (1)        NULL,
    [Is_Multiselect]               CHAR (1)        NULL,
    [Max_Length]                   INT             NULL,
    [Page_Control_Order]           INT             NULL,
    [Control_Field_Order]          INT             NULL,
    [Default_Values]               NVARCHAR (1000) NULL,
    [View_Name]                    VARCHAR (100)   NULL,
    [Text_Field]                   VARCHAR (100)   NULL,
    [Value_Field]                  VARCHAR (100)   NULL,
    [Whr_Criteria]                 VARCHAR (100)   NULL,
    [LP_Digital_Data_Code]         VARCHAR (1000)  NULL,
    [LP_Digital_Value_Config_Code] VARCHAR (1000)  NULL,
    CONSTRAINT [PK_Digital_Config] PRIMARY KEY CLUSTERED ([Digital_Config_Code] ASC),
    CONSTRAINT [FK_Digital_Config_Digital] FOREIGN KEY ([Digital_Code]) REFERENCES [dbo].[Digital] ([Digital_Code]),
    CONSTRAINT [FK_Digital_Config_Digital_Tab] FOREIGN KEY ([Digital_Tab_Code]) REFERENCES [dbo].[Digital_Tab] ([Digital_Tab_Code])
);

