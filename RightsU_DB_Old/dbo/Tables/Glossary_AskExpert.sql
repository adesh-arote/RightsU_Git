CREATE TABLE [dbo].[Glossary_AskExpert] (
    [Glossary_AskExpert_Code] INT            IDENTITY (1, 1) NOT NULL,
    [User_Code]               INT            NULL,
    [Subject]                 VARCHAR (50)   NULL,
    [Question]                VARCHAR (4000) NULL,
    [Is_Mail_Sent]            CHAR (1)       NULL,
    [Inserted_On]             DATETIME       NULL,
    CONSTRAINT [PK_Glossary_AskExpert] PRIMARY KEY CLUSTERED ([Glossary_AskExpert_Code] ASC),
    CONSTRAINT [FK_Glossary_AskExpert_Users] FOREIGN KEY ([User_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

