CREATE TABLE [dbo].[Royalty_Recoupment_Details] (
    [Royalty_Recoupment_Details_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Royalty_Recoupment_Code]         INT      NULL,
    [Recoupment_Type]                 CHAR (1) CONSTRAINT [DF_Table_1_Commission_Type] DEFAULT ('C') NULL,
    [Recoupment_Type_Code]            INT      NULL,
    [Add_Subtract]                    CHAR (1) CONSTRAINT [DF_Royalty_Recoupment_Details_Add_Subtract] DEFAULT ('A') NULL,
    [Position]                        INT      NULL,
    CONSTRAINT [PK_Royalty_Recoupment_Details] PRIMARY KEY CLUSTERED ([Royalty_Recoupment_Details_Code] ASC),
    CONSTRAINT [FK_Royalty_Recoupment_Details_Royalty_Recoupment] FOREIGN KEY ([Royalty_Recoupment_Code]) REFERENCES [dbo].[Royalty_Recoupment] ([Royalty_Recoupment_Code])
);

