CREATE TABLE [dbo].[Sport_Ancillary_Source] (
    [Sport_Ancillary_Source_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                        VARCHAR (100) NULL,
    [Is_Active]                   CHAR (1)      NULL,
    CONSTRAINT [PK_Sport_Ancillary_Source] PRIMARY KEY CLUSTERED ([Sport_Ancillary_Source_Code] ASC)
);

