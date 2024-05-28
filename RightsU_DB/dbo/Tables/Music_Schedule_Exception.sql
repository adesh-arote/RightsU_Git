CREATE TABLE [dbo].[Music_Schedule_Exception] (
    [Music_Schedule_Exception_Code]   INT         IDENTITY (1, 1) NOT NULL,
    [Music_Schedule_Transaction_Code] INT         NULL,
    [Error_Code]                      INT         NULL,
    [Status]                          VARCHAR (2) NULL,
    [Is_Mail_Sent]                    CHAR (1)    NULL,
    CONSTRAINT [PK_Music_Schedule_Exception] PRIMARY KEY CLUSTERED ([Music_Schedule_Exception_Code] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'AR- AutoResolved', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Music_Schedule_Exception', @level2type = N'COLUMN', @level2name = N'Status';

