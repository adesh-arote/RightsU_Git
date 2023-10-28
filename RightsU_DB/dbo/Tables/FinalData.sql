CREATE TABLE [dbo].[FinalData] (
    [id]                            INT            IDENTITY (1, 1) NOT NULL,
    [title_name]                    VARCHAR (500)  NULL,
    [Supplementary_Tab_Code]        INT            NULL,
    [Supplementary_Tab_Description] VARCHAR (500)  NULL,
    [Remarks]                       VARCHAR (5000) NULL,
    [Title_Code]                    INT            NULL,
    [Acq_Deal_Supplementary_Code]   INT            NULL
);

