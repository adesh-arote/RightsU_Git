CREATE TABLE [dbo].[Report_Column] (
    [Report_Column_Code] BIGINT        IDENTITY (1, 1) NOT NULL,
    [Query_Code]         INT           NOT NULL,
    [Column_Code]        INT           NULL,
    [Db_Value]           VARCHAR (300) NULL,
    [Is_Select]          CHAR (1)      NULL,
    [Display_Ord]        SMALLINT      NULL,
    [Sort_Type]          CHAR (1)      NULL,
    [Sort_Ord]           SMALLINT      NULL,
    [Agg_Function]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_Report_Column] PRIMARY KEY CLUSTERED ([Report_Column_Code] ASC)
);

