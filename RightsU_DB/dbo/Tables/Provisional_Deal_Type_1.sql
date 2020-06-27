CREATE TABLE [dbo].[Provisional_Deal_Type] (
    [Provisional_Deal_Type_Code] INT          IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Type_Name] VARCHAR (50) NULL,
    [Is_Active]                  CHAR (1)     NULL,
    CONSTRAINT [PK_Provisional_Deal_Type] PRIMARY KEY CLUSTERED ([Provisional_Deal_Type_Code] ASC)
);

