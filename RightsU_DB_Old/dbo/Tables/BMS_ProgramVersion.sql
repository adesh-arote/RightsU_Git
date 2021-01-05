CREATE TABLE [dbo].[BMS_ProgramVersion] (
    [BMS_ProgramVersion_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [AssetId]                    INT            NULL,
    [VersionTypeId]              INT            NULL,
    [MediaTypeId]                INT            NULL,
    [Duration]                   TIME (7)       NULL,
    [Description]                VARCHAR (80)   NULL,
    [Tapes]                      VARCHAR (40)   NULL,
    [IsLive]                     VARCHAR (5)    NULL,
    [CreatedDateTime]            DATETIME       NULL,
    [CreatedUserId]              VARCHAR (20)   NULL,
    [UpdateDateTime]             DATETIME       NULL,
    [UpdateUserId]               VARCHAR (20)   NULL,
    [IsArchived]                 VARCHAR (5)    NULL,
    [BMS_ProgramVersion_Ref_Key] INT            NULL,
    [Record_Status]              CHAR (1)       NULL,
    [Request_Time]               DATETIME       NULL,
    [Response_Time]              DATETIME       NULL,
    [Error_Description]          VARCHAR (4000) NULL,
    CONSTRAINT [PK_BMS_ProgramVersion] PRIMARY KEY CLUSTERED ([BMS_ProgramVersion_Code] ASC)
);

