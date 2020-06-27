CREATE TABLE [dbo].[Payment_Terms] (
    [Payment_Terms_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Payment_Terms]      NVARCHAR (100) NULL,
    [Inserted_On]        DATETIME       NULL,
    [Inserted_By]        INT            NULL,
    [Lock_Time]          DATETIME       NULL,
    [Last_Updated_Time]  DATETIME       NULL,
    [Last_Action_By]     INT            NULL,
    [Is_Active]          CHAR (1)       CONSTRAINT [DF_Payment_Terms_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Payment_Terms] PRIMARY KEY CLUSTERED ([Payment_Terms_Code] ASC)
);



