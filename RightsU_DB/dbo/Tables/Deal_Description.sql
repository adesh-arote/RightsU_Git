CREATE TABLE [dbo].[Deal_Description] (
    [Deal_Desc_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Deal_Desc_Name] NVARCHAR (MAX) NULL,
    [Type]           CHAR (1)       NULL,
    [Is_Active]      CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([Deal_Desc_Code] ASC)
);

