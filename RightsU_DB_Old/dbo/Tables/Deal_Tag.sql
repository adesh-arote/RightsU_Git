CREATE TABLE [dbo].[Deal_Tag] (
    [Deal_Tag_Code]        INT           IDENTITY (1, 1) NOT NULL,
    [Deal_Tag_Description] VARCHAR (100) NULL,
    CONSTRAINT [PK_Deal_Tag] PRIMARY KEY CLUSTERED ([Deal_Tag_Code] ASC)
);

