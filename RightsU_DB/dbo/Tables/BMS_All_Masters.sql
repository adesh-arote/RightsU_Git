CREATE TABLE [dbo].[BMS_All_Masters] (
    [Order_Id]    INT           NOT NULL,
    [Module_Name] VARCHAR (100) NULL,
    [BaseAddress] VARCHAR (200) NULL,
    [Is_Active]   CHAR (1)      NULL,
    [Method_Type] CHAR (1)      NULL,
    [RequestUri]  VARCHAR (100) NULL,
    CONSTRAINT [PK_BV_All_Masters] PRIMARY KEY CLUSTERED ([Order_Id] ASC)
);

