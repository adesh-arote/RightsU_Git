CREATE TABLE [dbo].[DM_Programming] (
    [IntCode]                    INT            NULL,
    [Deal_No]                    INT            NULL,
    [Title]                      VARCHAR (1000) NULL,
    [Type]                       VARCHAR (1000) NULL,
    [Obligation_to_Broadcast]    VARCHAR (1000) NULL,
    [No_Obligation_to_Broadcast] VARCHAR (1000) NULL,
    [When_to_Broadcast]          VARCHAR (1000) NULL,
    [Broadcast_Window]           VARCHAR (1000) NULL,
    [Broadcast_Window_unit]      VARCHAR (1000) NULL,
    [Periodicity]                VARCHAR (1000) NULL,
    [Duration]                   VARCHAR (1000) NULL,
    [Source_of_Content]          VARCHAR (1000) NULL,
    [Remarks]                    VARCHAR (MAX)  NULL
);

