CREATE TABLE [dbo].[IT_FilterSequence] (
    [ITFilterSequenceCode] INT          NOT NULL,
    [BVAttribGroupCode]    INT          NULL,
    [Column_Code]          INT          NULL,
    [Column_Code_Seq]      INT          NULL,
    [Display_Order]        INT          NULL,
    [IsMandatory]          CHAR (2)     NULL,
    [IsSkip]               CHAR (2)     NULL,
    [IsSkipAll]            CHAR (2)     NULL,
    [Type]                 VARCHAR (10) NULL
);

