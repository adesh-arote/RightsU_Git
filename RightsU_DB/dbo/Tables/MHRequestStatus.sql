CREATE TABLE [dbo].[MHRequestStatus] (
    [MHRequestStatusCode] INT            NOT NULL,
    [RequestStatusName]   NVARCHAR (400) NULL,
    [ModuleCode]          INT            NULL,
    [IsActive]            CHAR (1)       NULL,
    CONSTRAINT [PK_MHRequestStatus] PRIMARY KEY CLUSTERED ([MHRequestStatusCode] ASC),
    CONSTRAINT [FK_MHRequestStatus_System_Module] FOREIGN KEY ([ModuleCode]) REFERENCES [dbo].[System_Module] ([Module_Code])
);

