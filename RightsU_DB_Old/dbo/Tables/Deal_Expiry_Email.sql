CREATE TABLE [dbo].[Deal_Expiry_Email] (
    [Deal_Expiry_Email_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Mail_alert_days]        INT           NOT NULL,
    [Alert_Type]             VARCHAR (2)   NULL,
    [Users_Email_id]         VARCHAR (MAX) NOT NULL,
    [Allow_less_Than]        CHAR (1)      NOT NULL,
    [Is_Weekly]              CHAR (1)      NOT NULL,
    [Business_Unit_Code]     INT           NULL,
    [CC_Email_ID]            VARCHAR (MAX) NULL,
    [BCC_Email_ID]           VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Deal_Expiry_Email] PRIMARY KEY CLUSTERED ([Deal_Expiry_Email_Code] ASC)
);



