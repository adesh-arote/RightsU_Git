CREATE TABLE [dbo].[Sport_Ancillary_Type] (
    [Sport_Ancillary_Type_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                      VARCHAR (100) NULL,
    [Is_Active]                 CHAR (1)      NULL,
    CONSTRAINT [PK_Sport_Ancillary_Type] PRIMARY KEY CLUSTERED ([Sport_Ancillary_Type_Code] ASC)
);

