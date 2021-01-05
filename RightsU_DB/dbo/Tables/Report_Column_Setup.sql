CREATE TABLE [dbo].[Report_Column_Setup] (
    [Column_Code]           INT             IDENTITY (1, 1) NOT NULL,
    [View_Name]             VARCHAR (50)    NOT NULL,
    [Name_In_DB]            VARCHAR (1000)  NULL,
    [Display_Name]          NVARCHAR (50)   NULL,
    [Valued_As]             SMALLINT        NULL,
    [Display_Order]         INT             NULL,
    [IsPartofSelectOnly]    VARCHAR (1)     NULL,
    [List_Source]           VARCHAR (80)    NULL,
    [Lookup_Column]         NVARCHAR (50)   NULL,
    [Display_Column]        NVARCHAR (50)   NULL,
    [Right_Code]            INT             NULL,
    [Max_Length]            INT             NULL,
    [WhCondition]           NVARCHAR (1000) NULL,
    [ValidOpList]           VARCHAR (50)    NULL,
    [Alternate_Config_Code] INT             NULL,
    [Display_Type]          VARCHAR (5)     NULL,
    CONSTRAINT [PK_Report_Column_Setup] PRIMARY KEY CLUSTERED ([Column_Code] ASC)
);

