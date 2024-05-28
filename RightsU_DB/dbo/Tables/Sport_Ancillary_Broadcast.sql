CREATE TABLE [dbo].[Sport_Ancillary_Broadcast] (
    [Sport_Ancillary_Broadcast_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                           VARCHAR (100) NULL,
    [Is_Active]                      CHAR (1)      NULL,
    CONSTRAINT [PK_Sport_Ancillary_Broadcast] PRIMARY KEY CLUSTERED ([Sport_Ancillary_Broadcast_Code] ASC)
);

