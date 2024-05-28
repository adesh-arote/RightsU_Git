CREATE TABLE [dbo].[Import_Status] (
    [Import_Status_Code] INT           NOT NULL,
    [Status_Short_Code]  VARCHAR (50)  NULL,
    [Status_Desc]        VARCHAR (240) NULL,
    [Is_Mandatory]       INT           NULL,
    CONSTRAINT [PK_Import_Status] PRIMARY KEY CLUSTERED ([Import_Status_Code] ASC)
);

