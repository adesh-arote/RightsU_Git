CREATE TABLE [dbo].[MHRequestType] (
    [MHRequestTypeCode] INT            NOT NULL,
    [RequestTypeName]   NVARCHAR (400) NULL,
    [IsActive]          CHAR (1)       NULL,
    CONSTRAINT [PK_MHRequestType] PRIMARY KEY CLUSTERED ([MHRequestTypeCode] ASC)
);

