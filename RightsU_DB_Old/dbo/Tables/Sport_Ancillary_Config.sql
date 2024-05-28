CREATE TABLE [dbo].[Sport_Ancillary_Config] (
    [Sport_Ancillary_Config_Code]      INT      IDENTITY (1, 1) NOT NULL,
    [Flag]                             CHAR (1) NULL,
    [Sport_Ancillary_Type_Code]        INT      NULL,
    [Sport_Ancillary_Broadcast_Code]   INT      NULL,
    [Sport_Ancillary_Source_Code]      INT      NULL,
    [Sport_Ancillary_Periodicity_Code] INT      NULL,
    CONSTRAINT [PK_Sport_Ancillary_Config] PRIMARY KEY CLUSTERED ([Sport_Ancillary_Config_Code] ASC),
    CONSTRAINT [FK_Sport_Ancillary_Config_Sport_Ancillary_Broadcast] FOREIGN KEY ([Sport_Ancillary_Broadcast_Code]) REFERENCES [dbo].[Sport_Ancillary_Broadcast] ([Sport_Ancillary_Broadcast_Code]),
    CONSTRAINT [FK_Sport_Ancillary_Config_Sport_Ancillary_Periodicity] FOREIGN KEY ([Sport_Ancillary_Periodicity_Code]) REFERENCES [dbo].[Sport_Ancillary_Periodicity] ([Sport_Ancillary_Periodicity_Code]),
    CONSTRAINT [FK_Sport_Ancillary_Config_Sport_Ancillary_Source] FOREIGN KEY ([Sport_Ancillary_Source_Code]) REFERENCES [dbo].[Sport_Ancillary_Source] ([Sport_Ancillary_Source_Code]),
    CONSTRAINT [FK_Sport_Ancillary_Config_Sport_Ancillary_Type] FOREIGN KEY ([Sport_Ancillary_Type_Code]) REFERENCES [dbo].[Sport_Ancillary_Type] ([Sport_Ancillary_Type_Code])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P/M/F', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sport_Ancillary_Config', @level2type = N'COLUMN', @level2name = N'Flag';

