CREATE TABLE [dbo].[Attrib_Report_Column] (
    [Attrib_Report_Column_Code] INT           NOT NULL,
    [DP_Attrib_Group_Code]      INT           NULL,
    [BV_Attrib_Group_Code]      INT           NULL,
    [Column_Code]               INT           NULL,
    [Control_Type]              INT           NULL,
    [Display_Order]             INT           NULL,
    [Output_Group]              INT           NULL,
    [Is_Mandatory]              CHAR (1)      NULL,
    [Icon]                      VARCHAR (100) NULL,
    [Css_Class]                 VARCHAR (50)  NULL,
    [Type]                      VARCHAR (50)  NULL,
    CONSTRAINT [PK_Attrib_Report_Column] PRIMARY KEY CLUSTERED ([Attrib_Report_Column_Code] ASC),
    CONSTRAINT [FK_Attrib_Report_Column_Attrib_Group] FOREIGN KEY ([DP_Attrib_Group_Code]) REFERENCES [dbo].[Attrib_Group] ([Attrib_Group_Code]),
    CONSTRAINT [FK_Attrib_Report_Column_Attrib_Group1] FOREIGN KEY ([BV_Attrib_Group_Code]) REFERENCES [dbo].[Attrib_Group] ([Attrib_Group_Code]),
    CONSTRAINT [FK_Attrib_Report_Column_Report_Column_Setup] FOREIGN KEY ([Column_Code]) REFERENCES [dbo].[Report_Column_Setup_IT] ([Column_Code])
);

