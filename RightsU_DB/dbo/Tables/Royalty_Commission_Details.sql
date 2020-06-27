CREATE TABLE [dbo].[Royalty_Commission_Details] (
    [Royalty_Commission_Details_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Royalty_Commission_Code]         INT      NULL,
    [Commission_Type]                 CHAR (1) CONSTRAINT [DF_Royalty_Commission_Details_Commission_Type] DEFAULT ('C') NULL,
    [Commission_Type_Code]            INT      NULL,
    [Add_Subtract]                    CHAR (1) CONSTRAINT [DF_Royalty_Commission_Details_Add_Subtract] DEFAULT ('A') NULL,
    [Position]                        INT      NULL,
    CONSTRAINT [PK_Royalty_Commission_Details] PRIMARY KEY CLUSTERED ([Royalty_Commission_Details_Code] ASC),
    CONSTRAINT [FK_Royalty_Commission_Details_Royalty_Commission] FOREIGN KEY ([Royalty_Commission_Code]) REFERENCES [dbo].[Royalty_Commission] ([Royalty_Commission_Code])
);

