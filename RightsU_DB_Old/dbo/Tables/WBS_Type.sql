CREATE TABLE [dbo].[WBS_Type] (
    [WBS_Type_Code]        INT          IDENTITY (1, 1) NOT NULL,
    [WBS_Type_Char]        CHAR (1)     NULL,
    [WBS_Type_Description] VARCHAR (50) NULL,
    [Deal_Type_Code]       INT          NULL,
    CONSTRAINT [PK_WBS_Type] PRIMARY KEY CLUSTERED ([WBS_Type_Code] ASC)
);

