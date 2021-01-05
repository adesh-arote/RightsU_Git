CREATE TABLE [dbo].[MHNotificationLog] (
    [MHNotificationLogCode] INT            IDENTITY (1, 1) NOT NULL,
    [Email_Config_Code]     INT            NULL,
    [Created_Time]          DATETIME       NULL,
    [Is_Read]               CHAR (1)       NULL,
    [Email_Body]            NVARCHAR (MAX) NULL,
    [User_Code]             INT            NULL,
    [Vendor_Code]           INT            NULL,
    [Subject]               NVARCHAR (100) NULL,
    [Email_Id]              NVARCHAR (100) NULL,
    [MHRequestCode]         INT            NULL,
    [MHRequestTypeCode]     INT            NULL,
    PRIMARY KEY CLUSTERED ([MHNotificationLogCode] ASC)
);

