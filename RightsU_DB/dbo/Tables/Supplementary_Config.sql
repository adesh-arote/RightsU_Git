CREATE TABLE [dbo].[Supplementary_Config] (
    [Supplementary_Config_Code]          INT             IDENTITY (1, 1) NOT NULL,
    [Supplementary_Code]                 INT             NULL,
    [Supplementary_Tab_Code]             INT             NULL,
    [Page_Group]                         NVARCHAR (50)   NULL,
    [Label_Name]                         NVARCHAR (200)  NULL,
    [Control_Type]                       NVARCHAR (50)   NULL,
    [Is_Mandatory]                       CHAR (1)        NULL,
    [Is_Multiselect]                     CHAR (1)        NULL,
    [Max_Length]                         INT             NULL,
    [Page_Control_Order]                 INT             NULL,
    [Control_Field_Order]                INT             NULL,
    [Default_Values]                     NVARCHAR (1000) NULL,
    [View_Name]                          VARCHAR (100)   NULL,
    [Text_Field]                         VARCHAR (100)   NULL,
    [Value_Field]                        VARCHAR (100)   NULL,
    [Whr_Criteria]                       VARCHAR (100)   NULL,
    [LP_Supplementary_Data_Code]         VARCHAR (1000)  NULL,
    [LP_Supplementary_Value_Config_Code] VARCHAR (1000)  NULL,
    CONSTRAINT [PK_Supplementary_Config] PRIMARY KEY CLUSTERED ([Supplementary_Config_Code] ASC),
    CONSTRAINT [FK_Supplementary_Config_Supplementary] FOREIGN KEY ([Supplementary_Code]) REFERENCES [dbo].[Supplementary] ([Supplementary_Code]),
    CONSTRAINT [FK_Supplementary_Config_Supplementary_Tab] FOREIGN KEY ([Supplementary_Tab_Code]) REFERENCES [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code])
);

