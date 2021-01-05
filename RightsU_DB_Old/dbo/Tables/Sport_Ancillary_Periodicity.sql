CREATE TABLE [dbo].[Sport_Ancillary_Periodicity] (
    [Sport_Ancillary_Periodicity_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                             VARCHAR (100) NULL,
    [Is_Active]                        CHAR (1)      NULL,
    [Order_By]                         INT           NULL,
    CONSTRAINT [PK_Sport_Ancillary_Periodicity] PRIMARY KEY CLUSTERED ([Sport_Ancillary_Periodicity_Code] ASC)
);

